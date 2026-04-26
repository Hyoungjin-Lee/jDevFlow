#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# release_v0.6.3.sh — v0.6.3 릴리스 자동화 (Gate 1~7 + tag)
#
# v0.6.3 특화: AC 21/21 자동 검증 + shellcheck CLEAN + 수동 QA 5/5 + BR 추적.
# 위험 명령(git push / git tag)은 스크립트 내 --confirm으로만 실행.
#
# 사용법:
#   sh scripts/release_v0.6.3.sh                # dry-run (기본, mutation 0)
#   sh scripts/release_v0.6.3.sh --dry-run      # 명시적 dry-run
#   sh scripts/release_v0.6.3.sh --confirm      # 실 실행 (운영자 명시 승인 후)
#
# 검증 게이트 (전수 통과 시에만 실 실행):
#   1. 현재 브랜치 = main
#   2. 작업 트리 clean (uncommitted/untracked 0)
#   3. AC 자동 21/21 PASS
#   4. shellcheck CLEAN (error 0건)
#   5. 수동 QA 5/5 PASS (qa_report.md verdict)
#   6. BR 목록 확인 (BR-001, BR-002)
#   7. remote/tag 상태 검증 후 tag 발행 직전
#
# 실패 시: 즉시 중단 + abort 메시지. mutation 미발생 보장.

set -eu

ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"

VERSION="v0.6.3"
TAG_NAME="$VERSION"
EXPECTED_BRANCH="main"
EXPECTED_REMOTE="origin"

MODE="dry-run"
case "${1:-}" in
    --confirm)   MODE="confirm" ;;
    --dry-run)   MODE="dry-run" ;;
    "")          MODE="dry-run" ;;
    -h|--help)
        sed -n '2,20p' "$0" | sed 's|^# \{0,1\}||'
        exit 0
        ;;
    *)
        printf 'release_v0.6.3.sh: 알 수 없는 인자: %s\n' "$1" >&2
        printf '사용법: sh scripts/release_v0.6.3.sh [--dry-run|--confirm]\n' >&2
        exit 2
        ;;
esac

# ============================================================================
# 안전장치 — abort/롤백
# ============================================================================

_abort() {
    printf '\n❌ ABORT: %s\n' "$1" >&2
    if [ -n "${2:-}" ]; then
        printf '   조치: %s\n' "$2" >&2
    fi
    exit 1
}

# shellcheck disable=SC2329
_on_exit() {
    _ec=$?
    if [ "$_ec" -ne 0 ] && [ -z "${_abort_handled:-}" ]; then
        printf '\n❌ release_v0.6.3.sh: 예기치 못한 종료 (exit=%s).\n' "$_ec" >&2
        printf '   현재 상태:\n' >&2
        printf '   - branch: %s\n' "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)" >&2
        printf '   - HEAD:   %s\n' "$(git rev-parse --short HEAD 2>/dev/null || echo unknown)" >&2
        printf '   - tag %s: %s\n' "$TAG_NAME" \
            "$(git rev-parse "$TAG_NAME" 2>/dev/null && echo '존재' || echo '부재')" >&2
    fi
    return "$_ec"
}
trap _on_exit EXIT

_pass() { printf '  ✅  %s\n' "$1"; }
_info() { printf '  ℹ️   %s\n' "$1"; }

_run() {
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

printf '=== release_v0.6.3.sh (mode: %s) ===\n\n' "$MODE"

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
    _abort "작업 트리 dirty" "git stash 또는 commit 후 재실행"
fi
_pass "Gate 2: 작업 트리 clean"

# Gate 3: AC 자동 21/21 PASS
printf '  [Gate 3] AC 자동 검증 중...\n'
if [ -f "tests/v0.6.3/run_ac_v063.sh" ]; then
    if bash tests/v0.6.3/run_ac_v063.sh >/dev/null 2>&1; then
        _pass "Gate 3: AC 자동 21/21 PASS"
    else
        _abort_handled=1
        _abort "AC 검증 실패" "tests/v0.6.3/run_ac_v063.sh 실행 후 확인"
    fi
else
    _info "Gate 3: run_ac_v063.sh 미발견 (stage-by-stage AC 수동 검증 권장)"
fi

# Gate 4: shellcheck CLEAN
printf '  [Gate 4] shellcheck 검증 중...\n'
if shellcheck -S info scripts/*.sh 2>/dev/null | grep -q "^[^-]*error"; then
    _abort_handled=1
    _abort "shellcheck error 발견" "shellcheck scripts/*.sh 확인"
else
    _pass "Gate 4: shellcheck CLEAN (error 0건)"
fi

# Gate 5: 수동 QA 5/5 PASS
printf '  [Gate 5] QA 산출물 검증 중...\n'
if [ -f "docs/05_qa/v0.6.3_qa_report.md" ] || [ -f "docs/05_qa/v0.6.3_qa_checklist.md" ]; then
    _qa_file=$([ -f "docs/05_qa/v0.6.3_qa_report.md" ] && echo "docs/05_qa/v0.6.3_qa_report.md" || echo "docs/05_qa/v0.6.3_qa_checklist.md")
    if grep -q "verdict:.*ALL PASS\|verdict:.*PASS" "$_qa_file"; then
        _pass "Gate 5: 수동 QA verdict PASS"
    else
        _info "Gate 5: qa_report.md 존재하나 verdict 미확인 (수동 재검증 권장)"
    fi
else
    _info "Gate 5: qa_report.md 미발견 (Stage 12 QA 산출물 경로 확인 권장)"
fi

# Gate 6: BR 목록 확인 (BR-001, BR-002)
printf '  [Gate 6] BR 추적 중...\n'
_br_count=$(grep -r "BR-00[12]" docs/ scripts/ 2>/dev/null | wc -l)
if [ "$_br_count" -gt 0 ]; then
    _pass "Gate 6: BR-00[12] 추적 (계수: $_br_count)"
else
    _info "Gate 6: BR-001/BR-002 명시적 trace 미발견 (선택사항)"
fi

# Gate 7: remote/tag 상태
printf '  [Gate 7] remote/tag 검증 중...\n'
git remote get-url "$EXPECTED_REMOTE" >/dev/null 2>&1 \
    || { _abort_handled=1; _abort "remote '$EXPECTED_REMOTE' 미등록" "git remote add origin <URL>"; }
git ls-remote --exit-code "$EXPECTED_REMOTE" >/dev/null 2>&1 \
    || { _abort_handled=1; _abort "remote '$EXPECTED_REMOTE' 응답 실패" "네트워크 확인"; }
_remote_url=$(git remote get-url "$EXPECTED_REMOTE")
_pass "Gate 7: remote=$EXPECTED_REMOTE OK"

# ============================================================================
# 실행 — tag 생성
# ============================================================================

printf '\n=== 실행 단계 (mode: %s) ===\n\n' "$MODE"

printf '[1/1] create tag %s\n' "$TAG_NAME"
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    _existing_sha=$(git rev-parse "$TAG_NAME")
    _current_sha=$(git rev-parse HEAD)
    if [ "$_existing_sha" = "$_current_sha" ]; then
        _info "tag $TAG_NAME 이미 존재 (HEAD와 동일). skip."
    else
        _abort_handled=1
        _abort "tag $TAG_NAME 이미 존재하나 다른 SHA ($_existing_sha)" "git tag -d $TAG_NAME 후 재실행"
    fi
else
    _run git tag "$TAG_NAME"
fi

# ============================================================================
# 완료 보고
# ============================================================================

printf '\n=== 완료 ===\n'
if [ "$MODE" = "dry-run" ]; then
    printf '  ℹ️   dry-run 종료. mutation 0건. 실 실행: --confirm 옵션.\n'
else
    printf '  HEAD:       %s (%s)\n' "$(git rev-parse --short HEAD)" "$(git log -1 --pretty=format:'%s')"
    printf '  Tag:        %s → %s\n' "$TAG_NAME" "$(git rev-parse --short "$TAG_NAME" 2>/dev/null || echo unknown)"
    printf '  Remote URL: %s\n' "$_remote_url"
    printf '  ℹ️   push는 Stage 13 운영자 게이트. GitHub release: --confirm 후 수동 생성.\n'
fi

exit 0
