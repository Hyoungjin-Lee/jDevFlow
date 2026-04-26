#!/usr/bin/env bash
# run_ac_v063.sh — v0.6.3 자동 AC 21건 일괄 검증 (design_final Sec.4.2)
# Usage: bash tests/v0.6.3/run_ac_v063.sh
# Exit 0: 통과 ≥ 19/21 | Exit 1: 미달

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$ROOT"

pass=0; fail=0; total=21

log() {
  local r=$1 desc=$2
  if [ "$r" -eq 0 ]; then
    pass=$((pass + 1))
    printf '✅ %s\n' "$desc"
  else
    fail=$((fail + 1))
    printf '❌ %s\n' "$desc"
  fi
}

# 검증 명령을 안전하게 실행 — 실패해도 스크립트 계속 진행
chk() {
  local desc=$1; shift
  local r=0
  eval "$@" >/dev/null 2>&1 || r=$?
  log $r "$desc"
}

printf '=== AC v0.6.3 자동 검증 (%s) ===\n\n' "$(date '+%Y-%m-%d %H:%M:%S')"

# ── M1 (5건) ──────────────────────────────────────────────────────────────────
printf '── M1: Monitor 인프라 (5건) ──\n'

chk "M1-1 monitor_bridge.sh 존재 && ≥30줄" \
  '[ -f scripts/monitor_bridge.sh ] && [ "$(wc -l < scripts/monitor_bridge.sh)" -ge 30 ]'

chk "M1-2 📡 status 시그니처 존재" \
  'grep -q "📡 status" scripts/monitor_bridge.sh'

chk "M1-3 capture-pane -S -20 범위 명시" \
  'grep -q "\-S \-20" scripts/monitor_bridge.sh'

chk "M1-4 update_handoff.sh --dry-run windows/fallback 출력" \
  'bash scripts/update_handoff.sh --dry-run 2>&1 | grep -qiE "windows|fallback|copy|sync|DRY-RUN"'

chk "M1-5 timestamp (date +%Y-%m-%d) 존재" \
  'grep -q "date +%Y-%m-%d" scripts/monitor_bridge.sh'

# ── M2 (4건) ──────────────────────────────────────────────────────────────────
printf '\n── M2: 글로벌 ~/.claude 통합 (4건) ──\n'

chk "M2-1 ~/.claude/CLAUDE.md 존재 && ≥60줄" \
  '[ -f ~/.claude/CLAUDE.md ] && [ "$(wc -l < ~/.claude/CLAUDE.md)" -ge 60 ]'

chk "M2-2 CLAUDE.md specificity 원칙 명시 (≥1 hits)" \
  '[ "$(grep -c "specificity\|프로젝트 > 글로벌" CLAUDE.md)" -ge 1 ]'

chk "M2-3 CLAUDE.md 글로벌 포인터 존재" \
  'grep -q "~/.claude/CLAUDE.md" CLAUDE.md'

chk "M2-4 ~/.claude/CLAUDE.md 보편 정책 키워드 ≥3개" \
  '[ "$(grep -cE "보안|언어|톤|CLI 자동화" ~/.claude/CLAUDE.md)" -ge 3 ]'

# ── M3 (5건) ──────────────────────────────────────────────────────────────────
printf '\n── M3: Hooks + ETHOS (5건) ──\n'

chk "M3-1 settings.json hooks.PostToolUse 섹션 존재" \
  '[ "$(grep -c "PostToolUse" .claude/settings.json)" -ge 1 ]'

chk "M3-2 settings.json py_compile hook 명시" \
  'grep -q "py_compile" .claude/settings.json'

chk "M3-3 settings.json shellcheck hook 명시" \
  'grep -q "shellcheck" .claude/settings.json'

chk "M3-4 docs/guides/ethos_checklist.md 존재" \
  '[ -f docs/guides/ethos_checklist.md ]'

chk "M3-5 ethos_checklist.md ETHOS 3종 항목 포함" \
  '[ "$(grep -cE "Boil the Lake|autoplan|investigate" docs/guides/ethos_checklist.md)" -ge 3 ]'

# ── M4 (4건) ──────────────────────────────────────────────────────────────────
printf '\n── M4: 18명 페르소나 + 조건부 (4건) ──\n'

chk "M4-1 personas_18.md ≥150줄" \
  '[ "$(wc -l < docs/02_planning_v0.6.3/personas_18.md)" -ge 150 ]'

chk "M4-2 settings.json stage9_review=codex 확인" \
  'grep "stage9_review" .claude/settings.json | grep -q "codex"'

chk "M4-3 personas_18.md Codex 정의 ≥10줄 (R-1 정정)" \
  '[ "$(grep -A10 "Codex" docs/02_planning_v0.6.3/personas_18.md | wc -l)" -ge 10 ]'

chk "M4-4 operating_manual.md 조직도 명시" \
  'grep -q "조직도" docs/operating_manual.md'

# ── M5 (3건) ──────────────────────────────────────────────────────────────────
printf '\n── M5: Codex 조건부 (3건) ──\n'

chk "M5-1 ai_step.sh stage9_review 분기 로직 존재" \
  'grep -qE "stage9_reviewer|stage9_review" scripts/ai_step.sh'

chk "M5-2 ai_step.sh codex CLI 환경 감지 존재" \
  'grep -q "command -v codex" scripts/ai_step.sh'

chk "M5-3 ai_step.sh Stage 9 명시 ≥1건" \
  '[ "$(grep -c "Stage 9" scripts/ai_step.sh)" -ge 1 ]'

# ── 결과 ──────────────────────────────────────────────────────────────────────
pct=$(( pass * 100 / total ))
printf '\n=== AC v0.6.3: %d/%d (%d%%) ===\n' "$pass" "$total" "$pct"

if [ "$pass" -ge 19 ]; then
  printf '✅ Stage 9 진입 게이트 PASS (≥19/21)\n'
  exit 0
else
  printf '❌ Stage 9 진입 게이트 FAIL (<%d/21 — 미달 %d건)\n' 19 "$fail"
  exit 1
fi
