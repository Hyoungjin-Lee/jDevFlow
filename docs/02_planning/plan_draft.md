# 📐 Stage 2 — Plan Draft (jOneFlow v0.3)

> **Date:** 2026-04-22 (session 2)
> **Language:** EN primary (Korean translation: `plan_draft.ko.md` — paired file)
> **Mode:** Strict-hybrid (upper Strict + inner bundle Standard)
> **Upstream:** `docs/01_brainstorm/brainstorm.md` (incl. 2026-04-22 Addendum)
> **Downstream:** `plan_review.md` (Stage 3) → `plan_final.md` (Stage 4) → Stage 4.5 user-approval gate

---

## 0. How to read this document

- Bundle 1 (tool-picker) and Bundle 4 (doc-discipline) are **planned together in one file**. They share a validation group (Group 1) and must satisfy the same Stage 4 approval gate jointly.
- The **Deliverables** section keeps `kickoff goals` and `scope_extras` (from brainstorm Addendum) as **two distinct lists** for machine-readability and future re-mapping. Do not fold them into a single checklist.
- The **Milestones** section uses a `bundle × stage` matrix so that the shared Stage 11 validation is visually apparent.
- The **Approval checklist** at the bottom is a **draft** — it is intentionally populated now, will be re-reviewed in Stage 3, and signed off in Stage 4.

---

## 1. Goals

### 1-1. North Star (carried from brainstorm Sec. 1-4)

> **A Jonelab teammate can start a new backend project with jOneFlow v0.3 on their own within 30 minutes.**

"Start" = template clone → edit `CLAUDE.md` / `HANDOFF.md` → security setup → first commit → entry into Stage 1 Brainstorm.

### 1-2. Bundle-level goals

**Bundle 1 — Tool-picker system** (`risk_level: medium-high`, kickoff goals 7, 11, 12)

- **G1.1** — Ship a `tool-picker` skill that recommends next-step tools/docs/checklists based on the session's `stage`, `mode`, and `risk_level` metadata.
- **G1.2** — Recommendation surface is **advisory only** (D-B from brainstorm Sec. 7). The skill never blocks or rewrites user intent.
- **G1.3** — Recommendations reference Bundle 4's finalized doc structure (names, headers, link conventions) so the recommender has a stable parsing target.

**Bundle 4 — Doc discipline** (`risk_level: medium`, kickoff goals 5, 9, 10 + brainstorm Sec. 9-2 internal structure, under option β)

- **G4.1** — Separate clean **template** files from the live v0.3 dogfooding state (fold in the long-deferred `template_vs_dogfooding_separation`).
- **G4.2** — Introduce a minimum viable **external doc lifecycle** surface: `HANDOFF.md` auto-writer script, `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`.
- **G4.3** — Lock down the **internal doc structure**: header schema, bundle folder naming, link conventions, so Bundle 1's skill has a predictable surface to parse.

### 1-3. Joint goals (cross-bundle)

- **GJ.1** — Bundles 1 and 4 pass a **single Stage 11 joint validation** (validation_group = 1) in a fresh Claude session.
- **GJ.2** — Stage 4.5 user approval is **granted or refused for both bundles together** (there is no "approve Bundle 1, defer Bundle 4" path in v0.3 — they ship as a unit).

---

## 2. Non-goals

Carry-over from brainstorm Sec. 2 (N1–N11). Re-stated here so Stage 2–5 has it locally:

| # | Non-goal | Bundle affected |
|---|----------|------------------|
| N1 | Full UI workflow | — (policy) |
| N2 | Auto-migrate v0.1 project | — |
| N3 | Redesign the 13-stage flow | — |
| N4 | Support non-Codex implementation agents | — |
| N5 | Skill discovery automation (e.g. `/skills list` UX) | Bundle 1 |
| N6 | Full multi-language support | — |
| N7 | CI/CD templates | — (deferred to v0.4+) |
| N8 | Non-Python runtime support | — |
| N9 | Skill version management system | Bundle 1 |
| N10 | Retroactive EN back-translation of existing KO docs | Bundle 4 |
| N11 | Complex validation group handling (Group 2+ auto-detection) | — |

### v0.3-specific non-goals (added in Stage 2)

- **N12** — No live **link-check automation** in v0.3. Bundle 4 defines the convention; enforcement tooling is deferred to v0.4.
- **N13** — No automatic **metadata-driven stage skipping**. Metadata (`has_ui`, `risk_level`) is *recorded*; Claude still reads it manually, consistent with current Strict-hybrid practice.
- **N14** — No **skill-to-Claude-Code native registration** changes. Bundle 1 skill lives as Markdown referenced by the CLAUDE.md read-order; no modifications to `.claude/settings.json` schema in v0.3.

---

## 3. Deliverables

> **Convention:** kickoff goals and scope_extras are tracked as **separate lists**. This preserves traceability to `prompts/claude/v03_kickoff.md` and keeps Stage 5 design able to re-map if a goal splits.

### 3-1. Bundle 1 — Tool-picker

**From kickoff goals (primary):**

- **D1.a** (goal 7) — `.skills/tool-picker/SKILL.md` — the skill file itself, written to the Anthropic SKILL.md format (YAML frontmatter + description + instructions).
- **D1.b** (goal 11) — Recommendation logic section inside SKILL.md covering `(stage, mode, risk_level) → recommended action list`.
- **D1.c** (goal 12) — Worked example block inside SKILL.md showing the skill firing at a Stage 2 entry for Strict-hybrid mode.

**Scope extras (from Bundle 4 dependency resolution):**

- **D1.x** — A short reference file or README pointer that documents how the skill is expected to be invoked (not full discovery automation — per N5 that's deferred).

### 3-2. Bundle 4 — Doc discipline

**From kickoff goals (primary):**

- **D4.a** (goal 5) — `scripts/update_handoff.sh` — an idempotent script that updates the `## Status` and `## Recent Changes` sections of `HANDOFF.md` from CLI flags.
- **D4.b** (goal 9) — `CHANGELOG.md` at project root + a lightweight maintenance rule documented in `CONTRIBUTING.md`.
- **D4.c** (goal 10) — `CONTRIBUTING.md` + `CODE_OF_CONDUCT.md` split from any existing catch-all doc.

**Scope extras (option β, from brainstorm Sec. 9-2 + Addendum):**

- **D4.x1** — `templates/HANDOFF.template.md` — the clean template form of `HANDOFF.md` (fulfilling the deferred `template_vs_dogfooding_separation`).
- **D4.x2** — Internal doc header schema decision (YAML frontmatter vs. comment-header vs. none) documented in `docs/notes/decisions.md`.
- **D4.x3** — Bundle folder naming convention chosen among `bundle1_tool_picker/` | `tool-picker/` | `01_tool_picker/`, documented same place.
- **D4.x4** — Doc link conventions (relative-path rules, anchor style, cross-bundle linking) documented same place.

### 3-3. Cross-bundle deliverables

- **DC.1** — Updated `HANDOFF.md` reflecting v0.3 release state (status, bundles, recent changes, next-session prompt).
- **DC.2** — Updated `docs/notes/dev_history.md` with entries for every stage run in v0.3.
- **DC.3** — `docs/notes/final_validation.md` — Stage 11 joint validation record for validation group 1.
- **DC.4** — `docs/05_qa_release/qa_scenarios.md` + `release_checklist.md` — Stage 12 outputs.
- **DC.5** — `prompts/claude/v03/stage5_bundle1_design_prompt_draft.md` and `.../stage5_bundle4_design_prompt_draft.md` — Stage 5 kickoff prompt drafts (saved *before* Stage 5 entry).

---

## 4. Milestones (bundle × stage matrix)

Rows = stages in canonical Strict order. Columns = bundles. ✅ = complete, 🔄 = in progress this session, ⬜ = planned.

| Stage | Bundle 1 (tool-picker) | Bundle 4 (doc-discipline) | Joint |
|-------|------------------------|---------------------------|-------|
| 1 Brainstorm | ✅ (2026-04-22) | ✅ (2026-04-22) | ✅ single brainstorm.md |
| 2 Plan Draft | 🔄 (this file) | 🔄 (this file) | 🔄 joint plan_draft.md |
| 3 Plan Review | ⬜ | ⬜ | ⬜ joint plan_review.md |
| 4 Plan Final | ⬜ | ⬜ | ⬜ joint plan_final.md |
| 4.5 Approval gate | ⬜ | ⬜ | ⬜ **single user decision for both** |
| 5 Technical Design | ⬜ per-bundle `bundle1_tool_picker/technical_design.md` | ⬜ per-bundle `bundle4_doc_discipline/technical_design.md` | — |
| 6 UI Requirements | n/a (has_ui=false) | n/a | n/a |
| 7 UI Flow | n/a | n/a | n/a |
| 8 Implementation | ⬜ Codex | ⬜ Codex | — |
| 9 Code Review | ⬜ Claude (Sonnet) | ⬜ Claude (Sonnet) | — |
| 10 Revision | ⬜ if NEEDS REVISION | ⬜ if NEEDS REVISION | — |
| 11 Final Validation | ⬜ | ⬜ | ⬜ **joint session, validation_group=1** |
| 12 QA & Release | ⬜ | ⬜ | ⬜ joint qa_scenarios.md |
| 13 Deploy & Archive | ⬜ | ⬜ | ⬜ joint tag `v0.3` |

### Notable milestone rules

- **M.1** — Stage 4.5 is a single approval for both bundles (GJ.2). Partial approval is not a valid state in v0.3.
- **M.2** — Stage 5 splits into per-bundle design files. Before entering Stage 5, save the **design prompt drafts** to `prompts/claude/v03/` (DC.5). This is the "pre-Stage-5 housekeeping" noted in HANDOFF.md.
- **M.3** — Stage 11 is **one joint fresh session**, not two parallel ones. It receives both bundles' code + design docs as input.
- **M.4** — Each Stage 9 verdict (`minor` / `bug_fix` / `design_level`) is recorded in HANDOFF.md `bundles[i].verdict`. Only `design_level` forces Stage 4.5 re-approval (per brainstorm Sec. 5 Rule 5 + D-D).

---

## 5. Risks & mitigations

### 5-1. Top 3 risks (docs/operating_manual.md Sec.2 requires top-3 with mitigation each)

| # | Risk | Likelihood | Impact | Mitigation | Owner |
|---|------|-----------|--------|------------|-------|
| R1 | Bundle 4 option-β scope creep — internal structure decisions (D4.x2–x4) balloon into a second mini-project inside Bundle 4 | medium | high | Cap internal decisions to **three yes/no-ish choices** (header schema, folder naming, link style). Document rationale in one paragraph each; do **not** open a discussion doc per choice. Enforce at Stage 3 review. | Claude (planner) |
| R2 | Tool-picker skill (Bundle 1) drifts into N5 territory — i.e., starts building discovery UX instead of just a recommendation skill | medium | high | Stage 5 design document for Bundle 1 **must declare the skill's surface as read-only Markdown consumed by Claude's existing skill mechanism**. No shell commands, no interactive CLIs. Re-check at Stage 9. | Claude (designer) + Claude (reviewer) |
| R3 | Stage 11 joint validation drowns — validation group 1 carries ~2× output volume in a fresh session, risking context exhaustion during independent review | medium-high | medium | Pre-compact inputs before Stage 11: only ship `technical_design.md` + delta diffs + a 1-page summary per bundle to the fresh session. Full source code goes only as referenced paths, not pasted. | Claude (QA-orchestrator at Stage 11 entry) |

### 5-2. Secondary risks (noted, mitigated lightly)

| # | Risk | Mitigation |
|---|------|------------|
| R4 | KO translation falls out of sync with EN primary during rapid edits | Rule: KO update happens **at Stage close**, not per-edit. Stage 3 review checks KO freshness. |
| R5 | `scripts/update_handoff.sh` (D4.a) introduces shell-compatibility pain (bash vs. zsh, macOS vs. Linux) | Target POSIX `sh`, run `shellcheck`, test on macOS only in v0.3; Windows/WSL noted as future. |
| R6 | Bundle folder naming choice (D4.x3) conflicts with already-present `docs/03_design/` numerical prefix style | Pre-decide in Stage 5 Bundle 4 design: inside `docs/03_design/`, use `bundle{id}_{name}/` to align both. |
| R7 | `CHANGELOG.md` maintenance rule (D4.b) is written but never followed in v0.3 itself (dogfooding fails) | First CHANGELOG entry is v0.3 release itself; that entry is created as part of Stage 12. |
| R8 | Stage 5 design prompt drafts (DC.5) are written after Stage 5 already started, negating their purpose | Hard pre-condition: entering Stage 5 requires both drafts present in `prompts/claude/v03/`. Check recorded in HANDOFF.md. |

### 5-3. P1–P10 re-check (from brainstorm Sec. 7-1)

Brainstorm Sec. 7-1 flagged ten potential conflicts at Stage 1. None of them became blockers at planning. The Stage 2 view:

- **P1, P6** (UI policy vs. skill behavior) — still handled by `has_ui=false` in v0.3; no action needed.
- **P2, P3, P5, P9** (schema / folder / link / scale concerns) — addressed by Bundle 4 D4.x2–x4 and M.3.
- **P4, P7** (verdict authority, Codex timing) — addressed by M.4 + brainstorm Rule 5.
- **P8, P10** (Stage 11 context transfer, bilingual parsing) — P8 absorbed into R3's mitigation; P10 settled by "skills read YAML headers, not body prose".

Stage 5 technical design will re-check these against concrete API / schema proposals.

---

## 6. Dependencies

### 6-1. Internal (within v0.3)

- **DEP.1** — Bundle 1's SKILL.md depends on Bundle 4's D4.x2–x4 decisions being locked first (or at least before Stage 5 Bundle 1 begins). Sequencing: Bundle 4 Stage 5 *starts* before or simultaneously with Bundle 1 Stage 5, but Bundle 4's structural decisions must finalize first.
- **DEP.2** — `scripts/update_handoff.sh` (D4.a) depends on the final shape of `HANDOFF.md`'s Status/Recent Changes sections, which is itself a Bundle 4 deliverable (D4.x1 template). Resolved by writing `update_handoff.sh` against the *template* form, not the current dogfooding form.
- **DEP.3** — DC.5 (Stage 5 design prompts) depends on both Stage 4.5 approval and the final shape of this plan. Drafts are written **between** Stage 4.5 approval and Stage 5 entry.

### 6-2. External (outside v0.3 / pre-existing)

- **DEP.4** — Anthropic Skills format (YAML frontmatter convention) — treated as stable. If Anthropic changes the format during v0.3 execution, Bundle 1 absorbs the cost.
- **DEP.5** — Existing v0.2-inherited `security/` modules — treated as frozen; no changes in v0.3 scope.
- **DEP.6** — Claude Code's built-in `Skill` tool behavior — Bundle 1 is designed as a Markdown doc *referenced* from CLAUDE.md, not registered via any Claude Code native API, to avoid coupling (N14).

### 6-3. Blocking nothing outside v0.3

- **DEP.7** (noted) — v0.4 Bundles 2 and 3 depend on v0.3 Bundle 1. v0.3 does not need to account for them beyond leaving the skill file's structure extensible.

---

## 7. Open questions

Carry-over from brainstorm Sec. 9-1 through Sec. 9-6 plus new ones surfaced while drafting this plan. These are the inputs Stage 5 will answer; Stage 3 review should confirm none got lost.

### 7-1. Bundle 1 (tool-picker) — from brainstorm Sec. 9-1

- **OQ1.1** — Single `SKILL.md` vs. `SKILL.md + rules/*.md`. *Lean: single file in v0.3; split only if the rule body exceeds ~300 lines.*
- **OQ1.2** — Recommendation trigger: stage-entry auto, user-request on-demand, or both. *Lean: both, but stage-entry is advisory-printed-in-chat, not modal.*
- **OQ1.3** — How to bind to Claude Code's native `Skill` tool. *Lean: pure Markdown referenced from CLAUDE.md read-order; no native registration (N14).*

### 7-2. Bundle 4 (doc-discipline) — from brainstorm Sec. 9-2

- **OQ4.1** — Header metadata schema: YAML frontmatter vs. Markdown comment block vs. none. *Lean: **YAML frontmatter on Stage 5+ docs only**, because Stage 1–4 docs are narrative and bilingual headers hurt readability.*
- **OQ4.2** — Bundle folder naming: `bundle{id}_{name}/` vs. `{name}/` vs. `{nn}_{name}/`. *Lean: `bundle{id}_{name}/` (matches HANDOFF bundles[].id).*
- **OQ4.3** — Link-check automation in-scope or deferred. *Resolved as N12: deferred.*

### 7-3. HANDOFF.md schema upgrade — from brainstorm Sec. 9-3

- **OQ.H1** — `bundles[]` placement: under `## Status` vs. standalone `## Bundles`. *Current HANDOFF.md already has `## Bundles` section — keep.*
- **OQ.H2** — Backward compatibility with v0.1/v0.2 HANDOFF.md. *Lean: no auto-migration (N2). Document manual migration steps in CONTRIBUTING.md.*

### 7-4. Stage 11 independent validation — from brainstorm Sec. 9-4

- **OQ.S11.1** — How the joint validation session receives context. *Lean: a Stage 11 kickoff prompt template, saved to `prompts/claude/` at the same time as DC.5.*
- **OQ.S11.2** — If the two bundles' validations diverge (one APPROVED, one CHANGES REQUESTED), what state goes into HANDOFF. *Lean: group verdict = worst-case (CHANGES REQUESTED wins); Stage 4.5 re-approval rule only fires for `design_level`.*

### 7-5. Codex handoff — from brainstorm Sec. 9-5

- **OQ.C1** — Codex delegation scope for Bundle 1 (a skill .md file). *Lean: Codex generates the initial SKILL.md, Claude polishes. v0.4 may move more toward Claude-authored skills.*
- **OQ.C2** — Stage 5 design → Codex prompt mapping. *Lean: each `technical_design.md` ends with a "Codex handoff" appendix that is copy-paste-ready.*

### 7-6. Language policy execution — from brainstorm Sec. 9-6

- **OQ.L1** — Translation timing: co-write vs. post-approval. *Lean: EN drafted first, KO translated **at Stage close** (consistent with R4 mitigation).*
- **OQ.L2** — Where the "KO missing" check goes. *Lean: into the Stage 3 plan_review.md template and the Stage 9 code-review checklist.*

### 7-7. New open questions raised during Stage 2 drafting

- **OQ.N1** — Should `CHANGELOG.md` (D4.b) follow "Keep a Changelog" spec or use a custom lighter format? *Defer to Stage 5 Bundle 4 design.*
- **OQ.N2** — `scripts/update_handoff.sh` (D4.a): does it mutate files in-place or write to stdout for diff review first? *Lean: dry-run default + `--write` flag, per CLAUDE.md "always test --dry-run before real changes".*
- **OQ.N3** — `.github/` directory (issue templates, PR templates) — in-scope for Bundle 4 or deferred? *Lean: deferred to v0.4 (out of option β scope).*

---

## 8. Approval checklist (for Stage 4 sign-off)

> **Draft** — baked in at Stage 2 per session-1 agreement. Will be re-reviewed in Stage 3 and filled in (✅/❌ + short note) at Stage 4 before presenting to the user for Stage 4.5.

### 8-1. docs/operating_manual.md Sec.2.7 baseline (Stage 4 completion criteria)

- [ ] **AC.1** — In-scope and out-of-scope are clearly separated. (Deliverables Sec. 3 vs. Non-goals Sec. 2.)
- [ ] **AC.2** — Success criteria are measurable, not aspirational. (North star = "30-minute onboarding" is measurable by a timed dry-run. Bundle deliverables are enumerated with IDs.)
- [ ] **AC.3** — Top 3 risks each have a mitigation owner. (Sec. 5-1 R1–R3.)
- [ ] **AC.4** — Timeline is at least coarse-grained. (Sec. 4 milestone matrix; finer times are per-bundle in Stage 5.)

### 8-2. Strict-hybrid additional items (v0.3-specific)

- [ ] **AC.5** — Validation group 1 is acknowledged: both bundles will be signed off as one unit, and Stage 11 will be a single fresh-session joint review.
- [ ] **AC.6** — Bundle 4 option-β scope is explicit: both kickoff goals 5/9/10 **and** brainstorm Sec. 9-2 internal structure items are in scope. The risk bump (low-medium → medium) is accepted.
- [ ] **AC.7** — UI base-only policy for v0.3 is accepted: no UI workflow in v0.3, and the warning trigger for `has_ui=true` in downstream projects is carried over from brainstorm Sec. 6.

### 8-3. Non-blocking notes (not gates, but ask the user to acknowledge)

- **AN.1** — DC.5 (Stage 5 design prompt drafts in `prompts/claude/v03/`) is a **pre-condition for Stage 5 entry**, not a Stage 4 gate. It will be run after Stage 4.5 approval and before Stage 5 kickoff.
- **AN.2** — Open questions Sec. 7 are expected to be answered inside `technical_design.md` during Stage 5, not in this document.

---

## 9. What this plan does NOT decide (deferred to later stages)

To keep the plan_draft honest about its scope (complement to Sec. 2 Non-goals):

- Module-level code structure inside `.skills/tool-picker/` → **Stage 5 Bundle 1 design**.
- `scripts/update_handoff.sh` flag surface → **Stage 5 Bundle 4 design**.
- Codex prompt text verbatim → **Stage 5 design appendices**.
- Stage 11 kickoff prompt text → **pre-Stage-11 housekeeping** (new counterpart to DC.5).
- QA scenarios → **Stage 12**.

---

## 10. Revision log for this document

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 — Stage 2 draft written | Session 2. Bundles 1 + 4 combined. Approval checklist pre-populated. |

---

## 📌 Next Stage

**Stage 3 — Plan Review** (`docs/02_planning/plan_review.md`).

Self-review focus:
1. Does Sec. 3 Deliverables cover all kickoff goals 5/7/9/10/11/12 without double-counting?
2. Are Sec. 5 top-3 risks truly the top-3 (not chosen for writing convenience)?
3. Are Sec. 7 open questions solvable *inside* Stage 5, or do any leak back into Stage 4?
4. Is the KO translation (`plan_draft.ko.md`) in sync at the moment Stage 3 begins?

---
