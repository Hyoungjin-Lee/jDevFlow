#!/usr/bin/env bash
# zsh_aliases.sh — Shell aliases for the AI workflow
#
# Add this line to your ~/.zshrc or ~/.bashrc:
#   source ~/projects/my-project/scripts/zsh_aliases.sh
#
# Then reload: source ~/.zshrc

_AI_PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

alias aiinit="bash $_AI_PROJECT_ROOT/scripts/init_project.sh"
alias aisec="bash $_AI_PROJECT_ROOT/scripts/setup_security.sh"
alias aigit='bash $_AI_PROJECT_ROOT/scripts/git_checkpoint.sh'
alias aihist='bash $_AI_PROJECT_ROOT/scripts/append_history.sh'

# Stage runners
alias aib="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh brainstorm"
alias aipd="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh planning_draft"
alias aipr="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh planning_review"
alias aipf="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh planning_final"
alias aitd="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh technical_design"
alias aiui="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh ui_requirements"
alias aiflow="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh ui_flow"
alias aiimpl="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh implementation"
alias aireview="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh code_review"
alias airevise="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh revise"
alias aifinal="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh final_review"
alias aiqa="bash $_AI_PROJECT_ROOT/scripts/ai_step.sh qa"

echo "✅ AI workflow aliases loaded. (project: $_AI_PROJECT_ROOT)"
