#!/bin/sh
# git_checkpoint.sh — 작업 단위 커밋 + push
#
# 사용법:
#   bash scripts/git_checkpoint.sh "커밋 메시지"
#   bash scripts/git_checkpoint.sh "커밋 메시지" file1.md file2.md   # 특정 파일만
#
# 파일 미지정 시: git status 로 변경 파일 목록 보여주고 확인 후 진행

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

GIT_NAME="Hyoungjin"
GIT_EMAIL="geenya36@gmail.com"

MESSAGE="${1:-checkpoint}"
shift 2>/dev/null || true  # 메시지 인자 소비

# ── 스테이징 ──────────────────────────────────────────────────
if [ "$#" -gt 0 ]; then
  echo "📁 Staging: $*"
  git add "$@"
else
  echo "📋 변경된 파일:"
  git status --short
  printf "\n위 파일을 전부 스테이징할까요? [y/N] "
  read -r answer
  case "$answer" in
    y|Y) git add -A ;;
    *) echo "취소됨."; exit 0 ;;
  esac
fi

# ── 커밋 ──────────────────────────────────────────────────────
echo "💾 Committing: $MESSAGE"
git -c user.name="$GIT_NAME" -c user.email="$GIT_EMAIL" commit -m "$MESSAGE

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>" || {
  echo "ℹ️  커밋할 변경사항 없음."
  exit 0
}

# ── Push ──────────────────────────────────────────────────────
if git remote get-url origin >/dev/null 2>&1; then
  echo "🚀 Pushing to origin/main..."
  git push origin main
else
  echo "ℹ️  remote 없음. push 생략."
fi

echo ""
echo "✅ 완료: $MESSAGE"
