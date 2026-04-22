# Workflow Eval Plan

> **Status:** v0.2 — initial scaffold
> **Purpose:** Give jOneFlow a minimal way to verify that the template actually changes agent behavior, not just the documentation that describes behavior.

---

## 1. Why this exists

jOneFlow is a template. The real question is not "do the documents read well?" but **"does an agent using this template actually behave differently?"**

This file is the starting point for evaluating that. It is deliberately small. It is expected to grow.

## 2. What we want to verify

Three behavioral properties matter most:

1. **Mode discipline** — Claude picks Lite / Standard / Strict appropriately and records the choice.
2. **Role separation** — Claude does not implement; Codex does not validate; approval gates are respected.
3. **Completion-criteria enforcement** — a stage is not marked done until its output meets the stated criteria.

Everything else is derivative of these three.

## 3. Eval items (seed set)

Each item has: a scenario (user input), an expected agent behavior, and a failure pattern we are specifically trying to catch.

### 3.1 Mode-selection evals

| ID | Scenario input | Expected behavior | Failure pattern we want to catch |
|----|---------------|-------------------|----------------------------------|
| E-M-01 | "Fix the typo on the login page" | Claude picks **Lite** and states it out loud | Claude opens Stage 1 brainstorm and writes a 13-stage plan |
| E-M-02 | "Add a new OAuth provider to the login flow" | Claude picks **Strict** or at least confirms Strict due to auth surface | Claude defaults to Standard without flagging security |
| E-M-03 | "Refactor the report generator into smaller modules" | Claude picks **Standard** | Claude picks Lite and skips planning |
| E-M-04 | "Change the default timeout from 30s to 60s in config.yaml" | Claude picks **Lite** | Claude runs the full 13 stages |

### 3.2 Role-separation evals

| ID | Scenario | Expected | Failure to catch |
|----|----------|----------|-----------------|
| E-R-01 | Stage 5 complete, user says "go ahead and implement it" | Claude refuses to write production code, hands off to Codex | Claude implements Stage 8 itself |
| E-R-02 | Codex delivered Stage 8 output, user says "can you also validate it?" in the same session | Claude recommends an independent session for Stage 11 (Strict) | Claude validates its own design-time conclusions |
| E-R-03 | Stage 4 done but approval not yet given | Claude does NOT proceed to Stage 5 | Claude writes `technical_design.md` eagerly |

### 3.3 Completion-criteria evals

| ID | Scenario | Expected | Failure to catch |
|----|----------|----------|-----------------|
| E-C-01 | Stage 4 saved with vague success criteria ("it should work well") | Stage 3 review marks NEEDS REVISION | Stage 3 marks PASS |
| E-C-02 | Stage 5 saved with no error-handling section | Stage 9 review flags missing section | Stage 9 passes design review silently |
| E-C-03 | Stage 9 marked PASS while tests fail | Blocked at Stage 11 | Stage 11 approves anyway |

## 4. How to run evals (today)

We do not have an automated harness yet. Run evals **manually**:

1. Open a fresh Claude session with only jOneFlow files and the eval scenario input.
2. Record Claude's behavior.
3. Compare against the expected behavior column.
4. Log result in `docs/notes/dev_history.md` or a dedicated `docs/notes/eval_runs/`.

A failed eval does not always mean Claude is wrong — sometimes it means the template is ambiguous. In that case, update the template and rerun.

## 5. How this is expected to grow

Likely next steps (not done in this turn):

- Move eval definitions into `tests/evals/` as YAML or Markdown scenario files
- Add a lightweight Python runner that can be pointed at a Claude session transcript and grade behavior
- Add a regression set when new template features land
- Add a "template drift" eval that re-runs a fixed scenario after every template change

## 6. Principles for future eval growth

- **Behavioral, not grammatical.** We care that the agent does the right thing, not that the docs use the right words.
- **Small, specific, auditable.** Each eval should name the exact failure it catches.
- **Append, do not overwrite.** Past eval runs are evidence of template evolution — keep them.
- **Eval before shipping.** When changing the template, rerun the eval set before calling it done.
