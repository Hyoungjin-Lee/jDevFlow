---
title: Stage 8 Codex kickoff — Bundle 4 (Doc Discipline, option β)
stage: 8
bundle: 4
version: 2
language: en
paired_with: null
created: 2026-04-22
updated: 2026-04-22
status: ready
validation_group: 1
---

# Stage 8 Codex kickoff — Bundle 4 (Doc Discipline)

> **Order:** Run this **before** the Bundle 1 kickoff. Bundle 4 owns
> `docs/notes/decisions.md`, which Bundle 1 cites verbatim per DEP.1.
> **Mode:** Codex · High effort.
> **Canonical reference:** `prompts/codex/implementation.md` (v0.2 baseline);
> this file is the v0.3 working kickoff.
>
> **Report template (do NOT paste this into Codex):**
> `prompts/codex/v03/stage8_codex_report_template.md` — operator uses this
> *after* Codex finishes to format the completion report for the next
> Claude session.

---

## ⚠️ Operator instruction — read before pasting

This document contains exactly **one** fenced code block intended for Codex:
the block immediately under "Codex prompt — paste this exact block" below.

Do **not** paste:

- This document's prose sections.
- The "Coordination notes" section at the bottom.
- Any other content from the v0.3 prompts directory.

Past failure mode (2026-04-22): the previous version of this kickoff also
contained an "Expected report back (rough shape)" example block at the
bottom. The operator pasted that bottom block into Codex by mistake, and
Codex correctly produced an empty `Stage 8 Bundle 4 implementation
complete.` report — with no real file writes, because the example block
contained no instructions. To prevent recurrence, the example shapes have
been moved out of this kickoff into the separate report template file
referenced above.

---

## Codex prompt — paste this exact block

```
Implement jDevFlow v0.3 Bundle 4 (Doc Discipline, option β).

STEP 0 — Read & quote spec back BEFORE writing any file.

Read in order (use the Read or cat tool — do not skim from memory):
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md  (Sec. 10 Stage 8 in particular)
4. docs/03_design/bundle4_doc_discipline/technical_design.md  (PRIMARY SPEC)
5. docs/03_design/bundle4_doc_discipline/technical_design.ko.md  (KO pair, cross-check only)
6. docs/02_planning/plan_final.md  (Sec. 3-2, 5-2, 6 for context)

After reading, in your reply, quote back verbatim:
- The full Sec. 0 "Decisions locked at Stage 5" block from the Bundle 4
  technical_design.md (D4.x2, D4.x3, D4.x4 — exact wording).
- The Sec. 9-1 deliverables list from the same file.
- The Sec. 9-3 constraints list (do-NOT-violate items).
- The Sec. 8 test table.
- The full AC.B4.1 through AC.B4.16 acceptance-criteria rubric (exact wording
  of each AC item; do not paraphrase).

Only after the operator confirms your quotes are accurate may you proceed
to STEP 1. If any quote is approximate, stop and re-read.

STEP 1 — Implement the deliverables (Sec. 9-1 of the tech design),
in dependency order:

1. docs/notes/decisions.md
   - D4.x2 / D4.x3 / D4.x4 quotable record. Bundle 1 will read this file
     verbatim, so phrasing must be stable and unambiguous.

2. templates/HANDOFF.template.md
   - D4.x1 template separation. Strip volatile sections from the live
     HANDOFF.md shape; keep structure stable.

3. scripts/update_handoff.sh
   - POSIX sh only (no bashisms; verify with shellcheck).
   - Dry-run is the default; mutation requires explicit flag.
   - 6-exit-code contract per Sec. 6 of the tech design.

4. CHANGELOG.md
   - Keep-a-Changelog v1.1.0 shape.
   - Unreleased placeholder only at this stage; the real v0.3 entry
     lands at Stage 12 (release).

5. CODE_OF_CONDUCT.md
   - Contributor Covenant v2.1 verbatim.

6. CONTRIBUTING.md
   - 12 sections per Sec. 2-3.
   - Sec. 8 ("Changelog maintenance") is the F-a1 single exception
     (D4.b concern living inside a D4.c-owned file).
   - Sec. 12 = F-a1 ownership-table appendix making the exception explicit.

7. tests/bundle4/ + tests/run_bundle4.sh
   - Per the Sec. 8 test table.
   - Include the Stage 1–4 frontmatter-free check (AC.B4.16).

STEP 2 — Constraints (do NOT violate; Sec. 9-3 of the tech design):

- POSIX sh only; no bashisms in update_handoff.sh.
- No changes under security/.
- No changes under .skills/tool-picker/  (that is Bundle 1's territory).
- Do NOT add YAML frontmatter to Stage 1–4 docs (D4.x2 applies to
  Stage-5-and-later only).
- KO pair ships in the same commit as EN primary (R4).
- Do NOT add top-level files or folders not listed in Sec. 9-1 above.

STEP 3 — Progress log:

Append a Stage-8 section to docs/04_implementation/implementation_progress.md
using the format in prompts/codex/implementation.md.

STEP 4 — Verify before reporting complete:

- Run: shellcheck scripts/update_handoff.sh        → must be clean
- Run: tests/run_bundle4.sh                         → must all pass
- Run: ls -la docs/notes/decisions.md templates/HANDOFF.template.md \
              scripts/update_handoff.sh CHANGELOG.md CODE_OF_CONDUCT.md \
              CONTRIBUTING.md tests/run_bundle4.sh
  → all 7 paths must exist with non-zero size
- Run: wc -l docs/notes/decisions.md CONTRIBUTING.md scripts/update_handoff.sh
  → record line counts for the report

STEP 5 — Completion report:

Paste back into the next Claude session:
- Path of every created/modified file (real paths — do NOT use brackets)
- Real line counts for the big files
- Full stdout of `shellcheck scripts/update_handoff.sh`
- Full stdout of `tests/run_bundle4.sh`
- Confirmation that Stage 1–4 docs were NOT given frontmatter
- Any AC.B4.x where you made a non-trivial judgement call (Sec. 12-3)

If any STEP 4 verification fails, STOP and report the failure instead of
papering over it. Do not invent file paths, line counts, or test output.

Then return control. Claude will enter Stage 9 code review with
AC.B4.1–16 as the rubric.
```

---

## Coordination notes (operator-facing prose, not for Codex)

CLAUDE.md edit coordination — Bundle 4 does not edit the CLAUDE.md
"Read order" list. Only Bundle 1 adds the `.skills/tool-picker/SKILL.md`
line.

`docs/notes/decisions.md` is the DEP.1 artifact. It must exist and contain
D4.x2 / D4.x3 / D4.x4 records before Bundle 1's kickoff is run; Bundle 1's
implementation quotes it verbatim rather than re-derive the decisions.

F-a1 single exception. CONTRIBUTING.md Sec. 8 (`## Changelog maintenance`)
is the only section where a D4.b-level concern lives inside a D4.c-owned
file. The Sec. 12 ownership appendix makes this explicit.

Sec. 12-2 freedoms (Codex may choose without escalation):

- Regex implementation in `update_handoff.sh` (awk vs. sed).
- Rollback backup filename convention.
- Test harness internal naming.

Sec. 12-3 must-not-decide (escalate as Stage 9 finding instead of deciding):

- Anything that changes D4.x2 / D4.x3 / D4.x4.
- Adding top-level files or folders not listed in Sec. 9-1.
- CLI flag surface changes to `update_handoff.sh`.

---

## After Codex finishes

1. Verify Codex actually wrote the 7 deliverables: run the `ls -la` /
   `wc -l` commands listed in STEP 4 above and confirm real output.
2. Format the completion report using
   `prompts/codex/v03/stage8_codex_report_template.md` (Bundle 4 section).
3. Proceed to Bundle 1 kickoff
   (`prompts/codex/v03/stage8_bundle1_codex_kickoff.md`).
4. After both bundles ship, start a fresh Claude session with
   `prompts/claude/v03/session4_post_codex_resume_prompt.md`, pasting both
   completion reports into the marked sections.
