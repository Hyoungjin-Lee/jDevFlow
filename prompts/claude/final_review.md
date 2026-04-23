# Stage 11 — Final Validation (Opus · XHigh or High effort)

> Owner: 🔍 Reviewer | Model: Opus | Output: `docs/notes/final_validation.md`
> Runs in: **Standard** (High effort) and **Strict** (XHigh effort).
> Skipped in Lite when the change has no shared-state impact; downgraded to Sonnet/High for low-risk Standard changes.
> ⚠️ In **Strict mode this must run in an independent Claude session** with no prior context. See WORKFLOW.md.

---

## Your task

Perform a thorough, independent final validation of the revised code.
Assume you are seeing this code for the first time — no bias from earlier stages.

## Effort selection

- **XHigh** — Strict mode; security, architecture, auth, schema, payment, or any irreversible change
- **High** — Standard mode; most feature validation
- Downgrade to **Sonnet / Medium** only in Standard mode when the change is small (≤10 lines, single module, no shared state). Log the downgrade reason in the output.

## Pre-flight

- [ ] `docs/04_implementation/implementation_progress.md` shows Stage 9 PASS (or explicit NEEDS REVISION → Stage 10 loop closed)
- [ ] All tests pass on the latest commit
- [ ] You have access to the approved `technical_design.md` for this feature
- [ ] (Strict) You are running in an independent Claude session — confirm this out loud in the output

## Validation checklist

- [ ] Every Stage 9 finding is addressed or explicitly deferred with a reason
- [ ] No regression in existing functionality (unit + integration)
- [ ] Security: no credential exposure, proper auth, inputs validated
- [ ] Performance: no obvious bottlenecks introduced
- [ ] Code integrates cleanly with existing modules
- [ ] Documentation updated (docstrings, README, HANDOFF.md) if behavior changed
- [ ] Tests cover the new logic, including at least one edge case per component
- [ ] Mode / `has_ui` / `risk_level` recorded at Stage 1 still match reality

## Output

Save to `docs/notes/final_validation.md`:

```markdown
# Final Validation — [Feature/Project Name]
Date: YYYY-MM-DD
Validator: Claude (Opus)
Mode: Standard | Strict
Effort: XHigh | High | (downgraded) Sonnet/Medium — reason: …
Independent session: yes | no   ← must be "yes" in Strict mode

## Result
APPROVED | CHANGES REQUESTED (minor) | CHANGES REQUESTED (design-level)

## Findings
### Blocking issues
- (none, or list issues — reference file:line)

### Non-blocking observations
- observation 1

## Re-entry direction (if not APPROVED)
- Minor → Stage 10 → Stage 9 → Stage 11
- Design-level → Stage 5 (or 6/7) → Stage 8 → Stage 9 → Stage 11

## Approval statement
"The implementation of [feature] is approved for QA and release."
```

## After writing this document

- If APPROVED → proceed to Stage 12 (QA & Release).
- If CHANGES REQUESTED → log the loop in `docs/notes/dev_history.md` and return to the stage named in "Re-entry direction".
- If this is the third loop back from Stage 11 on the same change → escalate mode to Strict and pause for user input; repeated loops usually signal a design problem, not a code problem.
