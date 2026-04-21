#!/usr/bin/env bash
# append_history.sh — Manually append an entry to dev_history.md
#
# Usage:
#   bash scripts/append_history.sh "Stage 9 in progress: found 3 issues in code review"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M')"
MESSAGE="${1:-manual entry}"
HISTORY="$ROOT/docs/notes/dev_history.md"

if [ ! -f "$HISTORY" ]; then
  echo "❌ dev_history.md not found. Run init_project.sh first."
  exit 1
fi

cat >> "$HISTORY" << EOF

### $TIMESTAMP
- $MESSAGE
EOF

echo "📝 Appended to dev_history.md: $MESSAGE"
