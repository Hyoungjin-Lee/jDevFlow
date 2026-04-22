# Stage 2 — Plan Draft (Sonnet · Medium effort)

> Owner: 🧠 Planner | Model: Sonnet | Output: `docs/02_planning/plan_draft.md`
> Runs in: **Standard** and **Strict** modes. Skipped in Lite.

---

## Your task

Convert `docs/01_brainstorm/brainstorm.md` into a **scoped, testable plan draft**. The goal is not to write the final plan — it is to produce something concrete enough that Stage 3 (Plan Review) can attack it.

## Non-negotiables

- Record the mode (Lite / Standard / Strict) chosen at brainstorm
- Record `has_ui`, `risk_level` if they were decided
- Every in-scope item must be a specific deliverable, not a theme
- Every out-of-scope item must also be listed — silence about it is not enough
- Success criteria must be measurable (numbers, artifacts, behaviors)
- At least 3 risks, each with an explicit mitigation

## Checklist before saving

- [ ] Problem statement refined from brainstorm, not copy-pasted
- [ ] In-scope list is concrete (names of files, features, APIs)
- [ ] Out-of-scope list exists
- [ ] Success criteria are observable
- [ ] At least 3 risks, each with a mitigation
- [ ] Timeline estimate is at least coarse-grained (hours / days)
- [ ] Open questions block is honest (do not fake certainty)

## Output format

Save to `docs/02_planning/plan_draft.md`:

```markdown
# Plan Draft — [Feature/Project Name]
Date: YYYY-MM-DD
Mode: Lite | Standard | Strict
has_ui: true | false
risk_level: low | medium | high

## Problem Statement
[Refined from brainstorm — one or two sentences, concrete]

## Scope
### In scope
- [specific deliverable 1 — file path or feature name]
- [specific deliverable 2]

### Out of scope
- [explicitly excluded item 1]
- [explicitly excluded item 2]

## Success Criteria
- [ ] [criterion 1 — measurable]
- [ ] [criterion 2 — measurable]
- [ ] [criterion 3 — measurable]

## Chosen Approach
[1–3 paragraphs describing how we will solve it, not just what we will solve]

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| [risk 1] | L/M/H | L/M/H | [concrete action] |
| [risk 2] | L/M/H | L/M/H | [concrete action] |
| [risk 3] | L/M/H | L/M/H | [concrete action] |

## Timeline Estimate
| Stage | Est. Time |
|-------|-----------|
| Design (5–7) | |
| Implementation (8) | |
| Review + Validation (9–11) | |
| QA + Deploy (12–13) | |

## Dependencies
- [External service, library, or team this plan depends on]

## Open Questions
- [Question that must be resolved before Stage 3 review]
```

## After writing this document

Tell the user: "Plan draft saved. I will run Stage 3 (Plan Review) next unless you want to inspect it first."
