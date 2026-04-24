#!/bin/sh
# shellcheck disable=SC1007,SC1090
# SC1007: `CDPATH= cd` is the standard unset-and-cd idiom.
# SC1090: $LIB is the dynamic path to scripts/lib/settings.sh; sourced in
#         isolated subshells so a shellcheck source= directive cannot help.
# test_settings_write_key.sh
#
# Edge cases (per tech_design Sec 11.1):
#   - rollback when source is corrupt (atomic mv preserves original on failure)
#   - missing key -> exit 5
#   - successful round-trip read=write
#
# Exits 0 if all sub-cases pass.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
LIB="$ROOT/scripts/lib/settings.sh"

TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/v06-write.XXXXXX")
trap 'rm -rf "$TMPDIR"' EXIT HUP INT TERM

failures=0

mk_fixture() {
    # mk_fixture <root>
    mkdir -p "$1/.claude"
    cat > "$1/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "workflow_mode": "desktop-only",
  "team_mode": "claude-only",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "claude",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko",
  "teammateMode": "tmux"
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

# ---- Case 1: successful write + read-back ----
R1="$TMPDIR/r1"
mk_fixture "$R1"
( JONEFLOW_ROOT="$R1"; export JONEFLOW_ROOT; . "$LIB"; settings_write_key workflow_mode 'cli-only' )
got=$( ( JONEFLOW_ROOT="$R1"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key workflow_mode ) )
assert_eq 'write workflow_mode=cli-only' 'cli-only' "$got"

# Verify other fields untouched.
got=$( ( JONEFLOW_ROOT="$R1"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key language ) )
assert_eq 'language preserved after write' 'ko' "$got"
got=$( ( JONEFLOW_ROOT="$R1"; export JONEFLOW_ROOT; . "$LIB"; settings_read_key teammateMode ) )
assert_eq 'teammateMode preserved after write' 'tmux' "$got"

# Verify uniqueness preserved.
hits=$(grep -c '^  "workflow_mode":' "$R1/.claude/settings.json" || true)
assert_eq 'workflow_mode still unique after write' '1' "$hits"

# Verify file is still valid JSON.
if python3 -c "import json; json.load(open('$R1/.claude/settings.json'))" 2>/dev/null; then
    printf '  PASS JSON valid after write\n'
else
    printf '  FAIL JSON invalid after write\n'
    failures=$((failures + 1))
fi

# ---- Case 2: missing key -> exit 5 ----
R2="$TMPDIR/r2"
mk_fixture "$R2"
# Capture original file checksum.
orig_cksum=$(cksum < "$R2/.claude/settings.json")
set +e
( JONEFLOW_ROOT="$R2"; export JONEFLOW_ROOT; . "$LIB"; settings_write_key nonexistent_key 'value' ) 2>/dev/null
rc=$?
set -e
assert_eq 'missing key returns exit 5' '5' "$rc"
new_cksum=$(cksum < "$R2/.claude/settings.json")
assert_eq 'original file preserved on missing-key failure' "$orig_cksum" "$new_cksum"

# ---- Case 3: invalid value (contains double-quote) -> exit 5 ----
R3="$TMPDIR/r3"
mk_fixture "$R3"
orig_cksum=$(cksum < "$R3/.claude/settings.json")
set +e
( JONEFLOW_ROOT="$R3"; export JONEFLOW_ROOT; . "$LIB"; settings_write_key workflow_mode 'bad"value' ) 2>/dev/null
rc=$?
set -e
assert_eq 'invalid value returns exit 5' '5' "$rc"
new_cksum=$(cksum < "$R3/.claude/settings.json")
assert_eq 'original file preserved on invalid-value failure' "$orig_cksum" "$new_cksum"

# ---- Case 4: settings.json missing -> exit 4 ----
R4="$TMPDIR/r4"
mkdir -p "$R4/.claude"  # dir but no file
set +e
( JONEFLOW_ROOT="$R4"; export JONEFLOW_ROOT; . "$LIB"; settings_write_key workflow_mode 'desktop-cli' ) 2>/dev/null
rc=$?
set -e
assert_eq 'missing settings.json returns exit 4' '4' "$rc"

# ---- Case 5: rollback on simulated mv failure (read-only target dir) ----
R5="$TMPDIR/r5"
mk_fixture "$R5"
orig_cksum=$(cksum < "$R5/.claude/settings.json")
# Make .claude directory read-only so mv into it fails.
chmod 555 "$R5/.claude"
set +e
( JONEFLOW_ROOT="$R5"; export JONEFLOW_ROOT; . "$LIB"; settings_write_key workflow_mode 'cli-only' ) 2>/dev/null
rc=$?
set -e
chmod 755 "$R5/.claude"  # restore for cleanup trap
new_cksum=$(cksum < "$R5/.claude/settings.json")
# Either failure is acceptable (rc=5 from die) — what matters is original survives.
if [ "$rc" -eq 0 ]; then
    # On some systems mv might still succeed (e.g. running as root).
    printf '  SKIP read-only mv test (rc=0, possibly root)\n'
else
    assert_eq 'original preserved when mv fails' "$orig_cksum" "$new_cksum"
fi

# ---- Case 6: write to settings_require_v04 — ensure schema gate works ----
R6="$TMPDIR/r6"
mkdir -p "$R6/.claude"
cat > "$R6/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.3",
  "language": "ko"
}
EOF
set +e
( JONEFLOW_ROOT="$R6"; export JONEFLOW_ROOT; . "$LIB"; settings_require_v04 ) 2>/dev/null
rc=$?
set -e
assert_eq 'settings_require_v04 rejects v0.3 with exit 3' '3' "$rc"

if [ "$failures" -eq 0 ]; then
    printf 'test_settings_write_key: PASS\n'
    exit 0
else
    printf 'test_settings_write_key: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
