---
title: Stage 8 Codex kickoff — Bundle 1 (Tool Picker)
stage: 8
bundle: 1
version: 2
language: en
paired_with: null
created: 2026-04-22
updated: 2026-04-22
status: ready
validation_group: 1
---

# Stage 8 Codex kickoff — Bundle 1 (Tool Picker)

> **Order:** Run this **after** the Bundle 4 kickoff has completed and
> `docs/notes/decisions.md` exists with D4.x2 / D4.x3 / D4.x4 records
> (per M.1 + DEP.1).
> **Mode:** Codex · High effort (drafting) → Claude polish (Sec. 9-1 of
> Bundle 1 tech design).
> **Canonical reference:** `prompts/codex/implementation.md`.
>
> **Report template (do NOT paste this into Codex):**
> `prompts/codex/v03/stage8_codex_report_template.md`.

---

## ⚠️ Operator instruction — read before pasting

This document contains exactly **one** fenced code block intended for Codex:
the block immediately under "Codex prompt — paste this exact block" below.

Do **not** paste:

- This document's prose sections.
- The Precondition checklist.
- The Coordination notes section at the bottom.
- Any other content from the v0.3 prompts directory.

Past failure mode (2026-04-22): the previous version of this kickoff also
contained an "Expected report back (rough shape)" example block at the
bottom. The operator pasted that bottom block into Codex by mistake. The
example shapes have been moved to the separate report template file
referenced above so the kickoff document holds only one paste-target block.

---

## Precondition checklist (operator runs before pasting)

Do not start Bundle 1 if any check fails:

- [ ] Bundle 4 Stage 8 report received; all 7 deliverables present
      (verify with `ls -la` on the paths listed in the Bundle 4 kickoff
      STEP 4).
- [ ] `docs/notes/decisions.md` exists and contains D4.x2 / D4.x3 / D4.x4
      records (verify with `grep -E '^## D4\.x[234]\b' docs/notes/decisions.md`).
- [ ] Bundle 4 `tests/run_bundle4.sh` output = all green (operator
      confirmed during the interim Stage 9 review for Bundle 4, **or**
      this handoff explicitly waives the gate per coordination notes).

---

## Codex prompt — paste this exact block

```
Implement jDevFlow v0.3 Bundle 1 (tool-picker).

STEP 0 — Read & quote spec back BEFORE writing any file.

Read in order (use the Read or cat tool — do not skim from memory):
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md  (Sec. 10 Stage 8)
4. docs/03_design/bundle4_doc_discipline/technical_design.md  (Sec. 0 only —
   D4.x2 / D4.x3 / D4.x4; this is the DEP.1 gate)
5. docs/notes/decisions.md  (Bundle 4 deliverable; QUOTE FROM HERE — do
   not re-derive the D4.x records)
6. docs/03_design/bundle1_tool_picker/technical_design.md  (PRIMARY SPEC)
7. docs/03_design/bundle1_tool_picker/technical_design.ko.md  (KO pair,
   cross-check only)
8. docs/02_planning/plan_final.md  (Sec. 3-1, 5-2, 7-1 for context)

After reading, in your reply, quote back verbatim:
- The full D4.x2 / D4.x3 / D4.x4 entries from docs/notes/decisions.md
  (exact wording — these are your structural constraints).
- The Sec. 1-2 architecture summary from the Bundle 1 technical_design.md
  (8-section body shape).
- The Sec. 3-3 decision-table shape (rows × columns; cell wording is
  yours to draft).
- The Sec. 9-1 deliverables list and Sec. 9-3 constraints.
- The full AC.B1.1 through AC.B1.10 acceptance-criteria rubric (exact
  wording of each AC item; do not paraphrase).

Only after the operator confirms your quotes are accurate may you proceed
to STEP 1. If any quote is approximate, stop and re-read.

STEP 1 — Implement the deliverables (Sec. 9-1 of the Bundle 1 tech design):

1. .skills/tool-picker/SKILL.md
   - YAML frontmatter:
     - name: tool-picker          (must be exactly this string — N3 / Sec. 12-3)
     - description: must include the mandatory triggers
       "stage", "mode", "risk_level", "next step", "jDevFlow"
   - 8-section body per Sec. 1-2 architecture.
   - <= 300 lines total (OQ1.1).
   - If your draft would exceed 300 lines, STOP and raise a Stage 9
     finding — do NOT split into rules/*.md (N15 / Sec. 9-3).

2. docs/notes/tool_picker_usage.md
   - D1.x pedagogical reference, <= 80 lines.

3. docs/notes/tool_picker_usage.ko.md
   - KO pair (R4); ships in the same commit as the EN file.

4. tests/bundle1/run_bundle1.sh
   - Lint + snapshot checks per Sec. 8 of the Bundle 1 tech design.

STEP 2 — CLAUDE.md modification (Sec. 9-2):

- Add ONE line under the "Read order" section pointing to
  .skills/tool-picker/SKILL.md.
- Do NOT reorder existing lines.
- If Bundle 4 also modified CLAUDE.md in this same Codex session,
  prepare a joint commit labelled [bundle1+bundle4]. Otherwise rebase
  onto the Bundle 4 committed state before adding the tool-picker line.

STEP 3 — Constraints (do NOT violate; Sec. 9-3 of the Bundle 1 tech design):

- R2 read-only invariant. The skill body must not contain shell
  commands, interactive CLI suggestions, or file-write directives.
  Tested by:
    grep -E '\b(bash|sh |python|node|eval|exec |curl|wget)\b' \
         .skills/tool-picker/SKILL.md
  Any matches must occur ONLY inside fenced code blocks or quoted
  example output — never as a live instruction to the runtime.
- NO native Skill API registration (N14). Pure Markdown only.
- NO changes under security/.
- NO changes under Bundle 4 files (CHANGELOG.md, CONTRIBUTING.md,
  CODE_OF_CONDUCT.md, scripts/update_handoff.sh, templates/, tests/bundle4).
- NO splitting SKILL.md into rules/*.md (see STEP 1.1 escalation rule).
- NO top-level files or folders not in Sec. 9-1 of the Bundle 1 design.

STEP 4 — Output approach (plan_final Sec. 7-5 OQ.C1 lean):

- Generate the SKILL.md draft targeting the Sec. 3-3 decision-table
  shape exactly. Cell wording is a draft — Claude will polish in
  Stage 9 (Sec. 9-1 of Bundle 1 design explicitly allows this).
- For each decision-table cell where you were uncertain about wording,
  add a comment-style note for the report.

STEP 5 — Progress log:

Append a Stage-8 section to docs/04_implementation/implementation_progress.md
using the format in prompts/codex/implementation.md.

STEP 6 — Verify before reporting complete:

- Run: wc -l .skills/tool-picker/SKILL.md
  → must be ≤ 300; if > 300, STOP and raise Stage 9 finding instead.
- Run: wc -l docs/notes/tool_picker_usage.md
  → must be ≤ 80.
- Run: grep -E '\b(bash|sh |python|node|eval|exec |curl|wget)\b' \
              .skills/tool-picker/SKILL.md
  → review every match; matches outside code fences or quoted output
    are R2 violations — STOP and raise Stage 9 finding.
- Run: tests/bundle1/run_bundle1.sh
  → must all pass.
- Run: ls -la .skills/tool-picker/SKILL.md \
              docs/notes/tool_picker_usage.md \
              docs/notes/tool_picker_usage.ko.md \
              tests/bundle1/run_bundle1.sh
  → all 4 paths must exist with non-zero size.
- Run: diff -u <(grep -c '^##' docs/notes/tool_picker_usage.md) \
               <(grep -c '^##' docs/notes/tool_picker_usage.ko.md)
  → KO pair section count should match the EN primary (AC.B1.10).

STEP 7 — Completion report:

Paste back into the next Claude session:
- Path of every created/modified file (real paths — do NOT use brackets)
- Real line counts for SKILL.md and the usage doc
- Linter output (markdownlint or equivalent)
- AC.B1.7 grep output (R2 invariant) with each match annotated as
  "inside code fence" / "inside quoted output" / "violation"
- tests/bundle1/run_bundle1.sh full output
- KO pair sync confirmation
- Decision-table cells where you want Claude to polish wording

If any STEP 6 verification fails, STOP and report the failure instead of
papering over it. Do not invent file paths, line counts, or test output.

Then return control. Claude will enter Stage 9 code review with
AC.B1.1–10 as the rubric (headline: AC.B1.7 R2 invariant,
AC.B1.10 KO sync, AC.B1.4 mandatory triggers, AC.B1.3 ≤ 300 lines).
```

---

## Coordination notes (operator-facing prose, not for Codex)

Run order — Bundle 4 first. The interim Stage 9 review on Bundle 4 is not
strictly required before starting Bundle 1 (validation group 1 uses joint
Stage 11), but if Bundle 4 produced shellcheck errors or failing tests,
fix those first. Bundle 1 reads `docs/notes/decisions.md`, which Bundle 4
creates.

CLAUDE.md joint commit (Sec. 9-5 of Bundle 1 design). If both bundles land
in the same Codex session, the CLAUDE.md edit ships as one commit
`[bundle1+bundle4]`. If separate sessions, Bundle 1 is the sole CLAUDE.md
editor in this release because Bundle 4 makes no CLAUDE.md changes.

Sec. 12-2 freedoms (Codex may choose without escalation):

- Exact decision-table cell wording (shape is fixed; text is a draft).
- Separator inside multi-recommendation cells (design recommends `·`;
  `;` acceptable if there's a rendering issue).
- Worked-example narrative details.

Sec. 12-3 must-not-decide (escalate as Stage 9 finding instead of deciding):

- Frontmatter `name` value (must be `tool-picker` exactly).
- Splitting SKILL.md.
- Removing any mandatory trigger keyword.
- Adding any CLI surface (R2 violation → immediate stop).
- Binding to native Skill API (N14 violation).

---

## After Codex finishes

1. Verify Codex actually wrote the 4 deliverables and the CLAUDE.md edit:
   run the `ls -la` / `wc -l` / `grep` commands listed in STEP 6 above
   and confirm real output, not bracketed placeholders.
2. Format the completion report using
   `prompts/codex/v03/stage8_codex_report_template.md` (Bundle 1 section).
3. Start a fresh Claude session with
   `prompts/claude/v03/session4_post_codex_resume_prompt.md`, pasting both
   completion reports into the `=== CODEX STAGE 8 COMPLETION REPORT ===`
   sections.
