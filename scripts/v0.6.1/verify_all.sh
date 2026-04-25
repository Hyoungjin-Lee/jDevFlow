#!/bin/sh
# verify_all.sh - v0.6.1 N1 AC-N1-1~8 종합 검증.
# Reference: technical_design.md Sec.3.3 + Sec.10.
#
# fail-closed: 첫 실패 시 즉시 exit 1.
#
# Phase 분기:
#   phase1  filter-repo 직후 (오케스트레이터) - AC-N1-1, 2, 3, 7
#   phase2  remote 재등록 직후 (오케스트레이터) - AC-N1-4, 6
#   phase3  force push + 폴더 mv 후 (운영자 후속) - AC-N1-5, 8
#   all     phase1 -> phase2 -> phase3 순차
#
# Usage:
#   sh scripts/v0.6.1/verify_all.sh phase1
#   sh scripts/v0.6.1/verify_all.sh phase2
#   sh scripts/v0.6.1/verify_all.sh phase3
#   sh scripts/v0.6.1/verify_all.sh all
#
# Exit codes:
#   0 해당 phase 모든 AC PASS
#   1 AC 검증 실패 (위치 메시지)
#   2 잘못된 인자

set -eu

# shellcheck disable=SC1007  # CDPATH= idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$ROOT"

PHASE="${1:-}"
RESULTS_LOG="$ROOT/scripts/v0.6.1/verify_results.log"

_pass() { printf '  PASS  %s\n' "$1" | tee -a "$RESULTS_LOG"; }
_fail() {
    printf '  FAIL  %s\n    -> %s\n' "$1" "$2" | tee -a "$RESULTS_LOG" >&2
    exit 1
}
_section() { printf '\n--- %s ---\n' "$1" | tee -a "$RESULTS_LOG"; }

if [ -z "$PHASE" ]; then
    cat <<'USAGE_EOF' >&2
verify_all.sh: phase 인자 필요

사용법:
  sh scripts/v0.6.1/verify_all.sh phase1   - filter-repo 직후
  sh scripts/v0.6.1/verify_all.sh phase2   - remote 재등록 직후
  sh scripts/v0.6.1/verify_all.sh phase3   - force push + 폴더 mv 후
  sh scripts/v0.6.1/verify_all.sh all      - 전체 순차
USAGE_EOF
    exit 2
fi

case "$PHASE" in
    phase1|phase2|phase3|all) ;;
    *) printf 'verify_all.sh: 잘못된 phase: %s\n' "$PHASE" >&2; exit 2 ;;
esac

# Reset log
: > "$RESULTS_LOG"
printf '=== v0.6.1 N1 AC verify (phase=%s) ===\n' "$PHASE" | tee "$RESULTS_LOG"

# AC 함수 정의 ========================================================

_ac_n1_1() {
    _hits=$(grep -rnE 'jOneFlow|joneflow|JONEFLOW' . \
              --exclude-dir=.git --exclude-dir=node_modules \
              2>/dev/null | wc -l | tr -d ' ')
    if [ "$_hits" = "0" ]; then
        _pass "AC-N1-1 (worktree grep = 0 hits)"
    else
        printf '  잔존 위치 (앞 10건):\n' >&2
        grep -rnE 'jOneFlow|joneflow|JONEFLOW' . \
            --exclude-dir=.git --exclude-dir=node_modules \
            2>/dev/null | head -10 | sed 's|^|    |' >&2
        _fail "AC-N1-1 (grep $_hits hits)" "위 위치 패치 또는 expressions.txt 보강 후 재실행"
    fi
}

_ac_n1_2() {
    if [ ! -f scripts/run_tests.sh ]; then
        _fail "AC-N1-2 (run_tests.sh 부재)" "scripts/run_tests.sh 확인"
    fi
    if sh scripts/run_tests.sh > /tmp/v061_run_tests.log 2>&1; then
        _pass "AC-N1-2 (run_tests.sh 전체 PASS)"
    else
        printf '  run_tests.sh 출력 (마지막 20행):\n' >&2
        tail -20 /tmp/v061_run_tests.log | sed 's|^|    |' >&2
        _fail "AC-N1-2 (run_tests.sh exit != 0)" "/tmp/v061_run_tests.log 확인 - 하드코딩 치환 누락 가능"
    fi
}

_ac_n1_3() {
    _msg_hits=$(git log --all --pretty=format:'%H %s' 2>/dev/null \
                  | grep -cE 'jOneFlow|joneflow|JONEFLOW' || true)
    if [ "$_msg_hits" = "0" ]; then
        _pass "AC-N1-3 (commit msg 0 hits)"
    else
        printf '  잔존 메시지 (앞 5건):\n' >&2
        git log --all --pretty=format:'%H %s' \
            | grep -E 'jOneFlow|joneflow|JONEFLOW' | head -5 \
            | sed 's|^|    |' >&2
        _fail "AC-N1-3 (commit msg $_msg_hits hits)" \
              "filter-repo 옵션 점검 후 백업 브랜치에서 reset+재실행"
    fi
}

_ac_n1_4() {
    if git remote -v 2>/dev/null | grep -q 'jOneFlow'; then
        _pass "AC-N1-4 (remote URL = jOneFlow)"
        git remote -v | sed 's|^|    |'
    else
        printf '  현재 remote:\n' >&2
        git remote -v 2>/dev/null | sed 's|^|    |' >&2 || printf '    (none)\n' >&2
        _fail "AC-N1-4 (remote URL != jOneFlow)" \
              "git remote add origin https://github.com/Hyoungjin-Lee/jOneFlow.git"
    fi
}

_ac_n1_5() {
    if curl -fsSL https://github.com/Hyoungjin-Lee/jOneFlow -o /dev/null 2>/dev/null; then
        _pass "AC-N1-5 (GitHub URL HTTP 200)"
    else
        _fail "AC-N1-5 (HTTP 접근 실패)" \
              "Hyoungjin-Lee/jOneFlow rename 미완료 또는 권한 - GitHub Settings 확인"
    fi
}

_ac_n1_6() {
    if git ls-remote origin > /dev/null 2>&1; then
        _pass "AC-N1-6 (ls-remote dry check OK)"
    else
        _fail "AC-N1-6 (ls-remote 실패)" \
              "원격 접근 불가 - 6단계 GitHub rename 미완 가능, force push 직전 차단"
    fi
}

_ac_n1_7() {
    _f1=tests/bundle1/run_bundle1.sh
    _f2=tests/v0.6/test_init_project_verbatim.sh
    for _f in "$_f1" "$_f2"; do
        if [ ! -f "$_f" ]; then
            _fail "AC-N1-7 ($_f 부재)" "테스트 파일 경로 확인"
        fi
        if grep -qE 'jOneFlow' "$_f" 2>/dev/null; then
            _pass "AC-N1-7 ($_f -> jOneFlow 치환됨)"
        else
            _fail "AC-N1-7 ($_f 미치환)" \
                  "filter-repo가 이 파일을 처리 안 함 - expressions.txt + filter-repo 재실행"
        fi
    done
}

_ac_n1_8() {
    _upper_hits=$(grep -rnE 'jOneFlow|joneflow|JONEFLOW' \
                   /Users/geenya/projects/Jonelab_Platform/ \
                   --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git \
                   --include='*.md' --include='*.sh' --include='*.json' \
                   2>/dev/null | wc -l | tr -d ' ')
    if [ "$_upper_hits" = "0" ]; then
        _pass "AC-N1-8 (상위 경로 0 hits)"
    else
        printf '  상위 경로 잔존 (앞 5건):\n'
        grep -rnE 'jOneFlow|joneflow|JONEFLOW' \
            /Users/geenya/projects/Jonelab_Platform/ \
            --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git \
            --include='*.md' --include='*.sh' --include='*.json' \
            2>/dev/null | head -5 | sed 's|^|    |'
        # Q5-2 default(A): settings.local.json:19 1건 자동 무효화 허용.
        _expected_only="/Users/geenya/projects/Jonelab_Platform/.claude/settings.local.json"
        _other=$(grep -rnE 'jOneFlow|joneflow|JONEFLOW' \
                    /Users/geenya/projects/Jonelab_Platform/ \
                    --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git \
                    --include='*.md' --include='*.sh' --include='*.json' 2>/dev/null \
                  | grep -cvF "$_expected_only" || true)
        if [ "$_other" = "0" ]; then
            _pass "AC-N1-8 (Q5-2 default 허용 - settings.local.json 1건 자동 무효화)"
        else
            _fail "AC-N1-8 (예상 외 위치에 $_other hits)" \
                  "위 위치 수동 패치 또는 Q5-2 옵션 B 채택 후 재실행"
        fi
    fi
}

# Phase 분기 실행 =====================================================

_run_phase1() {
    _section "Phase 1: filter-repo 직후 (AC-N1-1, 2, 3, 7)"
    _ac_n1_1
    _ac_n1_3
    _ac_n1_7
    _ac_n1_2
}

_run_phase2() {
    _section "Phase 2: remote 재등록 직후 (AC-N1-4, 6)"
    _ac_n1_4
    _ac_n1_6
}

_run_phase3() {
    _section "Phase 3: force push + 폴더 mv 후 (AC-N1-5, 8)"
    _ac_n1_5
    _ac_n1_8
}

case "$PHASE" in
    phase1) _run_phase1 ;;
    phase2) _run_phase2 ;;
    phase3) _run_phase3 ;;
    all)    _run_phase1; _run_phase2; _run_phase3 ;;
esac

printf '\n=== verify_all.sh: phase=%s 모든 AC PASS ===\n' "$PHASE" | tee -a "$RESULTS_LOG"
exit 0
