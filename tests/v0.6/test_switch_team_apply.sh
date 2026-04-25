#!/usr/bin/env bash
# test_switch_team_apply.sh — Integration: 3종 team_mode 전환 → stage_assignments
# Sec.2.5 매핑표 검증 (AC-5-1, AC-5-2, AC-5-12).
#
# Cases:
#   A. claude-only          → s8/s9/s10/s11 = claude/claude/claude/claude
#   B. claude-impl-codex-review → claude/codex/claude/claude
#   C. codex-impl-claude-review → codex/claude/codex/claude
#   D. invalid mode 인자 → exit 2, 원본 보존
#   E. 라운드트립 (B → C → A) 후 키 유일성 + JSON validity
#   F. AC-5-2: pending_team_mode 부재
#
# Bg detection bypassed: 테스트 fixture는 새 tmp ROOT에서 격리 실행하지만
# 호스트의 실제 백그라운드 claude/codex 프로세스는 격리되지 않음.
# 그래서 본 테스트는 항상 --force를 사용해 bg 게이트를 우회한다.
# bg 게이트의 본질 검증은 test_switch_team_bg.sh가 담당.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
SWITCH_SCRIPT="$ROOT/scripts/switch_team.sh"

if [ ! -f "$SWITCH_SCRIPT" ]; then
    echo "FAIL: switch_team.sh not found: $SWITCH_SCRIPT" >&2
    exit 1
fi

TMPROOT=$(mktemp -d "${TMPDIR:-/tmp}/v06-switch-apply.XXXXXX")
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

mk_v04_fixture() {
    mkdir -p "$1/.claude"
    cat > "$1/.claude/settings.json" <<'EOF'
{
  "_comment": "v0.4 fixture for switch_team apply test",
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-only",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "claude",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko",
  "teammateMode": "tmux",
  "agents": {
    "planner": {
      "stages": [2, 3, 4]
    }
  }
}
EOF
}

run_switch() {
    _rs_root="$1"
    shift
    ( JONEFLOW_ROOT="$_rs_root"; export JONEFLOW_ROOT
      bash "$SWITCH_SCRIPT" "$@" --force
    ) > "$_rs_root/switch.stdout" 2> "$_rs_root/switch.stderr"
}

read_field() {
    sed -n 's/^  "'"$2"'": *"\([^"]*\)".*/\1/p' "$1/.claude/settings.json" | sed -n '1p'
}

read_stage() {
    sed -n 's/^    "'"$2"'": *"\([^"]*\)".*/\1/p' "$1/.claude/settings.json" | sed -n '1p'
}

# ============================================================================
# Case A: claude-only
# ============================================================================
RA="$TMPROOT/case_a"
mk_v04_fixture "$RA"
run_switch "$RA" claude-only

assert_eq 'A: team_mode=claude-only'         'claude-only' "$(read_field "$RA" team_mode)"
assert_eq 'A: stage8_impl=claude'            'claude'      "$(read_stage "$RA" stage8_impl)"
assert_eq 'A: stage9_review=claude'          'claude'      "$(read_stage "$RA" stage9_review)"
assert_eq 'A: stage10_fix=claude'            'claude'      "$(read_stage "$RA" stage10_fix)"
assert_eq 'A: stage11_verify=claude'         'claude'      "$(read_stage "$RA" stage11_verify)"
assert_eq 'A: agents.planner preserved'      '1' "$( grep -c '"planner":' "$RA/.claude/settings.json" )"

# ============================================================================
# Case B: claude-impl-codex-review
# ============================================================================
RB="$TMPROOT/case_b"
mk_v04_fixture "$RB"
run_switch "$RB" claude-impl-codex-review

assert_eq 'B: team_mode=claude-impl-codex-review' 'claude-impl-codex-review' "$(read_field "$RB" team_mode)"
assert_eq 'B: stage8_impl=claude'                  'claude' "$(read_stage "$RB" stage8_impl)"
assert_eq 'B: stage9_review=codex'                 'codex'  "$(read_stage "$RB" stage9_review)"
assert_eq 'B: stage10_fix=claude'                  'claude' "$(read_stage "$RB" stage10_fix)"
assert_eq 'B: stage11_verify=claude'               'claude' "$(read_stage "$RB" stage11_verify)"

# ============================================================================
# Case C: codex-impl-claude-review
# ============================================================================
RC="$TMPROOT/case_c"
mk_v04_fixture "$RC"
run_switch "$RC" codex-impl-claude-review

assert_eq 'C: team_mode=codex-impl-claude-review' 'codex-impl-claude-review' "$(read_field "$RC" team_mode)"
assert_eq 'C: stage8_impl=codex'                   'codex'  "$(read_stage "$RC" stage8_impl)"
assert_eq 'C: stage9_review=claude'                'claude' "$(read_stage "$RC" stage9_review)"
assert_eq 'C: stage10_fix=codex'                   'codex'  "$(read_stage "$RC" stage10_fix)"
assert_eq 'C: stage11_verify=claude'               'claude' "$(read_stage "$RC" stage11_verify)"

# ============================================================================
# Case D: invalid mode → exit 2, 원본 보존
# ============================================================================
RD="$TMPROOT/case_d"
mk_v04_fixture "$RD"
orig_cksum=$(cksum < "$RD/.claude/settings.json")
set +e
( JONEFLOW_ROOT="$RD"; export JONEFLOW_ROOT
  bash "$SWITCH_SCRIPT" unknown-mode --force ) > "$RD/d.stdout" 2> "$RD/d.stderr"
rc=$?
set -e
assert_eq 'D: invalid mode → exit 2' '2' "$rc"
new_cksum=$(cksum < "$RD/.claude/settings.json")
assert_eq 'D: original preserved on invalid mode' "$orig_cksum" "$new_cksum"

# ============================================================================
# Case E: 라운드트립 + 유일성 + JSON validity
# ============================================================================
RE="$TMPROOT/case_e"
mk_v04_fixture "$RE"
run_switch "$RE" claude-impl-codex-review
run_switch "$RE" codex-impl-claude-review
run_switch "$RE" claude-only

assert_eq 'E: round-trip ends at claude-only' 'claude-only' "$(read_field "$RE" team_mode)"
assert_eq 'E: stage8_impl reverted to claude' 'claude'      "$(read_stage "$RE" stage8_impl)"

for k in workflow_mode team_mode; do
    hits=$(grep -c '^  "'"$k"'":' "$RE/.claude/settings.json" || true)
    assert_eq "E: $k unique after round-trip" '1' "$hits"
done
for k in stage8_impl stage9_review stage10_fix stage11_verify; do
    hits=$(grep -c '^    "'"$k"'":' "$RE/.claude/settings.json" || true)
    assert_eq "E: stage_assignments.$k unique after round-trip" '1' "$hits"
done

if python3 -c "import json; json.load(open('$RE/.claude/settings.json'))" 2>/dev/null; then
    printf '  PASS E: JSON valid after round-trip\n'
else
    printf '  FAIL E: JSON invalid after round-trip\n'
    failures=$((failures + 1))
fi

# ============================================================================
# Case F: AC-5-2 — pending_team_mode 부재 across all written files.
# ============================================================================
for _f in "$RA" "$RB" "$RC" "$RE"; do
    _h=$(grep -c 'pending_team_mode' "$_f/.claude/settings.json" || true)
    assert_eq "F: pending_team_mode absent in $(basename "$_f")" '0' "$_h"
done

if [ "$failures" -eq 0 ]; then
    printf 'test_switch_team_apply: PASS\n'
    exit 0
else
    printf 'test_switch_team_apply: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
