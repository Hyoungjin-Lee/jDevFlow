# Stage 9 — Code Review (Sonnet · High effort)

> Owner: 🔍 Reviewer | Model: Sonnet | Output: `docs/04_implementation/implementation_progress.md`
> Input: Codex implementation diff/output
> Runs in: **always** (depth scales with mode). Never fully skipped.

---

## Mode-aware depth

- **Lite** — light, in-session review. Focus on secrets, obvious logic errors, and whether the change matches the original intent. No formal `NEEDS REVISION` loop required; fix in place if needed.
- **Standard** — full review against the checklist below. Result must be explicit PASS or NEEDS REVISION.
- **Strict** — full review **plus** independent verification of security-sensitive paths. If the change touches auth, secrets, or data schema, escalate to Stage 11 with XHigh effort regardless of this stage's result.

The reviewer agent is NOT the designer agent. If you designed the change at Stage 5, do not sign off on it alone — flag that Stage 11 must use an independent session.

## Your task

Review the code produced by Codex against `docs/03_design/technical_design.md` (or the Lite inline note if Technical Design was skipped).

## Review checklist

- [ ] All tests pass
- [ ] No hardcoded secrets or credentials
- [ ] Input validation present where needed
- [ ] Error handling is complete (matches the error-handling section of Technical Design)
- [ ] Matches the architecture in `technical_design.md`
- [ ] Follows project coding style
- [ ] Non-obvious logic is commented
- [ ] No unnecessary duplication
- [ ] Security considerations (from Technical Design "Security" section) are verifiably addressed
- [ ] Every acceptance criterion listed in Technical Design is met

## Output

Append a review section to `docs/04_implementation/implementation_progress.md`:

```markdown
## Code Review — YYYY-MM-DD (Stage 9)
Reviewer: Claude (Sonnet)
Mode: Lite | Standard | Strict
Result: PASS | NEEDS REVISION

### Issues
#### Critical (must fix before Stage 10)
- issue 1

#### Minor (fix or note)
- issue 1

### Approved changes
- change 1

### Escalation flag (Strict only)
- [ ] Touches security/auth/schema → Stage 11 MUST use an independent Claude session
```

## Re-entry rules

- Result = `NEEDS REVISION` → Stage 10 (Codex revises) → re-enter Stage 9
- Three loops on the same change → pause and escalate mode to Strict; design may be wrong, not the code
- Log every loop in `docs/notes/dev_history.md` with trigger and returned-to-stage

## After writing this section

Tell the user: "Stage 9 review complete. Result: [PASS | NEEDS REVISION]. Next: [Stage 10 revise | Stage 11 final validation | (Lite) ready to archive]."
