# Stage 12 — QA & Release (Sonnet · Medium effort)

> Owner: 🧪 QA Engineer | Model: Sonnet | Output: `docs/05_qa_release/`

---

## Your task

Write QA scenarios and a release checklist based on the validated implementation.

## Output 1: QA Scenarios

Save to `docs/05_qa_release/qa_scenarios.md`:

```markdown
# QA Scenarios — [Feature/Project Name]
Date: YYYY-MM-DD

## Happy Path
- [ ] scenario 1: [input] → [expected output]

## Edge Cases
- [ ] edge case 1

## Error Cases
- [ ] error case 1

## Regression Tests
- [ ] existing feature 1 still works
```

## Output 2: Release Checklist

Save to `docs/05_qa_release/release_checklist.md`:

```markdown
# Release Checklist — [Feature/Project Name]
Date: YYYY-MM-DD

## Pre-release
- [ ] All QA scenarios pass
- [ ] Final validation approved (Stage 11)
- [ ] No secrets in code
- [ ] README updated
- [ ] HANDOFF.md updated

## Deployment
- [ ] Deploy to target environment
- [ ] Smoke test in production
- [ ] Monitor logs for 30 minutes

## Post-release
- [ ] Archive feature docs to docs/archive/
- [ ] Update dev_history.md
```
