#!/usr/bin/env bash
# ai_step.sh — v0.6 Stage 2-13 오케스트레이터 + v0.5 Stage prompt runner.
#
# Usage:
#   bash scripts/ai_step.sh <stage_name>      # v0.5 호환 — prompts/{claude,codex}/<stage>.md 출력
#   bash scripts/ai_step.sh --stage <name>    # 동일 (명시 형태)
#   bash scripts/ai_step.sh --status          # 현재 + 다음 stage executor 표시
#   bash scripts/ai_step.sh --next            # 다음 stage 1개 진행
#   bash scripts/ai_step.sh --auto            # 다음 승인 게이트까지 자동 진행
#   bash scripts/ai_step.sh --resume          # paused 상태 재개
#   bash scripts/ai_step.sh -h | --help       # 사용법
#
# v0.5 호환 stage 이름:
#   brainstorm, planning_draft, planning_review, planning_final,
#   technical_design, ui_requirements, ui_flow,
#   implementation, code_review, revise, final_review, qa
#
# 핵심 설계 제약 (technical_design.md Sec.6.3):
#   F-2-a: 실행 결정 분기는 stage_assignments만 읽는다. 표시 경로(echo/printf/주석)
#          에서만 team_mode 리터럴 참조 허용.
#   F-D2 : jq 비호출. settings.sh의 POSIX 파서만 사용.
#   F-D3 : 구 pending 필드 신규 등장 금지.
#   F-n3 : openai-codex CLI 직접 호출 금지. plugin-cc 슬래시 커맨드 안내만.
#
# Exit codes (Sec 9.1):
#   0 정상  2 잘못된 인자/unknown executor  3 schema 불일치/키 누락
#   10 executor 실패  11 artifact 미생성  12 signal 키워드 미매치
#   13 타임아웃 / 무한루프 의심  130 Ctrl-C trap.

set -eu

# ============================================================================
# 부트스트랩 — SCRIPT_DIR / ROOT 경로 격리 (M2/M3 동일 패턴).
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -n "${JONEFLOW_ROOT:-}" ]; then
  ROOT="$JONEFLOW_ROOT"
else
  ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

# Source POSIX library (settings_*).
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib/settings.sh"

# ============================================================================
# 사용법 / 진단 / 종료
# ============================================================================

_ai_step_die() {
  _aid_code="$1"; shift
  printf 'ai_step.sh: %s\n' "$*" >&2
  exit "$_aid_code"
}

_ai_step_print_usage() {
  cat <<'EOF'
ai_step.sh — jOneFlow Stage runner (v0.6 오케스트레이터 + v0.5 호환).

Usage:
  bash scripts/ai_step.sh <stage_name>      # v0.5 호환 — Stage 프롬프트 출력 + dev_history 로그
  bash scripts/ai_step.sh --stage <name>    # 동일
  bash scripts/ai_step.sh --status          # 현재 운영 상태 출력 (settings.json)
  bash scripts/ai_step.sh --next            # 다음 stage 1개 진행
  bash scripts/ai_step.sh --auto            # 다음 승인 게이트까지 자동 진행
  bash scripts/ai_step.sh --resume          # paused 상태에서 재개
  bash scripts/ai_step.sh -h | --help       # 사용법

v0.5 호환 stage 이름:
  brainstorm, planning_draft, planning_review, planning_final,
  technical_design, ui_requirements, ui_flow,
  implementation, code_review, revise, final_review, qa

상세: docs/03_design/v0.6_cli_automation/technical_design.md Sec.6
EOF
}

_ai_step_log_interrupt() {
  ai_step_log_transition 'unknown' 'interrupted' 2>/dev/null || true
}

trap '_ai_step_log_interrupt; exit 130' INT

# ============================================================================
# v0.5 호환 — PROMPT_MAP / STAGE_NAME (기존 ai_step.sh와 동일)
# ============================================================================

# bash 3.2 호환을 위해 associative array 대신 case 기반 lookup 사용.

_ai_step_prompt_path_for() {
  case "$1" in
    brainstorm)        printf 'prompts/claude/brainstorm.md' ;;
    planning_draft)    printf 'prompts/claude/planning_draft.md' ;;
    planning_review)   printf 'prompts/claude/planning_review.md' ;;
    planning_final)    printf 'prompts/claude/planning_final.md' ;;
    technical_design)  printf 'prompts/claude/technical_design.md' ;;
    ui_requirements)   printf 'prompts/claude/ui_requirements.md' ;;
    ui_flow)           printf 'prompts/claude/ui_flow.md' ;;
    implementation)    printf 'prompts/codex/implementation.md' ;;
    code_review)       printf 'prompts/claude/code_review.md' ;;
    revise)            printf 'prompts/codex/revise.md' ;;
    final_review)      printf 'prompts/claude/final_review.md' ;;
    qa)                printf 'prompts/claude/qa.md' ;;
    *) return 1 ;;
  esac
}

_ai_step_display_name_for() {
  case "$1" in
    brainstorm)        printf 'Stage 1 — Brainstorm (Opus)' ;;
    planning_draft)    printf 'Stage 2 — Plan Draft (Sonnet)' ;;
    planning_review)   printf 'Stage 3 — Plan Review (Sonnet)' ;;
    planning_final)    printf 'Stage 4 — Plan Final (Sonnet)' ;;
    technical_design)  printf 'Stage 5 — Technical Design (Opus)' ;;
    ui_requirements)   printf 'Stage 6 — UI Requirements (Sonnet)' ;;
    ui_flow)           printf 'Stage 7 — UI Flow (Sonnet)' ;;
    implementation)    printf 'Stage 8 — Implementation (Codex)' ;;
    code_review)       printf 'Stage 9 — Code Review (Sonnet)' ;;
    revise)            printf 'Stage 10 — Revision (Codex)' ;;
    final_review)      printf 'Stage 11 — Final Validation (Opus)' ;;
    qa)                printf 'Stage 12 — QA & Release (Sonnet)' ;;
    *) return 1 ;;
  esac
}

_ai_step_list_legacy_stages() {
  printf '  brainstorm  →  Stage 1 — Brainstorm (Opus)\n'
  printf '  planning_draft  →  Stage 2 — Plan Draft (Sonnet)\n'
  printf '  planning_review  →  Stage 3 — Plan Review (Sonnet)\n'
  printf '  planning_final  →  Stage 4 — Plan Final (Sonnet)\n'
  printf '  technical_design  →  Stage 5 — Technical Design (Opus)\n'
  printf '  ui_requirements  →  Stage 6 — UI Requirements (Sonnet)\n'
  printf '  ui_flow  →  Stage 7 — UI Flow (Sonnet)\n'
  printf '  implementation  →  Stage 8 — Implementation (Codex)\n'
  printf '  code_review  →  Stage 9 — Code Review (Sonnet)\n'
  printf '  revise  →  Stage 10 — Revision (Codex)\n'
  printf '  final_review  →  Stage 11 — Final Validation (Opus)\n'
  printf '  qa  →  Stage 12 — QA & Release (Sonnet)\n'
}

# v0.5 호환 출력. 알 수 없는 stage는 메시지 출력 + exit 0 (기존 동작 유지).
_ai_step_legacy_print() {
  _alp_stage="${1:-}"
  if [ -z "$_alp_stage" ]; then
    printf 'Available stages:\n'
    _ai_step_list_legacy_stages | sort
    printf '\n'
    printf 'Enter stage name: '
    read -r _alp_stage || true
  fi

  if ! _alp_path=$(_ai_step_prompt_path_for "$_alp_stage"); then
    printf 'Unknown stage: %s\n' "'$_alp_stage'"
    printf '   Run without arguments for a list of available stages.\n'
    return 0
  fi

  _alp_display=$(_ai_step_display_name_for "$_alp_stage")
  _alp_full="$ROOT/$_alp_path"

  printf '\n'
  printf '======================================\n'
  printf '  %s\n' "$_alp_display"
  printf '======================================\n'
  printf '\n'

  if [ -f "$_alp_full" ]; then
    cat "$_alp_full"
  else
    printf 'Prompt file not found: %s\n' "$_alp_path"
    printf '   Create it or copy from prompts/ templates.\n'
  fi

  printf '\n'
  printf '======================================\n'

  _alp_history="$ROOT/docs/notes/dev_history.md"
  if [ -f "$_alp_history" ]; then
    _alp_ts=$(date '+%Y-%m-%d %H:%M')
    printf '\n### %s — %s started\n' "$_alp_ts" "$_alp_display" >> "$_alp_history"
  fi
}

# ============================================================================
# v0.6 helper — stage key / artifact / signal 매핑 (Sec.6.5)
# ============================================================================

# stage display marker ("stage2".."stage13") → stage_assignments key.
# stage 2~7, 12, 13 은 None (Claude 본인 실행, dispatch 안 함).
_ai_step_assign_key_for() {
  case "$1" in
    stage8)  printf 'stage8_impl' ;;
    stage9)  printf 'stage9_review' ;;
    stage10) printf 'stage10_fix' ;;
    stage11) printf 'stage11_verify' ;;
    *) printf '' ;;
  esac
}

# stage marker → glob pattern으로 첫 매치 artifact 경로. 못 찾으면 빈 문자열 + return 1.
_ai_step_artifact_path() {
  _aap_stage="$1"
  case "$_aap_stage" in
    stage2)  _aap_glob="$ROOT"'/docs/02_planning*/plan_draft.md' ;;
    stage3)  _aap_glob="$ROOT"'/docs/02_planning*/plan_review.md' ;;
    stage4)  _aap_glob="$ROOT"'/docs/02_planning*/plan_final.md' ;;
    stage5)  _aap_glob="$ROOT"'/docs/03_design*/technical_design.md' ;;
    stage6)  _aap_glob="$ROOT"'/docs/03_design*/ui_requirements.md' ;;
    stage7)  _aap_glob="$ROOT"'/docs/03_design*/ui_flow.md' ;;
    stage8)  _aap_glob="$ROOT"'/docs/04_implementation*/implementation.md' ;;
    stage9)  _aap_glob="$ROOT"'/docs/04_implementation*/code_review.md' ;;
    stage10) _aap_glob="$ROOT"'/docs/04_implementation*/revise.md' ;;
    stage11) _aap_glob="$ROOT"'/docs/05_qa_release*/final_review.md' ;;
    stage12) _aap_glob="$ROOT"'/docs/05_qa_release*/qa.md' ;;
    stage13) _aap_glob="$ROOT"'/CHANGELOG.md' ;;
    *) return 1 ;;
  esac
  # Glob 확장 (set -f off in subshell). 첫 매치 채택.
  for _aap_p in $_aap_glob; do
    if [ -f "$_aap_p" ]; then
      printf '%s\n' "$_aap_p"
      return 0
    fi
  done
  return 1
}

# stage → 완료 신호 grep 패턴. stage6/7 은 빈 패턴 (artifact 존재만 검사).
_ai_step_signal_pattern() {
  case "$1" in
    stage2)  printf '^# .+(plan_draft|Plan Draft)' ;;
    stage3)  printf '^# .+(plan_review|Plan Review)' ;;
    stage4)  printf 'status: (pending_operator_approval|approved)' ;;
    stage5)  printf '^## Sec\. 1\. 아키텍처|## Architecture' ;;
    stage6)  printf '' ;;
    stage7)  printf '' ;;
    stage8)  printf 'Status:.*(completed|done|green)' ;;
    stage9)  printf 'APPROVED' ;;
    stage10) printf 'Status:.*completed' ;;
    stage11) printf 'Verdict:.*PASS' ;;
    stage12) printf 'QA:.*PASS' ;;
    stage13) printf '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' ;;
    *) printf '' ;;
  esac
}

# stage marker 진행 순서.
_ai_step_next_stage() {
  case "$1" in
    ''|stage1) printf 'stage2' ;;
    stage2)    printf 'stage3' ;;
    stage3)    printf 'stage4' ;;
    stage4)    printf 'stage5' ;;
    stage5)    printf 'stage6' ;;
    stage6)    printf 'stage7' ;;
    stage7)    printf 'stage8' ;;
    stage8)    printf 'stage9' ;;
    stage9)    printf 'stage10' ;;
    stage10)   printf 'stage11' ;;
    stage11)   printf 'stage12' ;;
    stage12)   printf 'stage13' ;;
    stage13)   printf '' ;;
    *) printf 'stage2' ;;
  esac
}

# dev_history.md의 마지막 stage 마커 추출. 없으면 빈 문자열.
# format: "### YYYY-MM-DD HH:MM — stageN ..." 또는 "### YYYY-MM-DD HH:MM — Stage N — ..."
_ai_step_current_stage_marker() {
  _acsm_h="$ROOT/docs/notes/dev_history.md"
  if [ ! -f "$_acsm_h" ]; then
    printf ''
    return 0
  fi
  # 우선 v0.6 short form ("stage2".."stage13") 매칭, 없으면 v0.5 long form.
  # NOTE: BSD sed가 멀티바이트 em-dash(—) + 캡처 그룹 조합을 잘못 매칭함 →
  # grep으로 형식 필터링 후 sed는 .* 일반 패턴 + -E extended regex로 추출.
  _acsm_short=$(grep -E '^### [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} — stage[0-9]+' "$_acsm_h" 2>/dev/null \
                | tail -n 1 \
                | sed -E -n 's/.*(stage[0-9]+).*/\1/p')
  if [ -n "$_acsm_short" ]; then
    printf '%s' "$_acsm_short"
    return 0
  fi
  # v0.5 long form ("Stage N — ...") → "stageN".
  _acsm_long=$(grep -E '^### [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} — Stage [0-9]+' "$_acsm_h" 2>/dev/null \
               | tail -n 1 \
               | sed -E -n 's/.*Stage ([0-9]+).*/stage\1/p')
  printf '%s' "$_acsm_long"
}

# dev_history.md 마지막 stage 라인이 paused 상태인지 검사.
_ai_step_last_state_is_paused() {
  _alsp_h="$ROOT/docs/notes/dev_history.md"
  if [ ! -f "$_alsp_h" ]; then
    return 1
  fi
  _alsp_last=$(grep -E '^### [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} — stage[0-9]+' "$_alsp_h" 2>/dev/null | tail -n 1)
  case "$_alsp_last" in
    *paused*) return 0 ;;
    *) return 1 ;;
  esac
}

# plan_final.md status: approved 여부. 없거나 pending이면 1.
_ai_step_plan_final_approved() {
  if ! _apfa_path=$(_ai_step_artifact_path stage4); then
    return 1
  fi
  grep -qE '^status: approved' "$_apfa_path" 2>/dev/null
}

# ============================================================================
# 공개 함수 — Sec.8.2
# ============================================================================

# ai_step_resolve_executor STAGE_KEY  (예: "stage8_impl")
# echo claude|codex; settings 부재/오타 시 die.
ai_step_resolve_executor() {
  _are_stage="${1:-}"
  if [ -z "$_are_stage" ]; then
    _ai_step_die 2 "ai_step_resolve_executor: STAGE_KEY 인자 누락."
  fi
  _are_v=$(settings_read_stage_assign "$_are_stage")
  case "$_are_v" in
    claude|codex) printf '%s\n' "$_are_v" ;;
    '') _ai_step_die 3 "stage_assignments.${_are_stage} 키 누락. init_project.sh --force-reinit 실행." ;;
    *)  _ai_step_die 2 "알 수 없는 executor: '${_are_v}' (stage_assignments.${_are_stage}). 허용: claude|codex." ;;
  esac
}

# ai_step_check_complete STAGE_KEY [LAST_EXIT]
# return 0=clean / 1=artifact 미생성 / 2=executor 실패 / 3=signal 미매치.
ai_step_check_complete() {
  _ack_stage="${1:-}"
  _ack_last_exit="${2:-0}"
  if [ -z "$_ack_stage" ]; then
    return 1
  fi
  if ! _ack_artifact=$(_ai_step_artifact_path "$_ack_stage"); then
    return 1
  fi
  [ -f "$_ack_artifact" ] || return 1
  [ "$_ack_last_exit" = "0" ] || return 2

  _ack_pat=$(_ai_step_signal_pattern "$_ack_stage")
  if [ -n "$_ack_pat" ]; then
    grep -qE "$_ack_pat" "$_ack_artifact" || return 3
  fi
  return 0
}

# ai_step_dispatch STAGE_KEY EXECUTOR
# 외부 spawn 안 함. 안내 메시지 출력만 (Sec.6.9).
# openai-codex CLI 경로는 디스패치 테이블에 미포함 (F-n3).
ai_step_dispatch() {
  _ad_skey="${1:-}"
  _ad_exec="${2:-}"
  if [ -z "$_ad_skey" ] || [ -z "$_ad_exec" ]; then
    _ai_step_die 2 "ai_step_dispatch: STAGE_KEY/EXECUTOR 인자 누락."
  fi
  case "${_ad_skey}_${_ad_exec}" in
    stage8_impl_claude)    printf '   ▶ Stage 8 구현: claude --teammate-mode tmux <prompt>\n' ;;
    stage8_impl_codex)     printf '   ▶ Stage 8 구현: /codex:rescue <prompt> (plugin-cc)\n' ;;
    stage9_review_claude)  printf '   ▶ Stage 9 리뷰: claude Opus 서브에이전트 (code_review.md)\n' ;;
    stage9_review_codex)   printf '   ▶ Stage 9 리뷰: /codex:review <code_review prompt>\n' ;;
    stage10_fix_claude)    printf '   ▶ Stage 10 수정: claude --teammate-mode tmux <revise prompt>\n' ;;
    stage10_fix_codex)     printf '   ▶ Stage 10 수정: /codex:rescue <revise prompt>\n' ;;
    stage11_verify_claude) printf '   ▶ Stage 11 검증: claude Opus XHigh (final_review.md)\n' ;;
    *) _ai_step_die 2 "디스패치 테이블 미정 조합: ${_ad_skey}_${_ad_exec}" ;;
  esac
}

# ai_step_log_transition STAGE STATE [EXECUTOR]
# dev_history.md 끝에 한 줄 append. 파일 부재 시 noop.
ai_step_log_transition() {
  _alt_stage="${1:-}"
  _alt_state="${2:-}"
  _alt_executor="${3:-}"
  _alt_h="$ROOT/docs/notes/dev_history.md"
  [ -f "$_alt_h" ] || return 0
  _alt_ts=$(date '+%Y-%m-%d %H:%M')
  if [ -n "$_alt_executor" ]; then
    printf '\n### %s — %s (executor=%s) %s\n' "$_alt_ts" "$_alt_stage" "$_alt_executor" "$_alt_state" >> "$_alt_h"
  else
    printf '\n### %s — %s %s\n' "$_alt_ts" "$_alt_stage" "$_alt_state" >> "$_alt_h"
  fi
}

# ai_step_run_next  — 다음 stage 1개 진행 (게이트 체크 포함)
ai_step_run_next() {
  _arn_cur=$(_ai_step_current_stage_marker)
  _arn_next=$(_ai_step_next_stage "$_arn_cur")
  if [ -z "$_arn_next" ]; then
    printf '   ▶ 모든 stage 종료. 진행할 다음 stage 없음.\n'
    return 0
  fi

  # 승인 게이트: Stage 4.5 (plan_final approved 검증).
  if [ "$_arn_next" = "stage5" ] && ! _ai_step_plan_final_approved; then
    printf '⏸  Stage 4.5 승인 게이트. plan_final.md status: approved 변경 후 --resume 실행.\n'
    ai_step_log_transition "$_arn_next" 'paused'
    return 0
  fi

  # 승인 게이트: Stage 11 (간이 단순화 — 항상 paused 후 --resume).
  if [ "$_arn_next" = "stage11" ] && ! _ai_step_last_state_is_paused; then
    printf '⏸  Stage 11 승인 게이트. 고위험 작업 검토 후 --resume 실행.\n'
    ai_step_log_transition "$_arn_next" 'paused'
    return 0
  fi

  _arn_skey=$(_ai_step_assign_key_for "$_arn_next")
  if [ -n "$_arn_skey" ]; then
    _arn_exec=$(ai_step_resolve_executor "$_arn_skey")
    ai_step_log_transition "$_arn_next" 'started' "$_arn_exec"
    ai_step_dispatch "$_arn_skey" "$_arn_exec"
  else
    ai_step_log_transition "$_arn_next" 'started'
    printf '   ▶ %s — Claude 본인 실행 (Stage 2~7, 12, 13 기본)\n' "$_arn_next"
  fi
}

# ai_step_run_auto — 다음 승인 게이트(paused)까지 반복.
ai_step_run_auto() {
  _ara_max=20
  while [ "$_ara_max" -gt 0 ]; do
    _ara_max=$((_ara_max - 1))
    if ! ai_step_run_next; then
      return 1
    fi
    if _ai_step_last_state_is_paused; then
      return 0
    fi
    # next stage가 더 이상 없으면 (stage13 마무리) 빠져나감.
    _ara_cur=$(_ai_step_current_stage_marker)
    _ara_peek=$(_ai_step_next_stage "$_ara_cur")
    if [ -z "$_ara_peek" ]; then
      return 0
    fi
  done
  _ai_step_die 13 "ai_step_run_auto: 최대 stage 진행 한도(20) 초과. 무한 루프 의심."
}

# ============================================================================
# --status — 현재 운영 상태 출력 (표시 경로, F-2-a 예외 OK)
# ============================================================================

_ai_step_status_print() {
  _asp_file=$(settings_path)
  if [ ! -f "$_asp_file" ]; then
    _ai_step_die 4 "settings.json 없음: $_asp_file (init_project.sh 실행 필요)"
  fi

  _asp_workflow=$(settings_read_key workflow_mode)
  _asp_team=$(settings_read_key team_mode)
  _asp_s8=$(settings_read_stage_assign stage8_impl)
  _asp_s9=$(settings_read_stage_assign stage9_review)
  _asp_s10=$(settings_read_stage_assign stage10_fix)
  _asp_s11=$(settings_read_stage_assign stage11_verify)

  _asp_cur=$(_ai_step_current_stage_marker)
  _asp_next=$(_ai_step_next_stage "$_asp_cur")
  _asp_skey=$(_ai_step_assign_key_for "${_asp_next:-}")

  printf 'ai_step.sh — 현재 운영 상태:\n'
  printf '  workflow_mode: %s\n' "${_asp_workflow:-(미설정)}"
  printf '  team_mode:    %s\n' "${_asp_team:-(미설정)}"
  printf '  stage_assignments:\n'
  printf '    stage8_impl:    %s\n' "${_asp_s8:-(미설정)}"
  printf '    stage9_review:  %s\n' "${_asp_s9:-(미설정)}"
  printf '    stage10_fix:    %s\n' "${_asp_s10:-(미설정)}"
  printf '    stage11_verify: %s\n' "${_asp_s11:-(미설정)}"
  printf '  마지막 dev_history 마커: %s\n' "${_asp_cur:-(없음)}"
  if [ -n "$_asp_skey" ]; then
    printf '  다음 stage 예정:        %s (assignments 키: %s)\n' "${_asp_next:-(없음)}" "$_asp_skey"
  else
    printf '  다음 stage 예정:        %s (assignments 키: 없음 — Claude 본인 실행)\n' "${_asp_next:-(없음)}"
  fi
}

# ============================================================================
# main 디스패처
# ============================================================================

_ai_step_main() {
  _aim_action=""
  _aim_stage_arg=""

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --status)        _aim_action="status"; shift ;;
      --next)          _aim_action="next"; shift ;;
      --auto)          _aim_action="auto"; shift ;;
      --resume)        _aim_action="resume"; shift ;;
      --stage)
        _aim_action="legacy"
        shift
        if [ "$#" -gt 0 ]; then
          _aim_stage_arg="$1"
          shift
        fi
        ;;
      -h|--help)
        _ai_step_print_usage
        exit 0
        ;;
      --*)
        _ai_step_die 2 "알 수 없는 옵션: $1"
        ;;
      *)
        if [ -z "$_aim_action" ]; then
          _aim_action="legacy"
        fi
        if [ -z "$_aim_stage_arg" ]; then
          _aim_stage_arg="$1"
        fi
        shift
        ;;
    esac
  done

  case "$_aim_action" in
    status)
      _ai_step_status_print
      ;;
    next)
      settings_require_v04
      ai_step_run_next
      ;;
    auto)
      settings_require_v04
      ai_step_run_auto
      ;;
    resume)
      settings_require_v04
      ai_step_run_next
      ;;
    legacy|"")
      _ai_step_legacy_print "$_aim_stage_arg"
      ;;
    *)
      _ai_step_die 2 "알 수 없는 액션: $_aim_action"
      ;;
  esac
}

# BASH_SOURCE guard — 테스트가 함수만 호출하기 위해 source 가능.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  _ai_step_main "$@"
fi
