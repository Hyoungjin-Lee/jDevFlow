#!/bin/sh
# watch_round2.sh — Round 2 완료 감지 + flag 파일 생성
# 세션 16 A/B 실험용. watch_round1.sh와 구조 동일, 경로만 Round 2로.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT"

FLAG="/tmp/joneflow_round2_done.flag"
LOG="/tmp/joneflow_round2_watch.log"
REPORT="docs/04_implementation_v0.6_stage8/round2_report.md"

rm -f "$FLAG"
printf '%s — watch 시작 (ROOT=%s)\n' "$(date +'%H:%M:%S')" "$ROOT" > "$LOG"

while true; do
  sleep 20

  [ -f "$REPORT" ] || continue

  if ! git log --oneline -20 2>/dev/null | grep -qE "(M1 Round 2|feat.*Round.?2)"; then
    continue
  fi

  if ! git ls-files --error-unmatch "$REPORT" 2>/dev/null; then
    continue
  fi

  {
    date
    printf '완료 감지\n'
    printf 'branch: %s\n' "$(git branch --show-current)"
    printf 'last 3 commits:\n'
    git log --oneline -3
  } > "$FLAG"
  printf '%s — Round 2 완료 감지 → flag 생성\n' "$(date +'%H:%M:%S')" >> "$LOG"
  break
done
