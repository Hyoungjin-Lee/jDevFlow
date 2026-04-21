#!/usr/bin/env bash
# init_project.sh — Initialize project folders and placeholder files
# Usage: bash scripts/init_project.sh

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "=============================="
echo "  Project Template — Init"
echo "=============================="
echo ""

# Create all required directories
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
  # Keep empty dirs in git
  touch "$ROOT/$d/.gitkeep"
done

# Create starter docs/notes files if not already present
if [ ! -f "$ROOT/docs/notes/dev_history.md" ]; then
  cat > "$ROOT/docs/notes/dev_history.md" << 'EOF'
# Development History

> Append one entry per stage completion. Never delete entries.

---

## Format

```
### Stage X — YYYY-MM-DD
- Completed: [what was done]
- Blockers: [any blockers, or "none"]
- Output: [link to output document]
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

# Copy .env.example to .env if not present
if [ ! -f "$ROOT/.env" ] && [ -f "$ROOT/.env.example" ]; then
  cp "$ROOT/.env.example" "$ROOT/.env"
  echo "✅ Created .env from .env.example (do NOT commit .env)"
fi

echo ""
echo "=============================="
echo "  Init complete!"
echo ""
echo "  Next steps:"
echo "  1. Run security setup:  python3 security/secret_loader.py --setup"
echo "  2. Initialize git:      git init && git add . && git commit -m 'chore: init project'"
echo "  3. Start Stage 1:       bash scripts/ai_step.sh brainstorm"
echo "=============================="
