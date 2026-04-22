---
title: Stage 11 dossier — Bundle 1 (tool-picker)
stage: 11-input
bundle: 1
version: 1
language: en
paired_with: —
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Stage 11 Dossier — Bundle 1 (tool-picker)

## 1. What was built (≤ 10 lines)

A single-file Claude Skill that gives a short, read-only advisory for the
current jDevFlow moment. The skill reads `HANDOFF.md`, parses the
`(stage, mode, risk_level)` triple, looks up the matching cell in a
6-stage × 6-(mode, risk) decision table, and prints a three-line advisory
(primary file, checklist, watch-out). Ships as `.skills/tool-picker/SKILL.md`
(173 lines; D1.a + D1.b + D1.c co-located per OQ1.1 closure) plus a
short EN/KO reference at `docs/notes/tool_picker_usage.{md,ko.md}` (D1.x,
46 lines each). Tests at `tests/bundle1/run_bundle1.sh` (10 checks, all
PASS); `CLAUDE.md` carries the read-order hook.

## 2. Files touched

- `.skills/tool-picker/SKILL.md` (CREATED) — the skill itself: YAML frontmatter + 8-section body + 6×6 decision table + worked example + failure modes.
- `docs/notes/tool_picker_usage.md` (CREATED) — D1.x human-facing reference, 5 sections, EN primary.
- `docs/notes/tool_picker_usage.ko.md` (CREATED) — KO pair, same 5-section structure, same `updated:` date.
- `tests/bundle1/run_bundle1.sh` (CREATED) — 10-check test script (POSIX sh except for one `rg` line — see Sec. 6).
- `CLAUDE.md` (MODIFIED) — single-line Read-order hook: `> Skill hook: also read `.skills/tool-picker/SKILL.md` for jDevFlow stage/mode/risk_level advisory.` (Bundle 1 side of the shared edit.)
- `docs/04_implementation/implementation_progress.md` + `.ko.md` (MODIFIED) — Bundle 1 Stage 8 log + Stage 9 verdict section appended.
- `prompts/codex/v03/stage8_bundle1_codex_report.md` (CREATED) — archived Codex completion report (135 lines).

## 3. Key diffs (≤ 200 lines total)

The full SKILL.md is 173 lines and worth reading end-to-end during Stage 11.
Rather than paste it, this dossier pins only the structural invariants the
validator should eyeball; everything else is in the repo.

**YAML frontmatter (verifies AC.B1.1, AC.B1.2, AC.B1.9):**

```yaml
---
name: tool-picker
description: >-
  jDevFlow advisory for stage, mode, risk_level, and next step decisions.
  Match when a user enters a new stage, asks what next or which tool to open,
  or mentions jDevFlow with stage/mode/risk_level context. Read HANDOFF.md and
  reply with a ranked advisory only.
---
```

- Mandatory trigger words present: `stage`, `mode`, `risk_level`, `next step`, `jDevFlow`.
- `description` length: 287 bytes (≤ 1024).

**8-section body headings (verifies AC.B1.2 order):**

```
## 1. Purpose & scope
## 2. Inputs
## 3. Decision table
## 4. Output format
## 5. Triggers
## 6. Worked example
## 7. Failure modes
## 8. Invocation reference
```

**Decision-table shape (verifies AC.B1.3, AC.B1.4):**

- Rows: Stage 2 / 3 / 5 / 8 / 9 / 11 (6 rows).
- Columns: Strict-hybrid · medium | Strict-hybrid · medium-high | Standard · medium | Standard · medium-high | Strict · medium | Strict · medium-high (6 columns).
- Every cell has a non-empty `primary` (format `[primary] · [checklist] · [watch-out]`). Stage-11 cells annotate the `docs/notes/final_validation.md` path as `(to be created at Stage 11)` — rest all resolve to live repo paths.
- Fallback sentence present after the table.

**R2 read-only invariant (AC.B1.7 — headline):**

```sh
grep -nE '\b(bash|sh |python|node|eval|exec |curl|wget)\b' .skills/tool-picker/SKILL.md
# → 0 matches
```

**Worked example (AC.B1.5):** 31 lines, uses Stage 2 · Strict-hybrid · medium as the live triple; demonstrates trigger → HANDOFF read → cell lookup → advisory print → "skip" dismiss.

**CLAUDE.md hook (AC.B1.9 via test):**

```md
> Skill hook: also read `.skills/tool-picker/SKILL.md` for jDevFlow stage/mode/risk_level advisory.
```

## 4. Design references (paths only, not pasted)

- `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 — verbatim D4.x2/x3/x4 quote (DEP.1).
- `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 2 — single-file scope (D1.a + D1.b + D1.c, ≤ 300 lines).
- `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 11 — AC.B1.1–10 rubric.
- `docs/02_planning/plan_final.md` Sec. 3-2 — deliverable IDs D1.a (skill body), D1.b (decision logic), D1.c (worked example), D1.x (usage doc).
- `docs/notes/decisions.md` — D4.x2/x3/x4 canonical source that SKILL.md quotes.

## 5. Stage 9 findings and their resolution

| Finding | Original stage | Resolution | Commit/file ref |
|---------|----------------|------------|-----------------|
| AC.B1.3 — Codex expanded 4-col design example to 6-col literal (mode × risk) coverage. | Stage 9 | Accepted as correct interpretation — AC is authoritative over design example. | `docs/04_implementation/implementation_progress.md` Stage 9 Bundle 1 disposition row. |
| AC.B1.4 — `docs/notes/final_validation.md` not yet extant at Stage 8. | Stage 9 | Accepted Codex's `(to be created at Stage 11)` annotation; avoids ghost path. | SKILL.md Stage 11 row; disposition row. |
| AC.B1.7 — zero grep matches ⇒ no code-fence annotation exercise. | Stage 9 | Accepted as vacuous-by-construction (preferred outcome). | Stage 9 verdict AC.B1.7 row. |
| AC.B1.10 — structural-sync proxy (header count + `updated:` parity) instead of line-by-line KO diff. | Stage 9 | Accepted as correct proxy for bundle-stage freshness. | Stage 9 verdict AC.B1.10 row. |
| Entry 3.9 missing from `dev_history.ko.md` (prior session R4 slip). | Stage 9 | Backfilled during this session — declared out-of-Bundle-1-scope housekeeping. | `docs/notes/dev_history.ko.md` Entry 3.9. |

No code changes were applied during Stage 9; no inline design polish was applied to Bundle 1.

## 6. Deferred / non-blocking observations

- **Worked-example live-state refresh** — Sec. 6 currently uses a synthetic Stage-2 Strict-hybrid triple. Forward to Stage 11 so the example can anchor on a live-during-S11 triple if desired (non-blocking per AC.B1.5).
- **`tests/bundle1/run_bundle1.sh` line 53 uses `rg`** (ripgrep) inside an otherwise-POSIX `sh` script. Forward to Stage 11 mac + Linux CI matrix — either swap to `grep -E` or document the ripgrep dependency. Non-blocking at this stage (skill body itself is POSIX-clean).

## 7. Acceptance-criteria checklist (from technical_design.md Sec. 11)

- [x] **AC.B1.1** — SKILL.md 173 lines ≤ 300; YAML `name: tool-picker` + 5 trigger terms in `description`.
- [x] **AC.B1.2** — 8 sections in canonical order (test: `section order` PASS).
- [x] **AC.B1.3** — 6×6 decision table; every primary cell non-empty (test: `decision table completeness` PASS).
- [x] **AC.B1.4** — All cited paths resolve or carry `(to be created at Stage 11)` marker (test: `decision table paths` PASS).
- [x] **AC.B1.5** — Worked example 31 lines ≥ 15, Stage 2 Strict-hybrid, end-to-end (test: `worked example` PASS).
- [x] **AC.B1.6** — `tool_picker_usage.{md,ko.md}` present, 46 lines each, frontmatter `stage: 5-support` + `bundle: 1` (test: `usage docs and KO sync` PASS).
- [x] **AC.B1.7** (headline) — R2 read-only invariant: grep returns 0 matches; reviewer sign-off recorded (test: `R2 grep` PASS).
- [x] **AC.B1.8** — D4.x2/x3/x4 quoted verbatim in SKILL.md Sec. 2 (confirmed by human inspection in Stage 9).
- [x] **AC.B1.9** — `description` = 287 bytes (≤ 1024); CLAUDE.md hook present (test: `frontmatter triggers`, `CLAUDE read order hook` PASS).
- [x] **AC.B1.10** — KO pair `updated:` matches EN (2026-04-22); header count parity (test: `usage docs and KO sync` PASS).

Status: **10/10 ticked.** Verdict: **PASS — minor**. 0 code changes in Stage 9; 0 inline polish edits.

Tests re-run at dossier-write time: `bash tests/bundle1/run_bundle1.sh` → 10/10 PASS.
