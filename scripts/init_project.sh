#!/usr/bin/env bash
# init_project.sh — Initialize project folders and placeholder files
# Usage:
#   bash scripts/init_project.sh           # default: do NOT copy .env.example to .env
#   bash scripts/init_project.sh --with-env   # also create a local .env scratch file
#
# Philosophy:
#   - Real secrets live in the OS keychain, loaded via security/secret_loader.py.
#   - .env.example is a committed list of expected secret KEYS (no values).
#   - .env is an optional local scratch file for development shortcuts. Never commit.
#   - This script never puts real secrets anywhere. It only prepares folder structure.

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

WITH_ENV=0
for arg in "$@"; do
  case "$arg" in
    --with-env) WITH_ENV=1 ;;
  esac
done

echo "=============================="
echo "  jDevFlow — Init"
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
# Rationale: real secrets live in the OS keychain (see security/secret_loader.py).
# .env is just a local scratch file; creating it by default encourages bad habits.
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

echo ""
echo "=============================="
echo "  Init complete!"
echo ""
echo "  Next steps:"
echo "  1. Store any real secrets:    python3 security/secret_loader.py --setup"
echo "  2. Initialize git:            git init && git add . && git commit -m 'chore: init project'"
echo "  3. Start Stage 1 (brainstorm) with Claude, and choose a mode (Lite / Standard / Strict)."
echo "=============================="
