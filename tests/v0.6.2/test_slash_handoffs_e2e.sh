#!/bin/sh
# tests/v0.6.2/test_slash_handoffs_e2e.sh
# v0.6.2 F-X-3 회귀 테스트 — slash command + handoffs hook 결합 검증.
# 본 테스트는 dry-run 기반 — 실제 mutation 없음. archive/symlink 손상 차단.
# Stage 9 코드 리뷰 + Stage 12 QA에서 호출.

set -eu

# shellcheck disable=SC1007  # CDPATH= idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$ROOT"

_pass() { printf '  PASS  %s\n' "$1"; }
_fail() { printf '  FAIL  %s\n    -> %s\n' "$1" "$2" >&2; exit 1; }

printf '=== v0.6.2 slash + handoffs E2E (dry-run) ===\n'

# --- T1: .claude/commands/ 3 파일 존재 -----------------------------------
for f in init-project switch-team ai-step; do
    [ -f ".claude/commands/$f.md" ] || _fail "T1: .claude/commands/$f.md 부재" \
                                            "M-Slash 구현 누락"
done
_pass "T1: .claude/commands/ 3 파일 존재"

# --- T2: 각 .md가 셸 스크립트 호출 명시 ----------------------------------
grep -qF "bash scripts/init_project.sh" .claude/commands/init-project.md \
    || _fail "T2: init-project.md → init_project.sh 호출 명시 부재" "내부 매핑 누락"
grep -qF "bash scripts/switch_team.sh" .claude/commands/switch-team.md \
    || _fail "T2: switch-team.md → switch_team.sh 호출 명시 부재" "내부 매핑 누락"
grep -qF "bash scripts/ai_step.sh" .claude/commands/ai-step.md \
    || _fail "T2: ai-step.md → ai_step.sh 호출 명시 부재" "내부 매핑 누락"
_pass "T2: 3 슬래시 → 셸 스크립트 호출 명시"

# --- T3: F-62-1 settings.json 비참조 -------------------------------------
# 주석/주의사항에서의 언급은 허용. 실제 frontmatter 영역에서 참조 없는지 확인.
fm_refs=$(awk '/^---$/{in_fm=!in_fm; next} in_fm && /settings\.json/' .claude/commands/*.md | wc -l | tr -d ' ')
[ "$fm_refs" = "0" ] || _fail "T3 (F-62-1): frontmatter에서 settings.json 참조 발견" \
                              "frontmatter는 정적 텍스트만, settings.json 직접 참조 금지"
_pass "T3 (F-62-1): frontmatter ↔ settings.json 비결합"

# --- T4: AC-Hand-2 readlink ---------------------------------------------
if [ -L HANDOFF.md ]; then
    target=$(readlink HANDOFF.md)
    case "$target" in
        handoffs/active/HANDOFF_v*.md) _pass "T4 (AC-Hand-2): HANDOFF.md → $target" ;;
        *) _fail "T4: HANDOFF.md target 비정상: $target" "옵션 A 정책 위반 또는 손상" ;;
    esac
else
    # archive 직후 부재 상태도 정상 (옵션 A, F-04-S5a)
    _pass "T4 (AC-Hand-2): HANDOFF.md 부재 (archive 직후 정상 상태, EP-1)"
fi

# --- T5: F-X-3 dry-run hook 출력 패턴 -----------------------------------
if [ -f HANDOFF.md ] || [ -L HANDOFF.md ]; then
    # active 상태에서만 dry-run hook 검증 가능
    out=$(DRY_RUN=1 sh -c '
        ROOT="'"$ROOT"'"
        . scripts/lib/settings.sh
        . scripts/ai_step.sh 2>/dev/null || true
        _ai_step_archive_handoff
    ' 2>&1)
    echo "$out" | grep -q "DRY-RUN: would execute: mv .*handoffs/active" \
        || _fail "T5 (F-X-3 / AC-Hand-4): archive hook dry-run 출력 누락" \
                 "_ai_step_archive_handoff 함수 정의 또는 DRY_RUN 분기 점검"
    _pass "T5 (F-X-3 / AC-Hand-4): archive hook dry-run mv 출력 OK"
else
    _pass "T5 (F-X-3): archive 후 부재 상태 — dry-run hook skip"
fi

printf '\n=== v0.6.2 slash + handoffs E2E PASS ===\n'
exit 0
