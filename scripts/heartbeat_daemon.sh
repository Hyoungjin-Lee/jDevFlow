#!/bin/bash
# scripts/heartbeat_daemon.sh
# 정체 감지 데몬 (BR-001 정공법, v0.6.4 hotfix)
# 모든 Orc-* 세션 panes의 'thought for Xs' 시각 변동 polling
# 임계 시간 동안 변동 없으면 정체 의심 → macOS osascript notification + log
# Telegram 통합은 v0.6.5 영역 (운영자 명시: 나중)

set -euo pipefail

LOG_DIR="${LOG_DIR:-/tmp/jOneFlow_heartbeat}"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/heartbeat.log"

STALL_THRESHOLD_SEC="${STALL_THRESHOLD_SEC:-180}"  # 3분 임계
POLL_INTERVAL="${POLL_INTERVAL:-20}"               # 20초 polling

declare -A LAST_THOUGHT
declare -A LAST_CHANGE_TS
declare -A LAST_ALERT_TS

notify() {
  local title="$1"
  local message="$2"
  osascript -e "display notification \"$message\" with title \"$title\" sound name \"Submarine\"" 2>/dev/null || true
  echo "[$(date +%H:%M:%S)] NOTIFY: $title — $message" | tee -a "$LOG_FILE"
}

check_pane() {
  local target="$1"
  local capture
  capture=$(tmux capture-pane -t "$target" -p -S -8 2>/dev/null || echo "")
  [ -z "$capture" ] && return

  # 'thought for Xs' 또는 'X minutes Ys' 시각 추출 (claude CLI thinking 표시)
  local thought
  thought=$(echo "$capture" | grep -oE "thought for [0-9]+s|[0-9]+m [0-9]+s · thought" | tail -1 || echo "")
  [ -z "$thought" ] && return  # thinking 표시 없음 = idle 또는 prompt = 정상

  local now
  now=$(date +%s)
  local key="$target"
  local prev_thought="${LAST_THOUGHT[$key]:-}"
  local prev_ts="${LAST_CHANGE_TS[$key]:-$now}"
  local last_alert="${LAST_ALERT_TS[$key]:-0}"

  if [ "$thought" = "$prev_thought" ]; then
    local elapsed=$((now - prev_ts))
    local since_alert=$((now - last_alert))
    if [ "$elapsed" -ge "$STALL_THRESHOLD_SEC" ] && [ "$since_alert" -ge "$STALL_THRESHOLD_SEC" ]; then
      notify "🚨 정체 감지 — $target" "thought 변동 없음 ${elapsed}s | $thought"
      LAST_ALERT_TS[$key]=$now
    fi
  else
    LAST_THOUGHT[$key]=$thought
    LAST_CHANGE_TS[$key]=$now
    LAST_ALERT_TS[$key]=0
  fi
}

echo "[$(date +%H:%M:%S)] heartbeat_daemon started (PID $$, threshold=${STALL_THRESHOLD_SEC}s, poll=${POLL_INTERVAL}s)" | tee "$LOG_FILE"
notify "🟢 heartbeat 데몬 가동" "정체 감지 polling 시작 (임계 ${STALL_THRESHOLD_SEC}s)"

while true; do
  while IFS= read -r session; do
    [ -z "$session" ] && continue
    while IFS= read -r p; do
      [ -z "$p" ] && continue
      check_pane "${session}:1.${p}"
    done < <(tmux list-panes -t "$session" -F '#{pane_index}' 2>/dev/null || true)
  done < <(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -E '^Orc-' || true)
  sleep "$POLL_INTERVAL"
done
