---
title: QA Scenarios — jOneFlow v0.3 (Validation Group 1)
stage: 12
bundle: 1+4
version: 1
language: en
paired_with: qa_scenarios.ko.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# QA Scenarios — jOneFlow v0.3 (Validation Group 1)

**Scope:** Validation Group 1 = { Bundle 1 tool-picker, Bundle 4 doc-discipline (option β) }. Stage 12 QA covers both bundles jointly per plan_final M.6.

**Reading order:** This file is the primary Stage 12 deliverable (WORKFLOW Sec. 15). It pairs with `release_checklist.md` for release sign-off. Verdicts already approved at Stage 11 (`docs/notes/final_validation.md`); Stage 12 QA is the confirmatory pass, not a re-validation.

**Execution surface:**
- Bundle 1 harness: `bash tests/bundle1/run_bundle1.sh` (10 checks)
- Bundle 4 harness: `sh tests/run_bundle4.sh` (4 test scripts under `tests/bundle4/`)
- Both must remain green on every Stage 12 pass and at every release gate.

---

## 1. Happy-path scenarios

### H1. Bundle 1 — tool-picker discovery and decision

**Purpose:** Prove that a fresh Claude session can locate `.skills/tool-picker/SKILL.md`, read it in order, and emit the correct advisory output for a concrete `(stage, mode, risk)` triple.

**Preconditions:**
- Repo at `HEAD` of `main`.
- `CLAUDE.md` carries the read-order hook pointing to `.skills/tool-picker/SKILL.md`.

**Steps:**
1. Run `bash tests/bundle1/run_bundle1.sh`.
2. Confirm `CLAUDE read order hook` check PASSES (verifies discoverability).
3. Confirm `existence`, `section order`, `frontmatter triggers`, `decision table completeness`, and `decision table paths` PASS (covers AC.B1.1, AC.B1.2, AC.B1.3, AC.B1.4).
4. Inspect `.skills/tool-picker/SKILL.md` Sec. 6 — confirm the worked example produces advisory output in the documented five-line format (covers AC.B1.5).

**Expected:** 10/10 PASS from the harness + human spot-check of Sec. 6 output shape.

**AC coverage:** B1.1, B1.2, B1.3, B1.4, B1.5, B1.9.

---

### H2. Bundle 4 — `scripts/update_handoff.sh` succeeds on a valid HANDOFF.md

**Purpose:** Prove the POSIX-sh handoff updater mutates `HANDOFF.md` idempotently, with `.bak.<ts>.<pid>` rollback, for a conformant input.

**Preconditions:**
- `HANDOFF.md` contains the canonical sections the script expects (see `templates/HANDOFF.template.md`).
- `docs/notes/decisions.md` carries D4.x2/x3/x4 records.

**Steps:**
1. Run `sh tests/run_bundle4.sh`.
2. Confirm `test_01_update_handoff_success.sh` PASSES — covers the green path of `scripts/update_handoff.sh`, including `.bak.<ts>.<pid>` emission and clean removal on success.
3. Confirm `test_03_docs_structure.sh` PASSES — covers D4.x3 folder naming (`^bundle(\d+)_(.+)$`), doc placement under `docs/03_design/`, `docs/04_implementation/`, `docs/05_qa_release/`, and the `docs/notes/` cluster.
4. Confirm `test_04_frontmatter_and_stage1_4.sh` PASSES — covers D4.x2 frontmatter presence on Stage-5+ docs and its deliberate absence on Stage 1–4 prose.

**Expected:** 4/4 PASS from `tests/run_bundle4.sh`.

**AC coverage:** B4.1 (scripts exist), B4.2 (frontmatter schema), B4.3 (9 discriminated error codes — see F2 below), B4.4 (`.bak.<ts>.<pid>` rollback), B4.5 (folder naming), B4.6 (HANDOFF template), B4.9 (frontmatter enforcement).

---

### H3. Joint — SKILL.md verbatim-parses `docs/notes/decisions.md`

**Purpose:** Prove the D1.b ↔ D4.x2/x3/x4 parser contract is still wired correctly: Bundle 1 quotes Bundle 4's locking decisions verbatim, so any drift in `decisions.md` shows up immediately in Bundle 1's advisory surface.

**Preconditions:** Both harnesses green per H1 + H2.

**Steps:**
1. `diff <(sed -n '24,62p' docs/notes/decisions.md) <(sed -n '34,72p' .skills/tool-picker/SKILL.md)` — expected: empty diff (char-for-char match).
2. `grep -nE '\]\(' .skills/tool-picker/SKILL.md` — expected: 0 matches (D4.x4 is vacuous-by-construction, no markdown links to violate).
3. Confirm the verbatim block's backlink path reads `../03_design/bundle4_doc_discipline/technical_design.md Sec. 0` (D4.x4 relative-link format).

**Expected:** All three checks pass; no action on any result.

**AC coverage:** B4.10 (SKILL.md parses decisions.md), B4.11 (D4.x4 link conventions), and re-confirms B1.8 (verbatim-clause in SKILL.md).

**Last verified:** 2026-04-22 Stage 11 (`docs/notes/final_validation.md` Sec. 4).

---

### H4. Joint — KO pair freshness (R4) at stage close

**Purpose:** Prove R4 holds across the repo: every Stage-5+ doc has a KO pair whose `updated:` field is within 1 day of the EN; every Stage 1–4 doc has a KO pair whose `git log -1` timestamp is within 1 day of the EN.

**Preconditions:** Both harnesses green per H1 + H2.

**Steps:**
1. For each row of the `KO freshness table` in `docs/notes/final_validation.md` Sec. 5, compute `Δ = |EN_updated - KO_updated|` in days (using `updated:` for Stage-5+ docs, `git log -1 --format='%ai'` for Stage 1–4 prose).
2. Confirm Δ ≤ 1 for every row.
3. Re-run `tests/bundle4/test_04_frontmatter_and_stage1_4.sh` to verify frontmatter presence/absence per D4.x2.

**Expected:** All Δ ≤ 1; test PASSES.

**AC coverage:** B4.12 (R4 enforcement), B4.9 (frontmatter rule).

---

## 2. Failure / edge-case scenarios

Each failure scenario is phrased as an **expected rejection** — the test harness or human review must *refuse* the input. These scenarios exercise the discriminating error codes (AC.B4.3) and the read-only invariant (AC.B1.7, R2).

### F1. Bundle 1 — R2 read-only violation (synthetic injection)

**Purpose:** Prove that if a future editor accidentally pastes shell/CLI code into `.skills/tool-picker/SKILL.md`, the harness catches it.

**Steps (scratch branch, do not commit):**
1. Create throw-away branch: `git switch -c qa/f1-r2-violation`.
2. Inject a synthetic violation into `.skills/tool-picker/SKILL.md` Sec. 7 (e.g., append a line ```` ```bash\necho hello\n``` ````).
3. Run `bash tests/bundle1/run_bundle1.sh`.
4. Observe `R2 grep` FAILS with a clear message identifying the violating line.
5. Discard branch: `git switch main && git branch -D qa/f1-r2-violation`.

**Expected:** Harness fails on the injected violation; no other checks false-alarm.

**AC coverage:** B1.7 (R2 invariant), and confirms the grep regex covers the canonical forbidden prefixes.

---

### F2. Bundle 4 — `update_handoff.sh` rejects malformed input with discriminated error

**Purpose:** Prove that `scripts/update_handoff.sh` emits one of its 9 discriminated `error=<key>` codes on malformed inputs (AC.B4.3), and that each code maps 1:1 to a failure mode enumerated in `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 6 (extended to 10 rows at Stage 9).

**Steps:**
1. Run `sh tests/bundle4/test_02_update_handoff_failures.sh`.
2. Confirm each case in the test file triggers the matching `error=<key>` stdout discriminator and exits non-zero.
3. Spot-check the Sec. 6 table in `technical_design.md` to confirm the 10 rows × `stdout discriminator` column resolve to the 9 distinct `error=<key>` values the script emits (the 10th row documents the success path).

**Expected:** All discriminated failures raise their respective error codes; no generic exit-1 without a code; no code collisions.

**AC coverage:** B4.3 (discriminated errors), B4.4 (rollback on failure).

---

### F3. Bundle 4 — Stage-5+ doc missing D4.x2 frontmatter

**Purpose:** Prove the frontmatter guard rejects a Stage-5+ doc that lacks the required YAML header.

**Steps (scratch branch):**
1. `git switch -c qa/f3-missing-frontmatter`.
2. Remove the YAML frontmatter from any Stage-5+ doc (e.g., `docs/05_qa_release/qa_scenarios.md` — this file).
3. Run `sh tests/bundle4/test_04_frontmatter_and_stage1_4.sh`.
4. Observe test FAILS with a clear message naming the file and the missing field(s).
5. Discard branch.

**Expected:** Test fails; error message identifies the offending file.

**AC coverage:** B4.2 (frontmatter schema), B4.9 (enforcement).

---

### F4. Bundle 4 — Stage 1–4 doc with spurious frontmatter

**Purpose:** Prove the inverse guard also holds — Stage 1–4 prose docs must NOT carry frontmatter (D4.x2 explicitly excludes them).

**Steps (scratch branch):**
1. `git switch -c qa/f4-spurious-frontmatter`.
2. Prepend a YAML `---`…`---` block to `docs/01_brainstorm/brainstorm.md` (or any Stage 1–4 doc).
3. Run `sh tests/bundle4/test_04_frontmatter_and_stage1_4.sh`.
4. Observe test FAILS naming the offending Stage 1–4 file.
5. Discard branch.

**Expected:** Test fails.

**AC coverage:** B4.2 (frontmatter applies only to Stage-5+), B4.9.

---

### F5. Joint — KO pair drift > 1 day (R4 violation)

**Purpose:** Prove R4 catches stale KO translations.

**Steps (scratch branch):**
1. `git switch -c qa/f5-ko-drift`.
2. Edit `docs/03_design/bundle1_tool_picker/technical_design.md` (EN) — change `updated:` to today +1 without touching `.ko.md`.
3. Manually compute Δ using the procedure in H4.
4. Observe Δ = 1 day would pass the threshold (`≤ 1`), so bump EN `updated:` to today +2. Now Δ = 2.
5. Confirm Δ > 1 is flagged by the stage-close review procedure (R4 rule).
6. Discard branch.

**Expected:** R4 check flags the pair; rule enforced.

**AC coverage:** B4.12.

**Note:** No automated harness check for R4 numeric delta exists today (plan_final Sec. 5.2 accepts this — R4 is a human-reviewed gate at stage close). This scenario documents the manual procedure for the release gate.

---

### F6. Bundle 1 — synthetic tool-picker decision-table path rot

**Purpose:** Prove the harness catches a broken path reference in the decision table (AC.B1.4).

**Steps (scratch branch):**
1. `git switch -c qa/f6-path-rot`.
2. Change one cell in the decision table of `.skills/tool-picker/SKILL.md` Sec. 3 to reference a non-existent file (e.g., `docs/nonexistent/file.md`).
3. Run `bash tests/bundle1/run_bundle1.sh`.
4. Observe `decision table paths` FAILS naming the missing target.
5. Discard branch.

**Expected:** Harness fails with a path-resolution error.

**AC coverage:** B1.4.

---

## 3. Release checklist linkage

Stage 13 release gate (per plan_final M.6) requires:

1. All H1–H4 scenarios pass at `HEAD` of the release tag candidate.
2. All F1–F6 scenarios verified as *documented procedures* — they do not need to run on the release commit, but the procedures in this file must be current.
3. `CHANGELOG.md` `[0.3.0]` entry finalised with the real tag date (not TBD).
4. CI matrix (mac + Linux) green for both harnesses — this is the forward from Stage 11 Bundle 4 non-blocking #2.
5. `shellcheck -S style scripts/update_handoff.sh` green on CI — forward from Stage 11 Bundle 4 non-blocking #1.

See `docs/05_qa_release/release_checklist.md` for the full gate.

---

## 4. Scope boundaries

This file covers the **current shipped surface** of Bundle 1 + Bundle 4 as of Stage 11 APPROVED. Out of scope:

- **Live tool-picker triple refresh** in SKILL.md Sec. 6 — flagged at Stage 11 as an optional forward; if executed during Stage 12 housekeeping, add a post-hoc H5 scenario here. If deferred to v0.4, note in Stage 13 release_checklist.
- **tech_design Sec. 0 verbatim refresh** (AC.B1.8 tightening) — flagged at Stage 11 as optional; SKILL.md is already verbatim-compliant.
- **v0.4 features** — outside this file's scope.

---

## 5. Revision log

- v1 (2026-04-22, session 6 continuation): initial authoring for Stage 12. EN primary; KO pair in same session per R4.
