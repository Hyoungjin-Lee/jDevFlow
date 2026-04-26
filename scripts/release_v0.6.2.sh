#!/bin/sh
# release_v0.6.2.sh — v0.6.2 릴리스 자동화 (push + tag + push --tags 단일 trail)
#
# 신규 정책 (세션 26 박힘): 위험 명령(`git push` / `git tag` / `git push --tags`)은
# 운영자에게 명령줄 paste 금지. 본 스크립트가 정책 첫 적용 사례.
#
# 사용법:
#   sh scripts/release_v0.6.2.sh                # dry-run (default, mutation 0)
#   sh scripts/release_v0.6.2.sh --dry-run      # 명시적 dry-run
#   sh scripts/release_v0.6.2.sh --confirm      # 실 실행 (운영자 명시 승인 후)
#
# 검증 게이트 (전수 통과 시에만 실 실행):
#   1. 현재 브랜치 = main
#   2. 작업 트리 clean (uncommitted/untracked 0)
#   3. origin remote 등록 + ls-remote 응답
#   4. local HEAD가 push 가능 상태 (origin/main 보다 앞섬 또는 동일)
#   5. tag v0.6.2 local 부재 (멱등성: 있으면 skip + 안내)
#   6. tag v0.6.2 remote 부재 (있으면 abort + 안내)
#   7. Stage 9 review APPROVED + Stage 12 QA ALL PASS 산출물 존재
#
# 실패 시: 즉시 중단 + abort 메시지 + 롤백 명령 안내. mutation 미발생 보장.

set -eu

# shellcheck disable=SC1007  # CDPATH= idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"

VERSION="v0.6.2"
TAG_NAME="$VERSION"
EXPECTED_BRANCH="main"
EXPECTED_REMOTE="origin"

MODE="dry-run"
case "${1:-}" in
    --confirm)   MODE="confirm" ;;
    --dry-run)   MODE="dry-run" ;;
    "")          MODE="dry-run" ;;
    -h|--help)
        sed -n '2,18p' "$0" | sed 's|^# \{0,1\}||'
        exit 0
        ;;
    *)
        printf 'release_v0.6.2.sh: 알 수 없는 인자: %s\n' "$1" >&2
        printf '사용법: sh scripts/release_v0.6.2.sh [--dry-run|--confirm]\n' >&2
        exit 2
        ;;
esac

# ============================================================================
# 안전장치 — abort/롤백
# ============================================================================

_abort() {
    printf '\n❌ ABORT: %s\n' "$1" >&2
    if [ -n "${2:-}" ]; then
        printf '   롤백/조치: %s\n' "$2" >&2
    fi
    exit 1
}

# ERR trap: 예기치 못한 실패 시 안내. POSIX shell은 ERR trap 미지원이라 EXIT 사용.
# shellcheck disable=SC2329  # invoked via trap.
_on_exit() {
    _ec=$?
    if [ "$_ec" -ne 0 ] && [ -z "${_abort_handled:-}" ]; then
        printf '\n❌ release_v0.6.2.sh: 예기치 못한 종료 (exit=%s).\n' "$_ec" >&2
        printf '   현재 작업 트리/태그 상태:\n' >&2
        printf '   - branch: %s\n' "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)" >&2
        printf '   - HEAD:   %s\n' "$(git rev-parse --short HEAD 2>/dev/null || echo unknown)" >&2
        printf '   - tag %s: %s\n' "$TAG_NAME" \
            "$(git rev-parse "$TAG_NAME" 2>/dev/null && echo '존재' || echo '부재')" >&2
        printf '   복구: git tag -d %s (local), git push origin :refs/tags/%s (remote, 신중)\n' \
            "$TAG_NAME" "$TAG_NAME" >&2
    fi
    return "$_ec"
}
trap _on_exit EXIT

_pass() { printf '  ✅  %s\n' "$1"; }
_info() { printf '  ℹ️   %s\n' "$1"; }

_run() {
    # mutation wrapper. dry-run 시 echo만, --confirm 시 실 실행.
    # eval 미사용 — 인자 분리 보존 (SC2294).
    if [ "$MODE" = "dry-run" ]; then
        printf '  [DRY-RUN] $ %s\n' "$*"
    else
        printf '  $ %s\n' "$*"
        "$@"
    fi
}

# ============================================================================
# Gate 1~7: 검증 (mutation 전 전수 통과 필수)
# ============================================================================

printf '=== release_v0.6.2.sh (mode: %s) ===\n\n' "$MODE"

# Gate 1: 현재 브랜치 = main
_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
[ "$_branch" = "$EXPECTED_BRANCH" ] \
    || { _abort_handled=1; _abort "현재 브랜치=$_branch (기대=$EXPECTED_BRANCH)" "git checkout $EXPECTED_BRANCH"; }
_pass "Gate 1: 현재 브랜치=$EXPECTED_BRANCH"

# Gate 2: 작업 트리 clean
if [ -n "$(git status --porcelain)" ]; then
    _abort_handled=1
    printf '  현재 dirty 상태:\n' >&2
    git status --short | sed 's|^|    |' >&2
    _abort "작업 트리 dirty (uncommitted/untracked 잔존)" "git stash 또는 commit 후 재실행"
fi
_pass "Gate 2: 작업 트리 clean"

# Gate 3: origin remote + ls-remote 응답
git remote get-url "$EXPECTED_REMOTE" >/dev/null 2>&1 \
    || { _abort_handled=1; _abort "remote '$EXPECTED_REMOTE' 미등록" "git remote add $EXPECTED_REMOTE <URL>"; }
git ls-remote --exit-code "$EXPECTED_REMOTE" >/dev/null 2>&1 \
    || { _abort_handled=1; _abort "remote '$EXPECTED_REMOTE' 응답 실패" "네트워크/인증 확인"; }
_remote_url=$(git remote get-url "$EXPECTED_REMOTE")
_pass "Gate 3: remote=$EXPECTED_REMOTE ($_remote_url)"

# Gate 4: local HEAD가 origin/main 보다 앞섬 또는 동일 (push 가능)
git fetch "$EXPECTED_REMOTE" "$EXPECTED_BRANCH" >/dev/null 2>&1 \
    || { _abort_handled=1; _abort "fetch $EXPECTED_REMOTE/$EXPECTED_BRANCH 실패" "네트워크 확인"; }
_local_head=$(git rev-parse HEAD)
_remote_head=$(git rev-parse "$EXPECTED_REMOTE/$EXPECTED_BRANCH")
_ahead=$(git rev-list --count "$_remote_head..$_local_head")
_behind=$(git rev-list --count "$_local_head..$_remote_head")
if [ "$_behind" -gt 0 ]; then
    _abort_handled=1
    _abort "local이 origin보다 $_behind commit 뒤짐 (rewrite 또는 pull 필요)" \
           "git pull --rebase $EXPECTED_REMOTE $EXPECTED_BRANCH (신중)"
fi
_pass "Gate 4: local HEAD ahead=$_ahead, behind=$_behind (push 가능)"

# Gate 5: local tag v0.6.2 부재 (멱등성)
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    _existing_tag_sha=$(git rev-parse "$TAG_NAME")
    if [ "$_existing_tag_sha" = "$_local_head" ]; then
        _info "Gate 5: local tag $TAG_NAME 이미 존재 (HEAD와 동일 SHA, 재실행으로 간주). tag 생성 skip 예정."
        TAG_ALREADY_LOCAL=1
    else
        _abort_handled=1
        _abort "local tag $TAG_NAME 존재하나 HEAD와 다른 SHA ($_existing_tag_sha)" \
               "git tag -d $TAG_NAME 후 재실행 (신중)"
    fi
else
    _pass "Gate 5: local tag $TAG_NAME 부재 (신규 생성 예정)"
    TAG_ALREADY_LOCAL=0
fi

# Gate 6: remote tag v0.6.2 부재
_remote_tag=$(git ls-remote --tags "$EXPECTED_REMOTE" "refs/tags/$TAG_NAME" 2>/dev/null | head -1)
if [ -n "$_remote_tag" ]; then
    if [ "$TAG_ALREADY_LOCAL" = "1" ]; then
        _info "Gate 6: remote tag $TAG_NAME 이미 존재. push --tags skip 예정 (멱등성)."
        TAG_ALREADY_REMOTE=1
    else
        _abort_handled=1
        _abort "remote tag $TAG_NAME 이미 존재 (local과 충돌 위험): $_remote_tag" \
               "git ls-remote --tags origin $TAG_NAME 확인 후 신중 처리"
    fi
else
    _pass "Gate 6: remote tag $TAG_NAME 부재"
    TAG_ALREADY_REMOTE=0
fi

# Gate 7: Stage 9 review + Stage 12 QA 산출물 존재
[ -f "docs/04_review/v0.6.2_code_review.md" ] \
    || { _abort_handled=1; _abort "Stage 9 review 산출물 부재" "Stage 9 진행 후 재실행"; }
[ -f "docs/05_qa/v0.6.2_qa_checklist.md" ] \
    || { _abort_handled=1; _abort "Stage 12 QA 산출물 부재" "Stage 12 진행 후 재실행"; }
grep -q "verdict: PASS\|verdict: ALL PASS" docs/04_review/v0.6.2_code_review.md \
    || { _abort_handled=1; _abort "Stage 9 verdict PASS 미확인" "review.md frontmatter 확인"; }
grep -q "verdict: ALL PASS" docs/05_qa/v0.6.2_qa_checklist.md \
    || { _abort_handled=1; _abort "Stage 12 verdict ALL PASS 미확인" "qa_checklist.md frontmatter 확인"; }
_pass "Gate 7: Stage 9 PASS + Stage 12 ALL PASS 산출물 확인"

# ============================================================================
# 실행 — push + tag + push --tags
# ============================================================================

printf '\n=== 실행 단계 (mode: %s) ===\n\n' "$MODE"

# Step 1: git push origin main
printf '[1/3] push %s/%s\n' "$EXPECTED_REMOTE" "$EXPECTED_BRANCH"
if [ "$_ahead" -eq 0 ]; then
    _info "local HEAD가 origin과 동일 (ahead=0). push skip (멱등성)."
else
    _run git push "$EXPECTED_REMOTE" "$EXPECTED_BRANCH"
fi

# Step 2: git tag v0.6.2
printf '\n[2/3] create tag %s\n' "$TAG_NAME"
if [ "$TAG_ALREADY_LOCAL" = "1" ]; then
    _info "local tag $TAG_NAME 이미 존재. 생성 skip."
else
    _run git tag "$TAG_NAME"
fi

# Step 3: git push origin <tag> (단일 tag만 push, --tags 전체 push 회피)
printf '\n[3/3] push tag %s to %s\n' "$TAG_NAME" "$EXPECTED_REMOTE"
if [ "$TAG_ALREADY_REMOTE" = "1" ]; then
    _info "remote tag $TAG_NAME 이미 존재. push skip."
else
    _run git push "$EXPECTED_REMOTE" "refs/tags/$TAG_NAME"
fi

# ============================================================================
# 완료 보고
# ============================================================================

printf '\n=== 완료 ===\n'
if [ "$MODE" = "dry-run" ]; then
    printf '  ℹ️   dry-run 종료. mutation 0건. 실 실행: --confirm 옵션 추가.\n'
else
    printf '  HEAD:       %s (%s)\n' "$(git rev-parse --short HEAD)" "$(git log -1 --pretty=format:'%s')"
    printf '  Tag:        %s → %s\n' "$TAG_NAME" "$(git rev-parse --short "$TAG_NAME" 2>/dev/null || echo unknown)"
    printf '  Remote URL: %s\n' "$_remote_url"
    printf '  GitHub:     https://github.com/Hyoungjin-Lee/jOneFlow/releases/tag/%s\n' "$TAG_NAME"
fi

exit 0
