#!/usr/bin/env bash
# switch_team.sh — Runtime team_mode switcher (technical_design.md Sec 4).
#
# Usage:
#   bash scripts/switch_team.sh                                  # interactive
#   bash scripts/switch_team.sh <mode>                           # direct
#   bash scripts/switch_team.sh <mode> --force                   # bypass bg check
#   bash scripts/switch_team.sh --status                         # display only
#
# <mode> ∈ { claude-only, claude-impl-codex-review, codex-impl-claude-review }
#
# Constraints:
#   - jq 비의존 (F-D2). settings.sh의 POSIX 파서/라이터만 사용.
#   - 구 pending 필드/상태 미사용 (F-D3). 2분기 모델만 (차단/즉시).
#   - team_mode 리터럴 실행 분기 금지 (F-2-a). 표시 경로(--status, 메시지)만 예외.
#   - brainstorm Sec.5 L118-123 차단 메시지 verbatim 보존 (F-n2).
#   - openai-codex CLI 호출 경로 없음 (F-n3). plugin-cc 패턴 매칭만.
#
# Exit codes (Sec 9.1):
#   0 정상  1 백그라운드 차단  2 잘못된 인자  3 schema 불일치
#   4 settings.json 부재  5 포맷 손상

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -n "${JONEFLOW_ROOT:-}" ]; then
  ROOT="$JONEFLOW_ROOT"
else
  ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

# Source POSIX library + init verbatim block re-use.
# Both scripts are bash (BASH_SOURCE guard); sourcing them does not run main.
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib/settings.sh"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/init_project.sh"

# ============================================================================
# verbatim block — brainstorm.md Sec.5 L118-123. F-n2: 수정 금지.
# golden file 테스트 (test_switch_team_block.sh)가 매 빌드 byte-level 검증.
# ============================================================================

_switch_print_block_verbatim() {
  cat <<'EOF'
⚠️  팀 구성을 변경할 수 없습니다.

현재 구현 또는 검증 작업이 백그라운드에서 진행 중입니다.
작업이 완료된 후 다음 구현 시작 전에 변경해 주세요.

진행 상태 확인: /codex:status
EOF
}

# ============================================================================
# background process detection (Sec 4.4).
# pgrep -fl 패턴 매칭. 자기 자신($$) 필터링.
# ============================================================================

_switch_detect_bg() {
  # Echo PID + commandline lines (one per match). Empty stdout = clean.
  # claude --teammate-mode 패턴.
  _sdb_claude=$(pgrep -fl 'claude.*--teammate-mode' 2>/dev/null \
                  | grep -v "^$$ " \
                  || true)
  # Codex plugin-cc 패턴 (openai-codex CLI 미포함, F-n3).
  _sdb_codex=$(pgrep -fl '(codex-plugin-cc|/codex:(rescue|review|status))' 2>/dev/null \
                 | grep -v "^$$ " \
                 || true)
  if [ -n "$_sdb_claude" ]; then
    printf '%s\n' "$_sdb_claude"
  fi
  if [ -n "$_sdb_codex" ]; then
    printf '%s\n' "$_sdb_codex"
  fi
}

# ============================================================================
# usage / arg parsing
# ============================================================================

_switch_usage() {
  cat <<'EOF' >&2
사용법:
  bash scripts/switch_team.sh                              # 대화 모드
  bash scripts/switch_team.sh <mode>                       # 직접 지정
  bash scripts/switch_team.sh <mode> --force               # 백그라운드 우회
  bash scripts/switch_team.sh --status                     # 현재 상태 출력

<mode> ∈ { claude-only, claude-impl-codex-review, codex-impl-claude-review }
EOF
}

_switch_validate_mode() {
  case "$1" in
    claude-only|claude-impl-codex-review|codex-impl-claude-review) return 0 ;;
    *) return 1 ;;
  esac
}

# ============================================================================
# --status (Sec 4.8). 표시 경로 — team_mode 리터럴 출력 허용 (F-2-a 예외).
# ============================================================================

_switch_status() {
  if [ ! -f "$ROOT/.claude/settings.json" ]; then
    echo "switch_team.sh: settings.json 없음 ($ROOT/.claude/settings.json). init_project.sh 실행." >&2
    exit 4
  fi
  _ss_wm=$(settings_read_key workflow_mode)
  _ss_tm=$(settings_read_key team_mode)
  _ss_s8=$(settings_read_stage_assign stage8_impl)
  _ss_s9=$(settings_read_stage_assign stage9_review)
  _ss_s10=$(settings_read_stage_assign stage10_fix)
  _ss_s11=$(settings_read_stage_assign stage11_verify)

  echo "현재 운영 상태:"
  echo "  workflow_mode: ${_ss_wm:-(미설정)}"
  echo "  team_mode:    ${_ss_tm:-(미설정)}"
  echo "  stage_assignments:"
  echo "    stage8_impl:    ${_ss_s8:-(미설정)}"
  echo "    stage9_review:  ${_ss_s9:-(미설정)}"
  echo "    stage10_fix:    ${_ss_s10:-(미설정)}"
  echo "    stage11_verify: ${_ss_s11:-(미설정)}"

  _ss_bg=$(_switch_detect_bg)
  if [ -z "$_ss_bg" ]; then
    echo "  백그라운드 claude/codex: 없음"
  else
    echo "  백그라운드 claude/codex:"
    printf '%s\n' "$_ss_bg" | sed 's/^/    /'
  fi
}

# ============================================================================
# 정상 전환 (Sec 4.6). team_mode + stage_assignments 4라인 atomic 교체.
# ============================================================================

_switch_apply() {
  _sa_new="$1"
  _sa_prev=$(settings_read_key team_mode)
  # settings_write_stage_assign_block: team_mode + 4 stage 라인 동시 atomic write.
  settings_write_stage_assign_block "$_sa_new"

  _sa_s8=$(settings_read_stage_assign stage8_impl)
  _sa_s9=$(settings_read_stage_assign stage9_review)
  _sa_s10=$(settings_read_stage_assign stage10_fix)
  _sa_s11=$(settings_read_stage_assign stage11_verify)

  echo ""
  echo "✅ team_mode 변경 완료."
  echo ""
  echo "  이전: ${_sa_prev:-(미설정)}"
  echo "  현재: ${_sa_new}"
  echo ""
  echo "  stage_assignments (Sec 2.5 매핑):"
  echo "    stage8_impl:    ${_sa_s8}"
  echo "    stage9_review:  ${_sa_s9}"
  echo "    stage10_fix:    ${_sa_s10}"
  echo "    stage11_verify: ${_sa_s11}"
  echo ""
  echo "패턴 변경 가이드: docs/guides/switching.md"
}

# ============================================================================
# 차단 핸들러 (Sec 4.5). verbatim + 보조(감지 PID + --force 안내) + exit 1.
# ============================================================================

_switch_block_and_exit() {
  _sbe_bg="$1"
  _switch_print_block_verbatim
  echo ""
  echo "감지된 프로세스:"
  printf '%s\n' "$_sbe_bg" | sed 's/^/  PID  /'
  echo ""
  echo "우회: --force (운영자 책임. 진행 중 작업 부작용 감수)"
  exit 1
}

# ============================================================================
# main dispatcher
# ============================================================================

_switch_main() {
  # --- Phase 1: arg parse ---
  MODE=""
  FORCE=0
  STATUS=0

  for _arg in "$@"; do
    case "$_arg" in
      --status)
        STATUS=1
        ;;
      --force)
        FORCE=1
        ;;
      -h|--help)
        _switch_usage
        exit 0
        ;;
      claude-only|claude-impl-codex-review|codex-impl-claude-review)
        if [ -n "$MODE" ]; then
          echo "switch_team.sh: mode 인자 중복: '$MODE' vs '$_arg'" >&2
          _switch_usage
          exit 2
        fi
        MODE="$_arg"
        ;;
      *)
        echo "switch_team.sh: 알 수 없는 인자: '$_arg'" >&2
        _switch_usage
        exit 2
        ;;
    esac
  done

  # --- Phase 2: --status branch (no mutation) ---
  if [ "$STATUS" = "1" ]; then
    if [ -n "$MODE" ] || [ "$FORCE" = "1" ]; then
      echo "switch_team.sh: --status는 mode/--force와 함께 사용 불가." >&2
      _switch_usage
      exit 2
    fi
    _switch_status
    exit 0
  fi

  # --- Phase 3: precondition — settings.json + schema v0.4 ---
  if [ ! -f "$ROOT/.claude/settings.json" ]; then
    echo "switch_team.sh: settings.json 없음 ($ROOT/.claude/settings.json)." >&2
    echo "  → bash scripts/init_project.sh 실행 후 재시도." >&2
    exit 4
  fi
  # settings_require_v04: schema_version != 0.4 → exit 3.
  settings_require_v04

  # --- Phase 4: resolve target mode (interactive if absent) ---
  if [ -z "$MODE" ]; then
    if [ "$FORCE" = "1" ]; then
      echo "switch_team.sh: --force는 mode 인자와 함께 사용 (대화 모드와 결합 불가)." >&2
      _switch_usage
      exit 2
    fi
    # init_project.sh의 [2/2] verbatim 함수 + 입력 매퍼 + 3회 재시도 루프 재사용.
    MODE=$(_init_ask_choice _init_print_team_mode_prompt _init_team_mode_from_choice 3)
  fi

  if ! _switch_validate_mode "$MODE"; then
    echo "switch_team.sh: 알 수 없는 team_mode: '$MODE'" >&2
    _switch_usage
    exit 2
  fi

  # --- Phase 5: background gate (2분기, F-D3) ---
  BG=$(_switch_detect_bg)
  if [ -n "$BG" ] && [ "$FORCE" != "1" ]; then
    _switch_block_and_exit "$BG"
  fi

  # --- Phase 6: apply (atomic write via settings.sh) ---
  _switch_apply "$MODE"
}

# Source-vs-execute guard: tests source this file to call internal helpers
# (_switch_print_block_verbatim, _switch_detect_bg) without dispatching main.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  _switch_main "$@"
fi
