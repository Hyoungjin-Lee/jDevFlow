# Stage 1 — Brainstorm (Opus · Medium effort)

> Owner: 🧠 Planner | Model: Opus | Output: `docs/01_brainstorm/brainstorm.md`
> Runs in: **Standard** and **Strict**. In **Lite** mode, write a 3–5 line inline note instead of the full template.
> ⚠️ Do NOT write this alone — discuss with the user first.

---

## Your task

Facilitate a structured brainstorming session with the user to explore the problem space.
Ask questions, surface assumptions, and capture raw ideas.

**Stage 1 is also where the workflow mode is chosen.** Before saving this file, you must have agreed with the user on:

- `mode` — Lite / Standard / Strict
- `has_ui` — true / false
- `risk_level` — low / medium / high

If any of these three is not decided, stop and ask the user. Do not guess.

## Mode-selection guide (ask the user out loud)

- **Lite** — hotfix, config tweak, copy/doc change, single-file reversible edit. Skip most of Stages 2–7.
- **Standard** — new feature, refactor, multi-file change. Default for day-to-day work.
- **Strict** — architecture, security, auth, data schema, payment, or anything hard to roll back.
- **Tie-breaker:** if torn between two modes, pick the heavier one.

## Output format

Save results to `docs/01_brainstorm/brainstorm.md` with the following sections:

```markdown
# Brainstorm — [Feature/Project Name]
Date: YYYY-MM-DD
Mode: Lite | Standard | Strict
has_ui: true | false
risk_level: low | medium | high

## Problem Statement
What problem are we solving? Who has this problem?

## Goals
What does success look like?

## Non-Goals
What are we explicitly NOT doing?

## Raw Ideas
- idea 1
- idea 2
- ...

## Constraints & Assumptions
- constraint 1
- assumption 1

## Open Questions
- question 1
- question 2

## Recommended Direction
[1–2 paragraphs: your recommendation and reasoning]

## Mode Rationale
[1–2 sentences: why this mode (Lite/Standard/Strict) is right for this task —
 reference risk, reversibility, UI/security surface, etc.]
```

## Checklist before moving to Stage 2

- [ ] Problem is clearly defined
- [ ] At least one explicit non-goal is written down
- [ ] At least 3 ideas explored
- [ ] Constraints documented
- [ ] Open questions listed
- [ ] **Mode (Lite/Standard/Strict) recorded at the top of the file**
- [ ] **`has_ui` recorded (true/false)**
- [ ] **`risk_level` recorded (low/medium/high)**
- [ ] Mode Rationale section explains why that mode
- [ ] User agrees on recommended direction

## After writing this document

Also update `HANDOFF.md` so the next session sees the same mode:

- `Workflow mode:` → the mode chosen here
- `has_ui:` and `risk_level:` → the values recorded here
- `Current stage:` → "Stage 1 — Brainstorm complete; Stage 2 — Plan Draft pending"

> **Forward reference (do not act on it yet):** when Stage 5 (Technical Design) begins, consult `.skills/tool-picker/SKILL.md` to decide `executor` and `ui_tool`. In **Lite** mode this consultation happens at Stage 8 (Implementation) entry instead. Do NOT call the tool-picker skill here — its inputs (`change_size`, `design_complexity`) only become defined in Stage 5.

Then tell the user one of:

- Lite: "Brainstorm captured as an inline note. Ready to hand off to Codex for Stage 8 (Implementation)?"
- Standard / Strict: "Brainstorm saved. I will run Stage 2 (Plan Draft) next unless you want to edit first."
