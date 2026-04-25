#!/usr/bin/env bash
# test_ai_step_static_gate.sh — Static analysis gate (AC-5-5, F-2-a).
#
# Purpose: scripts/ai_step.sh / switch_team.sh / init_project.sh 에서
#   team_mode 리터럴이 **stage 실행 분기**(if/case 조건문, 변수 비교)에
#   사용되지 않음을 검증.
#
# 표시 경로(echo/printf 본문, 주석)와 helper 함수(입력 검증/매핑 헬퍼)는 예외:
#   - switch_team.sh `_switch_validate_mode`        — 입력 whitelist 검증
#   - switch_team.sh main 내부 case 블록 (line 200대) — 동일 입력 검증
#   - init_project.sh `_init_team_mode_from_choice` — 메뉴 매퍼 (출력만, 분기 아님)
#   - init_project.sh `_init_stage_assignments_for_team_mode` — Sec 2.5 매핑 헬퍼
#   - 모두 stage 실행 결정 분기가 아니다.
#
# 검증 알고리즘:
#   [strict] ai_step.sh — 3 리터럴이 conditional context (case/if/[) 0 hit
#                         + $team_mode 변수가 conditional 0 hit
#   [info]   switch_team.sh / init_project.sh — 정보 출력만 (FAIL 아님)
#                         단, 가시화 위해 등장 줄 수와 함수 컨텍스트 표기.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)

AI_STEP="$ROOT/scripts/ai_step.sh"
SWITCH="$ROOT/scripts/switch_team.sh"
INIT="$ROOT/scripts/init_project.sh"

failures=0

assert_eq() {
    if [ "$2" = "$3" ]; then
        printf '  PASS %s\n' "$1"
    else
        printf '  FAIL %s: expected=[%s] got=[%s]\n' "$1" "$2" "$3"
        failures=$((failures + 1))
    fi
}

# 3 리터럴 정규식 (alternation, 따옴표로 감싸진 형태).
LITERALS_RE='"(claude-only|claude-impl-codex-review|codex-impl-claude-review)"'

# 라인이 echo/printf로 시작 (선행 공백 trim 후) 인지 검사.
is_display_line() {
    _idl=$(printf '%s' "$1" | sed 's/^[[:space:]]*//')
    case "$_idl" in
        echo*|printf*|cat*|\#*) return 0 ;;
        *) return 1 ;;
    esac
}

# 라인이 stage 실행 분기 조건 컨텍스트인지 검사 (FAIL 트리거).
#   if [ "..." = "literal" ]
#   case "..." in literal)
#   [ "$..." = "literal" ]
is_branch_context() {
    _ibc="$1"
    case "$_ibc" in
        *'if '*'['*'='*) return 0 ;;
        *'case '*'in'*) return 0 ;;
        *'[ '*'= '*) return 0 ;;
        *'[ '*'='*) return 0 ;;
        *) return 1 ;;
    esac
}

# ============================================================================
# [strict] ai_step.sh — 3 리터럴이 분기 컨텍스트에 등장 0 hit
# ============================================================================
printf '==> [strict] %s\n' "$AI_STEP"

bad_lit=0
while IFS= read -r line; do
    [ -z "$line" ] && continue
    # 주석 제외
    case "$(printf '%s' "$line" | sed 's/^[0-9]*://' | sed 's/^[[:space:]]*//')" in
        '#'*) continue ;;
    esac
    # echo/printf 본문 안 → 표시 경로, OK
    if is_display_line "$(printf '%s' "$line" | sed 's/^[0-9]*://')"; then
        continue
    fi
    # 그 외 등장 → FAIL 후보
    bad_lit=$((bad_lit + 1))
    printf '  HIT (literal in non-display line): %s\n' "$line"
done <<EOF
$(grep -nE "$LITERALS_RE" "$AI_STEP" || true)
EOF
assert_eq 'ai_step.sh: 3 리터럴이 분기 컨텍스트 0 hit' '0' "$bad_lit"

# $team_mode 변수가 conditional context (`[`, `case`)에 등장하는지 검사.
# ai_step.sh 는 `settings_read_key team_mode` 호출 후 결과를 출력에만 사용해야 한다.
bad_var=0
while IFS= read -r line; do
    [ -z "$line" ] && continue
    raw=$(printf '%s' "$line" | sed 's/^[0-9]*://')
    # 주석 제외
    case "$(printf '%s' "$raw" | sed 's/^[[:space:]]*//')" in
        '#'*) continue ;;
    esac
    # 표시 경로 제외
    if is_display_line "$raw"; then
        continue
    fi
    # 변수 할당 라인 제외 ('_asp_team=...' 같은 형태)
    case "$(printf '%s' "$raw" | sed 's/^[[:space:]]*//')" in
        *team*=*) continue ;;
    esac
    # 분기 컨텍스트인지 확인
    if is_branch_context "$raw"; then
        bad_var=$((bad_var + 1))
        printf '  HIT (team_mode in branch ctx): %s\n' "$line"
    fi
done <<EOF
$(grep -nE 'team_mode' "$AI_STEP" || true)
EOF
# shellcheck disable=SC2016  # '$team_mode' is a literal label, not an expansion.
assert_eq 'ai_step.sh: $team_mode 변수가 분기 컨텍스트 0 hit' '0' "$bad_var"

# ============================================================================
# [info] switch_team.sh / init_project.sh — 정보 출력 (FAIL 아님)
# ============================================================================
for f in "$SWITCH" "$INIT"; do
    printf '==> [info] %s\n' "$f"
    if [ ! -f "$f" ]; then
        printf '  WARN: 파일 없음 (skip)\n'
        continue
    fi
    _hits=$(grep -cE "$LITERALS_RE" "$f" || true)
    printf '  INFO: 3 리터럴 등장 라인 수: %s\n' "$_hits"
    # 등장은 입력 whitelist (_switch_validate_mode) 또는 매핑 헬퍼
    # (_init_team_mode_from_choice / _init_stage_assignments_for_team_mode)
    # 책임 — stage 실행 결정 분기가 아니므로 PASS 판정.
    case "$f" in
        *switch_team.sh)
            if grep -qE '_switch_validate_mode' "$f"; then
                printf '  INFO: _switch_validate_mode 함수 존재 (입력 whitelist) — F-2-a 예외 적용\n'
            fi
            ;;
        *init_project.sh)
            if grep -qE '_init_team_mode_from_choice|_init_stage_assignments_for_team_mode' "$f"; then
                printf '  INFO: 매핑/메뉴 헬퍼 존재 (출력 매퍼) — F-2-a 예외 적용\n'
            fi
            ;;
    esac
done

# ============================================================================
# 추가 검증: ai_step.sh의 stage 실행 결정 경로는 settings_read_stage_assign만 사용해야 한다.
# (Sec 6.3 / AC-5-6 spirit)
# ============================================================================
printf '==> [strict] ai_step.sh: stage_assignments 의존 검증\n'

# resolve_executor 함수가 settings_read_stage_assign 만 호출하는지 확인.
# (settings_read_key team_mode를 호출하면 안 됨 — 호출은 _ai_step_status_print에서만 OK.)
in_resolve=$(awk '/^ai_step_resolve_executor\(\)/,/^}/' "$AI_STEP")
if echo "$in_resolve" | grep -q 'settings_read_stage_assign'; then
    printf '  PASS ai_step_resolve_executor가 settings_read_stage_assign 호출\n'
else
    printf '  FAIL ai_step_resolve_executor가 settings_read_stage_assign 미호출\n'
    failures=$((failures + 1))
fi
if echo "$in_resolve" | grep -q 'settings_read_key.*team_mode'; then
    printf '  FAIL ai_step_resolve_executor가 team_mode를 직접 읽음 (F-2-a 위반)\n'
    failures=$((failures + 1))
else
    printf '  PASS ai_step_resolve_executor가 team_mode 직접 참조 안 함\n'
fi

if [ "$failures" -eq 0 ]; then
    printf 'test_ai_step_static_gate: PASS\n'
    exit 0
else
    printf 'test_ai_step_static_gate: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
