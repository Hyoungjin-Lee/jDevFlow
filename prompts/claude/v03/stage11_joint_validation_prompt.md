# Stage 11 — Joint Validation (Validation Group 1) — Fresh-Session Kickoff Prompt

> **Owner:** 🔍 Reviewer (Claude, Opus · XHigh effort — mandatory for Strict-hybrid)
> **Scope:** validation_group = 1 = { Bundle 1 tool-picker, Bundle 4 doc-discipline }
> **Output:** `docs/notes/final_validation.md`
> **When:** single fresh Claude session with **no prior context**, after both bundles have passed Stage 9 (or completed Stage 10 revision loops).
> **DC.6** — promoted to a first-class deliverable per plan_final F-c1; written during **pre-Stage-11 housekeeping**.

---

## Why this prompt exists (v0.3 context)

- Validation Group 1 means **one joint fresh-session Stage 11 for both bundles** (plan_final Sec. 4 M.3), not two parallel sessions.
- Context budget risk (R3) is **medium-high** — two bundles' worth of code + design would blow a fresh context if pasted raw.
- Therefore: this prompt enforces a **pre-compacted input format** — summaries, diffs, and referenced paths, not full source.

---

## Copy-paste this at the start of the Stage 11 joint validation session

```
Start Stage 11 — Joint Final Validation for jDevFlow v0.3, validation_group = 1.

This is an INDEPENDENT fresh session with no prior chat context. Confirm
this explicitly in the output file (Independent session: yes).

Read first, in order:
1. CLAUDE.md
2. HANDOFF.md (verify both bundles show Stage 9 = PASS and Stage 10 loops closed)
3. WORKFLOW.md (Sec. 14 Stage 11 + Strict-mode rules)
4. docs/02_planning/plan_final.md (the approved plan — what was agreed)
5. Per-bundle summary dossiers (pre-compacted inputs, listed below)
6. prompts/claude/final_review.md (canonical Stage 11 prompt — structure reference)
7. This prompt: prompts/claude/v03/stage11_joint_validation_prompt.md

Project path: ~/projects/Jonelab_Platform/jDevFlow/
Mode: Strict-hybrid · Effort: XHigh
has_ui: false
Bundles in scope: 1 (tool-picker) + 4 (doc-discipline, option β)
Divergent-verdict policy: M.5 (plan_final Sec. 4) — group verdict = worst-of-two.

Your task: perform one joint final validation across both bundles and emit
a single docs/notes/final_validation.md with per-bundle AND group-level
verdicts. Do NOT produce two separate validation files.
```

---

## Per-bundle input dossier — pre-compact before Stage 11 entry

Before starting the Stage 11 session, the **QA-orchestrator Claude** (the session that just finished Stage 9/10) must produce the following two dossiers and place them at the paths below. The Stage 11 session reads these instead of raw source.

### Dossier format (applies to both bundles)

Each dossier is ≤ 1 page of prose + ≤ 200 lines of diff/code. Saved as:
- `docs/notes/stage11_dossiers/bundle1_dossier.md`
- `docs/notes/stage11_dossiers/bundle4_dossier.md`

Dossier structure:

```markdown
# Stage 11 Dossier — Bundle {id} ({name})

## 1. What was built (≤ 10 lines)
[Plain-English summary of what Codex implemented, referencing D{id}.x deliverables.]

## 2. Files touched
- path/to/file.ext (CREATED | MODIFIED | DELETED) — one-line purpose

## 3. Key diffs (≤ 200 lines total)
[Only the non-boilerplate lines that matter for review. Trim imports, formatting-only changes, generated code. Every include must be justified in one inline comment.]

## 4. Design references (paths only, not pasted)
- docs/03_design/bundle{id}_.../technical_design.md Sec. N — [what was specified]
- plan_final.md Sec. 3-{1 or 2} — [deliverable IDs covered]

## 5. Stage 9 findings and their resolution
| Finding | Original stage | Resolution | Commit/file ref |
|---------|----------------|------------|-----------------|
| ...     | Stage 9        | Addressed  | src/...         |

## 6. Deferred / non-blocking observations
- [observation — why deferred, where tracked]

## 7. Acceptance-criteria checklist (from technical_design.md Sec. 11)
- [x] ...
- [ ] ... (if any unchecked, explain)
```

Hard rule: **no pasted full source files**. The Stage 11 session reads the
repo directly for any file it wants to inspect — dossiers are the
navigation surface, not a substitute for the code.

---

## Joint validation checklist (group-level, above per-bundle work)

Check these BEFORE diving into per-bundle details:

- [ ] Both dossiers exist and conform to the format above.
- [ ] HANDOFF.md shows Stage 9 = PASS for both bundles (or explicit Stage 10 loop closure recorded).
- [ ] Each bundle's `technical_design.md` acceptance criteria (Sec. 11) show a ≥ 90% tick rate; any unchecked items have written justification.
- [ ] **Cross-bundle contract** — Bundle 1's recommendation logic (D1.b) parses Bundle 4's doc structure (D4.x2/x3/x4) as locked. Verify: does `.skills/tool-picker/SKILL.md` cite D4.x2/x3/x4 decisions, and do the actual repo docs match those decisions? If mismatch, this is a blocking issue.
- [ ] KO pair freshness: every stage-closing doc has a KO pair dated ≤ 1 day after the EN version (OQ.L2 Stage-9 half follow-up).
- [ ] `has_ui=false`, `risk_level=medium(-high)` values in HANDOFF.md still match reality.
- [ ] No secrets in any committed file (scan `src/` + `scripts/` + `.skills/`).
- [ ] `scripts/update_handoff.sh` passes `shellcheck` (re-run here).

## Per-bundle validation checklist

For each bundle:

- [ ] Every plan_final deliverable ID (D1.a–D1.c / D1.x OR D4.a–D4.c / D4.x1–x4) maps to a concrete file in the repo. No ghost deliverables.
- [ ] Every Stage 9 finding is addressed or explicitly deferred with reason.
- [ ] Tests cover the new logic; at least one edge case per component (from design Sec. 8).
- [ ] No regression in existing functionality (unit + integration, where applicable).
- [ ] Bundle-specific risk mitigation survives in code:
  - Bundle 1 R2 — skill surface is read-only Markdown, no shell/CLI.
  - Bundle 4 R5 — shell target is POSIX `sh`, shellcheck clean.
  - Bundle 4 R7 — CHANGELOG has v0.3 entry (dogfooding).
- [ ] Documentation updated (docstrings, README, HANDOFF.md) if behavior changed.

---

## Divergent-verdict handling (plan_final Sec. 4 M.5 — committed policy)

Emit three verdicts in the output file:
1. **Bundle 1 verdict** — APPROVED | CHANGES REQUESTED (minor) | CHANGES REQUESTED (design-level)
2. **Bundle 4 verdict** — same enum
3. **Group verdict** — **worst-of-two** by severity: `design-level` > `minor` > `approved`.

Re-approval trigger (Stage 4.5 loop) fires **iff at least one bundle
verdict is `design-level`**. If both are `minor`, the group flows to
Stage 10 for the affected bundle(s) only and Stage 11 re-runs as a joint
session once fixes land. Partial Stage 11 runs are not permitted — always
joint, always fresh.

## Output file format

Save to `docs/notes/final_validation.md` (single file, not per-bundle):

```markdown
# Final Validation — jDevFlow v0.3 (Validation Group 1)
Date: YYYY-MM-DD
Validator: Claude (Opus)
Mode: Strict-hybrid
Effort: XHigh
Independent session: yes  ← must be "yes"
Bundles: 1 (tool-picker), 4 (doc-discipline, option β)

## 1. Verdicts
- Bundle 1: APPROVED | CHANGES REQUESTED (minor) | CHANGES REQUESTED (design-level)
- Bundle 4: APPROVED | CHANGES REQUESTED (minor) | CHANGES REQUESTED (design-level)
- **Group (worst-of-two, per M.5):** ...

## 2. Re-entry direction (if any bundle ≠ APPROVED)
- Bundle X, minor → Stage 10 → Stage 9 → Stage 11 (joint re-run)
- Bundle X, design-level → Stage 4.5 re-approval (joint) → Stage 5 → Stage 8 → Stage 9 → Stage 11
- See M.5 — re-approval is joint; partial re-approval is not valid.

## 3. Per-bundle findings
### Bundle 1
- **Blocking** (none | list — reference file:line)
- **Non-blocking** (list)

### Bundle 4
- **Blocking** (none | list)
- **Non-blocking** (list)

## 4. Cross-bundle findings (joint only)
- Contract between D1.b and D4.x2/x3/x4 — verified | mismatch at {file:line}.
- Any other coupling issues.

## 5. KO pair freshness
| Doc | EN date | KO date | Delta | Status |
|-----|---------|---------|-------|--------|
| plan_final.md | ... | ... | ... | ✅ / ⚠️ |
| bundle4/technical_design.md | ... | ... | ... | ... |
| bundle1/technical_design.md | ... | ... | ... | ... |

## 6. Approval statement (if Group verdict = APPROVED)
"The implementation of jDevFlow v0.3 (Bundles 1 + 4) is approved for QA and release. Stage 12 may proceed. Stage 13 will release under a single joint `v0.3` git tag (M.6)."

## 7. Record both bundle verdicts AND the group verdict to HANDOFF.md
- Update HANDOFF.md `bundles[].verdict` for each bundle (minor | bug_fix | design_level | null).
- Add a group-level note in Recent Changes with the M.5 outcome.
```

---

## After writing

- **If Group verdict = APPROVED:** proceed to Stage 12 (QA & Release). Stage 13 will ship a single joint `v0.3` git tag per plan_final M.6.
- **If any bundle = minor:** record in `docs/notes/dev_history.md`, route to Stage 10 for that bundle, then back to Stage 11 (joint re-run).
- **If any bundle = design-level:** record in dev_history.md, **Stage 4.5 re-approval is required for both bundles** (M.1 + M.5 joint rule), then Stage 5 → Stage 8 → Stage 9 → Stage 11.
- **Third loop-back on same change:** escalate to user — likely a design problem, not code problem.

---

## Pre-flight for the QA-orchestrator (producing dossiers)

Before handing off to the Stage 11 fresh session:
- [ ] Dossier for Bundle 1 written to `docs/notes/stage11_dossiers/bundle1_dossier.md`.
- [ ] Dossier for Bundle 4 written to `docs/notes/stage11_dossiers/bundle4_dossier.md`.
- [ ] Dossier pages each ≤ 1 page prose + ≤ 200 lines diff.
- [ ] KO pair freshness table pre-populated in a scratch note (the Stage 11 validator verifies).
- [ ] HANDOFF.md Stage 9 entries match what the dossiers say.

---

## Revision log for this prompt

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 draft (DC.6 — pre-Stage-11 housekeeping) | Promoted from F-c1; resolves plan_final Sec. 7-4 OQ.S11.1 (context delivery format) by committing to the dossier format above. Enforces M.3 (joint fresh session) + M.5 (worst-of-two) + M.6 (single joint git tag). |
