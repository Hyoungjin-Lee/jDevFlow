---
title: Stage 8 Codex coordination notes (Bundle 4 + Bundle 1)
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

# Stage 8 Codex coordination notes — Bundle 4 + Bundle 1

> **Audience:** Whoever is orchestrating the Codex runs between Stage 5 close (2026-04-22)
> and the next Claude resumption session. Usually Hyoungjin.

---

## 1. Run order (non-negotiable)

1. **Bundle 4 first.** It creates `docs/notes/decisions.md`, which is the DEP.1 quotable record for Bundle 1.
2. **Bundle 1 second.** Preconditions must pass (see `stage8_bundle1_codex_kickoff.md` → "Precondition checklist").

> ⛔ Do not run Bundle 1 first. Bundle 1 cites Bundle 4's `decisions.md` verbatim; running in reverse means Codex either re-derives D4.x2/x3/x4 (violates DEP.1) or stalls.

---

## 2. Single-session vs. two-session decision

### Option A — Both bundles in **one** Codex session (recommended if time/context allows)

- Pros: Single `[bundle1+bundle4]` CLAUDE.md commit (Sec. 9-5 of Bundle 1 design), single progress-log entry, simpler Stage 9 batch review.
- Cons: Larger diff; if either bundle fails hard, the other's work also stays uncommitted.
- Commit discipline: one commit per bundle is still fine; only the CLAUDE.md edit needs joint-label if touched in the same session.

### Option B — Two Codex sessions (fallback if context is tight)

- Bundle 4 session ships independently; Bundle 1 session rebases onto Bundle 4's committed state.
- `docs/04_implementation/implementation_progress.md` gets two Stage-8 subsections (one per session date).
- Claude resumption prompt works equally well for either path — it just reads the progress log.

---

## 3. What Claude needs back from Codex

For the Stage 9 code review session to be efficient, each Codex run should end with a
**completion report pasted into the Claude resumption message** containing:

### Universal fields

- **Bundle:** 4 or 1
- **Files created** (with line counts for the big ones)
- **Files modified**
- **Test output** — paste the full stdout of the bundle's test runner
- **AC items with judgement calls** — one line per AC.Bx.y where Codex made a non-trivial choice

### Bundle-4-specific

- `shellcheck scripts/update_handoff.sh` output (must be clean)
- `tests/run_bundle4.sh` full output
- Confirmation that Stage 1–4 docs were NOT given frontmatter (D4.x2 scope respected)

### Bundle-1-specific

- AC.B1.7 grep output: `grep -E '\b(bash|sh |python|node|eval|exec |curl|wget)\b' .skills/tool-picker/SKILL.md`
- SKILL.md line count (must be ≤ 300; if it crept over, raise a Stage 9 finding — do NOT split)
- Decision-table cells flagged for Claude polish

---

## 4. Failure modes to escalate (do NOT let Codex silently fix)

| Symptom | Why it matters | Action |
|---------|---------------|--------|
| SKILL.md > 300 lines | OQ1.1 explicitly chose single-file; escalation is the prescribed response | Stop. Raise a Stage 9 finding. |
| R2 invariant grep matches outside code fences | Skill surface is leaking a shell-command affordance | Stop. Raise a Stage 9 finding. |
| D4.x2 applied to a Stage 1–4 doc | Scope creep on structural discipline | Stop. Revert that file. |
| `update_handoff.sh` bashism (shellcheck SC2128 etc.) | POSIX-sh contract broken | Fix in place; re-run shellcheck. |
| KO pair missing or stale | R4 violation | Create / refresh before reporting complete. |
| New top-level file not in Sec. 9-1 of the respective design | Unilateral scope expansion | Stop. Raise a Stage 9 finding. |

---

## 5. After Codex finishes

1. Paste each bundle's completion report into a single consolidated message.
2. Start a **new Claude session** using the prompt at
   `prompts/claude/v03/session4_post_codex_resume_prompt.md`.
3. Claude resumes at Stage 9 (code review). Stages 10 (debug), 11 (joint validation — fresh
   session per M.3), 12 (QA), 13 (release) follow.

---

## 6. Quick links

- Bundle 4 Codex kickoff: `prompts/codex/v03/stage8_bundle4_codex_kickoff.md`
- Bundle 1 Codex kickoff: `prompts/codex/v03/stage8_bundle1_codex_kickoff.md`
- Codex completion-report templates (operator-only, not for Codex):
  `prompts/codex/v03/stage8_codex_report_template.md`
- Post-Codex Claude resume prompt: `prompts/claude/v03/session4_post_codex_resume_prompt.md`
- Bundle 4 tech design: `docs/03_design/bundle4_doc_discipline/technical_design.md`
- Bundle 1 tech design: `docs/03_design/bundle1_tool_picker/technical_design.md`
- Canonical Stage-8 template (v0.2 baseline): `prompts/codex/implementation.md`

---

## 7. v2 kickoff structure (post-2026-04-22 redesign)

Both kickoff documents (`stage8_bundle{4,1}_codex_kickoff.md`) were rewritten
to v2 on 2026-04-22 after a paste-target mix-up: the operator pasted the
"Expected report back" example block from the bottom of v1 into Codex
instead of the actual prompt block. v2 changes:

- Each kickoff contains exactly **one** fenced code block intended for
  Codex (the "Codex prompt — paste this exact block" section).
- A prominent "⚠️ Operator instruction" banner appears above that single
  block to call out which content is the paste target.
- Example completion-report shapes were moved out of the kickoffs into
  the new `stage8_codex_report_template.md` so they can never be mistaken
  for an instruction block.
- The Codex prompt body now starts with a **STEP 0 quote-back gate**:
  Codex must read the spec files and quote the structural decisions
  (D4.x2/x3/x4, AC rubric, deliverables list) verbatim before being
  allowed to write any file. This catches "empty implementation complete"
  reports at the source.

---

## 8. Missing archive of Codex STEP 7 report (2026-04-22, Bundle 1)

**Symptom.** The operator opened a fresh Claude session with
`prompts/claude/v03/session5_post_codex_bundle1_resume_prompt.md`, whose
reading order points Claude at
`prompts/codex/v03/stage8_bundle1_codex_report.md` for the archived Codex
completion paste. Codex's Bundle 1 *artifacts* were all on disk
(`.skills/tool-picker/SKILL.md`, `docs/notes/tool_picker_usage.{md,ko.md}`,
`tests/bundle1/run_bundle1.sh`), but the report archive file did not
exist. Claude stopped before entering Stage 9 and asked the operator to
decide between (A) re-requesting only the STEP 7 paste from Codex since
artifacts were present, or (B) re-running Stage 8 from scratch. Operator
chose (A).

**Why it matters.**

- Stage 9 disposition logic depends on Codex's self-flagged judgement
  calls (STEP 7 report Sec. 7 — "Decision-table cells needing Claude
  polish"). Without the archive, the "accept / tighten rubric / tighten
  design doc" disposition precedent from Stage 9 Bundle 4 (AC.B4.3
  nine-error-cases, resolved by expanding Sec. 6 inline) cannot be
  applied — Claude has nothing to react to.
- M.3 forces Stage 9 into a fresh Claude session. Discovering the
  missing archive *after* that session has already bootstrapped wastes
  the context budget that was meant for the review itself.
- The report template's "What 'good' looks like" section treats
  bracketed placeholders (`[N]`, `[paste output]`) as a Stage 8 failure
  signal. A **missing archive entirely** is a stronger failure signal
  and should be caught earlier than the Claude session bootstrap.

**Root cause.** Bundle 4 archival worked because the operator manually
created `stage8_bundle4_codex_report.md` right after Codex returned its
paste. Bundle 1's post-Codex workflow had the same manual step but it
was not a documented precondition of the session5 resume prompt. The
"After Codex finishes" block at the bottom of
`stage8_bundle1_codex_kickoff.md` mentions the archive target, but
the operator-facing session5 prompt has no pre-flight verification that
the archive actually exists before a fresh Claude session is started.

**Fix applied (2026-04-22) — three layers, each removes a slice of
operator toil, primary fix is elimination of the manual archive step.**

1. **Layer 1 — Codex writes the archive itself (primary, producer-side).**
   `stage8_bundle1_codex_kickoff.md` STEP 7 rewritten into STEP 7.1 +
   7.2. STEP 7.1 now instructs Codex to write
   `prompts/codex/v03/stage8_bundle1_codex_report.md` to disk itself with
   the full YAML frontmatter block (`status: archived`, `stage: 8`,
   `bundle: 1`) and the standard header prose, then run the
   `ls / head / grep` verification commands. STEP 7.2 keeps the paste-back
   as redundancy. The bundle 4 kickoff was updated symmetrically for
   pattern consistency.
2. **Layer 2 — Claude auto-verifies at session start (consumer-side).**
   `prompts/claude/v03/session5_post_codex_bundle1_resume_prompt.md`'s
   EN and KO copy-paste blocks now start with a **STEP 0 archive
   integrity check** before any read. Claude runs `ls / wc -l / grep`
   against the archive, and on failure emits a canonical Codex
   re-instruction block (stored as the "Codex re-instruction block
   (STEP 0 failure fallback)" section of the same file) verbatim, then
   waits for the operator to reply "재실행 완료". The operator never has
   to open a terminal to check the archive, never has to hand-draft a
   re-instruction block, and never has to re-type YAML frontmatter.
3. **Layer 3 — Operator pre-flight (optional, belt).** The Usage notes
   still document the two-command manual check as an optional sanity
   step for operators who want to verify before opening a new session.
   With Layers 1 and 2 in place this is skippable.
4. **Permanent record.** This Sec. 8 is the lessons-learned entry.
5. **Recovery path used for this specific 2026-04-22 instance (Option A).**
   Re-instructed Codex to regenerate and archive the STEP 7 report only
   (Stage 8 artifacts already on disk from the prior run). Operator
   pasted the re-instruction block, Codex wrote
   `stage8_bundle1_codex_report.md` itself, then a new Claude session
   per M.3 (STEP 0 auto-verified the archive on entry).

**Generalizations.**

- *Archive-then-paste beats paste-only.* Anywhere the original process
  says *"paste Codex's output back to the next Claude session"*, the
  preferred implementation is *"Codex writes the paste to a named
  archive file on disk AND paste-returns it"*. Paste-return = belt,
  disk archive = suspenders.
- *Consumer-side auto-verification beats operator-side pre-flight.* If a
  resume prompt depends on a file produced in a prior session, the
  prompt itself should verify the file as its first step and carry its
  own canonical re-instruction block for the failure case. Asking the
  operator to "verify before pasting" loads the wrong side of the
  human-in-the-loop.
- *Operator toil is the failure signal.* Every time this review would
  tell the operator to "go look at X and figure out Y", treat that as
  a process bug, not a runbook improvement. Track human paste-shuttling
  as a **v0.4 automation candidate** in
  `docs/notes/codex_automation_exploration.md` and remove as many
  hand-retype steps as possible within v0.3 today.
