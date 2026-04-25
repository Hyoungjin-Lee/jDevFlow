#!/usr/bin/env bash
# rename_n1.sh - v0.6.1 N1 통합 진입점.
# Reference: technical_design.md Sec.4 + Sec.5 + Sec.11.1.
#
# 사고 후 안전 가드 (S5):
#   - --dry-run = DEFAULT (mutation 0). 실 실행은 --apply 명시 의무.
#   - --apply 시 TTY 인터랙티브 confirm prompt 1회 의무 (비-TTY는 명시적 --yes 동시 필요).
#   - phase1 직후 백업 브랜치 SHA + main HEAD SHA 자동 출력 (사후 복구 추적).
#   - filter-repo 실행은 본 스크립트가 호출하지만, 사고 회고로 추가 안전장치 다중화.
#
# Phase 분리:
#   phase1: 0~3.5단계 + verify phase1
#           pre_check -> filter-repo -> post_check(S2 reflog gc 없음) -> verify phase1
#           -> 운영자 인계 시그널 1: GitHub repo rename
#   phase2: 5~5.5단계 + verify phase2
#           git remote add origin -> ls-remote dry check -> verify phase2
#           -> 운영자 인계 시그널 2: force push + 폴더 mv
#
# Usage:
#   bash scripts/v0.6.1/rename_n1.sh phase1                       - DRY-RUN (기본)
#   bash scripts/v0.6.1/rename_n1.sh phase1 --apply               - 실 실행 (TTY confirm)
#   bash scripts/v0.6.1/rename_n1.sh phase1 --apply --yes         - 실 실행 (confirm 생략)
#   bash scripts/v0.6.1/rename_n1.sh phase2 [<new-origin-url>]    - DRY-RUN (기본)
#   bash scripts/v0.6.1/rename_n1.sh phase2 [<url>] --apply       - 실 실행
#   bash scripts/v0.6.1/rename_n1.sh -h | --help
#
# Exit codes:
#   0  해당 phase 완료
#   1  단계 실패 (백업 브랜치에서 복구 후 재시도)
#   2  잘못된 인자
#   3  운영자 confirm 거부

set -eu

# shellcheck disable=SC1007  # CDPATH= idiom.
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$ROOT"

EXPR_FILE="$ROOT/scripts/v0.6.1/expressions.txt"
BACKUP_BRANCH="backup-pre-v0.6.1-rename"
DEFAULT_NEW_URL="https://github.com/Hyoungjin-Lee/jOneFlow.git"

PHASE=""
APPLY=0       # S5: 0 = dry-run (default), 1 = 실 실행
YES=0         # S5: 1 = TTY confirm 생략 (--yes 명시 시)
NEW_URL=""

# 헬퍼 ================================================================

_die() { printf 'rename_n1.sh: %s\n' "$1" >&2; exit "${2:-1}"; }

_run() {
    # 명령 실행 wrapper. APPLY=0 (dry-run)이면 echo만.
    if [ "$APPLY" = "0" ]; then
        printf '  [DRY] %s\n' "$*"
    else
        printf '  [RUN] %s\n' "$*"
        "$@"
    fi
}

_section() {
    printf '\n==========================================================\n'
    printf '  %s\n' "$1"
    printf '==========================================================\n\n'
}

_print_usage() {
    sed -n '2,32p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

# S5: TTY confirm prompt (--apply 시) ---------------------------------
_confirm_apply() {
    if [ "$APPLY" != "1" ]; then
        return 0
    fi
    if [ "$YES" = "1" ]; then
        printf '  [INFO] --yes 명시 - confirm prompt 생략\n'
        return 0
    fi
    if [ ! -t 0 ]; then
        _die "비-TTY 환경에서 --apply 사용 시 --yes 명시 필요 (S5 안전 가드)" 2
    fi
    printf '\n'
    printf '🔴 실 실행 모드 (--apply) - git history 재작성합니다.\n'
    printf '   백업 브랜치: %s (영구 보존, Change-1)\n' "$BACKUP_BRANCH"
    printf '   현 main HEAD: %s\n' "$(git rev-parse HEAD)"
    printf '\n'
    printf '계속 진행하시겠습니까? [yes/no]: '
    read -r _ans
    case "$_ans" in
        yes|YES|y|Y) printf '  [OK] 운영자 confirm - 진행\n' ;;
        *) _die "운영자 confirm 거부 - 중단" 3 ;;
    esac
}

# S5: phase1 직후 SHA 자동 출력 ---------------------------------------
_print_recovery_info() {
    printf '\n  --- 사후 복구 추적 정보 ---\n'
    printf '  현재 main HEAD:   %s\n' "$(git rev-parse HEAD)"
    if git show-ref --verify --quiet "refs/heads/$BACKUP_BRANCH"; then
        printf '  백업 브랜치 SHA: %s (= %s)\n' \
            "$(git rev-parse "$BACKUP_BRANCH")" "$BACKUP_BRANCH"
    else
        printf '  백업 브랜치:     (부재 또는 외부 삭제)\n'
    fi
    printf '  복구가 필요한 경우:\n'
    printf '    git reset --hard %s   (로컬 백업)\n' "$BACKUP_BRANCH"
    printf '    또는 git fetch origin && git reset --hard origin/main   (원격 안전)\n'
    printf '\n'
}

# Phase 1: 0~3.5단계 + verify phase1 ==================================
_run_phase1() {
    _section "Phase 1 시작 - 0~3.5단계 + verify phase1 (APPLY=$APPLY)"
    _confirm_apply

    # 0~1단계: pre_check + 백업 브랜치 생성
    printf '> [0~1단계] pre_check.sh 실행\n'
    if [ "$APPLY" = "0" ]; then
        DRY_RUN=1 sh "$ROOT/scripts/v0.6.1/pre_check.sh"
    else
        sh "$ROOT/scripts/v0.6.1/pre_check.sh"
    fi

    # 2단계: git filter-repo
    printf '\n> [2단계] git filter-repo --replace-text\n'
    _run git filter-repo \
        --replace-text "$EXPR_FILE" \
        --preserve-commit-encoding \
        --force

    # 3~3.5단계: post_check (S2: reflog gc 없음)
    printf '\n> [3~3.5단계] post_check.sh 실행 (S2: reflog gc 없음)\n'
    if [ "$APPLY" = "0" ]; then
        printf '  [DRY] sh %s/scripts/v0.6.1/post_check.sh\n' "$ROOT"
    else
        sh "$ROOT/scripts/v0.6.1/post_check.sh"
    fi

    # 4단계: verify_all phase1
    printf '\n> [4단계] verify_all.sh phase1 (AC-N1-1, 2, 3, 7)\n'
    if [ "$APPLY" = "0" ]; then
        printf '  [DRY] sh %s/scripts/v0.6.1/verify_all.sh phase1\n' "$ROOT"
    else
        sh "$ROOT/scripts/v0.6.1/verify_all.sh" phase1
    fi

    # S5: phase1 직후 SHA 자동 출력 (실 실행 시만 의미 있음)
    if [ "$APPLY" = "1" ]; then
        _print_recovery_info
    fi

    # 운영자 인계 시그널 1
    _section "✅ Phase 1 완료 - 운영자 인계 시그널 1"
    cat <<'SIGNAL_EOF'
다음 = 운영자 작업:

  6단계: GitHub Settings -> Repository name -> jOneFlow
         URL: https://github.com/Hyoungjin-Lee/<repo>/settings
         새 repo 이름: jOneFlow

완료 후 본 세션에 "GitHub rename 완료"라고 알려주시면
오케스트레이터가 다음 명령으로 phase2 진행:

  bash scripts/v0.6.1/rename_n1.sh phase2 --apply

또는 명시적 URL:
  bash scripts/v0.6.1/rename_n1.sh phase2 https://github.com/Hyoungjin-Lee/jOneFlow.git --apply

상태:
  - 백업 브랜치 = backup-pre-v0.6.1-rename (영구 보존, Change-1)
  - filter-repo refs/original 정리는 S2 정책상 자동 실행 안 함
  - 모든 grep / test / commit msg PASS

주의:
  - GitHub rename 전까지 phase2 호출 금지 (5.5단계 dry check 실패)
  - 본 작업 중 IDE/추가 tmux 세션 띄우지 말 것
SIGNAL_EOF
}

# Phase 2: 5~5.5단계 + verify phase2 ==================================
_run_phase2() {
    _section "Phase 2 시작 - 5~5.5단계 + verify phase2 (APPLY=$APPLY)"
    _confirm_apply

    [ -n "$NEW_URL" ] || NEW_URL="$DEFAULT_NEW_URL"
    printf 'INFO 새 origin URL: %s\n' "$NEW_URL"
    printf '     (Q5-3 default A: HTTPS - 변경 시 phase2 인자로 명시)\n\n'

    # 기존 origin 제거 (filter-repo가 이미 제거했을 수 있음)
    if git remote get-url origin >/dev/null 2>&1; then
        printf '> 기존 origin 발견 - 제거 후 재등록\n'
        _run git remote remove origin
    fi

    # 5단계: remote 재등록
    printf '\n> [5단계] git remote add origin\n'
    _run git remote add origin "$NEW_URL"

    # 5.5단계: ls-remote dry check
    printf '\n> [5.5단계] git ls-remote origin (dry check)\n'
    if [ "$APPLY" = "0" ]; then
        printf '  [DRY] git ls-remote origin > /dev/null\n'
    else
        if ! git ls-remote origin > /dev/null 2>&1; then
            _die "ls-remote 실패 - 6단계 GitHub rename 미완 또는 URL 오타. 확인 후 재실행." 1
        fi
        printf '  [OK]  ls-remote 응답 정상\n'
    fi

    # verify_all phase2
    printf '\n> verify_all.sh phase2 (AC-N1-4, 6)\n'
    if [ "$APPLY" = "0" ]; then
        printf '  [DRY] sh %s/scripts/v0.6.1/verify_all.sh phase2\n' "$ROOT"
    else
        sh "$ROOT/scripts/v0.6.1/verify_all.sh" phase2
    fi

    # 운영자 인계 시그널 2
    _section "✅ Phase 2 완료 - 운영자 인계 시그널 2"
    cat <<'SIGNAL_EOF'
다음 = 운영자 작업 (force push + 폴더 mv):

  7단계: git push --force origin main
         부수 (백업 원격 보존):
           git push origin backup-pre-v0.6.1-rename
         -> GitHub main history 재작성 반영

  8단계: 모든 IDE / tmux 외 claude 세션 / 터미널 종료 후
         cd /Users/geenya/projects/Jonelab_Platform
         mv jOneFlow jOneFlow                 (단일 mv 명령, cp+rm 금지, F-N1-f)
         cd jOneFlow

완료 후 새 폴더에서 검증:
  git status                                       (clean)
  git log --oneline -5                             (새 history)
  git remote -v                                    (origin = jOneFlow URL)
  sh scripts/v0.6.1/verify_all.sh phase3           (AC-N1-5, 8)

추가 환경 정리:
  - shell rc 파일 (~/.zshrc, ~/.bashrc) JONEFLOW_ROOT -> JONEFLOW_ROOT 갱신
  - Jonelab_Platform/.claude/settings.local.json:19 (Q5-2 default A: 자동 무효화)
SIGNAL_EOF
}

# 인자 파싱 ===========================================================
while [ "$#" -gt 0 ]; do
    case "$1" in
        phase1)
            [ -n "$PHASE" ] && _die "phase 인자 중복" 2
            PHASE="phase1"; shift ;;
        phase2)
            [ -n "$PHASE" ] && _die "phase 인자 중복" 2
            PHASE="phase2"; shift
            # phase2의 다음 비-옵션 인자가 NEW_URL.
            if [ "$#" -gt 0 ] && [ "${1#-}" = "$1" ]; then
                NEW_URL="$1"; shift
            fi ;;
        --apply) APPLY=1; shift ;;
        --yes)   YES=1; shift ;;
        -h|--help) _print_usage; exit 0 ;;
        *) _die "알 수 없는 인자: $1" 2 ;;
    esac
done

# 실행 디스패치 =======================================================
case "$PHASE" in
    phase1) _run_phase1 ;;
    phase2) _run_phase2 ;;
    "")     _print_usage; exit 2 ;;
esac
