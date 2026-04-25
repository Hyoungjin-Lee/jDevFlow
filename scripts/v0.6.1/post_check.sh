#!/bin/sh
# post_check.sh - v0.6.1 N1 filter-repo 직후 잔존 검증 (축소판).
# Reference: technical_design.md Sec.3.5 (D2 사후 정리) + Sec.4 단계 3, 3.5.
#
# 책임 (S2 안전 제약 적용):
#   - 잔존 grep 검증 (AC-N1-1)
#   - 커밋 메시지 잔존 검증 (AC-N1-3)
#   - 백업 브랜치 보존 확인 (Change-1)
#
# 🔴 S2: reflog gc / refs/original 정리 코드 일체 제거.
#   - git reflog expire / git gc --prune / rm -rf .git/refs/original / git update-ref -d 류 금지
#   - 사고 회고: 이전 sessions에서 post_check가 reflog gc 실행 -> backup unreachable
#                객체 영구 삭제 -> 복구 불가능 catastrophic failure 발생.
#   - 본 버전: 잔존 검증만. 정리 행위 자체 금지 (백업 영구 보존 정책 강화).
#   - refs/original 정리가 정 필요하면 별도 cleanup_after_v061.sh로 분리 + 운영자 명시 트리거.
#
# Usage:
#   sh scripts/v0.6.1/post_check.sh
#
# Exit codes:
#   0 모든 검증 PASS
#   1 잔존 hits 발견 또는 검증 실패

set -eu

# shellcheck disable=SC1007  # CDPATH= idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$ROOT"

BACKUP_BRANCH="backup-pre-v0.6.1-rename"

_pass() { printf '  PASS  %s\n' "$1"; }
_fail() { printf '  FAIL  %s\n    -> %s\n' "$1" "$2" >&2; exit 1; }
_warn() { printf '  WARN  %s\n' "$1" >&2; }

printf '=== v0.6.1 N1 사후 검증 시작 (S2: reflog gc 비실행) ===\n\n'

# 1. AC-N1-1: 잔존 grep (worktree 파일) ---------------------------------
#    예외: .git/, node_modules/, 백업 브랜치(체크아웃 안 되면 worktree에 없음).
_grep_hits=$(grep -rnE 'jOneFlow|joneflow|JONEFLOW' . \
               --exclude-dir=.git --exclude-dir=node_modules \
               2>/dev/null | wc -l | tr -d ' ')
if [ "$_grep_hits" = "0" ]; then
    _pass "AC-N1-1 잔존 grep = 0 hits"
else
    printf '  잔존 hits 위치 (앞 10건):\n' >&2
    grep -rnE 'jOneFlow|joneflow|JONEFLOW' . \
        --exclude-dir=.git --exclude-dir=node_modules \
        2>/dev/null | head -10 | sed 's|^|    |' >&2
    _fail "AC-N1-1 잔존 grep = $_grep_hits hits" \
          "위치별 수동 패치 또는 expressions.txt 보강 후 백업 브랜치에서 reset+재실행"
fi

# 2. AC-N1-3: 커밋 메시지 잔존 -----------------------------------------
_msg_hits=$(git log --all --pretty=format:'%H %s' 2>/dev/null \
              | grep -cE 'jOneFlow|joneflow|JONEFLOW' || true)
if [ "$_msg_hits" = "0" ]; then
    _pass "AC-N1-3 커밋 메시지 잔존 = 0 hits"
else
    printf '  잔존 메시지 (앞 5건):\n' >&2
    git log --all --pretty=format:'%H %s' \
        | grep -E 'jOneFlow|joneflow|JONEFLOW' | head -5 \
        | sed 's|^|    |' >&2
    _fail "AC-N1-3 커밋 메시지 잔존 = $_msg_hits hits" \
          "filter-repo 옵션 점검 후 백업 브랜치에서 reset+재실행"
fi

# 3. 백업 브랜치 보존 확인 (Change-1) ----------------------------------
if git show-ref --verify --quiet "refs/heads/$BACKUP_BRANCH"; then
    _pass "백업 브랜치 보존 확인: $BACKUP_BRANCH (영구, Change-1)"
else
    _warn "백업 브랜치 부재 - pre_check.sh 1단계 누락 또는 외부 삭제"
fi

# 4. refs/original 잔존 안내 (S2: 정리 안 함, 안내만) ------------------
if [ -d .git/refs/original ]; then
    _warn ".git/refs/original 잔존 - filter-repo 부산물 (S2 정책: 자동 정리 금지)"
    _warn "  origin push 완료 후 운영자 판단 시 cleanup_after_v061.sh 별도 실행"
fi

printf '\n=== post_check.sh: 모든 검증 PASS (정리 행위 0건, S2) ===\n'
exit 0
