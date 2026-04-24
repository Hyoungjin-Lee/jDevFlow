#!/bin/sh
# run_tests.sh — run all test harnesses in one command.
#
# Usage (from project root):
#   sh scripts/run_tests.sh
#
# Exits 0 only if both harnesses pass.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
status=0

printf '=== bundle1 (10 checks) ===\n'
if bash "$ROOT/tests/bundle1/run_bundle1.sh"; then
  printf 'bundle1: PASS\n\n'
else
  printf 'bundle1: FAIL\n\n'
  status=1
fi

printf '=== bundle4 (4 tests) ===\n'
if sh "$ROOT/tests/run_bundle4.sh"; then
  printf 'bundle4: PASS\n\n'
else
  printf 'bundle4: FAIL\n\n'
  status=1
fi

printf '=== v0.6 (3 unit tests) ===\n'
if bash "$ROOT/tests/v0.6/run.sh"; then
  printf 'v0.6: PASS\n\n'
else
  printf 'v0.6: FAIL\n\n'
  status=1
fi

if [ "$status" -eq 0 ]; then
  printf '=== ALL PASS ===\n'
else
  printf '=== FAIL (see above) ===\n'
fi

exit "$status"
