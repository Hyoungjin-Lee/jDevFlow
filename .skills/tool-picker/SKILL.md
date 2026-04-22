---
name: tool-picker
description: >-
  jDevFlow advisory for stage, mode, risk_level, and next step decisions.
  Match when a user enters a new stage, asks what next or which tool to open,
  or mentions jDevFlow with stage/mode/risk_level context. Read HANDOFF.md and
  reply with a ranked advisory only.
---

## 1. Purpose & scope

- This skill gives a one-screen advisory for the current jDevFlow moment.
- It reads `HANDOFF.md`, maps `(stage, mode, risk_level)` to the decision
  table below, and prints a ranked next-step recommendation.
- The advisory is read-only, non-blocking, and easy to dismiss.
- Keep the output short enough for chat; omit empty checklist and watch-out
  blocks.
- If the user already gave a precise request, keep that intent and use the
  advisory only to prioritize the next file or prompt to open.

## 2. Inputs

- Primary input: `HANDOFF.md` at the project root.
- Parse only the `## Status` triple:
  `**Current stage:**`, `**Workflow mode:**`, `**risk_level:**`.
- Optional input: the user's follow-up wording, especially "what next",
  "which tool", or a bundle-specific mention in the current stage text.
- If the current stage line includes a bundle name, prefer the matching
  bundle-specific design or kickoff file after selecting the stage row.
- Structural constraints below are quoted verbatim from
  `docs/notes/decisions.md`; do not reinterpret them.

```text
### D4.x2 - Internal doc header schema

**Decision.** Confirms plan_final Sec. 7-2 OQ4.1 lean: **YAML frontmatter on Stage-5-and-later docs only**. Stage 1-4 narrative / bilingual docs remain prose-only (no frontmatter).

**Scope.**

- Docs that carry frontmatter: every file at `docs/03_design/**/technical_design.md`, `docs/04_implementation/implementation_progress.md`, `docs/notes/final_validation.md`, `docs/05_qa_release/qa_scenarios.md`, `docs/05_qa_release/release_checklist.md`, and their `.ko.md` pairs.
- Docs that do NOT carry frontmatter: `docs/01_brainstorm/**`, `docs/02_planning/**`, `docs/notes/dev_history.md`, `HANDOFF.md`, `CLAUDE.md`, `WORKFLOW.md`, any `README.md`.

**Rationale.** Stage-5+ docs are machine-parsed by Bundle 1 tool-picker (D1.b) and by Stage 11 dossier generation; a stable frontmatter keeps that parse trivial. Earlier-stage docs are narrative, bilingual, and human-first - frontmatter would add noise without a consumer.

**Backlink.** See `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.

### D4.x3 - Bundle folder naming convention

**Decision.** Confirms plan_final Sec. 7-2 OQ4.2 lean: **`bundle{id}_{name}/`** with snake_case `{name}`. Already in use at `docs/03_design/bundle4_doc_discipline/` and `docs/03_design/bundle1_tool_picker/`.

**Rule.** Folder name format: `bundle<integer id from HANDOFF.md bundles[].id>_<snake_case name from HANDOFF.md bundles[].name>/`. No leading zero on the id.

**Rationale.** The `bundle` prefix + numeric id aligns 1-to-1 with the `HANDOFF.md bundles[].id` / `HANDOFF.md bundles[].name` YAML block, so a regex like `^bundle(\d+)_(.+)$` extracts both fields deterministically. Rejects alternatives: `{name}/` loses id lookup; `{nn}_{name}/` invents a new numbering space; a bare numeric prefix is ambiguous with stage numbers.

**Backlink.** See `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.

### D4.x4 - Doc link conventions

**Decision.** **Always relative to the current file.** No project-root-absolute links. Anchor style is GitHub's: lowercase, spaces-to-hyphens, punctuation dropped.

**Rules.**

- Within the same folder: `./sibling.md` (the `./` is optional but recommended for clarity).
- To a sibling folder: `../other_folder/target.md`.
- To the project root: count the `../` hops explicitly. Do not use `/absolute` syntax.
- Anchor: `file.md#section-header-lowercased-hyphenated`. Convert "Sec. 3-2" to `#3-2-bundle-4-doc-discipline` style - match the header's actual rendered slug.
- Never embed `file://` or absolute paths.
- External links use full HTTPS URLs.

**Rationale.** Relative-to-current-file renders correctly in GitHub web UI, VS Code preview, Claude Code Read output, and any standard Markdown viewer. Project-root-absolute paths break in half of those renderers. The lowercase-hyphenated anchor rule matches GitHub's auto-slug so cross-references survive rename-safe.

**Backlink.** See `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.
```

## 3. Decision table

Cell format: `[primary] · [checklist] · [watch-out]`.

| Stage | Strict-hybrid · medium | Strict-hybrid · medium-high | Standard · medium | Standard · medium-high | Strict · medium | Strict · medium-high |
|------:|------------------------|-----------------------------|-------------------|------------------------|-----------------|----------------------|
| 2 Plan Draft | `prompts/claude/planning_draft.md` + `docs/02_planning/plan_draft.md` · `docs/02_planning/plan_final.md` Sec. 8 · top-3 risk depth | `prompts/claude/planning_draft.md` + `docs/02_planning/plan_draft.md` · `docs/02_planning/plan_final.md` Sec. 8 · strict-hybrid extras visible | `prompts/claude/planning_draft.md` + `docs/02_planning/plan_draft.md` · `—` · `—` | `prompts/claude/planning_draft.md` + `docs/02_planning/plan_draft.md` · `docs/02_planning/plan_final.md` Sec. 5 · top-3 risk depth | `prompts/claude/planning_draft.md` + `docs/02_planning/plan_draft.md` · `docs/02_planning/plan_final.md` Sec. 5 · scope creep | `prompts/claude/planning_draft.md` + `docs/02_planning/plan_draft.md` · `docs/02_planning/plan_final.md` Sec. 5 · scope and approval depth |
| 3 Plan Review | `prompts/claude/planning_review.md` + `docs/02_planning/plan_review.md` · KO sync check · stage-4 leaks | `prompts/claude/planning_review.md` + `docs/02_planning/plan_review.md` · KO sync check · committed-rule promotion | `prompts/claude/planning_review.md` + `docs/02_planning/plan_review.md` · `—` · `—` | `prompts/claude/planning_review.md` + `docs/02_planning/plan_review.md` · `docs/02_planning/plan_final.md` Sec. 5 · residual risk depth | `prompts/claude/planning_review.md` + `docs/02_planning/plan_review.md` · `docs/02_planning/plan_final.md` Sec. 6 · approval gate | `prompts/claude/planning_review.md` + `docs/02_planning/plan_review.md` · `docs/02_planning/plan_final.md` Sec. 6 · stage-4 leak risk |
| 5 Tech Design | `prompts/claude/technical_design.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · `docs/notes/decisions.md` · R2 drift | `prompts/claude/technical_design.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · `docs/notes/decisions.md` · DEP.1 and scope extras | `prompts/claude/technical_design.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · `—` · `—` | `prompts/claude/technical_design.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · `docs/02_planning/plan_final.md` Sec. 6 · scope extras | `prompts/claude/technical_design.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · Codex appendix · review handoff completeness | `prompts/claude/technical_design.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · Codex appendix · escalation over shortcuts |
| 8 Implementation | `prompts/codex/implementation.md` + `prompts/codex/v03/stage8_bundle1_codex_kickoff.md` · `docs/04_implementation/implementation_progress.md` · constraint violations | `prompts/codex/implementation.md` + `prompts/codex/v03/stage8_bundle1_codex_kickoff.md` · `docs/04_implementation/implementation_progress.md` · KO-pair same-session discipline | `prompts/codex/implementation.md` + `docs/04_implementation/implementation_progress.md` · `—` · `—` | `prompts/codex/implementation.md` + `docs/04_implementation/implementation_progress.md` · `docs/02_planning/plan_final.md` Sec. 7-5 · report completeness | `prompts/codex/implementation.md` + `prompts/codex/v03/stage8_coordination_notes.md` · `docs/04_implementation/implementation_progress.md` · constraint list | `prompts/codex/implementation.md` + `prompts/codex/v03/stage8_coordination_notes.md` · `docs/04_implementation/implementation_progress.md` · no unilateral scope changes |
| 9 Code Review | `prompts/claude/code_review.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · AC.B1.1-10 · KO freshness | `prompts/claude/code_review.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · AC.B1.1-10 · design-level escalation | `prompts/claude/code_review.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · basic AC check · `—` | `prompts/claude/code_review.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · AC.B1.1-10 · reviewer depth | `prompts/claude/code_review.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · AC.B1.1-10 · stage-10 loop if needed | `prompts/claude/code_review.md` + `docs/03_design/bundle1_tool_picker/technical_design.md` · AC.B1.1-10 · coupled-verdict risk |
| 11 Final Validation | `prompts/claude/v03/stage11_joint_validation_prompt.md` + `docs/notes/final_validation.md` (to be created at Stage 11) · dossier compactness · R3 context exhaustion | `prompts/claude/v03/stage11_joint_validation_prompt.md` + `docs/notes/final_validation.md` (to be created at Stage 11) · fresh-session rule · divergent-verdict policy | `prompts/claude/v03/stage11_joint_validation_prompt.md` · `—` · `—` | `prompts/claude/v03/stage11_joint_validation_prompt.md` · `docs/02_planning/plan_final.md` Sec. 6 · dossier completeness | `prompts/claude/v03/stage11_joint_validation_prompt.md` + `docs/notes/final_validation.md` (to be created at Stage 11) · fresh-session rule · independent validation depth | `prompts/claude/v03/stage11_joint_validation_prompt.md` + `docs/notes/final_validation.md` (to be created at Stage 11) · fresh-session rule · coupled-verdict policy |

Fallback row for any other stage: prefer the canonical file under
`prompts/claude/` that matches the stage name if it exists; otherwise say
"no specific recommendation — ask user what they want" and stop there.

## 4. Output format

Use this chat shape:

```md
**jDevFlow tool-picker advisory** — (stage X, mode Y, risk_level Z)

**Next step (primary):**
1. [primary recommendation]

**Checklist to keep open:**
- [checklist recommendation]

**Watch-out:**
- [warning]

_Advisory only — not blocking. Say "skip" to dismiss, or ask a follow-up._
```

- Keep "Next step (primary)" present every time.
- Omit checklist and watch-out blocks when the cell uses `—`.
- If the current stage line names a bundle, replace the generic primary with
  the matching bundle file after the stage row is chosen.

## 5. Triggers

- Stage-entry trigger: a fresh `HANDOFF.md` status read shows a new stage.
- On-demand trigger: the user asks "what next", "which tool", or "next step".
- Context trigger: the user mentions jDevFlow with `stage`, `mode`, or
  `risk_level` language.
- Dismiss trigger: if the user says "skip" or "dismiss", stop with no follow-up.

## 6. Worked example

This example uses the live field names from the current `HANDOFF.md` and a
Stage 2 entry value with the same shape.

1. `HANDOFF.md` status excerpt is read.
2. `**Current stage:** Stage 2 Plan Draft`
3. `**Workflow mode:** Strict-hybrid`
4. `**risk_level:** medium`
5. The stage row resolves to `2 Plan Draft`.
6. The mode-risk column resolves to `Strict-hybrid · medium`.
7. The selected cell is:
   `prompts/claude/planning_draft.md` + `docs/02_planning/plan_draft.md` ·
   `docs/02_planning/plan_final.md` Sec. 8 · top-3 risk depth
8. The advisory is printed:
   > **jDevFlow tool-picker advisory** — (stage 2, mode Strict-hybrid, risk_level medium)
   >
   > **Next step (primary):**
   > 1. Open `prompts/claude/planning_draft.md` and `docs/02_planning/plan_draft.md`.
   >
   > **Checklist to keep open:**
   > - Keep `docs/02_planning/plan_final.md` Sec. 8 visible.
   >
   > **Watch-out:**
   > - Keep top-3 risk depth explicit before leaving Stage 2.
   >
   > _Advisory only — not blocking. Say "skip" to dismiss, or ask a follow-up._
9. The user replies: "skip".
10. The advisory stops there.
11. If the user instead asks for detail, keep the same primary and expand only
    the checklist or watch-out text.

## 7. Failure modes

- No `HANDOFF.md`: print `tool-picker: no HANDOFF.md found at project root;
  advisory suppressed.` and stop.
- No `## Status`: print `tool-picker: HANDOFF.md has no ## Status section;
  advisory suppressed.` and stop.
- Missing triple field: name the missing fields and stop.
- Unknown stage: use the fallback row and never invent a path.
- Empty decision-table cell: print `tool-picker: decision table cell empty for
  (stage=X, mode=Y, risk=Z); this is a skill bug — please file.` and stop.

## 8. Invocation reference

- `CLAUDE.md` read order should point to `.skills/tool-picker/SKILL.md`.
- `docs/notes/tool_picker_usage.md` is the short human-facing reference.
- Keep this file English-only; the usage doc carries the EN/KO pair.
- If this file approaches 300 lines, raise the issue in Stage 9 instead of
  splitting it into support files.
