#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# cleanup_v0.6.3_release.sh — v0.6.3 release 잔재 정리 (v0.6.2 패턴 계승)
#
# 위험 명령 정책: git stage/commit은 본 스크립트를 통해서만 실행.
# push / git tag는 본 스크립트 범위 외 (별도 운영자 승인 게이트).
#
# 사용법:
#   sh scripts/cleanup_v0.6.3_release.sh            # dry-run (기본)
#   sh scripts/cleanup_v0.6.3_release.sh --dry-run  # 명시적 dry-run
#   sh scripts/cleanup_v0.6.3_release.sh --confirm  # 실 실행 (운영자 명시 승인 후)
#
# 처리 대상:
#   1. handoffs/active/HANDOFF_v0.6.3.md frontmatter status: active → archived 갱신
#   2. handoffs/active/HANDOFF_v0.6.3.md → handoffs/archive/ 이동 + git add
#   3. git rm handoffs/active/HANDOFF_v0.6.3.md (index에서 제거)
#   4. HANDOFF.md symlink → handoffs/active/HANDOFF_v0.6.4.md 재연결 + git add
#   5. CHANGELOG.md v0.6.3 entry git add
#   6. 단일 commit (git_checkpoint.sh 사용)
#
# 안전장치:
#   - --dry-run 기본 (mutation 0)
#   - set -eu + trap EXIT
#   - handoffs/active/HANDOFF_v0.6.4.md 존재 사전 확인 (gate)
#   - 멱등성 (재실행 안전)

set -eu

# shellcheck disable=SC1007
ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"

MODE="dry-run"
case "${1:-}" in
    --confirm)  MODE="confirm" ;;
    --dry-run)  MODE="dry-run" ;;
    "")         MODE="dry-run" ;;
    -h|--help)
        sed -n '2,25p' "$0" | sed 's|^# \{0,1\}||'
        exit 0
        ;;
    *)
        printf 'cleanup_v0.6.3_release.sh: 알 수 없는 인자: %s\n' "$1" >&2
        printf '사용법: sh scripts/cleanup_v0.6.3_release.sh [--dry-run|--confirm]\n' >&2
        exit 2
        ;;
esac

# ============================================================================
# 헬퍼
# ============================================================================

_abort() {
    printf '\n❌ ABORT: %s\n' "$1" >&2
    if [ -n "${2:-}" ]; then
        printf '   조치: %s\n' "$2" >&2
    fi
    exit 1
}

_on_exit() {
    _ec=$?
    if [ "$_ec" -ne 0 ]; then
        printf '\n❌ cleanup_v0.6.3_release.sh: 예기치 못한 종료 (exit=%s)\n' "$_ec" >&2
        printf '   branch=%s HEAD=%s\n' \
            "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)" \
            "$(git rev-parse --short HEAD 2>/dev/null || echo unknown)" >&2
    fi
}
trap _on_exit EXIT

_pass()  { printf '  ✅  %s\n' "$1"; }
_dry()   { printf '  🔵  [DRY-RUN] %s\n' "$1"; }
_info()  { printf '  ℹ️   %s\n' "$1"; }
_warn()  { printf '  ⚠️   %s\n' "$1"; }
_run() {
    if [ "$MODE" = "confirm" ]; then
        eval "$1"
    else
        _dry "$1"
    fi
}

# ============================================================================
# 검증 게이트
# ============================================================================

printf '\n🔍 사전 검증 게이트\n'

# Gate 1: 브랜치 확인
_branch=$(git rev-parse --abbrev-ref HEAD)
[ "$_branch" = "main" ] || _abort "브랜치가 main이 아닙니다: $_branch" "git checkout main"
_pass "Gate 1: 브랜치 = main"

# Gate 2: HANDOFF_v0.6.3.md active 파일 존재
_active_v063="handoffs/active/HANDOFF_v0.6.3.md"
[ -f "$_active_v063" ] || _abort "$_active_v063 없음" "파일 존재 확인 필요"
_pass "Gate 2: handoffs/active/HANDOFF_v0.6.3.md 존재"

# Gate 3: HANDOFF_v0.6.4.md 스켈레톤 존재 확인 (다음 버전)
_active_v064="handoffs/active/HANDOFF_v0.6.4.md"
[ -f "$_active_v064" ] || _abort "$_active_v064 없음" "v0.6.4 스켈레톤 생성 필요"
_pass "Gate 3: handoffs/active/HANDOFF_v0.6.4.md 존재 (다음 버전 스켈레톤)"

# Gate 4: handoffs/archive/ 디렉토리 존재
[ -d "handoffs/archive" ] || _abort "handoffs/archive/ 없음" "mkdir -p handoffs/archive"
_pass "Gate 4: handoffs/archive/ 존재"

# Gate 5: archive에 v0.6.3 파일 없음 (중복 방지)
_archive_v063="handoffs/archive/HANDOFF_v0.6.3.md"
if [ -f "$_archive_v063" ]; then
    _warn "Gate 5: $_archive_v063 이미 존재 — 멱등성: archive 단계 skip 예정"
    _ARCHIVE_SKIP=1
else
    _ARCHIVE_SKIP=0
    _pass "Gate 5: handoffs/archive/HANDOFF_v0.6.3.md 없음 (정상)"
fi

# Gate 6: CHANGELOG.md v0.6.3 entry 존재 확인
grep -q '^\#\# \[0\.6\.3\]' CHANGELOG.md || _abort "CHANGELOG.md에 [0.6.3] entry 없음" "CHANGELOG.md v0.6.3 entry 먼저 작성"
_pass "Gate 6: CHANGELOG.md [0.6.3] entry 존재"

# ============================================================================
# 처리 계획
# ============================================================================

printf '\n📋 처리 계획 (MODE=%s)\n' "$MODE"
printf '  1. HANDOFF_v0.6.3.md frontmatter status → archived 갱신\n'
printf '  2. HANDOFF_v0.6.3.md → handoffs/archive/ 이동\n'
printf '  3. git rm handoffs/active/HANDOFF_v0.6.3.md (index 제거)\n'
printf '  4. git add handoffs/archive/HANDOFF_v0.6.3.md\n'
printf '  5. HANDOFF.md symlink → handoffs/active/HANDOFF_v0.6.4.md 재연결\n'
printf '  6. git add HANDOFF.md CHANGELOG.md\n'
printf '  7. 단일 commit (git_checkpoint.sh)\n'

# ============================================================================
# 실행
# ============================================================================

printf '\n⚙️  실행\n'

# 1. frontmatter status 갱신 (awk POSIX, BSD/GNU sed 호환성 회피 F-62-6)
if [ "$_ARCHIVE_SKIP" = "0" ]; then
    if [ "$MODE" = "confirm" ]; then
        _tmp=$(mktemp)
        awk '
            /^status:/ && !_done { print "status: archived"; _done=1; next }
            { print }
        ' "$_active_v063" > "$_tmp"
        mv "$_tmp" "$_active_v063"
        _info "HANDOFF_v0.6.3.md frontmatter status → archived"
    else
        _dry "awk frontmatter status → archived in $_active_v063"
    fi

    # 2. archive 이동
    _run "mv '$_active_v063' '$_archive_v063'"
    _info "$_active_v063 → $_archive_v063"

    # 3. git rm active (이미 이동됐으므로 --cached)
    if git ls-files --error-unmatch "$_active_v063" 2>/dev/null; then
        _run "git rm --cached '$_active_v063'"
        _info "$_active_v063 index에서 제거"
    else
        _info "$_active_v063 이미 index에서 제거됨 (멱등성: skip)"
    fi

    # 4. git add archive
    _run "git add '$_archive_v063'"
    _info "$_archive_v063 staged"
else
    _info "archive 이미 존재 — 이동 단계 skip (멱등성)"
fi

# 5. HANDOFF.md symlink 재연결
_symlink_target="handoffs/active/HANDOFF_v0.6.4.md"
_current_target=$(readlink HANDOFF.md 2>/dev/null || echo "")
if [ "$_current_target" = "$_symlink_target" ]; then
    _info "HANDOFF.md 이미 → $_symlink_target (멱등성: skip)"
else
    _run "ln -sfn '$_symlink_target' HANDOFF.md"
    _info "HANDOFF.md → $_symlink_target 재연결"
fi
_run "git add HANDOFF.md"

# 6. CHANGELOG.md staged
_run "git add CHANGELOG.md"
_info "CHANGELOG.md staged"

# staged 상태 출력
printf '\n📦 staged 상태:\n'
if [ "$MODE" = "confirm" ]; then
    git diff --cached --name-status
else
    _dry "git diff --cached --name-status  (dry-run이므로 staged 없음)"
fi

# ============================================================================
# commit
# ============================================================================

if [ "$MODE" = "confirm" ]; then
    printf '\n🔖 commit 실행\n'
    sh scripts/git_checkpoint.sh \
        "release(v0.6.3): HANDOFF archive + CHANGELOG v0.6.3 entry + symlink v0.6.4 재연결" \
        CHANGELOG.md \
        HANDOFF.md

    _commit_sha=$(git rev-parse --short HEAD)
    _pass "commit 완료: $_commit_sha"

    # symlink 검증
    printf '\n🔗 symlink 검증:\n'
    _actual=$(readlink HANDOFF.md)
    printf '  readlink HANDOFF.md = %s\n' "$_actual"
    if [ "$_actual" = "$_symlink_target" ]; then
        _pass "HANDOFF.md → $_symlink_target 정상"
    else
        _abort "symlink 불일치: expected=$_symlink_target actual=$_actual" \
            "ln -sfn $_symlink_target HANDOFF.md 수동 실행"
    fi

    printf '\n✅ cleanup_v0.6.3_release.sh 완료\n'
    printf '  commit SHA : %s\n' "$_commit_sha"
    printf '  HANDOFF.md → %s\n' "$_symlink_target"
    printf '  push / tag : 별도 운영자 승인 게이트 (본 스크립트 범위 외)\n'
else
    printf '\n🔵 [DRY-RUN 완료] 실 실행하려면:\n'
    printf '  sh scripts/cleanup_v0.6.3_release.sh --confirm\n'
fi
