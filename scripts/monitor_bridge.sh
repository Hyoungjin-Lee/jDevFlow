#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# monitor_bridge.sh — JSONL 기반 브릿지 신호 모니터 (capture-pane 제거)
#
# 역할: bridge JSONL 파일을 tail 폴링 → 신호 감지 → 타임스탬프 붙여 emit
# 터미널 닫힘/minimize 상태에서도 동작.
#
# 사용법:
#   BRIDGE_PANE="bridge-064:1.1" bash scripts/monitor_bridge.sh &
#   TMUX_SESSION_BRIDGE="bridge-064" bash scripts/monitor_bridge.sh &  # 레거시 호환
#
# 신호 패턴:
#   📡 status [timestamp] [stage] [signal...]

set -eu

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 레거시 환경변수(TMUX_SESSION_BRIDGE) → BRIDGE_PANE 변환
if [ -z "${BRIDGE_PANE:-}" ]; then
  _sess="${TMUX_SESSION_BRIDGE:-bridge-064}"
  export BRIDGE_PANE="${_sess}:1.1"
fi

export MONITOR_INTERVAL="${MONITOR_INTERVAL:-3}"

exec "${ROOT}/venv/bin/python3" "${ROOT}/scripts/monitor_bridge_jsonl.py" "$@"
