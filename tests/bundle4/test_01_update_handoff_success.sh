#!/bin/sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
SCRIPT="$ROOT/scripts/update_handoff.sh"
TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/bundle4-success.XXXXXX")
trap 'rm -rf "$TMPDIR"' EXIT HUP INT TERM

DRYRUN_OUTPUT="$TMPDIR/dryrun.txt"
"$SCRIPT" \
  --section both \
  --status-version "v0.3 (in progress)" \
  --status "Stage 8 implementation in progress." \
  --change "Codex completed Bundle 4 implementation." \
  --file "$ROOT/HANDOFF.md" \
  >"$DRYRUN_OUTPUT" 2>"$TMPDIR/dryrun.err"

grep -q '^--- ' "$DRYRUN_OUTPUT"
grep -q 'OK - dry-run only' "$DRYRUN_OUTPUT"

cp "$ROOT/HANDOFF.md" "$TMPDIR/HANDOFF.md"

"$SCRIPT" \
  --section both \
  --status-version "v0.3 (in progress)" \
  --status "Stage 8 implementation in progress." \
  --change "Codex completed Bundle 4 implementation." \
  --file "$TMPDIR/HANDOFF.md" \
  --write \
  >"$TMPDIR/write1.out" 2>"$TMPDIR/write1.err"

grep -q '\*\*Current stage:\*\* Stage 8 implementation in progress\.' "$TMPDIR/HANDOFF.md"
grep -q '\*\*현재 단계:\*\* Stage 8 implementation in progress\.' "$TMPDIR/HANDOFF.md"
grep -q '| [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] | Codex completed Bundle 4 implementation\. |' "$TMPDIR/HANDOFF.md"

cksum_before=$(cksum "$TMPDIR/HANDOFF.md")
"$SCRIPT" \
  --section both \
  --status-version "v0.3 (in progress)" \
  --status "Stage 8 implementation in progress." \
  --change "Codex completed Bundle 4 implementation." \
  --file "$TMPDIR/HANDOFF.md" \
  --write \
  >"$TMPDIR/write2.out" 2>"$TMPDIR/write2.err"
cksum_after=$(cksum "$TMPDIR/HANDOFF.md")

[ "$cksum_before" = "$cksum_after" ]
grep -q 'OK - updated' "$TMPDIR/write2.out"
