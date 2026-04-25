#!/usr/bin/env bash
# test_ai_step_resolve_executor.sh — Unit: ai_step_resolve_executor
# (technical_design.md Sec 6.4, Sec 14 AC-5-7).
#
# Cases:
#   1. claude 매핑     — stage8_impl=claude    → stdout=claude, exit 0
#   2. codex 매핑      — stage9_review=codex   → stdout=codex,  exit 0
#   3. 빈 값 (키 부재) — stage10_fix 라인 삭제 → exit 3, stderr "키 누락"
#   4. 오타 값         — stage11_verify=clude  → exit 2, stderr "알 수 없는 executor"
#   5. 알 수 없는 stage 키 — `not_a_stage`    → exit 3 (빈 값 path 동일)

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
AI_STEP="$ROOT/scripts/ai_step.sh"

if [ ! -f "$AI_STEP" ]; then
    echo "FAIL: ai_step.sh not found: $AI_STEP" >&2
    exit 1
fi

TMPROOT=$(mktemp -d "${TMPDIR:-/tmp}/v06-ai-resolve.XXXXXX")
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

assert_grep() {
    _label="$1"; _pattern="$2"; _file="$3"
    if grep -q -- "$_pattern" "$_file"; then
        printf '  PASS %s\n' "$_label"
    else
        printf '  FAIL %s: pattern=[%s] not found in %s\n' "$_label" "$_pattern" "$_file"
        failures=$((failures + 1))
    fi
}

# v0.4 fixture (full stage_assignments block).
mk_fixture_v04() {
    mkdir -p "$1/.claude"
    cat > "$1/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-impl-codex-review",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "codex",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko"
}
EOF
}

# Source ai_step.sh in subshell with JDEVFLOW_ROOT set; capture stdout/exit.
# Use `bash -c` subshell + set +e to capture exit reliably.
call_resolve() {
    _cr_root="$1"
    _cr_key="$2"
    _cr_out="$3"
    _cr_err="$4"
    set +e
    ( JDEVFLOW_ROOT="$_cr_root"; export JDEVFLOW_ROOT
      # shellcheck disable=SC1090
      . "$AI_STEP"
      ai_step_resolve_executor "$_cr_key"
    ) > "$_cr_out" 2> "$_cr_err"
    _cr_rc=$?
    set -e
    printf '%s' "$_cr_rc"
}

# ============================================================================
# Case 1: claude 매핑 (stage8_impl)
# ============================================================================
RA="$TMPROOT/case1"
mk_fixture_v04 "$RA"
rc=$(call_resolve "$RA" stage8_impl "$RA/out" "$RA/err")
assert_eq '1: claude 매핑 exit 0'   '0'      "$rc"
assert_eq '1: stdout=claude'        'claude' "$(cat "$RA/out")"

# ============================================================================
# Case 2: codex 매핑 (stage9_review)
# ============================================================================
RB="$TMPROOT/case2"
mk_fixture_v04 "$RB"
rc=$(call_resolve "$RB" stage9_review "$RB/out" "$RB/err")
assert_eq '2: codex 매핑 exit 0'    '0'     "$rc"
assert_eq '2: stdout=codex'         'codex' "$(cat "$RB/out")"

# ============================================================================
# Case 3: 빈 값 (stage10_fix 라인 삭제) → exit 3 + 키 누락 메시지
# ============================================================================
RC="$TMPROOT/case3"
mk_fixture_v04 "$RC"
# stage10_fix 라인을 통째로 제거 (POSIX sed; in-place 대신 temp + mv).
SC="$RC/.claude/settings.json"
sed '/^    "stage10_fix":/d' "$SC" > "$SC.tmp" && mv "$SC.tmp" "$SC"

rc=$(call_resolve "$RC" stage10_fix "$RC/out" "$RC/err")
assert_eq '3: 빈 값 → exit 3' '3' "$rc"
assert_grep '3: stderr "키 누락" 메시지' 'stage_assignments.stage10_fix 키 누락' "$RC/err"

# ============================================================================
# Case 4: 오타 값 (stage11_verify=clude) → exit 2 + 알 수 없는 executor 메시지
# ============================================================================
RD="$TMPROOT/case4"
mk_fixture_v04 "$RD"
SD="$RD/.claude/settings.json"
# stage11_verify 값을 "clude"로 교체 (atomic).
sed 's|^    "stage11_verify": *"[^"]*"|    "stage11_verify": "clude"|' "$SD" > "$SD.tmp" && mv "$SD.tmp" "$SD"

rc=$(call_resolve "$RD" stage11_verify "$RD/out" "$RD/err")
assert_eq '4: 오타 값 → exit 2' '2' "$rc"
assert_grep '4: stderr "알 수 없는 executor"' '알 수 없는 executor' "$RD/err"
assert_grep "4: stderr에 'clude' 포함"        "clude"               "$RD/err"

# ============================================================================
# Case 5: 알 수 없는 stage 키 (정의되지 않은 키) → 빈 값 path와 동일하게 exit 3
# ============================================================================
RE="$TMPROOT/case5"
mk_fixture_v04 "$RE"
rc=$(call_resolve "$RE" not_a_stage "$RE/out" "$RE/err")
assert_eq '5: 알 수 없는 stage 키 → exit 3' '3' "$rc"
assert_grep '5: stderr "키 누락" 메시지' 'stage_assignments.not_a_stage 키 누락' "$RE/err"

if [ "$failures" -eq 0 ]; then
    printf 'test_ai_step_resolve_executor: PASS\n'
    exit 0
else
    printf 'test_ai_step_resolve_executor: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
