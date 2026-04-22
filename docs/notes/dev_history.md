# Development History — jOneFlow v0.3

> **Purpose.** Chronological, stage-granular log of everything that happened during the v0.3 development cycle. Each entry records one stage run (or housekeeping step) with its verdict, key outputs, and decisions forwarded to later stages. Intended to be readable by a fresh Claude session that needs to reconstruct why things are the way they are.
>
> **Read order.** This is reference material, read *after* CLAUDE.md / HANDOFF.md / WORKFLOW.md when deeper history is needed. Not a replacement for the primary planning artifacts.
>
> **Scheme.** One section per stage run, in chronological order. Cross-references use `Sec. N` (not the `§` character — dropped in v0.3 for readability).
>
> **Language.** EN primary. Korean pair at `dev_history.ko.md` (written at session close, per R4).
>
> **DC.2 reference.** Plan_final Sec. 3-3 DC.2. Backfill performed in session 3 resumed (2026-04-22).

---

## Session summary table

| Session | Date | Stages executed | Verdict | Closed at |
|---------|------|-----------------|---------|-----------|
| 1 | 2026-04-22 | Stage 1 Brainstorm | PASS | before Stage 2 (context preservation) |
| 2 | 2026-04-22 | Stage 2 Plan Draft (EN + KO) | PASS | ~76% UI usage, clean stage boundary |
| 3 | 2026-04-22 | Stage 3 Plan Review (EN + KO) | PASS, 4/4 focus | ~95% UI usage, pre-Stage-4 |
| 3 resumed (post token refill) | 2026-04-22 | Stage 4 Plan Final (EN + KO) + Stage 4.5 approval + DC.5 + DC.6 + section-sign convention change + this backfill + Stage 5 Bundle 4 Technical Design (EN + KO) + Stage 5 Bundle 1 Technical Design (EN + KO) | APPROVED (joint); both bundles' Stage 5 complete | TBD |

---

## Session 1 — 2026-04-22

### Entry 1.1 — Stage 1 Brainstorm

- **Stage:** 1 (Brainstorm)
- **Owner:** Claude (planner), Hyoungjin (participant)
- **Output:** `docs/01_brainstorm/brainstorm.md` (+ Addendum appended at session close)
- **Verdict:** PASS — ready for Stage 2.
- **Key decisions forwarded to Stage 2:**
  - Workflow mode: **Strict-hybrid** (upper Strict + inner bundle Standard).
  - Bundle selection: **Bundle 1 (tool-picker) + Bundle 4 (doc-discipline)**. Bundles 2 and 3 deferred to v0.4.
  - Validation group 1 = {Bundle 1, Bundle 4} with joint Stage 4.5 approval gate (M.1) and single fresh-session Stage 11 (M.3).
  - UI policy: `has_ui=false` for v0.3; base-only through v0.5 or first downstream has_ui=true project.
  - Bundle 4 scope **option β**: covers kickoff goals 5/9/10 AND brainstorm Sec. 9-2 internal doc structure. Risk bumped low-medium → medium. Brainstorm Addendum documents the decision.
- **Reference frames introduced:** P1–P10 concerns (scale / concurrency / verdict authority), D-A/B/C/D rules (advisory-only tool-picker, Codex timing, verdict propagation).
- **Deferred from this stage:** `template_vs_dogfooding_separation` (eventually absorbed into Bundle 4 option β as D4.x1 at Stage 2).
- **Session close reason:** pre-Stage-2 context preservation; handing off to session 2 with full brainstorm artifact.

### Entry 1.2 — HANDOFF.md conversion (housekeeping, Option 1)

- **Action:** Converted the v0.2-inherited HANDOFF.md template into a v0.3 dogfooding tracker in place (Option 1). Added the "this file tracks dogfooding" banner note.
- **Rationale:** jOneFlow v0.3 is dogfooding itself. Rather than maintain two forks of HANDOFF.md, track dogfooding state here and split a clean template (`templates/HANDOFF.template.md`) at v0.3 release as Bundle 4 D4.x1.
- **Forwarded:** Clean-template separation is Bundle 4 responsibility (D4.x1).

---

## Session 2 — 2026-04-22

### Entry 2.1 — Stage 2 Plan Draft (EN + KO pair)

- **Stage:** 2 (Plan Draft)
- **Owner:** Claude (planner)
- **Output:** `docs/02_planning/plan_draft.md` (EN) + `docs/02_planning/plan_draft.ko.md` (KO, paired same-session per R4).
- **Verdict:** PASS — ready for Stage 3.
- **Shape:** 10-section structure — Goals / Non-goals / Deliverables / Milestones / Risks / Dependencies / Open Questions / Approval Checklist (pre-baked, empty) / Deferrals / Revision log.
- **Bundle treatment:** joint plan (not two separate plan drafts) since both go through joint Stage 4.5 + Stage 11.
- **Trackability discipline:** kickoff goals and scope_extras kept as two separate lists in Sec. 3 to preserve link back to `prompts/claude/v03_kickoff.md`.
- **Top-3 risks pre-filled:** R1 option-β scope creep · R2 tool-picker drift to N5 · R3 Stage 11 context exhaustion. Each with likelihood/impact/mitigation/owner.
- **Approval checklist pre-baked:** 7 items — AC.1–AC.4 (WORKFLOW.md Sec. 6 baseline) + AC.5–AC.7 (Strict-hybrid extras). Left unchecked for Stage 4 to fill.
- **Open Questions opened this stage:** OQ.S11.2 (divergent-verdict policy), OQ.L2 (KO freshness check location), OQ.N3 (`.github/` templates). All three get resolved in session 3.
- **Session close reason:** stage boundary at ~76% UI usage. `docs/notes/session_token_economics.md` written alongside to capture the continue-vs-transition decision framework.

### Entry 2.2 — `session_token_economics.md` introduced (living doc)

- **Output:** `docs/notes/session_token_economics.md` (KO-only; EN pair deferred to OSS release).
- **Purpose:** Living operational wiki capturing the "continue current session vs. start new session" decision framework, distilled from session 2's real 76%-usage judgment call.
- **Status:** Not in Bundle 1 or 4 scope. Operational hygiene artifact.

---

## Session 3 — 2026-04-22 (pre token refill)

### Entry 3.1 — Stage 3 Plan Review (EN + KO pair)

- **Stage:** 3 (Plan Review)
- **Owner:** Claude (reviewer)
- **Input:** `plan_draft.md` from session 2.
- **Output:** `docs/02_planning/plan_review.md` + `plan_review.ko.md`.
- **Verdict:** **PASS** on all four focus points from plan_draft "Next Stage":
  - (a) kickoff goals 5/7/9/10/11/12 coverage — all mapped to deliverables.
  - (b) Top-3 risks validity — confirmed.
  - (c) Open Questions containment to Stage 5 — one true Stage-4 leak caught (see below).
  - (d) KO freshness — passed, and a reusable 4-item KO sync check block introduced (Sec. 4-3).
- **Key finding (true Stage-4 leak):** **OQ.S11.2 (divergent-verdict policy)** was identified as governance policy, not technical design. Promoted to **committed rule M.5** in plan_final (F-c2): group verdict = worst-of-two; `design_level` on either bundle triggers joint re-approval.
- **Other findings forwarded as revisions** (all absorbed in Stage 4):
  - F-a1 — CONTRIBUTING.md file ownership to D4.c; D4.b contributes one `## Changelog maintenance` section only.
  - F-b2 — New secondary risk **R9 Joint-approval coupling** (M.1 amplifier) added to Sec. 5-2.
  - F-c1 — New cross-bundle deliverable **DC.6** (`prompts/claude/v03/stage11_joint_validation_prompt.md`).
  - F-c3 — OQ.L2 Stage-3 half resolved via Sec. 4-3 KO sync check block. Stage-9 half retained for Bundle 4 tech design.
  - F-o1 — DEP.1 tightened: Bundle 4 D4.x2–x4 must lock before Bundle 1 D1.b; rest may proceed concurrently.
  - F-o2 — Stage 13 ships a single joint `v0.3` git tag (release hygiene note → M.6).
  - F-o3 — OQ.N3 folded into N7 as `.github/` PR/issue template sub-bullet; removed from Sec. 7.
- **Session close reason:** **~95% UI usage** reached. Stopped at the clean Stage-3 boundary before entering Stage 4. All Stage 4 work pre-staged as the 8-revision table in `plan_review.md Sec. 6` + HANDOFF.md next-session prompt so session 4 could resume mechanically.

---

## Session 3 (resumed after token refill) — 2026-04-22

### Entry 3.2 — Stage 4 Plan Final (EN + KO pair)

- **Stage:** 4 (Plan Final)
- **Owner:** Claude (planner)
- **Input:** `plan_draft.md` (v1, session 2) + `plan_review.md` (v1, session 3, revisions table).
- **Output:** `docs/02_planning/plan_final.md` + `plan_final.ko.md`.
- **Verdict:** 7/7 ✅ approval checklist passes. Ready for Stage 4.5.
- **All 8 plan_review revisions absorbed** (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3) — Sec. 0-2 Summary of changes table cross-references where each landed.
- **OQ.S11.2 committed as M.5** (no longer an open question) — divergent-verdict policy.
- **Open Questions Sec. 7 shrunk:** OQ.S11.2 removed (now M.5), OQ.L2 Stage-3 half marked resolved, OQ.N3 removed (folded into N7).
- **KO sync check block** added at Sec. 0, all 4 items checked against the paired `.ko.md`.
- **Non-blocking notes (AN.1–AN.3):** DC.5 + DC.6 are pre-Stage-5 / pre-Stage-11 preconditions (not Stage-4 gates); residual OQs resolve in Stage 5; `dev_history.md` backfill to happen this session.
- **Session continuation rationale:** user requested consecutive Stage 3 → Stage 4 after token refill despite usage pressure. Decision documented in session_token_economics wiki.

### Entry 3.3 — Stage 4.5 User Approval Gate

- **Stage:** 4.5 (Approval gate — joint for validation group 1)
- **Presenter:** Claude · **Decider:** Hyoungjin
- **Input presented:** `plan_final.md` + `plan_final.ko.md` with 7/7 ✅.
- **Constraint invoked:** M.1 — partial approval not valid; Bundle 1 + Bundle 4 decided together.
- **Verdict:** **APPROVED (joint)**. Both bundles' `approval_status` → `approved` in HANDOFF.md YAML.
- **Unblocked:** entry into pre-Stage-5 housekeeping + Stage 5.

### Entry 3.4 — Pre-Stage-5 Housekeeping (DC.5 + DC.6 prompt drafts)

- **Step:** Cross-bundle housekeeping (not a formal stage).
- **Owner:** Claude.
- **Output (3 new files in `prompts/claude/v03/`):**
  - `stage5_bundle4_design_prompt_draft.md` — DC.5 half #1. Hardwires D4.x2/x3/x4 as Sec. 0 locked-first requirement; lists D4.a–D4.c + D4.x1 coverage; enumerates OQs to close in Bundle 4 tech design.
  - `stage5_bundle1_design_prompt_draft.md` — DC.5 half #2. Hard-gates on Bundle 4 Sec. 0 locked; cites plan_final Sec. 5-2 R2 (read-only Markdown surface) as acceptance criterion.
  - `stage11_joint_validation_prompt.md` — DC.6 (new per F-c1). Enforces pre-compacted per-bundle dossier format (≤ 1 page prose + ≤ 200 lines diff each) to mitigate R3 context exhaustion. Encodes M.3/M.5/M.6 directly in the output template.
- **Open question closed:** OQ.S11.1 — Stage 11 context delivery format is now concretely "dossier at `docs/notes/stage11_dossiers/bundle{id}_dossier.md`".
- **Forwarded:** All three drafts are pre-conditions for the next stage entry they name.

### Entry 3.5 — Section-sign convention change (house style)

- **Step:** House style housekeeping.
- **Trigger:** User feedback — `§` (U+00A7) harms readability in the bilingual EN/KO planning docs.
- **Scope of change:** Batch-replaced `§` → `Sec. ` (literal prefix + space) across 8 v0.3 working documents:
  - `plan_draft.md` + `plan_draft.ko.md`
  - `plan_review.md` + `plan_review.ko.md`
  - `plan_final.md` + `plan_final.ko.md`
  - `HANDOFF.md`
  - `brainstorm.md`
- **Intentionally NOT changed:** canonical prompt templates (`prompts/claude/final_review.md`, `code_review.md`, `v03_kickoff.md`) to preserve v0.2 compatibility; `docs/notes/session_token_economics.md` and `docs/notes/2026-04-21-v0.3-kickoff-state.md` left untouched for now (not planning-docs surface).
- **Verification:** zero `§` remaining in the 8 files; zero `Sec.  ` (double-space) artifacts.
- **Forwarded:** New documents (anything drafted from here forward) use `Sec. ` directly; this entry serves as the convention reference.

### Entry 3.6 — `dev_history.md` backfill (this file)

- **Step:** AN.3 / DC.2 partial fulfillment (backfill only; live logging from here onward).
- **Output:** `docs/notes/dev_history.md` (this file) + Korean pair `dev_history.ko.md` (written same session per R4).
- **Scope:** Sessions 1, 2, 3 (pre- and post-refill). Stage-granular entries plus housekeeping entries.
- **Forward discipline:** From session 4 onward, append a new entry **at every stage close** or significant housekeeping step, not only on revision loops. Keep to the entry template used above (Stage / Owner / Input / Output / Verdict / Key decisions / Forwarded).

### Entry 3.7 — Stage 5 Bundle 4 Technical Design (EN + KO pair)

- **Stage:** 5 (Technical Design — Bundle 4, Doc Discipline, option β).
- **Owner:** Claude (designer).
- **Input:** `docs/02_planning/plan_final.md` (APPROVED at Stage 4.5) + `prompts/claude/v03/stage5_bundle4_design_prompt_draft.md` (DC.5 half #1).
- **Output:** `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN, 14 sections, ~640 lines) + `technical_design.ko.md` (KO pair, same session per R4). Both files carry YAML frontmatter per D4.x2 and a 4-item KO sync check block (all ticked).
- **Verdict:** Stage 5 Bundle 4 **complete**. AC.B4.1–16 enumerated for Stage 9 review.
- **Key decisions forwarded (Sec. 0 locked — DEP.1 gate):**
  - **D4.x2** — YAML frontmatter on Stage-5-and-later docs only; minimum fields `title, stage, bundle, version, language, paired_with, created, updated` (+ optional `status, supersedes, validation_group`). Stage 1–4 docs stay prose-only.
  - **D4.x3** — Bundle folder naming `bundle{id}_{name}/` with snake_case `{name}`; regex `^bundle(\d+)_(.+)$` extracts both fields.
  - **D4.x4** — Link convention is always relative to the current file (no project-root-absolute paths); anchor slugs follow GitHub's lowercase-hyphenated rule.
  - Decision record line to be quoted verbatim by Bundle 1 Sec. 1.
- **Components specified:** `scripts/update_handoff.sh` (D4.a, POSIX sh, dry-run default, 6-exit-code contract), `CHANGELOG.md` (D4.b, Keep-a-Changelog v1.1.0), `CONTRIBUTING.md` (D4.c, 12 required sections + F-a1 ownership table appendix), `CODE_OF_CONDUCT.md` (D4.c, Contributor Covenant v2.1), `templates/HANDOFF.template.md` (D4.x1), `docs/notes/decisions.md` (D4.x2/x3/x4 quotable record).
- **Open questions closed this step:** OQ.N1 (Keep-a-Changelog format chosen), OQ4.1 (Stage-5-and-later-only frontmatter), OQ4.2 (`bundle{id}_{name}/`), OQ.H2 (manual migration path → `CONTRIBUTING.md` Sec. 9), OQ.L2 Stage-9 half (KO freshness checklist bullet in `CONTRIBUTING.md` Sec. 7).
- **F-a1 remediation:** Sec. 8 `## Changelog maintenance` inside D4.c-owned `CONTRIBUTING.md` remains the single exception; explicit per-section ownership table appended as appendix Sec. 12 of `CONTRIBUTING.md`.
- **Forwarded to Stage 8 (Codex):** 7-file dependency-ordered deliverable list + do-not-violate constraints + Codex kickoff prompt (Sec. 12-1 of the tech design).
- **DEP.1 unblocked for Bundle 1:** Sec. 0 decisions are locked and quotable via `docs/notes/decisions.md`. Bundle 1 Stage 5 may now begin.

### Entry 3.8 — Stage 5 Bundle 1 Technical Design (EN + KO pair)

- **Stage:** 5 (Technical Design — Bundle 1, Tool Picker).
- **Owner:** Claude (designer).
- **Input:** `docs/02_planning/plan_final.md` (APPROVED at Stage 4.5) + `prompts/claude/v03/stage5_bundle1_design_prompt_draft.md` (DC.5 half #2) + `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 (DEP.1 gate, now locked).
- **Output:** `docs/03_design/bundle1_tool_picker/technical_design.md` (EN, 14 sections) + `technical_design.ko.md` (KO pair, same session per R4). Both files carry YAML frontmatter per D4.x2 and a 4-item KO sync check block (all ticked, 17/17 header parity, AC.B1.1–10 × 10 items).
- **Verdict:** Stage 5 Bundle 1 **complete**. AC.B1.1–10 enumerated for Stage 9 review (headline: AC.B1.7 R2 read-only invariant).
- **Key decisions forwarded (Sec. 0 DEP.1 preflight + Sec. 1–4):**
  - **OQ1.1 closed — single file:** `D1.a + D1.b + D1.c` consolidated into one `.skills/tool-picker/SKILL.md` (≤ 300 lines; expected 180–220; escalate rather than split).
  - **OQ1.2 closed — two triggers, one pipeline:** Both stage-entry auto-invocation and user-request invocation share a single decision pipeline; trigger source never alters output.
  - **OQ1.3 closed — no native Skill API:** Pure Markdown skill registered by CLAUDE.md Read order (N14); no native API registration.
  - **D1.x split into `docs/notes/tool_picker_usage.md`** (≤ 80 lines) to keep SKILL.md matcher-friendly — a deliberate scope-reduction from "inlined usage guide."
  - **Frontmatter contract:** `name: tool-picker` + description with mandatory-trigger keywords ("stage", "mode", "risk_level", "next step", "jOneFlow") per Anthropic Skills format.
  - **Decision table matrix:** stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high} → 3-slot output (primary / checklist / watch-out).
  - **R2 read-only invariant testable:** AC.B1.7 specifies grep pattern `'\b(bash|sh |python|node|eval|exec |curl|wget)\b'`; matches must only appear inside code fences or quoted example output.
  - **Narrow D4.x4 exception (Sec. 9-4):** Advisory output paths are project-root-relative (no "current file" context for runtime advice); skill body's own pedagogical citations still follow D4.x4.
  - **CLAUDE.md coordination (Sec. 9-5):** Joint commit `[bundle1+bundle4]` if same session, else rebase — both bundles edit CLAUDE.md Read order.
- **Open questions closed this step:** OQ1.1 (single file), OQ1.2 (both triggers, one pipeline), OQ1.3 (no native Skill API registration).
- **Components specified:** `.skills/tool-picker/SKILL.md` (D1.a + D1.b + D1.c, single file ≤ 300 lines) + `docs/notes/tool_picker_usage.md` (D1.x, ≤ 80 lines, pedagogical reference).
- **Forwarded to Stage 8 (Codex):** 2-file deliverable list (SKILL.md + usage doc) + CLAUDE.md one-line Read-order edit (coordinated with Bundle 4) + R2 invariant test + Codex kickoff prompt (Sec. 12-1 of the tech design).
- **DEP.1 satisfied:** Sec. 0 quotes Bundle 4 D4.x2/x3/x4 verbatim; Bundle 1 does not re-decide structural discipline.
- **Validation-group-1 status:** Both bundles' Stage 5 now complete. Stages 6–7 skipped (has_ui=false). Next stage = **Stage 8 Codex implementation** (per-bundle kickoff prompts at Sec. 12-1 of each tech design).

---

## Entry template (for future sessions)

```markdown
### Entry N.M — [stage or step name]

- **Stage:** [n and name, or "housekeeping"]
- **Owner:** [Claude / Codex / user]
- **Input:** [referenced artifacts]
- **Output:** [paths + KO pair note if applicable]
- **Verdict:** [PASS / NEEDS REVISION (minor|bug_fix|design_level) / APPROVED / BLOCKED]
- **Key decisions forwarded:** [bullet list with stage pointers]
- **Open questions opened/closed this step:** [OQ refs]
- **Session close reason (if session boundary):** [trigger]
```

---

## Revision log for this document

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 — initial backfill (session 3 resumed) | Covers sessions 1, 2, 3 (pre- and post-token-refill) at stage granularity. Fulfills plan_final AN.3 + partial DC.2. Korean pair written alongside. |
| 2026-04-22 | v1.1 — Stage 5 Bundle 4 close (Entry 3.7) | Added Entry 3.7 for Stage 5 Bundle 4 Technical Design (EN + KO pair). Session summary table updated. KO pair update below. |
| 2026-04-22 | v1.2 — Stage 5 Bundle 1 close (Entry 3.8) | Added Entry 3.8 for Stage 5 Bundle 1 Technical Design (EN + KO pair). Session summary table updated (Bundle 1 added to session-3-resumed row). Both bundles' Stage 5 now complete; next stage = Stage 8 Codex. KO pair updated alongside. |
