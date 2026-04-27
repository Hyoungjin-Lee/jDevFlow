# Contributing to jOneFlow

## 1. Purpose & audience

This file is the single contributor-facing reference for jOneFlow v0.3. Use it
when you need the project layout, documentation rules, bilingual policy,
release-note discipline, or `HANDOFF.md` maintenance workflow in one place.

## 2. Quick start

1. Clone the repository.
2. Read `CLAUDE.md`, then `HANDOFF.md`, then `docs/operating_manual.md`.
3. Open the current stage documents under `docs/`.
4. Run project setup only through documented scripts under `scripts/`.
5. Treat `docs/` as the source of truth for planning, design, implementation,
   and validation state.

## 3. Directory layout

jOneFlow uses bundle-aware design folders. Bundle folders follow the D4.x3
rule: `bundle{id}_{name}/`, where `{name}` is snake_case and `id` matches the
bundle entry in `HANDOFF.md`.

Key paths:

- `docs/01_brainstorm/` and `docs/02_planning/` for Stage 1-4 prose-only docs.
- `docs/03_design/` for Stage 5 technical design files.
- `docs/04_implementation/` for Stage 8-10 progress logs.
- `docs/notes/` for durable notes such as `dev_history.md` and `decisions.md`.
- `templates/` for clean starter artifacts such as `HANDOFF.template.md`.
- `scripts/` for project utilities.
- `tests/` for shell-based validation harnesses.

## 4. Stage flow summary

`docs/operating_manual.md` Sec.5 is canonical (16-stage v0.6.5+). In short:

- Claude handles planning, design, review, validation, and QA.
- Codex handles implementation and revision.
- Standard and Strict work require design before implementation.
- Stage 9 review is mandatory before Stage 11 validation.
- `HANDOFF.md` carries state across sessions.

## 5. Doc header schema

D4.x2 applies YAML frontmatter to Stage-5-and-later docs only. That includes
technical designs, implementation progress logs, final validation records, QA
artifacts, and their `.ko.md` pairs.

Stage 1-4 docs remain prose-only. Do not add YAML frontmatter to:

- `docs/01_brainstorm/**`
- `docs/02_planning/**`
- `docs/notes/dev_history.md`
- `HANDOFF.md`
- `CLAUDE.md`
- `docs/operating_manual.md`
- Any `README.md`

Required frontmatter keys for Stage-5+ docs:

- `title`
- `stage`
- `bundle`
- `version`
- `language`
- `created`
- `updated`

## 6. Link conventions

D4.x4 standardizes Markdown links:

- Always link relative to the current file.
- Use `./sibling.md` inside the same folder when clarity helps.
- Use `../` hops explicitly when linking upward.
- Use GitHub-style lowercase, hyphenated anchors.
- Never use `file://` links.
- Never use leading-slash project-root absolute paths in docs.
- External references must use HTTPS URLs.

## 7. Bilingual (EN/KO) policy

English is the primary drafting language. Korean pairs ship at stage close per
R4. Reviewers should verify the following before a stage-closing PR is marked
ready:

- Every new Stage-5+ document with frontmatter has a `.ko.md` sibling.
- The KO file is updated no later than one day after the EN primary.
- The top-of-file KO sync checklist is marked complete when the document uses
  that pattern.
- Reviewers tick a "KO freshness for stage-closing docs" check during review.

## 8. Changelog maintenance

Owner: **D4.b**.

`CHANGELOG.md` follows Keep a Changelog v1.1.0. During Stage 12 and later
release work:

- Keep entries in reverse chronological order.
- Use `## [version] - YYYY-MM-DD` release headers.
- Use only these subsection names: `Added`, `Changed`, `Deprecated`,
  `Removed`, `Fixed`, `Security`.
- Omit empty subsections in real releases when appropriate.
- Do not dump raw git logs into the changelog.

At Stage 8, keep only the `Unreleased` placeholder. The first real `0.3.0`
entry lands at Stage 12 release time.

## 9. HANDOFF.md manual migration from v0.1/v0.2

jOneFlow v0.3 does not auto-migrate older handoff files.

For v0.1 or v0.2 projects:

1. Copy `templates/HANDOFF.template.md` to `HANDOFF.md`.
2. Move only live project state into the template's `Status` and
   `Recent Changes` sections.
3. Rebuild `Bundles`, `Key Document Links`, and `Next Session Prompt` from the
   current project scope rather than copying stale state blindly.
4. Keep historical notes in `docs/notes/dev_history.md` instead of bloating the
   new handoff template.

## 10. Running `update_handoff.sh`

`scripts/update_handoff.sh` is POSIX `sh`, dry-run by default, and writes only
when `--write` is provided.

Examples:

```sh
scripts/update_handoff.sh \
  --section both \
  --status-version "v0.3 (in progress)" \
  --status "Stage 8 implementation in progress." \
  --change "Codex completed Bundle 4 implementation." \
  --dry-run
```

```sh
scripts/update_handoff.sh \
  --section status \
  --status-version "v0.3 (in progress)" \
  --status "Stage 9 code review in progress." \
  --write
```

The script updates the English and Korean `Status` and `Recent Changes`
sections together. It refuses secret-looking input and keeps dry-run output on
stdout for review.

## 11. Code of conduct reference

Community standards are defined in `CODE_OF_CONDUCT.md`. Use the placeholder
maintainer contact until the project owner provides the final reporting address.

## 12. Per-section ownership table

| Section # | Title | Owning deliverable | Notes |
|-----------|-------|-------------------|-------|
| 1 | Purpose & audience | D4.c | - |
| 2 | Quick start | D4.c | - |
| 3 | Directory layout | D4.c (cites D4.x3) | - |
| 4 | Stage flow summary | D4.c | - |
| 5 | Doc header schema | D4.c (cites D4.x2) | - |
| 6 | Link conventions | D4.c (cites D4.x4) | - |
| 7 | Bilingual (EN/KO) policy | D4.c | Contains the KO freshness review bullet. |
| 8 | Changelog maintenance | D4.b | The single F-a1 exception: D4.b maintenance guidance lives inside a D4.c-owned file. |
| 9 | HANDOFF manual migration | D4.c | Covers v0.1 to v0.3 and v0.2 to v0.3 paths. |
| 10 | Running `update_handoff.sh` | D4.c (cites D4.a) | - |
| 11 | Code of conduct reference | D4.c | Points to `CODE_OF_CONDUCT.md`. |
| 12 | Per-section ownership table | D4.c | Authoritative appendix for ownership boundaries. |
