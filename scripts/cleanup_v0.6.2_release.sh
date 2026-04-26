#!/bin/sh
# cleanup_v0.6.2_release.sh — v0.6.2 release 잔재 정리
#
# 위험 명령 정책(세션 26): git stage/commit은 본 스크립트를 통해서만 실행.
# push는 본 스크립트 범위 외 (별도 운영자 승인 게이트).
#
# 사용법:
#   sh scripts/cleanup_v0.6.2_release.sh            # dry-run (기본)
#   sh scripts/cleanup_v0.6.2_release.sh --dry-run  # 명시적 dry-run
#   sh scripts/cleanup_v0.6.2_release.sh --confirm  # 실 실행 (운영자 명시 승인 후)
#
# 처리 대상:
#   1. handoffs/active/HANDOFF_v0.6.2.md → git rm (물리 파일은 이미 archive 이동됨)
#   2. handoffs/archive/HANDOFF_v0.6.2.md → git add (untracked)
#   3. dispatch/archive/ 신규 생성
#   4. dispatch/2026-04-26_v0.6.2_stage13_deploy.md → dispatch/archive/ 이동 + git add
#   5. dispatch/2026-04-27_v0.6.2_release_cleanup.md → dispatch/archive/ 이동 + git add
#   6. handoffs/active/HANDOFF_v0.6.3.md 신규 → git add (이미 생성됨)
#   7. HANDOFF.md symlink → handoffs/active/HANDOFF_v0.6.3.md 재연결 + git add
#   8. 단일 commit (git_checkpoint.sh 사용)
#
# 안전장치:
#   - --dry-run 기본 (mutation 0)
#   - set -eu + trap EXIT
#   - v0.6.3 영역 파일 stage 금지 (방어 검증)
#   - 멱등성 (재실행 안전)

set -eu

# shellcheck disable=SC1007
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"

MODE="dry-run"
case "${1:-}" in
    --confirm)  MODE="confirm" ;;
    --dry-run)  MODE="dry-run" ;;
    "")         MODE="dry-run" ;;
    -h|--help)
        sed -n '2,20p' "$0" | sed 's|^# \{0,1\}||'
        exit 0
        ;;
    *)
        printf 'cleanup_v0.6.2_release.sh: 알 수 없는 인자: %s\n' "$1" >&2
        printf '사용법: sh scripts/cleanup_v0.6.2_release.sh [--dry-run|--confirm]\n' >&2
        exit 2
        ;;
esac

# ============================================================================
# 안전장치
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
        printf '\n❌ cleanup_v0.6.2_release.sh: 예기치 못한 종료 (exit=%s)\n' "$_ec" >&2
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
_run()   {
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
if [ "$_branch" != "main" ]; then
    _abort "브랜치가 main이 아닙니다: $_branch" "git checkout main"
fi
_pass "브랜치 = main"

# Gate 2: v0.6.3 영역 파일이 staged 상태가 아닌지 확인 (방어)
_v063_staged=$(git diff --cached --name-only | grep -E "^docs/.*v0\.6\.3|^dispatch/2026-04-26_v0\.6\.3" || true)
if [ -n "$_v063_staged" ]; then
    _abort "v0.6.3 영역 파일이 이미 staged 상태입니다: $_v063_staged" "git restore --staged <파일>"
fi
_pass "v0.6.3 영역 staged 없음"

# Gate 3: HANDOFF_v0.6.2.md 아카이브 파일 존재 + status: archived 확인
if [ ! -f "handoffs/archive/HANDOFF_v0.6.2.md" ]; then
    _abort "handoffs/archive/HANDOFF_v0.6.2.md 없음" "수동으로 archive 확인 필요"
fi
if ! grep -q "status: archived" "handoffs/archive/HANDOFF_v0.6.2.md"; then
    _abort "handoffs/archive/HANDOFF_v0.6.2.md frontmatter에 'status: archived' 없음" \
        "파일 내용 확인 필요"
fi
_pass "handoffs/archive/HANDOFF_v0.6.2.md 존재 && status: archived"

# Gate 4: HANDOFF_v0.6.3.md 스켈레톤 존재 확인
if [ ! -f "handoffs/active/HANDOFF_v0.6.3.md" ]; then
    _abort "handoffs/active/HANDOFF_v0.6.3.md 없음" \
        "파이널리즈(안영이)가 스켈레톤 생성 전 확인 필요"
fi
_pass "handoffs/active/HANDOFF_v0.6.3.md 존재"

# Gate 5: dispatch 대상 파일 존재 확인
_deploy_md="dispatch/2026-04-26_v0.6.2_stage13_deploy.md"
_cleanup_md="dispatch/2026-04-27_v0.6.2_release_cleanup.md"
for _f in "$_deploy_md" "$_cleanup_md"; do
    if [ ! -f "$_f" ]; then
        _warn "$_f 없음 — 이미 archive됐을 수 있음 (멱등성: skip)"
    fi
done
_pass "dispatch 대상 파일 확인 완료"

# ============================================================================
# 처리 계획 출력
# ============================================================================

printf '\n📋 처리 계획 (MODE=%s)\n' "$MODE"

printf '  1. git rm handoffs/active/HANDOFF_v0.6.2.md (물리 파일 이미 archive로 이동됨)\n'
printf '  2. git add handoffs/archive/HANDOFF_v0.6.2.md\n'
printf '  3. dispatch/archive/ 생성 (없을 경우)\n'
printf '  4. %s → dispatch/archive/ 이동 + git add\n' "$_deploy_md"
printf '  5. %s → dispatch/archive/ 이동 + git add\n' "$_cleanup_md"
printf '  6. git add handoffs/active/HANDOFF_v0.6.3.md\n'
printf '  7. ln -sfn handoffs/active/HANDOFF_v0.6.3.md HANDOFF.md + git add HANDOFF.md\n'
printf '  8. 단일 commit (git_checkpoint.sh)\n'

# ============================================================================
# 실행
# ============================================================================

printf '\n⚙️  실행\n'

# 1. git rm 이미 삭제된 active HANDOFF_v0.6.2.md (tracked)
if git ls-files --error-unmatch "handoffs/active/HANDOFF_v0.6.2.md" 2>/dev/null; then
    _run "git rm --cached handoffs/active/HANDOFF_v0.6.2.md"
    _info "handoffs/active/HANDOFF_v0.6.2.md → index에서 제거"
else
    _info "handoffs/active/HANDOFF_v0.6.2.md 이미 index에서 제거됨 (멱등성: skip)"
fi

# 2. git add archive HANDOFF
if ! git ls-files --error-unmatch "handoffs/archive/HANDOFF_v0.6.2.md" 2>/dev/null; then
    _run "git add handoffs/archive/HANDOFF_v0.6.2.md"
    _info "handoffs/archive/HANDOFF_v0.6.2.md → staged"
else
    _info "handoffs/archive/HANDOFF_v0.6.2.md 이미 tracked (멱등성: skip)"
fi

# 3. dispatch/archive/ 생성
if [ ! -d "dispatch/archive" ]; then
    _run "mkdir -p dispatch/archive"
    _info "dispatch/archive/ 생성"
else
    _info "dispatch/archive/ 이미 존재 (멱등성: skip)"
fi

# 4. deploy dispatch 이동 + git add
_archive_deploy="dispatch/archive/2026-04-26_v0.6.2_stage13_deploy.md"
if [ -f "$_deploy_md" ]; then
    _run "mv '$_deploy_md' '$_archive_deploy'"
    _run "git add '$_archive_deploy'"
    _info "$_deploy_md → dispatch/archive/ 이동 + staged"
elif [ -f "$_archive_deploy" ]; then
    if ! git ls-files --error-unmatch "$_archive_deploy" 2>/dev/null; then
        _run "git add '$_archive_deploy'"
        _info "$_archive_deploy 이미 이동됨, staged 처리"
    else
        _info "$_archive_deploy 이미 tracked (멱등성: skip)"
    fi
else
    _warn "$_deploy_md 없음, archive에도 없음 — 수동 확인 필요"
fi

# 5. cleanup dispatch 이동 + git add
_archive_cleanup="dispatch/archive/2026-04-27_v0.6.2_release_cleanup.md"
if [ -f "$_cleanup_md" ]; then
    _run "mv '$_cleanup_md' '$_archive_cleanup'"
    _run "git add '$_archive_cleanup'"
    _info "$_cleanup_md → dispatch/archive/ 이동 + staged"
elif [ -f "$_archive_cleanup" ]; then
    if ! git ls-files --error-unmatch "$_archive_cleanup" 2>/dev/null; then
        _run "git add '$_archive_cleanup'"
        _info "$_archive_cleanup 이미 이동됨, staged 처리"
    else
        _info "$_archive_cleanup 이미 tracked (멱등성: skip)"
    fi
else
    _warn "$_cleanup_md 없음, archive에도 없음 — 수동 확인 필요"
fi

# 6. HANDOFF_v0.6.3.md staged
if ! git ls-files --error-unmatch "handoffs/active/HANDOFF_v0.6.3.md" 2>/dev/null; then
    _run "git add handoffs/active/HANDOFF_v0.6.3.md"
    _info "handoffs/active/HANDOFF_v0.6.3.md → staged"
else
    _info "handoffs/active/HANDOFF_v0.6.3.md 이미 tracked (멱등성: skip)"
fi

# 7. HANDOFF.md symlink 재연결
_symlink_target="handoffs/active/HANDOFF_v0.6.3.md"
_run "ln -sfn '$_symlink_target' HANDOFF.md"
_run "git add HANDOFF.md"
_info "HANDOFF.md → $_symlink_target 재연결 + staged"

# 8. staged 상태 출력 (검증)
printf '\n📦 staged 상태 (예상 변경 목록):\n'
if [ "$MODE" = "confirm" ]; then
    git diff --cached --name-status
else
    _dry "git diff --cached --name-status  (dry-run이므로 실제 staged 없음)"
fi

# v0.6.3 영역 staged 방어 검증 (--confirm 시만)
if [ "$MODE" = "confirm" ]; then
    _staged_v063=$(git diff --cached --name-only | grep -E "^docs/.*v0\.6\.3|^dispatch/2026-04-26_v0\.6\.3" || true)
    if [ -n "$_staged_v063" ]; then
        _abort "v0.6.3 영역 파일이 실수로 staged됨: $_staged_v063" \
            "git restore --staged <파일> 후 재실행"
    fi
    _pass "staged 파일 중 v0.6.3 영역 없음 (방어 검증 PASS)"
fi

# ============================================================================
# commit
# ============================================================================

if [ "$MODE" = "confirm" ]; then
    printf '\n🔖 commit 실행\n'
    sh scripts/git_checkpoint.sh \
        "release(v0.6.2): handoff archive + dispatch archive + HANDOFF v0.6.3 symlink 정리" \
        handoffs/active/HANDOFF_v0.6.3.md \
        handoffs/archive/HANDOFF_v0.6.2.md \
        HANDOFF.md

    _commit_sha=$(git rev-parse --short HEAD)
    _pass "commit 완료: $_commit_sha"

    # symlink 검증
    printf '\n🔗 symlink 검증:\n'
    printf '  readlink HANDOFF.md = %s\n' "$(readlink HANDOFF.md)"
    _target_actual=$(readlink HANDOFF.md)
    if [ "$_target_actual" = "$_symlink_target" ]; then
        _pass "HANDOFF.md → $_symlink_target 정상"
    else
        _abort "symlink 불일치: expected=$_symlink_target actual=$_target_actual" \
            "ln -sfn $_symlink_target HANDOFF.md 수동 실행"
    fi

    printf '\n✅ cleanup_v0.6.2_release.sh 완료\n'
    printf '  commit SHA : %s\n' "$_commit_sha"
    printf '  HANDOFF.md → %s\n' "$_symlink_target"
    printf '  push       : 별도 운영자 승인 게이트 (본 스크립트 범위 외)\n'
else
    printf '\n🔵 [DRY-RUN 완료] 실 실행하려면:\n'
    printf '  sh scripts/cleanup_v0.6.2_release.sh --confirm\n'
fi
