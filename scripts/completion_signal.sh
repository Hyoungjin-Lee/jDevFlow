#!/usr/bin/env bash
# 의제 3 — Stop hook 확장: 완료 시그널 구조 초안
# Claude Code Stop hook에서 호출하여 stage 완료 시그널을 파일에 기록.
# 목표: 브릿지/대시보드가 파일 폴링(JSONL/JSON)으로 다음 단계 자동 트리거 가능.
#
# 사용:
#   1. CLAUDE_COMPLETION_STAGE 환경 변수로 호출 (예: CLAUDE_COMPLETION_STAGE=05 hook_stop.sh)
#   2. .claude/status/{session}.json 또는 .claude/bridge_status.json에 기록
#
# 포맷:
#   {
#     "stage": "05",
#     "phase": "plan_final",
#     "status": "COMPLETE",
#     "timestamp": "2026-04-27T10:30:45Z",
#     "session": "Orc-065-plan",
#     "actor": "finalizer"
#   }

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS_DIR="${PROJECT_ROOT}/.claude/status"

_exit_ok() { exit 0; }
trap _exit_ok ERR

# 환경 변수: hook_stop.sh에서 설정 필요
STAGE="${CLAUDE_COMPLETION_STAGE:-}"
PHASE="${CLAUDE_COMPLETION_PHASE:-}"
ACTOR="${CLAUDE_COMPLETION_ACTOR:-}"  # drafter|reviewer|finalizer|orchestrator

# 필수 정보 부재 시 조용히 종료 (부팅 검증 단계 등)
[ -z "${STAGE}" ] && exit 0
[ -z "${PHASE}" ] && exit 0

# tmux 컨텍스트에서 세션명 추출
SESSION_NAME=""
if [ -n "${TMUX_PANE:-}" ]; then
    SESSION_NAME="$(tmux display-message -t "${TMUX_PANE}" -p '#{session_name}' 2>/dev/null || true)"
fi

# 타임스탬프 (RFC 3339)
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

# JSON 페이로드 생성
STATUS_JSON="{"
STATUS_JSON+="\"stage\":\"${STAGE}\","
STATUS_JSON+="\"phase\":\"${PHASE}\","
STATUS_JSON+="\"status\":\"COMPLETE\","
STATUS_JSON+="\"timestamp\":\"${TIMESTAMP}\""
[ -n "${SESSION_NAME}" ] && STATUS_JSON+=",\"session\":\"${SESSION_NAME}\""
[ -n "${ACTOR}" ] && STATUS_JSON+=",\"actor\":\"${ACTOR}\""
STATUS_JSON+="}"

# 저장 위치 결정
# 1. 개별 세션 상태 (팀원 완료): .claude/status/{session}.json
# 2. 브릿지 상태 (오케 완료): .claude/bridge_status.json
TARGET_FILE=""
if [ -n "${SESSION_NAME}" ]; then
    mkdir -p "${STATUS_DIR}"
    TARGET_FILE="${STATUS_DIR}/${SESSION_NAME}.json"
elif [ -n "${STAGE}" ] && [ "${STAGE}" == "05" ] || [ "${STAGE}" == "06" ]; then
    # Stage 05(기획 파이널라이즈) 또는 06(운영자 승인) = 브릿지 레벨 신호
    TARGET_FILE="${PROJECT_ROOT}/.claude/bridge_status.json"
fi

# 파일 저장
if [ -n "${TARGET_FILE}" ]; then
    echo "${STATUS_JSON}" > "${TARGET_FILE}"
    echo "[$(date +%H:%M:%S)] completion_signal: saved to ${TARGET_FILE}" >> /tmp/joneflow_signal.log
fi

exit 0
