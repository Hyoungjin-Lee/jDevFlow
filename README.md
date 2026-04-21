# 🤖 jDevFlow

> A universal AI-driven development workflow template — part of the [Jonelab_Platform](https://github.com/aigeenya/Jonelab_Platform).
> Structured 13-stage workflow · Secure secrets management · Git automation · Bilingual (EN/KO)

**한국어 README:** [README.ko.md](./README.ko.md)

---

## What is this?

**jDevFlow** is the app/software development workflow template in the [Jonelab_Platform](https://github.com/aigeenya/Jonelab_Platform) family. Other flows (jDocsFlow, jCutFlow, …) are planned for different domains.

This template gives you a production-ready project structure for working with Claude (and Codex) across the full software development lifecycle — from brainstorming to deployment.

It is designed so that **non-developers can also use it** with Claude's guidance.

### Key features

- **13-stage AI workflow** with clearly defined roles for Claude (planning, design, review, QA) and Codex (implementation, revision)
- **4 AI agents** — Planner, Designer, Reviewer, QA Engineer — each using the right model and effort level
- **Cross-platform secret management** — macOS Keychain and Windows Credential Manager, no credentials ever in code
- **Git automation** — one-command checkpoints with automatic dev history logging
- **Session persistence** — HANDOFF.md keeps every Claude session in sync, even across days or weeks
- **Bilingual** — full English and Korean support

---

## Quick Start

### Requirements

- Python 3.10 or later
- Git
- Claude (Cowork, Claude Code, or Claude API)
- macOS or Windows (Linux supported via environment variables)

### 1. Copy the template

```bash
cp -r jDevFlow/ my-new-project/
cd my-new-project/
```

### 2. Initialize

```bash
bash scripts/init_project.sh
```

### 3. Set up secrets

```bash
bash scripts/setup_security.sh
```

### 4. Initialize git

```bash
git init
git add .
git commit -m "chore: init project from template"
```

### 5. Open Claude and start

Tell Claude:
> "I'm starting a new project. Please read CLAUDE.md and HANDOFF.md first, then ask me what language I'd like to work in."

Claude will guide you from there.

---

## Project Structure

```
your-project/
├── CLAUDE.md               ← Claude operating guide (read first every session)
├── WORKFLOW.md             ← 13-stage development workflow
├── HANDOFF.md              ← Session state & next tasks (read second)
├── README.md               ← This file
│
├── .claude/
│   ├── settings.json       ← Model & effort config (fixed in v0.1)
│   └── language.json       ← Language preference
│
├── security/
│   ├── secret_loader.py    ← Cross-platform secret loading (use this)
│   ├── keychain_manager.py ← macOS Keychain backend
│   └── credential_manager.py ← Windows Credential Manager backend
│
├── scripts/
│   ├── init_project.sh     ← One-time project setup
│   ├── git_checkpoint.sh   ← Git commit + dev history entry
│   ├── ai_step.sh          ← Stage runner (prints prompt for each stage)
│   ├── setup_security.sh   ← Secret setup wizard
│   ├── append_history.sh   ← Manual dev history entry
│   └── zsh_aliases.sh      ← Shell aliases (optional)
│
├── docs/                   ← All stage outputs live here
│   ├── 01_brainstorm/
│   ├── 02_planning/
│   ├── 03_design/
│   ├── 04_implementation/
│   ├── 05_qa_release/
│   └── notes/              ← dev_history.md, decisions.md, final_validation.md
│
├── prompts/
│   ├── claude/             ← Prompt templates for each Claude stage
│   └── codex/              ← Prompt templates for each Codex stage
│
├── src/                    ← Your project source code
├── tests/                  ← Your tests
├── .env.example            ← Secret keys template (no real values)
├── .gitignore
└── LICENSE
```

---

## The 13-Stage Workflow

| Stage | Name | Who | Model |
|-------|------|-----|-------|
| 1 | Brainstorm | Claude + You | Opus |
| 2 | Plan Draft | Claude | Sonnet |
| 3 | Plan Review | Claude | Sonnet |
| 4 | Plan Final | Claude | Sonnet |
| 4.5 | **Your Approval** 🔴 | You | — |
| 5 | Technical Design | Claude | Opus |
| 6 | UI/UX Requirements *(optional)* | Claude | Sonnet |
| 7 | UI Flow *(optional)* | Claude | Sonnet |
| 8 | Implementation | Codex | — |
| 9 | Code Review | Claude | Sonnet |
| 10 | Revision | Codex | — |
| 11 | Final Validation | Claude | Opus |
| 12 | QA & Release | Claude | Sonnet |
| 13 | Deploy & Archive | Codex | — |

See [WORKFLOW.md](./WORKFLOW.md) for the full details.

---

## Secret Management

Secrets (API keys, passwords, tokens) are **never stored in code or `.env` files**.
They live in your OS secure store.

```python
# In your code
from security.secret_loader import load_secret

api_key = load_secret("MY_API_KEY")   # reads from Keychain / Credential Manager
```

```bash
# From the command line
python3 security/secret_loader.py --set MY_API_KEY "your-value"
python3 security/secret_loader.py --get MY_API_KEY
python3 security/secret_loader.py --setup   # interactive wizard
```

---

## Shell Aliases (optional)

```bash
# Add to ~/.zshrc or ~/.bashrc
source ~/projects/my-project/scripts/zsh_aliases.sh
```

Then use:

```bash
aiinit       # initialize project
aib          # Stage 1: brainstorm
aipd         # Stage 2: plan draft
aitd         # Stage 5: technical design
aigit "msg"  # git commit + dev history
```

---

## Roadmap

| Version | Feature |
|---------|---------|
| **v0.1** (current) | Core 13-stage workflow, fixed model/effort, cross-platform secrets, bilingual |
| v0.2 | User-configurable model and effort per stage |
| v0.3 | First-run language selection wizard |
| v1.0 | Full Claude ↔ Codex automation (no manual handoff) |

---

## Contributing

Contributions welcome. Please open an issue first to discuss what you'd like to change.

---

## License

MIT © 형진 (Hyungjin) — see [LICENSE](./LICENSE)
