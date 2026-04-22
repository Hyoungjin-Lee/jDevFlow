---
title: Bundle 4 Structural Decisions
stage: 5-support
bundle: 4
version: 1
language: en
paired_with: decisions.ko.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Bundle 4 Structural Decisions

This file is the quotable record for D4.x2, D4.x3, and D4.x4.

Source of record: `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.

## Decision record line

> **D4.x2/x3/x4 locked on 2026-04-22 -- see `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.** Bundle 1 Stage 5 is unblocked.

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
