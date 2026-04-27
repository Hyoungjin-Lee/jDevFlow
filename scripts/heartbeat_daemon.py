#!/usr/bin/env python3
"""정체 감지 데몬 — JSONL 기반 (capture-pane 제거).

터미널 닫힘/minimize 상태에서도 동작.

동작:
  Orc-* / bridge-* 세션의 JSONL 파일을 폴링.
  마지막 user 엔트리 이후 assistant 응답이 없고 STALL_THRESHOLD_SEC 초 경과 →
  정체 의심 알림.
"""

import hashlib
import json
import os
import platform
import shutil
import subprocess
import tempfile
import time
from datetime import datetime
from pathlib import Path

OS_NAME = platform.system()

DEFAULT_LOG_DIR = (
    os.path.join(tempfile.gettempdir(), "jOneFlow_heartbeat")
    if OS_NAME == "Windows"
    else "/tmp/jOneFlow_heartbeat"
)
LOG_DIR = os.environ.get("LOG_DIR", DEFAULT_LOG_DIR)
LOG_FILE = os.path.join(LOG_DIR, "heartbeat.log")
STALL_THRESHOLD_SEC = int(os.environ.get("STALL_THRESHOLD_SEC", "180"))
POLL_INTERVAL = int(os.environ.get("POLL_INTERVAL", "20"))

PROJECT_ROOT = Path(__file__).resolve().parent.parent


# ---------------------------------------------------------------------------
# 로깅 / 알림
# ---------------------------------------------------------------------------

def log(msg: str) -> None:
    ts = datetime.now().strftime("%H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    try:
        with open(LOG_FILE, "a") as f:
            f.write(line + "\n")
    except OSError:
        pass


def _notify_macos(title: str, message: str) -> None:
    safe_msg = message.replace('"', '\\"')
    safe_title = title.replace('"', '\\"')
    script = f'display notification "{safe_msg}" with title "{safe_title}" sound name "Submarine"'
    subprocess.run(["osascript", "-e", script], check=False, capture_output=True)


def _notify_linux(title: str, message: str) -> None:
    if shutil.which("notify-send"):
        subprocess.run(["notify-send", "-u", "critical", title, message], check=False, capture_output=True)
    elif shutil.which("zenity"):
        subprocess.run(["zenity", "--notification", "--text", f"{title}\\n{message}"], check=False, capture_output=True)


def _notify_windows(title: str, message: str) -> None:
    try:
        from win10toast import ToastNotifier  # type: ignore
        ToastNotifier().show_toast(title, message, duration=5, threaded=True)
        return
    except ImportError:
        pass
    safe_msg = message.replace('"', '`"')
    safe_title = title.replace('"', '`"')
    ps_cmd = (
        f'Add-Type -AssemblyName System.Windows.Forms; '
        f'[System.Windows.Forms.MessageBox]::Show("{safe_msg}", "{safe_title}") | Out-Null'
    )
    subprocess.run(["powershell", "-NoProfile", "-Command", ps_cmd], check=False, capture_output=True)


def notify(title: str, message: str) -> None:
    try:
        if OS_NAME == "Darwin":
            _notify_macos(title, message)
        elif OS_NAME == "Linux":
            _notify_linux(title, message)
        elif OS_NAME == "Windows":
            _notify_windows(title, message)
    except Exception as e:
        log(f"NOTIFY-ERR ({OS_NAME}): {e}")
    log(f"NOTIFY: {title} — {message}")


# ---------------------------------------------------------------------------
# tmux 세션 목록
# ---------------------------------------------------------------------------

def tmux(args: list) -> str:
    try:
        r = subprocess.run(["tmux", *args], capture_output=True, text=True, check=False)
        return r.stdout.strip() if r.returncode == 0 else ""
    except Exception:
        return ""


def get_tracked_sessions() -> list:
    out = tmux(["list-sessions", "-F", "#{session_name}"])
    return [s for s in out.split("\n") if s.startswith("Orc-") or s.startswith("bridge-")]


def get_panes(session: str) -> list:
    out = tmux(["list-panes", "-a", "-t", session, "-F", "#{window_index}.#{pane_index}"])
    return [p for p in out.split("\n") if p]


# ---------------------------------------------------------------------------
# JSONL 경로 탐색
# ---------------------------------------------------------------------------

def _transcript_dir() -> Path:
    slug = str(PROJECT_ROOT).replace("/", "-").replace("_", "-")
    return Path.home() / ".claude/projects" / slug


def find_jsonl_for_pane(pane_name: str) -> Path | None:
    """customTitle 기반 JSONL 탐색 (token_hook.py 동일 로직)."""
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
# 정체 감지 — JSONL 타임스탬프 기반
# ---------------------------------------------------------------------------

def check_stall(jsonl_path: Path) -> dict:
    """JSONL에서 user/assistant 타임스탬프 갭으로 정체 판단.

    Returns:
        {stalled: bool, elapsed: float, last_user_ts: datetime | None}
    """
    last_user_ts = None
    last_asst_ts = None

    try:
        for line in jsonl_path.open(encoding="utf-8"):
            try:
                d = json.loads(line)
            except json.JSONDecodeError:
                continue
            entry_type = d.get("type")
            ts_str = d.get("timestamp", "")
            if not ts_str:
                continue
            try:
                ts = datetime.fromisoformat(ts_str)
            except ValueError:
                continue

            if entry_type == "user":
                # XML 시스템 메시지(슬래시 커맨드) 제외
                content = (d.get("message") or {}).get("content", "")
                if isinstance(content, str) and content.strip().startswith("<"):
                    continue
                last_user_ts = ts
            elif entry_type == "assistant":
                last_asst_ts = ts
    except OSError:
        return {"stalled": False, "elapsed": 0.0, "last_user_ts": None}

    if last_user_ts is None:
        return {"stalled": False, "elapsed": 0.0, "last_user_ts": None}

    # user 이후 assistant 응답이 없거나 user가 더 최신 → 응답 대기 중
    waiting = last_asst_ts is None or last_user_ts > last_asst_ts
    if not waiting:
        return {"stalled": False, "elapsed": 0.0, "last_user_ts": last_user_ts}

    elapsed = (datetime.now() - last_user_ts).total_seconds()
    return {
        "stalled": elapsed >= STALL_THRESHOLD_SEC,
        "elapsed": elapsed,
        "last_user_ts": last_user_ts,
    }


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    os.makedirs(LOG_DIR, exist_ok=True)
    open(LOG_FILE, "w").close()

    # pane → (last_alert_ts, last_stall_state)
    last_alert_ts: dict = {}

    log(f"heartbeat_daemon started (PID {os.getpid()}, threshold={STALL_THRESHOLD_SEC}s, poll={POLL_INTERVAL}s)")
    notify("🟢 heartbeat 데몬 가동", f"JSONL 기반 정체 감지 시작 (임계 {STALL_THRESHOLD_SEC}s)")

    # pane → jsonl_path 캐시
    jsonl_cache: dict = {}
    cache_ts: dict = {}
    CACHE_TTL = 60.0

    while True:
        now = time.time()
        for session in get_tracked_sessions():
            for pane_idx in get_panes(session):
                pane_name = f"{session}:{pane_idx}"

                # JSONL 경로 캐시
                if now - cache_ts.get(pane_name, 0) > CACHE_TTL:
                    jsonl_cache[pane_name] = find_jsonl_for_pane(pane_name)
                    cache_ts[pane_name] = now

                jsonl_path = jsonl_cache.get(pane_name)
                if jsonl_path is None:
                    continue

                result = check_stall(jsonl_path)
                if not result["stalled"]:
                    last_alert_ts.pop(pane_name, None)
                    continue

                last_alert = last_alert_ts.get(pane_name, 0)
                if now - last_alert >= STALL_THRESHOLD_SEC:
                    elapsed_min = int(result["elapsed"] // 60)
                    elapsed_sec = int(result["elapsed"] % 60)
                    msg = f"응답 없음 {elapsed_min}m {elapsed_sec}s | {pane_name}"
                    notify(f"🚨 정체 감지 — {pane_name}", msg)
                    last_alert_ts[pane_name] = now

        time.sleep(POLL_INTERVAL)


if __name__ == "__main__":
    main()
