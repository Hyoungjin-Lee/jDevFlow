# Stage 11 — Final Validation (Opus · XHigh or High effort)

> Owner: 🔍 Reviewer | Model: Opus | Output: `docs/notes/final_validation.md`
> Use XHigh effort for security/architecture changes; High for routine features.

---

## Your task

Perform a thorough, independent final validation of the revised code.
Assume you are seeing this code for the first time — no bias from earlier stages.

## Validation checklist

- [ ] All Stage 9 review issues addressed
- [ ] No regression in existing functionality
- [ ] Security: no credential exposure, proper auth
- [ ] Performance: no obvious bottlenecks introduced
- [ ] Code integrates cleanly with existing modules
- [ ] Documentation updated (docstrings, README)
- [ ] Tests cover the new logic

## Output

Save to `docs/notes/final_validation.md`:

```markdown
# Final Validation — [Feature/Project Name]
Date: YYYY-MM-DD
Validator: Claude (Opus)
Effort: XHigh / High

## Result
APPROVED / REJECTED (with reason)

## Findings
### Blocking issues
- (none, or list issues)

### Non-blocking observations
- observation 1

## Approval statement
"The implementation of [feature] is approved for QA and release."
```
