#!/usr/bin/env bash
# test_ai_step_auto.sh — Integration: ai_step.sh --status / paused / --auto
# (technical_design.md Sec 6.5 / 6.6 / 11.1).
#
# Scenarios:
#   A. --status — settings.json 부재 → exit 4
#   B. --status — v0.4 fixture → workflow_mode + stage_assignments 모두 출력
#   C. paused 인프라 — ai_step_log_transition 'stage5' 'paused' 호출 후
#                      _ai_step_last_state_is_paused true (dev_history 기반).
#   D. plan_final 게이트 — _ai_step_plan_final_approved 가 status 라인을 정확히 인식.
#   E. --auto end-to-end — stage1 completed 마커 + 2/3/4 artifact fixture →
#                          --auto 호출 → stage2/3/4 started + stage5 paused 시퀀스.
#   F. --resume — Case E paused 상태에서 plan_final.md status: approved 변경 →
#                 --resume → stage5 진입 (paused 게이트 통과 확인).
#
# 본체 BSD sed em-dash 추출 패치(`.* (stage[0-9]+).*`)로 _ai_step_current_stage_marker
# 가 정상 동작하므로 Case E/F 통합 시나리오 활성화됨.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
AI_STEP="$ROOT/scripts/ai_step.sh"

if [ ! -f "$AI_STEP" ]; then
    echo "FAIL: ai_step.sh not found: $AI_STEP" >&2
    exit 1
fi

TMPROOT=$(mktemp -d "${TMPDIR:-/tmp}/v06-ai-auto.XXXXXX")
trap 'rm -rf "$TMPROOT"' EXIT HUP INT TERM

failures=0

assert_eq() {
    if [ "$2" = "$3" ]; then
        printf '  PASS %s\n' "$1"
    else
        printf '  FAIL %s: expected=[%s] got=[%s]\n' "$1" "$2" "$3"
        failures=$((failures + 1))
    fi
}

assert_grep() {
    _label="$1"; _pattern="$2"; _file="$3"
    if grep -qE "$_pattern" "$_file"; then
        printf '  PASS %s\n' "$_label"
    else
        printf '  FAIL %s: pattern=[%s] not found in %s\n' "$_label" "$_pattern" "$_file"
        failures=$((failures + 1))
    fi
}

mk_fixture_v04() {
    mkdir -p "$1/.claude"
    cat > "$1/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-impl-codex-review",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "codex",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko"
}
EOF
}

mk_dev_history() {
    mkdir -p "$1/docs/notes"
    cat > "$1/docs/notes/dev_history.md" <<'EOF'
# Dev History

### 2026-04-25 09:00 — stage1 started
EOF
}

mk_plan_final_pending() {
    mkdir -p "$1/docs/02_planning_v0.6"
    cat > "$1/docs/02_planning_v0.6/plan_final.md" <<'EOF'
# Plan Final
---
status: pending_operator_approval
---
EOF
}

mk_plan_final_approved() {
    mkdir -p "$1/docs/02_planning_v0.6"
    cat > "$1/docs/02_planning_v0.6/plan_final.md" <<'EOF'
# Plan Final
---
status: approved
---
EOF
}

run_ai_step() {
    _ras_root="$1"
    shift
    set +e
    ( JONEFLOW_ROOT="$_ras_root"; export JONEFLOW_ROOT
      bash "$AI_STEP" "$@"
    ) > "$_ras_root/out" 2> "$_ras_root/err"
    _ras_rc=$?
    set -e
    printf '%s' "$_ras_rc"
}

# ============================================================================
# Case A: --status — settings.json 부재 → exit 4
# ============================================================================
RA="$TMPROOT/case_a"
mkdir -p "$RA"
rc=$(run_ai_step "$RA" --status)
assert_eq 'A: settings 부재 → exit 4' '4' "$rc"
assert_grep 'A: stderr "settings.json 없음"' 'settings.json 없음' "$RA/err"

# ============================================================================
# Case B: --status — v0.4 fixture → 핵심 필드 출력
# ============================================================================
RB="$TMPROOT/case_b"
mk_fixture_v04 "$RB"
mk_dev_history "$RB"
rc=$(run_ai_step "$RB" --status)
assert_eq 'B: --status 정상 종료'                    '0'           "$rc"
assert_grep 'B: workflow_mode 출력'                  'workflow_mode'                "$RB/out"
assert_grep 'B: team_mode 출력'                      'team_mode'                    "$RB/out"
assert_grep 'B: stage_assignments 블록 출력'         'stage_assignments'            "$RB/out"
assert_grep 'B: stage8_impl 라인 출력'               'stage8_impl:.*claude'         "$RB/out"
assert_grep 'B: stage9_review 라인 출력'             'stage9_review:.*codex'        "$RB/out"
assert_grep 'B: stage11_verify=claude 라인 출력'     'stage11_verify:.*claude'      "$RB/out"
assert_grep 'B: 다음 stage 예정 출력'                '다음 stage 예정'              "$RB/out"

# ============================================================================
# Case C: paused 인프라 — ai_step_log_transition 'stage5' 'paused' 호출 후
#         _ai_step_last_state_is_paused = true.
# ============================================================================
RC="$TMPROOT/case_c"
mk_fixture_v04 "$RC"
mk_dev_history "$RC"

# ai_step_log_transition 호출 후 dev_history paused 라인 기록 + last_state 검증.
set +e
( JONEFLOW_ROOT="$RC"; export JONEFLOW_ROOT
  # shellcheck disable=SC1090
  . "$AI_STEP"
  ai_step_log_transition 'stage5' 'paused'
  if _ai_step_last_state_is_paused; then
      printf 'PAUSED_TRUE\n'
  else
      printf 'PAUSED_FALSE\n'
  fi
) > "$RC/out" 2> "$RC/err"
rc=$?
set -e

assert_eq 'C: paused 인프라 호출 exit 0' '0' "$rc"
assert_grep 'C: _ai_step_last_state_is_paused = true' '^PAUSED_TRUE$' "$RC/out"
assert_grep 'C: dev_history에 stage5 paused 라인 추가' 'stage5 paused' "$RC/docs/notes/dev_history.md"

# ============================================================================
# Case D: plan_final 게이트 — _ai_step_plan_final_approved 정확성.
#         pending → false, approved → true.
# ============================================================================
RD="$TMPROOT/case_d"
mk_fixture_v04 "$RD"
mk_dev_history "$RD"
mk_plan_final_pending "$RD"

set +e
( JONEFLOW_ROOT="$RD"; export JONEFLOW_ROOT
  # shellcheck disable=SC1090
  . "$AI_STEP"
  if _ai_step_plan_final_approved; then printf 'PENDING_APPROVED\n'; else printf 'PENDING_NOT_APPROVED\n'; fi
) > "$RD/d1.out" 2>&1
set -e
assert_grep 'D: pending → not approved' '^PENDING_NOT_APPROVED$' "$RD/d1.out"

# 같은 ROOT에서 plan_final.md 변경 → approved.
mk_plan_final_approved "$RD"
set +e
( JONEFLOW_ROOT="$RD"; export JONEFLOW_ROOT
  # shellcheck disable=SC1090
  . "$AI_STEP"
  if _ai_step_plan_final_approved; then printf 'APPROVED_TRUE\n'; else printf 'APPROVED_FALSE\n'; fi
) > "$RD/d2.out" 2>&1
set -e
assert_grep 'D: approved → true (게이트 통과)' '^APPROVED_TRUE$' "$RD/d2.out"

# ============================================================================
# Case E: --auto end-to-end — stage1 completed 마커 + plan_draft/review/final
#         fixture를 갖춘 ROOT에서 --auto 호출 → stage2/3/4 started + stage5 paused.
# ============================================================================
RE="$TMPROOT/case_e"
mk_fixture_v04 "$RE"
mkdir -p "$RE/docs/notes" "$RE/docs/02_planning_v0.6"
cat > "$RE/docs/notes/dev_history.md" <<'EOF'
# Dev History

### 2026-04-25 09:00 — stage1 (executor=claude) completed
EOF
cat > "$RE/docs/02_planning_v0.6/plan_draft.md" <<'EOF'
# plan_draft v0.6
status: draft
EOF
cat > "$RE/docs/02_planning_v0.6/plan_review.md" <<'EOF'
# plan_review v0.6
status: reviewed
EOF
mk_plan_final_pending "$RE"

rc=$(run_ai_step "$RE" --auto)
assert_eq 'E: --auto exit 0 (paused at stage 4.5)' '0' "$rc"
assert_grep 'E: stage2 진행 안내'   'stage2 — Claude 본인 실행' "$RE/out"
assert_grep 'E: stage3 진행 안내'   'stage3 — Claude 본인 실행' "$RE/out"
assert_grep 'E: stage4 진행 안내'   'stage4 — Claude 본인 실행' "$RE/out"
assert_grep 'E: Stage 4.5 paused 메시지' 'Stage 4.5 승인 게이트' "$RE/out"
assert_grep 'E: dev_history stage2 started 라인' 'stage2 started' "$RE/docs/notes/dev_history.md"
assert_grep 'E: dev_history stage3 started 라인' 'stage3 started' "$RE/docs/notes/dev_history.md"
assert_grep 'E: dev_history stage4 started 라인' 'stage4 started' "$RE/docs/notes/dev_history.md"
assert_grep 'E: dev_history stage5 paused 라인'  'stage5 paused'  "$RE/docs/notes/dev_history.md"

# ============================================================================
# Case F: --resume — Case E ROOT에서 plan_final.md status approved 변경 후
#         --resume 호출 → 게이트 통과(plan_final approved=true 분기 진입).
# ============================================================================
mk_plan_final_approved "$RE"
rc=$(run_ai_step "$RE" --resume)
assert_eq 'F: --resume exit 0 (게이트 통과)' '0' "$rc"
# 게이트 통과 후 stage5 진입 안내 또는 paused 메시지가 사라졌는지 검증.
# 단순 검증: 출력에 "Stage 4.5 승인 게이트" 라인이 없어야 함.
if grep -q 'Stage 4.5 승인 게이트' "$RE/out"; then
    printf '  FAIL F: --resume 후에도 Stage 4.5 게이트 메시지 잔존\n'
    failures=$((failures + 1))
else
    printf '  PASS F: --resume 후 게이트 메시지 사라짐\n'
fi

if [ "$failures" -eq 0 ]; then
    printf 'test_ai_step_auto: PASS\n'
    exit 0
else
    printf 'test_ai_step_auto: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
