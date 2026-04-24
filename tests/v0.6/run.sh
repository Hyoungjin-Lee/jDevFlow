#!/bin/sh
# tests/v0.6/run.sh — v0.6 unit test harness for scripts/lib/settings.sh.
#
# Runs 3 unit tests covering the public API documented in
# docs/03_design/v0.6_cli_automation/technical_design.md Sec 8.1.
#
# Usage (from project root):
#   bash tests/v0.6/run.sh
#
# Exits 0 only when all 3 tests pass.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

pass=0
fail=0

for test_script in \
    "$SCRIPT_DIR/test_settings_read_key.sh" \
    "$SCRIPT_DIR/test_settings_write_key.sh" \
    "$SCRIPT_DIR/test_settings_write_stage_assign_block.sh"
do
    name=$(basename "$test_script")
    printf '==> %s\n' "$name"
    if sh "$test_script"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi
done

printf '\n=== v0.6 results: %d pass, %d fail ===\n' "$pass" "$fail"

if [ "$fail" -eq 0 ]; then
    exit 0
else
    exit 1
fi
