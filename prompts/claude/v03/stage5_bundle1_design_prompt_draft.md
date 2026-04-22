# Stage 5 — Bundle 1 (Tool Picker) Technical Design — Kickoff Prompt (DRAFT)

> **Owner:** 🏗️ Designer (Claude, Opus · High effort)
> **Input:** approved `docs/02_planning/plan_final.md` + `plan_final.ko.md`, AND locked Bundle 4 Sec. 0 structural decisions (D4.x2/x3/x4).
> **Output:** `docs/03_design/bundle1_tool_picker/technical_design.md` (EN) + `technical_design.ko.md` (KO)
> **Sequencing:** **run this AFTER Bundle 4 Sec. 0 is locked** (plan_final Sec. 6 DEP.1).
> **DC.5 half #2** — saved before Stage 5 entry, per plan_final Sec. 8-3 AN.1.

---

## Copy-paste this at the start of the Stage 5 Bundle 1 session

```
Start Stage 5 — Bundle 1 (tool-picker) Technical Design for jDevFlow v0.3.

Read first, in order:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md (especially Sec. 8 Stage 5)
4. docs/02_planning/plan_final.md (Sec. 3-1 D1.a–D1.c, D1.x; Sec. 5-2 R2; Sec. 7-1)
5. docs/03_design/bundle4_doc_discipline/technical_design.md Sec. 0 — locked
   structural decisions D4.x2/x3/x4 (this session is blocked until that
   file exists with Sec. 0 filled in)
6. prompts/claude/technical_design.md (canonical Stage 5 prompt — structure reference)
7. This draft: prompts/claude/v03/stage5_bundle1_design_prompt_draft.md

Project path: ~/projects/Jonelab_Platform/jDevFlow/
Mode: Strict-hybrid (Bundle 1 runs Standard-equivalent inside).
has_ui: false · risk_level: medium-high

Your task: write a complete technical design for Bundle 1 that Codex can
implement from directly. Save it to:
- docs/03_design/bundle1_tool_picker/technical_design.md  (EN primary)
- docs/03_design/bundle1_tool_picker/technical_design.ko.md  (KO pair, written at stage close)

Hard pre-condition: Bundle 4 Sec. 0 (D4.x2/x3/x4) MUST be locked before
you start. Cite the exact decision text in this design's Sec. 1 (bind
recommendation logic to Bundle 4's doc structure).
```

---

## What this design must cover

### 1. Primary deliverables (D1.a–D1.c)

All three live inside a single `.skills/tool-picker/SKILL.md` file (per plan_final Sec. 7-1 OQ1.1 lean: single file unless rule body exceeds ~300 lines).

- **D1.a — `.skills/tool-picker/SKILL.md`**
  - Anthropic Skills format: YAML frontmatter (`name`, `description`) + instructions body.
  - Description field wording matters for discovery; draft ~2–3 sentences with mandatory triggers (`stage`, `mode`, `risk_level`, explicit "next step").
- **D1.b — Recommendation logic section (inside SKILL.md)**
  - Input surface: `(stage, mode, risk_level)` triple from HANDOFF.md.
  - Output surface: ordered list of recommended tools / docs / checklists, each referencing **Bundle 4 finalized doc structure** (cite D4.x2/x3/x4 verbatim).
  - Decision table: stage × mode × risk_level → recommendation set. At
    minimum cover `Stage 2, 3, 5, 8, 9, 11` × `Standard, Strict` × `medium, medium-high`.
  - **Advisory-only rule** (plan_final Sec. 5-2 R2 + G1.2 + plan_draft D-B): never block, never rewrite user intent. Output is chat-printed, not modal.
- **D1.c — Worked example block (inside SKILL.md)**
  - One fully rendered example: Strict-hybrid, Stage 2 entry. Show
    triggering context → skill fires → recommendation list printed → user
    acknowledgment. Minimum 15 lines.

### 2. Scope extras (D1.x)

- **D1.x — Invocation reference**
  - One short section or a separate `docs/notes/tool_picker_usage.md`
    (designer's choice, record rationale).
  - Documents how the skill is expected to be invoked: Claude Code native
    skill mechanism + read-from-CLAUDE.md reference (plan_final Sec. 7-1
    OQ1.3 lean: pure Markdown referenced from CLAUDE.md read-order; no
    native registration — N14).
  - Explicitly NOT a discovery UX (that's N5, deferred).

### 3. Close these Open Questions during design

- **OQ1.1** — single file vs. split (confirm single).
- **OQ1.2** — trigger: stage-entry auto vs. user-request on-demand.
  Lean: both; stage-entry output is advisory, printed in chat, not modal.
  Formalize the trigger surface in design.
- **OQ1.3** — native Skill tool binding. Lean: no (per N14). Confirm and
  explain the read-from-CLAUDE.md mechanism.

### 4. Risk re-checks (from plan_final Sec. 5)

Explicitly acknowledge how the design mitigates:
- **R2** (drift into N5 territory) — declare the skill's surface as
  **read-only Markdown consumed by Claude's existing skill mechanism**.
  No shell commands, no interactive CLIs. Add this as an acceptance
  criterion for Stage 9 review.
- **R3** (Stage 11 context exhaustion) — Bundle 1 design must reference
  DC.6's context-delivery format so Stage 11 can summarize Bundle 1 in
  one page.

### 5. Cite Bundle 4 locked decisions

In Sec. 1 (Architecture Overview) of this design, quote D4.x2/x3/x4
verbatim from `docs/03_design/bundle4_doc_discipline/technical_design.md
Sec. 0`. Recommendation logic MUST parse files according to D4.x2 (header
schema) and reference paths per D4.x4 (link conventions).

---

## Required output structure

Follow `prompts/claude/technical_design.md` as the canonical shape.

Mandatory sections (in order):
1. Architecture Overview — where SKILL.md lives, how it's discovered, what Bundle 4 structures it parses (cite D4.x2/x3/x4).
2. Components — SKILL.md frontmatter / recommendation-logic section / worked-example section / invocation reference (D1.x).
3. Data Flow — HANDOFF.md read → `(stage, mode, risk_level)` extraction → decision-table lookup → advisory output printed to chat. Include error branches (missing HANDOFF fields, malformed frontmatter).
4. Data Models — decision-table schema; recommendation-list output shape.
5. API Contracts — none (pure Markdown); state "N/A, reason: Markdown skill consumed natively by Claude Code".
6. Error Handling — missing-metadata fallback (default to "no recommendation, ask user"); malformed recommendation set → safe default.
7. Security Considerations — skill must never expose secrets; never execute user-supplied paths; state "N/A for network/auth, reason: read-only Markdown".
8. Testing Strategy — unit-like checks as Markdown lint: frontmatter valid YAML, all decision-table rows have recommendations, worked example compiles against current HANDOFF.md, R2 read-only invariant verified.
9. Implementation Notes for Codex — files to create (`.skills/tool-picker/SKILL.md` + optional `docs/notes/tool_picker_usage.md`), constraints (no shell, no CLI, no native Skill API).
10. Out of Scope — N5 (discovery UX), N9 (version mgmt), N14 (native reg).
11. Acceptance Criteria (for Stage 9) — concrete items including the R2 read-only invariant check.
12. Codex handoff appendix (plan_final Sec. 7-5 OQ.C1 + OQ.C2 leans: Codex generates initial SKILL.md, Claude polishes).

Append KO sync check block (copied from `plan_review.md` Sec. 4-3) at the
top of the document, marked complete only after `technical_design.ko.md`
is written.

---

## Mode & effort

- **Model:** Opus · High effort.
- **No Codex delegation** for Stage 5 itself.

## Pre-flight checks before writing

- [ ] plan_final.md is APPROVED (Stage 4.5 verdict recorded in HANDOFF.md).
- [ ] `docs/03_design/bundle4_doc_discipline/technical_design.md` EXISTS and Sec. 0 shows D4.x2/x3/x4 as **locked**. If not, STOP — this design is blocked per DEP.1.
- [ ] You've read plan_final Sec. 3-1, Sec. 5-2 R2, Sec. 7-1, Sec. 7-5.
- [ ] You've read WORKFLOW.md Sec. 8 Stage 5.
- [ ] You understand `has_ui=false` — no Stage 6/7 follows.
- [ ] `docs/03_design/bundle1_tool_picker/` directory exists (create if not).

## After writing

Tell the user:
- "Bundle 1 technical design saved to `docs/03_design/bundle1_tool_picker/technical_design.md` (+ KO pair). Both Stage 5 designs complete. Codex can start Stage 8 from either design; sequencing is Codex's choice subject to Bundle 4 D4.x2/x3/x4 already being locked in design."

---

## Revision log for this draft

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 draft (DC.5) | Pre-Stage-5 housekeeping; covers plan_final D1.a–D1.c + D1.x, OQ1.1/1.2/1.3, R2/R3 mitigations. Hard DEP.1 gate: Bundle 4 Sec. 0 must be locked first. |
