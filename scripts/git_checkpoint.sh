#!/usr/bin/env bash
# git_checkpoint.sh — Git commit + auto dev_history entry
#
# Usage:
#   bash scripts/git_checkpoint.sh "Stage 2 complete: plan draft written"
#
# What it does:
#   1. Stages all changes (git add -A)
#   2. Commits with the provided message
#   3. Appends a timestamped entry to docs/notes/dev_history.md
#   4. Pushes to remote (if configured)

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MESSAGE="${1:-checkpoint}"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M')"
DATE="$(date '+%Y-%m-%d')"

# ── Git commit ─────────────────────────────────────────────
echo "📦 Staging all changes..."
git add -A

echo "💾 Committing: $MESSAGE"
git commit -m "$MESSAGE" || {
  echo "ℹ️  Nothing to commit."
}

# ── dev_history entry ──────────────────────────────────────
HISTORY_FILE="$ROOT/docs/notes/dev_history.md"
if [ -f "$HISTORY_FILE" ]; then
  cat >> "$HISTORY_FILE" << EOF

### $TIMESTAMP
- $MESSAGE
EOF
  echo "📝 Appended to dev_history.md"
fi

# ── Push ───────────────────────────────────────────────────
if git remote get-url origin &>/dev/null; then
  echo "🚀 Pushing to remote..."
  git push || echo "⚠️  Push failed — check your remote configuration."
else
  echo "ℹ️  No remote configured. Skipping push."
fi

echo ""
echo "✅ Checkpoint complete: $MESSAGE"
