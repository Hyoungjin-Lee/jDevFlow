#!/usr/bin/env bash
# v0.6.6 의제 #2 reviewer — Stop hook chain 스모크 테스트
#
# 검증 대상:
#   T1. settings.json Stop hook → scripts/hook_stop.sh 시그니처 정합
#   T2. hook_stop.sh / completion_signal.sh 실행권한
#   T3. completion_signal.sh STAGE/PHASE 가드 (env 미설정 = no-op)
#   T4. completion_signal.sh STAGE+PHASE 설정 = TARGET_FILE 발화
#   T5. hook_stop.sh chain — CLAUDE_COMPLETION_STAGE 전달 시 chain 발화
#       (env 미설정 시 chain 미발화)
#
# 사용:
#   bash scripts/test_hook_chain.sh
#
# 출력: PASS/FAIL 라인 + 마지막 SUMMARY. 실패 1건 이상 시 exit 1.
# 부수효과: /tmp/joneflow_test_hook_chain/ 임시 디렉토리만 사용
#           (실제 .claude/status/ / /tmp/joneflow_signal.log 미오염).

set -u

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_TMP="/tmp/joneflow_test_hook_chain"
PASS=0
FAIL=0

_pass() { echo "PASS $*"; PASS=$((PASS+1)); }
_fail() { echo "FAIL $*"; FAIL=$((FAIL+1)); }

mkdir -p "${TEST_TMP}"
rm -f "${TEST_TMP}"/*.json "${TEST_TMP}"/*.log

# ─────────────────────────────────────────────────────────
# T1. settings.json Stop hook 시그니처
# ─────────────────────────────────────────────────────────
STOP_CMD="$(python3 -c "
import json
data = json.load(open('${PROJECT_ROOT}/.claude/settings.json'))
hooks = data.get('hooks', {}).get('Stop', [])
if hooks and hooks[0].get('hooks'):
    print(hooks[0]['hooks'][0].get('command', ''))
" 2>/dev/null)"
if [ "${STOP_CMD}" = "scripts/hook_stop.sh" ]; then
    _pass "T1 settings.json Stop hook = ${STOP_CMD}"
else
    _fail "T1 settings.json Stop hook = '${STOP_CMD}' (expected: scripts/hook_stop.sh)"
fi

# ─────────────────────────────────────────────────────────
# T2. 실행권한
# ─────────────────────────────────────────────────────────
[ -x "${PROJECT_ROOT}/scripts/hook_stop.sh" ] \
    && _pass "T2a hook_stop.sh executable" \
    || _fail "T2a hook_stop.sh NOT executable"

[ -x "${PROJECT_ROOT}/scripts/completion_signal.sh" ] \
    && _pass "T2b completion_signal.sh executable" \
    || _fail "T2b completion_signal.sh NOT executable (drafter c24e7b4 chmod 누락 회수 대상)"

# ─────────────────────────────────────────────────────────
# T3. completion_signal.sh — STAGE 미설정 시 no-op
# ─────────────────────────────────────────────────────────
SIDE_EFFECT_BEFORE="$(ls "${TEST_TMP}"/*.json 2>/dev/null | wc -l | tr -d ' ')"
env -u CLAUDE_COMPLETION_STAGE -u CLAUDE_COMPLETION_PHASE \
    "${PROJECT_ROOT}/scripts/completion_signal.sh" >/dev/null 2>&1
RC=$?
SIDE_EFFECT_AFTER="$(ls "${TEST_TMP}"/*.json 2>/dev/null | wc -l | tr -d ' ')"
if [ "${RC}" -eq 0 ] && [ "${SIDE_EFFECT_BEFORE}" = "${SIDE_EFFECT_AFTER}" ]; then
    _pass "T3 STAGE 미설정 → exit 0 + no-op (RC=${RC})"
else
    _fail "T3 STAGE 미설정 가드 실패 (RC=${RC} before=${SIDE_EFFECT_BEFORE} after=${SIDE_EFFECT_AFTER})"
fi

# ─────────────────────────────────────────────────────────
# T4. completion_signal.sh — STAGE+PHASE 양쪽 설정 시 발화
#     SESSION_NAME 부재(=tmux 외부) + STAGE=05 → bridge_status.json 분기
# ─────────────────────────────────────────────────────────
BRIDGE_STATUS="${PROJECT_ROOT}/.claude/bridge_status.json"
BRIDGE_STATUS_BACKUP=""
if [ -f "${BRIDGE_STATUS}" ]; then
    BRIDGE_STATUS_BACKUP="${TEST_TMP}/bridge_status.backup.json"
    cp "${BRIDGE_STATUS}" "${BRIDGE_STATUS_BACKUP}"
fi

env -u TMUX_PANE \
    CLAUDE_COMPLETION_STAGE="05" \
    CLAUDE_COMPLETION_PHASE="test_smoke" \
    CLAUDE_COMPLETION_ACTOR="reviewer" \
    "${PROJECT_ROOT}/scripts/completion_signal.sh" >/dev/null 2>&1
RC=$?

if [ "${RC}" -eq 0 ] && [ -f "${BRIDGE_STATUS}" ]; then
    PAYLOAD_OK="$(python3 -c "
import json
d = json.load(open('${BRIDGE_STATUS}'))
ok = d.get('stage') == '05' and d.get('phase') == 'test_smoke' and d.get('status') == 'COMPLETE' and d.get('actor') == 'reviewer'
print('OK' if ok else 'BAD: ' + json.dumps(d))
" 2>&1)"
    if [ "${PAYLOAD_OK}" = "OK" ]; then
        _pass "T4 STAGE+PHASE 발화 + payload 정합 (bridge_status.json)"
    else
        _fail "T4 payload 비정합: ${PAYLOAD_OK}"
    fi
else
    _fail "T4 STAGE+PHASE 발화 실패 (RC=${RC} bridge_status_exists=$([ -f "${BRIDGE_STATUS}" ] && echo Y || echo N))"
fi

# 복원
if [ -n "${BRIDGE_STATUS_BACKUP}" ]; then
    mv "${BRIDGE_STATUS_BACKUP}" "${BRIDGE_STATUS}"
else
    rm -f "${BRIDGE_STATUS}"
fi

# ─────────────────────────────────────────────────────────
# T5. hook_stop.sh chain — env 설정 + stdin 빈 JSON
# ─────────────────────────────────────────────────────────
HOOK_DEBUG_LOG="/tmp/joneflow_hook_debug.log"
DEBUG_BACKUP=""
if [ -f "${HOOK_DEBUG_LOG}" ]; then
    DEBUG_BACKUP="${TEST_TMP}/hook_debug.backup.log"
    cp "${HOOK_DEBUG_LOG}" "${DEBUG_BACKUP}"
fi
: > "${HOOK_DEBUG_LOG}"

env -u TMUX_PANE \
    CLAUDE_COMPLETION_STAGE="05" \
    CLAUDE_COMPLETION_PHASE="test_chain" \
    CLAUDE_COMPLETION_ACTOR="reviewer" \
    bash "${PROJECT_ROOT}/scripts/hook_stop.sh" <<<'{"usage":{"input_tokens":0,"output_tokens":0}}' >/dev/null 2>&1

if grep -q "hook_stop chain: completion_signal stage=05" "${HOOK_DEBUG_LOG}"; then
    _pass "T5a env 설정 시 chain 발화 trail 기록 (hook_debug.log)"
else
    _fail "T5a env 설정 시 chain 발화 trail 누락"
fi

# env 미설정 시 chain 미발화 — 새 stdin
: > "${HOOK_DEBUG_LOG}"
env -u TMUX_PANE -u CLAUDE_COMPLETION_STAGE -u CLAUDE_COMPLETION_PHASE -u CLAUDE_COMPLETION_ACTOR \
    bash "${PROJECT_ROOT}/scripts/hook_stop.sh" <<<'{"usage":{"input_tokens":0,"output_tokens":0}}' >/dev/null 2>&1

if grep -q "hook_stop chain: completion_signal" "${HOOK_DEBUG_LOG}"; then
    _fail "T5b env 미설정인데 chain 발화 (가드 실패)"
else
    _pass "T5b env 미설정 시 chain 미발화 (가드 OK)"
fi

# 복원
if [ -n "${DEBUG_BACKUP}" ]; then
    mv "${DEBUG_BACKUP}" "${HOOK_DEBUG_LOG}"
else
    rm -f "${HOOK_DEBUG_LOG}"
fi

# 정리
rm -rf "${TEST_TMP}"

# ─────────────────────────────────────────────────────────
# SUMMARY
# ─────────────────────────────────────────────────────────
echo "─────────────────────────────────────────"
echo "SUMMARY: ${PASS} pass / ${FAIL} fail"
[ "${FAIL}" -eq 0 ] && exit 0 || exit 1
