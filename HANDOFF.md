# 📋 HANDOFF — Session State

> **Read this second**, after CLAUDE.md.
> Update this file at the end of every session.
> Korean version below (한국어 버전: 파일 하단)

> ⚠️ **Note (2026-04-22):** This file currently tracks **jDevFlow's own v0.3 dogfooding**
> state (Option 1). A clean template version will be separated into
> `templates/HANDOFF.template.md` at v0.3 release (Bundle 4 — Doc discipline scope).
> Until then, new projects should copy this file and clear state sections manually.

---

## Status

**Current version:** v0.3 (in progress)
**Last updated:** 2026-04-22 (UTC)
**Workflow mode:** Strict-hybrid
**Current stage:** Stage 9 Bundle 1 ✅ PASS — minor; both bundles in validation group 1 now closed at Stage 9. Next: Stage 10/11 (Stage 11 = fresh Claude session per M.3). has_ui=false; risk_level=medium.
**has_ui:** false
**risk_level:** medium

### ✅ Completed
- [x] Project initialized (folders, CLAUDE.md, WORKFLOW.md present — inherited from v0.2)
- [x] Language selected: EN primary + KO translation (applies from `plan_draft.md` onward)
- [x] Security setup: inherited from v0.2 (no changes in v0.3 scope)
- [x] Git initialized (local tracking assumed; inherited from v0.2)
- [x] **Stage 1 — Brainstorm** → `docs/01_brainstorm/brainstorm.md`
- [x] Mode & bundle selection: Strict-hybrid, Bundle 1 + Bundle 4
- [x] Validation group declared: Group 1 = {Bundle 1, Bundle 4}
- [x] **Stage 2 — Plan Draft** → `docs/02_planning/plan_draft.md` (EN) + `plan_draft.ko.md` (KO)
- [x] Language policy first application: EN primary written, KO paired translation committed same session (per R4 mitigation rule in plan_draft Sec. 5-2)
- [x] **Stage 3 — Plan Review** → `docs/02_planning/plan_review.md` (EN) + `plan_review.ko.md` (KO). Verdict: PASS all 4 focus points (coverage / top-3 risks / OQ containment / KO sync). 8 revisions forwarded to plan_final (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3). One true leak caught: **OQ.S11.2 → promote to committed policy M.5** (divergent-verdict policy).
- [x] **Stage 4 — Plan Final** → `docs/02_planning/plan_final.md` (EN) + `plan_final.ko.md` (KO). All 8 plan_review revisions absorbed. Approval checklist 7/7 ✅. Ready for Stage 4.5 presentation.
- [x] **Stage 4.5 — User approval gate** ✅ APPROVED (2026-04-22, session 3 resumed). Joint approval for Bundle 1 + Bundle 4 (M.1 satisfied, no partial approval). Bundle approval_status → approved for both. Stage 5 unblocked.
- [x] **Pre-Stage-5 housekeeping (DC.5 + DC.6)** ✅ complete — drafts saved in `prompts/claude/v03/`:
  - `stage5_bundle4_design_prompt_draft.md` (DC.5 half #1; Bundle 4 first per DEP.1)
  - `stage5_bundle1_design_prompt_draft.md` (DC.5 half #2; gated on Bundle 4 Sec. 0 locked)
  - `stage11_joint_validation_prompt.md` (DC.6; enforces dossier-based context delivery + M.3/M.5/M.6)
- [x] **Stage 5 Bundle 4 — Technical Design** ✅ complete (2026-04-22, session 3 resumed) — `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN) + `technical_design.ko.md` (KO). Sec. 0 locks D4.x2/x3/x4; AC.B4.1–16 acceptance criteria enumerated; 12-section Codex handoff appendix; YAML frontmatter applied per D4.x2; KO sync check block ticked (18/18 headers, 16/16 AC items). **DEP.1 unblocked** — Bundle 1 Stage 5 can now begin.
- [x] **Stage 5 Bundle 1 — Technical Design** ✅ complete (2026-04-22, session 3 resumed) — `docs/03_design/bundle1_tool_picker/technical_design.md` (EN) + `technical_design.ko.md` (KO). Quotes Bundle 4 D4.x2/x3/x4 verbatim in Sec. 0 per DEP.1. Single-file skill design (D1.a/D1.b/D1.c in one SKILL.md ≤ 300 lines) + D1.x usage reference doc. Decision table covers stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high}. AC.B1.1–10 enumerated (headline: AC.B1.7 R2 read-only invariant). Closes OQ1.1 (single file), OQ1.2 (both triggers, one pipeline), OQ1.3 (no native API registration). YAML frontmatter + KO sync check block ticked (17/17 headers, 10/10 AC items).
- [x] **Stage 8 Codex handoff package prepared** ✅ (2026-04-22, session 3 resumed, session-close housekeeping) — 4 new files:
  - `prompts/codex/v03/stage8_bundle4_codex_kickoff.md` — Bundle 4 first per M.1 (owns `docs/notes/decisions.md`)
  - `prompts/codex/v03/stage8_bundle1_codex_kickoff.md` — Bundle 1 second; Precondition checklist gates on Bundle 4 complete
  - `prompts/codex/v03/stage8_coordination_notes.md` — run-order, single-vs-two-session, failure escalations, report shape
  - `prompts/claude/v03/session4_post_codex_resume_prompt.md` — post-Codex Claude resume prompt (EN + KO mirror) for starting session 4 at Stage 9
- [x] **Stage 8 Bundle 4 — Codex implementation** ✅ complete (2026-04-22, Codex session) — 14 deliverables: `scripts/update_handoff.sh` (POSIX sh, 486 lines, shellcheck clean), `templates/HANDOFF.template.md`, `CHANGELOG.md` (KaC v1.1.0), `CODE_OF_CONDUCT.md` (Covenant v2.1), `CONTRIBUTING.md` (12 sections + F-a1 appendix), `docs/notes/decisions.md` (+ `.ko.md`, D4.x2/x3/x4 quotable), `docs/04_implementation/implementation_progress.md` (+ `.ko.md`), `tests/run_bundle4.sh` + 4 test scripts under `tests/bundle4/` (all PASS). Completion report archived at `prompts/codex/v03/stage8_bundle4_codex_report.md`.
- [x] **Stage 9 Bundle 4 — Claude code review** ✅ **PASS — minor** (2026-04-22, session 4) — per-AC verdict table in `docs/04_implementation/implementation_progress.md` (+ `.ko.md`). No code changes. Inline design polish: Bundle 4 `technical_design.md` Sec. 6 expanded 8 → 10 rows with added `stdout discriminator` column (+ KO pair) to resolve AC.B4.3 mismatch (rubric "nine" = nine distinct `error=<key>` discriminators, now mapped 1-to-1). `dev_history.md` Entry 3.9 recorded. Bundle 1 kickoff precondition checklist ticked (all 3 green).

### 🔄 In Progress
- **Awaiting Stage 8 Bundle 1 Codex run.** Bundle 4 side is fully closed through Stage 9. Hyoungjin runs the Bundle 1 kickoff next (`prompts/codex/v03/stage8_bundle1_codex_kickoff.md`); on completion, Hyoungjin starts **session 5** using `prompts/claude/v03/session5_post_codex_bundle1_resume_prompt.md` to enter **Stage 9 Bundle 1 code review** (M.3 invariant — fresh Claude session).

### ⏭️ Next (session 5)
1. **Stage 8 Bundle 1 Codex run** (operator-driven, outside Claude) — paste block from `stage8_bundle1_codex_kickoff.md`. Expected 2-file deliverable: `.skills/tool-picker/SKILL.md` (D1.a+D1.b+D1.c, ≤ 300 lines) + `docs/notes/tool_picker_usage.md` (D1.x, ≤ 80 lines) + KO pair for D1.x + test `tests/bundle1/test_skill_read_only.sh` + CLAUDE.md Read-order line (coordinated with Bundle 4).
2. **Stage 9 Bundle 1 — Claude code review** against AC.B1.1–10 (headline: AC.B1.7 R2 read-only invariant grep test; AC.B1.3 ≤ 300 lines; AC.B1.4 frontmatter mandatory triggers; AC.B1.10 KO pair sync). Sec. 9-1 "Claude polish" allowance: decision-table wording polish may be applied inline during Stage 9.
3. **Stage 10** (if NEEDS REVISION) → loop back to Codex with `prompts/codex/revise.md` + findings list → re-enter Stage 9.
4. **Stage 11 joint validation** — after both bundles at PASS — **fresh Claude session** per M.3 invariant; do NOT chain into the same session. Use `prompts/claude/v03/stage11_joint_validation_prompt.md`.

### 🚧 Blockers
- None. All three Bundle 1 kickoff preconditions satisfied (Bundle 4 deliverables present; `decisions.md` D4.x2/x3/x4 recorded; `tests/run_bundle4.sh` green + Stage 9 PASS).

---

## Bundles (v0.3 scope)

```yaml
bundles:
  - id: 1
    name: tool-picker
    goals: [7, 11, 12]          # from prompts/claude/v03_kickoff.md
    risk_level: medium-high
    stage: 9                     # Stage 9 closed 2026-04-22 (PASS — minor)
    verdict: minor               # Stage 9 Bundle 1 close 2026-04-22 — housekeeping only; 0 code changes, 0 inline polish edits
    validation_group: 1
    approval_status: approved  # Stage 4.5 joint approval 2026-04-22 (M.1 satisfied)
  - id: 4
    name: doc-discipline
    goals: [5, 9, 10]              # from v03_kickoff.md
    scope_option: beta              # α = goals only, β = goals + brainstorm Sec. 9-2, γ = split
    scope_extras:                   # added under option β (2026-04-22 session 1 close)
      - internal_doc_header_schema
      - bundle_folder_naming
      - doc_link_conventions
      - template_vs_dogfooding_separation  # earlier deferral folded in
    risk_level: medium               # bumped from low-medium under option β
    stage: 9                         # Stage 9 closed 2026-04-22 (PASS)
    verdict: minor                   # Stage 9 Bundle 4 close 2026-04-22 — design-doc polish only; no code revision
    validation_group: 1
    approval_status: approved  # Stage 4.5 joint approval 2026-04-22 (M.1 satisfied)

deferred:
  - id: 2
    name: metadata-refinement
    goals: [1, 2, 3]
    reason: depends on Bundle 1 real-world use; re-scope in v0.4
  - id: 3
    name: codex-handoff-ux
    goals: [4, 6, 8]
    reason: depends on Bundle 1 skill surface; re-scope in v0.4

validation_groups:
  - id: 1
    bundles: [1, 4]
    stage_11_required: true
```

---

## Recent Changes

| Date | Description |
|------|-------------|
| 2026-04-22 | Stage 9 Bundle 1 code review PASS — minor; 0 code changes, 0 inline polish edits; Entry 3.9 KO-mirror backfilled; Bundle 1 YAML bumped stage 1→9, verdict null→minor. |
| 2026-04-22 | Stage 9 Bundle 4 code review PASS; Sec. 6 of Bundle 4 technical_design expanded to 10 rows to resolve AC.B4.3 mismatch. |
| 2026-04-22 | Stage 1 Brainstorm complete: mode=strict-hybrid, bundles 1+4 selected, validation group 1 declared, UI base-only policy set (through v0.5 or first downstream has_ui=true) |
| 2026-04-22 | HANDOFF.md converted from template into v0.3 dogfooding tracker (Option 1); template separation deferred to Bundle 4 |
| 2026-04-22 | Bundle 4 scope clarified (option β): covers both goals 5/9/10 AND brainstorm Sec. 9-2 internal doc structure items; risk_level bumped low-medium → medium; brainstorm.md Addendum added |
| 2026-04-22 | Session 1 closed before plan_draft.md to preserve context; session 2 resumes at Stage 2 |
| 2026-04-22 | Session 2: Stage 2 Plan Draft complete — `plan_draft.md` (EN) + `plan_draft.ko.md` (KO) written. Scope: bundles combined, kickoff goals and scope_extras kept as separate lists, bundle×stage milestone matrix, 7-item approval checklist (WORKFLOW Sec. 6 baseline 4 + Strict-hybrid extras 3) pre-baked. Session 3 resumes at Stage 3. |
| 2026-04-22 | Session 2: added operational wiki `docs/notes/session_token_economics.md` — living doc capturing the "continue session vs. new session" decision framework, derived from session 2's own 76%-usage judgment. KO-only; EN pair deferred to OSS release. |
| 2026-04-22 | Session 3: Stage 3 Plan Review complete — `plan_review.md` (EN) + `plan_review.ko.md` (KO). All 4 focus points PASS. 8 revisions forwarded to plan_final. Key finding: **OQ.S11.2 (divergent-verdict policy) was a true Stage-4 leak** — promoted to committed rule M.5. 2 traceability upgrades (DC.6, DEP.1 tightening). Session closed before Stage 4 at ~95% UI token usage; plan_final work fully pre-staged in plan_review Sec. 6 for session 4. |
| 2026-04-22 | Session 3 (resumed after token refill): Stage 4 Plan Final complete — `plan_final.md` (EN) + `plan_final.ko.md` (KO). All 8 plan_review revisions absorbed (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3). Approval checklist 7/7 ✅. Stage 4.5 approval gate now presented to user; Stage 5 is blocked until approval. |
| 2026-04-22 | Session 3 (resumed): **Stage 4.5 APPROVED** by user (joint Bundle 1 + 4, M.1 satisfied). Both bundles `approval_status: approved` in HANDOFF YAML. Stage 5 unblocked. Next: DC.5 + DC.6 prompt drafts → Stage 5 Bundle 4 (per DEP.1 tightened) → Bundle 1. Note: the U+00A7 section-sign character will be dropped in new documents for readability (replaced by literal "Sec. " prefix). |
| 2026-04-22 | Session 3 (resumed): **DC.5 + DC.6 housekeeping complete**. 3 new files under `prompts/claude/v03/`: `stage5_bundle4_design_prompt_draft.md`, `stage5_bundle1_design_prompt_draft.md`, `stage11_joint_validation_prompt.md`. Bundle 4 prompt enforces D4.x2–x4 as Sec. 0 locked-first requirement; Bundle 1 prompt hard-gates on Bundle 4 Sec. 0 existence; Stage 11 prompt commits to pre-compacted dossier format (resolves OQ.S11.1). Section-sign U+00A7 convention dropped from new files. |
| 2026-04-22 | Session 3 (resumed): **`§ → Sec. ` batch migration** across 8 v0.3 working docs (plan_draft/review/final + KO pairs, HANDOFF.md, brainstorm.md). Canonical prompt templates left untouched for v0.2 compatibility. Zero U+00A7 remaining in migrated files; zero double-space artifacts. |
| 2026-04-22 | Session 3 (resumed): **`dev_history.md` backfill complete** — EN + KO pair. Covers sessions 1/2/3 (pre- and post-refill) at stage granularity with per-entry template. Fulfills plan_final AN.3 + partial DC.2. Going forward, append a new entry at every stage close or significant housekeeping step. |
| 2026-04-22 | Session 3 (resumed): **Stage 5 Bundle 4 Technical Design complete** — `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN, 14 sections, ~640 lines) + `technical_design.ko.md` (KO pair, same session per R4). **Sec. 0 locks D4.x2 / D4.x3 / D4.x4** (YAML frontmatter on Stage-5+ docs; `bundle{id}_{name}/` snake_case folder; always-relative-to-current-file links with GitHub anchor slugs) — DEP.1 satisfied, Bundle 1 Stage 5 unblocked. Closes OQ.N1, OQ4.1, OQ4.2, OQ.H2, OQ.L2 Stage-9 half. Acceptance criteria AC.B4.1–16 enumerated. Both files carry YAML frontmatter per D4.x2; KO sync check block ticked (18/18 headers, 16/16 AC items). |
| 2026-04-22 | Session 3 (resumed): **Stage 5 Bundle 1 Technical Design complete** — `docs/03_design/bundle1_tool_picker/technical_design.md` (EN, 14 sections) + `technical_design.ko.md` (KO pair, same session per R4). Sec. 0 quotes Bundle 4 D4.x2/x3/x4 verbatim per DEP.1. Single-file `.skills/tool-picker/SKILL.md` scope (D1.a+D1.b+D1.c in one file ≤ 300 lines) + D1.x `docs/notes/tool_picker_usage.md` reference. Decision table: stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high}. Closes OQ1.1/1.2/1.3. AC.B1.1–10 enumerated; R2 read-only invariant locked as AC.B1.7. YAML frontmatter applied; KO sync check ticked (17/17 headers, 10/10 AC items). **Both bundles' Stage 5 now complete**; Stages 6–7 n/a (has_ui=false); next stage = Stage 8 Codex implementation. |
| 2026-04-22 | Session 3 (resumed, close): **Stage 8 Codex handoff package prepared** — 3 files under `prompts/codex/v03/` (Bundle 4 kickoff, Bundle 1 kickoff, coordination notes) + 1 file under `prompts/claude/v03/` (post-Codex session-4 resume prompt, EN + KO mirror). Run order fixed: Bundle 4 first (owns `docs/notes/decisions.md`), Bundle 1 second with precondition checklist. Claude session 4 starts at Stage 9 code review after Codex completion reports are pasted into the resume prompt. |

---

## Key Document Links

| Document | Stage | Status |
|----------|-------|--------|
| `docs/01_brainstorm/brainstorm.md` | Stage 1 | ✅ Complete (2026-04-22) |
| `docs/02_planning/plan_draft.md` | Stage 2 | ✅ Complete (2026-04-22, session 2) |
| `docs/02_planning/plan_draft.ko.md` | Stage 2 (KO) | ✅ Complete (2026-04-22, session 2) |
| `docs/02_planning/plan_review.md` | Stage 3 | ✅ Complete (2026-04-22, session 3) |
| `docs/02_planning/plan_review.ko.md` | Stage 3 (KO) | ✅ Complete (2026-04-22, session 3) |
| `docs/02_planning/plan_final.md` | Stage 4 | ✅ Complete (2026-04-22, session 3 resumed) |
| `docs/02_planning/plan_final.ko.md` | Stage 4 (KO) | ✅ Complete (2026-04-22, session 3 resumed) |
| `docs/03_design/bundle1_tool_picker/technical_design.md` | Stage 5 | ✅ Complete (2026-04-22, session 3 resumed) — EN + KO pair, AC.B1.1–10 enumerated |
| `docs/03_design/bundle4_doc_discipline/technical_design.md` | Stage 5 | ✅ Complete (2026-04-22, session 3 resumed) — EN + KO pair, D4.x2/x3/x4 locked |
| `docs/04_implementation/implementation_progress.md` | Stage 8–10 | ⬜ Not started |
| `docs/notes/final_validation.md` | Stage 11 | ⬜ Not started (Group 1 joint validation) |
| `docs/05_qa_release/qa_scenarios.md` | Stage 12 | ⬜ Not started |
| `docs/notes/dev_history.md` | All | ✅ Backfilled (2026-04-22, session 3 resumed) — EN + KO pair |
| `prompts/claude/v03_kickoff.md` | Stage 0 | ✅ Reference |

---

## 📋 Next Session Prompt

> Copy and paste this at the start of your next Claude session (**session 5**, after Codex has run Stage 8 Bundle 1).
> Full standalone copy also at: `prompts/claude/v03/session5_post_codex_bundle1_resume_prompt.md` (EN + KO mirror).
>
> Before running this Claude prompt, Hyoungjin runs **one** Codex job:
> 1. Bundle 1 only — prompt at `prompts/codex/v03/stage8_bundle1_codex_kickoff.md`
>    (Bundle 4 Stage 8 + Stage 9 are already closed; Bundle 1 preconditions are all ticked.)
> 2. Coordination notes (still applicable — same failure-escalation rules) — `prompts/codex/v03/stage8_coordination_notes.md`
> 3. Codex's Bundle 1 completion report should be archived at
>    `prompts/codex/v03/stage8_bundle1_codex_report.md` (mirrors the Bundle 4 archive pattern).

```
Continue jDevFlow v0.3 (session 5 — post-Codex Bundle 1 resumption).

Please read in this order:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md  (in particular Sec. 10 Stages 9, 10, 11, 12, 13)
4. docs/notes/dev_history.md  (latest entry: 3.9 — Stage 8 + 9 Bundle 4 close)
5. docs/03_design/bundle1_tool_picker/technical_design.md     (AC.B1.1–10 rubric — PRIMARY spec this session)
6. docs/04_implementation/implementation_progress.md          (Stage 8 Bundle 4 log + Stage 9 Bundle 4 verdict; Bundle 1 log appended by Codex this session)
7. prompts/codex/v03/stage8_bundle1_codex_report.md           (archived Codex paste for Bundle 1, if present)
8. Whatever Codex created for Bundle 1 — skim tree with:
   find .skills docs/notes/tool_picker_usage.md docs/notes/tool_picker_usage.ko.md tests/bundle1 -maxdepth 3 2>/dev/null

Path: ~/projects/Jonelab_Platform/jDevFlow/

Session-specific deltas from the template:
- Bundle 4 side is DONE through Stage 9 (PASS — minor, 2026-04-22). Skip all Bundle 4 review.
- This session reviews Bundle 1 ONLY against AC.B1.1–10.
- Bundle 1's artifacts are still untracked. Formal commit only after Stage 9 PASS.
- Codex Stage 8 Bundle 1 report archive location (not pasted inline):
  prompts/codex/v03/stage8_bundle1_codex_report.md
- If Codex flagged any non-trivial judgement calls in its report, Stage 9 must
  decide disposition (accept / tighten rubric / tighten design doc). Precedent
  from Stage 9 Bundle 4: AC.B4.3 nine-error-cases mismatch resolved by
  expanding Sec. 6 of the Bundle 4 design inline (Option b).

Current status:
- Workflow mode: Strict-hybrid
- Validation group 1 = {Bundle 1 tool-picker, Bundle 4 doc-discipline (option β)}
- Stages 1–5 complete; Stages 6–7 skipped (has_ui=false)
- Stage 8 Bundle 4 done; Stage 9 Bundle 4 = PASS — minor
- Stage 8 Bundle 1: SEE CODEX REPORT BELOW
- has_ui=false, risk_level=medium-high (Bundle 1)

=== CODEX STAGE 8 COMPLETION REPORT — BUNDLE 1 ===
[paste Codex's Bundle 1 completion report here, or note "pending" if not yet run]

Next task in this session: Stage 9 Bundle 1 code review (AC.B1.1–10).

Stage 9 Bundle 1 plan:
1. Read Codex's Bundle 1 artifacts: `.skills/tool-picker/SKILL.md`,
   `docs/notes/tool_picker_usage.{md,ko.md}`, `tests/bundle1/*`, and the
   one-line edit to CLAUDE.md Read-order.
2. Run per-AC verdict against AC.B1.1–10.
   - Headline items: AC.B1.7 (R2 read-only invariant grep test — pattern
     `'\b(bash|sh |python|node|eval|exec |curl|wget)\b'` must only match
     inside code fences or quoted example output), AC.B1.3 (SKILL.md
     ≤ 300 lines; escalate rather than split), AC.B1.4 (frontmatter
     mandatory-trigger keywords: "stage", "mode", "risk_level",
     "next step", "jDevFlow"), AC.B1.10 (KO pair sync for D1.x usage
     doc), AC.B1.1 (single-file consolidation D1.a+D1.b+D1.c).
   - Sec. 9-1 of Bundle 1 tech design permits inline Claude polish of
     decision-table cell wording during Stage 9 — apply sparingly and
     record every edit in the verdict section.
3. Append Stage 9 Bundle 1 verdict section to
   `docs/04_implementation/implementation_progress.md` (+ .ko.md) with
   per-AC verdict table, inline-polish list, and PASS / NEEDS REVISION
   decision.
4. Update HANDOFF.md Recent Changes (EN + KO mirror) via
   `scripts/update_handoff.sh --section both --write` (dogfood Bundle 4
   script).
5. Append `dev_history.md` Entry 3.10 (Stage 8 + 9 Bundle 1 close).
6. If PASS: set Bundle 1 verdict in HANDOFF YAML to the appropriate
   value (minor / bug_fix / design_level); validation-group-1 Stage 9
   gate now closed — ready for Stage 11 joint validation.
   If NEEDS REVISION: trigger Stage 10 — hand back to Codex with a
   focused revise prompt (prompts/codex/revise.md canonical template +
   specific findings list). Re-enter Stage 9 on the revised output.

Important M.3 invariant (do NOT violate):
- Stage 11 joint validation is a FRESH Claude session. Do NOT run Stage
  11 in this same session. At the end of Stage 9/10 close, the operator
  runs the Stage 11 prompt at prompts/claude/v03/stage11_joint_validation_prompt.md
  in a new Claude session with only the pre-compacted dossiers (DC.6).

Language policy reminders:
- EN primary + KO translation; KO updated at stage close (R4).
- New documents avoid the U+00A7 section-sign — use literal "Sec. " prefix.
- Stage 5+ docs carry YAML frontmatter (D4.x2). Stage 1–4 docs stay prose-only.

Announce "읽기 완료 — Stage 9 Bundle 1 시작 준비됨" once the reads are done,
then begin from AC.B1.1.
```

---
---

# 📋 HANDOFF — 세션 인계 문서 (한국어)

> **두 번째로 읽는 파일** (CLAUDE.md 다음).
> 매 세션 종료 시 반드시 업데이트하세요.

> ⚠️ **참고 (2026-04-22):** 이 파일은 현재 **jDevFlow v0.3 자기-dogfooding** 상태를
> 추적합니다 (옵션 1). 순수 템플릿 버전은 v0.3 릴리스 시
> `templates/HANDOFF.template.md`로 분리됩니다 (Bundle 4 — Doc discipline 설계 범위).
> 그 전까지 신규 프로젝트는 이 파일을 복사해서 상태 섹션을 수동으로 초기화하세요.

---

## 현재 상태

**현재 버전:** v0.3 (in progress)
**마지막 업데이트:** 2026-04-22 (UTC)
**워크플로우 모드:** Strict-hybrid
**현재 단계:** Stage 9 Bundle 1 ✅ PASS — minor; both bundles in validation group 1 now closed at Stage 9. Next: Stage 10/11 (Stage 11 = fresh Claude session per M.3). has_ui=false; risk_level=medium.
**has_ui:** false
**risk_level:** medium

### ✅ 완료
- [x] 프로젝트 초기화 (폴더, CLAUDE.md, WORKFLOW.md 존재 — v0.2 승계)
- [x] 언어 선택 완료: EN primary + KO translation (`plan_draft.md`부터 적용)
- [x] 보안 설정: v0.2 승계 (v0.3 범위 외)
- [x] Git 초기화 (v0.2 상태 승계)
- [x] **Stage 1 — 브레인스토밍** → `docs/01_brainstorm/brainstorm.md`
- [x] 모드 & 번들 선택: Strict-hybrid, Bundle 1 + Bundle 4
- [x] Validation group 선언: Group 1 = {Bundle 1, Bundle 4}
- [x] **Stage 2 — Plan Draft** → `docs/02_planning/plan_draft.md` (EN) + `plan_draft.ko.md` (KO)
- [x] 언어 정책 최초 적용: EN primary 작성, 같은 세션에 KO 페어 번역 커밋 (plan_draft Sec. 5-2 R4 규칙 준수)
- [x] **Stage 3 — Plan Review** → `docs/02_planning/plan_review.md` (EN) + `plan_review.ko.md` (KO). 판정: 4개 포커스 모두 PASS. plan_final로 8건 개정 포워드. 핵심 발견: **OQ.S11.2 (판정 분기 정책)는 Stage 4로의 진짜 leak** — committed 규칙 M.5로 승격.
- [x] **Stage 4 — Plan Final** → `docs/02_planning/plan_final.md` (EN) + `plan_final.ko.md` (KO). plan_review 개정 8건 전부 흡수. Approval checklist 7/7 ✅. Stage 4.5 제출 준비 완료.
- [x] **Stage 4.5 — 사용자 승인 게이트** ✅ APPROVED (2026-04-22, 세션 3 재개). Bundle 1 + 4 공동 승인 (M.1 충족, 부분 승인 없음). 두 번들 approval_status → approved. Stage 5 차단 해제.
- [x] **Pre-Stage-5 housekeeping (DC.5 + DC.6)** ✅ 완료 — `prompts/claude/v03/`에 3개 드래프트 저장:
  - `stage5_bundle4_design_prompt_draft.md` (DC.5 #1; DEP.1에 따라 Bundle 4 먼저)
  - `stage5_bundle1_design_prompt_draft.md` (DC.5 #2; Bundle 4 Sec. 0 잠금 게이트)
  - `stage11_joint_validation_prompt.md` (DC.6; dossier 기반 컨텍스트 전달 + M.3/M.5/M.6 강제)
- [x] **Stage 5 Bundle 4 — 기술 설계** ✅ 완료 (2026-04-22, 세션 3 재개) — `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN) + `technical_design.ko.md` (KO). Sec. 0 에서 D4.x2/x3/x4 잠금; AC.B4.1–16 수락 기준 열거; 12 섹션 Codex 핸드오프 부록; D4.x2 에 따른 YAML 프론트매터 적용; KO 동기화 체크 완료 (헤더 18/18, AC 16/16). **DEP.1 차단 해제** — Bundle 1 Stage 5 진입 가능.
- [x] **Stage 5 Bundle 1 — 기술 설계** ✅ 완료 (2026-04-22, 세션 3 재개) — `docs/03_design/bundle1_tool_picker/technical_design.md` (EN) + `technical_design.ko.md` (KO). Sec. 0 에서 Bundle 4 D4.x2/x3/x4 를 DEP.1 에 따라 원문 인용. 단일 파일 스킬 설계 (D1.a+D1.b+D1.c 를 한 SKILL.md ≤ 300 줄에) + D1.x `docs/notes/tool_picker_usage.md` 참조. 결정 테이블: stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high}. OQ1.1 (단일 파일), OQ1.2 (두 트리거, 단일 파이프라인), OQ1.3 (네이티브 API 없음) 해결. AC.B1.1–10 열거 (헤드라인: AC.B1.7 R2 읽기 전용 불변식). YAML 프론트매터 + KO 동기화 체크 완료 (헤더 17/17, AC 10/10).
- [x] **Stage 8 Codex 핸드오프 패키지 준비** ✅ (2026-04-22, 세션 3 재개, 세션-종료 housekeeping) — 신규 파일 4개:
  - `prompts/codex/v03/stage8_bundle4_codex_kickoff.md` — M.1 에 따라 Bundle 4 먼저 (Bundle 4 가 `docs/notes/decisions.md` 소유)
  - `prompts/codex/v03/stage8_bundle1_codex_kickoff.md` — Bundle 1 다음; Precondition checklist 로 Bundle 4 완료 게이트
  - `prompts/codex/v03/stage8_coordination_notes.md` — 실행 순서 / 단일-vs-2-세션 / 실패 escalation / 보고 형식
  - `prompts/claude/v03/session4_post_codex_resume_prompt.md` — Codex 작업 이후 Claude 세션 4 재개 프롬프트 (EN + KO 미러), Stage 9 진입
- [x] **Stage 8 Bundle 4 — Codex 구현** ✅ 완료 (2026-04-22, Codex 세션) — 14 개 산출물: `scripts/update_handoff.sh` (POSIX sh, 486 줄, shellcheck clean), `templates/HANDOFF.template.md`, `CHANGELOG.md` (KaC v1.1.0), `CODE_OF_CONDUCT.md` (Covenant v2.1), `CONTRIBUTING.md` (12 섹션 + F-a1 부록), `docs/notes/decisions.md` (+ `.ko.md`, D4.x2/x3/x4 quotable), `docs/04_implementation/implementation_progress.md` (+ `.ko.md`), `tests/run_bundle4.sh` + `tests/bundle4/` 아래 4 개 테스트 (전부 PASS). Codex 완료 보고서는 `prompts/codex/v03/stage8_bundle4_codex_report.md` 에 아카이브.
- [x] **Stage 9 Bundle 4 — Claude 코드 리뷰** ✅ **PASS — minor** (2026-04-22, 세션 4) — per-AC 판정 표가 `docs/04_implementation/implementation_progress.md` (+ `.ko.md`) 에 기록됨. 코드 변경 없음. 인라인 설계 보정: Bundle 4 `technical_design.md` Sec. 6 을 8 → 10 행으로 확장하고 `stdout 디스크리미네이터` 열 추가 (+ KO 쌍) — AC.B4.3 불일치 해소 (루브릭 "nine" = 9 개의 구분되는 `error=<key>` 디스크리미네이터, 이제 1:1 매핑). `dev_history.md` Entry 3.9 기록. Bundle 1 킥오프 Precondition checklist 3 개 모두 ticked.

### 🔄 진행 중
- **Stage 8 Bundle 1 Codex 실행 대기 중.** Bundle 4 쪽은 Stage 9 까지 완전 종료. Hyoungjin 이 다음으로 Bundle 1 킥오프 (`prompts/codex/v03/stage8_bundle1_codex_kickoff.md`) 실행 → 완료되면 `prompts/claude/v03/session5_post_codex_bundle1_resume_prompt.md` 로 **세션 5** 시작 → **Stage 9 Bundle 1 코드 리뷰** 진입 (M.3 불변식: 새 Claude 세션).

### ⏭️ 다음 (세션 5)
1. **Stage 8 Bundle 1 Codex 실행** (운영자 주도, Claude 외부) — `stage8_bundle1_codex_kickoff.md` 의 단일 paste 블록 실행. 기대 산출물: `.skills/tool-picker/SKILL.md` (D1.a+D1.b+D1.c, ≤ 300 줄) + `docs/notes/tool_picker_usage.md` (D1.x, ≤ 80 줄) + D1.x 의 KO 쌍 + 테스트 `tests/bundle1/test_skill_read_only.sh` + CLAUDE.md Read-order 1줄 편집 (Bundle 4 와 조정).
2. **Stage 9 Bundle 1 — Claude 코드 리뷰** (AC.B1.1–10 기준) (헤드라인: AC.B1.7 R2 읽기 전용 불변식 grep 테스트; AC.B1.3 ≤ 300 줄; AC.B1.4 프론트매터 mandatory triggers; AC.B1.10 KO 쌍 동기화). Sec. 9-1 "Claude polish" 허용 — 결정 테이블 문구 polish 는 Stage 9 인라인으로 가능.
3. **Stage 10** (NEEDS REVISION 시) → `prompts/codex/revise.md` + findings 리스트로 Codex 에 되돌려보냄 → Stage 9 재진입.
4. **Stage 11 공동 검증** — 양 번들 PASS 이후 — **새 Claude 세션** (M.3 불변식); 같은 세션에서 chain 금지. `prompts/claude/v03/stage11_joint_validation_prompt.md` 사용.

### 🚧 차단 요인
- 없음. Bundle 1 킥오프 3 개 Precondition 전부 충족 (Bundle 4 산출물 존재; `decisions.md` D4.x2/x3/x4 기록; `tests/run_bundle4.sh` green + Stage 9 PASS).

---

## 번들 (v0.3 범위)

상단 EN 섹션의 `bundles:` YAML 블록 참조. v0.3는 **Bundle 1 + Bundle 4** 두 개만 다루고,
Bundle 2·3는 v0.4로 이월.

- **Bundle 1** — tool-picker system (goals 7, 11, 12), risk medium-high
- **Bundle 4** — doc discipline (goals 5, 9, 10), risk low-medium
- **Validation Group 1** — {Bundle 1, Bundle 4} 공동 Stage 11 검증

---

## 최근 변경 이력

| 날짜 | 설명 |
|------|------|
| 2026-04-22 | Stage 9 Bundle 1 code review PASS — minor; 0 code changes, 0 inline polish edits; Entry 3.9 KO-mirror backfilled; Bundle 1 YAML bumped stage 1→9, verdict null→minor. |
| 2026-04-22 | Stage 9 Bundle 4 code review PASS; Sec. 6 of Bundle 4 technical_design expanded to 10 rows to resolve AC.B4.3 mismatch. |
| 2026-04-22 | Stage 1 브레인스토밍 완료: 모드 strict-hybrid, 번들 1+4 선택, validation group 1 선언, UI base-only 정책 확정 (v0.5 또는 첫 downstream has_ui=true 중 먼저) |
| 2026-04-22 | HANDOFF.md를 템플릿에서 v0.3 dogfooding 트래커로 전환 (옵션 1); 템플릿 분리는 Bundle 4로 이월 |
| 2026-04-22 | 세션 2: Stage 2 Plan Draft 완료 — `plan_draft.md` (EN) + `plan_draft.ko.md` (KO) 작성. 번들 통합 / kickoff goals·scope_extras 분리 유지 / 번들×스테이지 milestone 매트릭스 / 7개 항목 approval checklist (WORKFLOW Sec. 6 기본 4 + Strict-hybrid 추가 3) 사전 박음. 세션 3에서 Stage 3 재개. |
| 2026-04-22 | 세션 2: 운영 wiki `docs/notes/session_token_economics.md` 추가 — "현재 세션 유지 vs 새 세션 전환" 판단 프레임워크 (living doc). 이번 세션의 76% 사용량 하 실제 판단 사례에서 유도. KO 단독, EN 페어는 OSS 공개 시점에 추가. |
| 2026-04-22 | 세션 3: Stage 3 Plan Review 완료 — `plan_review.md` (EN) + `plan_review.ko.md` (KO). 4개 포커스 모두 PASS. plan_final로 8건 개정 포워드. 핵심 발견: **OQ.S11.2 (판정 분기 정책)는 진짜 Stage-4 leak** — commit된 규칙 M.5로 승격. DC.6 신규(Stage 11 kickoff 프롬프트), DEP.1 순서 표현 정밀화 등 2건의 추적성 업그레이드. UI 사용량 약 95% 시점에 Stage 4 진입 전에 조기 종료; Stage 4 작업은 `plan_review.md Sec. 6`에 사전 스테이징. |
| 2026-04-22 | 세션 3 (토큰 충전 후 재개): Stage 4 Plan Final 완료 — `plan_final.md` (EN) + `plan_final.ko.md` (KO). plan_review 개정 8건 전부 흡수 (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3). Approval checklist 7/7 ✅. Stage 4.5 승인 게이트 사용자에게 제출; 승인 전 Stage 5 차단. |
| 2026-04-22 | 세션 3 (재개): **Stage 4.5 사용자 승인 완료** (Bundle 1 + 4 공동, M.1 충족). 두 번들 `approval_status: approved`. Stage 5 차단 해제. 다음: DC.5 + DC.6 프롬프트 드래프트 → Stage 5 Bundle 4 (DEP.1 정밀화 기준) → Bundle 1. 메모: 신규 문서부터는 가독성을 위해 U+00A7 섹션 기호 사용 중단 (리터럴 "Sec. " 접두어로 대체). |
| 2026-04-22 | 세션 3 (재개): **DC.5 + DC.6 housekeeping 완료**. `prompts/claude/v03/` 하위에 3개 신규 파일: `stage5_bundle4_design_prompt_draft.md`, `stage5_bundle1_design_prompt_draft.md`, `stage11_joint_validation_prompt.md`. Bundle 4 프롬프트는 D4.x2–x4를 Sec. 0 잠금-우선 요구로 고정; Bundle 1 프롬프트는 Bundle 4 Sec. 0 존재를 하드 게이트; Stage 11 프롬프트는 pre-compacted dossier 포맷 확정 (OQ.S11.1 해결). 신규 파일은 U+00A7 사용 안 함. |
| 2026-04-22 | 세션 3 (재개): **`§ → Sec. ` 일괄 마이그레이션** — v0.3 작업 문서 8개 (plan_draft/review/final + KO 페어, HANDOFF.md, brainstorm.md). Canonical 프롬프트 템플릿은 v0.2 호환성 위해 보존. 변환 대상 파일 내 U+00A7 잔존 0건, double-space 아티팩트 0건. |
| 2026-04-22 | 세션 3 (재개): **`dev_history.md` backfill 완료** — EN + KO 페어. 세션 1/2/3 (충전 전후)를 stage 단위로 기록하고 entry 템플릿 포함. plan_final AN.3 + DC.2 부분 충족. 이후부터는 stage 종료 또는 중대 housekeeping 때마다 신규 entry 추가. |
| 2026-04-22 | 세션 3 (재개): **Stage 5 Bundle 4 기술 설계 완료** — `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN, 14 섹션, 약 640 줄) + `technical_design.ko.md` (KO 페어, R4 에 따라 같은 세션). **Sec. 0 에서 D4.x2 / D4.x3 / D4.x4 잠금** (Stage-5+ 문서에 YAML 프론트매터; `bundle{id}_{name}/` snake_case 폴더; 항상 현재 파일 기준 상대경로 + GitHub 앵커 슬러그) — DEP.1 충족, Bundle 1 Stage 5 차단 해제. OQ.N1, OQ4.1, OQ4.2, OQ.H2, OQ.L2 Stage-9 half 해결. 수락 기준 AC.B4.1–16 열거. 양쪽 파일이 D4.x2 에 따른 YAML 프론트매터 소유; KO 동기화 체크 완료 (헤더 18/18, AC 16/16). |
| 2026-04-22 | 세션 3 (재개): **Stage 5 Bundle 1 기술 설계 완료** — `docs/03_design/bundle1_tool_picker/technical_design.md` (EN, 14 섹션) + `technical_design.ko.md` (KO 페어, R4 에 따라 같은 세션). Sec. 0 에서 Bundle 4 D4.x2/x3/x4 를 DEP.1 에 따라 원문 인용. 단일 파일 `.skills/tool-picker/SKILL.md` 범위 (D1.a+D1.b+D1.c 를 한 파일 ≤ 300 줄) + D1.x `docs/notes/tool_picker_usage.md` 참조. 결정 테이블: stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high}. OQ1.1/1.2/1.3 해결. AC.B1.1–10 열거 (헤드라인: AC.B1.7 R2 읽기 전용 불변식). YAML 프론트매터 적용; KO 동기화 체크 완료 (헤더 17/17, AC 10/10). **양 번들 Stage 5 모두 완료**; Stage 6–7 n/a (has_ui=false); 다음 stage = Stage 8 Codex 구현. |
| 2026-04-22 | 세션 3 (재개, 종료): **Stage 8 Codex 핸드오프 패키지 준비** — `prompts/codex/v03/` 하위 3 개 파일 (Bundle 4 킥오프, Bundle 1 킥오프, coordination notes) + `prompts/claude/v03/` 하위 1 개 파일 (Codex 작업 이후 세션-4 재개 프롬프트, EN + KO 미러). 실행 순서 고정: Bundle 4 먼저 (`docs/notes/decisions.md` 소유), Bundle 1 다음 (Precondition checklist 게이트). Codex 완료 보고서를 재개 프롬프트에 붙여넣으면 Claude 세션 4 가 Stage 9 코드 리뷰 진입. |

---

## 주요 문서 링크

| 문서 | 단계 | 상태 |
|------|------|------|
| `docs/01_brainstorm/brainstorm.md` | Stage 1 | ✅ 완료 (2026-04-22) |
| `docs/02_planning/plan_draft.md` | Stage 2 | ✅ 완료 (2026-04-22, 세션 2) |
| `docs/02_planning/plan_draft.ko.md` | Stage 2 (KO) | ✅ 완료 (2026-04-22, 세션 2) |
| `docs/02_planning/plan_review.md` | Stage 3 | ✅ 완료 (2026-04-22, 세션 3) |
| `docs/02_planning/plan_review.ko.md` | Stage 3 (KO) | ✅ 완료 (2026-04-22, 세션 3) |
| `docs/02_planning/plan_final.md` | Stage 4 | ✅ 완료 (2026-04-22, 세션 3 재개) — Stage 4.5 승인 |
| `docs/02_planning/plan_final.ko.md` | Stage 4 (KO) | ✅ 완료 (2026-04-22, 세션 3 재개) — Stage 4.5 승인 |
| `docs/03_design/bundle1_tool_picker/technical_design.md` | Stage 5 | ✅ 완료 (2026-04-22, 세션 3 재개) — EN + KO 페어, AC.B1.1–10 열거 |
| `docs/03_design/bundle4_doc_discipline/technical_design.md` | Stage 5 | ✅ 완료 (2026-04-22, 세션 3 재개) — EN + KO 페어, D4.x2/x3/x4 잠금 |
| `docs/04_implementation/implementation_progress.md` | Stage 8~10 | ⬜ 미시작 |
| `docs/notes/final_validation.md` | Stage 11 | ⬜ 미시작 (Group 1 공동 검증) |
| `docs/05_qa_release/qa_scenarios.md` | Stage 12 | ⬜ 미시작 |
| `docs/notes/dev_history.md` | 전체 | ✅ Backfill 완료 (2026-04-22, 세션 3 재개) — EN + KO 페어 |
| `prompts/claude/v03_kickoff.md` | Stage 0 | ✅ 참조 |

---

## 📋 다음 세션 시작 프롬프트

> 다음 Claude 세션 (**세션 5**, Codex Stage 8 Bundle 1 실행 이후) 시작 시 복사해서 붙여넣으세요.
> 독립 파일 사본: `prompts/claude/v03/session5_post_codex_bundle1_resume_prompt.md` (EN + KO 미러).
>
> 이 Claude 프롬프트를 실행하기 전에 Hyoungjin 이 Codex 작업 **1건**을 먼저 수행:
> 1. Bundle 1 만 — `prompts/codex/v03/stage8_bundle1_codex_kickoff.md`
>    (Bundle 4 Stage 8 + Stage 9 는 이미 종료; Bundle 1 Precondition 전부 ticked.)
> 2. 조정 참고 (여전히 적용됨 — 동일 실패-escalation 규칙) — `prompts/codex/v03/stage8_coordination_notes.md`
> 3. Codex 의 Bundle 1 완료 보고서는 `prompts/codex/v03/stage8_bundle1_codex_report.md` 에
>    아카이브 (Bundle 4 아카이브 패턴 동일).

```
jDevFlow v0.3 이어서 진행해줘 (세션 5 — Codex Bundle 1 작업 이후 재개).

다음 순서로 먼저 읽어줘:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md  (특히 Sec. 10 Stage 9, 10, 11, 12, 13)
4. docs/notes/dev_history.md  (최신 Entry: 3.9 — Stage 8 + 9 Bundle 4 종료)
5. docs/03_design/bundle1_tool_picker/technical_design.md     (AC.B1.1–10 루브릭 — 이번 세션의 PRIMARY 스펙)
6. docs/04_implementation/implementation_progress.md          (Stage 8 Bundle 4 로그 + Stage 9 Bundle 4 판정; Bundle 1 로그는 이번 세션에 Codex 가 추가)
7. prompts/codex/v03/stage8_bundle1_codex_report.md           (아카이브된 Codex Bundle 1 paste, 존재 시)
8. Codex 가 Bundle 1 로 생성한 것: 트리 스킴 —
   find .skills docs/notes/tool_picker_usage.md docs/notes/tool_picker_usage.ko.md tests/bundle1 -maxdepth 3 2>/dev/null

경로: ~/projects/Jonelab_Platform/jDevFlow/

이번 세션 특이사항 (템플릿 대비 델타):
- Bundle 4 는 Stage 9 까지 종료 (PASS — minor, 2026-04-22). Bundle 4 리뷰 섹션 전부 스킵.
- 이번 세션은 AC.B1.1–10 기준 Bundle 1 만 리뷰.
- Bundle 1 산출물은 아직 untracked. Stage 9 PASS 판정 후에만 정식 커밋.
- Codex Stage 8 Bundle 1 보고서 아카이브 위치 (인라인 paste 아님):
  prompts/codex/v03/stage8_bundle1_codex_report.md
- Codex 가 보고서에 non-trivial judgement call 을 플래그했다면, Stage 9 에서
  처분 결정 (accept / rubric 정정 / 설계 문서 정정). Stage 9 Bundle 4 선례:
  AC.B4.3 nine-error-cases 불일치를 Bundle 4 설계 Sec. 6 인라인 확장으로 해소
  (Option b).

현재 상태:
- 워크플로우 모드: Strict-hybrid
- Validation group 1 = {Bundle 1 tool-picker, Bundle 4 doc-discipline (옵션 β)}
- Stage 1–5 완료; Stage 6–7 스킵 (has_ui=false)
- Stage 8 Bundle 4 완료; Stage 9 Bundle 4 = PASS — minor
- Stage 8 Bundle 1: 아래 CODEX 보고서 참조
- has_ui=false, risk_level=medium-high (Bundle 1)

=== CODEX STAGE 8 완료 보고서 — BUNDLE 1 ===
[Codex 의 Bundle 1 완료 보고서를 여기 붙여넣기, 또는 미실행이면 "pending"]

이 세션에서 할 작업: Stage 9 Bundle 1 코드 리뷰 (AC.B1.1–10).

Stage 9 Bundle 1 계획:
1. Codex Bundle 1 산출물 읽기: `.skills/tool-picker/SKILL.md`,
   `docs/notes/tool_picker_usage.{md,ko.md}`, `tests/bundle1/*`,
   CLAUDE.md Read-order 1줄 편집.
2. AC.B1.1–10 per-AC 판정.
   - 헤드라인: AC.B1.7 (R2 읽기 전용 불변식 grep 테스트 — 패턴
     `'\b(bash|sh |python|node|eval|exec |curl|wget)\b'` 매치는 code fence
     또는 quoted example output 안에서만 허용), AC.B1.3 (SKILL.md ≤ 300 줄;
     분할 말고 escalate), AC.B1.4 (프론트매터 mandatory-trigger 키워드:
     "stage", "mode", "risk_level", "next step", "jDevFlow"), AC.B1.10
     (D1.x 사용 문서 KO 쌍 동기화), AC.B1.1 (단일 파일 통합
     D1.a+D1.b+D1.c).
   - Bundle 1 기술 설계 Sec. 9-1 은 Stage 9 중 결정 테이블 셀 문구
     인라인 Claude polish 허용 — 절제 있게 적용하고 판정 섹션에 모든
     편집 기록.
3. Stage 9 Bundle 1 판정 섹션을 `docs/04_implementation/implementation_progress.md`
   (+ .ko.md) 에 추가 — per-AC 판정 표, 인라인 polish 리스트, PASS /
   NEEDS REVISION 결정.
4. HANDOFF.md 최근 변경 이력 (EN + KO 미러) 을
   `scripts/update_handoff.sh --section both --write` 로 갱신 (Bundle 4
   스크립트 dogfooding).
5. `dev_history.md` Entry 3.10 (Stage 8 + 9 Bundle 1 종료) 추가.
6. PASS 시: HANDOFF YAML 의 Bundle 1 verdict 를 적절한 값 (minor /
   bug_fix / design_level) 으로 설정; validation-group-1 Stage 9 게이트
   종료 → Stage 11 공동 검증 준비 완료.
   NEEDS REVISION 시: Stage 10 진입 — focused revise 프롬프트로 Codex 에
   되돌려보냄 (prompts/codex/revise.md 표준 템플릿 + 구체적 findings
   리스트). 수정본으로 Stage 9 재진입.

M.3 불변식 준수 (위반 금지):
- Stage 11 공동 검증은 반드시 새 Claude 세션. 같은 세션에서 chain 금지.
  Stage 9/10 종료 시 운영자가 prompts/claude/v03/stage11_joint_validation_prompt.md
  프롬프트를 새 Claude 세션에서 실행; DC.6 pre-compacted dossier 만 컨텍스트로 제공.

언어 정책 상기:
- EN primary + KO translation; KO 는 stage 종료 시 업데이트 (R4).
- 신규 문서는 U+00A7 섹션 기호 사용 안 함 — 리터럴 "Sec. " 접두어 사용.
- Stage 5 이후 문서에 YAML 프론트매터 (D4.x2). Stage 1–4 는 prose-only 유지.

읽기 끝나면 "읽기 완료 — Stage 9 Bundle 1 시작 준비됨" 알리고, AC.B1.1 부터 시작.
```
