---
title: Stage 8 Codex kickoff — Bundle 4 (Doc Discipline, option β)
stage: 8
bundle: 4
version: 1
language: en
paired_with: null
created: 2026-04-22
updated: 2026-04-22
status: ready
validation_group: 1
---

# Stage 8 Codex kickoff — Bundle 4 (Doc Discipline)

> **Order:** Run this **before** the Bundle 1 kickoff (per M.1 — Bundle 4 owns `docs/notes/decisions.md`, which Bundle 1 cites).
> **Mode:** Codex · High effort.
> **Canonical reference:** `prompts/codex/implementation.md` (v0.2 template; this file is the v0.3 working kickoff).

---

## Copy-paste prompt

```
Implement jOneFlow v0.3 Bundle 4 (Doc Discipline, option β).

Read in order:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md Sec. 10 Stage 8
4. docs/03_design/bundle4_doc_discipline/technical_design.md (primary spec)
5. docs/03_design/bundle4_doc_discipline/technical_design.ko.md (KO pair, cross-check only)
6. docs/02_planning/plan_final.md Sec. 3-2, 5-2, 6 (context)

Deliverables, in dependency order (Sec. 9-1 of the tech design):
1. docs/notes/decisions.md                    # D4.x2/x3/x4 quotable record — Bundle 1 depends on this
2. templates/HANDOFF.template.md              # D4.x1 template separation
3. scripts/update_handoff.sh                  # POSIX sh, shellcheck clean, dry-run default, 6-exit-code contract
4. CHANGELOG.md                               # Keep-a-Changelog v1.1.0; Unreleased placeholder only (real v0.3 entry lands at Stage 12)
5. CODE_OF_CONDUCT.md                         # Contributor Covenant v2.1
6. CONTRIBUTING.md                            # 12 sections per Sec. 2-3; F-a1 ownership table appendix Sec. 12
7. tests/bundle4/ + tests/run_bundle4.sh      # per Sec. 8 test table

Constraints (do NOT violate — Sec. 9-3):
- POSIX sh only; no bashisms
- No changes under security/
- No changes under .skills/tool-picker/ (Bundle 1's territory)
- Do NOT add YAML frontmatter to Stage 1–4 docs (D4.x2 applies to Stage-5-and-later only)
- KO pair ships in the same commit as EN primary

Progress log:
Append a Stage-8 section to docs/04_implementation/implementation_progress.md
using the format in prompts/codex/implementation.md.

Report at completion (paste into the Claude resumption session):
- Path of every created/modified file
- `shellcheck scripts/update_handoff.sh` output
- `tests/run_bundle4.sh` output
- Any AC.B4.x that remains unclear or required a judgement call (Sec. 12-3)

Then return control. Claude will enter Stage 9 code review with
AC.B4.1–16 as the rubric.
```

---

## Coordination notes

- **CLAUDE.md edit coordination.** Bundle 4 does **not** edit CLAUDE.md Read order. (Only Bundle 1 adds the `.skills/tool-picker/SKILL.md` line.)
- **`docs/notes/decisions.md` is the DEP.1 artifact.** Create this file first — Bundle 1's implementation quotes it verbatim.
- **F-a1 single exception.** CONTRIBUTING.md Sec. 8 `## Changelog maintenance` is the only section where a D4.b-level concern lives inside a D4.c-owned file. The ownership appendix (Sec. 12) makes this explicit.
- **Sec. 12-2 freedoms** (Codex may choose): regex implementation in `update_handoff.sh` (awk vs. sed), rollback backup filename convention, test harness internal naming.
- **Sec. 12-3 must-not-decide**: anything that changes D4.x2/x3/x4, adding top-level files/folders not in Sec. 9-1, CLI flag surface changes to `update_handoff.sh`.

---

## Expected report back (rough shape)

```
Stage 8 Bundle 4 implementation complete.

Files created:
- docs/notes/decisions.md                        (Nx lines)
- templates/HANDOFF.template.md                  (Nx lines)
- scripts/update_handoff.sh                      (Nx lines, shellcheck clean)
- CHANGELOG.md                                   (N lines)
- CODE_OF_CONDUCT.md                             (Contributor Covenant v2.1 verbatim)
- CONTRIBUTING.md                                (Nx lines, 12 sections + F-a1 appendix)
- tests/bundle4/test_update_handoff.sh           (N lines)
- tests/bundle4/fixtures/*                       (N files)
- tests/run_bundle4.sh                           (entry point)

Files modified:
- docs/04_implementation/implementation_progress.md  (Stage 8 section appended)

shellcheck scripts/update_handoff.sh:
[paste full output]

tests/run_bundle4.sh:
[paste full output; all tests should pass]

AC.B4.x notes:
- AC.B4.x : ok
- AC.B4.y : ok with judgement — [one-line note]
- ...

Ready for Stage 9 code review.
```
