#!/bin/sh
# git_checkpoint.sh — 작업 단위 커밋 (push 없음)
#
# 사용법 (로컬 쉘에서 실행):
#   bash scripts/git_checkpoint.sh "커밋 메시지" file1.md file2.md
#
# 파일을 명시적으로 지정하는 것이 원칙 (secret 혼입 방지).
# 파일 미지정 시 변경 목록을 보여주고 중단 — git add -A 사용 안 함.
#
# Claude 가 제공하는 커밋 블록 형식:
#   sh scripts/git_checkpoint.sh "type: subject" path/a path/b
# 위 한 줄을 로컬 터미널에 붙여넣으면 커밋 완료.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT"

GIT_NAME="Hyoungjin"
GIT_EMAIL="geenya36@gmail.com"

if [ "$#" -lt 1 ]; then
  printf 'usage: git_checkpoint.sh "message" file1 [file2 ...]\n' >&2
  exit 2
fi

MESSAGE="$1"
shift

if [ "$#" -eq 0 ]; then
  printf 'error: 파일을 명시해 주세요 (git add -A 사용 안 함).\n\n' >&2
  printf '변경된 파일 목록:\n'
  git status --short
  exit 2
fi

printf '📁 Staging: %s\n' "$*"
git add "$@"

printf '💾 Committing: %s\n' "$MESSAGE"
git -c user.name="$GIT_NAME" -c user.email="$GIT_EMAIL" \
  commit -m "$MESSAGE

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>" || {
  printf 'ℹ️  커밋할 변경사항 없음.\n'
  exit 0
}

printf '\n✅ 완료. SHA: '
git rev-parse --short HEAD
printf '\n현재 상태:\n'
git log --oneline -3
git status --short
