#!/usr/bin/env bash
# init_project.sh — Initialize project folders + .claude/settings.json (v0.4 schema)
#
# Usage:
#   bash scripts/init_project.sh                # interactive (default)
#   bash scripts/init_project.sh --with-env     # also copy .env.example -> .env
#   bash scripts/init_project.sh --no-prompt    # CI/automation: write defaults
#   bash scripts/init_project.sh --force-reinit # rewrite v0.6 fields even if v0.4
#
# v0.5 folder/dev_history/decisions starter logic preserved.
# v0.6 additions (technical_design.md Sec.3): workflow_mode + team_mode dialogue
# → POSIX write to .claude/settings.json. No jq (F-D2). F-D3 fields excluded.
# brainstorm.md Sec.4 verbatim blocks (F-n1) — see _init_print_*_prompt below.

set -eu

# SCRIPT_DIR = location of this script (always real repo). Used to source lib/.
# ROOT       = project root (override via JONEFLOW_ROOT for tests).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -n "${JONEFLOW_ROOT:-}" ]; then
  ROOT="$JONEFLOW_ROOT"
else
  ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi
SETTINGS_FILE="$ROOT/.claude/settings.json"

# Source POSIX library (provides settings_write_key, settings_write_stage_assign_block).
# Always loaded from the real repo via SCRIPT_DIR (independent of test ROOT).
# shellcheck disable=SC1091
. "$SCRIPT_DIR/lib/settings.sh"

WITH_ENV=0
NO_PROMPT=0
FORCE_REINIT=0

# Arg parsing moved into _init_parse_args (called from _init_main).
# Module-level parser would otherwise consume the parent script's $@ when
# init_project.sh is sourced (e.g. by switch_team.sh) — see source guard at EOF.
_init_parse_args() {
  for _arg in "$@"; do
    case "$_arg" in
      --with-env)     WITH_ENV=1 ;;
      --no-prompt)    NO_PROMPT=1 ;;
      --force-reinit) FORCE_REINIT=1 ;;
      -h|--help)
        sed -n '2,8p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
      *)
        echo "init_project.sh: 알 수 없는 인자: $_arg" >&2
        echo "사용법: bash scripts/init_project.sh [--with-env] [--no-prompt] [--force-reinit]" >&2
        exit 2
        ;;
    esac
  done
}

# ============================================================================
# verbatim prompt blocks — brainstorm.md Sec.4 L58–77 (workflow), L81–101 (team)
# F-n1: ★추천★ 마커 포함 1:1 보존. 수정 금지. golden file 테스트가 매 빌드 검증.
# ============================================================================

_init_print_workflow_mode_prompt() {
  cat <<'EOF'
=== jOneFlow 프로젝트 초기화 ===

[1/2] 운영 방식을 선택하세요:

  1) 데스크탑 only
     - Cowork 앱에서 Claude와 대화하며 전 단계 진행
     - 터미널 명령어를 중간중간 수동으로 실행
     → 추천: 터미널이 낯선 분 / 처음 jOneFlow를 쓰는 분

  2) 데스크탑 + CLI
     - Stage 1 소통은 Cowork, Stage 2–13은 CLI 오케스트레이터 자동 처리
     - 터미널 개입 최소화
     → 추천: Cowork 익숙 + CLI도 병행하고 싶은 분

  3) CLI only
     - 전 단계를 터미널에서 진행 (claude 대화형 REPL 포함)
     - 가장 높은 자동화 수준
     → 추천: 터미널 주 사용자 / Cowork 없이 운영하고 싶은 분

선택 (1/2/3, 기본값 1):
EOF
}

_init_print_team_mode_prompt() {
  cat <<'EOF'
[2/2] 에이전트 팀 구성을 선택하세요:

  1) Claude 구현 + Codex 리뷰  ★추천★
     - 구현: claude --teammate-mode
     - 리뷰: /codex:review (Codex 5.5 리뷰 능력 활용)
     - 검증: Claude Opus
     → 추천: Codex 리뷰 품질을 원하지만 구현은 Claude가 익숙한 분

  2) Codex 구현 + Claude 리뷰
     - 구현: /codex:rescue
     - 리뷰: Claude Opus 서브에이전트
     - 수정보완: /codex:rescue
     - 검증: Claude Opus
     → 추천: 구현 속도 우선, 리뷰는 Claude 깊이를 원하는 분

  3) Claude 전담  (기본값)
     - 구현/리뷰/검증 모두 Claude
     - OpenAI 구독 불필요
     → 추천: OpenAI 미사용자 / 단일 도구로 심플하게

선택 (1/2/3, 기본값 3):
EOF
}

# ============================================================================
# input (1|2|3) → canonical mode value
# ============================================================================

_init_workflow_mode_from_choice() {
  case "$1" in
    1|"") echo "desktop-only" ;;
    2)    echo "desktop-cli" ;;
    3)    echo "cli-only" ;;
    *)    return 1 ;;
  esac
}

_init_team_mode_from_choice() {
  case "$1" in
    1)    echo "claude-impl-codex-review" ;;
    2)    echo "codex-impl-claude-review" ;;
    3|"") echo "claude-only" ;;
    *)    return 1 ;;
  esac
}

# team_mode → "stage8 stage9 stage10" (Sec 2.5 매핑표).
# stage11_verify는 항상 claude (Sec 2.4).
_init_stage_assignments_for_team_mode() {
  case "$1" in
    claude-impl-codex-review) echo "claude codex claude" ;;
    codex-impl-claude-review) echo "codex claude codex"  ;;
    claude-only)              echo "claude claude claude" ;;
    *) return 1 ;;
  esac
}

# ============================================================================
# interactive choice loop (max 3 attempts, then exit 2)
# ============================================================================

_init_ask_choice() {
  # $1 = printer fn, $2 = mapper fn, $3 = default-choice ("1" or "3")
  _iac_print="$1"
  _iac_map="$2"
  _iac_default="$3"
  _iac_attempts=0
  while [ "$_iac_attempts" -lt 3 ]; do
    # Prompt to stderr so command-substitution callers can capture stdout cleanly.
    "$_iac_print" >&2
    _iac_input=""
    if ! IFS= read -r _iac_input; then
      _iac_input=""
    fi
    [ -z "$_iac_input" ] && _iac_input="$_iac_default"
    if _iac_value=$("$_iac_map" "$_iac_input"); then
      echo "$_iac_value"
      return 0
    fi
    echo "잘못된 선택입니다. 1, 2, 3 중 선택." >&2
    _iac_attempts=$((_iac_attempts + 1))
  done
  echo "init_project.sh: 3회 잘못된 입력. 중단." >&2
  exit 2
}

# ============================================================================
# settings.json writers (jq-free, F-D2)
# ============================================================================

# Case A: settings.json 부재 → heredoc 템플릿 전체 emit.
# 호출: _init_emit_v04_skeleton WORKFLOW_MODE TEAM_MODE STAGE8 STAGE9 STAGE10
_init_emit_v04_skeleton() {
  _ies_wm="$1"; _ies_tm="$2"; _ies_s8="$3"; _ies_s9="$4"; _ies_s10="$5"
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  # Note: agents:{} 의도적 빈 객체. v0.6 신규 필드만 책임. (Sec 3.5)
  cat > "$SETTINGS_FILE" <<EOF
{
  "_comment": "AI Workflow settings — schema v0.4 (v0.6 CLI automation layer).",
  "_comment_v04_fields": "workflow_mode + team_mode + stage_assignments는 POSIX grep/sed/awk로만 파싱된다. 2-space 들여쓰기 / 1줄 1키 / 파일 내 유일 키명 규약을 깨지 말 것.",
  "_comment_model_policy": "Max x5 요금제 기준. Stage 1=Sonnet, Stage 2–4=Opus, Stage 5=Opus, Stage 9/11=Opus, 나머지=Sonnet.",
  "schema_version": "0.4",
  "workflow_mode": "${_ies_wm}",
  "team_mode": "${_ies_tm}",
  "stage_assignments": {
    "stage8_impl": "${_ies_s8}",
    "stage9_review": "${_ies_s9}",
    "stage10_fix": "${_ies_s10}",
    "stage11_verify": "claude"
  },
  "language": "ko",
  "teammateMode": "tmux",
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "agents": {}
}
EOF
}

# Case B: 기존 v0.3 → schema bump + 신규 필드 awk 삽입.
# 기존 v0.3 필드(agents.*, env.*, language, teammateMode)는 100% 보존 (F-5-a).
_init_upgrade_v03_to_v04() {
  _iuv_wm="$1"; _iuv_tm="$2"; _iuv_s8="$3"; _iuv_s9="$4"; _iuv_s10="$5"
  _iuv_tmp1=$(mktemp "${TMPDIR:-/tmp}/init_project.XXXXXX")
  _iuv_tmp2=$(mktemp "${TMPDIR:-/tmp}/init_project.XXXXXX")

  # 1. schema_version 0.3 → 0.4 bump.
  if ! sed 's|"schema_version": *"0.3"|"schema_version": "0.4"|' "$SETTINGS_FILE" > "$_iuv_tmp1"; then
    rm -f "$_iuv_tmp1" "$_iuv_tmp2"
    echo "init_project.sh: schema_version bump 실패. 원본 보존." >&2
    return 5
  fi

  # 2. v0.4 신규 필드를 schema_version 라인 바로 아래에 awk로 삽입.
  if ! awk -v wm="$_iuv_wm" -v tm="$_iuv_tm" \
          -v s8="$_iuv_s8" -v s9="$_iuv_s9" -v s10="$_iuv_s10" '
    BEGIN { inserted = 0 }
    {
      print
      if (!inserted && $0 ~ /^[[:space:]]+"schema_version":[[:space:]]*"0\.4",?[[:space:]]*$/) {
        print "  \"workflow_mode\": \"" wm "\","
        print "  \"team_mode\": \"" tm "\","
        print "  \"stage_assignments\": {"
        print "    \"stage8_impl\": \"" s8 "\","
        print "    \"stage9_review\": \"" s9 "\","
        print "    \"stage10_fix\": \"" s10 "\","
        print "    \"stage11_verify\": \"claude\""
        print "  },"
        inserted = 1
      }
    }
    END {
      if (!inserted) exit 5
    }
  ' "$_iuv_tmp1" > "$_iuv_tmp2"; then
    rm -f "$_iuv_tmp1" "$_iuv_tmp2"
    echo "init_project.sh: v0.4 필드 삽입 실패 (schema_version 라인 발견 못함). 원본 보존." >&2
    return 5
  fi

  # 3. atomic mv.
  if ! mv "$_iuv_tmp2" "$SETTINGS_FILE"; then
    rm -f "$_iuv_tmp1" "$_iuv_tmp2"
    echo "init_project.sh: 원자적 mv 실패. 원본 보존." >&2
    return 5
  fi
  rm -f "$_iuv_tmp1"
}

# Case C-force: 기존 v0.4 + --force-reinit → 신규 v0.6 필드만 in-place 갱신.
# agents.* 등 기존 v0.4 필드는 손대지 않음 (lib settings.sh의 atomic 라인 교체 사용).
_init_reinit_v04_in_place() {
  _irv_wm="$1"; _irv_tm="$2"
  # workflow_mode 라인 교체 (settings.sh).
  settings_write_key workflow_mode "$_irv_wm"
  # team_mode + stage_assignments 4라인 동시 교체 (settings.sh, Sec 2.5 매핑).
  settings_write_stage_assign_block "$_irv_tm"
}

# ============================================================================
# state detection + setup orchestration
# ============================================================================

_init_detect_schema_version() {
  # echo: "absent" | "v03" | "v04" | "unknown"
  if [ ! -f "$SETTINGS_FILE" ]; then
    echo "absent"; return 0
  fi
  _idsv_v=$(sed -n 's/^  "schema_version": *"\([^"]*\)".*/\1/p' "$SETTINGS_FILE" | sed -n '1p')
  case "$_idsv_v" in
    "0.3") echo "v03" ;;
    "0.4") echo "v04" ;;
    *)     echo "unknown" ;;
  esac
}

_init_run_settings_setup() {
  echo ""
  _state=$(_init_detect_schema_version)
  case "$_state" in
    v04)
      if [ "$FORCE_REINIT" != "1" ]; then
        _existing_wm=$(sed -n 's/^  "workflow_mode": *"\([^"]*\)".*/\1/p' "$SETTINGS_FILE" | sed -n '1p')
        _existing_tm=$(sed -n 's/^  "team_mode": *"\([^"]*\)".*/\1/p' "$SETTINGS_FILE" | sed -n '1p')
        echo "ℹ️  settings.json 이미 v0.4로 초기화됨. 대화 생략."
        echo "    workflow_mode: ${_existing_wm:-(미설정)}"
        echo "    team_mode:    ${_existing_tm:-(미설정)}"
        echo "    재실행: bash scripts/init_project.sh --force-reinit"
        echo "    런타임 변경: bash scripts/switch_team.sh"
        return 0
      fi
      echo "🔁 --force-reinit: settings.json 신규 v0.6 필드만 재기록 (기존 agents.* 보존)."
      ;;
    v03)
      echo "🔁 v0.3 settings.json 감지 → v0.4로 업그레이드합니다 (기존 v0.3 필드 보존)."
      ;;
    absent)
      echo "🆕 settings.json 부재. v0.4 스켈레톤을 생성합니다."
      ;;
    unknown)
      echo "init_project.sh: settings.json schema_version 확인 불가. 수동 점검 필요." >&2
      return 5
      ;;
  esac

  if [ "$NO_PROMPT" = "1" ]; then
    WORKFLOW_MODE="desktop-only"
    TEAM_MODE="claude-only"
    echo "  --no-prompt: 기본값 적용 (workflow_mode=$WORKFLOW_MODE, team_mode=$TEAM_MODE)"
  else
    WORKFLOW_MODE=$(_init_ask_choice _init_print_workflow_mode_prompt _init_workflow_mode_from_choice 1)
    TEAM_MODE=$(_init_ask_choice _init_print_team_mode_prompt _init_team_mode_from_choice 3)
  fi

  # Sec 2.5 매핑.
  _assigns=$(_init_stage_assignments_for_team_mode "$TEAM_MODE") || {
    echo "init_project.sh: stage_assignments 매핑 실패: '$TEAM_MODE'" >&2
    return 5
  }
  # shellcheck disable=SC2086  # word-splitting intentional (3 tokens).
  set -- $_assigns
  STAGE8="$1"; STAGE9="$2"; STAGE10="$3"

  case "$_state" in
    absent)
      _init_emit_v04_skeleton "$WORKFLOW_MODE" "$TEAM_MODE" "$STAGE8" "$STAGE9" "$STAGE10"
      ;;
    v03)
      _init_upgrade_v03_to_v04 "$WORKFLOW_MODE" "$TEAM_MODE" "$STAGE8" "$STAGE9" "$STAGE10"
      ;;
    v04)
      # --force-reinit only (early-return above for non-force).
      _init_reinit_v04_in_place "$WORKFLOW_MODE" "$TEAM_MODE"
      ;;
  esac

  echo ""
  echo "✅ settings.json 업데이트 완료."
  echo ""
  echo "  workflow_mode: ${WORKFLOW_MODE}"
  echo "  team_mode:    ${TEAM_MODE}"
  echo ""
  echo "패턴/팀 구성을 나중에 바꾸려면:"
  echo "  bash scripts/switch_team.sh"
  echo "  → docs/guides/switching.md 참조"
}

# ============================================================================
# main — v0.5 폴더 생성 로직 보존 + v0.6 settings 단계 추가
# ============================================================================

_init_main() {
  _init_parse_args "$@"
  cd "$ROOT"

  echo "=============================="
  echo "  jOneFlow — Init"
  echo "=============================="
  echo ""

  dirs=(
    "src"
    "tests"
    "data"
    "logs"
    "docs/01_brainstorm"
    "docs/02_planning"
    "docs/03_design"
    "docs/04_implementation"
    "docs/05_qa_release"
    "docs/notes"
    "prompts/claude"
    "prompts/codex"
    ".skills"
  )

  for d in "${dirs[@]}"; do
    mkdir -p "$ROOT/$d"
    touch "$ROOT/$d/.gitkeep"
  done

  if [ ! -f "$ROOT/docs/notes/dev_history.md" ]; then
    cat > "$ROOT/docs/notes/dev_history.md" << 'EOF'
# Development History

> Append one entry per stage completion. Never delete entries.

---

## Format

```
### Stage X — YYYY-MM-DD — Mode: Lite | Standard | Strict
- Completed: [what was done]
- Blockers: [any blockers, or "none"]
- Output: [link to output document]
- Rollbacks: [if this was a rollback, say what triggered it and where it came from]
```

---

EOF
    echo "✅ Created docs/notes/dev_history.md"
  fi

  if [ ! -f "$ROOT/docs/notes/decisions.md" ]; then
    cat > "$ROOT/docs/notes/decisions.md" << 'EOF'
# Decision Log

> Record architectural and design decisions here.
> Format: Date | Decision | Reason | Alternatives considered

---

EOF
    echo "✅ Created docs/notes/decisions.md"
  fi

  # .env handling — OPT-IN only.
  # Real secrets live in the OS keychain (security/secret_loader.py).
  if [ "$WITH_ENV" = "1" ]; then
    if [ ! -f "$ROOT/.env" ] && [ -f "$ROOT/.env.example" ]; then
      cp "$ROOT/.env.example" "$ROOT/.env"
      echo "✅ Created .env from .env.example (local scratch only — do NOT commit, do NOT put production secrets here)"
    fi
  else
    if [ -f "$ROOT/.env.example" ] && [ ! -f "$ROOT/.env" ]; then
      echo "ℹ️  Skipped creating .env. Real secrets live in the OS keychain via security/secret_loader.py."
      echo "    Rerun with --with-env if you want a local scratch .env for development shortcuts."
    fi
  fi

  # v0.6: settings.json workflow_mode/team_mode/stage_assignments setup.
  _init_run_settings_setup

  echo ""
  echo "=============================="
  echo "  Init complete!"
  echo ""
  echo "  Next steps:"
  echo "  1. Store any real secrets:    python3 security/secret_loader.py --setup"
  echo "  2. Initialize git:            git init && git add . && git commit -m 'chore: init project'"
  echo "  3. Start Stage 1 (brainstorm) with Claude, and choose a mode (Lite / Standard / Strict)."
  echo "=============================="
}

# Source-vs-execute guard: tests source this file to call _init_print_*_prompt
# without triggering folder creation.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  _init_main "$@"
fi
