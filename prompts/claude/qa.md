# Stage 12 — QA & Release (Sonnet · Medium effort)

> Owner: 🧪 QA Engineer | Model: Sonnet | Output: `docs/05_qa_release/`
> Runs in: **Standard** (full) and **Strict** (full + release checklist signed off).
> In **Lite** mode, produce only a lightweight checklist (single section, no separate files).

---

## Your task

Write QA scenarios and a release checklist based on the validated implementation.

The success criteria being tested here must be **the same criteria that were written down in `plan_final.md` (Stage 4)**. If they are not, stop and reconcile — tests drifting away from the approved plan is a workflow failure.

## Pre-flight

- [ ] `docs/notes/final_validation.md` shows Stage 11 APPROVED (or, in Lite, Stage 9 light-review PASS)
- [ ] `plan_final.md` success criteria are in front of you
- [ ] Mode / `has_ui` / `risk_level` from Stage 1 are still accurate

## Lite mode output

If mode is Lite, append the following to `docs/04_implementation/implementation_progress.md` and skip the two files below:

```markdown
## QA & Release — YYYY-MM-DD (Stage 12, Lite)
Mode: Lite
- [ ] Change behaves as described in the inline brainstorm note
- [ ] No regression on the one adjacent feature most likely to break
- [ ] `HANDOFF.md` updated
- [ ] `docs/notes/dev_history.md` appended
```

Then proceed to Stage 13 (Codex archives / tags / deploys).

## Standard / Strict mode output

### Output 1: QA Scenarios

Save to `docs/05_qa_release/qa_scenarios.md`:

```markdown
# QA Scenarios — [Feature/Project Name]
Date: YYYY-MM-DD
Mode: Standard | Strict

## Traceability
Each scenario below maps to a success criterion from `docs/02_planning/plan_final.md`.

| Scenario ID | plan_final criterion | Type |
|-------------|---------------------|------|
| S-1 | [criterion 1] | happy path |
| S-2 | [criterion 2] | edge case |
| S-3 | [criterion 3] | error case |

## Happy Path
- [ ] S-1: [input] → [expected output]

## Edge Cases
- [ ] S-2: [edge case input] → [expected handling]

## Error Cases
- [ ] S-3: [failure input] → [expected error surface]

## Regression Tests
- [ ] existing feature 1 still works
- [ ] existing feature 2 still works
```

### Output 2: Release Checklist

Save to `docs/05_qa_release/release_checklist.md`:

```markdown
# Release Checklist — [Feature/Project Name]
Date: YYYY-MM-DD
Mode: Standard | Strict

## Pre-release
- [ ] All QA scenarios in qa_scenarios.md pass
- [ ] Final validation APPROVED (Stage 11) — see docs/notes/final_validation.md
- [ ] No secrets in code or logs (`grep` for known secret patterns)
- [ ] README / docstrings updated if behavior changed
- [ ] `HANDOFF.md` updated with mode, current stage, next action
- [ ] (Strict) Rollback plan documented in docs/notes/decisions.md

## Deployment
- [ ] Deploy to target environment
- [ ] Smoke test in production (happy path only)
- [ ] Monitor logs for the first 30 minutes
- [ ] (Strict) Feature flag / gradual rollout configured, or reason for full rollout logged

## Post-release
- [ ] Archive feature docs to `docs/archive/` (or tag them in dev_history.md)
- [ ] Append release entry to `docs/notes/dev_history.md`
- [ ] Next-session prompt in `HANDOFF.md` reflects "all systems nominal"
```

## Re-entry

- Any QA scenario fails → Stage 10 (fix) → Stage 9 → Stage 12 (retest that scenario)
- Release-checklist item cannot be satisfied → stop release, log blocker in `HANDOFF.md`, do NOT proceed to Stage 13

## After writing these documents

Tell the user: "QA & Release docs saved. Ready to hand off Stage 13 (Deploy & Archive) to Codex? Any open checklist items must be resolved first."
