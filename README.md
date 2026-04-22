# 🤖 jDevFlow

> A universal AI-driven development workflow template — part of the [Jonelab_Platform](https://github.com/aigeenya/Jonelab_Platform).
> Tiered workflow (Lite / Standard / Strict) · Document-centric · Session persistence · Secure secrets · Bilingual (EN/KO)

**한국어 README:** [README.ko.md](./README.ko.md)

---

## What is this?

**jDevFlow** is the app/software development workflow template in the [Jonelab_Platform](https://github.com/aigeenya/Jonelab_Platform) family. Other flows (jDocsFlow, jCutFlow, …) are planned for different domains.

This template gives you a production-ready project structure for working with Claude (and Codex) across the full software development lifecycle — from brainstorming to deployment.

It is designed so that **non-developers can also use it** with Claude's guidance.

### Key features

- **Tiered workflow** — pick **Lite**, **Standard**, or **Strict** per task so workflow weight matches task risk
- **Canonical Strict Flow** of 13 stages that defines the upper bound of governance (the reference flow, not a forced default)
- **Role separation** — Claude for thinking (planning, design, review, QA); Codex for implementation and revision
- **4 Claude agents** — Planner, Designer, Reviewer, QA Engineer — each using the right model and effort
- **Cross-platform secret management** — macOS Keychain and Windows Credential Manager, never plaintext credentials in code
- **Git automation** — one-command checkpoints with automatic dev history logging
- **Session persistence** — `HANDOFF.md` keeps every Claude session in sync, even across days or weeks
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
> "I'm starting a new project. Please read CLAUDE.md and HANDOFF.md first, then ask me what language I'd like to work in and which workflow mode (Lite / Standard / Strict) fits this task."

Claude will guide you from there. See [`docs/notes/session_bootstrap.md`](./docs/notes/session_bootstrap.md) for the canonical session entry sequence.

---

## Project Structure

```
your-project/
├── CLAUDE.md               ← Claude operating guide (read first every session)
├── WORKFLOW.md             ← Tiered workflow model + Canonical Strict Flow (13 stages)
├── HANDOFF.md              ← Session state, current mode, next tasks (read second)
├── README.md               ← This file
│
├── .claude/
│   ├── settings.json       ← Model & effort config
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
│   └── notes/              ← dev_history.md, decisions.md, final_validation.md,
│                            session_bootstrap.md, workflow_eval_plan.md
│
├── prompts/
│   ├── claude/             ← Prompt templates for each Claude stage
│   └── codex/              ← Prompt templates for each Codex stage
│
├── .skills/
│   ├── README.md           ← How to write behavior-shaping skills
│   ├── _templates/         ← Empty skill template to copy
│   └── examples/           ← Worked example skills
│
├── src/                    ← Your project source code
├── tests/                  ← Your tests
├── .env.example            ← Secret KEY NAMES (no values — real secrets go in the OS keychain)
├── .gitignore
└── LICENSE
```

---

## Workflow modes — Lite / Standard / Strict

jDevFlow does **not** force every task through 13 stages. You pick a mode based on the work:

| Mode | Use it for | Typical time |
|------|-----------|--------------|
| **Lite** | Hotfixes, config tweaks, copy changes, docs-only updates | minutes – 2 hr |
| **Standard** | New features, refactors, most day-to-day work | 4 hr – 2 days |
| **Strict** | Architecture, security, data-schema, payment, regulated changes | 2 days – weeks |

The **Strict Flow** is the 13-stage canonical reference:

| Stage | Name | Who | Model |
|-------|------|-----|-------|
| 1 | Brainstorm | Claude + You | Opus |
| 2 | Plan Draft | Claude | Sonnet |
| 3 | Plan Review | Claude | Sonnet |
| 4 | Plan Final | Claude | Sonnet |
| 4.5 | **Your Approval** 🔴 | You | — |
| 5 | Technical Design | Claude | Opus |
| 6 | UI/UX Requirements *(if `has_ui`)* | Claude | Sonnet |
| 7 | UI Flow *(if `has_ui`)* | Claude | Sonnet |
| 8 | Implementation | Codex | — |
| 9 | Code Review | Claude | Sonnet |
| 10 | Revision | Codex | — |
| 11 | Final Validation | Claude | Opus |
| 12 | QA & Release | Claude | Sonnet |
| 13 | Deploy & Archive | Codex | — |

**Lite** keeps only Implementation → (light) Code Review → Archive. **Standard** adds planning, design, and a required approval gate. **Strict** adds stricter conditions and Opus-level final validation at Stage 11.

See [WORKFLOW.md](./WORKFLOW.md) for the full model, including stage types, execution conditions, completion criteria, and re-entry rules.

---

## Secret Management

Real secrets (API keys, passwords, tokens) live in your **OS secure store**, never in code and never in `.env`.

- `.env.example` — committed, holds only the **key names** the project expects
- `.env` — optional local scratch file, never committed, never holds production secrets
- OS keychain (macOS Keychain / Windows Credential Manager) — the real store, accessed via `secret_loader.py`

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
| v0.1 | Core 13-stage workflow, fixed model/effort, cross-platform secrets, bilingual |
| v0.2 | Tiered workflow model (Lite / Standard / Strict), stage types, execution conditions, completion criteria, re-entry rules, strengthened planning/design/review/QA templates, `.skills/` behavior-contract library with starter template and worked example, attribution to `obra/superpowers` |
| **v0.3** (next) | First-run language-selection wizard (interactive), automated workflow-eval runner for `docs/notes/workflow_eval_plan.md`, session-bootstrap hook reference implementation (Claude Code / Cowork), expanded `.skills/examples/` set (API client, report generator, safe-deploy), `HANDOFF.md` auto-writer script, mode-selection decision-tree `.skills` rule, **Stage 6 / 7 (UI) prompt strengthened to v0.2 parity** (Runs-in / completion criteria / re-entry), **`ai_step.sh` + `zsh_aliases.sh` mode-aware CLI** (`aib --lite`, `aipd --standard`, etc.), **`CHANGELOG.md` with v0.1 → v0.2 migration notes and keep-a-changelog discipline**, **`CONTRIBUTING.md` split from README + Contributor Covenant `CODE_OF_CONDUCT.md`**, **Stage 8 implementer picker** (Codex-recommended / Claude-Sonnet / custom — context-dependent recommendation), **Stage 6 / 7 UI-tool picker** (Google Antigravity–recommended / Claude Design / Figma / custom) |
| v1.0 | Full Claude ↔ Codex automation with policy-driven mode selection, template-drift regression evals, one-command release pipeline |

---

## Contributing

Contributions welcome. Please open an issue first to discuss what you'd like to change.

---

## Acknowledgments

jDevFlow was developed independently as part of Jonelab_Platform. Some workflow, skill-system, and agent-operating design directions were informed by ideas explored in [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent and contributors. Where jDevFlow adapts concepts inspired by that work, we acknowledge superpowers as an important reference. See [ATTRIBUTION.md](./ATTRIBUTION.md) for details.

---

## License

MIT © 형진 (Hyungjin) — see [LICENSE](./LICENSE)
