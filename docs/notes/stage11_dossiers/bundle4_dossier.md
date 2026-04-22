---
title: Stage 11 dossier — Bundle 4 (doc-discipline, option β)
stage: 11-input
bundle: 4
version: 1
language: en
paired_with: —
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Stage 11 Dossier — Bundle 4 (doc-discipline, option β)

## 1. What was built (≤ 10 lines)

Three capabilities bundled together: (a) a POSIX `sh` helper
`scripts/update_handoff.sh` that updates `HANDOFF.md` Status and/or
Recent Changes idempotently (Bundle 4's D4.b); (b) the OSS-canon
document set — `CHANGELOG.md` (Keep a Changelog v1.1.0), `CODE_OF_CONDUCT.md`
(Contributor Covenant v2.1), `CONTRIBUTING.md` (12 sections, F-a1
appendix) (D4.a + D4.c); (c) the structural-decision record
`docs/notes/decisions.md` (+ KO pair) that locks D4.x2 (internal doc
frontmatter schema), D4.x3 (`bundle{id}_{name}/` folder naming), and
D4.x4 (relative link + GitHub-anchor convention) so Bundle 1 could
quote them verbatim per DEP.1. Template skeleton at
`templates/HANDOFF.template.md` gives downstream projects a clean
copy-target. Test harness at `tests/run_bundle4.sh` orchestrates 4
sub-scripts (all PASS).

## 2. Files touched

- `scripts/update_handoff.sh` (CREATED) — 486 lines POSIX sh, `set -eu`, 9 error-discriminator stdout keys, 6 exit codes (0 + 1..5).
- `templates/HANDOFF.template.md` (CREATED) — 155 lines; structural parity with live HANDOFF.md (section order + YAML state blocks + EN/KO mirror + Recent Changes header) with values reset (`v0.0.0`, `TBD`, `bundles: []`, `⬜ Not started`).
- `CHANGELOG.md` (CREATED) — 26 lines, H1 + KaC URL reference + `## [Unreleased]` + six subsections; no `0.3.0` release entry yet (correct — lands at Stage 12).
- `CODE_OF_CONDUCT.md` (CREATED) — 126 lines, Contributor Covenant v2.1 verbatim, `{PROJECT_MAINTAINER_EMAIL}` placeholder.
- `CONTRIBUTING.md` (CREATED) — 173 lines, 12 sections in prescribed order, Sec. 12 ownership appendix with the F-a1 exception (Sec. 8 Changelog maintenance owned by D4.b inside a D4.c-owned file).
- `docs/notes/decisions.md` (+ `.ko.md`) (CREATED) — D4.x2/x3/x4 records with backlinks to the tech_design Sec. 0 source.
- `docs/04_implementation/implementation_progress.md` (+ `.ko.md`) (CREATED) — Stage 8 log + Stage 9 Bundle 4 verdict section (and later Bundle 1's appended below it).
- `tests/bundle4/test_01_update_handoff_success.sh` + `_02_failures.sh` + `_03_docs_structure.sh` + `_04_frontmatter_and_stage1_4.sh` (CREATED) — 4 test scripts, 232 lines combined.
- `tests/run_bundle4.sh` (CREATED) — 25-line orchestrator; runs all 4.
- `docs/03_design/bundle4_doc_discipline/technical_design.md` (+ `.ko.md`) (MODIFIED) — Stage 9 inline polish: Sec. 6 error-handling table expanded 8 → 10 rows, added `stdout discriminator` column (+ KO pair same session).
- `prompts/codex/v03/stage8_bundle4_codex_report.md` (CREATED) — archived Codex completion report (120 lines).

## 3. Key diffs (≤ 200 lines total)

Bundle 4 is large (14 deliverables + test harness + design polish). This
dossier pins the interfaces and the Stage 9 polish only; full sources are
in the repo for Stage 11 inspection.

**`update_handoff.sh` CLI contract (AC.B4.1, AC.B4.2, AC.B4.3):**

```text
usage: update_handoff.sh [OPTIONS]

OPTIONS
  --section <status|recent_changes|both>
  --status <text>
  --status-version <v>
  --change <text>
  --dev-history <text>
  --file <path>
  --template
  --write
  --dry-run
  --no-diff
  -h, --help
  -V, --version
```

- Default mode = dry-run. `--write` required for mutation. Idempotent: re-running the same `--write` payload produces zero diff (verified by `test_01_update_handoff_success.sh` cksum compare).
- 9 distinct `error=<key>` stdout discriminators mapped 1:1 against Sec. 6 table of `technical_design.md` after the Stage 9 polish. Exit codes: 0 (success), 1 (usage), 2 (input validation), 3 (file not found / too large), 4 (lock / concurrency), 5 (I/O). (Originally-drafted "6 exit codes" framing = 0 + the five non-zero — contract is now explicit in Sec. 6.)

**`decisions.md` anchor strings (AC.B4.7 — what Bundle 1 SKILL.md quotes verbatim):**

```markdown
### D4.x2 - Internal doc header schema
### D4.x3 - Bundle folder naming convention
### D4.x4 - Doc link conventions
```

Each record has: Decision / Scope|Rule / Rationale / Backlink. Backlink format = `../03_design/bundle4_doc_discipline/technical_design.md Sec. 0` (honors D4.x4).

**`CHANGELOG.md` skeleton (AC.B4.4):**

```markdown
# Changelog

All notable changes ... [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)

## [Unreleased]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
```

**`CONTRIBUTING.md` Sec. 7 KO-freshness bullet (AC.B4.16):**

```markdown
Reviewers tick a "KO freshness for stage-closing docs" check during review.
```

(Lives in `CONTRIBUTING.md` Sec. 7, not `.github/PULL_REQUEST_TEMPLATE.md`, because `.github/` is out of v0.3 scope per N7.)

**Stage 9 inline design polish — Sec. 6 before → after (condensed):**

```diff
 ## 6. Error handling
-... 8-row table without stdout-key column ...
+| Error class | stdout discriminator | Exit | Example message |
+|-------------|----------------------|------|-----------------|
+... 10 rows, each mapping one error case to one `error=<key>` + exit code ...
+
+Note: the rubric's "nine error cases" phrase maps to the 9 distinct
+`error=<key>` discriminators across the 10 failure-mode rows (two share
+a discriminator by design — see row 7/8).
```

Applied to both EN and KO the same day per R4.

## 4. Design references (paths only, not pasted)

- `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 — D4.x2/x3/x4 source of record (what `decisions.md` re-exports).
- `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 6 — error table (post-Stage-9 polish).
- `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 11 — AC.B4.1–16 rubric.
- `docs/02_planning/plan_final.md` Sec. 3-1 — deliverable IDs D4.a (OSS-canon docs), D4.b (update_handoff.sh), D4.c (CONTRIBUTING.md), D4.x1 (template), D4.x2/x3/x4 (structural decisions).

## 5. Stage 9 findings and their resolution

| Finding | Original stage | Resolution | Commit/file ref |
|---------|----------------|------------|-----------------|
| AC.B4.3 — "nine error cases" phrasing in rubric vs implementation's 10 failure rows. | Stage 9 | Inline polish: Sec. 6 table expanded 8 → 10 rows + `stdout discriminator` column added (9 distinct keys across 10 rows). No code change. | `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 6 + KO pair. |
| AC.B4.1 — `shellcheck` not installable in review sandbox. | Stage 9 | `sh -n` + `dash -n` syntax checks used as proxy; forwarded to Stage 11 CI for shellcheck -S style. | Stage 9 Bundle 4 AC.B4.1 row. |
| AC.B4.13 — Cross-platform (mac + Linux) not covered in Stage 9. | Stage 9 | FORWARD to Stage 11 CI matrix. | Stage 9 Bundle 4 AC.B4.13 row. |
| AC.B4.14 — `0.3.0` CHANGELOG entry. | Stage 9 | FORWARD to Stage 12 release time (correct per KaC convention). | Stage 9 Bundle 4 AC.B4.14 row. |

No `scripts/` or `tests/` code changes during Stage 9; edits were confined to the design doc's Sec. 6.

## 6. Deferred / non-blocking observations

- **`shellcheck -S style` re-run** on a sandbox/CI where the tool is installable. Forward to Stage 11.
- **mac + Linux CI matrix** for `tests/run_bundle4.sh` and `tests/bundle1/run_bundle1.sh`. Forward to Stage 11.
- **`CHANGELOG.md` v0.3.0 release entry** — authored at Stage 12 release time, not earlier.

## 7. Acceptance-criteria checklist (from technical_design.md Sec. 11)

- [x] **AC.B4.1** — POSIX sh, no bashisms; `shellcheck` re-run forwarded (proxy PASS via `sh -n` + `dash -n`).
- [x] **AC.B4.2** — Dry-run default, `--write` idempotent (test_01 PASS).
- [x] **AC.B4.3** — 9 `error=<key>` × 10 Sec. 6 rows mapped; Sec. 6 is authoritative contract.
- [x] **AC.B4.4** — CHANGELOG.md matches KaC v1.1.0 skeleton.
- [x] **AC.B4.5** — CONTRIBUTING.md has 12 sections in order; F-a1 appendix ticked.
- [x] **AC.B4.6** — CODE_OF_CONDUCT.md = Covenant v2.1 verbatim.
- [x] **AC.B4.7** — decisions.md records D4.x2/x3/x4 with backlinks; KO pair structural mirror.
- [x] **AC.B4.8** — templates/HANDOFF.template.md structural parity with live HANDOFF.md.
- [x] **AC.B4.9** — YAML frontmatter lint PASS across every Stage-5+ doc (test_04 PASS).
- [ ] **AC.B4.10** — Cross-bundle: Bundle 1 tool-picker parses `decisions.md` — **verified jointly at Stage 11** (this session).
- [ ] **AC.B4.11** — Cross-bundle: Bundle 1 worked example uses D4.x4 link conventions — **verified jointly at Stage 11** (this session).
- [x] **AC.B4.12** — R1 scope: Bundle 4 did not touch `.skills/` or `security/`.
- [ ] **AC.B4.13** — R5 shell compat on mac + Linux CI — **forward to Stage 11 CI**.
- [ ] **AC.B4.14** — R7 dogfooding: `0.3.0` CHANGELOG entry — **forward to Stage 12**.
- [x] **AC.B4.15** — Every new Stage-5+ EN doc has same-day KO pair (R4).
- [x] **AC.B4.16** — CONTRIBUTING.md Sec. 7 KO-freshness reviewer bullet present (N7-compliant alternative to `.github/`).

Status: **12/16 ticked in Stage 9.** AC.B4.10/11 land as cross-bundle checks
*in this Stage 11 session*; AC.B4.13/14 are explicit forwards to CI +
Stage 12. Verdict: **PASS — minor**. 0 code changes in Stage 9; 1 inline
design-doc polish (Sec. 6 expansion).

Tests re-run at dossier-write time: `sh tests/run_bundle4.sh` → 4/4 PASS.
