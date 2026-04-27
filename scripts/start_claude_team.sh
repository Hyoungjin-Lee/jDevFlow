#!/usr/bin/env bash
# start_claude_team.sh — Orc 세션의 모든 pane에 claude --name 옵션으로 시작.
#
# 사용법:
#   bash scripts/start_claude_team.sh [session_name]
#   bash scripts/start_claude_team.sh          # 현재 활성 Orc 세션 전체 자동 감지
#   bash scripts/start_claude_team.sh Orc-064-plan
#   bash scripts/start_claude_team.sh bridge-064
#
# 동작:
#   - 세션의 모든 pane에 `claude --dangerously-skip-permissions --name "session:w.p"` 전송.
#   - 이미 claude가 실행 중인 pane은 건너뜀 (skip).
#   - --name 옵션으로 시작된 세션은 JSONL에 customTitle이 기록됨 → token_hook 정확 매핑.
#
# 주의:
#   - bridge / bridge-064 세션은 PM 오케스트레이터용. 단일 pane 1.1만.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

_start_pane() {
    local pane_target="$1"
    local session="$2"
    local window="$3"
    local pane_idx="$4"
    local pane_name="${session}:${window}.${pane_idx}"

    # 이미 claude가 실행 중이면 skip
    local pane_pid
    pane_pid=$(tmux display-message -t "$pane_target" -p "#{pane_pid}" 2>/dev/null || echo "")
    if [ -n "$pane_pid" ]; then
        local child_claude
        child_claude=$(pgrep -P "$pane_pid" 2>/dev/null | while read -r cpid; do
            comm=$(ps -p "$cpid" -o comm= 2>/dev/null || echo "")
            [[ "$comm" == *"claude"* ]] && echo "$cpid" && break
        done || true)
        if [ -n "$child_claude" ]; then
            printf '  ↳ skip %s (claude PID=%s 실행 중)\n' "$pane_name" "$child_claude"
            return
        fi
    fi

    printf '  ▶ %s  ← claude --name "%s"\n' "$pane_name" "$pane_name"
    tmux send-keys -t "$pane_target" \
        "claude --dangerously-skip-permissions --name '${pane_name}'" Enter
    sleep 0.2
}

_start_session() {
    local session="$1"
    printf '\n[%s]\n' "$session"

    # 세션의 모든 pane 목록 (window_index.pane_index)
    tmux list-panes -a -t "$session" \
        -F "#{window_index}:#{pane_index}" 2>/dev/null | \
    while IFS=: read -r win pane; do
        _start_pane "${session}:${win}.${pane}" "$session" "$win" "$pane"
    done
}

# 대상 세션 결정
if [ $# -ge 1 ]; then
    SESSIONS=("$@")
else
    # Orc-* + bridge-064 자동 감지
    mapfile -t SESSIONS < <(
        tmux list-sessions -F "#{session_name}" 2>/dev/null | \
        grep -E '^(Orc-|bridge-[0-9])' | sort
    )
fi

if [ ${#SESSIONS[@]} -eq 0 ]; then
    echo "오류: 실행 중인 Orc- 또는 bridge-* 세션이 없습니다." >&2
    exit 1
fi

printf '▶ claude --name 시작 대상 세션: %s\n' "${SESSIONS[*]}"

for sess in "${SESSIONS[@]}"; do
    if ! tmux has-session -t "$sess" 2>/dev/null; then
        printf '  ✗ 세션 없음: %s\n' "$sess"
        continue
    fi
    _start_session "$sess"
done

printf '\n✅ 완료. 각 pane이 JSONL customTitle을 기록하면 토큰 추적이 정확해집니다.\n'
