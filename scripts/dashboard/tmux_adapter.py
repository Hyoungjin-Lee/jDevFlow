"""tmux + git subprocess 격리 layer — 모듈 경계 #4 (design_final Sec.4.2).

``subprocess`` 직접 import는 본 모듈 + ``notifier.py`` 2건만 허용 (R-5 정정 = AC-T-4 = 2).
``token_hook.py`` / ``pending_collector.py``는 본 어댑터(TmuxAdapter / GitAdapter) 위임으로
subprocess 직접 호출 0건. Stage 10 M-1 fix — pending_collector ``_git_run`` → ``GitAdapter`` 위임.

sync 인터페이스 전면 (F-D4 Threaded sync wrapper). textual ``run_worker(thread=True)``
워커 thread에서 1초 주기 호출됩니다 — 메인 thread blocking 없음.

Stage 10 M-2 fix — ``capture_panes_batch`` 1회 subprocess로 N pane 일괄 capture
(``display-message`` 구분자 + tmux command chaining). 18~33 spawn/sec → 2 spawn/sec.
"""
from __future__ import annotations

import hashlib
import subprocess
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple


# M-2 batch capture 구분자. tmux ``display-message -p`` stdout 출력으로 pane 사이 경계 표시.
_BATCH_DELIM = "<<<JONEFLOW_PANE_DELIM>>>"


class TmuxAdapter:
    """tmux 세션 / pane sync 어댑터. 미가동 / 미설치 시 빈 list 폴백 (Q5 idle 통합)."""

    DEFAULT_TIMEOUT_SEC = 3.0

    def __init__(self, timeout_sec: float = DEFAULT_TIMEOUT_SEC) -> None:
        self.timeout_sec = timeout_sec
        # pane signature → 마지막 변화 시각 캐시 (R-1 staleness 정합).
        self._pane_change_cache: Dict[str, Tuple[str, datetime]] = {}

    def list_sessions(self) -> List[str]:
        """``tmux list-sessions -F '#{session_name}'`` → 세션명 list.

        tmux 미설치(``FileNotFoundError``) / 세션 0개(``returncode != 0``) / timeout
        모두 빈 list 반환 — Q5 idle 통합 폴백 정합.
        """
        result = self._run(["tmux", "list-sessions", "-F", "#{session_name}"])
        if result is None:
            return []
        return [line.strip() for line in result.splitlines() if line.strip()]

    def list_panes(self, session: str) -> List[str]:
        """``<session>:<window>.<pane>`` 형식 pane id list. 실패 시 빈 list."""
        result = self._run([
            "tmux", "list-panes", "-t", session, "-a",
            "-F", "#{session_name}:#{window_index}.#{pane_index}",
        ])
        if result is None:
            return []
        return [line.strip() for line in result.splitlines() if line.strip()]

    def capture_pane(self, pane: str, lines: int = 50) -> List[str]:
        """``tmux capture-pane -p -S -<lines>`` → 마지막 N줄 list.

        부수효과: pane signature 변화 감지 → ``last_pane_change`` 캐시 갱신
        (idle 임계 판정용, design_final Sec.7.4 t=10초 정합).
        """
        result = self._run(
            ["tmux", "capture-pane", "-t", pane, "-p", "-S", f"-{int(lines)}"]
        )
        if result is None:
            return []
        captured = result.splitlines()
        self._update_change_cache(pane, captured)
        return captured

    def capture_panes_batch(
        self, panes: List[str], lines: int = 50
    ) -> Dict[str, List[str]]:
        """N개 pane을 ``tmux`` 1회 호출(command chaining)로 일괄 capture (M-2 fix).

        ``display-message -p '<DELIM><pane><DELIM>'`` + ``capture-pane -p`` 반복을
        ``;`` separator로 연결. 결과 stdout을 구분자로 split.

        - 미가동 / 실패: 입력 pane 모두 빈 list 매핑 dict.
        - 부수효과: 각 pane별 ``last_pane_change`` 캐시 갱신 (capture_pane 동등).
        - 호출 비용: 18 pane = 1 subprocess.run / sec (기존 18~33 → ≤ 2).
        """
        if not panes:
            return {}
        argv: List[str] = ["tmux"]
        for i, pane in enumerate(panes):
            if i > 0:
                argv.append(";")
            argv.extend(
                ["display-message", "-p", f"{_BATCH_DELIM}{pane}{_BATCH_DELIM}"]
            )
            argv.append(";")
            argv.extend(
                ["capture-pane", "-t", pane, "-p", "-S", f"-{int(lines)}"]
            )
        raw = self._run(argv)
        out: Dict[str, List[str]] = {p: [] for p in panes}
        if raw is None:
            return out
        current: Optional[str] = None
        buffer: List[str] = []
        for line in raw.splitlines():
            if (
                line.startswith(_BATCH_DELIM)
                and line.endswith(_BATCH_DELIM)
                and len(line) > 2 * len(_BATCH_DELIM)
            ):
                if current is not None and current in out:
                    out[current] = buffer
                    self._update_change_cache(current, buffer)
                current = line[len(_BATCH_DELIM):-len(_BATCH_DELIM)]
                buffer = []
            else:
                buffer.append(line)
        if current is not None and current in out:
            out[current] = buffer
            self._update_change_cache(current, buffer)
        return out

    def last_pane_change(self, pane: str) -> datetime:
        """pane 마지막 변화 시각. 미관측 = epoch 0 → staleness 자연 발동 (R-1).

        ``capture_pane`` 부수효과로 갱신됨. 직접 호출 시 cache lookup만 수행.
        """
        cached = self._pane_change_cache.get(pane)
        if cached is None:
            return datetime.fromtimestamp(0)
        return cached[1]

    # ------------------------------------------------------------------
    # 내부 helper
    # ------------------------------------------------------------------

    def _run(self, argv: List[str]) -> Optional[str]:
        """subprocess.run 단일 진입 — 격리 #4 정합. 실패 시 None."""
        try:
            res = subprocess.run(
                argv,
                capture_output=True,
                text=True,
                timeout=self.timeout_sec,
                check=False,
            )
        except (FileNotFoundError, subprocess.TimeoutExpired, OSError):
            return None
        if res.returncode != 0:
            return None
        return res.stdout

    def _update_change_cache(self, pane: str, captured: List[str]) -> None:
        """pane 출력 SHA1 변화 시 ``last_pane_change`` 갱신."""
        signature = hashlib.sha1("\n".join(captured).encode("utf-8")).hexdigest()
        prev = self._pane_change_cache.get(pane)
        if prev is None or prev[0] != signature:
            self._pane_change_cache[pane] = (signature, datetime.now())


class GitAdapter:
    """git subprocess 격리 adapter — Stage 10 M-1 fix (AC-T-4 = 2 유지).

    ``pending_collector.py``가 본 어댑터 위임으로 subprocess 직접 import 0건.
    ``token_hook.py``의 ``TmuxAdapter`` 위임 패턴 정합 — design_final Sec.4.3 #4.

    sync 인터페이스 — F-D4 Threaded sync wrapper 정합.
    """

    DEFAULT_TIMEOUT_SEC = 3.0

    def __init__(
        self,
        project_root: Optional[Path] = None,
        timeout_sec: float = DEFAULT_TIMEOUT_SEC,
    ) -> None:
        self.project_root = (project_root or Path.cwd()).resolve()
        self.timeout_sec = timeout_sec

    def run(self, argv: List[str]) -> Optional[str]:
        """git argv → stdout 문자열. 실패(미설치 / timeout / non-zero) 시 None.

        cwd = ``self.project_root`` 고정 — 다른 working tree 영향 0건.
        """
        try:
            res = subprocess.run(
                argv,
                capture_output=True,
                text=True,
                timeout=self.timeout_sec,
                check=False,
                cwd=str(self.project_root),
            )
        except (FileNotFoundError, subprocess.TimeoutExpired, OSError):
            return None
        if res.returncode != 0:
            return None
        return res.stdout
