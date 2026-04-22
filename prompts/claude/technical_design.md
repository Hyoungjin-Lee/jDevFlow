# Stage 5 — Technical Design (Opus · High effort)

> Owner: 🏗️ Designer | Model: Opus | Output: `docs/03_design/technical_design.md`
> Input: approved `docs/02_planning/plan_final.md`
> Runs in: **Standard** and **Strict**. Skipped or inlined in Lite.

---

## Your task

Produce a **complete, unambiguous technical design** that Codex can implement from directly. If Codex has to guess at Stage 8, the design is incomplete.

## Non-negotiables

- Every component is named. Every interface is specified.
- Error paths are described, not just happy paths.
- Test strategy covers at least one edge case per component.
- Security considerations are addressed (even a one-line "N/A, reason: …").
- The design is self-contained — a fresh Claude session with no chat history should be able to implement from it.

## Design pre-flight checks

Before writing, verify:

- [ ] `docs/02_planning/plan_final.md` exists and is marked APPROVED
- [ ] You know the mode (Standard / Strict)
- [ ] You know whether `has_ui` is true (if yes, Stages 6 and 7 will follow)
- [ ] You have read the existing code patterns in `src/` that this change will touch

## Checklist before saving

- [ ] Architecture overview has at least one block diagram or ASCII sketch
- [ ] Every component has Responsibility, Interface, Dependencies
- [ ] Data flow is described end-to-end, including error branches
- [ ] Data models or schemas are specified (or "none, reason:")
- [ ] API / function signatures are exact
- [ ] Error handling strategy is named (exception types, retry policy, logging)
- [ ] Security considerations addressed (input validation, secrets, auth)
- [ ] Test strategy names at least one edge case per component
- [ ] Implementation notes for Codex are concrete (files to create, files to modify, constraints)
- [ ] Out-of-scope section lists what Codex should NOT implement this pass

## Output format

Save to `docs/03_design/technical_design.md`:

```markdown
# Technical Design — [Feature/Project Name]
Date: YYYY-MM-DD
Input: docs/02_planning/plan_final.md (approved)
Mode: Standard | Strict

## Architecture Overview
[Block diagram or ASCII sketch — components and their relationships]

## Components

### Component 1 — [name]
- **Responsibility:** [what this component owns]
- **Interface:** [public functions, classes, or endpoints with exact signatures]
- **Dependencies:** [other components, libraries, external services]
- **File(s):** `src/path/to/file.py`

### Component 2 — [name]
- **Responsibility:**
- **Interface:**
- **Dependencies:**
- **File(s):**

## Data Flow
1. [Step 1 — input source, validation]
2. [Step 2 — transformation]
3. [Step 3 — output destination]
4. [Error branches: what happens if step N fails]

## Data Models
- [Schema, type, or structure — use code blocks for exact shape]

## API Contracts
- [Endpoint / function signature / message format — exact, not approximate]

## Error Handling
- **Expected errors:** [error class → how it is caught and surfaced]
- **Unexpected errors:** [fallback logging / alerting strategy]
- **Retry policy:** [if any]

## Security Considerations
- **Secrets:** loaded via `security/secret_loader.py` (list the keys this feature needs)
- **Input validation:** [what gets validated, where]
- **Auth / authorization:** [if applicable, or "N/A, reason: internal batch job"]
- **Logging:** [what must NEVER be logged — PII, tokens]

## Testing Strategy
| Component | Test type | Edge case to cover |
|-----------|-----------|--------------------|
| Component 1 | unit | [edge case] |
| Component 1 | integration | [edge case] |
| Component 2 | unit | [edge case] |

## Implementation Notes for Codex
- **Files to create:** `src/...`, `tests/...`
- **Files to modify:** `src/...` (keep existing public API unless noted)
- **Constraints:**
  - [e.g., "do not change the signature of `load_config()`"]
  - [e.g., "preserve backward compatibility with config v1"]
- **Commit style:** [expected commit message pattern]

## Out of Scope (this implementation)
- [what Codex must NOT implement this pass, with reason]

## Acceptance Criteria (for Stage 9 review)
- [ ] [criterion — what makes the implementation "correct"]
- [ ] [criterion]
- [ ] [criterion]
```

## After writing this document

Tell the user: "Technical design saved at `docs/03_design/technical_design.md`. If `has_ui == true`, I will proceed to Stage 6 (UI Requirements). Otherwise Codex can begin Stage 8 from this document."
