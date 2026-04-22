# Stage 12 — QA & Release Prep (Validation Group 1) — Session Kickoff Prompt

> **Owner:** 🧪 QA author + 🧰 housekeeper (Claude, Opus · High effort)
> **Scope:** validation_group = 1 = { Bundle 1 tool-picker, Bundle 4 doc-discipline } — joint per M.6
> **Primary output:** `docs/05_qa_release/qa_scenarios.md` (+ `.ko.md` per R4)
> **Secondary outputs:** housekeeping forwards from `docs/notes/final_validation.md` Sec. 3; `CHANGELOG.md` `[0.3.0]` entry; Stage 13 release plan
> **When:** after Stage 11 APPROVED (Group verdict = M.5 worst-of-two = APPROVED on 2026-04-22, session 6).
> **Need NOT be a fresh session** — unlike Stage 11. May reuse prior context (context-budget pressure at Stage 12 is low: no cross-bundle verdict required, no dossier compaction).

---

## Why this prompt exists (v0.3 context)

- Stage 11 ended APPROVED with a small list of explicitly-forwarded non-blocking items (`final_validation.md` Sec. 3). Stage 12 is where those get discharged.
- Stage 12 is also where the joint release artefacts are prepared: `qa_scenarios.md`, `[0.3.0]` CHANGELOG, release plan.
- Stage 13 will ship a **single joint `v0.3` git tag** per plan_final Sec. 4 M.6.
- Unlike Stage 11, Stage 12 has no divergent-verdict policy — the bundles travel together from here to release.

---

## Copy-paste this at the start of the Stage 12 session

```
Start Stage 12 — QA & Release prep for jDevFlow v0.3, validation_group = 1 (joint per M.6).

Read first, in order:
1. CLAUDE.md
2. HANDOFF.md (verify Stage 11 = APPROVED, both bundles stage=11 verdict=minor)
3. WORKFLOW.md (Sec. 15 Stage 12 + Sec. 16 Stage 13)
4. docs/notes/final_validation.md (approved verdicts + forwarded non-blocking items — Sec. 3 is the Stage 12 punch list)
5. docs/02_planning/plan_final.md Sec. 4 (M.6 single-joint-tag rule)

Project path: ~/projects/Jonelab_Platform/jDevFlow/
Mode: Strict-hybrid · Effort: High
has_ui: false
Bundles in scope: 1 (tool-picker) + 4 (doc-discipline, option β) — joint release per M.6

Pre-flight checks (do NOT skip):
- `git status` — confirm clean tree (Stage 11 close commit already in: see `d453ea1` or equivalent).
- Re-run `bash tests/bundle1/run_bundle1.sh` (expect 10/10 PASS) and `sh tests/run_bundle4.sh` (expect 4/4 PASS).

Your task — in this order:

1. QA SCENARIOS (primary Stage 12 output, WORKFLOW Sec. 15):
   - Author `docs/05_qa_release/qa_scenarios.md` covering both bundles.
   - Apply D4.x2 YAML frontmatter (stage: 12, bundle: 1+4, language: en, paired_with: qa_scenarios.ko.md, etc.).
   - Mirror to `docs/05_qa_release/qa_scenarios.ko.md` within the same session (R4).

2. HOUSEKEEPING FORWARDS (from final_validation.md Sec. 3):
   - Bundle 1:
     a) Swap `rg` → `grep -E` at `tests/bundle1/run_bundle1.sh` line 53 (or document ripgrep dependency in CI notes).
     b) Fix AC.B1.6 ↔ AC.B1.8 row-label swap in `docs/04_implementation/implementation_progress.md` Stage 9 Bundle 1 verdict table.
     c) (Optional) Refresh `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 to paste D4.x2/x3/x4 verbatim (tighten AC.B1.8 beyond current paraphrase).
     d) (Optional) Refresh `.skills/tool-picker/SKILL.md` Sec. 6 worked example onto a live Stage-12 triple.
   - Bundle 4:
     a) Run `shellcheck -S style scripts/update_handoff.sh` on mac + Linux CI container (Stage 9/11 sandbox lacked shellcheck).
     b) Run `tests/run_bundle4.sh` and `tests/bundle1/run_bundle1.sh` on both mac and Linux (AC.B4.13 CI matrix forward).

3. RELEASE PREP (Stage 13 feeder):
   - Author `[0.3.0]` entry in `CHANGELOG.md` per Keep a Changelog v1.1.0 (AC.B4.14).
     Sections: Added, Changed (if any), Removed (if any). Date = Stage 13 tag date (leave as TBD placeholder until tag day).
   - Plan the single joint `v0.3` git tag per M.6. Document the release-checklist items in `docs/05_qa_release/release_checklist.md` (+ `.ko.md`).

4. HANDOFF UPDATES:
   - Move Stage 12 items from "Next" to "Completed" as they land.
   - Promote Stage 13 to "In Progress" once `qa_scenarios.md` + `CHANGELOG.md [0.3.0]` are in.

Language policy: EN primary + KO pair at stage close (R4). Stage 5+ docs carry D4.x2 frontmatter.

Session-close git policy: CLAUDE.md subsection applies — ask user at close whether to commit now or defer.
```

---

## Input surfaces (no dossier needed)

Stage 12 can read directly (no pre-compaction required):

- `docs/notes/final_validation.md` Sec. 3 — authoritative punch list.
- `docs/03_design/bundle1_tool_picker/technical_design.md` — Bundle 1 AC reference.
- `docs/03_design/bundle4_doc_discipline/technical_design.md` — Bundle 4 AC reference.
- `docs/notes/decisions.md` — D4.x2/x3/x4 verbatim, linked from both SKILL.md and qa_scenarios.
- `tests/bundle1/run_bundle1.sh` + `tests/run_bundle4.sh` + all `tests/bundle{1,4}/test_*.sh` — test harness for QA scenario grounding.
- `scripts/update_handoff.sh` — shellcheck subject.

---

## Acceptance criteria for Stage 12 close

This session closes when **all** of the following are true:

- [ ] `docs/05_qa_release/qa_scenarios.md` + `.ko.md` authored, D4.x2 frontmatter applied.
- [ ] `tests/bundle1/run_bundle1.sh` line 53 ripgrep dep is either swapped to `grep -E` or explicitly documented in CI notes.
- [ ] `docs/04_implementation/implementation_progress.md` (+ `.ko.md`) Stage 9 Bundle 1 table row labels corrected.
- [ ] `CHANGELOG.md` `[0.3.0]` entry authored (date placeholder allowed).
- [ ] `docs/05_qa_release/release_checklist.md` + `.ko.md` drafted with Stage 13 tag plan.
- [ ] HANDOFF.md + `dev_history.md` (+ `.ko.md`) updated with Stage 12 close entry.
- [ ] Both test suites still green.

Optional (deferrable to early Stage 13 housekeeping if time-boxed): tech_design Sec. 0 verbatim refresh (AC.B1.8 tightening); SKILL.md Sec. 6 live-triple refresh; shellcheck on mac+Linux CI (requires CI runner, may genuinely need to wait for Stage 13 pre-tag CI run).

---

## Relationship to Stage 13

Stage 13 (per WORKFLOW Sec. 16 + plan_final M.6) will:
- Cut a single joint `v0.3` git tag (not per-bundle tags).
- Finalize `CHANGELOG.md` `[0.3.0]` with the real tag date.
- Run pre-tag CI matrix (shellcheck + both OSes) if not completed in Stage 12.

Stage 12's job is to make Stage 13 mechanical: no new decisions, no design drift, just tag + publish.

---

## Revision log

- v1 (2026-04-22, session 6 close): initial authoring after Stage 11 APPROVED. Paired with Next Session Prompt block in HANDOFF.md.
