# 📋 HANDOFF — Session State

> **Read this second**, after CLAUDE.md.
> Update this file at the end of every session.
> Korean version below (한국어 버전: 파일 하단)

> ⚠️ **Note (2026-04-22):** This file currently tracks **jOneFlow's own v0.3 dogfooding**
> state (Option 1). A clean template version will be separated into
> `templates/HANDOFF.template.md` at v0.3 release (Bundle 4 — Doc discipline scope).
> Until then, new projects should copy this file and clear state sections manually.

---

## Status

**Current version:** v0.3 (in progress)
**Last updated:** 2026-04-22 (UTC)
**Workflow mode:** Strict-hybrid
**Current stage:** Stage 12 ✅ **complete** (QA & Release prep, session 6 continuation, 2026-04-22). `docs/05_qa_release/qa_scenarios.md` (+ `.ko.md`) and `docs/05_qa_release/release_checklist.md` (+ `.ko.md`) authored; `CHANGELOG.md` `[0.3.0]` entry drafted (TBD tag date); Stage 11 non-blocking housekeeping discharged on-tree (rg→grep -E, AC.B1.6/B1.8 label swap). Stage 13 is the release tag gate; CI matrix forwards (shellcheck, mac+Linux) remain the only pre-tag prerequisites. has_ui=false; risk_level=medium.
> ⚠️ **Uncommitted Stage 12 work on disk** (per user choice to defer commit under CLAUDE.md "Session close — git policy"). Stage 13 session must **first** commit the Stage 12 close artefacts before any new work. Expected modified/untracked set: `CHANGELOG.md`, `HANDOFF.md`, `docs/04_implementation/implementation_progress.md` (+ `.ko.md`), `docs/notes/dev_history.md` (+ `.ko.md`), `tests/bundle1/run_bundle1.sh`, `docs/05_qa_release/` (new folder), `prompts/claude/v03/stage12_qa_release_prompt.md` (new). Stage 11 close commit `d453ea1` is the parent.
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
- [x] **Stage 9 Bundle 1 — Claude code review** ✅ **PASS — minor** (2026-04-22, session 5) — per-AC verdict table in `docs/04_implementation/implementation_progress.md` (+ `.ko.md`). 0 code changes, 0 inline polish edits; accepted 4 Codex judgement calls (AC.B1.3 6-column expansion, AC.B1.4 `to be created at Stage 11` marker, AC.B1.7 zero-match grep, AC.B1.10 structural-sync proxy). Entry 3.10 recorded; `dev_history.ko.md` Entry 3.9 backfilled. Validation group 1 Stage 9 gate closed (bundle 4 minor + bundle 1 minor).
- [x] **Stage 10 skipped** (both bundles PASS — minor; no revision required per WORKFLOW Sec. 10 Stage 10 "if NEEDS REVISION").
- [x] **Stage 11 prep housekeeping** ✅ complete (2026-04-22, session 5 continued) — DC.6 dossiers produced:
  - `docs/notes/stage11_dossiers/bundle1_dossier.md` (135 lines, ≤ 1 page prose + pinned key-diff blocks)
  - `docs/notes/stage11_dossiers/bundle4_dossier.md` (173 lines, ≤ 1 page prose + pinned key-diff blocks)
  - `docs/notes/stage11_dossiers/ko_freshness.md` (scratch KO-freshness table, pre-populated for validator cross-check)
  - `CLAUDE.md` "Session close — git policy" subsection added near cross-tool handoff rule (uncommitted on-disk — bundled into next commit per user's defer choice branch 2).
  - Bundle 1 + Bundle 4 test harnesses re-run: `tests/bundle1/run_bundle1.sh` 10/10 PASS; `tests/run_bundle4.sh` 4/4 PASS.
- [x] **Stage 11 — Joint Final Validation** ✅ **APPROVED** (2026-04-22, session 6, fresh session per M.3) — `docs/notes/final_validation.md` (EN) + `final_validation.ko.md` (KO) emitted. Bundle 1 verdict = APPROVED; Bundle 4 verdict = APPROVED; Group (M.5 worst-of-two) = APPROVED. Cross-bundle checks pass: AC.B4.10 (SKILL.md lines 34–72 verbatim-match decisions.md lines 24–62, char-for-char); AC.B4.11 (0 Markdown-link matches in SKILL.md ⇒ D4.x4 vacuous-by-construction; backlinks inside the verbatim block already use D4.x4 form); D1.b↔D4.x2/x3/x4 parser contract intact. KO freshness table independently re-verified — 7 pairs, 0-day delta across the board. 4 non-blocking items forwarded to Stage 12 housekeeping (Bundle 1: worked-example live-state refresh, `rg` dep in tests/bundle1/run_bundle1.sh, AC.B1.6/B1.8 label swap in implementation_progress.md, AC.B1.8 tech_design Sec. 0 paraphrase-vs-verbatim hygiene; Bundle 4: shellcheck -S style to CI, mac+Linux CI matrix, 0.3.0 CHANGELOG entry at Stage 12). No blocking findings.
- [x] **Stage 11 close commit** ✅ (2026-04-22, session 6 continuation) — commit `d453ea1` bundled 9 files: `CLAUDE.md`, `HANDOFF.md`, `docs/notes/dev_history.{md,ko.md}`, `docs/notes/final_validation.{md,ko.md}`, `docs/notes/stage11_dossiers/{bundle1_dossier,bundle4_dossier,ko_freshness}.md` (+804/−199). Used inline `git -c user.name/email` flags to avoid modifying global config.
- [x] **Stage 12 — QA & Release prep** ✅ complete (2026-04-22, session 6 continuation) — new files: `docs/05_qa_release/qa_scenarios.md` + `.ko.md` (H1–H4 happy paths + F1–F6 failure scenarios; AC mapping); `docs/05_qa_release/release_checklist.md` + `.ko.md` (Stage 13 tag gate); `CHANGELOG.md` `[0.3.0]` entry (Keep a Changelog v1.1.0, date = TBD); `prompts/claude/v03/stage12_qa_release_prompt.md`. Housekeeping discharged on-tree: `rg` → `grep -E` swap in `tests/bundle1/run_bundle1.sh` line 53 (removes ripgrep dep, POSIX-clean); AC.B1.6/B1.8 row-label swap fixed in `docs/04_implementation/implementation_progress.md` (+ `.ko.md`). Both harnesses re-run green after every edit (Bundle 1: 10/10 PASS; Bundle 4: 4/4 PASS). Optional refreshes (SKILL.md Sec. 6 live triple, tech_design Sec. 0 verbatim) deferred to v0.4 per CHANGELOG `[0.3.0]` "Deferred to v0.4". CI forwards (shellcheck, mac+Linux matrix) remain Stage 13 pre-tag prerequisites.

### 🔄 In Progress
- **Stage 13 (Release tag).** Per plan_final M.6, Stage 13 ships a single joint `v0.3` git tag. Gate: `docs/05_qa_release/release_checklist.md` fully ticked. Only pre-tag prerequisites left are CI forwards (shellcheck on mac+Linux; full test matrix on both OSes) and finalising the TBD date in `CHANGELOG.md` `[0.3.0]`.

### ⏭️ Next (session 7 — Stage 13 Release tag)
1. **CI matrix** — run `shellcheck -S style scripts/update_handoff.sh` on mac + Linux; run `tests/bundle1/run_bundle1.sh` and `tests/run_bundle4.sh` on both OSes. Record results on `release_checklist.md`.
2. **Finalise CHANGELOG** — replace `[0.3.0]` `TBD` date with the real tag date; reset `[Unreleased]` section to empty stubs.
3. **Cut the tag** — `git tag -a v0.3 -m "..."` per `release_checklist.md` Sec. 5; push tag to origin; open GitHub release with `[0.3.0]` body.
4. **Post-release** — update HANDOFF status line to "v0.3 released; v0.4 planning open"; append post-release entry to `dev_history.md` (EN + KO) with actual tag SHA + date; seed v0.4 backlog from `CHANGELOG.md` "Deferred to v0.4".
5. **Session-close git policy** — per CLAUDE.md subsection, ask user whether to commit Stage 12 close artefacts now or defer.

### 🚧 Blockers
- None. Stage 12 closed; Stage 13 tag gate awaits CI matrix + TBD-date finalisation.

---

## Bundles (v0.3 scope)

```yaml
bundles:
  - id: 1
    name: tool-picker
    goals: [7, 11, 12]          # from prompts/claude/v03_kickoff.md
    risk_level: medium-high
    stage: 12                    # Stage 12 closed 2026-04-22 (QA & Release prep complete)
    verdict: minor               # Stage 11 carry-forward: Stage 9 minor + no Stage 11 blocking finding
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
    stage: 12                        # Stage 12 closed 2026-04-22 (QA & Release prep complete)
    verdict: minor                   # Stage 11 carry-forward: Stage 9 minor + no Stage 11 blocking finding
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
| 2026-04-22 | **Stage 12 QA & Release prep complete** (session 6 continuation, same chat window). New: `docs/05_qa_release/qa_scenarios.md` + `.ko.md` (H1–H4 happy + F1–F6 failure scenarios, full AC mapping), `docs/05_qa_release/release_checklist.md` + `.ko.md` (Stage 13 tag gate), `CHANGELOG.md` `[0.3.0]` section (KaC v1.1.0, TBD date), `prompts/claude/v03/stage12_qa_release_prompt.md` canonical. Housekeeping discharged on-tree: `rg` → `grep -E` swap in `tests/bundle1/run_bundle1.sh` line 53 (removes ripgrep dep), AC.B1.6/B1.8 label swap fix in `implementation_progress.md` (+ `.ko.md`). Both harnesses re-run green (Bundle 1: 10/10, Bundle 4: 4/4). Optional Stage 11 forwards (SKILL.md Sec. 6 live triple, tech_design Sec. 0 verbatim refresh) deferred to v0.4. CI forwards (shellcheck + mac+Linux matrix) remain Stage 13 pre-tag prerequisites. |
| 2026-04-22 | **Stage 11 close commit** `d453ea1` — bundled 9 files (CLAUDE.md session-close git policy, HANDOFF.md, dev_history {md,ko.md}, final_validation {md,ko.md}, stage11_dossiers/{bundle1,bundle4,ko_freshness}.md) into one commit: +804/−199. Used inline `git -c user.name/email` flags per git safety protocol. |
| 2026-04-22 | **Stage 11 joint validation APPROVED** (session 6, fresh Claude session per M.3). Group verdict (M.5 worst-of-two) = APPROVED. Bundle 1 = APPROVED, Bundle 4 = APPROVED. `docs/notes/final_validation.md` (EN) + `final_validation.ko.md` (KO) emitted under DC.6. Cross-bundle contracts verified: AC.B4.10 (SKILL.md verbatim from decisions.md), AC.B4.11 (D4.x4 link conventions — vacuous-by-construction). KO freshness independently re-verified (7 pairs, 0-day delta). 4 non-blocking items forwarded to Stage 12 housekeeping; 3 Bundle-4 items remain as CI/Stage-12 forwards (shellcheck -S style, mac+Linux CI matrix, 0.3.0 CHANGELOG entry). Stage 12 unblocked; Stage 13 ships single joint `v0.3` git tag per M.6. Uncommitted-edits decision deferred to user per CLAUDE.md "Session close — git policy". |
| 2026-04-22 | Stage 11 prep complete: `bundle1_dossier.md` + `bundle4_dossier.md` + `ko_freshness.md` produced under `docs/notes/stage11_dossiers/`; Stage 10 skipped (both bundles PASS — minor); CLAUDE.md "Session close — git policy" subsection added (uncommitted on-disk, bundled into next commit per user defer choice); both bundles' test harnesses re-run green. |
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
| `docs/04_implementation/implementation_progress.md` | Stage 8–10 | ✅ Stage 9 verdicts recorded (2026-04-22, sessions 4+5) — EN + KO pair |
| `docs/notes/final_validation.md` | Stage 11 | ✅ Complete (2026-04-22, session 6) — Group 1 joint validation APPROVED, EN + KO pair |
| `docs/05_qa_release/qa_scenarios.md` | Stage 12 | ✅ Complete (2026-04-22, session 6 continuation) — EN + KO pair, H1–H4 + F1–F6 scenarios |
| `docs/05_qa_release/release_checklist.md` | Stage 12 | ✅ Complete (2026-04-22, session 6 continuation) — EN + KO pair, Stage 13 tag gate |
| `CHANGELOG.md` | Stage 12 | ✅ `[0.3.0]` drafted (2026-04-22) — TBD date, finalise at Stage 13 tag time |
| `docs/notes/dev_history.md` | All | ✅ Backfilled + Entry 3.13 Stage 12 close (2026-04-22) — EN + KO pair |
| `prompts/claude/v03_kickoff.md` | Stage 0 | ✅ Reference |

---

## 📋 Next Session Prompt

> Copy and paste this at the start of your next Claude session — **session 7 = Stage 13 Release tag (single joint `v0.3` per M.6)**.
> Canonical structure reference: `WORKFLOW.md` Sec. 16 (Stage 13); tag gate = `docs/05_qa_release/release_checklist.md`.
>
> **Stage 11 and Stage 12 are CLOSED** as of 2026-04-22 session 6 (Stage 11 APPROVED; Stage 12 prep complete). All primary artefacts are on-tree: `docs/05_qa_release/qa_scenarios.md` + `.ko.md`, `docs/05_qa_release/release_checklist.md` + `.ko.md`, `CHANGELOG.md` `[0.3.0]` (TBD date). Two Stage 11 housekeeping forwards discharged in Stage 12: `rg` → `grep -E` swap, AC.B1.6/B1.8 label swap fix.
>
> **Uncommitted-edits flag (at session-6 close):** Stage 12 artefacts (`HANDOFF.md`, `CHANGELOG.md`, `docs/04_implementation/implementation_progress.{md,ko.md}`, `docs/notes/dev_history.{md,ko.md}`, `tests/bundle1/run_bundle1.sh`, `docs/05_qa_release/*.md`, `prompts/claude/v03/stage12_qa_release_prompt.md`) are **uncommitted on disk by user choice** (defer per CLAUDE.md "Session close — git policy"). Stage 13 session **must first** create a Stage 12 close commit (parent = `d453ea1`) before any new work; see release_checklist.md Sec. 4 and pre-flight below.

```
Start Stage 13 — Release tag for jOneFlow v0.3, validation_group = 1 (single joint tag per M.6).

Read first, in order:
1. CLAUDE.md
2. HANDOFF.md (verify Stage 12 = complete, Stage 13 blockers = CI matrix + TBD date only)
3. WORKFLOW.md (Sec. 16 Stage 13)
4. docs/05_qa_release/release_checklist.md (authoritative tag gate — work through it)
5. docs/05_qa_release/qa_scenarios.md (H1–H4 must PASS on tag candidate commit; F1–F6 are documented procedures)
6. CHANGELOG.md [0.3.0] (finalise TBD → real tag date)

Project path: ~/projects/Jonelab_Platform/jOneFlow/
Mode: Strict-hybrid · Effort: Medium (release mechanics, not design)
has_ui: false
Bundles in scope: 1 (tool-picker) + 4 (doc-discipline, option β) — single joint `v0.3` tag

Pre-flight checks (do NOT skip):
- `git status` — expect the Stage 12 uncommitted set listed in HANDOFF.md Status block. **First action: create the Stage 12 close commit** (parent = `d453ea1`) with message "Stage 12 QA & Release prep close — validation_group 1 (sessions 6 continuation)". Do NOT fold Stage 12 into the Stage 13 tag commit.
- Re-run `bash tests/bundle1/run_bundle1.sh` (10/10) and `sh tests/run_bundle4.sh` (4/4) on the Stage 12 close commit (which becomes the tag candidate's parent).

Your task — in this order (follow release_checklist.md):

1. CI MATRIX (release_checklist.md Sec. 1):
   - `shellcheck -S style scripts/update_handoff.sh` on mac + Linux.
   - Both test harnesses on mac + Linux.
   - Record results in release_checklist.md. If shellcheck unavailable, use documented proxy (sh -n + dash -n) AND open v0.4 issue.

2. QA GATES (release_checklist.md Sec. 2):
   - Verify H1–H4 scenarios pass on tag candidate.
   - Confirm F1–F6 procedures are current in qa_scenarios.md.

3. DOC GATES (release_checklist.md Sec. 3):
   - Replace CHANGELOG [0.3.0] "TBD" with real tag date.
   - Reset [Unreleased] section to empty stubs.
   - Update HANDOFF status + dev_history (EN + KO) with Stage 13 close entry.

4. TAG (release_checklist.md Sec. 5):
   - `git tag -a v0.3 -m "jOneFlow v0.3 — Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β); joint release per M.6"`
   - Push tag; open GitHub release from [0.3.0] body.

5. POST-RELEASE (release_checklist.md Sec. 6):
   - HANDOFF status → "v0.3 released; v0.4 planning open".
   - dev_history post-release entry with actual tag SHA.
   - Seed v0.4 backlog from CHANGELOG "Deferred to v0.4".

Language policy: EN primary + KO pair at stage close (R4). Stage 5+ docs carry D4.x2 frontmatter.

Session-close git policy: CLAUDE.md subsection applies — ask user at close whether to commit now or defer.
```

---
---

# 📋 HANDOFF — 세션 인계 문서 (한국어)

> **두 번째로 읽는 파일** (CLAUDE.md 다음).
> 매 세션 종료 시 반드시 업데이트하세요.

> ⚠️ **참고 (2026-04-22):** 이 파일은 현재 **jOneFlow v0.3 자기-dogfooding** 상태를
> 추적합니다 (옵션 1). 순수 템플릿 버전은 v0.3 릴리스 시
> `templates/HANDOFF.template.md`로 분리됩니다 (Bundle 4 — Doc discipline 설계 범위).
> 그 전까지 신규 프로젝트는 이 파일을 복사해서 상태 섹션을 수동으로 초기화하세요.

---

## 현재 상태

**현재 버전:** v0.3 (in progress)
**마지막 업데이트:** 2026-04-22 (UTC)
**워크플로우 모드:** Strict-hybrid
**현재 단계:** Stage 12 ✅ **완료** (QA & Release 준비, 세션 6 연속, 2026-04-22). `docs/05_qa_release/qa_scenarios.md` (+ `.ko.md`) 및 `docs/05_qa_release/release_checklist.md` (+ `.ko.md`) 작성; `CHANGELOG.md` `[0.3.0]` 엔트리 초안 (TBD 태그 날짜); Stage 11 non-blocking housekeeping 트리에 랜딩 (rg→grep -E, AC.B1.6/B1.8 레이블 swap). Stage 13 은 릴리스 태그 게이트; CI 매트릭스 forward (shellcheck, mac+Linux) 가 남은 유일한 pre-tag 전제조건. has_ui=false; risk_level=medium.
> ⚠️ **Stage 12 작업이 디스크에 uncommitted 상태** (사용자가 CLAUDE.md "Session close — git policy" 에 따라 커밋을 defer 선택). Stage 13 세션은 **맨 먼저** Stage 12 close 산출물을 커밋한 후 신규 작업 진행. 예상 modified/untracked 집합: `CHANGELOG.md`, `HANDOFF.md`, `docs/04_implementation/implementation_progress.md` (+ `.ko.md`), `docs/notes/dev_history.md` (+ `.ko.md`), `tests/bundle1/run_bundle1.sh`, `docs/05_qa_release/` (신규 폴더), `prompts/claude/v03/stage12_qa_release_prompt.md` (신규). Stage 11 close 커밋 `d453ea1` 이 부모.
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
- [x] **Stage 9 Bundle 1 — Claude 코드 리뷰** ✅ **PASS — minor** (2026-04-22, 세션 5) — per-AC 판정 표가 `docs/04_implementation/implementation_progress.md` (+ `.ko.md`) 에 기록됨. 코드 변경 0건, 인라인 polish 편집 0건; Codex 판정 4건 수락 (AC.B1.3 6열 확장, AC.B1.4 `to be created at Stage 11` 마커, AC.B1.7 0-매치 grep, AC.B1.10 구조 동기 프록시). Entry 3.10 기록; `dev_history.ko.md` Entry 3.9 백필. Validation group 1 의 Stage 9 게이트 종료 (번들 4 minor + 번들 1 minor).
- [x] **Stage 10 생략** (두 번들 모두 PASS — minor; WORKFLOW Sec. 10 Stage 10 "NEEDS REVISION 시" 조건 미충족이므로 revision 불필요).
- [x] **Stage 11 prep housekeeping** ✅ 완료 (2026-04-22, 세션 5 연속) — DC.6 dossier 산출:
  - `docs/notes/stage11_dossiers/bundle1_dossier.md` (135 줄, ≤ 1 쪽 prose + pinned key-diff 블록)
  - `docs/notes/stage11_dossiers/bundle4_dossier.md` (173 줄, ≤ 1 쪽 prose + pinned key-diff 블록)
  - `docs/notes/stage11_dossiers/ko_freshness.md` (KO 동기 검증용 스크래치 표, 사전 채움)
  - `CLAUDE.md` "Session close — git policy" 서브섹션을 cross-tool handoff rule 근처에 추가 (디스크 상 uncommitted — 사용자 defer 선택 branch 2 에 따라 다음 커밋에 번들).
  - Bundle 1 + Bundle 4 테스트 하네스 재실행: `tests/bundle1/run_bundle1.sh` 10/10 PASS; `tests/run_bundle4.sh` 4/4 PASS.
- [x] **Stage 11 — 공동 최종 검증** ✅ **APPROVED** (2026-04-22, 세션 6, M.3 에 따른 새 세션) — `docs/notes/final_validation.md` (EN) + `final_validation.ko.md` (KO) 발행. Bundle 1 판정 = APPROVED; Bundle 4 판정 = APPROVED; 그룹 (M.5 worst-of-two) = APPROVED. Cross-bundle 점검 PASS: AC.B4.10 (SKILL.md 34–72 행이 decisions.md 24–62 행과 문자 단위 verbatim 일치); AC.B4.11 (SKILL.md 에 Markdown 링크 0 매치 ⇒ D4.x4 vacuous-by-construction; verbatim 블록 내부의 backlink 는 이미 D4.x4 형식 사용); D1.b↔D4.x2/x3/x4 파서 계약 유지. KO freshness 표 독립 재검증 — 7 페어, 전역 0일 델타. 4 건의 non-blocking 항목을 Stage 12 housekeeping 으로 forward (Bundle 1: worked-example live-state refresh, tests/bundle1/run_bundle1.sh 의 `rg` 의존성, implementation_progress.md 의 AC.B1.6/B1.8 레이블 swap, tech_design Sec. 0 의 AC.B1.8 paraphrase-vs-verbatim 위생; Bundle 4: shellcheck -S style CI 재실행, mac+Linux CI 매트릭스, 0.3.0 CHANGELOG entry Stage 12). Blocking 발견 없음.
- [x] **Stage 11 close 커밋** ✅ (2026-04-22, 세션 6 연속) — 커밋 `d453ea1` 가 9 파일 번들 (CLAUDE.md, HANDOFF.md, dev_history {md,ko.md}, final_validation {md,ko.md}, stage11_dossiers/{bundle1,bundle4,ko_freshness}.md): +804/−199. git 안전 정책에 따라 inline `git -c user.name/email` 플래그 사용 (global config 미수정).
- [x] **Stage 12 — QA & Release 준비** ✅ 완료 (2026-04-22, 세션 6 연속) — 신규 파일: `docs/05_qa_release/qa_scenarios.md` + `.ko.md` (H1–H4 happy + F1–F6 실패 시나리오, AC 매핑 완비), `docs/05_qa_release/release_checklist.md` + `.ko.md` (Stage 13 태그 게이트), `CHANGELOG.md` `[0.3.0]` 엔트리 (KaC v1.1.0, 날짜 TBD), `prompts/claude/v03/stage12_qa_release_prompt.md` 정본. Housekeeping 트리에 랜딩: `tests/bundle1/run_bundle1.sh` 53 행의 `rg` → `grep -E` 스왑 (ripgrep 의존성 제거, POSIX-clean), `docs/04_implementation/implementation_progress.md` (+ `.ko.md`) 의 AC.B1.6/B1.8 행 레이블 swap 수정. 모든 편집 후 양 하네스 재실행 green (Bundle 1: 10/10 PASS; Bundle 4: 4/4 PASS). Optional refresh (SKILL.md Sec. 6 live triple, tech_design Sec. 0 verbatim) 는 CHANGELOG `[0.3.0]` "Deferred to v0.4" 에 따라 v0.4 로 연기. CI forward (shellcheck, mac+Linux 매트릭스) 는 Stage 13 pre-tag 전제조건으로 유지.

### 🔄 진행 중
- **Stage 13 (릴리스 태그).** plan_final M.6 에 따라 Stage 13 은 단일 공동 `v0.3` git tag 발행. 게이트: `docs/05_qa_release/release_checklist.md` 전부 체크. 남은 pre-tag 전제조건은 CI forward (shellcheck mac+Linux; 전체 테스트 매트릭스 양 OS) 및 `CHANGELOG.md` `[0.3.0]` 의 TBD 날짜 확정뿐.

### ⏭️ 다음 (세션 7 — Stage 13 릴리스 태그)
1. **CI 매트릭스** — `shellcheck -S style scripts/update_handoff.sh` mac + Linux 실행; `tests/bundle1/run_bundle1.sh` 와 `tests/run_bundle4.sh` 양 OS 실행. `release_checklist.md` 에 결과 기록.
2. **CHANGELOG 확정** — `[0.3.0]` `TBD` 를 실제 태그 날짜로 교체; `[Unreleased]` 섹션을 빈 stub 으로 리셋.
3. **태그 커팅** — `release_checklist.md` Sec. 5 에 따라 `git tag -a v0.3 -m "..."` ; origin 에 푸시; `[0.3.0]` 본문으로 GitHub 릴리스 오픈.
4. **릴리스 후** — HANDOFF 상태 라인을 "v0.3 released; v0.4 planning open" 으로; 실제 태그 SHA + 날짜로 `dev_history.md` (EN + KO) 에 post-release 엔트리; `CHANGELOG.md` "Deferred to v0.4" 로부터 v0.4 백로그 seed.
5. **세션 종료 git 정책** — CLAUDE.md 서브섹션에 따라 사용자에게 Stage 12 close 산출물을 지금 커밋할지 defer 할지 질문.

### 🚧 차단 요인
- 없음. Stage 12 종료; Stage 13 태그 게이트는 CI 매트릭스 + TBD 날짜 확정만 남음.

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
| 2026-04-22 | **Stage 12 QA & Release 준비 완료** (세션 6 연속, 같은 대화창). 신규: `docs/05_qa_release/qa_scenarios.md` + `.ko.md` (H1–H4 happy + F1–F6 실패 시나리오, AC 매핑 완비), `docs/05_qa_release/release_checklist.md` + `.ko.md` (Stage 13 태그 게이트), `CHANGELOG.md` `[0.3.0]` 섹션 (KaC v1.1.0, 날짜 TBD), `prompts/claude/v03/stage12_qa_release_prompt.md` 정본. Housekeeping 트리 랜딩: `tests/bundle1/run_bundle1.sh` 53 행의 `rg` → `grep -E` 스왑 (ripgrep 의존성 제거), `implementation_progress.md` (+ `.ko.md`) 의 AC.B1.6/B1.8 레이블 swap 수정. 양 하네스 재실행 green (Bundle 1: 10/10, Bundle 4: 4/4). Optional Stage 11 forward (SKILL.md Sec. 6 live triple, tech_design Sec. 0 verbatim refresh) 는 v0.4 로 연기. CI forward (shellcheck + mac+Linux 매트릭스) 는 Stage 13 pre-tag 전제조건 유지. |
| 2026-04-22 | **Stage 11 close 커밋** `d453ea1` — 9 파일 번들 (CLAUDE.md 세션 종료 git 정책, HANDOFF.md, dev_history {md,ko.md}, final_validation {md,ko.md}, stage11_dossiers/{bundle1,bundle4,ko_freshness}.md) 를 단일 커밋으로: +804/−199. git 안전 정책에 따라 inline `git -c user.name/email` 플래그 사용. |
| 2026-04-22 | **Stage 11 공동 검증 APPROVED** (세션 6, M.3 에 따른 새 Claude 세션). 그룹 판정 (M.5 worst-of-two) = APPROVED. Bundle 1 = APPROVED, Bundle 4 = APPROVED. `docs/notes/final_validation.md` (EN) + `final_validation.ko.md` (KO) 를 DC.6 에 따라 발행. Cross-bundle 계약 검증: AC.B4.10 (SKILL.md 가 decisions.md 에서 verbatim 인용), AC.B4.11 (D4.x4 링크 컨벤션 — vacuous-by-construction). KO freshness 독립 재검증 (7 페어, 0일 델타). 4 건의 non-blocking 항목을 Stage 12 housekeeping 으로 forward; Bundle 4 에서 3 건은 CI/Stage-12 forward 로 유지 (shellcheck -S style, mac+Linux CI 매트릭스, 0.3.0 CHANGELOG entry). Stage 12 차단 해제; Stage 13 은 M.6 에 따라 단일 공동 `v0.3` git tag 릴리스. Uncommitted 편집 처리는 CLAUDE.md "Session close — git policy" 에 따라 사용자에게 질문 이월. |
| 2026-04-22 | Stage 11 prep 완료: `bundle1_dossier.md` + `bundle4_dossier.md` + `ko_freshness.md` 을 `docs/notes/stage11_dossiers/` 에 산출; Stage 10 생략 (두 번들 PASS — minor); CLAUDE.md "Session close — git policy" 서브섹션 추가 (디스크 상 uncommitted, 사용자 defer 선택에 따라 다음 커밋에 번들); 두 번들 테스트 하네스 재실행 green. |
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
| `docs/04_implementation/implementation_progress.md` | Stage 8~10 | ✅ Stage 9 판정 기록 완료 (2026-04-22, 세션 4+5) — EN + KO 페어 |
| `docs/notes/final_validation.md` | Stage 11 | ✅ 완료 (2026-04-22, 세션 6) — Group 1 공동 검증 APPROVED, EN + KO 페어 |
| `docs/05_qa_release/qa_scenarios.md` | Stage 12 | ✅ 완료 (2026-04-22, 세션 6 연속) — EN + KO 페어, H1–H4 + F1–F6 시나리오 |
| `docs/05_qa_release/release_checklist.md` | Stage 12 | ✅ 완료 (2026-04-22, 세션 6 연속) — EN + KO 페어, Stage 13 태그 게이트 |
| `CHANGELOG.md` | Stage 12 | ✅ `[0.3.0]` 초안 (2026-04-22) — TBD 날짜, Stage 13 태그 시점에 확정 |
| `docs/notes/dev_history.md` | 전체 | ✅ Backfill 완료 + Entry 3.13 Stage 12 close (2026-04-22) — EN + KO 페어 |
| `prompts/claude/v03_kickoff.md` | Stage 0 | ✅ 참조 |

---

## 📋 다음 세션 시작 프롬프트

> 다음 Claude 세션 — **세션 7 = Stage 13 릴리스 태그 (M.6 에 따른 단일 공동 `v0.3`)** — 시작 시 복사해서 붙여넣으세요.
> 표준 구조 참조: `WORKFLOW.md` Sec. 16 (Stage 13); 태그 게이트 = `docs/05_qa_release/release_checklist.md`.
>
> **Stage 11 과 Stage 12 는 2026-04-22 세션 6 에 종료** (Stage 11 APPROVED; Stage 12 준비 완료). 주 산출물 전부 트리에: `docs/05_qa_release/qa_scenarios.md` + `.ko.md`, `docs/05_qa_release/release_checklist.md` + `.ko.md`, `CHANGELOG.md` `[0.3.0]` (TBD 날짜). Stage 11 housekeeping forward 2 건을 Stage 12 에서 처리: `rg` → `grep -E` 스왑, AC.B1.6/B1.8 레이블 swap 수정.
>
> **Uncommitted 편집 플래그 (세션 6 종료 시):** Stage 12 산출물 (`HANDOFF.md`, `CHANGELOG.md`, `docs/04_implementation/implementation_progress.{md,ko.md}`, `docs/notes/dev_history.{md,ko.md}`, `tests/bundle1/run_bundle1.sh`, `docs/05_qa_release/*.md`, `prompts/claude/v03/stage12_qa_release_prompt.md`) 이 **사용자 선택에 따라 디스크에 uncommitted** (CLAUDE.md "Session close — git policy" 의 defer 옵션). Stage 13 세션은 **반드시 맨 먼저** Stage 12 close 커밋을 생성 (부모 = `d453ea1`) 한 후 신규 작업 진행; pre-flight 및 release_checklist.md Sec. 4 참조.

```
Start Stage 13 — Release tag for jOneFlow v0.3, validation_group = 1 (single joint tag per M.6).

Read first, in order:
1. CLAUDE.md
2. HANDOFF.md (verify Stage 12 = complete, Stage 13 blockers = CI matrix + TBD date only)
3. WORKFLOW.md (Sec. 16 Stage 13)
4. docs/05_qa_release/release_checklist.md (authoritative tag gate — work through it)
5. docs/05_qa_release/qa_scenarios.md (H1–H4 must PASS on tag candidate commit; F1–F6 are documented procedures)
6. CHANGELOG.md [0.3.0] (finalise TBD → real tag date)

Project path: ~/projects/Jonelab_Platform/jOneFlow/
Mode: Strict-hybrid · Effort: Medium (release mechanics, not design)
has_ui: false
Bundles in scope: 1 (tool-picker) + 4 (doc-discipline, option β) — single joint `v0.3` tag

Pre-flight checks (do NOT skip):
- `git status` — expect the Stage 12 uncommitted set listed in HANDOFF.md Status block. **First action: create the Stage 12 close commit** (parent = `d453ea1`) with message "Stage 12 QA & Release prep close — validation_group 1 (sessions 6 continuation)". Do NOT fold Stage 12 into the Stage 13 tag commit.
- Re-run `bash tests/bundle1/run_bundle1.sh` (10/10) and `sh tests/run_bundle4.sh` (4/4) on the Stage 12 close commit (which becomes the tag candidate's parent).

Your task — in this order (follow release_checklist.md):

1. CI MATRIX (release_checklist.md Sec. 1):
   - `shellcheck -S style scripts/update_handoff.sh` on mac + Linux.
   - Both test harnesses on mac + Linux.
   - Record results in release_checklist.md. If shellcheck unavailable, use documented proxy (sh -n + dash -n) AND open v0.4 issue.

2. QA GATES (release_checklist.md Sec. 2):
   - Verify H1–H4 scenarios pass on tag candidate.
   - Confirm F1–F6 procedures are current in qa_scenarios.md.

3. DOC GATES (release_checklist.md Sec. 3):
   - Replace CHANGELOG [0.3.0] "TBD" with real tag date.
   - Reset [Unreleased] section to empty stubs.
   - Update HANDOFF status + dev_history (EN + KO) with Stage 13 close entry.

4. TAG (release_checklist.md Sec. 5):
   - `git tag -a v0.3 -m "jOneFlow v0.3 — Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β); joint release per M.6"`
   - Push tag; open GitHub release from [0.3.0] body.

5. POST-RELEASE (release_checklist.md Sec. 6):
   - HANDOFF status → "v0.3 released; v0.4 planning open".
   - dev_history post-release entry with actual tag SHA.
   - Seed v0.4 backlog from CHANGELOG "Deferred to v0.4".

Language policy: EN primary + KO pair at stage close (R4). Stage 5+ docs carry D4.x2 frontmatter.

Session-close git policy: CLAUDE.md subsection applies — ask user at close whether to commit now or defer.
```
