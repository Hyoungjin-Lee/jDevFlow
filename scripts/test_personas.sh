#!/bin/sh
# v0.6.6 의제 #5 reviewer — personas.sh API + 팀 명단 헌법 정합 스모크 테스트
#
# 검증 대상 (drafter 2e1fd2b 영구화):
#   T1. 18명 페르소나 model/effort/role/team 누락 없음
#   T2. 팀 명단 헌법 순서 (PL | drafter | reviewer | finalizer)
#   T3. dev = dev-be alias (persona_list_team)
#   T4. 미지정 페르소나 → 빈 문자열 (가드)
#   T5. CEO 이형진 = model 없음 (Cowork 운영자, 코드 실행 X)
#
# 사용:
#   sh scripts/test_personas.sh
# 부수효과 없음 (read-only API 호출).

set -u

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck disable=SC1091
. "${PROJECT_ROOT}/scripts/lib/personas.sh"

PASS=0
FAIL=0
_pass() { echo "PASS $*"; PASS=$((PASS+1)); }
_fail() { echo "FAIL $*"; FAIL=$((FAIL+1)); }

# T1 — 18명 페르소나 lookup (이형진 모델은 빈 문자열 허용)
PERSONAS_18="이형진 박지영 이희윤 \
이종선 김민교 안영이 장그래 \
우상호 이수지 오해원 장원영 \
공기성 최우영 현봉식 카더가든 \
백강혁 김원훈 지예은"

T1_FAIL=0
for p in $PERSONAS_18; do
    eff=$(persona_effort "$p")
    rol=$(persona_role "$p")
    tm=$(persona_team "$p")
    # 이형진은 effort/model 빈 문자열 허용. role/team만 필수.
    if [ -z "$rol" ] || [ -z "$tm" ]; then
        _fail "T1 $p role='$rol' team='$tm' (필수 누락)"
        T1_FAIL=$((T1_FAIL + 1))
    fi
    # 이형진 외에는 effort 필수
    if [ "$p" != "이형진" ] && [ -z "$eff" ]; then
        _fail "T1 $p effort 누락 (이형진 외)"
        T1_FAIL=$((T1_FAIL + 1))
    fi
done
[ "$T1_FAIL" = "0" ] && _pass "T1 18명 페르소나 role/team/effort 누락 없음"

# T2 — 팀 명단 헌법 순서 (PL | drafter | reviewer | finalizer)
_check_roster() {
    _cr_team="$1"
    _cr_expected="$2"
    _cr_got=$(persona_list_team "$_cr_team")
    if [ "$_cr_got" = "$_cr_expected" ]; then
        _pass "T2 ${_cr_team} 명단 헌법 순서 ($_cr_got)"
    else
        _fail "T2 ${_cr_team} got='$_cr_got' expected='$_cr_expected'"
    fi
    # 4개 항목 분리 검증 (awk NF로 정확히 카운트 — 후행 newline 의존 X)
    _cr_n=$(printf '%s' "$_cr_got" | awk -F'|' '{print NF}')
    [ "$_cr_n" = "4" ] || _fail "T2 ${_cr_team} pane 헌법 위반 (4명 아님: $_cr_n)"
}

_check_roster plan      "이종선|장그래|김민교|안영이"
_check_roster design    "우상호|장원영|이수지|오해원"
_check_roster dev       "공기성|카더가든|최우영|현봉식"
_check_roster dev-be    "공기성|카더가든|최우영|현봉식"
_check_roster dev-fe    "공기성|지예은|백강혁|김원훈"

# 헌법 순서 검증 — 각 멤버의 role이 PL/drafter/reviewer/finalizer 순서인가
for tm in plan design dev-be dev-fe; do
    roster=$(persona_list_team "$tm")
    pl_p=$(printf '%s' "$roster" | cut -d'|' -f1)
    df_p=$(printf '%s' "$roster" | cut -d'|' -f2)
    rv_p=$(printf '%s' "$roster" | cut -d'|' -f3)
    fn_p=$(printf '%s' "$roster" | cut -d'|' -f4)

    pl_r=$(persona_role "$pl_p")
    df_r=$(persona_role "$df_p")
    rv_r=$(persona_role "$rv_p")
    fn_r=$(persona_role "$fn_p")

    if [ "$pl_r" = "PL" ] && [ "$df_r" = "drafter" ] && [ "$rv_r" = "reviewer" ] && [ "$fn_r" = "finalizer" ]; then
        _pass "T2 ${tm} 역할 순서 헌법 정합 (PL|drafter|reviewer|finalizer)"
    else
        _fail "T2 ${tm} 역할 순서 위반 ($pl_r|$df_r|$rv_r|$fn_r)"
    fi
done

# T3 — dev = dev-be alias
g1=$(persona_list_team dev)
g2=$(persona_list_team dev-be)
if [ "$g1" = "$g2" ]; then _pass "T3 dev = dev-be alias"
else _fail "T3 dev='$g1' dev-be='$g2'"; fi

# T4 — 미지정 페르소나 가드
v=$(persona_model "없는사람")
if [ -z "$v" ]; then _pass "T4 미지정 persona model → empty"
else _fail "T4 model got '$v'"; fi
v=$(persona_effort "없는사람")
if [ -z "$v" ]; then _pass "T4 미지정 persona effort → empty"
else _fail "T4 effort got '$v'"; fi
v=$(persona_list_team "unknown_team")
if [ -z "$v" ]; then _pass "T4 미지정 team → empty"
else _fail "T4 list_team got '$v'"; fi

# T5 — 이형진 = CEO, model/effort 빈 문자열 / role+team 필수
v=$(persona_model "이형진")
if [ -z "$v" ]; then _pass "T5 이형진 model = empty (Cowork 운영자)"
else _fail "T5 이형진 model='$v'"; fi
v=$(persona_role "이형진")
if [ "$v" = "ceo" ]; then _pass "T5 이형진 role = ceo"
else _fail "T5 이형진 role='$v'"; fi
v=$(persona_team "이형진")
if [ "$v" = "exec" ]; then _pass "T5 이형진 team = exec"
else _fail "T5 이형진 team='$v'"; fi

echo "─────────────────────────────────────"
echo "SUMMARY: ${PASS} pass / ${FAIL} fail"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
