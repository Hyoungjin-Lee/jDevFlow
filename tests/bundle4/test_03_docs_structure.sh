#!/bin/sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)

for path in \
  "$ROOT/docs/notes/decisions.md" \
  "$ROOT/docs/notes/decisions.ko.md" \
  "$ROOT/templates/HANDOFF.template.md" \
  "$ROOT/CHANGELOG.md" \
  "$ROOT/CODE_OF_CONDUCT.md" \
  "$ROOT/CONTRIBUTING.md"
do
  [ -s "$path" ]
done

grep -q '^## \[Unreleased\]$' "$ROOT/CHANGELOG.md"
for heading in Added Changed Deprecated Removed Fixed Security; do
  grep -q "^### $heading\$" "$ROOT/CHANGELOG.md"
done

grep -q '^# Contributor Covenant Code of Conduct$' "$ROOT/CODE_OF_CONDUCT.md"
grep -q 'version 2.1' "$ROOT/CODE_OF_CONDUCT.md"
grep -q '{PROJECT_MAINTAINER_EMAIL}' "$ROOT/CODE_OF_CONDUCT.md"

grep -q '^## 8\. Changelog maintenance$' "$ROOT/CONTRIBUTING.md"
grep -q 'KO freshness for stage-closing docs' "$ROOT/CONTRIBUTING.md"
grep -q 'The single F-a1 exception' "$ROOT/CONTRIBUTING.md"

for heading in \
  '## 1. Purpose & audience' \
  '## 2. Quick start' \
  '## 3. Directory layout' \
  '## 4. Stage flow summary' \
  '## 5. Doc header schema' \
  '## 6. Link conventions' \
  '## 7. Bilingual (EN/KO) policy' \
  '## 8. Changelog maintenance' \
  '## 9. HANDOFF.md manual migration from v0.1/v0.2' \
  '## 10. Running `update_handoff.sh`' \
  '## 11. Code of conduct reference' \
  '## 12. Per-section ownership table'
do
  grep -Fqx "$heading" "$ROOT/CONTRIBUTING.md"
done

grep -q 'docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0' "$ROOT/docs/notes/decisions.md"
grep -q 'docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0' "$ROOT/docs/notes/decisions.ko.md"
! grep -q 'file://' "$ROOT/docs/notes/decisions.md"
! grep -q '^/.*\.md' "$ROOT/docs/notes/decisions.md"

grep -q '^## Bundles (v0.3 scope)$' "$ROOT/templates/HANDOFF.template.md"
grep -Fqx '## 번들 (v0.3 범위)' "$ROOT/templates/HANDOFF.template.md"
grep -q '^bundles: \[\]$' "$ROOT/templates/HANDOFF.template.md"
grep -q '^| Date | Description |$' "$ROOT/templates/HANDOFF.template.md"
grep -q '^| 날짜 | 설명 |$' "$ROOT/templates/HANDOFF.template.md"
! grep -q 'Stage 5 complete for both bundles' "$ROOT/templates/HANDOFF.template.md"
