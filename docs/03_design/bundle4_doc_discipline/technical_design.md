---
title: Technical Design — Bundle 4 (Doc Discipline, option β)
stage: 5
bundle: 4
version: 1
language: en
paired_with: technical_design.ko.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Technical Design — Bundle 4 (Doc Discipline, option β)

**Project:** jDevFlow v0.3
**Stage:** 5 (Technical Design)
**Date:** 2026-04-22 (session 3 resumed)
**Mode:** Strict-hybrid (upper Strict + inner bundle Standard)
**Input:** `docs/02_planning/plan_final.md` (APPROVED at Stage 4.5 joint, 2026-04-22) · `prompts/claude/v03/stage5_bundle4_design_prompt_draft.md` (DC.5 half #1)
**Output paired KO:** `technical_design.ko.md` (this document's Korean pair, written at stage close per R4)
**Risk level:** medium (option β)
**has_ui:** false

---

## KO sync check (plan_review Sec. 4-3 reusable block)

Check after KO pair is written:

- [x] Section-header count parity between EN and KO (18 / 18 verified)
- [x] North-star sentence (or equivalent — see Sec. 1) present and equivalent in KO
- [x] Locked-decision IDs (D4.x2 / D4.x3 / D4.x4) identical in both files
- [x] Acceptance-criteria item count identical in both files (AC.B4.1–16, 16 items / 16 items)

(Marked complete at stage close 2026-04-22.)

---

## 0. Structural decisions (locked — DEP.1 gate for Bundle 1)

> These three paragraphs satisfy the DEP.1 (F-o1) sequencing requirement.
> Bundle 1 Stage 5 may begin once this section exists and is signed below.
> Bundle 1 design MUST cite these decisions verbatim in its own Sec. 1.

### D4.x2 — Internal doc header schema

**Decision.** Confirms plan_final Sec. 7-2 OQ4.1 lean: **YAML frontmatter on Stage-5-and-later docs only**. Stage 1–4 narrative / bilingual docs remain prose-only (no frontmatter).

**Scope.**

- Docs that carry frontmatter: every file at `docs/03_design/**/technical_design.md`, `docs/04_implementation/implementation_progress.md`, `docs/notes/final_validation.md`, `docs/05_qa_release/qa_scenarios.md`, `docs/05_qa_release/release_checklist.md`, and their `.ko.md` pairs.
- Docs that do NOT carry frontmatter: `docs/01_brainstorm/**`, `docs/02_planning/**`, `docs/notes/dev_history.md`, `HANDOFF.md`, `CLAUDE.md`, `WORKFLOW.md`, any `README.md`.

**Minimum required fields (both EN and KO):**

```yaml
---
title: Technical Design — Bundle 4 (Doc Discipline, option β)
stage: 5
bundle: 4
version: 1
language: en         # "en" or "ko"
paired_with: technical_design.ko.md   # the sibling file; optional on Stage 11/12 singletons
created: 2026-04-22
updated: 2026-04-22
---
```

Optional fields: `status` (`draft|approved|archived`), `supersedes`, `validation_group`.

**Rationale.** Stage-5+ docs are machine-parsed by Bundle 1 tool-picker (D1.b) and by Stage 11 dossier generation; a stable frontmatter keeps that parse trivial. Earlier-stage docs are narrative, bilingual, and human-first — frontmatter would add noise without a consumer.

### D4.x3 — Bundle folder naming convention

**Decision.** Confirms plan_final Sec. 7-2 OQ4.2 lean: **`bundle{id}_{name}/`** with snake_case `{name}`. Already in use at `docs/03_design/bundle4_doc_discipline/` and `docs/03_design/bundle1_tool_picker/`.

**Rule.** Folder name format: `bundle<integer id from HANDOFF.md bundles[].id>_<snake_case name from HANDOFF.md bundles[].name>/`. No leading zero on the id.

**Rationale.** The `bundle` prefix + numeric id aligns 1-to-1 with the `HANDOFF.md bundles[].id` / `HANDOFF.md bundles[].name` YAML block, so a regex like `^bundle(\d+)_(.+)$` extracts both fields deterministically. Rejects alternatives: `{name}/` loses id lookup; `{nn}_{name}/` invents a new numbering space; a bare numeric prefix is ambiguous with stage numbers.

### D4.x4 — Doc link conventions

**Decision.** **Always relative to the current file.** No project-root-absolute links. Anchor style is GitHub's: lowercase, spaces-to-hyphens, punctuation dropped.

**Rules.**

- Within the same folder: `./sibling.md` (the `./` is optional but recommended for clarity).
- To a sibling folder: `../other_folder/target.md`.
- To the project root: count the `../` hops explicitly. Do not use `/absolute` syntax.
- Anchor: `file.md#section-header-lowercased-hyphenated`. Convert "Sec. 3-2" to `#3-2-bundle-4-doc-discipline` style — match the header's actual rendered slug.
- Never embed `file://` or absolute paths.
- External links (GitHub, Anthropic docs) use full HTTPS URLs.

**Rationale.** Relative-to-current-file renders correctly in GitHub web UI, VS Code preview, Claude Code Read output, and any standard Markdown viewer. Project-root-absolute paths break in half of those renderers. The lowercase-hyphenated anchor rule matches GitHub's auto-slug so cross-references survive rename-safe.

### Decision record line (Bundle 1 quotes this verbatim)

> **D4.x2/x3/x4 locked on 2026-04-22 — see `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.** Bundle 1 Stage 5 is unblocked.

---

## 1. Architecture overview

Bundle 4 establishes the **documentation substrate** that Bundle 1's tool-picker reads and that every future downstream jDevFlow user copies. It is deliberately small — four scripts/files plus three decisions — but those sit underneath everything else.

```
┌─────────────────────────────────────────────────────────────────┐
│                     jDevFlow project root                       │
├─────────────────────────────────────────────────────────────────┤
│  CHANGELOG.md            (D4.b — release log, "Keep a           │
│                            Changelog" format, first entry v0.3) │
│  CONTRIBUTING.md         (D4.c — owns file; contains            │
│                            `## Changelog maintenance` from D4.b │
│                            per F-a1)                            │
│  CODE_OF_CONDUCT.md      (D4.c — Contributor Covenant v2.1)     │
│                                                                 │
│  templates/                                                     │
│    HANDOFF.template.md   (D4.x1 — clean template form)          │
│                                                                 │
│  scripts/                                                       │
│    update_handoff.sh     (D4.a — POSIX sh, dry-run default,     │
│                            writes against template form)        │
│                                                                 │
│  docs/                                                          │
│    notes/                                                       │
│      decisions.md        (D4.x2/x3/x4 quotable record           │
│                            — created fresh, pointers back       │
│                            into this tech_design Sec. 0)        │
│    03_design/bundleN_.../technical_design.md[.ko.md]            │
│                          (all downstream tech designs follow    │
│                            D4.x2 frontmatter + D4.x3 folder     │
│                            naming + D4.x4 link rules)           │
└─────────────────────────────────────────────────────────────────┘
             │
             ▼
    Bundle 1 tool-picker (.skills/tool-picker/SKILL.md)
    reads HANDOFF.md (state) + docs/ structure (per D4.x2/x3/x4)
    and emits advisory recommendations.
```

**North star for this bundle (derivative of plan_final Sec. 1-1):** A new teammate cloning jDevFlow v0.3 can, in under 30 minutes, (a) understand the doc layout from `CONTRIBUTING.md` alone, (b) locate the HANDOFF template, and (c) run `scripts/update_handoff.sh --dry-run` to preview a Status update.

---

## 2. Components

### 2-1. Component — `scripts/update_handoff.sh` (D4.a)

- **Responsibility.** Idempotently rewrite the `## Status` and `## Recent Changes` sections of `HANDOFF.md` from CLI inputs, without touching anything else. Dry-run is default; `--write` persists.
- **Runtime.** POSIX `sh` — target `dash` semantics to avoid bashisms. macOS-only in v0.3 (plan_final Sec. 5-2 R5); Linux expected to work; Windows/WSL deferred to v0.4 (out of scope).
- **Dependencies.** Coreutils (`sed`, `awk`, `date`), `shellcheck` for CI lint. No non-standard tools.
- **File.** `scripts/update_handoff.sh` (executable, `chmod +x`, shebang `#!/bin/sh`).
- **Interface.** See Sec. 5-1.

### 2-2. Component — `CHANGELOG.md` (D4.b, file only)

- **Responsibility.** Hold release entries in reverse-chronological order. First concrete entry = v0.3 itself (plan_final Sec. 5-2 R7 dogfooding).
- **Format.** "Keep a Changelog" v1.1.0 (closes plan_final Sec. 7-7 OQ.N1). Sections per release: Added / Changed / Deprecated / Removed / Fixed / Security.
- **Ownership.** File is owned by D4.b. Maintenance rule (**how/when to append**) lives as a single `## Changelog maintenance` section in `CONTRIBUTING.md` (F-a1 per plan_final Sec. 3-2).
- **File.** `CHANGELOG.md` at project root.

### 2-3. Component — `CONTRIBUTING.md` (D4.c, file + owning doc)

- **Responsibility.** Single authoritative contributor-facing doc. Owns file itself + a per-section ownership table at the top (F-a1 remediation).
- **Required sections (in order):**
  1. Purpose & audience
  2. Quick start (clone → read order)
  3. Directory layout (points to D4.x3 rules)
  4. Stage flow summary (points to `WORKFLOW.md`)
  5. Doc header schema (summarizes D4.x2)
  6. Link conventions (summarizes D4.x4)
  7. Bilingual (EN/KO) policy and R4 timing rule
  8. **Changelog maintenance** — owned by **D4.b**, body lives here per F-a1
  9. HANDOFF.md manual migration from v0.1/v0.2 (closes plan_final Sec. 7-3 OQ.H2)
  10. Running `scripts/update_handoff.sh`
  11. Code of conduct reference → `CODE_OF_CONDUCT.md`
  12. Per-section ownership table (appendix)
- **File.** `CONTRIBUTING.md` at project root.

### 2-4. Component — `CODE_OF_CONDUCT.md` (D4.c)

- **Responsibility.** Community behavior baseline.
- **Choice.** **Contributor Covenant v2.1** (verbatim), with maintainer contact set to the project owner. Resolves the "base pick" open question.
- **File.** `CODE_OF_CONDUCT.md` at project root.

### 2-5. Component — `templates/HANDOFF.template.md` (D4.x1)

- **Responsibility.** Clean template form of `HANDOFF.md`. Serves as the **write target** for `scripts/update_handoff.sh` (resolves plan_final Sec. 6 DEP.2).
- **Reset protocol.** State sections ARE cleared to placeholder text on copy. Structural sections are preserved byte-for-byte. See Sec. 4-1 for the section classification.
- **File.** `templates/HANDOFF.template.md`.

### 2-6. Component — `docs/notes/decisions.md` (D4.x2/x3/x4 record)

- **Responsibility.** Short quotable record of the three structural decisions. Each decision gets its own H3 with a backlink to this design's Sec. 0. Bundle 1 tool-picker reads THIS file, not this design file, to avoid coupling `.skills/tool-picker/SKILL.md` to Stage-5 design paths.
- **File.** `docs/notes/decisions.md`.
- **Schema.** Front-matter yes (D4.x2 applies to itself — this is an exception but consistent; flag `stage: 5-support`).

---

## 3. Data flow

### 3-1. `update_handoff.sh` end-to-end

```
CLI flags (--section, --status, --change, --dev-history, --dry-run, --write, ...)
           │
           ▼
  [1] Arg parse     ──►  validation error ──►  exit 2, usage printed to stderr
           │
           ▼
  [2] Locate HANDOFF.md target
      (default: ./HANDOFF.md;
       --template uses ./templates/HANDOFF.template.md)
           │
           ▼
  [3] Read file into memory (awk-buffered; ≤ 10 MB guard)
           │
           ▼
  [4] Section locator
      (header regex: ^## Status$  and  ^## Recent Changes$)
           │
           ├── section missing ──► exit 3, clear message, NO write
           │
           ▼
  [5] Section rewriter (by --section scope)
      - status: replace under "## Status" up to next top-level header
      - recent_changes: prepend one row to the markdown table under
        "## Recent Changes", preserving the header row
           │
           ▼
  [6] Diff preview (always emitted on stdout)
           │
           ├── --dry-run (default) ──► exit 0, no file written
           │
           ▼
  [7] Write new content via sponge-style temp-file + atomic rename
           │
           ▼
  [8] Post-write verification (re-read + diff-empty check)
           │
           └── mismatch ──► exit 4, restore backup, print error
           │
           ▼
  exit 0, print "OK — updated HANDOFF.md (section=...)."
```

Error branches covered: missing-section (step 4), malformed table (step 5 → sub-exit 5), write-then-verify mismatch (step 8 → exit 4).

### 3-2. CHANGELOG append flow (manual, no script in v0.3)

`CONTRIBUTING.md Sec. 8` prescribes the manual procedure. No automation in v0.3 (deferred). First entry is written by hand at Stage 12 as "v0.3 — release".

---

## 4. Data models

### 4-1. HANDOFF.md section classification (for `update_handoff.sh` + template reset)

| Section (header) | Class | Reset on template copy? | Script writes? |
|------------------|-------|-------------------------|----------------|
| Title + banner note | structural | no | no |
| `## Status` | state | yes (to placeholder) | yes (if `--section=status` or `both`) |
| `## Bundles (v0.3 scope)` + YAML | structural-with-placeholders | yes (YAML body to empty `bundles: []`) | no (v0.3); v0.4 may extend |
| `## Recent Changes` | state | yes (to single placeholder row) | yes (prepend one row) |
| `## Key Document Links` | structural-with-placeholders | yes (state columns to `⬜ Not started`) | no |
| `## Next Session Prompt` | state | yes (to placeholder template) | no (v0.3); v0.4 may extend |
| Korean mirror (`## 현재 상태` …) | mirror of above | yes (same sections) | yes (same flags; KO keys mirror EN) |

### 4-2. CHANGELOG entry schema

```markdown
## [VERSION] - YYYY-MM-DD

### Added
- …

### Changed
- …

### Fixed
- …
```

Omit empty sub-sections. Entries are in reverse-chronological order (newest at top, below the `# Changelog` H1 and intro paragraph).

### 4-3. YAML frontmatter schema (D4.x2)

```yaml
---
title: string                        # required
stage: integer 1..13 | "5-support"   # required for Stage-5+ docs
bundle: integer | null               # null for cross-bundle
version: integer                     # required, incremented on non-trivial edits
language: "en" | "ko"                # required
paired_with: string (filename)       # optional; required if a .ko.md or .en.md sibling exists
created: YYYY-MM-DD                  # required
updated: YYYY-MM-DD                  # required
status: "draft" | "approved" | "archived"   # optional; default "draft"
supersedes: string (filepath)        # optional
validation_group: integer            # optional; only when Stage 11-relevant
---
```

Unknown fields are allowed (forward compatibility). Parsers must tolerate missing optional fields and must not fail on unknown keys.

---

## 5. API contracts

### 5-1. `scripts/update_handoff.sh` CLI contract

```
update_handoff.sh [OPTIONS]

OPTIONS
  --section <status|recent_changes|both>
                          (default: both)  which section to update
  --status <text>         one-line text for "Current stage:" (status only)
  --status-version <v>    value for "Current version:" (status only)
  --change <text>         one-line text to prepend as a new row in Recent Changes
                          (recent_changes only). Date is auto-set to today (UTC).
  --dev-history <text>    optional: also append a line to docs/notes/dev_history.md
                          under a new entry in the current session.
                          Implies a corresponding Korean append to dev_history.ko.md.
  --file <path>           target HANDOFF.md (default: ./HANDOFF.md)
  --template              write against ./templates/HANDOFF.template.md instead
  --write                 persist changes (default is dry-run)
  --dry-run               explicit dry-run (default; kept for clarity in scripts)
  --no-diff               suppress the diff preview on stdout
  -h, --help              print usage
  -V, --version           print script version
```

### 5-2. Exit codes

| Code | Meaning |
|------|---------|
| 0    | Success (either dry-run or persisted) |
| 1    | Generic runtime failure (reserved) |
| 2    | Usage error (bad flags or missing required text) |
| 3    | Target file missing or section not found |
| 4    | Post-write verification failed; backup restored |
| 5    | Malformed `## Recent Changes` table (header missing or column count mismatch) |

Non-zero exits print a single-line human-readable reason to stderr **and** a machine-parseable key on stdout of the form `error=<code_name>`.

### 5-3. stdout/stderr discipline

- Diff preview → **stdout** (can be piped to `less` / `diff`).
- Informational success messages → **stdout**.
- All errors, usage, and warnings → **stderr**.
- Exit-code rationale (when non-zero and non-obvious) → **stderr**.

---

## 6. Error handling

| Failure | Detection | Action | Exit |
|---------|-----------|--------|------|
| Unknown flag | arg parser | print usage, abort | 2 |
| Missing required `--status` or `--change` | arg parser (per `--section` scope) | print "status/change text required for --section=X" | 2 |
| Target file absent | step 2 | print "HANDOFF.md not found at <path>" | 3 |
| Section header absent | step 4 regex | print "section `## Status` not found" | 3 |
| Malformed table in Recent Changes | step 5 | print "Recent Changes table missing header row" | 5 |
| Disk-full or permission on write | step 7 `mv` fail | leave target untouched (temp-file discarded) | 1 |
| Post-write verify mismatch | step 8 | restore from pre-write backup `.bak`, print "verify mismatch; rolled back" | 4 |
| File > 10 MB guard | step 3 | print "HANDOFF.md unusually large; aborting"; user must investigate | 1 |

No retry logic — every failure surfaces immediately so the user knows state is untouched.

---

## 7. Security considerations

- **No secrets in HANDOFF.md.** Script refuses inputs whose `--status` or `--change` text matches a permissive `TOKEN|SECRET|KEY|PASSWORD|Bearer\s|sk-` regex; prints warning and aborts (exit 2). Mitigates accidental secret leak (v0.2-inherited `security/` modules are unaffected).
- **Input length guard.** `--status` ≤ 500 chars, `--change` ≤ 1000 chars. Long inputs abort (exit 2) to prevent pathological regex behavior.
- **No arbitrary file writes.** Target is always `HANDOFF.md` or the template; `--file` is validated to end in `HANDOFF*.md`.
- **Temp-file in same directory** as target (atomic `mv`); no `/tmp` hop that could be symlink-hijacked.
- **Shellcheck clean.** `shellcheck -S style` must pass (acceptance criterion).
- **No network, no auth, no subprocess spawn beyond coreutils.** "N/A for auth, reason: local read/write only."
- **Logging discipline.** Never log the raw `--status` or `--change` text to a file; stdout/stderr only.

---

## 8. Testing strategy

| Component | Test type | Edge case / assertion |
|-----------|-----------|------------------------|
| `update_handoff.sh` arg parser | unit (shell-based) | unknown flag → exit 2; missing required text → exit 2 |
| `update_handoff.sh` status writer | integration | empty `## Status` body; body with multiple key-value lines; non-ASCII (한글) input preserved |
| `update_handoff.sh` recent_changes writer | integration | empty table (just header); 100-row table (perf smoke); malformed (no leading `\|` — exit 5) |
| `update_handoff.sh` atomic write | integration | simulated write failure via read-only target → exit 1, no corruption |
| `update_handoff.sh` secret-detection | unit | input containing `Bearer eyJ…` aborts with exit 2 |
| `update_handoff.sh` idempotency | integration | `--write` then re-run same command produces zero diff |
| `update_handoff.sh` CRLF line endings | integration | accept CRLF input, preserve original line endings on write |
| `update_handoff.sh` KO mirror | integration | `--section=status` updates both EN and KO status blocks consistently |
| `CONTRIBUTING.md` structure | lint | all 12 required sections present, in order |
| `CHANGELOG.md` | lint | first entry = `## [0.3.0] - YYYY-MM-DD`; Keep-a-Changelog sub-sections valid |
| `HANDOFF.template.md` reset | unit | diff vs. live HANDOFF.md shows only state sections differ |
| D4.x2 frontmatter | lint | every Stage-5+ `.md` has valid YAML block with required fields |
| D4.x4 link conventions | lint | no `file://`, no leading-slash absolute links, no broken relative paths |
| **KO freshness** [OQ.L2 Stage-9 half] | **code-review checklist** | for every Stage-closing doc: KO pair exists and `updated` field ≤ 1 day after EN primary |

Test harness: plain shell scripts under `tests/bundle4/` (single-file per test), executed via a top-level `tests/run_bundle4.sh`. No test framework dependency. Mirrors Bundle 1's "no framework" discipline.

---

## 9. Implementation notes for Codex

### 9-1. Files to create (ordered by dependency)

1. `docs/notes/decisions.md` — three decision records quoting Sec. 0 of this design.
2. `templates/HANDOFF.template.md` — clean-template form per Sec. 4-1.
3. `scripts/update_handoff.sh` — against the template form (DEP.2 resolved).
4. `CHANGELOG.md` with a placeholder "Unreleased" section only; real v0.3 entry written at Stage 12.
5. `CODE_OF_CONDUCT.md` — Contributor Covenant v2.1 verbatim, email placeholder `{PROJECT_MAINTAINER_EMAIL}`.
6. `CONTRIBUTING.md` with the 12 required sections (Sec. 2-3) and the per-section ownership table.
7. `tests/bundle4/` test harness + `tests/run_bundle4.sh`.

### 9-2. Files to modify

- `HANDOFF.md` — no structural change; verify that `## Status` and `## Recent Changes` match the template form field-for-field (structural parity check).
- `CLAUDE.md` — add one line under "Read order" pointing to `CONTRIBUTING.md` for contributor-facing material (preserves existing read order — do NOT reorder).

### 9-3. Constraints (do-not-violate list)

- Do not change any file under `security/` (plan_final Sec. 6 DEP.5 — frozen).
- Do not touch `.skills/tool-picker/SKILL.md` — that is Bundle 1's file (Stage 5 Bundle 1 design + Stage 8 Codex).
- Do not introduce any dependency outside POSIX `sh` + coreutils + shellcheck.
- Do not add YAML frontmatter to any Stage-1–4 doc (D4.x2 exclusion list).
- `HANDOFF.template.md` must never contain a live project's data.
- KO pair discipline: every doc created in this bundle that carries frontmatter must ship a `.ko.md` sibling in the same commit (R4 enforced at Stage 9).

### 9-4. Per-section ownership table (F-a1 remediation — to be placed at the top of CONTRIBUTING.md appendix)

| Section # | Title | Owning deliverable | Notes |
|-----------|-------|-------------------|-------|
| 1 | Purpose & audience | D4.c | — |
| 2 | Quick start | D4.c | — |
| 3 | Directory layout | D4.c (cites D4.x3) | — |
| 4 | Stage flow summary | D4.c | — |
| 5 | Doc header schema | D4.c (cites D4.x2) | — |
| 6 | Link conventions | D4.c (cites D4.x4) | — |
| 7 | Bilingual (EN/KO) policy | D4.c | — |
| 8 | Changelog maintenance | **D4.b** | The one F-a1 exception: maintenance rule for D4.b-owned CHANGELOG.md lives here inside D4.c-owned file. |
| 9 | HANDOFF manual migration | D4.c (closes OQ.H2) | Covers v0.1 → v0.3 and v0.2 → v0.3 paths. |
| 10 | Running `update_handoff.sh` | D4.c (cites D4.a) | — |
| 11 | Code of conduct reference | D4.c (cites `CODE_OF_CONDUCT.md`) | — |
| 12 | Per-section ownership table (this table) | D4.c | Appendix; serves as the F-a1 authoritative record. |

### 9-5. Commit style

Single-deliverable commits, each title prefixed `[bundle4] `. Example: `[bundle4] Add scripts/update_handoff.sh with dry-run default (D4.a)`.
Multi-file atomic commits only when the files are genuinely coupled (e.g. `[bundle4] Add CONTRIBUTING.md + CODE_OF_CONDUCT.md (D4.c)`).
Always include the Korean pair (`.ko.md`) in the same commit as its EN primary (R4 enforcement at Stage 9 code-review).

---

## 10. Out of scope (this implementation)

- **N10** (retroactive EN back-translation of existing KO-only docs). `session_token_economics.md` stays KO-only.
- **N12** (live link-check automation). `update_handoff.sh` does not verify that the file links in `Key Document Links` actually exist on disk. Deferred to v0.4.
- **N7** (CI/CD templates including `.github/` PR/issue templates). Not in this bundle.
- Windows / WSL support for `update_handoff.sh`. POSIX-sh on macOS/Linux only.
- Automated CHANGELOG generation from git log. Manual append per `CONTRIBUTING.md Sec. 8`.
- Migrating existing docs to adopt D4.x2 frontmatter retroactively. Only new Stage-5+ docs from v0.3 forward carry it. (This technical_design.md itself should carry it — add at KO-pair writing step.)
- Link-check across `.ko.md` pairs. Same R4 discipline applies; verification is human/code-review, not automated.

---

## 11. Acceptance criteria (for Stage 9 review)

### 11-1. Primary deliverables

- [ ] **AC.B4.1** — `scripts/update_handoff.sh` passes `shellcheck -S style` with no warnings.
- [ ] **AC.B4.2** — `update_handoff.sh` dry-run on the current live HANDOFF.md produces a non-empty diff preview (smoke: status/change test input); re-running `--write` twice produces zero diff on the second run (idempotency).
- [ ] **AC.B4.3** — `update_handoff.sh` exits non-zero on all nine error cases enumerated in Sec. 6.
- [ ] **AC.B4.4** — `CHANGELOG.md` conforms to "Keep a Changelog" v1.1.0 lint (valid H2 release header format, valid sub-section names).
- [ ] **AC.B4.5** — `CONTRIBUTING.md` contains all 12 required sections in the prescribed order; `## Changelog maintenance` is clearly attributed to D4.b in the appendix table.
- [ ] **AC.B4.6** — `CODE_OF_CONDUCT.md` matches Contributor Covenant v2.1 verbatim except for the maintainer email.

### 11-2. Structural decisions / extras

- [ ] **AC.B4.7** — `docs/notes/decisions.md` records D4.x2/x3/x4 with backlinks to this file Sec. 0. Every downstream Stage-5+ doc cites the same three IDs.
- [ ] **AC.B4.8** — `templates/HANDOFF.template.md` state sections match the classification in Sec. 4-1; structural-parity diff check passes against current HANDOFF.md.
- [ ] **AC.B4.9** — YAML frontmatter lint (Sec. 8) passes for every Stage-5+ doc in the repo, including this one's `.ko.md` pair.

### 11-3. Cross-bundle contract (verified at Stage 11 joint)

- [ ] **AC.B4.10** — Bundle 1 tool-picker parses `docs/notes/decisions.md` (not this tech_design file) to read D4.x2/x3/x4. Verified by grep on `.skills/tool-picker/SKILL.md`.
- [ ] **AC.B4.11** — Bundle 1 recommendation logic (D1.b) follows D4.x4 link conventions in its `worked example` block.

### 11-4. Risk-mitigation verification

- [ ] **AC.B4.12** — Scope creep (plan_final R1) kept in check: D4.x2/x3/x4 each fit in one paragraph + one-line rationale in Sec. 0 of this doc. No per-decision discussion doc was created.
- [ ] **AC.B4.13** — Shell-compat (R5) verified on macOS 14+ and a Linux CI run; output identical modulo line endings.
- [ ] **AC.B4.14** — Dogfooding (R7): CHANGELOG.md contains a v0.3 release entry by end of Stage 12.

### 11-5. Bilingual discipline

- [ ] **AC.B4.15** — Every Stage-5+ doc shipped by this bundle has an `.ko.md` pair in the same git commit. KO sync check block at the top of each is marked complete before Stage 9 submission.
- [ ] **AC.B4.16** — OQ.L2 Stage-9 half: code-review checklist item "KO freshness for stage-closing docs" added to `.github/PULL_REQUEST_TEMPLATE.md`… wait, `.github/` is out of scope (N7). **Instead**, the checklist item lives in `CONTRIBUTING.md Sec. 7` as a bullet reviewers are expected to tick when reviewing Stage-closing PRs. (Resolves OQ.L2 Stage-9 half within scope.)

---

## 12. Codex handoff appendix

### 12-1. Copy-paste kickoff prompt for Stage 8 (Bundle 4 implementation)

```
Implement jDevFlow v0.3 Bundle 4 (Doc Discipline, option β).

Read in order:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md Sec. 10 Stage 8
4. docs/03_design/bundle4_doc_discipline/technical_design.md (this design)
5. docs/03_design/bundle4_doc_discipline/technical_design.ko.md (KO pair)
6. docs/02_planning/plan_final.md Sec. 3-2, 5-2, 6 (context)

Deliverables, in dependency order (Sec. 9-1):
1. docs/notes/decisions.md
2. templates/HANDOFF.template.md
3. scripts/update_handoff.sh  — POSIX sh, shellcheck clean
4. CHANGELOG.md  — Unreleased placeholder only; real v0.3 at Stage 12
5. CODE_OF_CONDUCT.md  — Contributor Covenant v2.1
6. CONTRIBUTING.md  — 12 sections per Sec. 2-3; F-a1 ownership table
7. tests/bundle4/ + tests/run_bundle4.sh  — per Sec. 8 table

Constraints (do NOT violate — Sec. 9-3):
- POSIX sh only; no bashisms
- No security/ changes
- No .skills/tool-picker/ changes (Bundle 1's territory)
- Do NOT add frontmatter to Stage 1–4 docs
- KO pair ships in same commit as EN primary

Report at completion: path of every created/modified file, shellcheck
output, test run output. Then I will enter Stage 9 code review.
```

### 12-2. What Codex may choose

- Exact implementation of the section-locator regex in `update_handoff.sh` (awk vs. sed is Codex's choice).
- The rollback backup file name convention (e.g. `.HANDOFF.md.bak.YYYYMMDDTHHMMSS`).
- Test harness naming inside `tests/bundle4/` as long as `tests/run_bundle4.sh` is the single entry point.

### 12-3. What Codex must NOT decide unilaterally

- Anything that changes D4.x2 / D4.x3 / D4.x4 (Sec. 0 is locked; changes require re-entry to Stage 5).
- Adding a new top-level file or folder not listed in Sec. 9-1.
- CLI flag surface changes to `update_handoff.sh` (escalate via a Stage 9 finding if a gap is discovered).

---

## 13. Forward notes / housekeeping

- **Stage 9 (code review)** — Use the 12-section CONTRIBUTING.md structure + Sec. 8 test table as the review rubric. Item AC.B4.15 is easy to miss; reviewer should explicitly tick it.
- **Stage 11 joint validation** — Dossier for this bundle (`docs/notes/stage11_dossiers/bundle4_dossier.md` per DC.6) should cite AC.B4.1 through AC.B4.16 in its acceptance-criteria table and flag any untick.
- **Stage 13** — This bundle contributes to the single joint `v0.3` git tag (plan_final M.6). CHANGELOG entry "v0.3 — release" lands here.

---

## 14. Revision log for this document

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 — Stage 5 Bundle 4 technical design | Session 3 resumed. Covers D4.a–D4.c + D4.x1–x4; closes OQ.N1, OQ4.1, OQ4.2, OQ.H2, OQ.L2 Stage-9 half. Sec. 0 D4.x2/x3/x4 locked — Bundle 1 Stage 5 unblocked. YAML frontmatter (per D4.x2) added at stage close; KO pair `technical_design.ko.md` written in same session per R4; KO sync check block marked complete. |
