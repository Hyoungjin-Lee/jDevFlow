#!/usr/bin/env bash
# shellcheck disable=SC1091
# SC1091: scripts/switch_team.sh sourced by absolute path; safe.
#
# test_switch_team_block.sh — Golden file test for AC-5-4 [F-n2].
#
# Validates that scripts/switch_team.sh's _switch_print_block_verbatim function
# emits text byte-identical to brainstorm.md Sec.5 차단 블록 (L118-123, the 6
# lines inside the fenced code block).
#
# Reference: docs/03_design/v0.6_cli_automation/technical_design.md Sec 4.5,
# Sec 11.1 row "switch_team.sh 차단".
#
# Bash required (BASH_SOURCE guard in switch_team.sh).

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
BRAINSTORM="$ROOT/docs/01_brainstorm_v0.6/brainstorm.md"
SWITCH_SCRIPT="$ROOT/scripts/switch_team.sh"

if [ ! -f "$BRAINSTORM" ]; then
    echo "FAIL: brainstorm.md not found: $BRAINSTORM" >&2
    exit 1
fi
if [ ! -f "$SWITCH_SCRIPT" ]; then
    echo "FAIL: switch_team.sh not found: $SWITCH_SCRIPT" >&2
    exit 1
fi

TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/v06-switch-block.XXXXXX")
trap 'rm -rf "$TMPDIR"' EXIT HUP INT TERM

failures=0

# ----------------------------------------------------------------------------
# Extract golden block from brainstorm.md.
# Block: "### 차단 (백그라운드 작업 진행 중)" 다음 ``` … ``` 사이 6줄.
# 정확히 ⚠️  팀 구성을 변경할 수 없습니다. ~ 진행 상태 확인: /codex:status
# ----------------------------------------------------------------------------
awk '
  /^### 차단 \(백그라운드 작업 진행 중\)/ { found_section = 1; next }
  found_section && /^```$/ {
    if (in_block) { exit }
    in_block = 1
    next
  }
  in_block { print }
' "$BRAINSTORM" > "$TMPDIR/block.golden"

# Sanity: golden file must contain anchor lines.
if ! grep -q '⚠️  팀 구성을 변경할 수 없습니다.' "$TMPDIR/block.golden"; then
    echo "FAIL: block.golden missing ⚠️ anchor (brainstorm.md changed?)" >&2
    sed 's/^/    /' "$TMPDIR/block.golden" >&2
    exit 1
fi
if ! grep -q '^진행 상태 확인: /codex:status$' "$TMPDIR/block.golden"; then
    echo "FAIL: block.golden missing /codex:status anchor" >&2
    exit 1
fi
# Expected exactly 6 lines (Sec 4.5 표).
_lines=$(wc -l < "$TMPDIR/block.golden" | tr -d ' ')
if [ "$_lines" != "6" ]; then
    echo "FAIL: block.golden expected 6 lines, got $_lines" >&2
    exit 1
fi

# ----------------------------------------------------------------------------
# Source switch_team.sh + invoke verbatim helper, capture stdout.
# Source-vs-execute guard ensures _switch_main does NOT run.
# ----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "$SWITCH_SCRIPT"

_switch_print_block_verbatim > "$TMPDIR/block.actual"

# ----------------------------------------------------------------------------
# diff = 0 bytes (AC-5-4)
# ----------------------------------------------------------------------------
if diff -u "$TMPDIR/block.golden" "$TMPDIR/block.actual" > "$TMPDIR/diff.out"; then
    printf '  PASS verbatim block matches brainstorm.md Sec.5 L118-123 (diff 0 bytes)\n'
else
    printf '  FAIL verbatim block diverges from brainstorm.md\n'
    echo "----- diff (golden ← brainstorm.md, actual ← switch_team.sh fn) -----" >&2
    sed 's/^/    /' "$TMPDIR/diff.out" >&2
    echo "----- end diff -----" >&2
    failures=$((failures + 1))
fi

# Belt-and-suspenders: byte-for-byte cmp.
if cmp -s "$TMPDIR/block.golden" "$TMPDIR/block.actual"; then
    printf '  PASS cmp -s confirms byte-identical\n'
else
    printf '  FAIL cmp -s disagrees with diff (binary divergence)\n'
    failures=$((failures + 1))
fi

if [ "$failures" -eq 0 ]; then
    printf 'test_switch_team_block: PASS\n'
    exit 0
else
    printf 'test_switch_team_block: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
