#!/bin/sh
# setup_tmux_layout.sh — 제이원랩 기본 tmux 레이아웃 구성
#
# 레이아웃: 왼쪽 큰 pane = 오케스트레이터 / 오른쪽 세로 분할 N-pane = 팀원
#
# 사용법:
#   bash scripts/setup_tmux_layout.sh [session_name] [team_size]
#
# 기본값:
#   session_name = joneflow
#   team_size    = 2 (오른쪽 상하 2-pane)
#
# 동작:
#   1. 세션이 없으면 detached로 새로 생성 (cwd = 프로젝트 루트).
#   2. 세션이 있으면 첫 pane(오케스트레이터로 간주)만 남기고 나머지 모두 kill.
#   3. 왼쪽 오케스트레이터 / 오른쪽 N개 팀원 pane으로 재구성.
#   4. `main-vertical` 레이아웃 적용 (왼쪽 큰 main + 오른쪽 세로 분할).
#   5. focus는 오케스트레이터로 복귀.
#
# 전제:
#   - 오케스트레이터 claude CLI는 별도 기동. 본 스크립트는 레이아웃만 담당.
#   - 세션 재구성은 오케스트레이터 작업 중에는 방해가 되므로, 실행 타이밍 주의.
#
# 제이원랩 조직도 (v0.6):
#   CTO팀 (데스크탑 앱)
#     └─ AI팀 오케스트레이터 (CLI, 왼쪽 pane)
#          └─ AI팀 팀원 N명 (오른쪽 pane 각각 1개씩)

set -eu

SESSION="${1:-joneflow}"
TEAM_SIZE="${2:-2}"
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)

if [ "$TEAM_SIZE" -lt 1 ]; then
  printf 'error: team_size는 1 이상 (받은 값: %s)\n' "$TEAM_SIZE" >&2
  exit 2
fi

# 세션 부재 시 생성
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux new-session -d -s "$SESSION" -c "$ROOT"
  printf '▷ 새 tmux 세션 "%s" 생성 (cwd=%s)\n' "$SESSION" "$ROOT"
fi

# 오케스트레이터 pane 확정 (첫 pane)
first_pane=$(tmux list-panes -t "$SESSION" -F "#{pane_id}" | head -1)

# 나머지 pane 모두 kill
tmux kill-pane -a -t "$first_pane" 2>/dev/null || true

# 오른쪽으로 split (첫 팀원)
tmux split-window -h -t "$first_pane" -c "$ROOT"

# 팀원 2명 이상이면 오른쪽에서 추가 세로 분할
i=1
while [ "$i" -lt "$TEAM_SIZE" ]; do
  right_pane=$(tmux list-panes -t "$SESSION" -F "#{pane_id}" | tail -1)
  tmux split-window -v -t "$right_pane" -c "$ROOT"
  i=$((i + 1))
done

# main-vertical 레이아웃 (왼쪽 큰 main + 오른쪽 세로 분할)
tmux select-layout -t "$SESSION" main-vertical >/dev/null

# focus 오케스트레이터
tmux select-pane -t "$first_pane"

# 팀원 pane 안내 메시지
i=1
tmux list-panes -t "$SESSION" -F "#{pane_id}" | tail -n +2 | while IFS= read -r pane_id; do
  tmux send-keys -t "$pane_id" "clear && echo '▼ 팀원 pane $i / $TEAM_SIZE'" Enter
  i=$((i + 1))
done

# Monitor 자동 재가동 hook (M1 — F-62-7)
# bridge 세션에서 PostToolUse/Stop 신호 감지 시 monitor_bridge.sh 자동 재시작
if [ "$SESSION" = "bridge" ] || [ "$SESSION" = "bridge-063" ]; then
  # 기존 monitor 프로세스 있으면 종료
  if pgrep -f "monitor_bridge.sh" >/dev/null 2>&1; then
    pkill -f "monitor_bridge.sh" 2>/dev/null || true
    sleep 0.5
  fi

  # Monitor 백그라운드 가동 (환경 변수 주입 — Q1 패턴)
  (
    export TMUX_SESSION_BRIDGE="$SESSION"
    cd "$ROOT"
    bash scripts/monitor_bridge.sh >/dev/null 2>&1 &
  ) || true

  printf '▶ Monitor 프로세스 가동 (세션: %s)\n' "$SESSION"
fi

printf '✅ 레이아웃 구성 완료 — 세션: %s, 오케스트레이터 1 + 팀원 %s\n' "$SESSION" "$TEAM_SIZE"
tmux list-panes -t "$SESSION" -F "  pane #{pane_index}: #{pane_id}  #{pane_height}x#{pane_width}  active=#{pane_active}"
