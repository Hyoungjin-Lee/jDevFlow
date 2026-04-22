---
title: Technical Design — Bundle 1 (Tool-Picker)
stage: 5
bundle: 1
version: 1
language: en
paired_with: technical_design.ko.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Technical Design — Bundle 1 (Tool-Picker)

**Project:** jDevFlow v0.3
**Stage:** 5 (Technical Design)
**Date:** 2026-04-22 (session 3 resumed)
**Mode:** Strict-hybrid (upper Strict + inner bundle Standard)
**Input:** `docs/02_planning/plan_final.md` (APPROVED at Stage 4.5 joint, 2026-04-22) · `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 (D4.x2/x3/x4 locked) · `prompts/claude/v03/stage5_bundle1_design_prompt_draft.md` (DC.5 half #2)
**Output paired KO:** `technical_design.ko.md` (written in the same session per R4)
**Risk level:** medium-high
**has_ui:** false

---

## KO sync check (plan_review Sec. 4-3 reusable block)

Check after KO pair is written:

- [x] Section-header count parity between EN and KO
- [x] North-star sentence (or equivalent — see Sec. 1) present and equivalent in KO
- [x] Decision-table shape (stage × mode × risk_level) identical in both files
- [x] Acceptance-criteria item count identical in both files (AC.B1.1–10, 10 items / 10 items)

(Marked complete at stage close 2026-04-22.)

---

## 0. DEP.1 preflight — Bundle 4 Sec. 0 decisions quoted

> **Source.** `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0, locked 2026-04-22. The three decisions below are quoted verbatim (Bundle 1 must bind to them, not re-decide them). Any change requires re-entry to Stage 5 Bundle 4.

- **D4.x2 — Internal doc header schema.** YAML frontmatter on Stage-5-and-later docs only; Stage 1–4 narrative / bilingual docs remain prose-only. Minimum required fields: `title, stage, bundle, version, language, paired_with, created, updated` (optional: `status, supersedes, validation_group`).
- **D4.x3 — Bundle folder naming convention.** `bundle{id}_{name}/` with snake_case `{name}`. Regex `^bundle(\d+)_(.+)$` extracts `{id}` and `{name}` deterministically.
- **D4.x4 — Doc link conventions.** Always relative to the current file; no project-root-absolute paths. Anchor style is GitHub's: lowercase, spaces-to-hyphens, punctuation dropped. `file.md#section-header-lowercased-hyphenated`.

Bundle 1's recommendation logic parses `HANDOFF.md` plus any Stage-5+ doc it cites; it never parses Stage 1–4 docs (they have no frontmatter to key off of). All internal references in `SKILL.md` use the D4.x4 link style.

---

## 1. Architecture overview

Bundle 1 is **one Markdown file** (`.skills/tool-picker/SKILL.md`) consumed by Claude Code's existing skill mechanism. It emits **advisory recommendations** — a ranked list of next-step tools, docs, and checklists — based on the current `(stage, mode, risk_level)` triple read from `HANDOFF.md`. That is the entire surface.

```
┌──────────────────────────────────────────────────────────────────┐
│                    .skills/tool-picker/SKILL.md                  │
├──────────────────────────────────────────────────────────────────┤
│  ── YAML frontmatter ──                                          │
│    name: tool-picker                                             │
│    description: >-                                               │
│      Advisory next-step recommender for jDevFlow. Triggers       │
│      when the user enters a new Stage, asks "what next", or      │
│      mentions jDevFlow + stage/mode/risk. Reads HANDOFF.md       │
│      and returns a ranked action list.                           │
│                                                                  │
│  ── Instructions body ──                                         │
│    Sec. 1  Purpose & scope (advisory-only; R2 invariant)         │
│    Sec. 2  Inputs (HANDOFF.md triple + optional user intent)     │
│    Sec. 3  Decision table (stage × mode × risk_level)            │
│    Sec. 4  Output format (ranked list, chat-printed, not modal)  │
│    Sec. 5  Triggers (stage-entry auto + user-request on-demand)  │
│    Sec. 6  Worked example (Strict-hybrid Stage 2 entry)          │
│    Sec. 7  Failure modes (no-HANDOFF, malformed triple, etc.)    │
│    Sec. 8  Invocation reference (how CLAUDE.md points to this)   │
└──────────────────────────────────────────────────────────────────┘
                      │
                      ▼
     CLAUDE.md "Read order" cites this path so the skill is
     discovered by Claude Code's native skill loader. NO native
     API registration (N14). Pure Markdown surface (R2).
```

**North star for this bundle (derivative of plan_final Sec. 1-1):** At any stage transition, the user sees a **one-screen advisory** — "for this stage in this mode at this risk level, these are the recommended tools/docs/checklists" — without any popup, prompt, shell command, or blocking modal. The user can accept, ignore, or ask follow-ups; the skill never rewrites user intent and never halts progress.

**Risk invariants carried from plan_final Sec. 5:**

- **R2 read-only surface.** No shell commands, no interactive CLIs, no file mutations. Verified as Stage-9 acceptance criterion AC.B1.7.
- **R3 Stage-11 compatibility.** The skill's entire body fits in a DC.6 per-bundle dossier (≤ 1 page prose + ≤ 200 lines diff). Design choice: keep the decision table compact enough that Stage 11's dossier can reproduce it inline.

---

## 2. Components

Bundle 1 is intentionally **one file + one optional reference doc**. No sub-modules.

### 2-1. Component — `.skills/tool-picker/SKILL.md` (D1.a + D1.b + D1.c, single file)

- **Responsibility.** Self-contained skill: frontmatter, recommendation logic (decision table), worked example, failure-mode notes, invocation reference.
- **Anthropic Skills format.** YAML frontmatter (`name`, `description`) + Markdown instructions body. No binary assets, no external includes.
- **Size target.** ≤ 300 lines total (plan_final Sec. 7-1 OQ1.1 lean threshold before splitting). Current design is expected to land around 180–220 lines.
- **File.** `.skills/tool-picker/SKILL.md` (relative to project root).
- **Frontmatter contract.**

  ```yaml
  ---
  name: tool-picker
  description: >-
    jDevFlow advisory tool-picker. Fires on Stage entry, on user
    "what next / which tool" questions, and when the user names a
    jDevFlow stage/mode/risk_level. Reads HANDOFF.md Status fields
    and returns a ranked list of recommended tools, docs, and
    checklists for the current (stage, mode, risk_level) triple.
    Advisory only — never blocks, never rewrites intent, never
    runs shell.
  ---
  ```

  Description wording is **discovery-critical** — the mandatory triggers (`stage`, `mode`, `risk_level`, "next step", "jDevFlow") must appear verbatim for Claude's skill matcher to pick it up.

### 2-2. Component — `docs/notes/tool_picker_usage.md` (D1.x, optional auxiliary)

- **Responsibility.** Short human-facing doc explaining how `SKILL.md` is expected to be invoked, how to inspect its output, and the read-order hook in `CLAUDE.md`.
- **Rationale for a separate doc (vs. inlining in SKILL.md).** Keeps `SKILL.md` lean for Claude's matcher (description parses better when body is short and focused), while still giving humans a narrative landing page. The designer-level choice is to **split**, keeping SKILL.md ≤ 220 lines and the human-facing prose in its own place.
- **Scope.** ≤ 80 lines. Covers (a) where the skill lives, (b) how Claude Code loads it, (c) how the advisory output looks, (d) what the skill is NOT (N5 discovery UX).
- **File.** `docs/notes/tool_picker_usage.md` + `tool_picker_usage.ko.md` (KO pair per R4).
- **Frontmatter per D4.x2.** Stage-5+ doc, so it carries the full frontmatter. `stage: 5-support`, `bundle: 1`.

---

## 3. Data flow

### 3-1. Stage-entry trigger path (OQ1.2 — auto half)

```
User edits HANDOFF.md or Claude itself updates Status
           │
           ▼
  Claude Code detects a HANDOFF.md Status change
  (skill matcher scans description triggers)
           │
           ▼
  Matcher fires tool-picker skill (description match:
    "stage" or "mode" or "risk_level" appearing in recent
    assistant/user turns, OR explicit user phrasing like
    "what next", "which tool")
           │
           ▼
  [1] Read HANDOFF.md Status section
           │
           ├── file missing ──► Sec. 6 "no-HANDOFF" fallback
           │                     ("no advisory; ask user to cd into
           │                     a jDevFlow project root")
           │
           ▼
  [2] Parse triple: (stage, mode, risk_level)
           │
           ├── any field missing / malformed ──► Sec. 6 "malformed"
           │    fallback ("advisory suppressed; the following
           │    fields couldn't be parsed: …")
           │
           ▼
  [3] Decision-table lookup (Sec. 3-2)
           │
           ▼
  [4] Render ranked list (Sec. 4 output format)
           │
           ▼
  Chat message printed (non-modal, advisory tone).
  User may accept, ignore, or ask follow-ups.
```

### 3-2. User-request trigger path (OQ1.2 — on-demand half)

```
User: "which tool should I use now?" / "what next?" /
      "recommend the next step for this stage"
           │
           ▼
  Matcher fires the same tool-picker skill
           │
           ▼
  Same [1]–[4] pipeline as 3-1.
```

There is only one pipeline; the two triggers share the same decision logic. This keeps the skill body at one code path and makes R2 invariant verification trivial.

### 3-3. Decision table (D1.b)

Rows = stages. Columns = (mode, risk_level) pairs. Cell = ordered recommendation list.

Scope of the in-scope table (minimum coverage per DC.5 half #2 requirement): **stages 2, 3, 5, 8, 9, 11** × modes **Standard | Strict | Strict-hybrid** × risk levels **medium | medium-high**.

Each cell emits **three kinds of recommendation**:

1. **Primary tool / doc to open next** (exactly one).
2. **Checklist to keep in view** (zero or one — e.g. Sec. 0 KO sync block, approval checklist).
3. **Warning to watch for** (zero or one — e.g. R2 drift at Stage 5 Bundle 1).

Cells not listed default to the **fallback row** (see Sec. 4-1).

| Stage | Strict-hybrid · medium | Strict-hybrid · medium-high | Standard · medium | Strict · medium |
|------:|------------------------|------------------------------|--------------------|-----------------|
| 2  Plan Draft | `prompts/claude/plan_draft.md` + `plan_draft.md` scaffold · AC.1–AC.4 sketch · watch top-3 risk depth | same + AC.5–AC.7 (Strict-hybrid extras) · risk depth ≥ plan_final Sec. 5 | `plan_draft.md` scaffold · AC.1–AC.4 · no extras | `plan_draft.md` scaffold · AC.1–AC.4 · watch scope creep |
| 3  Plan Review | `plan_review.md` (focus: coverage / top-3 / OQ containment / KO sync) · plan_review Sec. 4-3 KO check · watch Stage-4 leaks | same + explicit joint-approval note (M.1) · KO check · watch OQ promotion to committed rule (M.x) | `plan_review.md` · lighter KO check · none | same as Strict-hybrid medium (no extras) · none |
| 5  Tech Design | `prompts/claude/technical_design.md` · D4.x2/x3/x4 quote block (if Bundle 1) · watch R2 drift (N5) | same · DEP.1 gate visible · watch scope extras (D1.x / D4.x1–x4) | `technical_design.md` · no KO block · none | same · Codex handoff appendix required |
| 8  Implementation | Codex kickoff prompt (Sec. 12-1 of relevant tech design) · per-section ownership table · watch constraint violations | same · joint-commit discipline (R4 KO pairs) | Codex kickoff prompt · no ownership table | same · full constraint list |
| 9  Code Review | `prompts/claude/code_review.md` · AC.Bn.1–N from the relevant tech design · watch KO freshness (OQ.L2 Stage-9 half) | same · joint-verdict coupling (R9) · watch design-level escalation | code review prompt · basic AC check | same |
| 11 Final Validation | DC.6 kickoff prompt (`stage11_joint_validation_prompt.md`) · dossier format (≤ 1 p. + ≤ 200 lines) · watch R3 context exhaustion | same · **joint fresh session** (M.3) · divergent-verdict policy (M.5) · R3 | DC.6 (if applicable) · basic | same |

**Fallback row (any stage not listed).** Recommend: the canonical prompt from `prompts/claude/` matching the stage name if one exists; otherwise "no specific recommendation — ask user what they want". Never invent a prompt path.

---

## 4. Data models

### 4-1. Recommendation output shape

The skill emits a single **Markdown block** into the chat. Shape:

```markdown
**jDevFlow tool-picker advisory** — (stage X, mode Y, risk_level Z)

**Next step (primary):**
1. [primary recommendation — with a relative path per D4.x4 when a file reference applies]

**Checklist to keep open:**
- [checklist recommendation, if any]

**Watch-out:**
- [warning, if any]

_Advisory only — not blocking. Say "skip" to dismiss, or ask a follow-up._
```

- The trailing dismissal line is always present. This is the R2-read-only invariant made visible.
- "Next step (primary)" is always a numbered list of length ≥ 1 even when the cell recommends only one thing — gives the output a consistent shape for downstream parsing (e.g. the Stage 11 dossier renderer).
- Empty checklist/watch-out sub-blocks are **omitted** (not rendered as `- none`), to keep output short.

### 4-2. HANDOFF triple parse rule

The skill reads `HANDOFF.md` and extracts `(stage, mode, risk_level)` by simple line match against the `## Status` section — specifically:

- `**Current stage:**` line → `stage`. Accept numeric (`Stage 5`), word (`Stage 5 Bundle 4`), or checkpoint (`Stage 4.5`). Strip trailing description; take the leading stage identifier.
- `**Workflow mode:**` line → `mode`. Accept `Strict`, `Standard`, `Strict-hybrid` (case-insensitive).
- `**risk_level:**` line → `risk_level`. Accept `low`, `low-medium`, `medium`, `medium-high`, `high`.

Anything else in `## Status` is ignored. This is deliberately brittle for v0.3 — the HANDOFF schema is not yet versioned, so the skill's parser is the source of truth for what "the triple" means.

### 4-3. Decision-table internal representation (authoring form in `SKILL.md` body)

The table in Sec. 3-3 is **authored directly in Markdown** inside `SKILL.md`. No separate YAML/JSON. Claude reads the table the same way a human would. This keeps the skill's entire surface inspectable and avoids a second parser path.

Cell format convention inside `SKILL.md`:

```
[primary] · [checklist] · [watch-out]
```

Bullets within a cell use `·` as a separator. When a slot is empty, it is rendered as the placeholder `—`. The output renderer (Sec. 4-1) reads these positions and only emits non-`—` entries.

---

## 5. API contracts

**N/A, reason: pure Markdown skill consumed natively by Claude Code's skill mechanism. No callable API surface exists.**

The skill's "contract" is:

- Frontmatter `name: tool-picker` (fixed).
- Frontmatter `description` containing the mandatory trigger vocabulary (Sec. 2-1).
- Body structure matching Sec. 1's 8-section layout.

Any downstream consumer (e.g. Bundle 4 CONTRIBUTING.md Sec. 10) that wants to reference the skill does so by path: `.skills/tool-picker/SKILL.md`. There is no programmatic import.

---

## 6. Error handling

| Failure | Detection | Action |
|---------|-----------|--------|
| `HANDOFF.md` not found at project root | stage [1] of Sec. 3-1 | Print "tool-picker: no HANDOFF.md found at project root; advisory suppressed. If this is a jDevFlow project, confirm you are in the project root." Do NOT recurse into parent directories. |
| `## Status` section missing from HANDOFF.md | stage [1] | Print "tool-picker: HANDOFF.md has no `## Status` section; advisory suppressed. See `CONTRIBUTING.md` Sec. 9 for manual migration." |
| Triple field missing or malformed | stage [2] | Print "tool-picker: couldn't parse [field names]; advisory suppressed. Expected format: `**Current stage:** Stage N`, `**Workflow mode:** Strict-hybrid`, `**risk_level:** medium`." |
| Stage matches no decision-table row | stage [3] | Fall through to Sec. 3-3 **fallback row**. Print the `prompts/claude/` match if one exists; otherwise "no specific recommendation — ask user what they want". |
| Decision cell empty (authoring bug) | stage [3] | Print "tool-picker: decision table cell empty for (stage=X, mode=Y, risk=Z); this is a skill bug — please file." |
| User says "skip" / "dismiss" | chat follow-up | Skill does nothing (advisory is dismissed; no state stored). On next trigger it will run again. |

**No retry logic.** Every failure prints a single advisory-suppressed notice and exits. The user is never blocked by a skill failure.

---

## 7. Security considerations

- **No shell execution.** The skill body contains **zero** executable code. Grep check: `grep -E '\b(bash|sh|python|node|eval|exec)\b' SKILL.md` must return only references inside example code fences, not imperative instruction to Claude. Verified as AC.B1.7.
- **No file writes.** The skill reads `HANDOFF.md` only. It never instructs Claude to modify any file. Verified as AC.B1.7.
- **No secret handling.** The skill never reads, prints, or stores credentials. If `HANDOFF.md` contains a secret (shouldn't, per Bundle 4 D4.a secret-detection rule), the skill's parser does not expose it — it only matches `**Current stage:**` / `**Workflow mode:**` / `**risk_level:**` lines.
- **No user-supplied paths.** The only path the skill touches is the well-known `HANDOFF.md` at the project root. User-supplied paths in follow-up chat are treated as conversation, not parsed as file references.
- **N/A for network, auth, persistence — reason: read-only Markdown instruction, no side effects.**

---

## 8. Testing strategy

| Item | Type | Assertion |
|------|------|-----------|
| Frontmatter YAML validity | lint | `name: tool-picker`, `description:` present, description includes all mandatory triggers (`stage`, `mode`, `risk_level`, "next step", "jDevFlow") |
| Decision-table completeness | lint | Every cell in the in-scope table (stages 2/3/5/8/9/11 × 4 mode-risk columns) has a non-empty `[primary]` slot |
| Decision-table row linkout validity | lint | Every `prompts/claude/...` path cited resolves to an actual file (relative to repo root); every `docs/...` path resolves |
| R2 read-only invariant | lint (grep-based) | No occurrence of `run`, `execute`, `shell`, `bash $`, `sh $`, `python $` in imperative instruction voice (example code fences allowed) |
| Worked example — Stage 2 entry | snapshot | The rendered example (Sec. 6 of SKILL.md) compiles against the current `HANDOFF.md` — triple is extractable and matches the example's opening claim |
| HANDOFF triple parser — normal | unit (manual walk) | On current live HANDOFF.md, (stage, mode, risk_level) parses to ("Stage 5 Bundle 1" or similar, "Strict-hybrid", "medium") |
| HANDOFF triple parser — missing Status | unit | With `## Status` removed, skill emits the "Section missing" advisory-suppressed message (Sec. 6) |
| Fallback row behavior | unit | For a fabricated stage = "Stage 7" entry, skill emits the fallback row (canonical prompt match or "no recommendation") |
| Output format stability | snapshot | For a sampled cell, the rendered output matches the Sec. 4-1 template exactly (so Stage 11 dossier can parse it) |
| Invocation reference freshness | lint | `docs/notes/tool_picker_usage.md` cites the current `.skills/tool-picker/SKILL.md` path; `CLAUDE.md` Read order includes a pointer line |
| **KO freshness** [cross-bundle OQ.L2] | code-review checklist | `docs/notes/tool_picker_usage.ko.md` exists and has an `updated` field ≤ 1 day after the EN primary's `updated` — same rule as Bundle 4 |

Test harness: one shell script under `tests/bundle1/run_bundle1.sh` that greps / diffs the skill file. No test framework. Mirrors Bundle 4's "no framework" discipline.

---

## 9. Implementation notes for Codex

### 9-1. Files to create

1. `.skills/tool-picker/SKILL.md` — the full skill (frontmatter + 8-section body per Sec. 1).
2. `docs/notes/tool_picker_usage.md` — the D1.x human-facing reference doc.
3. `docs/notes/tool_picker_usage.ko.md` — KO pair (ships in same commit per R4).
4. `tests/bundle1/run_bundle1.sh` — lint + snapshot checks per Sec. 8.

### 9-2. Files to modify

- `CLAUDE.md` — add one line under "Read order" pointing to `.skills/tool-picker/SKILL.md` so Claude Code loads the skill on session start. **Do NOT reorder** existing entries. Bundle 4 is also modifying this file (to reference `CONTRIBUTING.md`); coordinate in one commit per Sec. 9-5.
- Nothing else. In particular, no change to `HANDOFF.md` is required from Bundle 1 — the skill only reads it.

### 9-3. Constraints (do-not-violate list)

- **No shell commands** anywhere in the skill body. No `bash`, `sh`, `python`, `curl`, `wget`, `eval`, `exec`. Example fences that show output format are allowed only if clearly marked as output, not instruction.
- **No interactive CLI.** No "run this and paste the result" flows.
- **No native Skill API registration** (OQ1.3 lean per N14). The skill is discovered via CLAUDE.md Read-order citation plus Claude Code's existing matcher.
- **No splitting into `rules/*.md`** in v0.3. If the body exceeds 300 lines during Codex implementation, escalate as a Stage 9 finding rather than splitting unilaterally (OQ1.1 lean).
- **Do not change anything under `security/`** (plan_final Sec. 6 DEP.5 — frozen).
- **Do not touch Bundle 4 files** (`scripts/update_handoff.sh`, `CONTRIBUTING.md`, `CHANGELOG.md`, `CODE_OF_CONDUCT.md`, `templates/HANDOFF.template.md`, `docs/notes/decisions.md`). Those are Bundle 4's territory.
- **KO pair ships in the same commit as EN primary** for `tool_picker_usage.md`. `SKILL.md` itself is English-only (Anthropic Skills format convention; bilingual skill descriptions would confuse the matcher).

### 9-4. Paths in the decision table

Every `prompts/claude/...` and `docs/...` path in the Sec. 3-3 table is relative **to project root** when referenced from a file emitted into the chat (the advisory is seen outside any specific file's context). This is a **deliberate narrow exception** to D4.x4's "always relative to current file" rule — the advisory has no current file, so project-root-relative is the natural idiom.

When the skill body itself cites a path for pedagogical purposes (e.g. in the worked example), it uses D4.x4 current-file-relative syntax.

### 9-5. Commit style

Single-deliverable commits, each title prefixed `[bundle1] `. Example: `[bundle1] Add .skills/tool-picker/SKILL.md with decision table (D1.a/D1.b/D1.c)`.

Coordinate the `CLAUDE.md` Read-order edit with Bundle 4's Read-order edit: **one joint commit** `[bundle1+bundle4] Update CLAUDE.md Read order (tool-picker + CONTRIBUTING)` if they land in the same session; otherwise each bundle adds its own line in its own commit and the other bundle rebases.

---

## 10. Out of scope (this implementation)

- **N5** — Discovery UX. No popup, no menu, no settings surface. The skill is Markdown + Claude Code's native matcher.
- **N9** — Skill versioning / skill registry. v0.3 ships exactly one version of this skill; versioning is deferred.
- **N14** — Native Skill API registration. Not used; CLAUDE.md Read-order citation is the entire discovery mechanism.
- **Bundle 2/3 functionality.** No metadata refinement (Bundle 2), no Codex-handoff UX beyond the kickoff prompts already drafted (Bundle 3). Deferred to v0.4.
- **Non-English skill body.** `SKILL.md` is English only. The D1.x auxiliary doc is bilingual (per R4) but the skill itself is not.
- **Dynamic HANDOFF schema evolution.** The parser (Sec. 4-2) targets the v0.3 HANDOFF layout; v0.4 schema changes will require a skill update.
- **Stage 6/7 (UI) recommendations.** `has_ui=false` — the decision table has no rows for Stage 6 or 7, and the fallback row handles them by saying "no advisory for UI stages in v0.3 (has_ui=false)".

---

## 11. Acceptance criteria (for Stage 9 review)

- [ ] **AC.B1.1** — `.skills/tool-picker/SKILL.md` exists, ≤ 300 lines, with valid YAML frontmatter containing `name: tool-picker` and a `description` that includes all five mandatory trigger terms (`stage`, `mode`, `risk_level`, "next step", "jDevFlow").
- [ ] **AC.B1.2** — Instructions body contains all 8 sections enumerated in Sec. 1 in order.
- [ ] **AC.B1.3** — Decision table (Sec. 3-3) covers stages 2 / 3 / 5 / 8 / 9 / 11 × modes Standard / Strict / Strict-hybrid × risk_levels medium / medium-high, with every cell having a non-empty primary recommendation.
- [ ] **AC.B1.4** — Every path cited in decision-table cells resolves to an existing file or is clearly marked "(to be created at Stage X)".
- [ ] **AC.B1.5** — Worked example (D1.c) is ≥ 15 lines, shows a Stage-2 entry in Strict-hybrid mode end-to-end (trigger → HANDOFF read → decision lookup → advisory printed → user acknowledgment), and compiles against the current `HANDOFF.md`.
- [ ] **AC.B1.6** — D1.x reference (`docs/notes/tool_picker_usage.md`) exists with its `.ko.md` pair, ≤ 80 lines, YAML frontmatter per D4.x2 with `stage: 5-support`, `bundle: 1`.
- [ ] **AC.B1.7** — **R2 read-only invariant.** `grep -E '\b(bash|sh |python|node|eval|exec |curl|wget)\b' .skills/tool-picker/SKILL.md` returns only matches inside code fences or quoted example output — zero imperative-voice instructions for Claude to execute anything. Reviewer explicitly signs off.
- [ ] **AC.B1.8** — Bundle 4 Sec. 0 decisions are quoted verbatim in this file's Sec. 0 and in `SKILL.md` where D4.x2/x3/x4 are referenced; no paraphrase.
- [ ] **AC.B1.9** — Frontmatter description is under the Anthropic skill-description length guidance (~1024 characters). Measured and recorded in Stage 9.
- [ ] **AC.B1.10** — KO sync: `docs/notes/tool_picker_usage.ko.md` exists, `updated` ≤ 1 day after EN primary's `updated`, and the KO sync check block at the top of this design file is fully ticked.

---

## 12. Codex handoff appendix

### 12-1. Copy-paste kickoff prompt for Stage 8 (Bundle 1 implementation)

```
Implement jDevFlow v0.3 Bundle 1 (tool-picker).

Read in order:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md Sec. 10 Stage 8
4. docs/03_design/bundle1_tool_picker/technical_design.md (this design)
5. docs/03_design/bundle1_tool_picker/technical_design.ko.md (KO pair)
6. docs/03_design/bundle4_doc_discipline/technical_design.md Sec. 0 (D4.x2/x3/x4)
7. docs/02_planning/plan_final.md Sec. 3-1, 5-2, 7-1 (context)

Deliverables (Sec. 9-1):
1. .skills/tool-picker/SKILL.md — frontmatter + 8-section body
2. docs/notes/tool_picker_usage.md + .ko.md — D1.x reference
3. tests/bundle1/run_bundle1.sh — lint + snapshot checks

Modifications (Sec. 9-2):
- CLAUDE.md — add ONE line under "Read order" pointing to
  .skills/tool-picker/SKILL.md. Do NOT reorder existing lines.

Constraints (do NOT violate — Sec. 9-3):
- NO shell commands, no interactive CLIs, no native Skill API
- NO changes under security/ or Bundle 4 files
- Keep SKILL.md ≤ 300 lines (escalate if over)
- R2 read-only invariant: grep -E '\b(bash|sh |python|node|eval|exec)\b'
  returns only matches inside code fences / quoted output

Output approach (plan_final Sec. 7-5 OQ.C1 lean):
- Codex generates the initial SKILL.md draft
- Claude polishes (description wording, worked example fit)

Report at completion: paths of created/modified files, linter output,
snapshot test output. Then I will enter Stage 9 code review.
```

### 12-2. What Codex may choose

- Exact wording of the decision-table cells (the table shape is fixed; cell text is Codex's draft, Claude polishes).
- Choice of separator inside multi-recommendation cells — `·` (Sec. 4-3) is the design recommendation; Codex may pick `;` if `·` is problematic in its rendering.
- The worked example's narrative details (which specific stage 2 deliverable is mentioned, etc.), as long as AC.B1.5 is met.

### 12-3. What Codex must NOT decide unilaterally

- Frontmatter `name` value (must be `tool-picker`, exactly).
- Splitting SKILL.md into `rules/*.md` (if the draft exceeds 300 lines, raise a Stage 9 finding — do not split).
- Removing any mandatory trigger term from the description.
- Adding a shell-command or CLI surface (R2 violation — immediate Stage 9 block).
- Binding to any native Skill API (N14 violation).

---

## 13. Forward notes / housekeeping

- **Stage 9 (code review).** Use AC.B1.1–10 as the review rubric. AC.B1.7 (R2 invariant) is the headline item. AC.B1.10 (KO sync) is easy to miss — reviewer explicitly ticks.
- **Stage 11 joint validation.** Bundle 1 dossier at `docs/notes/stage11_dossiers/bundle1_dossier.md` (per DC.6) cites AC.B1.1–10 and reproduces the Sec. 3-3 decision table inline. Keep that dossier ≤ 1 page + ≤ 200 lines diff (R3).
- **v0.4 pointer.** Bundles 2 and 3 will consume this skill as-is; design leaves room for added table rows (more stages, more modes) without structural change.
- **Stage 13.** Single joint `v0.3` tag (M.6) — no Bundle-1-specific tag.

---

## 14. Revision log for this document

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 — Stage 5 Bundle 1 technical design | Session 3 resumed. Covers D1.a–D1.c + D1.x; closes OQ1.1 (single file ≤ 300 lines), OQ1.2 (both triggers, one pipeline), OQ1.3 (no native API). Sec. 0 quotes Bundle 4 D4.x2/x3/x4 verbatim per DEP.1. AC.B1.1–10 enumerated. YAML frontmatter applied at write time per D4.x2. KO pair `technical_design.ko.md` written same session per R4; KO sync check block marked complete. |
