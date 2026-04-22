# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- None yet.

### Changed
- None yet.

### Deprecated
- None yet.

### Removed
- None yet.

### Fixed
- None yet.

### Security
- None yet.

### Planned for v0.4 (retrospective + simplification release — meta scope, no feature adds)
- **Retrospective** on v0.3 dogfooding experience: catalogue concrete friction points from the 7-session v0.3 build (13 stages × 2 bundles × EN+KO × validation groups × M.1/M.3/M.5/M.6 gates × AC matrices × D4.x frontmatter × R4 freshness × R2 read-only invariant × dual harness).
- **Simplification pass** on the workflow itself — with the working hypothesis that the "default" mode should be materially lighter than v0.3's Strict-hybrid. Candidates for demotion / merger / removal: validation-group joint gates, R4 EN+KO sync rule, D4.x frontmatter, M.3 fresh-session requirement, per-AC cross-bundle matrices, dual EN/KO dev_history.
- **Deliverable shape (tentative)**: one brainstorm doc + one simplification proposal doc; minimal code changes; no new bundles. v0.4 acts as the self-test of "can jDevFlow release something lightly?"

### Planned for v0.5 (inherited backlog from original v0.3 Stage 13 deferrals — feature work resumes)
- Live tool-picker triple refresh in `.skills/tool-picker/SKILL.md` Sec. 6 (AC.B1.5 hygiene; pick the current HANDOFF triple at v0.5 Stage 1).
- `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 verbatim-paste refresh of D4.x2/x3/x4 (AC.B1.8 tightening).
- Install `shellcheck` in the Linux CI runner so `shellcheck -S style scripts/update_handoff.sh` replaces the v0.3 proxy (`sh -n` + `dash -n` + `bash -n`). See `docs/05_qa_release/release_checklist.md` Sec. 1.1 row 1.f.
- Automate mac-side CI (`bash tests/bundle1/run_bundle1.sh`, `sh tests/run_bundle4.sh`, `shellcheck -S style scripts/update_handoff.sh`) so Stage 13 no longer requires an operator paste (v0.3 used release_checklist.md Sec. 1.1 rows 1.g–1.i manual paste).
- Bundle 2 (metadata-refinement, goals 1/2/3) and Bundle 3 (codex-handoff-UX, goals 4/6/8) — re-scope based on v0.3 real-world use (deferred from v0.3; now carried further to sit behind v0.4 simplification decisions).
- Move the v0.2-compatibility `§` section-sign off canonical prompt templates (kept verbatim for v0.2 cross-version use during v0.3).
- **UI base-only policy sunset** — per v0.3 brainstorm Sec. 9 / plan_final: UI base-only stays in effect through v0.5 or first downstream `has_ui=true`, whichever comes first. v0.5 is the nominal sunset anchor.

## [0.3.0] - 2026-04-22

> Released 2026-04-22 (UTC) under a single joint `v0.3` git tag per plan_final M.6. Validation Group 1 = Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β).

### Added

- **Bundle 1 — tool-picker skill** (single-file Anthropic Skill at `.skills/tool-picker/SKILL.md`, 173 lines) with an 8-section body and a decision table covering every `stage × (mode, risk)` intersection across `Standard | Strict | Strict-hybrid` × `medium | medium-high`.
- **Bundle 1 — D1.x reference** `docs/notes/tool_picker_usage.md` + `.ko.md` (46 lines each), the usage companion to the skill.
- **Bundle 4 — POSIX-sh handoff updater** `scripts/update_handoff.sh` (486 lines, shellcheck-clean) with nine discriminated `error=<key>` stdout codes and `.bak.<ts>.<pid>` rollback on failure.
- **Bundle 4 — HANDOFF template** `templates/HANDOFF.template.md`.
- **Bundle 4 — contributor onboarding** `CODE_OF_CONDUCT.md` (Contributor Covenant v2.1), `CONTRIBUTING.md` (12 sections + F-a1 appendix).
- **Bundle 4 — D4.x2/x3/x4 decision ledger** `docs/notes/decisions.md` + `.ko.md` (quotable, verbatim-referenced from Bundle 1 SKILL.md).
- **Bundle 4 — documentation discipline** YAML frontmatter on every Stage-5+ doc (D4.x2), `^bundle(\d+)_(.+)$` folder convention (D4.x3), relative-link + GitHub-anchor rules (D4.x4).
- **Workflow artefacts** `docs/01_brainstorm/`, `docs/02_planning/` (plan_draft/plan_review/plan_final, EN + KO), `docs/03_design/bundle1_tool_picker/technical_design.md` + `bundle4_doc_discipline/technical_design.md` (EN + KO each), `docs/04_implementation/implementation_progress.md` + `.ko.md`, `docs/notes/stage11_dossiers/{bundle1,bundle4,ko_freshness}.md`, `docs/notes/final_validation.md` + `.ko.md`, `docs/05_qa_release/qa_scenarios.md` + `.ko.md`, `docs/05_qa_release/release_checklist.md` + `.ko.md`.
- **Test harnesses** `tests/bundle1/run_bundle1.sh` (10 checks) and `tests/run_bundle4.sh` + `tests/bundle4/test_0{1..4}_*.sh` (4 tests).
- **Kickoff prompts** `prompts/claude/v03/stage5_*_draft.md`, `prompts/claude/v03/stage11_joint_validation_prompt.md`, `prompts/claude/v03/stage12_qa_release_prompt.md`, `prompts/codex/v03/stage8_{bundle1,bundle4,coordination_notes,*_report}.md`.
- **Changelog & SemVer policy** This file, following Keep a Changelog v1.1.0 + SemVer v2.0.0.

### Changed

- **Workflow stages 11/13 semantics** — plan_final M.3 requires a fresh Claude session for Stage 11; M.5 group verdict = worst-of-two; M.6 releases Validation Group 1 under a single joint tag.
- **CLAUDE.md read order** now routes to `.skills/tool-picker/SKILL.md` as the decision surface.

### Fixed

- **AC.B1.6/B1.8 row label swap** in `docs/04_implementation/implementation_progress.md` Stage 9 Bundle 1 verdict table (Stage 12 housekeeping).
- **`rg` → `grep -E`** swap in `tests/bundle1/run_bundle1.sh` line 53 — removes the ripgrep dependency so the harness is POSIX-clean end-to-end (Stage 12 housekeeping).

### Deferred to v0.5 (originally queued for v0.4; reindexed 2026-04-23 when v0.4 was redefined as a retrospective/simplification release)

- Live tool-picker triple refresh in `.skills/tool-picker/SKILL.md` Sec. 6 (Stage 11 non-blocking forward).
- `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 verbatim-paste refresh of D4.x2/x3/x4 (AC.B1.8 tightening, Stage 11 non-blocking forward).

### CI / release prerequisites (run before final tag)

- `shellcheck -S style scripts/update_handoff.sh` on mac + Linux.
- Full test matrix on mac + Linux for both harnesses.
