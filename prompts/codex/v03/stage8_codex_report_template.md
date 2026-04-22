---
title: Stage 8 Codex completion report templates (Bundle 4 + Bundle 1)
stage: 8
bundle: null
version: 1
language: en
paired_with: null
created: 2026-04-22
updated: 2026-04-22
status: ready
validation_group: 1
---

# Stage 8 Codex completion report templates

> **Purpose.** This file holds the *example shape* of the completion report
> Codex should paste back into the next Claude session. It is intentionally
> separated from the kickoff prompts so that Codex never sees these examples
> mixed into its instructions. (Past failure mode: Codex was handed the
> "Expected report back" example block instead of the actual prompt block,
> and dutifully produced an empty "implementation complete" message with
> no real file writes.)
>
> **Audience.** The human operator (Hyoungjin), and Claude during the
> Stage 9 review session. Do **not** paste this file into Codex.

---

## How to use

1. After Codex finishes a Stage 8 run, copy the relevant template below.
2. Replace bracketed placeholders with the actual Codex output (paths,
   line counts, command output).
3. Paste the filled template into the Section labelled
   `=== CODEX STAGE 8 COMPLETION REPORT — BUNDLE x ===` inside
   `prompts/claude/v03/session4_post_codex_resume_prompt.md`'s body when
   starting the next Claude session.

---

## Bundle 4 — completion report template

```
Stage 8 Bundle 4 implementation complete.

Files created:
- docs/notes/decisions.md                        ([N] lines)
- templates/HANDOFF.template.md                  ([N] lines)
- scripts/update_handoff.sh                      ([N] lines, shellcheck clean)
- CHANGELOG.md                                   ([N] lines)
- CODE_OF_CONDUCT.md                             (Contributor Covenant v2.1 verbatim)
- CONTRIBUTING.md                                ([N] lines, 12 sections + F-a1 appendix)
- tests/bundle4/test_update_handoff.sh           ([N] lines)
- tests/bundle4/fixtures/*                       ([N] files)
- tests/run_bundle4.sh                           (entry point)

Files modified:
- docs/04_implementation/implementation_progress.md   (Stage 8 section appended)

shellcheck scripts/update_handoff.sh:
[paste full output — must be clean per AC.B4.1]

tests/run_bundle4.sh:
[paste full output; all tests should pass]

D4.x2 frontmatter scope check:
[confirm Stage 1–4 docs were NOT given frontmatter]

AC.B4.x notes (only AC items where a judgement call was made):
- AC.B4.x : ok
- AC.B4.y : ok with judgement — [one-line note]
- ...

Ready for Stage 9 code review.
```

---

## Bundle 1 — completion report template

```
Stage 8 Bundle 1 implementation complete.

Files created:
- .skills/tool-picker/SKILL.md              ([N] lines, must be ≤ 300)
- docs/notes/tool_picker_usage.md           ([N] lines, ≤ 80)
- docs/notes/tool_picker_usage.ko.md        ([N] lines)
- tests/bundle1/run_bundle1.sh              ([N] lines)
- tests/bundle1/snapshots/*                 ([N] files)

Files modified:
- CLAUDE.md                                  (one line added under Read order;
                                              if joint with Bundle 4 in same
                                              session, commit labelled
                                              [bundle1+bundle4])
- docs/04_implementation/implementation_progress.md   (Stage 8 section appended)

Linter output:
[paste full markdownlint or equivalent output]

AC.B1.7 grep test (R2 read-only invariant):
$ grep -E '\b(bash|sh |python|node|eval|exec |curl|wget)\b' .skills/tool-picker/SKILL.md
[paste output — matches must all be inside code fences or quoted example output]

tests/bundle1/run_bundle1.sh:
[paste full output; all tests should pass]

SKILL.md size:
$ wc -l .skills/tool-picker/SKILL.md
[paste output — must be ≤ 300; if > 300, raise Stage 9 finding instead of splitting]

KO pair sync (AC.B1.10):
[confirm tool_picker_usage.ko.md mirrors tool_picker_usage.md]

Decision-table cells needing Claude polish review (Sec. 9-1 of Bundle 1 design):
- stage X × (mode Y, risk Z): [draft wording]
- ...

Ready for Stage 9 code review.
```

---

## What "good" looks like

A correctly executed Stage 8 report should have:

- **Real file paths** (not bracketed placeholders).
- **Real line counts** from `wc -l`, not "[N]".
- **Real command output** pasted in for shellcheck / tests / grep, not the
  literal `[paste full output]` placeholder.
- **Specific AC notes** — at least one entry per bundle, even if it's just
  "no judgement calls; followed spec verbatim".

If a report comes back with bracketed placeholders intact, that is a
**signal that Codex did not actually do the work** — treat it as Stage 8
failure and re-run with the kickoff prompt, not the report template.
