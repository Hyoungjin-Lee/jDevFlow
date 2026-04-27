#!/usr/bin/env python3
"""monitor_bridge_jsonl.py — JSONL 기반 브릿지 신호 모니터.

capture-pane 방식 완전 제거. 터미널 닫힘/minimize 상태에서도 동작.

동작:
  - bridge 세션(기본: bridge-064:1.1)의 JSONL 파일을 tail 폴링.
  - 새로운 assistant 텍스트 블록에서 신호 패턴(📡 status, ERROR 등) 감지.
  - 감지 시 타임스탬프 + stage 정보 붙여 stdout emit.

사용법:
  BRIDGE_PANE=bridge-064:1.1 venv/bin/python3 scripts/monitor_bridge_jsonl.py
"""
from __future__ import annotations

import json
import os
import re
import sys
import time
from datetime import datetime
from pathlib import Path

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

BRIDGE_PANE = os.environ.get("BRIDGE_PANE", "bridge-064:1.1")
POLL_INTERVAL = float(os.environ.get("MONITOR_INTERVAL", "3"))
PROJECT_ROOT = Path(__file__).resolve().parent.parent

# 신호 감지 패턴 (기존 monitor_bridge.sh 호환)
SIGNAL_RE = re.compile(
    r"📡\s*status|ERROR|운영자\s*결정|중단\s*조건|FAIL|S\d+\s*✅|COMPLETE|APPROVED|GO|REJECTED"
)
STAGE_RE = re.compile(r"Stage\s*\d+\S*")

# ---------------------------------------------------------------------------
# JSONL 경로 탐색 (token_hook.py 동일 로직)
# ---------------------------------------------------------------------------

def _transcript_dir() -> Path:
    slug = str(PROJECT_ROOT).replace("/", "-").replace("_", "-")
    return Path.home() / ".claude/projects" / slug


def find_jsonl_for_pane(pane_name: str) -> Path | None:
    td = _transcript_dir()
    if not td.exists():
        return None
    try:
        candidates = sorted(td.glob("*.jsonl"), key=lambda p: p.stat().st_mtime, reverse=True)[:60]
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
        except Exception:
            continue
    return None

# ---------------------------------------------------------------------------
# 텍스트 추출
# ---------------------------------------------------------------------------

def extract_text_blocks(entry: dict) -> list[str]:
    """assistant 엔트리에서 text 블록 텍스트 목록 반환."""
    msg = entry.get("message", {})
    if not isinstance(msg, dict):
        return []
    content = msg.get("content", [])
    if isinstance(content, str):
        return [content] if content.strip() else []
    if not isinstance(content, list):
        return []
    texts = []
    for block in content:
        if isinstance(block, dict) and block.get("type") == "text":
            t = block.get("text", "").strip()
            if t:
                texts.append(t)
    return texts

# ---------------------------------------------------------------------------
# 신호 emit
# ---------------------------------------------------------------------------

def emit_signal(text_line: str) -> None:
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    stage_m = STAGE_RE.search(text_line)
    stage_info = stage_m.group(0) if stage_m else "UNKNOWN"
    print(f"📡 status {ts} {stage_info} {text_line}", flush=True)

# ---------------------------------------------------------------------------
# JSONL tail 폴링
# ---------------------------------------------------------------------------

def monitor_jsonl(jsonl_path: Path) -> None:
    """JSONL 파일을 tail 폴링하며 새 assistant 신호 감지."""
    print(f"[monitor] JSONL: {jsonl_path.name}", file=sys.stderr, flush=True)
    # 현재 파일 끝 위치에서 시작 (과거 항목 무시)
    with jsonl_path.open(encoding="utf-8") as fh:
        fh.seek(0, 2)  # EOF
        pos = fh.tell()

    prev_size = pos
    while True:
        try:
            cur_size = jsonl_path.stat().st_size
        except OSError:
            time.sleep(POLL_INTERVAL)
            continue

        if cur_size > prev_size:
            with jsonl_path.open(encoding="utf-8") as fh:
                fh.seek(prev_size)
                for line in fh:
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        d = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    if d.get("type") != "assistant":
                        continue
                    for text in extract_text_blocks(d):
                        for part in text.splitlines():
                            if SIGNAL_RE.search(part):
                                emit_signal(part.strip())
            prev_size = cur_size

        time.sleep(POLL_INTERVAL)

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    print(f"[monitor] 시작 — pane={BRIDGE_PANE}, interval={POLL_INTERVAL}s", file=sys.stderr, flush=True)

    jsonl_path: Path | None = None
    while True:
        if jsonl_path is None or not jsonl_path.exists():
            jsonl_path = find_jsonl_for_pane(BRIDGE_PANE)
            if jsonl_path is None:
                print(f"[monitor] JSONL 미발견 ({BRIDGE_PANE}), 재시도...", file=sys.stderr, flush=True)
                time.sleep(POLL_INTERVAL)
                continue
        try:
            monitor_jsonl(jsonl_path)
        except KeyboardInterrupt:
            print("[monitor] 종료", file=sys.stderr, flush=True)
            break
        except Exception as e:
            print(f"[monitor] 오류: {e}, 재시작...", file=sys.stderr, flush=True)
            jsonl_path = None
            time.sleep(POLL_INTERVAL)


if __name__ == "__main__":
    main()
