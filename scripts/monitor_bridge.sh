#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# monitor_bridge.sh — F-62-7 Monitor 인프라 (timestamp/stage/범위)
#
# 역할: bridge 세션 신호 자동 캐치 + 타임스탐프 붙임 + stage 명시
#
# 사용법:
#   TMUX_SESSION_BRIDGE="bridge" bash scripts/monitor_bridge.sh &
#
# 신호 패턴 (F-62-7a: timestamp / F-62-7b: stage 명시 / F-62-7c: -S -20 범위):
#   📡 status [timestamp] [stage] [signal...]
#
# 예시:
#   📡 status 2026-04-27 10:34:56 Stage 5 진입 GO
#   📡 status 2026-04-27 11:02:15 Stage 8 구현 시작
#

set -eu

# ============================================================================
# Config
# ============================================================================

# F-62-7a: Q1 패턴 — 환경 변수 주입
target_session="${TMUX_SESSION_BRIDGE:-bridge}"
monitor_interval=3

# 신호 감지 패턴 (F-62-7c: capture-pane -S -20 범위 내 시그니처)
signal_pattern="^📡 status|^ERROR|^운영자 결정|^중단 조건|FAIL|S[0-9]+ ✅"

# ============================================================================
# 함수
# ============================================================================

# timestamp 생성 (F-62-7a)
get_timestamp() {
  date +%Y-%m-%d\ %H:%M:%S
}

# 신호 감지 및 출력
emit_signal() {
  local signal_line="$1"
  local timestamp
  timestamp=$(get_timestamp)

  # 신호에 stage 정보 추가 (F-62-7b)
  # 기존 신호에서 "Stage X" 형식 감지, 없으면 "UNKNOWN" 사용
  local stage_info="UNKNOWN"
  if echo "$signal_line" | grep -q "Stage [0-9]"; then
    stage_info=$(echo "$signal_line" | grep -oE "Stage [0-9]+[^ ]*" | head -1)
  fi

  printf '📡 status %s %s %s\n' "$timestamp" "$stage_info" "$signal_line"
}

# 세션 검증
check_session() {
  tmux has-session -t "$target_session" 2>/dev/null && return 0
  printf 'error: session "%s" not found\n' "$target_session" >&2
  return 1
}

# ============================================================================
# Main Loop
# ============================================================================

# 세션 확인
if ! check_session; then
  printf 'monitor_bridge.sh: waiting for session "%s" to be created...\n' "$target_session" >&2
  for i in $(seq 1 30); do
    sleep 1
    check_session && break
    if [ "$i" -eq 30 ]; then
      printf 'error: session "%s" timeout after 30s\n' "$target_session" >&2
      exit 1
    fi
  done
fi

# 신호 히스토리 초기화
prev=""

# Monitor 루프 (F-62-7c: -S -20 범위)
while true; do
  # 최근 20줄 capture (F-62-7c)
  cur=$(tmux capture-pane -t "$target_session" -p -S -20 2>/dev/null \
    | grep --line-buffered -E "$signal_pattern" \
    | tail -5)

  # 변화 감지 (중복 신호 필터링)
  if [ "$cur" != "$prev" ] && [ -n "$cur" ]; then
    # 각 라인을 emit
    while IFS= read -r line; do
      [ -n "$line" ] && emit_signal "$line"
    done <<< "$cur"
    prev="$cur"
  fi

  sleep "$monitor_interval"
done
