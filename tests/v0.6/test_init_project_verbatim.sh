#!/usr/bin/env bash
# shellcheck disable=SC1091
# SC1091: scripts/init_project.sh sourced by absolute path; safe.
#
# test_init_project_verbatim.sh — Golden file test for AC-5-4 [F-n1].
#
# Validates that scripts/init_project.sh's _init_print_workflow_mode_prompt and
# _init_print_team_mode_prompt emit text byte-identical to brainstorm.md Sec.4
# fenced block. ★추천★ 마커 + 한글 / en-dash / 화살표 모두 1:1 일치 의무.
#
# Reference: docs/03_design/v0.6_cli_automation/technical_design.md Sec 11.1
# row "init_project.sh 대화 verbatim".
#
# Bash required (BASH_SOURCE guard in init_project.sh).

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
BRAINSTORM="$ROOT/docs/01_brainstorm_v0.6/brainstorm.md"
INIT_SCRIPT="$ROOT/scripts/init_project.sh"

if [ ! -f "$BRAINSTORM" ]; then
    echo "FAIL: brainstorm.md not found: $BRAINSTORM" >&2
    exit 1
fi
if [ ! -f "$INIT_SCRIPT" ]; then
    echo "FAIL: init_project.sh not found: $INIT_SCRIPT" >&2
    exit 1
fi

TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/v06-verbatim.XXXXXX")
trap 'rm -rf "$TMPDIR"' EXIT HUP INT TERM

failures=0

# ----------------------------------------------------------------------------
# Extract golden blocks from brainstorm.md
# ----------------------------------------------------------------------------
# Workflow block: from "=== jDevFlow 프로젝트 초기화 ===" through the line
# that starts with "선택 (1/2/3, 기본값 1):". Inclusive.
awk '
  /^=== jDevFlow 프로젝트 초기화 ===/ { capture = 1 }
  capture { print }
  /^선택 \(1\/2\/3, 기본값 1\):/ && capture { exit }
' "$BRAINSTORM" > "$TMPDIR/workflow.golden"

# Team block: from "[2/2] 에이전트 팀 구성을 선택하세요:" through
# "선택 (1/2/3, 기본값 3):". Inclusive.
awk '
  /^\[2\/2\] 에이전트 팀 구성을 선택하세요:/ { capture = 1 }
  capture { print }
  /^선택 \(1\/2\/3, 기본값 3\):/ && capture { exit }
' "$BRAINSTORM" > "$TMPDIR/team.golden"

# Sanity: each golden file must contain its anchor line (catches awk bug).
if ! grep -q '^=== jDevFlow 프로젝트 초기화 ===' "$TMPDIR/workflow.golden"; then
    echo "FAIL: workflow.golden extraction missing anchor (brainstorm.md changed?)" >&2
    exit 1
fi
if ! grep -q '★추천★' "$TMPDIR/team.golden"; then
    echo "FAIL: team.golden missing ★추천★ marker (brainstorm.md changed?)" >&2
    exit 1
fi

# ----------------------------------------------------------------------------
# Source init_project.sh and emit actual blocks via the printer functions
# ----------------------------------------------------------------------------
# init_project.sh's BASH_SOURCE guard means main does NOT run on source.
# shellcheck source=/dev/null
. "$INIT_SCRIPT"

_init_print_workflow_mode_prompt > "$TMPDIR/workflow.actual"
_init_print_team_mode_prompt     > "$TMPDIR/team.actual"

# ----------------------------------------------------------------------------
# diff = 0 bytes (AC-5-4)
# ----------------------------------------------------------------------------
assert_diff_zero() {
    _label="$1"
    _golden="$2"
    _actual="$3"
    if diff -u "$_golden" "$_actual" > "$TMPDIR/diff.out"; then
        printf '  PASS %s (diff 0 bytes)\n' "$_label"
    else
        printf '  FAIL %s\n' "$_label"
        echo "----- diff (golden ← brainstorm.md, actual ← init_project.sh fn) -----" >&2
        sed 's/^/    /' "$TMPDIR/diff.out" >&2
        echo "----- end diff -----" >&2
        failures=$((failures + 1))
    fi
}

assert_diff_zero "workflow_mode block matches brainstorm.md L58-77" \
    "$TMPDIR/workflow.golden" "$TMPDIR/workflow.actual"

assert_diff_zero "team_mode block matches brainstorm.md L81-101" \
    "$TMPDIR/team.golden" "$TMPDIR/team.actual"

# ----------------------------------------------------------------------------
# Belt-and-suspenders: ★추천★ marker preserved in actual output (F-n1)
# ----------------------------------------------------------------------------
if grep -q '★추천★' "$TMPDIR/team.actual"; then
    printf '  PASS ★추천★ marker preserved in init output\n'
else
    printf '  FAIL ★추천★ marker lost in init output\n'
    failures=$((failures + 1))
fi

if [ "$failures" -eq 0 ]; then
    printf 'test_init_project_verbatim: PASS\n'
    exit 0
else
    printf 'test_init_project_verbatim: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
