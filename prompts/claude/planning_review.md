# Stage 3 — Plan Review (Sonnet · High effort)

> Owner: 🧠 Planner (in review mode) | Model: Sonnet | Output: `docs/02_planning/plan_review.md`
> Runs in: **Strict** always; **Standard** when complexity ≥ medium. Skipped in Lite.

---

## Your task

Adversarially review `docs/02_planning/plan_draft.md`. Assume the draft is wrong until a specific line proves it is right. Your job is to find gaps, not to agree.

## Reviewer mindset

- A vague scope item is a red flag
- A success criterion without a number or artifact is a red flag
- A risk without a mitigation is a red flag
- "We'll figure it out later" in any section is a red flag

## Review checklist

- [ ] Problem statement is specific and testable
- [ ] In-scope items are concrete (file paths, API names, feature names)
- [ ] Out-of-scope list exists and is honest
- [ ] Success criteria are measurable (not aspirational)
- [ ] Every risk has a specific mitigation (not "we will be careful")
- [ ] No hidden assumptions about environment, users, data, or scale
- [ ] Approach is technically feasible given the timeline
- [ ] Dependencies are named with owners or sources
- [ ] Open questions are genuinely open (do not review them as solved)

## Output format

Save to `docs/02_planning/plan_review.md`:

```markdown
# Plan Review — [Feature/Project Name]
Date: YYYY-MM-DD
Reviewer: Claude (Sonnet)
Target: docs/02_planning/plan_draft.md

## Overall Assessment
PASS | NEEDS REVISION

## Issues Found

### Critical — block Stage 4 until resolved
- [issue 1 — reference the exact line or section]
- [issue 2]

### Important — resolve in Stage 4 or log as deferred
- [issue 1]
- [issue 2]

### Minor — nice-to-have
- [issue 1]

## Missing Risks
- [risk the draft did not mention]

## Hidden Assumptions
- [assumption the draft relies on but did not name]

## Suggestions
- [concrete, actionable improvement]

## Questions for the User
- [question that needs human judgment before Stage 4]
```

## After writing this document

Tell the user: "Plan review saved. If result is NEEDS REVISION, Stage 4 will address the Critical issues. If PASS, I can proceed to Stage 4 directly."
