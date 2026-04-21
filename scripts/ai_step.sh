#!/usr/bin/env bash
# ai_step.sh — Stage runner
#
# Prints the prompt for a given stage and logs the step start
# to docs/notes/dev_history.md.
#
# Usage:
#   bash scripts/ai_step.sh <stage_name>
#   bash scripts/ai_step.sh brainstorm
#   bash scripts/ai_step.sh technical_design
#
# Available stage names:
#   brainstorm, planning_draft, planning_review, planning_final,
#   technical_design, ui_requirements, ui_flow,
#   implementation, code_review, revise, final_review, qa

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAGE="${1:-}"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M')"

# Stage → prompt file mapping
declare -A PROMPT_MAP=(
  ["brainstorm"]="prompts/claude/brainstorm.md"
  ["planning_draft"]="prompts/claude/planning_draft.md"
  ["planning_review"]="prompts/claude/planning_review.md"
  ["planning_final"]="prompts/claude/planning_final.md"
  ["technical_design"]="prompts/claude/technical_design.md"
  ["ui_requirements"]="prompts/claude/ui_requirements.md"
  ["ui_flow"]="prompts/claude/ui_flow.md"
  ["implementation"]="prompts/codex/implementation.md"
  ["code_review"]="prompts/claude/code_review.md"
  ["revise"]="prompts/codex/revise.md"
  ["final_review"]="prompts/claude/final_review.md"
  ["qa"]="prompts/claude/qa.md"
)

# Stage → display name
declare -A STAGE_NAME=(
  ["brainstorm"]="Stage 1 — Brainstorm (Opus)"
  ["planning_draft"]="Stage 2 — Plan Draft (Sonnet)"
  ["planning_review"]="Stage 3 — Plan Review (Sonnet)"
  ["planning_final"]="Stage 4 — Plan Final (Sonnet)"
  ["technical_design"]="Stage 5 — Technical Design (Opus)"
  ["ui_requirements"]="Stage 6 — UI Requirements (Sonnet)"
  ["ui_flow"]="Stage 7 — UI Flow (Sonnet)"
  ["implementation"]="Stage 8 — Implementation (Codex)"
  ["code_review"]="Stage 9 — Code Review (Sonnet)"
  ["revise"]="Stage 10 — Revision (Codex)"
  ["final_review"]="Stage 11 — Final Validation (Opus)"
  ["qa"]="Stage 12 — QA & Release (Sonnet)"
)

# Interactive stage picker if no argument
if [ -z "$STAGE" ]; then
  echo "Available stages:"
  for key in "${!STAGE_NAME[@]}"; do
    echo "  $key  →  ${STAGE_NAME[$key]}"
  done | sort
  echo ""
  read -r -p "Enter stage name: " STAGE
fi

PROMPT_FILE="${PROMPT_MAP[$STAGE]:-}"
if [ -z "$PROMPT_FILE" ]; then
  echo "❌ Unknown stage: '$STAGE'"
  echo "   Run without arguments for a list of available stages."
  exit 1
fi

FULL_PATH="$ROOT/$PROMPT_FILE"
DISPLAY="${STAGE_NAME[$STAGE]}"

echo ""
echo "══════════════════════════════════════"
echo "  $DISPLAY"
echo "══════════════════════════════════════"
echo ""

if [ -f "$FULL_PATH" ]; then
  cat "$FULL_PATH"
else
  echo "⚠️  Prompt file not found: $PROMPT_FILE"
  echo "   Create it or copy from prompts/ templates."
fi

echo ""
echo "══════════════════════════════════════"

# Log to dev_history
HISTORY="$ROOT/docs/notes/dev_history.md"
if [ -f "$HISTORY" ]; then
  echo "" >> "$HISTORY"
  echo "### $TIMESTAMP — $DISPLAY started" >> "$HISTORY"
fi
