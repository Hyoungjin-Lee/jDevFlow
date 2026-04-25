#!/usr/bin/env bash
# test_switch_team_status.sh — `--status` 모드 필드 전체 출력 검증.
#
# Reference: technical_design.md Sec 4.8.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
SWITCH_SCRIPT="$ROOT/scripts/switch_team.sh"

if [ ! -f "$SWITCH_SCRIPT" ]; then
    echo "FAIL: switch_team.sh not found: $SWITCH_SCRIPT" >&2
    exit 1
fi

TMPROOT=$(mktemp -d "${TMPDIR:-/tmp}/v06-switch-status.XXXXXX")
trap 'rm -rf "$TMPROOT"' EXIT HUP INT TERM

failures=0

assert_grep() {
    _label="$1"; _pattern="$2"; _file="$3"
    if grep -qE "$_pattern" "$_file"; then
        printf '  PASS %s\n' "$_label"
    else
        printf '  FAIL %s: pattern=[%s] not found\n' "$_label" "$_pattern"
        failures=$((failures + 1))
    fi
}

# ============================================================================
# Fixture: claude-impl-codex-review (mixed assignments) → status output
# 모든 5개 stage_assignment 라인 + workflow_mode + team_mode가 출력되어야.
# ============================================================================
R="$TMPROOT/r"
mkdir -p "$R/.claude"
cat > "$R/.claude/settings.json" <<'EOF'
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

set +e
( JONEFLOW_ROOT="$R"; export JONEFLOW_ROOT
  bash "$SWITCH_SCRIPT" --status ) > "$R/status.stdout" 2> "$R/status.stderr"
rc=$?
set -e

if [ "$rc" -ne 0 ]; then
    echo "FAIL: --status exited $rc (expected 0). stderr:" >&2
    sed 's/^/    /' "$R/status.stderr" >&2
    exit 1
fi

# Header + 모든 7개 라인 검증.
assert_grep 'header line'             '^현재 운영 상태:'                 "$R/status.stdout"
assert_grep 'workflow_mode line'      '^  workflow_mode: desktop-cli'    "$R/status.stdout"
assert_grep 'team_mode line'          '^  team_mode:    claude-impl-codex-review'  "$R/status.stdout"
assert_grep 'stage_assignments label' '^  stage_assignments:'            "$R/status.stdout"
assert_grep 'stage8_impl line'        '^    stage8_impl:    claude'      "$R/status.stdout"
assert_grep 'stage9_review line'      '^    stage9_review:  codex'       "$R/status.stdout"
assert_grep 'stage10_fix line'        '^    stage10_fix:    claude'      "$R/status.stdout"
assert_grep 'stage11_verify line'     '^    stage11_verify: claude'      "$R/status.stdout"
assert_grep 'bg label'                '^  백그라운드 claude/codex'        "$R/status.stdout"

# AC-5-2: status 출력에도 pending_team_mode 흔적 없어야.
_hits=$(grep -c 'pending_team_mode' "$R/status.stdout" || true)
if [ "$_hits" = "0" ]; then
    printf '  PASS pending_team_mode absent in --status output\n'
else
    printf '  FAIL pending_team_mode hit %s in --status output\n' "$_hits"
    failures=$((failures + 1))
fi

# settings.json 변동 없음 (--status는 read-only).
orig_cksum=$(cksum < "$R/.claude/settings.json")
( JONEFLOW_ROOT="$R"; export JONEFLOW_ROOT
  bash "$SWITCH_SCRIPT" --status ) > /dev/null 2>&1
new_cksum=$(cksum < "$R/.claude/settings.json")
if [ "$orig_cksum" = "$new_cksum" ]; then
    printf '  PASS --status is read-only (settings.json unchanged)\n'
else
    printf '  FAIL --status mutated settings.json\n'
    failures=$((failures + 1))
fi

# settings.json 부재 → exit 4.
R2="$TMPROOT/missing"
mkdir -p "$R2"
set +e
( JONEFLOW_ROOT="$R2"; export JONEFLOW_ROOT
  bash "$SWITCH_SCRIPT" --status ) > /dev/null 2> "$R2/err"
rc=$?
set -e
if [ "$rc" = "4" ]; then
    printf '  PASS --status without settings.json → exit 4\n'
else
    printf '  FAIL --status without settings.json: expected exit 4, got %s\n' "$rc"
    failures=$((failures + 1))
fi

# --status + mode 조합 → exit 2.
set +e
( JONEFLOW_ROOT="$R"; export JONEFLOW_ROOT
  bash "$SWITCH_SCRIPT" --status claude-only ) > /dev/null 2> "$R/err2"
rc=$?
set -e
if [ "$rc" = "2" ]; then
    printf '  PASS --status with mode arg → exit 2\n'
else
    printf '  FAIL --status with mode arg: expected exit 2, got %s\n' "$rc"
    failures=$((failures + 1))
fi

if [ "$failures" -eq 0 ]; then
    printf 'test_switch_team_status: PASS\n'
    exit 0
else
    printf 'test_switch_team_status: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
