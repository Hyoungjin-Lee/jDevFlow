---
title: Stage 8 Codex kickoff — Bundle 1 (Tool Picker)
stage: 8
bundle: 1
version: 1
language: en
paired_with: null
created: 2026-04-22
updated: 2026-04-22
status: ready
validation_group: 1
---

# Stage 8 Codex kickoff — Bundle 1 (Tool Picker)

> **Order:** Run this **after** the Bundle 4 kickoff has completed and `docs/notes/decisions.md` exists (per M.1 + DEP.1).
> **Mode:** Codex · High effort (drafting) → Claude polish (Sec. 9-1 of Bundle 1 tech design).
> **Canonical reference:** `prompts/codex/implementation.md`.

---

## Precondition checklist (DO NOT start if any fails)

- [ ] Bundle 4 Stage 8 report received; all 7 deliverables present.
- [ ] `docs/notes/decisions.md` exists and contains D4.x2 / D4.x3 / D4.x4 records.
- [ ] Bundle 4 `tests/run_bundle4.sh` output = all green (Claude confirmed during the interim Stage 9 review for Bundle 4, OR this handoff explicitly waives the gate — see coordination notes below).

---

## Copy-paste prompt

```
Implement jOneFlow v0.3 Bundle 1 (tool-picker).

Read in order:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md Sec. 10 Stage 8
4. docs/03_design/bundle1_tool_picker/technical_design.md (primary spec)
5. docs/03_design/bundle1_tool_picker/technical_design.ko.md (KO pair, cross-check only)
6. docs/03_design/bundle4_doc_discipline/technical_design.md Sec. 0 (D4.x2/x3/x4 — DEP.1 gate)
7. docs/notes/decisions.md (Bundle 4 deliverable; quote from here, not re-derive)
8. docs/02_planning/plan_final.md Sec. 3-1, 5-2, 7-1 (context)

Deliverables (Sec. 9-1 of the Bundle 1 tech design):
1. .skills/tool-picker/SKILL.md
   - YAML frontmatter: name: tool-picker; description includes mandatory triggers
     ("stage", "mode", "risk_level", "next step", "jOneFlow")
   - 8-section body per Sec. 1-2 architecture; <= 300 lines total
2. docs/notes/tool_picker_usage.md        # D1.x pedagogical reference, <= 80 lines
3. docs/notes/tool_picker_usage.ko.md     # KO pair
4. tests/bundle1/run_bundle1.sh           # lint + snapshot checks (Sec. 8)

Modifications (Sec. 9-2):
- CLAUDE.md — add ONE line under "Read order" pointing to
  .skills/tool-picker/SKILL.md. Do NOT reorder existing lines.
- If Bundle 4 also modified CLAUDE.md in this session, prepare a joint
  commit labelled [bundle1+bundle4]; otherwise rebase onto Bundle 4's
  CLAUDE.md state before committing.

Constraints (do NOT violate — Sec. 9-3):
- R2 read-only invariant. No shell commands, no interactive CLI, no file
  writes in the skill body. Tested by grep -E
  '\b(bash|sh |python|node|eval|exec |curl|wget)\b' .skills/tool-picker/SKILL.md
  — matches must only appear inside code fences or quoted example output.
- NO native Skill API registration (N14). Pure Markdown only.
- NO changes under security/ or Bundle 4 files.
- NO splitting SKILL.md into rules/*.md. If the draft exceeds 300 lines,
  raise a Stage 9 finding and stop — do not split.

Output approach (plan_final Sec. 7-5 OQ.C1 lean):
- Codex generates the initial SKILL.md draft targeting the Sec. 3-3
  decision table shape exactly; cell wording is a draft for Claude to polish.
- Claude will refine description wording, worked example fit, and decision-
  table cell phrasing in a follow-up pass (Sec. 9-1 note).

Progress log:
Append a Stage-8 section to docs/04_implementation/implementation_progress.md.

Report at completion (paste into the Claude resumption session):
- Paths of created/modified files (with line counts for SKILL.md and usage doc)
- Linter output (markdownlint / your preferred)
- AC.B1.7 grep test output (R2 invariant, see constraints)
- tests/bundle1/run_bundle1.sh output
- Any decision-table cell where you were uncertain about wording

Then return control. Claude will enter Stage 9 code review with
AC.B1.1–10 as the rubric (headline: AC.B1.7 R2 invariant,
AC.B1.10 KO sync).
```

---

## Coordination notes

- **Run order.** Bundle 4 runs first. Interim Stage 9 on Bundle 4 is **not strictly required** before starting Bundle 1 (validation group 1 uses joint Stage 11), but if Bundle 4 produces shellcheck errors or failing tests, fix those first — Bundle 1 reads `docs/notes/decisions.md` which Bundle 4 creates.
- **CLAUDE.md joint commit (Sec. 9-5 of Bundle 1 design).** If both bundles land in the same Codex session, the CLAUDE.md edit ships as one commit `[bundle1+bundle4]`. If separate sessions, Bundle 1 rebases onto the Bundle 4 state that already added nothing to CLAUDE.md — practically, Bundle 1 is the sole CLAUDE.md editor in this release.
- **Sec. 12-2 freedoms** (Codex may choose): exact decision-table cell wording (shape fixed, text drafts), separator inside multi-recommendation cells (design recommends `·`; `;` acceptable if rendering issue), worked example narrative details.
- **Sec. 12-3 must-not-decide**: frontmatter `name` value (must be `tool-picker` exactly), splitting SKILL.md, removing mandatory triggers, adding CLI surface (R2 violation → immediate stop), binding to native Skill API (N14 violation).

---

## Expected report back (rough shape)

```
Stage 8 Bundle 1 implementation complete.

Files created:
- .skills/tool-picker/SKILL.md              (N lines, <= 300)
- docs/notes/tool_picker_usage.md           (N lines, <= 80)
- docs/notes/tool_picker_usage.ko.md        (N lines)
- tests/bundle1/run_bundle1.sh              (N lines)
- tests/bundle1/snapshots/*                 (N files)

Files modified:
- CLAUDE.md                                  (one line added under Read order)
- docs/04_implementation/implementation_progress.md  (Stage 8 section appended)

Linter output:
[paste full output]

AC.B1.7 grep test (R2 invariant):
$ grep -E '\b(bash|sh |python|node|eval|exec |curl|wget)\b' .skills/tool-picker/SKILL.md
[paste output — matches must all be inside code fences or quoted example output]

tests/bundle1/run_bundle1.sh:
[paste full output; all tests should pass]

Decision-table cells needing polish review:
- stage X × (mode Y, risk Z): [draft wording]
- ...

Ready for Stage 9 code review.
```
