#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# spawn_team.sh — 팀 세션 + 4-pane split + claude 기동 자동화 (v0.6.6 #5).
#
# 역할: 팀별(plan/design/dev) tmux 세션 생성 + 4 pane split + 페르소나 매핑
#       + claude CLI 기동 시 모델/effort 자동 주입.
#
# pane 헌법 (dispatch v0.6.6 #5):
#   - 왼쪽 큰 pane = 오케 PL
#   - 오른쪽 stack 3개 = drafter / reviewer / finalizer
#   - select-pane -T <페르소나명> + pane-border-status top + pane-border-format
#
# 사용법:
#   bash scripts/spawn_team.sh dev               # 개발팀 BE default (4명)
#   bash scripts/spawn_team.sh dev-fe            # 개발팀 FE
#   bash scripts/spawn_team.sh plan              # 기획팀 4명
#   bash scripts/spawn_team.sh design            # 디자인팀 4명
#   bash scripts/spawn_team.sh dev --version 0.6.6
#   bash scripts/spawn_team.sh dev --session Orc-066-dev
#   bash scripts/spawn_team.sh dev --dry-run     # 명령만 echo
#   bash scripts/spawn_team.sh dev --no-claude   # tmux만, claude 기동 skip
#
# 종료 코드:
#   0 정상  2 잘못된 인자  3 settings.json schema 불일치  4 tmux 미감지
#   5 세션 충돌 (기존 동명 세션, --force 미사용)

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib/personas.sh"
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib/settings.sh"

# ============================================================================
# 옵션 파싱
# ============================================================================

TEAM=""
VERSION=""
SESSION_NAME=""
DRY_RUN=0
NO_CLAUDE=0
FORCE=0
MAIN_PANE_WIDTH_PCT=62  # main-vertical 비율 (왼쪽 큰 pane)

_usage() {
    cat <<'EOF'
spawn_team.sh — 팀 세션 spawn + 4-pane split + claude 기동.

Usage:
  spawn_team.sh <team> [--version V] [--session NAME] [--dry-run] [--no-claude] [--force]

Teams:
  plan     기획팀 4명 (이종선 PL + 김민교/안영이/장그래)
  design   디자인팀 4명 (우상호 PL + 이수지/오해원/장원영)
  dev      개발팀 BE 4명 (공기성 PL + 카더가든/최우영/현봉식)
  dev-fe   개발팀 FE 4명 (공기성 PL + 지예은/백강혁/김원훈)

Options:
  --version V    프로젝트 버전 (예: 0.6.6) — 미지정 시 handoffs/active/HANDOFF_v*.md 자동 감지
  --session N    세션명 직접 지정 (default: Orc-<ver-숫자>-<team-suffix>)
  --dry-run      tmux 명령만 echo. 실제 실행 X.
  --no-claude    tmux 세션 + pane만 셋업. claude CLI 기동 skip.
  --force        동명 세션 존재 시 kill 후 재생성.
  -h | --help    도움말.

상세: docs/operating_manual.md Sec.1.2 + dispatch v0.6.6 #5.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        plan|design|dev|dev-be|dev-fe) TEAM="$1"; shift ;;
        --version) VERSION="${2:-}"; shift 2 ;;
        --session) SESSION_NAME="${2:-}"; shift 2 ;;
        --dry-run) DRY_RUN=1; shift ;;
        --no-claude) NO_CLAUDE=1; shift ;;
        --force) FORCE=1; shift ;;
        -h|--help) _usage; exit 0 ;;
        *) printf 'spawn_team.sh: 알 수 없는 인자: %s\n' "$1" >&2; _usage >&2; exit 2 ;;
    esac
done

if [ -z "$TEAM" ]; then
    _usage >&2
    exit 2
fi
# dev = dev-be alias.
[ "$TEAM" = "dev" ] && TEAM="dev-be"

# ============================================================================
# 버전 / 세션명 결정
# ============================================================================

_detect_version() {
    if [ -n "$VERSION" ]; then
        printf '%s' "$VERSION"
        return 0
    fi
    # handoffs/active/HANDOFF_v<X>.md 에서 추출.
    for _f in "$ROOT"/handoffs/active/HANDOFF_v*.md; do
        [ -f "$_f" ] || continue
        _b=$(basename "$_f" .md)
        printf '%s' "${_b#HANDOFF_v}"
        return 0
    done
    printf '0.6.6'  # fallback default
}

VERSION=$(_detect_version)
# 점 제거: 0.6.6 → 066 (Orc 세션명 컨벤션).
VER_NUM=$(printf '%s' "$VERSION" | tr -d '.')

if [ -z "$SESSION_NAME" ]; then
    case "$TEAM" in
        plan)    SESSION_NAME="Orc-${VER_NUM}-plan" ;;
        design)  SESSION_NAME="Orc-${VER_NUM}-design" ;;
        dev-be)  SESSION_NAME="Orc-${VER_NUM}-dev" ;;
        dev-fe)  SESSION_NAME="Orc-${VER_NUM}-dev-fe" ;;
    esac
fi

# ============================================================================
# tmux 명령 wrapper (dry-run 지원)
# ============================================================================

_run() {
    if [ "$DRY_RUN" = "1" ]; then
        printf 'DRY-RUN: %s\n' "$*"
    else
        # shellcheck disable=SC2294
        eval "$@"
    fi
}

_die() {
    printf 'spawn_team.sh: %s\n' "$*" >&2
    exit "${2:-1}"
}

# ============================================================================
# Pre-flight 검증
# ============================================================================

if ! command -v tmux >/dev/null 2>&1; then
    _die "tmux 미설치. brew install tmux 필요." 4
fi

if [ -f "$ROOT/.claude/settings.json" ]; then
    # v0.4 또는 v0.5 schema 모두 통과 (grace period).
    settings_require_v04 || _die "settings.json schema 불일치." 3
fi

# 동명 세션 충돌 검사.
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    if [ "$FORCE" = "1" ]; then
        printf '⚠️  세션 %s 이미 존재 — --force, kill 후 재생성.\n' "$SESSION_NAME"
        _run "tmux kill-session -t '$SESSION_NAME'"
    else
        _die "세션 '$SESSION_NAME' 이미 존재. --force 또는 다른 --session 지정." 5
    fi
fi

# ============================================================================
# 페르소나 명단 + 모델/effort lookup
# ============================================================================

ROSTER=$(persona_list_team "$TEAM")
if [ -z "$ROSTER" ]; then
    _die "팀 페르소나 명단 lookup 실패: $TEAM" 2
fi

# ROSTER = "PL|m1|m2|m3"  →  4개 변수로 분할.
PL_NAME=$(printf '%s' "$ROSTER" | cut -d'|' -f1)
M1_NAME=$(printf '%s' "$ROSTER" | cut -d'|' -f2)  # drafter
M2_NAME=$(printf '%s' "$ROSTER" | cut -d'|' -f3)  # reviewer
M3_NAME=$(printf '%s' "$ROSTER" | cut -d'|' -f4)  # finalizer

PL_MODEL=$(persona_model "$PL_NAME")
M1_MODEL=$(persona_model "$M1_NAME")
M2_MODEL=$(persona_model "$M2_NAME")
M3_MODEL=$(persona_model "$M3_NAME")

PL_EFFORT=$(persona_effort "$PL_NAME")
M1_EFFORT=$(persona_effort "$M1_NAME")
M2_EFFORT=$(persona_effort "$M2_NAME")
M3_EFFORT=$(persona_effort "$M3_NAME")

# pane 타이틀 = "<페르소나> [<role>·<effort>]"  (pane-border-format에 표시)
PL_TITLE="${PL_NAME} [PL·${PL_EFFORT}]"
M1_TITLE="${M1_NAME} [drafter·${M1_EFFORT}]"
M2_TITLE="${M2_NAME} [reviewer·${M2_EFFORT}]"
M3_TITLE="${M3_NAME} [finalizer·${M3_EFFORT}]"

printf '\n▶ spawn_team.sh — %s (%s)\n' "$TEAM" "$SESSION_NAME"
printf '   version=%s pane_main_pct=%s%%\n' "$VERSION" "$MAIN_PANE_WIDTH_PCT"
printf '   PL:        %s  (%s, %s)\n' "$PL_NAME"  "$PL_MODEL"  "$PL_EFFORT"
printf '   drafter:   %s  (%s, %s)\n' "$M1_NAME"  "$M1_MODEL"  "$M1_EFFORT"
printf '   reviewer:  %s  (%s, %s)\n' "$M2_NAME"  "$M2_MODEL"  "$M2_EFFORT"
printf '   finalizer: %s  (%s, %s)\n' "$M3_NAME"  "$M3_MODEL"  "$M3_EFFORT"
printf '\n'

# ============================================================================
# tmux 세션 + pane 생성
# ============================================================================

# 1. detached 세션 생성 (1 pane).
_run "tmux new-session -d -s '$SESSION_NAME' -n team -c '$ROOT'"

# 2. base-index 무관하게 window index 동적 추출 (사용자 .tmux.conf base-index=1 호환).
if [ "$DRY_RUN" = "1" ]; then
    WIN_IDX=0  # dry-run에서는 가정값.
else
    WIN_IDX=$(tmux list-windows -t "$SESSION_NAME" -F '#{window_index}' 2>/dev/null | head -1)
    [ -z "$WIN_IDX" ] && _die "window index 추출 실패." 4
fi

# pane 인덱스도 base-index에 따라 0 또는 1부터 시작. 첫 pane index 추출 후 +1씩 가정.
# (split-window 호출 순서 = base+0, +1, +2, +3 으로 부여됨 — 검증된 tmux 동작.)
if [ "$DRY_RUN" = "1" ]; then
    P0=0; P1=1; P2=2; P3=3
else
    P_BASE=$(tmux list-panes -t "$SESSION_NAME:$WIN_IDX" -F '#{pane_index}' 2>/dev/null | head -1)
    [ -z "$P_BASE" ] && _die "pane index 추출 실패." 4
    P0=$P_BASE
    P1=$((P_BASE + 1))
    P2=$((P_BASE + 2))
    P3=$((P_BASE + 3))
fi

WIN_TARGET="$SESSION_NAME:$WIN_IDX"

# 3. 오른쪽 split (pane P1 — drafter).
_run "tmux split-window -t '$WIN_TARGET.$P0' -h -c '$ROOT'"

# 4. 오른쪽 pane을 다시 split (pane P2 — reviewer).
_run "tmux split-window -t '$WIN_TARGET.$P1' -v -c '$ROOT'"

# 5. 또 다시 split (pane P3 — finalizer).
_run "tmux split-window -t '$WIN_TARGET.$P2' -v -c '$ROOT'"

# 6. main-vertical layout 적용 (왼쪽 큰 pane + 오른쪽 stack).
_run "tmux select-layout -t '$WIN_TARGET' main-vertical"

# 7. 왼쪽 pane 너비 비율 설정.
_run "tmux resize-pane -t '$WIN_TARGET.$P0' -x \$((\$(tmux display-message -t '$WIN_TARGET' -p '#{window_width}') * $MAIN_PANE_WIDTH_PCT / 100))"

# 8. 페르소나 라벨 적용 — R-1/R-2 reviewer 정정 (bridge_protocol Sec.4 헌법 표 정합).
#    set-option -p @persona '<페르소나명>'  ← claude CLI auto-rename 면역 (영구 보존)
#    select-pane -T '<title>'              ← 호환용 (@persona 미감지 환경 fallback)
#    pane-border-format은 #{@persona} 사용 (아래 9번 단계).
_run "tmux set-option -p -t '$WIN_TARGET.$P0' @persona '$PL_NAME'"
_run "tmux set-option -p -t '$WIN_TARGET.$P1' @persona '$M1_NAME'"
_run "tmux set-option -p -t '$WIN_TARGET.$P2' @persona '$M2_NAME'"
_run "tmux set-option -p -t '$WIN_TARGET.$P3' @persona '$M3_NAME'"
_run "tmux select-pane -t '$WIN_TARGET.$P0' -T '$PL_TITLE'"
_run "tmux select-pane -t '$WIN_TARGET.$P1' -T '$M1_TITLE'"
_run "tmux select-pane -t '$WIN_TARGET.$P2' -T '$M2_TITLE'"
_run "tmux select-pane -t '$WIN_TARGET.$P3' -T '$M3_TITLE'"

# 9. pane-border-status + format 설정 (세션 옵션 = -g 없이 세션 한정).
#    R-2 reviewer 정정: pane-border-format은 #{@persona} 우선
#    + #{pane_title} fallback (@persona 미설정 호환). claude CLI auto-rename 후에도
#    @persona는 영구 보존되므로 페르소나 라벨이 그대로 표시됨.
_run "tmux set-option -t '$SESSION_NAME' pane-border-status top"
_run "tmux set-option -t '$SESSION_NAME' pane-border-format ' #{?@persona,#{@persona},#{pane_title}} '"

# 10. PL pane 활성화.
_run "tmux select-pane -t '$WIN_TARGET.$P0'"

# ============================================================================
# claude CLI 기동 (옵션)
# ============================================================================

# claude --dangerously-skip-permissions --model X --name "session:w.p"
# F-62-9 강제. effort는 CLI 직접 플래그 없음 → 환경변수 CLAUDE_PERSONA_EFFORT로 전달
# (token_hook / dashboard 메타데이터로 활용 가능).
_send_claude() {
    _sc_target="$1"
    _sc_persona="$2"
    _sc_model="$3"
    _sc_effort="$4"
    _sc_role="$5"

    if [ -z "$_sc_model" ]; then
        printf '   ⚠️  %s 모델 미정 → claude 기동 skip.\n' "$_sc_persona"
        return 0
    fi

    # 기동 명령 조립.
    _sc_cmd="CLAUDE_PERSONA='$_sc_persona' CLAUDE_PERSONA_ROLE='$_sc_role' CLAUDE_PERSONA_EFFORT='$_sc_effort' "
    _sc_cmd="${_sc_cmd}claude --dangerously-skip-permissions --model '$_sc_model' --name '${_sc_target}'"

    _run "tmux send-keys -t '$_sc_target' \"$_sc_cmd\" Enter"
    printf '   ▶ %s  pane=%s model=%s effort=%s\n' "$_sc_persona" "$_sc_target" "$_sc_model" "$_sc_effort"
}

if [ "$NO_CLAUDE" = "1" ]; then
    printf '\n--no-claude — tmux pane 셋업만. claude 기동 skip.\n'
else
    printf '\n▶ claude CLI 기동:\n'
    _send_claude "$WIN_TARGET.$P0" "$PL_NAME" "$PL_MODEL" "$PL_EFFORT" "PL"
    _send_claude "$WIN_TARGET.$P1" "$M1_NAME" "$M1_MODEL" "$M1_EFFORT" "drafter"
    _send_claude "$WIN_TARGET.$P2" "$M2_NAME" "$M2_MODEL" "$M2_EFFORT" "reviewer"
    _send_claude "$WIN_TARGET.$P3" "$M3_NAME" "$M3_MODEL" "$M3_EFFORT" "finalizer"
fi

# ============================================================================
# 마감 출력
# ============================================================================

printf '\n✅ spawn_team.sh 완료: %s\n' "$SESSION_NAME"
printf '   접속:  tmux attach -t %s\n' "$SESSION_NAME"
if [ "$DRY_RUN" = "1" ]; then
    printf '   (DRY-RUN — 실제 tmux 변경 없음)\n'
fi
