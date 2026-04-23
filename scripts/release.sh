#!/bin/sh
# release.sh — 버전 마감 원스텝 스크립트
#
# 사용법:
#   bash scripts/release.sh v0.5
#
# 수행 순서:
#   1. CHANGELOG.md 에서 해당 버전 섹션 추출 → release body 생성
#   2. 스테이징된 파일 커밋 (없으면 스킵)
#   3. annotated tag 생성 (이미 있으면 -f 로 업데이트)
#   4. main + tag push
#   5. GitHub release 생성 또는 업데이트

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

GIT_NAME="Hyoungjin"
GIT_EMAIL="geenya36@gmail.com"

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
  echo "❌ 버전을 지정하세요. 예: bash scripts/release.sh v0.5"
  exit 1
fi

# v0.5 → 0.5.0 형태로 CHANGELOG 섹션 검색용 변환
VERSION_NUM="${VERSION#v}"          # v0.5 → 0.5
CHANGELOG_KEY="[${VERSION_NUM}.0]" # [0.5.0]

echo "🔖 릴리스 준비: $VERSION"

# ── CHANGELOG 섹션 추출 ────────────────────────────────────────
BODY_FILE="$(mktemp /tmp/release_body.XXXXXX)"
trap 'rm -f "$BODY_FILE"' EXIT

awk "/^## \\[${VERSION_NUM}\\.0\\]/{flag=1; next} /^## \\[/{flag=0} flag" \
  "$ROOT/CHANGELOG.md" > "$BODY_FILE"

if [ ! -s "$BODY_FILE" ]; then
  echo "❌ CHANGELOG.md 에서 ## ${CHANGELOG_KEY} 섹션을 찾을 수 없습니다."
  echo "   CHANGELOG.md 에 해당 버전 섹션이 있는지 확인하세요."
  exit 1
fi

echo "📄 Release body 확인:"
echo "---"
cat "$BODY_FILE"
echo "---"
printf "\n계속할까요? [y/N] "
read -r answer
case "$answer" in
  y|Y) ;;
  *) echo "취소됨."; exit 0 ;;
esac

# ── 커밋 (스테이징된 파일 있을 때만) ──────────────────────────
STAGED=$(git diff --cached --name-only 2>/dev/null || true)
if [ -n "$STAGED" ]; then
  echo "💾 스테이징된 파일 커밋 중..."
  git -c user.name="$GIT_NAME" -c user.email="$GIT_EMAIL" commit -m \
    "[${VERSION}] release

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
else
  echo "ℹ️  스테이징된 파일 없음. 커밋 스킵."
fi

# ── Tag ───────────────────────────────────────────────────────
if git tag | grep -qx "$VERSION"; then
  echo "🔄 태그 $VERSION 이미 존재 → 업데이트 (-f)"
  git -c user.name="$GIT_NAME" -c user.email="$GIT_EMAIL" \
    tag -a "$VERSION" -m "jOneFlow $VERSION" -f
else
  echo "🏷️  태그 생성: $VERSION"
  git -c user.name="$GIT_NAME" -c user.email="$GIT_EMAIL" \
    tag -a "$VERSION" -m "jOneFlow $VERSION"
fi

# ── Push ──────────────────────────────────────────────────────
echo "🚀 Pushing main + $VERSION..."
git push origin main
git push origin "$VERSION" -f

# ── GitHub Release ────────────────────────────────────────────
if gh release view "$VERSION" >/dev/null 2>&1; then
  echo "🔄 GitHub release $VERSION 업데이트..."
  gh release edit "$VERSION" -F "$BODY_FILE"
else
  echo "🎉 GitHub release $VERSION 생성..."
  gh release create "$VERSION" -F "$BODY_FILE"
fi

echo ""
echo "✅ $VERSION 릴리스 완료!"
