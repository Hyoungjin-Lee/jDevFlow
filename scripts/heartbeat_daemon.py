#!/usr/bin/env python3
"""정체 감지 데몬 (BR-001 정공법, v0.6.4 hotfix).

Orc-* 세션 모든 panes의 'thought for Xs' 시각 변동 polling.
임계 시간 동안 변동 없으면 정체 의심 → macOS osascript notification + log.
Telegram 통합은 v0.6.5 영역 (운영자 명시: 우선순위 최하).
"""

import os
import re
import subprocess
import time
from datetime import datetime

LOG_DIR = os.environ.get("LOG_DIR", "/tmp/jOneFlow_heartbeat")
LOG_FILE = os.path.join(LOG_DIR, "heartbeat.log")
STALL_THRESHOLD_SEC = int(os.environ.get("STALL_THRESHOLD_SEC", "180"))
POLL_INTERVAL = int(os.environ.get("POLL_INTERVAL", "20"))

THOUGHT_RE = re.compile(r"thought for \d+s|\d+m \d+s · thought")


def log(msg: str) -> None:
    ts = datetime.now().strftime("%H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    try:
        with open(LOG_FILE, "a") as f:
            f.write(line + "\n")
    except OSError:
        pass


def notify(title: str, message: str) -> None:
    safe_msg = message.replace('"', '\\"')
    safe_title = title.replace('"', '\\"')
    script = f'display notification "{safe_msg}" with title "{safe_title}" sound name "Submarine"'
    subprocess.run(["osascript", "-e", script], check=False, capture_output=True)
    log(f"NOTIFY: {title} — {message}")


def tmux(args: list[str]) -> str:
    try:
        r = subprocess.run(["tmux", *args], capture_output=True, text=True, check=False)
        return r.stdout.strip() if r.returncode == 0 else ""
    except Exception:
        return ""


def get_tracked_sessions() -> list[str]:
    """jOneFlow 프레임워크 영역 = Orc-* + bridge-* 모두 추적."""
    out = tmux(["list-sessions", "-F", "#{session_name}"])
    return [s for s in out.split("\n") if s.startswith("Orc-") or s.startswith("bridge-")]


def get_panes(session: str) -> list[str]:
    out = tmux(["list-panes", "-t", session, "-F", "#{pane_index}"])
    return [p for p in out.split("\n") if p]


def capture_pane(target: str) -> str:
    return tmux(["capture-pane", "-t", target, "-p", "-S", "-8"])


def extract_thought(capture: str) -> str | None:
    matches = THOUGHT_RE.findall(capture)
    return matches[-1] if matches else None


def main() -> None:
    os.makedirs(LOG_DIR, exist_ok=True)
    open(LOG_FILE, "w").close()

    last_thought: dict[str, str] = {}
    last_change_ts: dict[str, float] = {}
    last_alert_ts: dict[str, float] = {}

    log(f"heartbeat_daemon started (PID {os.getpid()}, threshold={STALL_THRESHOLD_SEC}s, poll={POLL_INTERVAL}s)")
    notify("🟢 heartbeat 데몬 가동", f"정체 감지 polling 시작 (임계 {STALL_THRESHOLD_SEC}s)")

    while True:
        for session in get_orc_sessions():
            for p in get_panes(session):
                target = f"{session}:1.{p}"
                capture = capture_pane(target)
                if not capture:
                    continue
                thought = extract_thought(capture)
                if thought is None:
                    continue

                now = time.time()
                prev_thought = last_thought.get(target)
                prev_ts = last_change_ts.get(target, now)
                last_alert = last_alert_ts.get(target, 0.0)

                if thought == prev_thought:
                    elapsed = now - prev_ts
                    since_alert = now - last_alert
                    if elapsed >= STALL_THRESHOLD_SEC and since_alert >= STALL_THRESHOLD_SEC:
                        notify(f"🚨 정체 감지 — {target}", f"thought 변동 없음 {int(elapsed)}s | {thought}")
                        last_alert_ts[target] = now
                else:
                    last_thought[target] = thought
                    last_change_ts[target] = now
                    last_alert_ts[target] = 0.0

        time.sleep(POLL_INTERVAL)


if __name__ == "__main__":
    main()
