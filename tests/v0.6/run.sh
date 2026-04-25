#!/bin/sh
# tests/v0.6/run.sh — v0.6 test harness.
#
# M1: scripts/lib/settings.sh unit tests (technical_design.md Sec 8.1).
# M2: scripts/init_project.sh verbatim + integration tests (Sec 11.1).
# M3: scripts/switch_team.sh verbatim + apply + status + bg tests (Sec 11.1).
#
# Usage (from project root):
#   bash tests/v0.6/run.sh
#
# Exits 0 only when all tests pass.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

pass=0
fail=0

# bash-required tests source init_project.sh (uses BASH_SOURCE guard).
run_test() {
    _rt_script="$1"
    _rt_runner="$2"
    name=$(basename "$_rt_script")
    printf '==> %s\n' "$name"
    if "$_rt_runner" "$_rt_script"; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
    fi
}

# M1 — POSIX sh unit tests.
run_test "$SCRIPT_DIR/test_settings_read_key.sh"                 sh
run_test "$SCRIPT_DIR/test_settings_write_key.sh"                sh
run_test "$SCRIPT_DIR/test_settings_write_stage_assign_block.sh" sh

# M2 — bash tests (init_project.sh has BASH_SOURCE guard).
run_test "$SCRIPT_DIR/test_init_project_verbatim.sh" bash
run_test "$SCRIPT_DIR/test_init_project_cases.sh"    bash

# M3 — switch_team.sh tests (also bash; sources init_project.sh for verbatim).
run_test "$SCRIPT_DIR/test_switch_team_block.sh"  bash
run_test "$SCRIPT_DIR/test_switch_team_apply.sh"  bash
run_test "$SCRIPT_DIR/test_switch_team_status.sh" bash
run_test "$SCRIPT_DIR/test_switch_team_bg.sh"     bash

printf '\n=== v0.6 results: %d pass, %d fail ===\n' "$pass" "$fail"

if [ "$fail" -eq 0 ]; then
    exit 0
else
    exit 1
fi
