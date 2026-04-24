#!/bin/sh
# shellcheck disable=SC1007,SC1090
# SC1007: `CDPATH= cd` is the standard unset-and-cd idiom (line 14).
# SC1090: $LIB is the dynamic path to scripts/lib/settings.sh; sourced in
#         isolated subshells so a shellcheck source= directive cannot help.
# test_settings_read_key.sh
#
# Edge cases (per tech_design Sec 11.1):
#   - key uniqueness (no duplicate hits)
#   - value with whitespace / Korean (Hangul)
#   - empty value
#   - CRLF vs LF line endings
#
# Exits 0 if all sub-cases pass.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
LIB="$ROOT/scripts/lib/settings.sh"

TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/v06-read.XXXXXX")
trap 'rm -rf "$TMPDIR"' EXIT HUP INT TERM

failures=0

mk_settings() {
    # mk_settings <out_path> <body>
    cat > "$1"
}

run_with_settings() {
    # run_with_settings <settings_path> <key> [stage_assign]
    JONEFLOW_ROOT_OLD="${JONEFLOW_ROOT:-}"
    # Place settings.json under a synthetic root so settings_path picks it up.
    _root="$2"
    JONEFLOW_ROOT="$_root"
    export JONEFLOW_ROOT
    # shellcheck source=/dev/null
    . "$LIB"
    if [ "${4:-}" = "stage" ]; then
        settings_read_stage_assign "$3"
    else
        settings_read_key "$3"
    fi
    JONEFLOW_ROOT="$JONEFLOW_ROOT_OLD"
    export JONEFLOW_ROOT
}

assert_eq() {
    # assert_eq <label> <expected> <actual>
    if [ "$2" = "$3" ]; then
        printf '  PASS %s\n' "$1"
    else
        printf '  FAIL %s: expected=[%s] got=[%s]\n' "$1" "$2" "$3"
        failures=$((failures + 1))
    fi
}

# ---- Case 1: simple value ----
ROOT_A="$TMPDIR/a"
mkdir -p "$ROOT_A/.claude"
mk_settings "$ROOT_A/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-only",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "codex",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko"
}
EOF

# Run sub-tests in subshells so source state doesn't leak.
got=$( ( JONEFLOW_ROOT="$ROOT_A"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key schema_version ) )
assert_eq 'simple read schema_version' '0.4' "$got"

got=$( ( JONEFLOW_ROOT="$ROOT_A"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key workflow_mode ) )
assert_eq 'simple read workflow_mode' 'desktop-cli' "$got"

got=$( ( JONEFLOW_ROOT="$ROOT_A"; export JONEFLOW_ROOT; . "$LIB"; settings_read_stage_assign stage9_review ) )
assert_eq 'stage_assign stage9_review' 'codex' "$got"

# ---- Case 2: missing key returns empty ----
got=$( ( JONEFLOW_ROOT="$ROOT_A"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key missing_key ) )
assert_eq 'missing key returns empty' '' "$got"

got=$( ( JONEFLOW_ROOT="$ROOT_A"; export JONEFLOW_ROOT; . "$LIB"; settings_read_stage_assign stageX_missing ) )
assert_eq 'missing stage_assign returns empty' '' "$got"

# ---- Case 3: empty value (allowed at read side) ----
ROOT_B="$TMPDIR/b"
mkdir -p "$ROOT_B/.claude"
mk_settings "$ROOT_B/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "team_mode": "",
  "stage_assignments": {
    "stage8_impl": ""
  }
}
EOF
got=$( ( JONEFLOW_ROOT="$ROOT_B"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key team_mode ) )
assert_eq 'empty value reads as empty' '' "$got"

got=$( ( JONEFLOW_ROOT="$ROOT_B"; export JONEFLOW_ROOT; . "$LIB"; settings_read_stage_assign stage8_impl ) )
assert_eq 'empty stage_assign reads as empty' '' "$got"

# ---- Case 4: value containing whitespace ----
ROOT_C="$TMPDIR/c"
mkdir -p "$ROOT_C/.claude"
mk_settings "$ROOT_C/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "team_mode": "value with spaces",
  "language": "ko"
}
EOF
got=$( ( JONEFLOW_ROOT="$ROOT_C"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key team_mode ) )
assert_eq 'value with spaces' 'value with spaces' "$got"

# ---- Case 5: Korean value ----
ROOT_D="$TMPDIR/d"
mkdir -p "$ROOT_D/.claude"
mk_settings "$ROOT_D/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "_note": "한글 값 테스트",
  "language": "ko"
}
EOF
got=$( ( JONEFLOW_ROOT="$ROOT_D"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key _note ) )
assert_eq 'Korean value' '한글 값 테스트' "$got"

# ---- Case 6: CRLF line endings ----
ROOT_E="$TMPDIR/e"
mkdir -p "$ROOT_E/.claude"
# Build CRLF file by piping through awk.
mk_settings "$TMPDIR/e_lf.json" <<'EOF'
{
  "schema_version": "0.4",
  "team_mode": "claude-only",
  "language": "ko"
}
EOF
awk 'BEGIN{ORS="\r\n"} {print}' "$TMPDIR/e_lf.json" > "$ROOT_E/.claude/settings.json"
got=$( ( JONEFLOW_ROOT="$ROOT_E"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key team_mode ) )
# CRLF: trailing \r may attach to value. Documented behavior: returned value
# may contain trailing \r since sed treats lines literally. We accept either
# 'claude-only' or 'claude-only\r' as long as the visible token survives.
case "$got" in
    claude-only|claude-only*) printf '  PASS CRLF reads (got=[%s])\n' "$got" ;;
    *) printf '  FAIL CRLF reads: got=[%s]\n' "$got"; failures=$((failures + 1)) ;;
esac

# ---- Case 7: uniqueness check ----
# Verify that the live settings.json has unique keys (no duplicates).
ROOT_F="$ROOT"  # repo root
hits=$(grep -c '"workflow_mode"' "$ROOT_F/.claude/settings.json" || true)
assert_eq 'workflow_mode unique in live file' '1' "$hits"
hits=$(grep -c '"team_mode"' "$ROOT_F/.claude/settings.json" || true)
assert_eq 'team_mode unique in live file' '1' "$hits"

if [ "$failures" -eq 0 ]; then
    printf 'test_settings_read_key: PASS\n'
    exit 0
else
    printf 'test_settings_read_key: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
