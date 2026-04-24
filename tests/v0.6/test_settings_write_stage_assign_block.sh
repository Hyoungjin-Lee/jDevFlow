#!/bin/sh
# shellcheck disable=SC1007,SC1090
# SC1007: `CDPATH= cd` is the standard unset-and-cd idiom.
# SC1090: $LIB is the dynamic path to scripts/lib/settings.sh; sourced in
#         isolated subshells so a shellcheck source= directive cannot help.
# test_settings_write_stage_assign_block.sh
#
# Validates Sec 2.5 mapping table. Each of 3 team_modes -> exact 4 stage
# assignment lines. Round-trip verifies via settings_read_stage_assign.
#
# Exits 0 if all sub-cases pass.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
LIB="$ROOT/scripts/lib/settings.sh"

TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/v06-block.XXXXXX")
trap 'rm -rf "$TMPDIR"' EXIT HUP INT TERM

failures=0

mk_fixture() {
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

assert_eq() {
    if [ "$2" = "$3" ]; then
        printf '  PASS %s\n' "$1"
    else
        printf '  FAIL %s: expected=[%s] got=[%s]\n' "$1" "$2" "$3"
        failures=$((failures + 1))
    fi
}

# verify_block <root> <expected_team_mode> <s8> <s9> <s10> <s11>
verify_block() {
    _vb_root="$1"
    _vb_mode="$2"
    _vb_s8="$3"
    _vb_s9="$4"
    _vb_s10="$5"
    _vb_s11="$6"

    got=$( ( JDEVFLOW_ROOT="$_vb_root"; export JDEVFLOW_ROOT; . "$LIB"; settings_read_key team_mode ) )
    assert_eq "team_mode=$_vb_mode" "$_vb_mode" "$got"

    got=$( ( JDEVFLOW_ROOT="$_vb_root"; export JDEVFLOW_ROOT; . "$LIB"; settings_read_stage_assign stage8_impl ) )
    assert_eq "  stage8_impl=$_vb_s8" "$_vb_s8" "$got"

    got=$( ( JDEVFLOW_ROOT="$_vb_root"; export JDEVFLOW_ROOT; . "$LIB"; settings_read_stage_assign stage9_review ) )
    assert_eq "  stage9_review=$_vb_s9" "$_vb_s9" "$got"

    got=$( ( JDEVFLOW_ROOT="$_vb_root"; export JDEVFLOW_ROOT; . "$LIB"; settings_read_stage_assign stage10_fix ) )
    assert_eq "  stage10_fix=$_vb_s10" "$_vb_s10" "$got"

    got=$( ( JDEVFLOW_ROOT="$_vb_root"; export JDEVFLOW_ROOT; . "$LIB"; settings_read_stage_assign stage11_verify ) )
    assert_eq "  stage11_verify=$_vb_s11" "$_vb_s11" "$got"
}

# ---- Case A: claude-only mapping ----
RA="$TMPDIR/a"
mk_fixture "$RA"
( JDEVFLOW_ROOT="$RA"; export JDEVFLOW_ROOT; . "$LIB"; settings_write_stage_assign_block 'claude-only' )
verify_block "$RA" 'claude-only' 'claude' 'claude' 'claude' 'claude'

# ---- Case B: claude-impl-codex-review mapping ----
RB="$TMPDIR/b"
mk_fixture "$RB"
( JDEVFLOW_ROOT="$RB"; export JDEVFLOW_ROOT; . "$LIB"; settings_write_stage_assign_block 'claude-impl-codex-review' )
verify_block "$RB" 'claude-impl-codex-review' 'claude' 'codex' 'claude' 'claude'

# ---- Case C: codex-impl-claude-review mapping ----
RC="$TMPDIR/c"
mk_fixture "$RC"
( JDEVFLOW_ROOT="$RC"; export JDEVFLOW_ROOT; . "$LIB"; settings_write_stage_assign_block 'codex-impl-claude-review' )
verify_block "$RC" 'codex-impl-claude-review' 'codex' 'claude' 'codex' 'claude'

# ---- Case D: invalid team_mode -> exit 2 ----
RD="$TMPDIR/d"
mk_fixture "$RD"
orig_cksum=$(cksum < "$RD/.claude/settings.json")
set +e
( JDEVFLOW_ROOT="$RD"; export JDEVFLOW_ROOT; . "$LIB"; settings_write_stage_assign_block 'unknown-mode' ) 2>/dev/null
rc=$?
set -e
assert_eq 'invalid team_mode returns exit 2' '2' "$rc"
new_cksum=$(cksum < "$RD/.claude/settings.json")
assert_eq 'original preserved on invalid team_mode' "$orig_cksum" "$new_cksum"

# ---- Case E: round-trip — switch from A to C and back to A preserves uniqueness ----
RE="$TMPDIR/e"
mk_fixture "$RE"
( JDEVFLOW_ROOT="$RE"; export JDEVFLOW_ROOT; . "$LIB"; settings_write_stage_assign_block 'codex-impl-claude-review' )
( JDEVFLOW_ROOT="$RE"; export JDEVFLOW_ROOT; . "$LIB"; settings_write_stage_assign_block 'claude-only' )
verify_block "$RE" 'claude-only' 'claude' 'claude' 'claude' 'claude'

# Uniqueness check after round-trip.
for k in workflow_mode team_mode; do
    hits=$(grep -c '^  "'"$k"'":' "$RE/.claude/settings.json" || true)
    assert_eq "$k unique after round-trip" '1' "$hits"
done
for k in stage8_impl stage9_review stage10_fix stage11_verify; do
    hits=$(grep -c '^    "'"$k"'":' "$RE/.claude/settings.json" || true)
    assert_eq "stage_assignments.$k unique after round-trip" '1' "$hits"
done

# JSON validity after round-trip.
if python3 -c "import json; json.load(open('$RE/.claude/settings.json'))" 2>/dev/null; then
    printf '  PASS JSON valid after round-trip\n'
else
    printf '  FAIL JSON invalid after round-trip\n'
    failures=$((failures + 1))
fi

# ---- Case F: schema corruption (missing stage9_review key) -> exit 5 ----
RF="$TMPDIR/f"
mkdir -p "$RF/.claude"
cat > "$RF/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-only",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko"
}
EOF
orig_cksum=$(cksum < "$RF/.claude/settings.json")
set +e
( JDEVFLOW_ROOT="$RF"; export JDEVFLOW_ROOT; . "$LIB"; settings_write_stage_assign_block 'claude-impl-codex-review' ) 2>/dev/null
rc=$?
set -e
assert_eq 'missing stage_assignments key returns exit 5' '5' "$rc"
new_cksum=$(cksum < "$RF/.claude/settings.json")
assert_eq 'original preserved on schema corruption' "$orig_cksum" "$new_cksum"

if [ "$failures" -eq 0 ]; then
    printf 'test_settings_write_stage_assign_block: PASS\n'
    exit 0
else
    printf 'test_settings_write_stage_assign_block: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
