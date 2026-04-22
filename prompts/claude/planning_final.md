# Stage 4 — Plan Final (Sonnet · Medium effort)

> Owner: 🧠 Planner | Model: Sonnet | Output: `docs/02_planning/plan_final.md`
> Runs in: **Standard** and **Strict**. Lite writes a minimal inline note instead.
> ⚠️ After this stage, user approval is required (Stage 4.5) before Stage 5.

---

## Your task

Integrate `docs/02_planning/plan_draft.md` and `docs/02_planning/plan_review.md` into the **final confirmed plan**. This document is the input to Stage 5 (Technical Design) and to Codex in Stage 8 — vagueness here will be amplified later.

## Non-negotiables

- Every Critical issue from Stage 3 must be either resolved or explicitly deferred with a reason
- Scope must not expand silently — if scope grew during review, note that explicitly
- Success criteria must be the ones that will actually be tested in Stage 12
- Risks must be updated to match what Stage 3 surfaced

## Checklist before asking for approval

- [ ] Every Critical issue from Stage 3 is addressed or logged as deferred
- [ ] Scope has no "etc." or "TBD" items
- [ ] Success criteria are the criteria Stage 12 will verify
- [ ] Top 3 risks each have an owner and a mitigation
- [ ] Timeline is realistic given the mode (Standard vs Strict)
- [ ] Open questions from Stage 3 are resolved (or explicitly deferred)
- [ ] The plan can be handed to someone who has not read the chat

## Output format

Save to `docs/02_planning/plan_final.md`:

```markdown
# Final Plan — [Feature/Project Name]
Date: YYYY-MM-DD
Status: PENDING APPROVAL
Mode: Lite | Standard | Strict
has_ui: true | false
risk_level: low | medium | high

## Problem Statement
[Final single-paragraph statement — no ambiguity]

## Confirmed Scope
### In scope
- [deliverable 1]
- [deliverable 2]

### Out of scope
- [explicit exclusion 1]
- [explicit exclusion 2]

## Success Criteria
- [ ] [criterion 1 — measurable, will be tested in Stage 12]
- [ ] [criterion 2 — measurable]
- [ ] [criterion 3 — measurable]

## Chosen Approach
[Final approach — 1–3 paragraphs, no alternatives]

## Risks & Mitigations
| Risk | Owner | Mitigation | Trigger to escalate |
|------|-------|-----------|---------------------|
| [risk 1] | | | |
| [risk 2] | | | |

## Timeline
| Stage | Owner | Est. Time |
|-------|-------|-----------|
| 5 Technical Design | Claude (Opus) | |
| 8 Implementation | Codex | |
| 9 Code Review | Claude (Sonnet) | |
| 11 Final Validation | Claude (Opus) | |
| 12 QA & Release | Claude (Sonnet) | |
| 13 Deploy & Archive | Codex | |

## Dependencies
- [dependency 1 — with owner or source]

## Deferred / Out of this iteration
- [item that was in Stage 3 but is deferred, with reason]

## Approval
- [ ] User approved on: YYYY-MM-DD
- Approver:
- Notes:
```

## After writing this document

Tell the user exactly this:

> "Please review `docs/02_planning/plan_final.md`. I will not enter Stage 5 without your explicit approval. Reply 'approved' to continue, or list changes you want."

Do NOT proceed to Stage 5 until the user types an approval. Record the approval date and name in the Approval section before moving on.
