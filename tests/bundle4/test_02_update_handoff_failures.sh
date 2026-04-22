#!/bin/sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
SCRIPT="$ROOT/scripts/update_handoff.sh"
TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/bundle4-failures.XXXXXX")
trap 'chmod 700 "$TMPDIR/readonly" 2>/dev/null || true; rm -rf "$TMPDIR"' EXIT HUP INT TERM

check_exit() {
  expected_code=$1
  expected_key=$2
  shift 2
  stdout_file="$TMPDIR/stdout.$$"
  stderr_file="$TMPDIR/stderr.$$"
  set +e
  "$@" >"$stdout_file" 2>"$stderr_file"
  actual_code=$?
  set -e
  [ "$actual_code" -eq "$expected_code" ]
  grep -q "^error=$expected_key\$" "$stdout_file"
  rm -f "$stdout_file" "$stderr_file"
}

check_exit 2 usage_error "$SCRIPT" --bogus
check_exit 2 usage_error "$SCRIPT" --section status --file "$ROOT/HANDOFF.md"
check_exit 2 secret_like_input "$SCRIPT" --section status --status "Bearer abc" --file "$ROOT/HANDOFF.md"
check_exit 3 missing_target "$SCRIPT" --section status --status "x" --file "$TMPDIR/missing/HANDOFF.md"

cat >"$TMPDIR/no_status_HANDOFF.md" <<'EOF'
# Hand-off

## Recent Changes
| Date | Description |
|------|-------------|
| 2026-04-22 | Seed row |

## 현재 상태
**현재 버전:** v0
**마지막 업데이트:** 2026-04-22
**현재 단계:** seed

## 최근 변경 이력
| 날짜 | 설명 |
|------|------|
| 2026-04-22 | seed |
EOF
check_exit 3 missing_section "$SCRIPT" --section status --status "x" --file "$TMPDIR/no_status_HANDOFF.md"

cat >"$TMPDIR/bad_recent_HANDOFF.md" <<'EOF'
## Status
**Current version:** v0
**Last updated:** 2026-04-22
**Current stage:** seed

## Recent Changes
not a table

## 현재 상태
**현재 버전:** v0
**마지막 업데이트:** 2026-04-22
**현재 단계:** seed

## 최근 변경 이력
| 날짜 | 설명 |
|------|------|
| 2026-04-22 | seed |
EOF
check_exit 5 malformed_recent_changes_table "$SCRIPT" --section recent_changes --change "x" --file "$TMPDIR/bad_recent_HANDOFF.md"

cp "$ROOT/HANDOFF.md" "$TMPDIR/big_HANDOFF.md"
python3 - <<'PY' "$TMPDIR/big_HANDOFF.md"
from pathlib import Path
path = Path(__import__("sys").argv[1])
path.write_bytes(path.read_bytes() + b"x" * (11 * 1024 * 1024))
PY
check_exit 1 file_too_large "$SCRIPT" --section status --status "x" --file "$TMPDIR/big_HANDOFF.md"

mkdir "$TMPDIR/readonly"
cp "$ROOT/HANDOFF.md" "$TMPDIR/readonly/HANDOFF.md"
chmod 500 "$TMPDIR/readonly"
check_exit 1 runtime_failure "$SCRIPT" --section status --status "x" --file "$TMPDIR/readonly/HANDOFF.md" --write

cp "$ROOT/HANDOFF.md" "$TMPDIR/verify_HANDOFF.md"
JDEVFLOW_TEST_TAMPER_AFTER_WRITE=1 \
  check_exit 4 verify_mismatch "$SCRIPT" --section status --status "x" --file "$TMPDIR/verify_HANDOFF.md" --write
