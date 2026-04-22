#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
TEST_DIR="$SCRIPT_DIR/bundle4"

status=0

for test_script in \
  "$TEST_DIR"/test_01_update_handoff_success.sh \
  "$TEST_DIR"/test_02_update_handoff_failures.sh \
  "$TEST_DIR"/test_03_docs_structure.sh \
  "$TEST_DIR"/test_04_frontmatter_and_stage1_4.sh
do
  printf '==> %s\n' "$(basename "$test_script")"
  if "$test_script"; then
    printf 'PASS %s\n' "$(basename "$test_script")"
  else
    printf 'FAIL %s\n' "$(basename "$test_script")"
    status=1
  fi
done

exit "$status"
