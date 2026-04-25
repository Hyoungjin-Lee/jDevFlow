#!/usr/bin/env bash
# test_init_project_cases.sh — Integration test for scripts/init_project.sh
# v0.6 settings.json setup (technical_design.md Sec 3.3, Sec 11.1).
#
# Cases:
#   A. settings.json absent      → --no-prompt emits v0.4 skeleton.
#   B. settings.json v0.3 fixture → --no-prompt upgrades, preserves v0.3 fields.
#   C. settings.json v0.4 fixture → --no-prompt skips (returns 0, no diff).
#   D. settings.json v0.4 fixture → --force-reinit updates v0.6 fields in-place,
#                                   preserves agents.* (F-5-a-style guarantee).
#   E. AC-5-2 grep-zero: 'pending_team_mode' must not appear anywhere we emit.
#   F. AC-5-1: each new v0.4 key appears exactly once after every case.
#
# Each case runs in an isolated tmp dir via JONEFLOW_ROOT override.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
INIT_SCRIPT="$ROOT/scripts/init_project.sh"

if [ ! -f "$INIT_SCRIPT" ]; then
    echo "FAIL: init_project.sh not found: $INIT_SCRIPT" >&2
    exit 1
fi

TMPROOT=$(mktemp -d "${TMPDIR:-/tmp}/v06-init-cases.XXXXXX")
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
    if grep -q "$_pattern" "$_file"; then
        printf '  PASS %s\n' "$_label"
    else
        printf '  FAIL %s: pattern=[%s] not found in %s\n' "$_label" "$_pattern" "$_file"
        failures=$((failures + 1))
    fi
}

assert_grep_count() {
    _label="$1"; _pattern="$2"; _file="$3"; _expected="$4"
    _got=$(grep -c "$_pattern" "$_file" || true)
    assert_eq "$_label (count of $_pattern)" "$_expected" "$_got"
}

# Run init_project.sh with --no-prompt in isolated root. Suppresses noisy stdout.
run_init() {
    _ri_root="$1"
    shift
    mkdir -p "$_ri_root"
    ( JONEFLOW_ROOT="$_ri_root"; export JONEFLOW_ROOT
      bash "$INIT_SCRIPT" --no-prompt "$@" ) > "$_ri_root/init.stdout" 2> "$_ri_root/init.stderr"
}

# Each case runs in its own subdir so mktemp -d artifacts cleanup neatly.

# ============================================================================
# Case A: settings.json absent → emit fresh v0.4 skeleton.
# ============================================================================
RA="$TMPROOT/case_a"
run_init "$RA"
SA="$RA/.claude/settings.json"

assert_eq 'A: settings.json created'              '1' "$( [ -f "$SA" ] && echo 1 || echo 0 )"
assert_grep_count 'A: schema_version=0.4 unique'  '"schema_version": "0.4"' "$SA" '1'
assert_grep_count 'A: workflow_mode unique'       '^  "workflow_mode":'      "$SA" '1'
assert_grep_count 'A: team_mode unique'           '^  "team_mode":'          "$SA" '1'
assert_grep_count 'A: stage8_impl unique'         '^    "stage8_impl":'      "$SA" '1'
assert_grep_count 'A: stage9_review unique'       '^    "stage9_review":'    "$SA" '1'
assert_grep_count 'A: stage10_fix unique'         '^    "stage10_fix":'      "$SA" '1'
assert_grep_count 'A: stage11_verify unique'      '^    "stage11_verify":'   "$SA" '1'
assert_grep 'A: --no-prompt default workflow=desktop-only' '"workflow_mode": "desktop-only"' "$SA"
assert_grep 'A: --no-prompt default team=claude-only'      '"team_mode": "claude-only"'      "$SA"
assert_grep 'A: stage11_verify=claude'                     '"stage11_verify": "claude"'      "$SA"
# AC-5-2: pending_team_mode 부재.
_hits=$(grep -c 'pending_team_mode' "$SA" || true)
assert_eq 'A: pending_team_mode absent (AC-5-2)' '0' "$_hits"
# JSON validity
if python3 -c "import json; json.load(open('$SA'))" 2>/dev/null; then
    printf '  PASS A: JSON valid\n'
else
    printf '  FAIL A: JSON invalid\n'; failures=$((failures + 1))
fi

# ============================================================================
# Case B: v0.3 fixture → upgrade to v0.4, preserve v0.3 fields (F-5-a).
# ============================================================================
RB="$TMPROOT/case_b"
mkdir -p "$RB/.claude"
cat > "$RB/.claude/settings.json" <<'EOF'
{
  "_comment": "v0.3 sample (pre-CLI-automation).",
  "schema_version": "0.3",
  "language": "ko",
  "teammateMode": "tmux",
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "agents": {
    "planner": {
      "stages": [2, 3, 4],
      "models": {
        "stage_2": "claude-opus-4-7"
      }
    }
  }
}
EOF
# Capture v0.3 lines that must survive (whole file minus schema_version line).
grep -v 'schema_version' "$RB/.claude/settings.json" > "$RB/v03_preserve.txt"

run_init "$RB"
SB="$RB/.claude/settings.json"

assert_grep_count 'B: schema_version bumped to 0.4 (unique)' '"schema_version": "0.4"' "$SB" '1'
assert_grep_count 'B: schema_version 0.3 removed'            '"schema_version": "0.3"' "$SB" '0'
assert_grep_count 'B: workflow_mode inserted'  '^  "workflow_mode":'   "$SB" '1'
assert_grep_count 'B: team_mode inserted'      '^  "team_mode":'       "$SB" '1'
assert_grep_count 'B: stage_assignments block' '^  "stage_assignments": {' "$SB" '1'
assert_grep_count 'B: stage8_impl present'     '^    "stage8_impl":'   "$SB" '1'

# v0.3 field preservation (AC-5-10 spirit, Stage 9 책임).
for _line_pattern in '"_comment":' '"language":' '"teammateMode":' '"CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS":' '"planner":' '"stages":' '"claude-opus-4-7"'; do
    assert_grep "B: v0.3 line preserved: $_line_pattern" "$_line_pattern" "$SB"
done

# AC-5-2 + JSON validity post-upgrade.
_hits=$(grep -c 'pending_team_mode' "$SB" || true)
assert_eq 'B: pending_team_mode absent post-upgrade' '0' "$_hits"
if python3 -c "import json; json.load(open('$SB'))" 2>/dev/null; then
    printf '  PASS B: JSON valid post-upgrade\n'
else
    printf '  FAIL B: JSON invalid post-upgrade\n'; failures=$((failures + 1))
fi

# ============================================================================
# Case C: v0.4 fixture, no --force-reinit → skip (no mutation).
# ============================================================================
RC="$TMPROOT/case_c"
mkdir -p "$RC/.claude"
cat > "$RC/.claude/settings.json" <<'EOF'
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
  "language": "ko",
  "agents": {}
}
EOF
SC="$RC/.claude/settings.json"
orig_cksum=$(cksum < "$SC")
run_init "$RC"
new_cksum=$(cksum < "$SC")
assert_eq 'C: file unchanged when v0.4 + no --force-reinit' "$orig_cksum" "$new_cksum"
assert_grep 'C: skip notice printed' '이미 v0.4로 초기화됨' "$RC/init.stdout"

# ============================================================================
# Case D: v0.4 fixture + --force-reinit → in-place update of v0.6 fields,
#         agents.* preserved.
# ============================================================================
RD="$TMPROOT/case_d"
mkdir -p "$RD/.claude"
cat > "$RD/.claude/settings.json" <<'EOF'
{
  "_comment": "fixture v0.4 with rich agents block",
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-impl-codex-review",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "codex",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko",
  "teammateMode": "tmux",
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "agents": {
    "planner": {
      "stages": [2, 3, 4]
    }
  }
}
EOF
SD="$RD/.claude/settings.json"
run_init "$RD" --force-reinit

# --no-prompt defaults are workflow=desktop-only, team=claude-only.
assert_grep 'D: workflow_mode rewritten to default'   '"workflow_mode": "desktop-only"' "$SD"
assert_grep 'D: team_mode rewritten to default'       '"team_mode": "claude-only"'      "$SD"
assert_grep 'D: stage9_review rewritten to claude (mapping)' '"stage9_review": "claude"' "$SD"
# agents.* preservation (the whole point of in-place update).
assert_grep 'D: agents.planner preserved' '"planner":' "$SD"
assert_grep 'D: _comment preserved'       '"_comment": "fixture v0.4 with rich agents block"' "$SD"
# Uniqueness still holds.
assert_grep_count 'D: workflow_mode unique post-reinit' '^  "workflow_mode":' "$SD" '1'
assert_grep_count 'D: team_mode unique post-reinit'     '^  "team_mode":'     "$SD" '1'
# JSON validity.
if python3 -c "import json; json.load(open('$SD'))" 2>/dev/null; then
    printf '  PASS D: JSON valid post-reinit\n'
else
    printf '  FAIL D: JSON invalid post-reinit\n'; failures=$((failures + 1))
fi

# ============================================================================
# Case E: AC-5-2 file-wide pending_team_mode grep across every case file.
# ============================================================================
for _f in "$SA" "$SB" "$SD"; do
    _h=$(grep -c 'pending_team_mode' "$_f" || true)
    assert_eq "E: pending_team_mode absent across $(basename "$(dirname "$(dirname "$_f")")")" '0' "$_h"
done

if [ "$failures" -eq 0 ]; then
    printf 'test_init_project_cases: PASS\n'
    exit 0
else
    printf 'test_init_project_cases: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
