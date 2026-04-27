#!/bin/sh
# v0.6.6 의제 #4 reviewer — settings.sh / ai_step.sh schema v0.5 호환 스모크 테스트
#
# 검증 대상 (drafter f5cc549 영구화):
#   T1. settings_require_v05 (현재 schema 0.5 = PASS)
#   T2. settings_require_v04 grace period (schema 0.5 허용)
#   T3. settings_read_stage_assign_compat — neo 우선 (stage11_impl)
#   T4. settings_read_stage_assign_compat — legacy fallback (neo 없을 때 stage9_review)
#   T5. settings_read_stage_assign_compat — neo+legacy 둘 다 없음 → 빈 문자열
#   T6. _ai_step_assign_key_for_16 — 16-stage 마커 매핑 4종
#   T7. _ai_step_assign_key_for — 13-stage 회귀 OK
#   T8. _ai_step_read_assign_compat alias 동작
#   T9. _ai_step_read_assign_compat 인자 누락 가드
#
# 사용:
#   sh scripts/test_settings_v05_compat.sh
#   exit 0 = 전체 PASS, exit 1 = 1건 이상 FAIL.
#
# 부수효과 없음 (read-only 검증). settings.json 변경 X.

set -u

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "${PROJECT_ROOT}/scripts/lib/settings.sh"

PASS=0
FAIL=0
_pass() { echo "PASS $*"; PASS=$((PASS+1)); }
_fail() { echo "FAIL $*"; FAIL=$((FAIL+1)); }

# T1
( settings_require_v05 ) 2>/dev/null
if [ $? -eq 0 ]; then _pass "T1 settings_require_v05 (schema=0.5)"
else _fail "T1 settings_require_v05 (schema=0.5)"; fi

# T2
( settings_require_v04 ) 2>/dev/null
if [ $? -eq 0 ]; then _pass "T2 settings_require_v04 grace (schema=0.5 허용)"
else _fail "T2 settings_require_v04 grace"; fi

# T3
v=$(settings_read_stage_assign_compat stage11_impl stage8_impl)
if [ "$v" = "claude" ]; then _pass "T3 compat NEO 우선 (stage11_impl=claude)"
else _fail "T3 compat NEO got '$v'"; fi

# T4
v=$(settings_read_stage_assign_compat nonexistent_neo stage9_review)
if [ "$v" = "codex" ]; then _pass "T4 compat LEGACY fallback (stage9_review=codex)"
else _fail "T4 compat LEGACY got '$v'"; fi

# T5
v=$(settings_read_stage_assign_compat nonexistent_a nonexistent_b)
if [ -z "$v" ]; then _pass "T5 compat both missing → empty"
else _fail "T5 compat got '$v' (expected empty)"; fi

# ai_step.sh helpers — source 후 함수 직접 호출
. "${PROJECT_ROOT}/scripts/ai_step.sh" 2>/dev/null || true

# T6
k=$(_ai_step_assign_key_for_16 stage11)
if [ "$k" = "stage11_impl" ]; then _pass "T6a stage11→stage11_impl"
else _fail "T6a got '$k'"; fi
k=$(_ai_step_assign_key_for_16 stage12)
if [ "$k" = "stage12_review" ]; then _pass "T6b stage12→stage12_review"
else _fail "T6b got '$k'"; fi
k=$(_ai_step_assign_key_for_16 stage13)
if [ "$k" = "stage13_fix" ]; then _pass "T6c stage13→stage13_fix"
else _fail "T6c got '$k'"; fi
k=$(_ai_step_assign_key_for_16 stage14)
if [ "$k" = "stage14_verify" ]; then _pass "T6d stage14→stage14_verify"
else _fail "T6d got '$k'"; fi

# T7 — 13-stage 회귀
k=$(_ai_step_assign_key_for stage8)
if [ "$k" = "stage8_impl" ]; then _pass "T7 13-stage 회귀 OK (stage8→stage8_impl)"
else _fail "T7 got '$k'"; fi

# T8
v=$(_ai_step_read_assign_compat stage12_review stage9_review)
if [ "$v" = "codex" ]; then _pass "T8 ai_step compat alias (codex)"
else _fail "T8 got '$v'"; fi

# T9
v=$(_ai_step_read_assign_compat "" "")
if [ -z "$v" ]; then _pass "T9 ai_step compat 인자 누락 가드 (empty)"
else _fail "T9 got '$v'"; fi

echo "─────────────────────────────────────"
echo "SUMMARY: ${PASS} pass / ${FAIL} fail"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
