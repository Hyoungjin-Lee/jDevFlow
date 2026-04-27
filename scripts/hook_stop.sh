#!/usr/bin/env bash
# Claude Code Stop hook — 세션 종료 시 토큰 누적값을 dashboard_state에 저장.
# stdin: {"session_id":"...","transcript_path":"...","usage":{"input_tokens":N,"output_tokens":N,...}}
# 출력 없음. 실패 시 exit 0 강제 (dashboard hook은 Claude Code 세션을 차단하면 안 됨).
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOK_DIR="${PROJECT_ROOT}/.claude/dashboard_state"

_exit_ok() { exit 0; }
trap _exit_ok ERR

# stdin 읽기 (Claude Code가 JSON으로 넘겨줌).
STDIN_DATA="$(cat)"

# tmux 세션명 추출 — hook은 claude CLI 실행 pane 컨텍스트에서 돌아감.
if [ -n "${TMUX_PANE:-}" ]; then
    SESSION_NAME="$(tmux display-message -t "${TMUX_PANE}" -p '#{session_name}' 2>/dev/null || true)"
else
    SESSION_NAME=""
fi

# tmux 밖이거나 세션명 취득 실패 시 조용히 종료.
[ -z "${SESSION_NAME}" ] && exit 0

# project hash — token_hook.py 와 동일 알고리즘 (sha1(project_root)[:8]).
PROJECT_HASH="$(python3 -c "import hashlib,sys; print(hashlib.sha1(sys.argv[1].encode()).hexdigest()[:8])" "${PROJECT_ROOT}" 2>/dev/null || true)"
[ -z "${PROJECT_HASH}" ] && exit 0

TARGET_FILE="${HOOK_DIR}/joneflow_${PROJECT_HASH}_${SESSION_NAME}.json"

# stdin JSON에서 input_tokens / output_tokens 추출.
PARSED="$(python3 -c "
import json, sys
try:
    data = json.loads(sys.argv[1])
    usage = data.get('usage') or {}
    inp = int(usage.get('input_tokens', 0))
    out = int(usage.get('output_tokens', 0))
    print(inp, out)
except Exception:
    print(0, 0)
" "${STDIN_DATA}" 2>/dev/null || echo "0 0")"

NEW_INPUT="$(echo "${PARSED}" | awk '{print $1}')"
NEW_OUTPUT="$(echo "${PARSED}" | awk '{print $2}')"

# 둘 다 0이면 저장 의미 없음.
[ "${NEW_INPUT}" -eq 0 ] && [ "${NEW_OUTPUT}" -eq 0 ] && exit 0

# 기존 파일 있으면 누적, 없으면 새로 쓰기.
mkdir -p "${HOOK_DIR}"

if [ -f "${TARGET_FILE}" ]; then
    PREV="$(python3 -c "
import json,sys
try:
    d=json.load(open(sys.argv[1]))
    print(d.get('input_tokens',0), d.get('output_tokens',0))
except Exception:
    print(0, 0)
" "${TARGET_FILE}" 2>/dev/null || echo "0 0")"
    PREV_INPUT="$(echo "${PREV}" | awk '{print $1}')"
    PREV_OUTPUT="$(echo "${PREV}" | awk '{print $2}')"
    NEW_INPUT=$(( NEW_INPUT + PREV_INPUT ))
    NEW_OUTPUT=$(( NEW_OUTPUT + PREV_OUTPUT ))
fi

python3 -c "
import json, sys
data = {'input_tokens': int(sys.argv[1]), 'output_tokens': int(sys.argv[2])}
open(sys.argv[3], 'w').write(json.dumps(data))
" "${NEW_INPUT}" "${NEW_OUTPUT}" "${TARGET_FILE}" 2>/dev/null || true

exit 0
