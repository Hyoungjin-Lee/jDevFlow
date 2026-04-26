#!/bin/sh
# pre_check.sh - v0.6.1 N1 rename 사전 점검 + 백업 브랜치 생성.
# Reference: technical_design.md Sec.3.4 (D2 사전 점검) + Sec.4 단계 0~1.
#
# 책임:
#   - filter-repo 실행 전 환경 검증 (8 항목)
#   - 백업 브랜치 생성 (Change-1: 영구 보존)
#   - 상위 경로 baseline grep + 하드코딩 위치 사전 식별 (info)
#
# 운영자 변경사항 흡수:
#   - Change-1 (백업 영구): 백업 브랜치 생성, 삭제 단계 없음
#   - Change-2 (stale lock 운영자 사전 정리): 사후 검증만 수행
#
# 사고 후 안전 제약 (S1-S5 적용):
#   - S2: reflog gc / refs/original 정리 코드 일체 없음 (사고 직접 원인 회피)
#   - S3: shebang 첫 바이트 0x23 보장
#   - S4: filter-repo 실 실행 없음 (스크립트 작성/검증 영역)
#
# Usage:
#   sh scripts/v0.6.1/pre_check.sh           - 실 실행 (백업 브랜치 생성)
#   DRY_RUN=1 sh scripts/v0.6.1/pre_check.sh - 백업 브랜치 생성도 echo만
#
# Exit codes:
#   0 모든 점검 PASS
#   1 점검 실패 (메시지 + 라인 표기)
#   2 환경 오류 (도구 미설치 등)

set -eu

# shellcheck disable=SC1007  # CDPATH= idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$ROOT"

DRY_RUN="${DRY_RUN:-0}"
BACKUP_BRANCH="backup-pre-v0.6.1-rename"
EXPR_FILE="$ROOT/scripts/v0.6.1/expressions.md"

# D4 patch: filter-repo 자기-치환 회피.
# 'j'/'J' 첫 글자를 printf hex로 분리 → 디스크에 원본 단어 단일 시퀀스 0 등장
# → 미래 filter-repo 재실행 시 expressions.md 매칭 회피 (자기-치환 false-positive 방지).
_pj=$(printf '\x6a')   # 'j'
_puj=$(printf '\x4a')  # 'J'
_old_pattern="${_pj}DevFlow|${_pj}devflow|${_puj}DEVFLOW"

_pass() { printf '  PASS  %s\n' "$1"; }
_fail() { printf '  FAIL  %s\n    -> %s\n' "$1" "$2" >&2; exit 1; }
_info() { printf '  INFO  %s\n' "$1"; }
_die_env() { printf 'pre_check.sh: 환경 오류: %s\n' "$1" >&2; exit 2; }

printf '=== v0.6.1 N1 사전 점검 시작 (DRY_RUN=%s) ===\n\n' "$DRY_RUN"

# 1. git-filter-repo 설치 확인 -----------------------------------------
if ! command -v git-filter-repo >/dev/null 2>&1; then
    _die_env "git-filter-repo 미설치 - brew install git-filter-repo"
fi
_pass "git-filter-repo 설치 확인 ($(command -v git-filter-repo))"

# 2. main 브랜치 + working tree clean ----------------------------------
_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
[ "$_branch" = "main" ] || _fail "현재 브랜치=$_branch (기대=main)" "git checkout main"

if [ -n "$(git status --porcelain)" ]; then
    _fail "working tree dirty" "git status - commit 또는 stash 필요"
fi
_pass "main 브랜치 + working tree clean"

# 3. stale lock 사후 검증 (Change-2 - 운영자 사전 정리 완료 가정) ------
_lock_count=0
for _f in .git/*.lock.stale*; do
    [ -e "$_f" ] && _lock_count=$((_lock_count + 1))
done
if [ "$_lock_count" -gt 0 ]; then
    printf '  발견된 stale lock 파일:\n' >&2
    # shellcheck disable=SC2012  # 메시지 출력용 - find 대비 가독성 우선.
    ls .git/*.lock.stale* 2>/dev/null | sed 's|^|    |' >&2
    _fail "stale lock $_lock_count 건 잔존 (Change-2: 정리 책임 = 운영자)" \
          "운영자에게 정리 요청 후 재실행"
fi
_pass "stale lock 사후 검증 (0건)"

# 4. 백업 브랜치 idempotent 확인 (옵션 C patch) ------------------------
#    - 부재: 9단계에서 신규 생성 (정상 흐름)
#    - 존재 + SHA == HEAD: 이미 안전망 보존 → PASS (rename_n1 phase1 재호출 시나리오)
#    - 존재 + SHA != HEAD: 이전 시도 흔적 가능 → FAIL (잘못된 백업)
if git show-ref --verify --quiet "refs/heads/$BACKUP_BRANCH"; then
    _backup_sha=$(git rev-parse "$BACKUP_BRANCH")
    _head_sha=$(git rev-parse HEAD)
    if [ "$_backup_sha" = "$_head_sha" ]; then
        _pass "백업 브랜치 존재 + SHA == HEAD ($_head_sha) - idempotent PASS"
    else
        _fail "백업 브랜치 '$BACKUP_BRANCH' SHA 불일치 (backup=$_backup_sha vs HEAD=$_head_sha)" \
              "이전 시도 흔적 - 이전 결과 확인 후 git branch -D $BACKUP_BRANCH"
    fi
else
    _pass "백업 브랜치 부재 확인 (이전 시도 흔적 없음)"
fi

# 5. expressions.md 존재 + 정확히 3 매핑 (S1) -------------------------
[ -f "$EXPR_FILE" ] || _fail "expressions.md 부재" "scripts/v0.6.1/expressions.md 작성"
_total_lines=$(wc -l < "$EXPR_FILE" | tr -d ' ')
_mapping_count=$(grep -cE '^[A-Za-z]+==>[A-Za-z]+$' "$EXPR_FILE" || true)
_comment_count=$(grep -cE '^#' "$EXPR_FILE" || true)
[ "$_mapping_count" = "3" ] \
    || _fail "expressions.md 매핑 라인 수 = $_mapping_count (기대=3)" \
             "S1: 정확히 3 매핑만 (jOneFlow/joneflow/JONEFLOW)"
[ "$_comment_count" = "0" ] \
    || _fail "expressions.md 주석 라인 = $_comment_count (기대=0)" \
             "S1: 주석 라인 일체 금지 (단독 # 라인이 모든 # 마스킹 사고 원인)"
[ "$_total_lines" = "3" ] \
    || _fail "expressions.md 총 라인 수 = $_total_lines (기대=3)" \
             "S1: 매핑 외 일체 금지"
_pass "expressions.md: 3 매핑 / 주석 0 / 총 3 라인 (S1)"

# 6. 상위 경로 baseline grep (AC-N1-8 baseline) ------------------------
_upper_baseline=$(grep -rnE "$_old_pattern" \
                    /Users/geenya/projects/Jonelab_Platform/ \
                    --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git \
                    --include='*.md' --include='*.sh' --include='*.json' \
                    2>/dev/null | wc -l | tr -d ' ')
_info "상위 경로 baseline grep hits = $_upper_baseline (AC-N1-8 사후 비교 기준)"

if [ "$_upper_baseline" != "0" ]; then
    printf '  baseline 위치:\n'
    grep -rnE "$_old_pattern" \
        /Users/geenya/projects/Jonelab_Platform/ \
        --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git \
        --include='*.md' --include='*.sh' --include='*.json' \
        2>/dev/null | sed 's|^|    |'
    _info "Q5-2 default(A): 폴더 mv 후 자동 무효화"
fi

# 7. 하드코딩 위치 사전 식별 (정보 출력) -------------------------------
_info "하드코딩 위치 사전 확인 (filter-repo 자동 치환 대상):"
for _hf in tests/bundle1/run_bundle1.sh \
           tests/v0.6/test_init_project_verbatim.sh \
           scripts/release.sh \
           scripts/watch_v061_plan.sh \
           scripts/watch_v061_stage5.sh; do
    if [ -f "$_hf" ]; then
        _hit=$(grep -cE "$_old_pattern" "$_hf" 2>/dev/null || true)
        printf '    %s: %s hits\n' "$_hf" "$_hit"
    fi
done

# 8. IDE/세션 종료 안내 (수동 확인 - 자동 검증 불가) -------------------
_info "filter-repo 실행 전 다음을 수동 확인:"
printf '    [ ] VSCode / JetBrains / 기타 IDE 종료\n'
printf '    [ ] 본 tmux 외 claude --teammate-mode 세션 종료\n'
printf '    [ ] 본 repo의 다른 터미널 작업 종료\n'

# 9. 백업 브랜치 생성 (Change-1: 영구 보존) — idempotent ----------------
if [ "$DRY_RUN" = "1" ]; then
    _info "DRY_RUN: git branch $BACKUP_BRANCH (실행 생략)"
elif git show-ref --verify --quiet "refs/heads/$BACKUP_BRANCH"; then
    _info "백업 브랜치 이미 존재 (4번 게이트에서 SHA 동일 PASS) - 신규 생성 skip"
else
    git branch "$BACKUP_BRANCH"
    if git show-ref --verify --quiet "refs/heads/$BACKUP_BRANCH"; then
        _pass "백업 브랜치 생성 완료: $BACKUP_BRANCH (영구 보존, Change-1)"
    else
        _fail "백업 브랜치 생성 실패" "git reflog 확인 후 재시도"
    fi
fi

printf '\n=== pre_check.sh: 모든 점검 PASS ===\n'
exit 0
