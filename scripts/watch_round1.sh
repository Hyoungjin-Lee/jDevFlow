#!/bin/sh
# watch_round1.sh — Round 1 완료 감지 + flag 파일 생성
#
# 완료 조건 (AND):
#   1. docs/04_implementation_v0.6_stage8/round1_report.md 존재
#   2. git log에 "M1 Round 1" 커밋 메시지
#   3. round1_report.md가 커밋됨 (git ls-files로 tracked 확인)
#
# 감지 시 /tmp/jdevflow_round1_done.flag 생성 후 종료.
# 세션 16 A/B 실험용 임시 스크립트. v0.6 본 릴리스 이후 제거 가능.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT"

FLAG="/tmp/jdevflow_round1_done.flag"
LOG="/tmp/jdevflow_round1_watch.log"
REPORT="docs/04_implementation_v0.6_stage8/round1_report.md"

rm -f "$FLAG"
printf '%s — watch 시작 (ROOT=%s)\n' "$(date +'%H:%M:%S')" "$ROOT" > "$LOG"

while true; do
  sleep 20

  # 조건 1: report 파일 존재
  [ -f "$REPORT" ] || continue

  # 조건 2: "M1 Round 1" 커밋 메시지
  if ! git log --oneline -20 2>/dev/null | grep -qE "(M1 Round 1|feat.*Round.?1)"; then
    continue
  fi

  # 조건 3: report 파일 tracked
  if ! git ls-files --error-unmatch "$REPORT" 2>/dev/null; then
    continue
  fi

  # 모든 조건 만족
  {
    date
    printf '완료 감지\n'
    printf 'branch: %s\n' "$(git branch --show-current)"
    printf 'last 3 commits:\n'
    git log --oneline -3
  } > "$FLAG"
  printf '%s — Round 1 완료 감지 → flag 생성\n' "$(date +'%H:%M:%S')" >> "$LOG"
  break
done
