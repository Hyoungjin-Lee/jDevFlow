#!/bin/sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)

for doc in \
  "$ROOT/docs/01_brainstorm/brainstorm.md" \
  "$ROOT/docs/02_planning/plan_draft.md" \
  "$ROOT/docs/02_planning/plan_draft.ko.md" \
  "$ROOT/docs/02_planning/plan_review.md" \
  "$ROOT/docs/02_planning/plan_review.ko.md" \
  "$ROOT/docs/02_planning/plan_final.md" \
  "$ROOT/docs/02_planning/plan_final.ko.md"
do
  first_line=$(sed -n '1p' "$doc")
  [ "$first_line" != "---" ]
done

for doc in \
  "$ROOT/docs/03_design/bundle4_doc_discipline/technical_design.md" \
  "$ROOT/docs/03_design/bundle4_doc_discipline/technical_design.ko.md" \
  "$ROOT/docs/03_design/bundle1_tool_picker/technical_design.md" \
  "$ROOT/docs/03_design/bundle1_tool_picker/technical_design.ko.md" \
  "$ROOT/docs/notes/decisions.md" \
  "$ROOT/docs/notes/decisions.ko.md" \
  "$ROOT/docs/04_implementation/implementation_progress.md" \
  "$ROOT/docs/04_implementation/implementation_progress.ko.md"
do
  sed -n '1,9p' "$doc" | grep -q '^---$'
  sed -n '1,12p' "$doc" | grep -q '^title: '
  sed -n '1,12p' "$doc" | grep -q '^stage: '
  sed -n '1,12p' "$doc" | grep -q '^version: '
  sed -n '1,12p' "$doc" | grep -q '^language: '
  sed -n '1,12p' "$doc" | grep -q '^created: '
  sed -n '1,12p' "$doc" | grep -q '^updated: '
done

grep -q 'Every new Stage-5+ document with frontmatter has a `.ko.md` sibling\.' "$ROOT/CONTRIBUTING.md"
