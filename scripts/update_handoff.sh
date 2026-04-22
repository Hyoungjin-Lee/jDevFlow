#!/bin/sh

set -eu

SCRIPT_VERSION="0.3.0"
SECTION="both"
STATUS_TEXT=""
STATUS_VERSION=""
CHANGE_TEXT=""
DEV_HISTORY_TEXT=""
FILE="./HANDOFF.md"
WRITE_MODE=0
SHOW_DIFF=1
TEMPLATE_MODE=0
MAX_FILE_BYTES=10485760

usage() {
  cat <<'EOF' >&2
usage: update_handoff.sh [OPTIONS]

OPTIONS
  --section <status|recent_changes|both>
  --status <text>
  --status-version <v>
  --change <text>
  --dev-history <text>
  --file <path>
  --template
  --write
  --dry-run
  --no-diff
  -h, --help
  -V, --version
EOF
}

stdout_error() {
  printf 'error=%s\n' "$1"
}

die_usage() {
  stdout_error "$1"
  printf '%s\n' "$2" >&2
  usage
  exit 2
}

die_runtime() {
  stdout_error "$1"
  printf '%s\n' "$2" >&2
  exit "$3"
}

is_secret_like() {
  printf '%s\n' "$1" | grep -Eiq 'TOKEN|SECRET|KEY|PASSWORD|Bearer[[:space:]]|sk-'
}

ensure_length() {
  value=$1
  limit=$2
  name=$3
  length=$(printf '%s' "$value" | wc -c | tr -d ' ')
  if [ "$length" -gt "$limit" ]; then
    die_usage "input_too_long" "$name exceeds $limit bytes"
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --section)
      [ "$#" -ge 2 ] || die_usage "usage_error" "missing value for --section"
      SECTION=$2
      shift 2
      ;;
    --status)
      [ "$#" -ge 2 ] || die_usage "usage_error" "missing value for --status"
      STATUS_TEXT=$2
      shift 2
      ;;
    --status-version)
      [ "$#" -ge 2 ] || die_usage "usage_error" "missing value for --status-version"
      STATUS_VERSION=$2
      shift 2
      ;;
    --change)
      [ "$#" -ge 2 ] || die_usage "usage_error" "missing value for --change"
      CHANGE_TEXT=$2
      shift 2
      ;;
    --dev-history)
      [ "$#" -ge 2 ] || die_usage "usage_error" "missing value for --dev-history"
      DEV_HISTORY_TEXT=$2
      shift 2
      ;;
    --file)
      [ "$#" -ge 2 ] || die_usage "usage_error" "missing value for --file"
      FILE=$2
      shift 2
      ;;
    --template)
      TEMPLATE_MODE=1
      FILE="./templates/HANDOFF.template.md"
      shift
      ;;
    --write)
      WRITE_MODE=1
      shift
      ;;
    --dry-run)
      WRITE_MODE=0
      shift
      ;;
    --no-diff)
      SHOW_DIFF=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -V|--version)
      printf '%s\n' "$SCRIPT_VERSION"
      exit 0
      ;;
    *)
      die_usage "usage_error" "unknown flag: $1"
      ;;
  esac
done

case "$SECTION" in
  status|recent_changes|both) ;;
  *)
    die_usage "usage_error" "invalid --section value: $SECTION"
    ;;
esac

case "$FILE" in
  *HANDOFF*.md) ;;
  *)
    die_usage "usage_error" "--file must target HANDOFF*.md"
    ;;
esac

case "$SECTION" in
  status)
    [ -n "$STATUS_TEXT" ] || die_usage "usage_error" "status text required for --section=status"
    ;;
  recent_changes)
    [ -n "$CHANGE_TEXT" ] || die_usage "usage_error" "change text required for --section=recent_changes"
    ;;
  both)
    [ -n "$STATUS_TEXT" ] || die_usage "usage_error" "status text required for --section=both"
    [ -n "$CHANGE_TEXT" ] || die_usage "usage_error" "change text required for --section=both"
    ;;
esac

ensure_length "$STATUS_TEXT" 500 "--status"
ensure_length "$CHANGE_TEXT" 1000 "--change"

if [ -n "$STATUS_TEXT" ] && is_secret_like "$STATUS_TEXT"; then
  die_usage "secret_like_input" "status text looks like a secret; aborting"
fi

if [ -n "$CHANGE_TEXT" ] && is_secret_like "$CHANGE_TEXT"; then
  die_usage "secret_like_input" "change text looks like a secret; aborting"
fi

[ -f "$FILE" ] || die_runtime "missing_target" "HANDOFF.md not found at $FILE" 3

file_bytes=$(wc -c < "$FILE" | tr -d ' ')
if [ "$file_bytes" -gt "$MAX_FILE_BYTES" ]; then
  die_runtime "file_too_large" "HANDOFF.md unusually large; aborting" 1
fi

TODAY_UTC=$(date -u +%Y-%m-%d)
LAST_UPDATED_EN="$TODAY_UTC (UTC)"
LAST_UPDATED_KO="$TODAY_UTC (UTC)"

TMP_PREFIX=$(basename "$FILE")
DIR_NAME=$(dirname "$FILE")
TMP_BASE=${TMPDIR:-/tmp}
ORIG_LF="$TMP_BASE/.${TMP_PREFIX}.orig.$$"
NEW_LF="$TMP_BASE/.${TMP_PREFIX}.new.$$"
WRITE_TMP="$DIR_NAME/.${TMP_PREFIX}.write.$$"
BACKUP_FILE="$DIR_NAME/.${TMP_PREFIX}.bak.$(date -u +%Y%m%dT%H%M%SZ).$$"
VERIFY_LF="$TMP_BASE/.${TMP_PREFIX}.verify.$$"
trap 'rm -f "$ORIG_LF" "$NEW_LF" "$WRITE_TMP" "$VERIFY_LF"' EXIT HUP INT TERM

if awk 'index($0, "\r") { found=1; exit } END { exit found ? 0 : 1 }' "$FILE"; then
  LINE_ENDING="CRLF"
else
  LINE_ENDING="LF"
fi

tr -d '\r' < "$FILE" > "$ORIG_LF"

set +e
awk \
  -v section="$SECTION" \
  -v status_text="$STATUS_TEXT" \
  -v status_version="$STATUS_VERSION" \
  -v change_text="$CHANGE_TEXT" \
  -v today="$TODAY_UTC" \
  -v last_updated_en="$LAST_UPDATED_EN" \
  -v last_updated_ko="$LAST_UPDATED_KO" '
BEGIN {
  in_status_en = 0
  in_status_ko = 0
  in_recent_en = 0
  in_recent_ko = 0
  saw_status_en = 0
  saw_status_ko = 0
  saw_stage_en = 0
  saw_stage_ko = 0
  saw_recent_en = 0
  saw_recent_ko = 0
  header_en = 0
  header_ko = 0
  separator_en = 0
  separator_ko = 0
  inserted_en = 0
  inserted_ko = 0
  pending_insert_en = 0
  pending_insert_ko = 0
}
function emit_recent_row() {
  return "| " today " | " change_text " |"
}
function finish_recent(which) {
  if (which == "en") {
    if (!header_en || !separator_en) {
      exit 25
    }
  } else {
    if (!header_ko || !separator_ko) {
      exit 25
    }
  }
}
{
  if ((section == "recent_changes" || section == "both") && in_recent_en && pending_insert_en && $0 ~ /^## /) {
    print emit_recent_row()
    inserted_en = 1
    pending_insert_en = 0
  }
  if ((section == "recent_changes" || section == "both") && in_recent_ko && pending_insert_ko && $0 ~ /^## /) {
    print emit_recent_row()
    inserted_ko = 1
    pending_insert_ko = 0
  }
  if ((section == "recent_changes" || section == "both") && in_recent_en && $0 ~ /^## /) {
    finish_recent("en")
    in_recent_en = 0
  }
  if ((section == "recent_changes" || section == "both") && in_recent_ko && $0 ~ /^## /) {
    finish_recent("ko")
    in_recent_ko = 0
  }
  if (in_status_en && $0 ~ /^## /) {
    in_status_en = 0
  }
  if (in_status_ko && $0 ~ /^## /) {
    in_status_ko = 0
  }

  if ($0 == "## Status") {
    saw_status_en = 1
    in_status_en = 1
    print
    next
  }
  if ($0 == "## 현재 상태") {
    saw_status_ko = 1
    in_status_ko = 1
    print
    next
  }
  if ((section == "recent_changes" || section == "both") && $0 == "## Recent Changes") {
    saw_recent_en = 1
    in_recent_en = 1
    print
    next
  }
  if ((section == "recent_changes" || section == "both") && $0 == "## 최근 변경 이력") {
    saw_recent_ko = 1
    in_recent_ko = 1
    print
    next
  }

  if ((section == "status" || section == "both") && in_status_en) {
    if ($0 ~ /^\*\*Current version:\*\*/) {
      if (status_version != "") {
        print "**Current version:** " status_version
      } else {
        print
      }
      next
    }
    if ($0 ~ /^\*\*Last updated:\*\*/) {
      print "**Last updated:** " last_updated_en
      next
    }
    if ($0 ~ /^\*\*Current stage:\*\*/) {
      print "**Current stage:** " status_text
      saw_stage_en = 1
      next
    }
  }

  if ((section == "status" || section == "both") && in_status_ko) {
    if ($0 ~ /^\*\*현재 버전:\*\*/) {
      if (status_version != "") {
        print "**현재 버전:** " status_version
      } else {
        print
      }
      next
    }
    if ($0 ~ /^\*\*마지막 업데이트:\*\*/) {
      print "**마지막 업데이트:** " last_updated_ko
      next
    }
    if ($0 ~ /^\*\*현재 단계:\*\*/) {
      print "**현재 단계:** " status_text
      saw_stage_ko = 1
      next
    }
  }

  if ((section == "recent_changes" || section == "both") && in_recent_en) {
    if ($0 ~ /^\|[[:space:]]*Date[[:space:]]*\|[[:space:]]*Description[[:space:]]*\|$/) {
      header_en = 1
      print
      next
    }
    if (header_en && !separator_en && $0 ~ /^\|[-:[:space:]]+\|[-:[:space:]]+\|$/) {
      separator_en = 1
      pending_insert_en = 1
      print
      next
    }
    if (pending_insert_en && !inserted_en) {
      if ($0 == emit_recent_row()) {
        inserted_en = 1
        pending_insert_en = 0
        print
        next
      }
      print emit_recent_row()
      inserted_en = 1
      pending_insert_en = 0
    }
  }

  if ((section == "recent_changes" || section == "both") && in_recent_ko) {
    if ($0 ~ /^\|[[:space:]]*날짜[[:space:]]*\|[[:space:]]*설명[[:space:]]*\|$/) {
      header_ko = 1
      print
      next
    }
    if (header_ko && !separator_ko && $0 ~ /^\|[-:[:space:]]+\|[-:[:space:]]+\|$/) {
      separator_ko = 1
      pending_insert_ko = 1
      print
      next
    }
    if (pending_insert_ko && !inserted_ko) {
      if ($0 == emit_recent_row()) {
        inserted_ko = 1
        pending_insert_ko = 0
        print
        next
      }
      print emit_recent_row()
      inserted_ko = 1
      pending_insert_ko = 0
    }
  }

  print
}
END {
  if ((section == "recent_changes" || section == "both") && in_recent_en && pending_insert_en && !inserted_en) {
    print emit_recent_row()
    inserted_en = 1
    pending_insert_en = 0
  }
  if ((section == "recent_changes" || section == "both") && in_recent_ko && pending_insert_ko && !inserted_ko) {
    print emit_recent_row()
    inserted_ko = 1
    pending_insert_ko = 0
  }
  if ((section == "recent_changes" || section == "both") && in_recent_en) {
    finish_recent("en")
  }
  if ((section == "recent_changes" || section == "both") && in_recent_ko) {
    finish_recent("ko")
  }
  if ((section == "status" || section == "both")) {
    if (!saw_status_en || !saw_status_ko || !saw_stage_en || !saw_stage_ko) {
      exit 23
    }
  }
  if ((section == "recent_changes" || section == "both")) {
    if (!saw_recent_en || !saw_recent_ko) {
      exit 23
    }
    if (!inserted_en || !inserted_ko) {
      exit 25
    }
  }
}
' "$ORIG_LF" > "$NEW_LF"
AWK_OUTPUT=$?
set -e

case "$AWK_OUTPUT" in
  0) ;;
  23)
    die_runtime "missing_section" "required HANDOFF section not found" 3
    ;;
  25)
    die_runtime "malformed_recent_changes_table" "Recent Changes table missing header row" 5
    ;;
  *)
    die_runtime "runtime_failure" "failed to rewrite HANDOFF content" 1
    ;;
esac

if [ "$SHOW_DIFF" -eq 1 ]; then
  diff -u "$ORIG_LF" "$NEW_LF" || true
fi

append_dev_history() {
  history_file=$1
  history_text=$2
  [ -n "$history_text" ] || return 0
  [ -f "$history_file" ] || return 0
  printf '\n- %s\n' "$history_text" >> "$history_file"
}

if [ "$WRITE_MODE" -eq 0 ]; then
  printf 'OK - dry-run only (section=%s, target=%s).\n' "$SECTION" "$FILE"
  exit 0
fi

cp "$FILE" "$BACKUP_FILE" 2>/dev/null || die_runtime "runtime_failure" "could not create backup for $FILE" 1

if [ "$LINE_ENDING" = "CRLF" ]; then
  awk '{ sub(/\r$/, ""); printf "%s\r\n", $0 }' "$NEW_LF" > "$WRITE_TMP" || {
    mv "$BACKUP_FILE" "$FILE" 2>/dev/null || true
    die_runtime "runtime_failure" "failed to encode CRLF output" 1
  }
else
  cp "$NEW_LF" "$WRITE_TMP" 2>/dev/null || {
    mv "$BACKUP_FILE" "$FILE" 2>/dev/null || true
    die_runtime "runtime_failure" "failed to stage output file" 1
  }
fi

if ! mv "$WRITE_TMP" "$FILE" 2>/dev/null; then
  mv "$BACKUP_FILE" "$FILE" 2>/dev/null || true
  die_runtime "runtime_failure" "write failed; target left untouched" 1
fi

if [ "${JONEFLOW_TEST_TAMPER_AFTER_WRITE:-0}" = "1" ]; then
  printf '\nTAMPERED\n' >> "$FILE"
fi

tr -d '\r' < "$FILE" > "$VERIFY_LF"

if ! cmp -s "$NEW_LF" "$VERIFY_LF"; then
  mv "$BACKUP_FILE" "$FILE" 2>/dev/null || true
  die_runtime "verify_mismatch" "verify mismatch; rolled back" 4
fi

rm -f "$BACKUP_FILE"

if [ -n "$DEV_HISTORY_TEXT" ] && [ "$TEMPLATE_MODE" -eq 0 ]; then
  append_dev_history "./docs/notes/dev_history.md" "$DEV_HISTORY_TEXT"
  append_dev_history "./docs/notes/dev_history.ko.md" "$DEV_HISTORY_TEXT"
fi

printf 'OK - updated %s (section=%s).\n' "$FILE" "$SECTION"
