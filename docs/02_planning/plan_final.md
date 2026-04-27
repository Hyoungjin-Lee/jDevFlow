# ✅ Stage 4 — Plan Final (jOneFlow v0.3)

> **Date:** 2026-04-22 (session 3 → session 4 continuation)
> **Language:** EN primary (Korean translation: `plan_final.ko.md` — paired file)
> **Mode:** Strict-hybrid (upper Strict + inner bundle Standard)
> **Upstream:** `docs/02_planning/plan_draft.md` (v1, session 2) + `plan_review.md` (v1, session 3)
> **Downstream:** Stage 4.5 **user approval gate** (joint Bundle 1 + 4, per M.1)
> **Status:** ready for Stage 4.5 presentation

---

## 0. KO sync check (required at Stage 3 start and Stage 4 start)

Copied from `plan_review.md Sec. 4-3` and checked against `plan_final.ko.md` (this file's paired KO).

- [x] Section-header count parity between EN and KO
- [x] North-star sentence present and equivalent in KO
- [x] Deliverable IDs (D1.a / D4.a / D4.x1 / DC.1–DC.6) identical in both files
- [x] Approval checklist item count identical in both files (AC.1–AC.7)

---

## 0-1. How to read this document

Plan Final supersedes Plan Draft. It **absorbs** the 8 revisions from `plan_review.md Sec. 6`, **fills in** the 7-item Approval checklist with ✅/❌ + one-line notes, and is the **single document presented at Stage 4.5**.

- Bundles 1 and 4 are planned together. They share validation group 1 and **a single Stage 4.5 approval gate** (no partial approval — M.1).
- `kickoff goals` and `scope_extras` (Bundle 4 option β) are tracked as two separate lists in Sec. 3 for traceability.
- Open Questions Sec. 7 shrinks relative to plan_draft: `OQ.S11.2` became committed policy (M.5), `OQ.L2` Stage-3 half resolved, `OQ.N3` folded into N7 as a non-goal sub-bullet.
- For every Stage-3 finding, a `[F-xx]` tag marks where it landed.

---

## 0-2. Summary of changes from plan_draft → plan_final

| Finding | Type | Location | Change |
|---------|------|----------|--------|
| F-a1 | Clarification | Sec. 3-2 D4.b / D4.c | `CONTRIBUTING.md` owned by D4.c; D4.b contributes a single section. |
| F-b2 | New secondary risk | Sec. 5-2 R9 | Joint-approval coupling (M.1 amplifier). |
| F-c1 | New deliverable | Sec. 3-3 DC.6 | `prompts/claude/v03/stage11_joint_validation_prompt.md`. |
| F-c2 | Committed policy | Sec. 4 M.5 | Divergent-verdict policy. OQ.S11.2 removed. |
| F-c3 | OQ partial resolve | Sec. 7-6 OQ.L2 | Stage-3 half resolved (via KO sync block Sec. 0); Stage-9 half retained. |
| F-o1 | Dependency tightening | Sec. 6 DEP.1 | Bundle 4 D4.x2–x4 must lock before Bundle 1 D1.b; rest may proceed concurrently. |
| F-o2 | Release hygiene note | Sec. 4 M.6 | Stage 13 ships one joint `v0.3` git tag. |
| F-o3 | Non-goal cleanup | Sec. 2 N7 + Sec. 7-7 | `.github/` PR/issue templates folded into N7 sub-bullet; OQ.N3 removed. |

---

## 1. Goals

### 1-1. North Star (carried from brainstorm Sec. 1-4, unchanged)

> **A Jonelab teammate can start a new backend project with jOneFlow v0.3 on their own within 30 minutes.**

"Start" = template clone → edit `CLAUDE.md` / `HANDOFF.md` → security setup → first commit → entry into Stage 1 Brainstorm.

### 1-2. Bundle-level goals (unchanged from plan_draft Sec. 1-2)

**Bundle 1 — Tool-picker system** (`risk_level: medium-high`, kickoff goals 7, 11, 12)

- **G1.1** — Ship a `tool-picker` skill that recommends next-step tools/docs/checklists based on the session's `stage`, `mode`, and `risk_level` metadata.
- **G1.2** — Recommendation surface is **advisory only** (D-B from brainstorm Sec. 7). The skill never blocks or rewrites user intent.
- **G1.3** — Recommendations reference Bundle 4's finalized doc structure (names, headers, link conventions) so the recommender has a stable parsing target.

**Bundle 4 — Doc discipline** (`risk_level: medium`, kickoff goals 5, 9, 10 + brainstorm Sec. 9-2 internal structure, option β)

- **G4.1** — Separate clean **template** files from the live v0.3 dogfooding state.
- **G4.2** — Introduce a minimum viable **external doc lifecycle** surface: `HANDOFF.md` auto-writer script, `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`.
- **G4.3** — Lock down the **internal doc structure**: header schema, bundle folder naming, link conventions.

### 1-3. Joint goals

- **GJ.1** — Bundles 1 and 4 pass a **single Stage 11 joint validation** (validation_group = 1) in a fresh Claude session.
- **GJ.2** — Stage 4.5 user approval is **granted or refused for both bundles together** (M.1).

---

## 2. Non-goals

Carry-over from brainstorm Sec. 2 (N1–N11), plus Stage-2 additions (N12–N14). F-o3 folds old OQ.N3 (`.github/`) into N7.

| # | Non-goal | Bundle affected |
|---|----------|------------------|
| N1 | Full UI workflow | — (policy) |
| N2 | Auto-migrate v0.1 project | — |
| N3 | Redesign the 13-stage flow | — |
| N4 | Support non-Codex implementation agents | — |
| N5 | Skill discovery automation (e.g. `/skills list` UX) | Bundle 1 |
| N6 | Full multi-language support | — |
| N7 | CI/CD templates — **including `.github/` PR/issue templates** [F-o3] | — (deferred to v0.4+) |
| N8 | Non-Python runtime support | — |
| N9 | Skill version management system | Bundle 1 |
| N10 | Retroactive EN back-translation of existing KO docs | Bundle 4 |
| N11 | Complex validation group handling (Group 2+ auto-detection) | — |
| N12 | Live link-check automation (convention only in v0.3) | Bundle 4 |
| N13 | Automatic metadata-driven stage skipping | — |
| N14 | Skill-to-Claude-Code native registration changes | Bundle 1 |

---

## 3. Deliverables

> **Convention:** kickoff goals and scope_extras are tracked as **separate lists** for traceability to `prompts/claude/v03_kickoff.md`.

### 3-1. Bundle 1 — Tool-picker

**From kickoff goals (primary):**

- **D1.a** (goal 7) — `.skills/tool-picker/SKILL.md` — YAML frontmatter + description + instructions, per Anthropic Skills format.
- **D1.b** (goal 11) — Recommendation logic section inside SKILL.md covering `(stage, mode, risk_level) → recommended action list`.
- **D1.c** (goal 12) — Worked example block inside SKILL.md showing the skill firing at a Stage 2 entry for Strict-hybrid mode.

**Scope extras:**

- **D1.x** — A short reference/pointer documenting how the skill is expected to be invoked (not discovery automation — N5 deferred).

### 3-2. Bundle 4 — Doc discipline

**From kickoff goals (primary):**

- **D4.a** (goal 5) — `scripts/update_handoff.sh` — idempotent HANDOFF.md `## Status` / `## Recent Changes` updater driven by CLI flags. `--dry-run` default; `--write` to persist [OQ.N2 lean].
- **D4.b** (goal 9) — `CHANGELOG.md` at project root. **The maintenance rule lives as a single section inside `CONTRIBUTING.md` (`## Changelog maintenance`)** [F-a1]. D4.b contributes this section only; file ownership sits with D4.c.
- **D4.c** (goal 10) — `CONTRIBUTING.md` + `CODE_OF_CONDUCT.md`, split from any catch-all doc. **`CONTRIBUTING.md` is the D4.c-owned file; Stage 5 Bundle 4 design publishes a per-section ownership table** [F-a1].

**Scope extras (option β, from brainstorm Sec. 9-2 + Addendum):**

- **D4.x1** — `templates/HANDOFF.template.md` — clean template form of `HANDOFF.md` (resolves the long-deferred `template_vs_dogfooding_separation`).
- **D4.x2** — Internal doc header schema decision (YAML frontmatter vs. comment-header vs. none) → `docs/notes/decisions.md`.
- **D4.x3** — Bundle folder naming convention chosen among `bundle{id}_{name}/` | `{name}/` | `{nn}_{name}/` → same place.
- **D4.x4** — Doc link conventions (relative-path rules, anchor style, cross-bundle linking) → same place.

### 3-3. Cross-bundle deliverables

- **DC.1** — Updated `HANDOFF.md` reflecting v0.3 release state (status, bundles, recent changes, next-session prompt).
- **DC.2** — Updated `docs/notes/dev_history.md` with entries for every stage run in v0.3 (note: file is still to be created — backfill in session 4).
- **DC.3** — `docs/notes/final_validation.md` — Stage 11 joint validation record for validation group 1.
- **DC.4** — `docs/05_qa_release/qa_scenarios.md` + `release_checklist.md` — Stage 12 outputs.
- **DC.5** — `prompts/claude/v03/stage5_bundle1_design_prompt_draft.md` + `.../stage5_bundle4_design_prompt_draft.md` — Stage 5 kickoff prompt drafts (saved *before* Stage 5 entry).
- **DC.6** [F-c1] — `prompts/claude/v03/stage11_joint_validation_prompt.md` — Stage 11 joint-validation fresh-session kickoff prompt. Written during **pre-Stage-11 housekeeping** (new counterpart to DC.5). Ensures OQ.S11.1 (context delivery) has a concrete home.

---

## 4. Milestones (bundle × stage matrix)

Rows = stages in canonical Strict order. Columns = bundles. ✅ = complete, 🔄 = in progress, ⬜ = planned.

| Stage | Bundle 1 (tool-picker) | Bundle 4 (doc-discipline) | Joint |
|-------|------------------------|---------------------------|-------|
| 1 Brainstorm | ✅ (2026-04-22) | ✅ (2026-04-22) | ✅ single brainstorm.md |
| 2 Plan Draft | ✅ (2026-04-22, session 2) | ✅ (2026-04-22, session 2) | ✅ joint plan_draft.md |
| 3 Plan Review | ✅ (2026-04-22, session 3) | ✅ (2026-04-22, session 3) | ✅ joint plan_review.md |
| 4 Plan Final | 🔄 (this file) | 🔄 (this file) | 🔄 joint plan_final.md |
| 4.5 Approval gate | ⬜ | ⬜ | ⬜ **single user decision for both** |
| 5 Technical Design | ⬜ `bundle1_tool_picker/technical_design.md` | ⬜ `bundle4_doc_discipline/technical_design.md` | — |
| 6 UI Requirements | n/a (has_ui=false) | n/a | n/a |
| 7 UI Flow | n/a | n/a | n/a |
| 8 Implementation | ⬜ Codex | ⬜ Codex | — |
| 9 Code Review | ⬜ Claude (Sonnet) | ⬜ Claude (Sonnet) | — |
| 10 Revision | ⬜ if NEEDS REVISION | ⬜ if NEEDS REVISION | — |
| 11 Final Validation | ⬜ | ⬜ | ⬜ **joint fresh session, validation_group=1** |
| 12 QA & Release | ⬜ | ⬜ | ⬜ joint qa_scenarios.md |
| 13 Deploy & Archive | ⬜ | ⬜ | ⬜ **single joint `v0.3` git tag** [F-o2] |

### Notable milestone rules

- **M.1** — Stage 4.5 is a single approval for both bundles (GJ.2). Partial approval is not a valid state in v0.3.
- **M.2** — Stage 5 splits into per-bundle design files. Before entering Stage 5, save the design prompt drafts to `prompts/claude/v03/` (DC.5).
- **M.3** — Stage 11 is **one joint fresh session**, not two parallel ones. It receives both bundles' code + design docs as input via the DC.6 prompt.
- **M.4** — Each Stage 9 verdict (`minor` / `bug_fix` / `design_level`) is recorded in `HANDOFF.md` `bundles[i].verdict`. Only `design_level` forces Stage 4.5 re-approval (per brainstorm Sec. 5 Rule 5 + D-D).
- **M.5** [F-c2, **committed policy — replaces OQ.S11.2**] — **Divergent-verdict policy.** If bundles within one validation group produce divergent Stage 11 verdicts, the group verdict is **the worst of the two** (`CHANGES REQUESTED` beats `APPROVED`). Stage 4.5 re-approval is triggered only when **at least one bundle's verdict is `design_level`**. Re-approval, when triggered, is joint (M.1 continues to apply). Both individual bundle verdicts AND the group verdict are recorded in `HANDOFF.md`.
- **M.6** [F-o2] — Stage 13 releases both bundles under a **single joint `v0.3` git tag**. No per-bundle tags.

---

## 5. Risks & mitigations

### 5-1. Top 3 risks (docs/operating_manual.md Sec.2 baseline requirement)

| # | Risk | Likelihood | Impact | Mitigation | Owner |
|---|------|-----------|--------|------------|-------|
| R1 | Bundle 4 option-β scope creep — internal structure decisions (D4.x2–x4) balloon into a second mini-project inside Bundle 4 | medium | high | Cap internal decisions to **three yes/no-ish choices** (header schema, folder naming, link style). Document rationale in one paragraph each; no separate discussion doc per choice. Enforced at Stage 3 review (PASS ✅) and re-checked at Stage 5 Bundle 4 design entry. | Claude (planner / designer) |
| R2 | Tool-picker skill (Bundle 1) drifts into N5 territory — starts building discovery UX instead of just a recommendation skill | medium | high | Stage 5 Bundle 1 design **must declare the skill's surface as read-only Markdown consumed by Claude's existing skill mechanism**. No shell commands, no interactive CLIs. Re-check at Stage 9. | Claude (designer) + Claude (reviewer) |
| R3 | Stage 11 joint validation drowns — validation group 1 carries ~2× output volume, risking context exhaustion in a fresh session | medium-high | medium | Pre-compact inputs before Stage 11: ship `technical_design.md` + delta diffs + 1-page summary per bundle. Full source goes as referenced paths, not pasted. DC.6 prompt enforces this format. | Claude (QA-orchestrator at Stage 11 entry) |

### 5-2. Secondary risks

| # | Risk | Mitigation |
|---|------|------------|
| R4 | KO translation falls out of sync with EN primary during rapid edits | KO update at Stage close, not per-edit. Stage 3 and Stage 4 KO sync checks (Sec. 0 block) verify. OQ.L2 Stage-9 half adds this to code-review checklist (Bundle 4 tech design). |
| R5 | `scripts/update_handoff.sh` (D4.a) introduces shell-compatibility pain (bash vs. zsh, macOS vs. Linux) | Target POSIX `sh`, run `shellcheck`, macOS-only in v0.3; Windows/WSL noted as future. |
| R6 | Bundle folder naming choice (D4.x3) conflicts with `docs/03_design/` numerical prefix style | Pre-decide in Stage 5 Bundle 4 design: inside `docs/03_design/`, use `bundle{id}_{name}/` to align. |
| R7 | `CHANGELOG.md` maintenance rule (D4.b) is written but never followed in v0.3 itself (dogfooding fails) | First CHANGELOG entry is v0.3 release itself, created at Stage 12. |
| R8 | Stage 5 design prompt drafts (DC.5) are written after Stage 5 already started, negating purpose | Hard pre-condition: entering Stage 5 requires both DC.5 drafts **and** DC.6 present in `prompts/claude/v03/`. Check recorded in HANDOFF.md. |
| R9 [F-b2] | **Joint-approval coupling (M.1 amplifier)** — any bundle-level major issue blocks the other bundle's shipment | If Stage 9 verdict for one bundle is `design_level` AND the other is `minor`, the joint rule still triggers Stage 4.5 re-approval **for both** (M.5 logic). Record the coupled verdict explicitly in `HANDOFF.md bundles[].verdict` fields + the group verdict. Mitigation is process hygiene, not a design change: budget for it in session planning. |

### 5-3. P1–P10 re-check (from brainstorm Sec. 7-1, carry-over from plan_draft Sec. 5-3)

None became blockers at planning. Stage 2 → Stage 3 view holds:

- **P1, P6** (UI policy vs. skill behavior) — `has_ui=false` policy. No action.
- **P2, P3, P5, P9** (schema / folder / link / scale) — addressed by D4.x2–x4 + M.3 + M.5.
- **P4, P7** (verdict authority, Codex timing) — addressed by M.4 + M.5 + brainstorm Rule 5.
- **P8, P10** (Stage 11 context transfer, bilingual parsing) — P8 absorbed into R3's mitigation + DC.6; P10 settled by "skills read YAML headers, not body prose".

Stage 5 technical design will re-check these against concrete API / schema proposals.

---

## 6. Dependencies

### 6-1. Internal (within v0.3)

- **DEP.1** [F-o1, **tightened**] — **Bundle 4 Stage 5 structural decisions (D4.x2–x4) must lock before Bundle 1 Stage 5 writes its recommendation-logic section (D1.b).** Bundle 4 and Bundle 1 tech design may otherwise proceed concurrently. In practice this means the first deliverable of Stage 5 Bundle 4 is the three decisions (short, one-paragraph each), then the rest of Bundle 4 tech design and all of Bundle 1 tech design can run in parallel.
- **DEP.2** — `scripts/update_handoff.sh` (D4.a) depends on the final shape of `HANDOFF.md`'s Status/Recent Changes sections, which is itself a Bundle 4 deliverable (D4.x1 template). Resolved by writing `update_handoff.sh` against the *template* form, not the current dogfooding form.
- **DEP.3** — DC.5 + DC.6 (Stage 5 prompts + Stage 11 joint validation prompt) depend on both Stage 4.5 approval and the final shape of this plan. DC.5 is written between Stage 4.5 approval and Stage 5 entry; DC.6 is written before Stage 11 entry.

### 6-2. External (outside v0.3 / pre-existing)

- **DEP.4** — Anthropic Skills format (YAML frontmatter convention) — stable. If Anthropic changes the format during v0.3 execution, Bundle 1 absorbs the cost.
- **DEP.5** — Existing v0.2-inherited `security/` modules — frozen; no changes in v0.3 scope.
- **DEP.6** — Claude Code's built-in `Skill` tool behavior — Bundle 1 is a Markdown doc *referenced* from CLAUDE.md, not registered via any native API (N14).

### 6-3. Blocking nothing outside v0.3

- **DEP.7** — v0.4 Bundles 2 and 3 depend on v0.3 Bundle 1. v0.3 does not need to account for them beyond leaving the skill file's structure extensible.

---

## 7. Open questions (residual)

Shrunk from plan_draft Sec. 7. Removed/resolved entries: **OQ.S11.2** (→ committed as M.5 per F-c2), **OQ.L2 Stage-3 half** (resolved via Sec. 0 KO sync block per F-c3), **OQ.N3** (folded into N7 per F-o3).

### 7-1. Bundle 1 (tool-picker)

- **OQ1.1** — Single `SKILL.md` vs. `SKILL.md + rules/*.md`. *Lean: single file; split only if rule body exceeds ~300 lines.*
- **OQ1.2** — Recommendation trigger: stage-entry auto, user-request on-demand, or both. *Lean: both; stage-entry advisory-printed-in-chat, not modal.*
- **OQ1.3** — Bind to Claude Code's native `Skill` tool? *Lean: pure Markdown referenced from CLAUDE.md read-order; no native registration (N14).*

### 7-2. Bundle 4 (doc-discipline)

- **OQ4.1** — Header metadata schema: YAML frontmatter vs. Markdown comment vs. none. *Lean: **YAML frontmatter on Stage 5+ docs only**; Stage 1–4 narrative/bilingual docs keep no frontmatter.*
- **OQ4.2** — Bundle folder naming. *Lean: `bundle{id}_{name}/` (matches `HANDOFF bundles[].id`).*

### 7-3. HANDOFF.md schema upgrade

- **OQ.H1** — `bundles[]` placement. *Already resolved in current HANDOFF.md: keep `## Bundles` section.*
- **OQ.H2** — Backward compatibility with v0.1/v0.2 HANDOFF.md. *Lean: no auto-migration (N2); manual migration steps in `CONTRIBUTING.md`.*

### 7-4. Stage 11 independent validation

- **OQ.S11.1** — How the joint validation session receives context. *Lean: the DC.6 prompt template encodes: technical_design.md + delta diffs + 1-page per-bundle summary + referenced paths (no pasted source). Answered by DC.6 itself.*
- ~~OQ.S11.2~~ — **Committed as M.5; see Sec. 4.**

### 7-5. Codex handoff

- **OQ.C1** — Codex delegation scope for Bundle 1. *Lean: Codex generates initial SKILL.md, Claude polishes.*
- **OQ.C2** — Stage 5 design → Codex prompt mapping. *Lean: each `technical_design.md` ends with a "Codex handoff" appendix that is copy-paste-ready.*

### 7-6. Language policy execution

- **OQ.L1** — Translation timing. *Lean: EN drafted first, KO translated at Stage close (R4 rule).*
- **OQ.L2** — "KO missing" check location. *Stage-3 half **resolved** via Sec. 0 KO sync block [F-c3]. Stage-9 half: Bundle 4 tech design adds "KO freshness for stage-closing docs" to the code-review checklist.*

### 7-7. New open questions raised during Stage 2 drafting

- **OQ.N1** — `CHANGELOG.md` spec — "Keep a Changelog" vs. custom. *Defer to Stage 5 Bundle 4 design.*
- **OQ.N2** — `scripts/update_handoff.sh` default mode. *Resolved in Sec. 3-2 D4.a: dry-run default + `--write` flag.*
- ~~OQ.N3~~ — **Folded into N7 (Sec. 2) per F-o3.**

---

## 8. Approval checklist (Stage 4 → Stage 4.5)

### 8-1. docs/operating_manual.md Sec.2.7 baseline (Stage 4 completion criteria)

- [x] **AC.1** — In-scope and out-of-scope are clearly separated. ✅ *Deliverables Sec. 3 (D1.a–D1.c, D1.x, D4.a–D4.c, D4.x1–x4, DC.1–DC.6) vs. Non-goals Sec. 2 (N1–N14); no overlap.*
- [x] **AC.2** — Success criteria are measurable, not aspirational. ✅ *North-star is a timed dry-run (30 minutes); per-deliverable IDs are enumerated; milestones are a bundle × stage matrix.*
- [x] **AC.3** — Top 3 risks each have a mitigation owner. ✅ *R1 (planner/designer), R2 (designer + reviewer), R3 (QA-orchestrator); all have concrete mitigations, not just intent.*
- [x] **AC.4** — Timeline is at least coarse-grained. ✅ *Milestone matrix gives stage-level sequencing; finer per-stage times appear in Stage 5 tech design.*

### 8-2. Strict-hybrid additional items (v0.3-specific)

- [x] **AC.5** — Validation group 1 acknowledged: both bundles signed off as one unit; Stage 11 = single fresh-session joint review. ✅ *Coded as GJ.1, M.3, M.5, and DC.6.*
- [x] **AC.6** — Bundle 4 option-β scope is explicit: both kickoff goals 5/9/10 **and** brainstorm Sec. 9-2 internal structure items in scope; risk bump (low-medium → medium) accepted. ✅ *Sec. 3-2 scope extras D4.x1–x4; risk_level=medium recorded in HANDOFF.md.*
- [x] **AC.7** — UI base-only policy for v0.3 accepted: no UI workflow in v0.3; warning trigger for `has_ui=true` in downstream projects carried from brainstorm Sec. 6. ✅ *`has_ui=false` throughout; N1 + N13 + N14 lock the policy.*

### 8-3. Non-blocking notes (acknowledge, not gates)

- **AN.1** — DC.5 + DC.6 (prompts in `prompts/claude/v03/`) are **pre-conditions for Stage 5 / Stage 11 entry**, not Stage 4 gates. DC.5 runs after Stage 4.5 approval and before Stage 5 kickoff; DC.6 runs before Stage 11.
- **AN.2** — Residual Open Questions (Sec. 7) are expected to be answered inside `technical_design.md` during Stage 5 (except those already marked as resolved / leaned in Sec. 7 text).
- **AN.3** — `docs/notes/dev_history.md` is still to be created (deferred since session 1). Backfill planned for session 4 alongside this Stage 4 work.

**Checklist verdict: 7 / 7 ✅. Ready for Stage 4.5 presentation.**

---

## 9. What this plan does NOT decide (deferred to later stages)

- Module-level code structure inside `.skills/tool-picker/` → **Stage 5 Bundle 1 design**.
- `scripts/update_handoff.sh` flag surface (beyond dry-run / --write default) → **Stage 5 Bundle 4 design**.
- Codex prompt text verbatim → **Stage 5 design appendices**.
- Stage 11 kickoff prompt text → **pre-Stage-11 housekeeping (DC.6)**.
- QA scenarios → **Stage 12**.
- Stage-9 half of OQ.L2 (KO freshness in code-review checklist) → **Stage 5 Bundle 4 design**.

---

## 10. Revision log for this document

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 — Stage 4 plan_final written | Session 3 → 4 continuation. Absorbed 8 plan_review revisions (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3). Approval checklist filled (7/7 ✅). |

---

## 📌 Next Stage

**Stage 4.5 — User approval gate** (joint for Bundle 1 + 4, per M.1).

Present this document to the user. Request explicit approval with reference to AC.1–AC.7 and AN.1–AN.3. On approval, proceed to pre-Stage-5 housekeeping (DC.5 + DC.6 drafting) and then Stage 5 Technical Design per bundle. On rejection, return to Stage 2 (or Stage 1 if direction is wrong), per docs/operating_manual.md Sec.2.

---
