#!/usr/bin/env bash
# test_ai_step_check_complete.sh — Unit: ai_step_check_complete 3-signal AND
# (technical_design.md Sec 6.5, Sec 14 AC-5-8).
#
# Stage 4를 샘플로 8가지 조합 truth table 검증:
#   artifact 존재 × executor exit (0|≠0) × 키워드 매칭 = 3 signal AND.
#
# Truth table (return code 기대):
#   #  artifact  last_exit  키워드  return  사유
#   1   T         0          T       0     clean
#   2   F         0          T       1     artifact 미생성
#   3   T         1          T       2     executor 실패
#   4   T         0          F       3     signal 미매치
#   5   F         1          T       1     artifact 우선 (artifact 부재로 1)
#   6   F         0          F       1     artifact 우선
#   7   T         1          F       2     executor 우선 (artifact 통과 후 exit 검사)
#   8   F         1          F       1     artifact 우선
#
# Stage 4 매핑 (Sec 6.5):
#   artifact: docs/02_planning*/plan_final.md
#   keyword : status: (pending_operator_approval|approved)

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
AI_STEP="$ROOT/scripts/ai_step.sh"

if [ ! -f "$AI_STEP" ]; then
    echo "FAIL: ai_step.sh not found: $AI_STEP" >&2
    exit 1
fi

TMPROOT=$(mktemp -d "${TMPDIR:-/tmp}/v06-ai-check.XXXXXX")
trap 'rm -rf "$TMPROOT"' EXIT HUP INT TERM

failures=0

assert_eq() {
    if [ "$2" = "$3" ]; then
        printf '  PASS %s\n' "$1"
    else
        printf '  FAIL %s: expected=[%s] got=[%s]\n' "$1" "$2" "$3"
        failures=$((failures + 1))
    fi
}

# v0.4 settings fixture (ai_step.sh source 시 settings 라이브러리 의존성 충족).
mk_fixture_v04() {
    mkdir -p "$1/.claude"
    cat > "$1/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-only",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "claude",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko"
}
EOF
}

# artifact 매칭 (키워드 통과 본문).
mk_artifact_match() {
    mkdir -p "$1/docs/02_planning_v0.6"
    cat > "$1/docs/02_planning_v0.6/plan_final.md" <<'EOF'
# Plan Final
---
status: pending_operator_approval
---
EOF
}

# artifact 비매칭 (키워드 없음).
mk_artifact_nomatch() {
    mkdir -p "$1/docs/02_planning_v0.6"
    cat > "$1/docs/02_planning_v0.6/plan_final.md" <<'EOF'
# Plan Final
(no status line — keyword absent)
EOF
}

# Source ai_step.sh in subshell, run ai_step_check_complete, capture rc.
call_check() {
    _cc_root="$1"
    _cc_stage="$2"
    _cc_last="$3"
    set +e
    ( JDEVFLOW_ROOT="$_cc_root"; export JDEVFLOW_ROOT
      # shellcheck disable=SC1090
      . "$AI_STEP"
      ai_step_check_complete "$_cc_stage" "$_cc_last"
    ) > /dev/null 2>&1
    _cc_rc=$?
    set -e
    printf '%s' "$_cc_rc"
}

# ============================================================================
# Case 1: artifact T / exit 0 / keyword T  → 0 (clean)
# ============================================================================
R1="$TMPROOT/case1"
mk_fixture_v04 "$R1"; mk_artifact_match "$R1"
rc=$(call_check "$R1" stage4 0)
assert_eq '1: T/0/T  → 0 (clean)' '0' "$rc"

# ============================================================================
# Case 2: artifact F / exit 0 / keyword T  → 1 (artifact 미생성)
# ============================================================================
R2="$TMPROOT/case2"
mk_fixture_v04 "$R2"
# artifact 의도적으로 생성 안 함 (키워드 매치 여부는 무의미 — artifact 부재).
rc=$(call_check "$R2" stage4 0)
assert_eq '2: F/0/T  → 1 (artifact 미생성)' '1' "$rc"

# ============================================================================
# Case 3: artifact T / exit 1 / keyword T  → 2 (executor 실패)
# ============================================================================
R3="$TMPROOT/case3"
mk_fixture_v04 "$R3"; mk_artifact_match "$R3"
rc=$(call_check "$R3" stage4 1)
assert_eq '3: T/1/T  → 2 (executor 실패)' '2' "$rc"

# ============================================================================
# Case 4: artifact T / exit 0 / keyword F  → 3 (signal 미매치)
# ============================================================================
R4="$TMPROOT/case4"
mk_fixture_v04 "$R4"; mk_artifact_nomatch "$R4"
rc=$(call_check "$R4" stage4 0)
assert_eq '4: T/0/F  → 3 (signal 미매치)' '3' "$rc"

# ============================================================================
# Case 5: artifact F / exit 1 / keyword T  → 1 (artifact 우선)
# ============================================================================
R5="$TMPROOT/case5"
mk_fixture_v04 "$R5"
# artifact 없음 — exit 코드와 무관하게 1.
rc=$(call_check "$R5" stage4 1)
assert_eq '5: F/1/T  → 1 (artifact 우선)' '1' "$rc"

# ============================================================================
# Case 6: artifact F / exit 0 / keyword F  → 1 (artifact 우선)
# ============================================================================
R6="$TMPROOT/case6"
mk_fixture_v04 "$R6"
rc=$(call_check "$R6" stage4 0)
assert_eq '6: F/0/F  → 1 (artifact 우선)' '1' "$rc"

# ============================================================================
# Case 7: artifact T / exit 1 / keyword F  → 2 (executor 우선; artifact 통과 후 exit 검사)
# ============================================================================
R7="$TMPROOT/case7"
mk_fixture_v04 "$R7"; mk_artifact_nomatch "$R7"
rc=$(call_check "$R7" stage4 1)
assert_eq '7: T/1/F  → 2 (executor 우선)' '2' "$rc"

# ============================================================================
# Case 8: artifact F / exit 1 / keyword F  → 1 (artifact 우선)
# ============================================================================
R8="$TMPROOT/case8"
mk_fixture_v04 "$R8"
rc=$(call_check "$R8" stage4 1)
assert_eq '8: F/1/F  → 1 (artifact 우선)' '1' "$rc"

if [ "$failures" -eq 0 ]; then
    printf 'test_ai_step_check_complete: PASS (8/8 truth table)\n'
    exit 0
else
    printf 'test_ai_step_check_complete: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
