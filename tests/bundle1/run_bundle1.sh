#!/bin/sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
SKILL="$ROOT/.skills/tool-picker/SKILL.md"
USAGE_EN="$ROOT/docs/notes/tool_picker_usage.md"
USAGE_KO="$ROOT/docs/notes/tool_picker_usage.ko.md"
CLAUDE="$ROOT/CLAUDE.md"

fail() {
  printf 'FAIL: %s\n' "$1"
  exit 1
}

printf '==> existence\n'
for path in "$SKILL" "$USAGE_EN" "$USAGE_KO" "$ROOT/tests/bundle1/run_bundle1.sh"; do
  [ -s "$path" ] || fail "missing or empty $path"
done
printf 'PASS existence\n'

printf '==> line counts\n'
skill_lines=$(wc -l <"$SKILL" | tr -d ' ')
usage_lines=$(wc -l <"$USAGE_EN" | tr -d ' ')
[ "$skill_lines" -le 300 ] || fail "SKILL.md over 300 lines ($skill_lines)"
[ "$usage_lines" -le 80 ] || fail "tool_picker_usage.md over 80 lines ($usage_lines)"
printf 'PASS line counts (skill=%s, usage=%s)\n' "$skill_lines" "$usage_lines"

printf '==> frontmatter triggers\n'
sed -n '1,8p' "$SKILL" | grep -q '^name: tool-picker$' || fail "missing exact skill name"
desc_block=$(sed -n '/^description:/,/^---$/p' "$SKILL")
printf '%s\n' "$desc_block" | grep -q 'stage' || fail "description missing stage"
printf '%s\n' "$desc_block" | grep -q 'mode' || fail "description missing mode"
printf '%s\n' "$desc_block" | grep -q 'risk_level' || fail "description missing risk_level"
printf '%s\n' "$desc_block" | grep -q 'next step' || fail "description missing next step"
printf '%s\n' "$desc_block" | grep -q 'jDevFlow' || fail "description missing jDevFlow"
desc_len=$(printf '%s' "$desc_block" | wc -c | tr -d ' ')
[ "$desc_len" -le 1024 ] || fail "description too long ($desc_len)"
printf 'PASS frontmatter triggers (description_bytes=%s)\n' "$desc_len"

printf '==> section order\n'
expected_sections=$(cat <<'EOF'
## 1. Purpose & scope
## 2. Inputs
## 3. Decision table
## 4. Output format
## 5. Triggers
## 6. Worked example
## 7. Failure modes
## 8. Invocation reference
EOF
)
actual_sections=$(grep -E '^## [1-8]\. ' "$SKILL")
[ "$actual_sections" = "$expected_sections" ] || fail "8-section body order mismatch"
printf 'PASS section order\n'

printf '==> decision table completeness\n'
awk '
BEGIN { fs_ok=1 }
/^\| Stage \|/ { in_table=1; next }
in_table && /^\|[-:| ]+\|$/ { next }
in_table && /^\|/ {
  row_count++
  if (NF != 9) {
    printf "bad-column-count row=%s nf=%d\n", $2, NF
    exit 1
  }
  for (i = 3; i <= 8; i++) {
    cell = $i
    gsub(/^ +| +$/, "", cell)
    split(cell, parts, / · /)
    primary = parts[1]
    gsub(/^ +| +$/, "", primary)
    if (primary == "" || primary == "—") {
      printf "empty-primary row=%s col=%d\n", $2, i
      exit 1
    }
  }
  next
}
in_table && !/^\|/ { in_table=0 }
END {
  if (row_count != 6) {
    printf "bad-row-count=%d\n", row_count
    exit 1
  }
}
' FS='|' "$SKILL" || fail "decision table incomplete"
grep -q '^Fallback row for any other stage:' "$SKILL" || fail "missing fallback row"
printf 'PASS decision table completeness\n'

printf '==> decision table paths\n'
while IFS= read -r path; do
  case "$path" in
    docs/notes/final_validation.md)
      grep -q '`docs/notes/final_validation.md` (to be created at Stage 11)' "$SKILL" \
        || fail "missing Stage 11 creation marker"
      ;;
    *)
      [ -e "$ROOT/$path" ] || fail "missing referenced path $path"
      ;;
  esac
done <<EOF
$(awk '
/^\| Stage \|/ { in_table=1; next }
in_table && /^\|[-:| ]+\|$/ { next }
in_table && /^\|/ {
  while (match($0, /`[^`]+`/)) {
    item = substr($0, RSTART + 1, RLENGTH - 2)
    if (item ~ /^(prompts|docs)\//) print item
    $0 = substr($0, RSTART + RLENGTH)
  }
  next
}
in_table && !/^\|/ { in_table=0 }
' "$SKILL" | sort -u)
EOF
printf 'PASS decision table paths\n'

printf '==> worked example\n'
example_lines=$(awk '
/^## 6\. Worked example$/ { in_block=1; next }
/^## 7\. Failure modes$/ { in_block=0 }
in_block { count++ }
END { print count + 0 }
' "$SKILL")
[ "$example_lines" -ge 15 ] || fail "worked example too short ($example_lines)"
grep -q 'Stage 1 Brainstorm' "$SKILL" || fail "worked example missing Stage 1 Brainstorm entry"
grep -q 'mode Standard' "$SKILL" || fail "worked example missing mode Standard"
grep -q 'risk_level medium' "$SKILL" || fail "worked example missing risk_level medium"
printf 'PASS worked example (%s lines)\n' "$example_lines"

printf '==> R2 grep\n'
matches=$(grep -nE '\b(bash|sh |python|node|eval|exec |curl|wget)\b' "$SKILL" || true)
[ -z "$matches" ] || fail "R2 grep found disallowed tokens"
printf 'PASS R2 grep (no matches)\n'

printf '==> usage docs and KO sync\n'
sed -n '1,12p' "$USAGE_EN" | grep -q '^stage: 5-support$' || fail "EN usage stage mismatch"
sed -n '1,12p' "$USAGE_EN" | grep -q '^bundle: 1$' || fail "EN usage bundle mismatch"
sed -n '1,12p' "$USAGE_KO" | grep -q '^stage: 5-support$' || fail "KO usage stage mismatch"
sed -n '1,12p' "$USAGE_KO" | grep -q '^bundle: 1$' || fail "KO usage bundle mismatch"
[ "$(grep -c '^## ' "$USAGE_EN")" -eq "$(grep -c '^## ' "$USAGE_KO")" ] || fail "EN/KO section count mismatch"
en_updated=$(sed -n 's/^updated: //p' "$USAGE_EN")
ko_updated=$(sed -n 's/^updated: //p' "$USAGE_KO")
[ "$en_updated" = "$ko_updated" ] || fail "EN/KO updated mismatch"
printf 'PASS usage docs and KO sync\n'

printf '==> CLAUDE read order hook\n'
grep -q '^> Skill hook: also read `.skills/tool-picker/SKILL.md` for jDevFlow stage/mode/risk_level advisory\.$' "$CLAUDE" \
  || fail "CLAUDE read-order hook missing"
printf 'PASS CLAUDE read order hook\n'
