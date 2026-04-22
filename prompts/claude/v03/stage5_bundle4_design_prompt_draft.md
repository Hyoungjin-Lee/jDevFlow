# Stage 5 — Bundle 4 (Doc Discipline) Technical Design — Kickoff Prompt (DRAFT)

> **Owner:** 🏗️ Designer (Claude, Opus · High effort)
> **Input:** approved `docs/02_planning/plan_final.md` + `plan_final.ko.md`
> **Output:** `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN) + `technical_design.ko.md` (KO)
> **Sequencing:** **run this BEFORE Bundle 1 Stage 5** (per plan_final Sec. 6 DEP.1 tightened by F-o1).
> **DC.5 half #1** — saved before Stage 5 entry, per plan_final Sec. 8-3 AN.1.

---

## Copy-paste this at the start of the Stage 5 Bundle 4 session

```
Start Stage 5 — Bundle 4 (doc-discipline) Technical Design for jOneFlow v0.3.

Read first, in order:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md (especially Sec. 8 Stage 5)
4. docs/02_planning/plan_final.md (Sec. 3-2 D4.a–D4.c, D4.x1–x4; Sec. 6 DEP.1/DEP.2; Sec. 7-2, 7-6, 7-7)
5. prompts/claude/technical_design.md (canonical Stage 5 prompt — structure reference)
6. This draft: prompts/claude/v03/stage5_bundle4_design_prompt_draft.md

Project path: ~/projects/Jonelab_Platform/jOneFlow/
Mode: Strict-hybrid (Bundle 4 runs Standard-equivalent inside).
has_ui: false · risk_level: medium (option β)

Your task: write a complete technical design for Bundle 4 that Codex can
implement from directly. Save it to:
- docs/03_design/bundle4_doc_discipline/technical_design.md  (EN primary)
- docs/03_design/bundle4_doc_discipline/technical_design.ko.md  (KO pair, written at stage close)

Two strong sequencing rules:
- D4.x2, D4.x3, D4.x4 (the three structural-decision paragraphs) MUST be
  written and locked FIRST, before any other Bundle 4 design work and
  before Stage 5 Bundle 1 starts. These decisions propagate into Bundle 1
  D1.b recommendation logic (plan_final Sec. 6 DEP.1).
- Once D4.x2–x4 are locked (one short paragraph each, plus a one-line
  rationale), the rest of Bundle 4 design and all of Bundle 1 design may
  proceed concurrently.
```

---

## What this design must cover

### 1. Structural decisions (D4.x2–x4) — lock FIRST, in this order

Each decision gets one paragraph + one-line rationale. Land them at the top
of `technical_design.md` under a `## 0. Structural decisions (locked)` heading.

- **D4.x2** — Internal doc header schema.
  Lean from plan_final Sec. 7-2 OQ4.1: **YAML frontmatter on Stage 5+ docs only**;
  Stage 1–4 narrative/bilingual docs keep no frontmatter. Confirm or override.
- **D4.x3** — Bundle folder naming convention.
  Lean from Sec. 7-2 OQ4.2: `bundle{id}_{name}/`. Verify it matches
  `docs/03_design/bundle4_doc_discipline/` path already in use.
- **D4.x4** — Doc link conventions (relative-path rules, anchor style,
  cross-bundle linking). Pick one of: always-relative-from-root · always-relative-to-current-file · mixed-by-depth. Include anchor style (`#kebab-case`).

After these three paragraphs, emit a **decision record line** that Bundle 1
designer will cite verbatim: `D4.x2/x3/x4 locked on YYYY-MM-DD — see Sec. 0`.

### 2. Primary deliverables (D4.a–D4.c)

- **D4.a — `scripts/update_handoff.sh`**
  - Language: POSIX `sh` (per plan_final Sec. 5-2 R5).
  - CLI surface: `--dry-run` default; `--write` to persist; `--section=status|recent_changes|both`; `--dev-history` optional flag for dev-history append. Confirm final flag set.
  - Target sections: `## Status` and `## Recent Changes` in HANDOFF.md.
  - Idempotency rule: running twice with identical env produces identical file state.
  - Write against the **template form** (`templates/HANDOFF.template.md`, D4.x1), not the current dogfooding file. Resolves DEP.2.
  - Include `shellcheck` in the design's acceptance criteria.
- **D4.b — `CHANGELOG.md` + maintenance rule**
  - File lives at project root. First entry = v0.3 release itself (plan_final Sec. 5-2 R7).
  - Maintenance rule text goes **only** in `CONTRIBUTING.md` as a single `## Changelog maintenance` section (per plan_final Sec. 3-2 F-a1).
  - Pick format: "Keep a Changelog" vs. custom (closes OQ.N1 from Sec. 7-7).
- **D4.c — `CONTRIBUTING.md` + `CODE_OF_CONDUCT.md`**
  - `CONTRIBUTING.md` is the D4.c-owned file; produce a per-section
    ownership table here (who owns which section, D4.b or D4.c) — this is
    the F-a1 remediation.
  - `CODE_OF_CONDUCT.md`: pick base (Contributor Covenant vs. custom minimal).

### 3. Scope extras (D4.x1 + decisions already locked as x2–x4)

- **D4.x1 — `templates/HANDOFF.template.md`**
  - Clean template with state sections emptied + placeholder text.
  - Documented reset protocol: which sections are state (must be cleared
    on copy) vs. structure (must be preserved).

### 4. Close these Open Questions during design

- **OQ.L2 Stage-9 half (Sec. 7-6)** — Add "KO freshness for stage-closing
  docs" to Bundle 4's code-review checklist (belongs in the design's
  Testing Strategy or Implementation Notes section).
- **OQ.N1** (changelog spec) — pick format (see D4.b above).
- **OQ4.1, OQ4.2** — committed via D4.x2/x3.
- **OQ.H2** — HANDOFF v0.1/v0.2 backward compatibility: document manual
  migration steps to go into `CONTRIBUTING.md`.

### 5. Risk re-checks (from plan_final Sec. 5)

Explicitly acknowledge how the design mitigates:
- **R1** (scope creep) — cap structural decisions to three yes/no-ish choices; no per-decision discussion docs.
- **R5** (shell compat) — POSIX sh target; shellcheck; macOS-only in v0.3.
- **R6** (folder naming vs. `docs/03_design/` prefix) — D4.x3 locks the alignment.

---

## Required output structure

Follow `prompts/claude/technical_design.md` as the canonical shape, **but prepend Sec. 0 "Structural decisions (locked)"** before "Architecture Overview".

Mandatory sections (in order):
0. Structural decisions (locked) — D4.x2/x3/x4.
1. Architecture Overview — block diagram of template vs. dogfooding separation + script + doc files.
2. Components — one per deliverable (D4.a through D4.x1). For each: Responsibility / Interface / Dependencies / File(s).
3. Data Flow — HANDOFF update flow end-to-end (env → parser → section rewriter → file write). Include error branches.
4. Data Models — HANDOFF section schema + CHANGELOG entry schema.
5. API Contracts — `update_handoff.sh` CLI contract (exit codes, stdout/stderr discipline).
6. Error Handling — script failure modes, missing-section fallback, diff preview.
7. Security Considerations — script must never write secrets; input validation on CLI flags.
8. Testing Strategy — include edge cases: empty Recent Changes, malformed bundle YAML, KO-only doc missing EN pair, CRLF line endings.
9. Implementation Notes for Codex — files to create, files to modify, per-section ownership table (F-a1).
10. Out of Scope — reiterate N10, N12 in design terms.
11. Acceptance Criteria (for Stage 9) — concrete checkable items.
12. Codex handoff appendix (per plan_final Sec. 7-5 OQ.C2).

Append KO sync check block (copied from `plan_review.md` Sec. 4-3) at the
top of the document, marked complete only after `technical_design.ko.md`
is written.

---

## Mode & effort

- **Model:** Opus · High effort (Strict-hybrid upper shell requires it; Bundle 4 content complexity is medium).
- **No Codex delegation** for Stage 5 itself. Codex receives the output.

## Pre-flight checks before writing

- [ ] plan_final.md is APPROVED (Stage 4.5 verdict recorded in HANDOFF.md).
- [ ] You've read plan_final Sec. 3-2, Sec. 5-2, Sec. 6, Sec. 7-2, Sec. 7-6, Sec. 7-7.
- [ ] You've read WORKFLOW.md Sec. 8 Stage 5.
- [ ] You know Bundle 1 design is blocked on D4.x2–x4 (DEP.1 tightened).
- [ ] `docs/03_design/bundle4_doc_discipline/` directory exists (create if not).

## After writing

Tell the user:
- "Bundle 4 technical design saved to `docs/03_design/bundle4_doc_discipline/technical_design.md` (+ KO pair). D4.x2/x3/x4 are locked in Sec. 0 — Bundle 1 Stage 5 is unblocked. Ready to start Stage 5 Bundle 1 with `stage5_bundle1_design_prompt_draft.md`."

---

## Revision log for this draft

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 draft (DC.5) | Pre-Stage-5 housekeeping; covers plan_final D4.a–D4.c + D4.x1–x4, OQ.L2 Stage-9 half, OQ.N1, OQ.H2. Sequencing rule: D4.x2–x4 lock first (DEP.1 per F-o1). |
