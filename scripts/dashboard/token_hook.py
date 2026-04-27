"""Q2 — JSONL 트랜스크립트 직접 파싱으로 토큰 추출.

pane → claude PID (pgrep) → 프로세스 시작 시간 → JSONL 파일 매핑.
각 응답마다 JSONL에 assistant.message.usage가 기록되므로 실시간 추적 가능.

2순위 폴백: Stop hook이 저장한 dashboard_state JSON (세션 종료 시점 누적값).
"""
from __future__ import annotations

import hashlib
import json
import subprocess
import time
from datetime import datetime
from pathlib import Path
from typing import Dict, Optional

from .tmux_adapter import TmuxAdapter

# Claude Code JSONL 트랜스크립트 위치 패턴
_TRANSCRIPT_DIR_TPL = str(Path.home() / ".claude/projects" / "{proj_hash}")

# JSONL 시간 매핑 허용 오차 (초)
_JSONL_TIME_TOLERANCE_SEC = 600


class TokenHook:
    """pane → JSONL 트랜스크립트 직접 파싱으로 tokens_k 반환.

    pane_name: "{session}:{window}.{pane}" (예: Orc-064-plan:1.1)

    우선순위:
      1. JSONL 파싱 — pane → claude PID → 시작 시간 → JSONL
      2. dashboard_state JSON — Stop hook 저장 파일
      3. 0.0 폴백
    """

    HOOK_DIR_NAME = ".claude/dashboard_state"

    def __init__(
        self,
        tmux: Optional[TmuxAdapter] = None,
        project_root: Optional[Path] = None,
    ) -> None:
        self.tmux = tmux or TmuxAdapter()
        self._project_root = (project_root or Path.cwd()).resolve()
        self._hook_dir = self._project_root / self.HOOK_DIR_NAME
        self._project_hash = hashlib.sha1(
            str(self._project_root).encode("utf-8")
        ).hexdigest()[:8]
        # transcript 디렉토리 — project root → Claude 정규화 경로
        # Claude Code: '/' → '-', '_' → '-', leading '-' 유지
        _slug = str(self._project_root).replace("/", "-").replace("_", "-")
        self._transcript_dir = Path.home() / ".claude/projects" / _slug

        # 캐시: pane_name → (jsonl_path, cached_at)
        self._jsonl_cache: Dict[str, tuple] = {}
        self._cache_ttl = 15.0  # 15초마다 PID/파일 재검색

    # ------------------------------------------------------------------
    # 공개 API
    # ------------------------------------------------------------------

    def get_tokens_k(
        self,
        pane_name: str,
        prefetched_lines: Optional[list] = None,  # 호환성 유지 (미사용)
    ) -> float:
        """tokens_k 반환. 1순위 JSONL / 2순위 hook JSON / 3순위 0.0."""
        jsonl_value = self._read_jsonl(pane_name)
        if jsonl_value is not None:
            return jsonl_value
        session = pane_name.split(":")[0] if ":" in pane_name else pane_name
        hook_value = self._read_hook(session)
        return hook_value if hook_value is not None else 0.0

    # ------------------------------------------------------------------
    # 1순위 — JSONL 파싱
    # ------------------------------------------------------------------

    def _read_jsonl(self, pane_name: str) -> Optional[float]:
        jsonl_path = self._resolve_jsonl(pane_name)
        if jsonl_path is None:
            return None
        return self._parse_usage(jsonl_path)

    def _resolve_jsonl(self, pane_name: str) -> Optional[Path]:
        """캐시된 JSONL 경로 반환. TTL 초과 시 재검색.

        1순위: customTitle 기반 (claude --name pane_name 으로 시작한 경우).
        2순위: PID 시작 시간 기반 폴백.
        """
        now = time.monotonic()
        cached = self._jsonl_cache.get(pane_name)
        if cached and (now - cached[1]) < self._cache_ttl:
            return cached[0]

        jsonl = self._find_jsonl_by_title(pane_name)
        if jsonl is None:
            cpid = self._claude_pid_for_pane(pane_name)
            if cpid:
                start_epoch = self._pid_start_epoch(cpid)
                if start_epoch is not None:
                    jsonl = self._match_jsonl_by_time(start_epoch)

        self._jsonl_cache[pane_name] = (jsonl, now)
        return jsonl

    def _find_jsonl_by_title(self, pane_name: str) -> Optional[Path]:
        """JSONL 파일의 customTitle == pane_name 매칭.

        ``claude --name pane_name``으로 시작한 세션은 JSONL 첫 엔트리에
        ``{"type":"custom-title","customTitle":"pane_name"}``이 기록됨.
        최신 파일부터 검색하여 가장 최근 매칭 반환.
        """
        if not self._transcript_dir.exists():
            return None
        try:
            candidates = sorted(
                self._transcript_dir.glob("*.jsonl"),
                key=lambda p: p.stat().st_mtime,
                reverse=True,
            )[:50]
        except Exception:
            return None
        for f in candidates:
            try:
                for i, line in enumerate(f.open(encoding="utf-8")):
                    if i >= 4:
                        break
                    d = json.loads(line)
                    if d.get("customTitle") == pane_name or d.get("agentName") == pane_name:
                        return f
            except (json.JSONDecodeError, OSError):
                continue
        return None

    def _claude_pid_for_pane(self, pane_name: str) -> Optional[str]:
        """tmux pane → pane PID → 자식 claude PID.

        list-panes는 window 전체를 반환하므로 display-message로 특정 pane PID 획득.
        """
        try:
            r = subprocess.run(
                ["tmux", "display-message", "-t", pane_name, "-p", "#{pane_pid}"],
                capture_output=True, text=True, timeout=2,
            )
            pane_pid = r.stdout.strip() or None
        except Exception:
            return None
        if not pane_pid:
            return None
        try:
            r2 = subprocess.run(
                ["pgrep", "-P", pane_pid],
                capture_output=True, text=True, timeout=2,
            )
            for cpid in r2.stdout.strip().split():
                comm = subprocess.run(
                    ["ps", "-p", cpid, "-o", "comm="],
                    capture_output=True, text=True, timeout=2,
                ).stdout.strip()
                if "claude" in comm:
                    return cpid
        except Exception:
            pass
        return None

    def _pid_start_epoch(self, pid: str) -> Optional[float]:
        """프로세스 시작 시간 → epoch (float)."""
        try:
            r = subprocess.run(
                ["ps", "-p", pid, "-o", "lstart="],
                capture_output=True, text=True, timeout=2,
            )
            lstart = r.stdout.strip()
            if not lstart:
                return None
            return datetime.strptime(lstart, "%a %b %d %H:%M:%S %Y").timestamp()
        except Exception:
            return None

    def _match_jsonl_by_time(self, start_epoch: float) -> Optional[Path]:
        """claude 시작 시간과 가장 가까운 JSONL 파일 (허용 오차 내)."""
        if not self._transcript_dir.exists():
            return None
        best: Optional[Path] = None
        best_diff = float("inf")
        try:
            for f in self._transcript_dir.glob("*.jsonl"):
                diff = abs(f.stat().st_mtime - start_epoch)
                if diff < best_diff and diff < _JSONL_TIME_TOLERANCE_SEC:
                    best, best_diff = f, diff
        except Exception:
            pass
        return best

    def get_pane_state(self, pane_name: str) -> dict:
        """pane_name → {status, task, tokens_k, last_update}.

        터미널 상태 무관 — JSONL 파일 직접 읽기.
        status: 'working' | 'idle'
          - JSONL 마지막 엔트리 type==user  → working (Claude 응답 생성 중)
          - JSONL 마지막 엔트리 type==assistant → idle (응답 완료)
        task: 마지막 user str-content 메시지 첫 80자 (dispatch 프롬프트).
        tokens_k: 마지막 assistant.message.usage 기준 컨텍스트 창 크기.
        last_update: 마지막 assistant 타임스탬프 (없으면 파일 mtime).
        """
        jsonl_path = self._resolve_jsonl(pane_name)
        if jsonl_path is None:
            return {"status": "idle", "task": None, "tokens_k": 0.0, "last_update": None}
        return self._parse_state(jsonl_path)

    def _parse_state(self, jsonl_path: Path) -> dict:
        """JSONL 전체 스캔 → state dict."""
        last_type: Optional[str] = None
        last_task: Optional[str] = None       # 마지막 user str-content
        last_usage: Optional[dict] = None     # 마지막 assistant usage
        last_asst_ts: Optional[datetime] = None

        try:
            for line in jsonl_path.open(encoding="utf-8"):
                try:
                    d = json.loads(line)
                except json.JSONDecodeError:
                    continue
                entry_type = d.get("type")
                if entry_type == "user":
                    content = (d.get("message") or {}).get("content", "")
                    # XML 태그로 시작하는 str = 슬래시 커맨드 내부 시스템 메시지
                    # (/exit, /clear 등). 상태 판단에서 제외.
                    if isinstance(content, str) and content.strip().startswith("<"):
                        continue
                    last_type = "user"
                    if isinstance(content, str) and content.strip():
                        last_task = content.strip()[:80]
                elif entry_type == "assistant":
                    last_type = "assistant"
                    msg = d.get("message")
                    if isinstance(msg, dict):
                        u = msg.get("usage")
                        if isinstance(u, dict):
                            last_usage = u
                        ts = d.get("timestamp", "")
                        if ts:
                            try:
                                last_asst_ts = datetime.fromisoformat(ts)
                            except ValueError:
                                pass
        except OSError:
            pass

        status = "working" if last_type == "user" else "idle"

        tokens_k = 0.0
        if last_usage:
            total = (
                int(last_usage.get("input_tokens", 0))
                + int(last_usage.get("cache_read_input_tokens", 0))
                + int(last_usage.get("cache_creation_input_tokens", 0))
            )
            tokens_k = total / 1000.0

        last_update = last_asst_ts or datetime.fromtimestamp(jsonl_path.stat().st_mtime)

        return {
            "status": status,
            "task": last_task if status == "working" else None,
            "tokens_k": tokens_k,
            "last_update": last_update,
        }

    def _parse_usage(self, jsonl_path: Path) -> Optional[float]:
        """JSONL에서 가장 최근 assistant.message.usage → tokens_k."""
        state = self._parse_state(jsonl_path)
        return state["tokens_k"] if state["tokens_k"] > 0 else None

    # ------------------------------------------------------------------
    # 2순위 — Stop hook JSON (세션 종료 시 저장)
    # ------------------------------------------------------------------

    def _read_hook(self, session: str) -> Optional[float]:
        f = self._hook_dir / f"joneflow_{self._project_hash}_{session}.json"
        if not f.is_file():
            return None
        try:
            data = json.loads(f.read_text(encoding="utf-8"))
            input_tokens = int(data.get("input_tokens", 0))
            output_tokens = int(data.get("output_tokens", 0))
        except (json.JSONDecodeError, OSError, ValueError, TypeError):
            return None
        return (input_tokens + output_tokens) / 1000.0
