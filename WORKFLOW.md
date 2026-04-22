# 🔄 jOneFlow — AI-Driven Development Workflow Architecture

> **Version:** 2.0
> **Scope:** Universal — applicable to any project using Claude as orchestrator and Codex as implementer
> **Korean version:** see bottom of this file (한국어 버전: 파일 하단 참조)

---

## 0. What this document is

This file is the **workflow architecture reference** for jOneFlow. It describes:

1. A **tiered workflow model** — Lite, Standard, and Strict — so you can match workflow weight to task risk
2. A **Canonical Strict Flow** (13 stages) that defines the upper bound of governance
3. **Stage types** — a reusable vocabulary that an orchestration engine can recombine
4. **Execution conditions**, **completion criteria**, and **re-entry rules** so stages are not just a linear list

jOneFlow's philosophy stays the same: documents-first, role separation, session persistence via `HANDOFF.md`, and security-first defaults. What changes in v2 is that those principles are now expressed as a model you can scale up or down instead of a fixed 13-step pipeline.

---

## 1. Summary

jOneFlow establishes a **document-centric, role-separated development process**:

- **Claude** handles thinking, planning, design, review, and QA
- **Codex** handles implementation, revision, and deployment
- **Documents** (`docs/` folder) are the single source of truth
- **HANDOFF.md** carries state across sessions
- **Workflow mode** (Lite / Standard / Strict) is chosen per task, not per project

The 13-stage flow you see below is the **Strict Flow**. It is not the only path — it is the canonical reference from which lighter modes are derived.

---

## 2. Workflow Modes — Lite / Standard / Strict

You do not have to run every task through the full 13 stages. Pick the mode that matches task risk and complexity.

### 2.1 Mode comparison

| Dimension | **Lite** | **Standard** | **Strict** |
|-----------|----------|--------------|------------|
| Intended use | Hotfixes, config tweaks, copy changes, small maintenance | New features, refactors, most day-to-day work | Architecture-level, security-sensitive, multi-system, regulated changes |
| Complexity | Low | Medium | High |
| Risk | Low | Medium–High | High–Critical |
| Plan documents | Minimal (1 note) | Required | Required + reviewed |
| User approval gate | Optional | Required at Stage 4 | Required at Stage 4 (stricter criteria) |
| Technical design | Optional / inline | Required | Required, Opus-level |
| Code review | Light, in-session | Required (Stage 9) | Required + independent validation |
| Final validation | Skipped or Sonnet | Sonnet (High) | Opus (XHigh) |
| QA & release doc | Lightweight checklist | Full | Full + release checklist |
| Typical time | minutes–2 hr | 4 hr–2 days | 2 days–weeks |

### 2.2 When to pick each mode

Use **Lite** when:

- The change is local and reversible (config value, copy text, log format)
- There is no user-facing behavior change at the feature level
- The fix is urgent and well-scoped (production hotfix)
- You can describe the change in one sentence

Use **Standard** when:

- You are adding a feature, refactoring a module, or integrating a new service
- The change affects more than one file or one subsystem
- You need Codex to implement it from a spec
- This is the default for most day-to-day development

Use **Strict** when:

- The change touches architecture, security, auth, data schema, or payment flows
- Multiple systems or external integrations are involved
- The change is hard to roll back
- Regulatory, compliance, or audit trails apply

**Tie-breaker rule:** if you are not sure between two modes, pick the heavier one. It is cheaper to lighten a plan than to recover from a skipped review.

### 2.3 Stage coverage per mode

| Stage | Stage type | Lite | Standard | Strict |
|-------|-----------|------|----------|--------|
| 1 Brainstorm | ideation | skip | run (light) | run |
| 2 Plan Draft | planning | skip | run | run |
| 3 Plan Review | planning | skip | optional | run |
| 4 Plan Final | planning | minimal note | run | run |
| 4.5 User Approval | approval_gate | optional | run | run (stricter) |
| 5 Technical Design | design | skip / inline | run | run |
| 6 UI Requirements | design | skip | if `has_ui` | if `has_ui` |
| 7 UI Flow | design | skip | if `has_ui` | if `has_ui` |
| 8 Implementation | implementation | run | run | run |
| 9 Code Review | review | light | run | run |
| 10 Revision | implementation | if review failed | if review failed | if review failed |
| 11 Final Validation | validation | skip or Sonnet | run (High) | run (XHigh) |
| 12 QA & Release | qa_release | checklist only | run | run |
| 13 Deploy & Archive | archive | run (simple) | run | run |

"if `has_ui`" means: run the stage only when the feature includes a user-facing UI.

---

## 3. Canonical Strict Flow — the 13 stages

This is the reference flow. Lite and Standard are subsets of it. Do not treat this as "mandatory for every task" — treat it as "the upper bound of discipline for this template."

| # | Stage | Type | Owner | Model | Effort | Input | Output | Typical time |
|---|-------|------|-------|-------|--------|-------|--------|--------------|
| 1 | **Brainstorm** ⚠️ | ideation | Claude + User | Opus | Medium | User request | `docs/01_brainstorm/brainstorm.md` | 15–30 min |
| 2 | **Plan Draft** | planning | Claude | Sonnet | Medium | Brainstorm result | `docs/02_planning/plan_draft.md` | 15–30 min |
| 3 | **Plan Review** | planning | Claude | Sonnet | High | Plan draft | `docs/02_planning/plan_review.md` | 10–20 min |
| 4 | **Plan Final** ⚠️ | planning | Claude | Sonnet | Medium | Draft + review | `docs/02_planning/plan_final.md` | 10–15 min |
| 4.5 | **User Approval** 🔴 | approval_gate | User | — | — | plan_final.md | Approval confirmed | — |
| 5 | **Technical Design** | design | Claude | Opus | High | Approved plan | `docs/03_design/technical_design.md` | 30–60 min |
| 6 | **UI/UX Requirements** *(if `has_ui`)* | design | Claude | Sonnet | Medium | Technical design | `docs/03_design/ui_requirements.md` | 15–30 min |
| 7 | **UI Flow** *(if `has_ui`)* | design | Claude | Sonnet | Medium | UI requirements | `docs/03_design/ui_flow.md` | 20–40 min |
| 8 | **Implementation** | implementation | Codex | — | High | Design + UI flow | Code + tests + commit | 1–8 hrs |
| 9 | **Code Review** | review | Claude | Sonnet | High | Codex output | `docs/04_implementation/implementation_progress.md` | 15–30 min |
| 10 | **Revision** | implementation | Codex | — | Medium | Review feedback | Revised code + tests | 30 min–2 hrs |
| 11 | **Final Validation** | validation | Claude | Opus | XHigh or High* | Revised code + test results | `docs/notes/final_validation.md` | 30 min–1 hr |
| 12 | **QA & Release** | qa_release | Claude | Sonnet | Medium | Validated code | `docs/05_qa_release/qa_scenarios.md` + `release_checklist.md` | 15–30 min |
| 13 | **Deploy & Archive** | archive | Codex | — | Medium | QA-approved code | Merged code + updated `HANDOFF.md` | varies |

**Effort tiers:**

- **XHigh** — security, architecture, irreversible production changes
- **High** — most feature validation, code review, design decisions
- **Medium** — planning, documentation, routine review
- `*` Stage 11 default is **High**; escalate to **XHigh** only when Strict mode criteria apply

⚠️ stages must not be skipped silently. Skipping is a mode decision recorded in `HANDOFF.md` or `dev_history.md`.

---

## 4. Stage types — the reusable vocabulary

Every stage belongs to a stage type. Stage types exist so the workflow can be recombined by a future orchestration engine and so lighter modes can be described consistently.

| Stage type | Purpose | Typical owner | Canonical stages |
|-----------|---------|---------------|------------------|
| `ideation` | Surface problem, constraints, options | Claude + User | 1 |
| `planning` | Convert ideas into a scoped plan | Claude | 2, 3, 4 |
| `approval_gate` | Explicit human confirmation | User | 4.5 |
| `design` | Decide how to build it | Claude | 5, 6, 7 |
| `implementation` | Produce code, tests, commits | Codex | 8, 10 |
| `review` | Independent inspection of output | Claude | 9 |
| `validation` | High-confidence go/no-go | Claude | 11 |
| `qa_release` | Pre-release verification | Claude | 12 |
| `archive` | Deploy, tag, roll handoff | Codex | 13 |

**Naming note:** the exact names are less important than the fact that each stage can be classified. An orchestration engine can use these types to skip, repeat, or reorder stages by policy.

---

## 5. Execution conditions — when a stage runs

A stage is not "always on." Each stage has a condition. Conditions can be evaluated by a human at session start, or by a future engine from project metadata.

| Stage | Runs when | Skipped when |
|-------|-----------|--------------|
| 1 Brainstorm | `mode ∈ {Standard, Strict}` AND request is non-trivial | `mode == Lite` or intent is fully clear |
| 2 Plan Draft | `mode ∈ {Standard, Strict}` | `mode == Lite` |
| 3 Plan Review | `mode == Strict` OR `complexity >= medium` | Plan is small and single-module |
| 4 Plan Final | `mode ∈ {Standard, Strict}` | `mode == Lite` (inline note only) |
| 4.5 Approval | `approval_mode == manual` (default Standard, Strict) | Trusted internal hotfix under Lite |
| 5 Technical Design | `mode ∈ {Standard, Strict}` OR crosses multiple modules | Single-file Lite change |
| 6 UI Requirements | `has_ui == true` | Backend-only or CLI-only |
| 7 UI Flow | `has_ui == true` AND (`mode == Strict` OR complex states) | Flat or single-view UI |
| 8 Implementation | Always | — |
| 9 Code Review | Always (depth scales with mode) | Never fully skipped |
| 10 Revision | Stage 9 result = NEEDS REVISION | Stage 9 result = PASS |
| 11 Final Validation | `risk_level >= medium` OR `mode == Strict` | Lite changes with no shared-state impact |
| 12 QA & Release | `mode ∈ {Standard, Strict}` | Lite docs-only changes |
| 13 Deploy & Archive | Always | — |

Where `has_ui`, `complexity`, `risk_level`, `approval_mode` are properties the user (or a future engine) sets at the start of the task. In practice today, Claude asks the user at Stage 1 and records the answers in `brainstorm.md`.

---

## 6. Completion criteria — when a stage is "done"

A stage is complete only when both (a) the output document exists and (b) the criteria below are met. Writing the document alone is not sufficient.

### Representative criteria (the ones most commonly missed)

**Stage 1 — Brainstorm**
- [ ] Problem statement is explicit
- [ ] At least one "non-goal" is written down
- [ ] `mode` (Lite/Standard/Strict), `has_ui`, `risk_level` are recorded
- [ ] User agrees with the recommended direction

**Stage 4 — Plan Final**
- [ ] Scope is split into in-scope and out-of-scope
- [ ] Success criteria are measurable (not aspirational)
- [ ] Top 3 risks each have a mitigation
- [ ] Timeline is at least coarse-grained

**Stage 5 — Technical Design**
- [ ] Module boundaries are named
- [ ] Data flow is described end-to-end
- [ ] Error paths are specified, not just happy paths
- [ ] Test strategy lists at least one edge case per module
- [ ] Security considerations are addressed (even if "N/A, reason: …")

**Stage 9 — Code Review**
- [ ] Tests pass
- [ ] No hardcoded secrets or unvalidated inputs
- [ ] Follows existing code patterns
- [ ] Non-obvious logic is commented
- [ ] Result is explicit: **PASS** or **NEEDS REVISION**

**Stage 11 — Final Validation**
- [ ] Every Stage 9 finding is addressed or deliberately deferred
- [ ] No regression in existing tests
- [ ] Integration points verified (not just unit tests)
- [ ] Docs (README, docstrings) updated if behavior changed
- [ ] Result is explicit: **APPROVED** or **CHANGES REQUESTED**

**Stage 12 — QA & Release**
- [ ] Happy path test scenario written
- [ ] At least one failure/edge-case scenario written
- [ ] Release checklist signed off

For other stages, use the same pattern: define a handful of observable checks, not a checklist of vague intents.

---

## 7. Re-entry and rollback rules

Real workflows are not linear. A stage can fail or be rejected, and the workflow must know where to go back to. These rules make that explicit.

### 7.1 Loop rules

| Trigger | Action | Returns to |
|---------|--------|-----------|
| Stage 9 result = NEEDS REVISION | Hand back to Codex | Stage 10 → Stage 9 |
| Stage 11 result = CHANGES REQUESTED (minor) | Codex fixes | Stage 10 → Stage 9 → Stage 11 |
| Stage 11 result = CHANGES REQUESTED (design-level) | Claude revises design | Stage 5 (or 6/7) → Stage 8 |
| Stage 4.5 = User rejects plan | Replan | Stage 2 (or Stage 1 if direction is wrong) |
| Stage 12 QA fail (test scenario) | Fix and retest | Stage 10 → Stage 9 → Stage 12 |
| Stage 13 deploy fail (env issue) | Fix deploy assets only | Stage 13 (not back to 8) |
| Production incident post-13 | Enter a new Lite task | Stage 8 (Lite) |

### 7.2 Rollback principles

- Rolling back **does not** mean deleting prior documents. Append a new revision section instead, so dev_history stays auditable.
- Every rollback must be logged in `docs/notes/dev_history.md` with the trigger, the stage it returned to, and the reason.
- If the same loop (e.g., Stage 9 → 10) happens three times on the same change, pause and escalate to Strict mode. Repeated loops are usually a signal that design is wrong, not that code is wrong.

### 7.3 Flow sketch (Standard mode)

```
ideation → planning → approval_gate → design → implementation
                                                    ↓
                                                  review ──fail──▶ implementation (loop)
                                                    ↓pass
                                               validation ──fail──▶ design | implementation
                                                    ↓pass
                                                qa_release
                                                    ↓
                                                  archive
```

The Strict mode uses the same skeleton but adds stricter conditions at each gate. Lite mode collapses `ideation → planning → design` into a short note and keeps `implementation → review → archive`.

---

## 8. Operating context — feature vs hotfix vs architecture

This is the same idea as mode selection, expressed from the user's point of view.

### 8.1 Feature development (Standard or Strict)

- Adding new functionality
- Refactoring core modules
- Integrating new APIs or services
- Redesigning architecture
- Fixing bugs that touch architecture
- **Trigger phrases:** "implement X", "refactor Y", "add support for Z"

### 8.2 Lite / hotfix execution (Lite)

- Emergency production fixes (go directly Stage 8 → 9 (light) → 11 (optional) → 13)
- Config or data file updates
- Routine maintenance (log cleanup, cache refresh)
- Documentation-only updates
- **Trigger phrases:** "fix bug in main.py", "update config", "bump version"

### 8.3 Mode switch rule

At session start, check `HANDOFF.md`:

- Status shows "feature development in progress" → use the mode recorded there (usually Standard)
- Status shows "all systems nominal" → read CLAUDE.md + HANDOFF.md and decide mode with the user at Stage 1
- If the user says "just fix this real quick" → confirm Lite mode out loud before acting

---

## 9. Model and effort strategy

### Model selection guide

| Task type | Primary | Fallback | Reason |
|-----------|---------|----------|--------|
| Brainstorm, architecture | **Opus** | Sonnet | Strong reasoning on ambiguous/creative problems |
| Planning, design review | **Sonnet** | Opus | Fast iteration, sufficient depth |
| Code review, validation | **Sonnet** or **Opus** | — | Routine → Sonnet; critical path → Opus |
| Implementation | **Codex** | — | Specialized coding environment |
| Documentation, summary | **Haiku** | Sonnet | Fast and cost-efficient |

### Effort decision tree

```
Is it security-related or production-critical?
├─ YES → XHigh (Stage 11 in Strict mode)
└─ NO
   ├─ Does it affect core architecture or multiple systems?
   │  ├─ YES → High
   │  └─ NO
   │     ├─ New feature or significant refactor?
   │     │  ├─ YES → Medium (planning) → High (review)
   │     │  └─ NO → Medium or Low
   │     └─ Documentation or summary?
   │        └─ YES → Low or Medium
```

---

## 10. Agent composition

Four dedicated agents. Codex is an external implementation tool, not an agent.

| Agent | Stages | Primary model | Effort |
|-------|--------|---------------|--------|
| 🧠 Planner | 1, 2, 3, 4 | Sonnet (Opus for Stage 1) | Medium–High |
| 🏗️ Designer | 5, 6, 7 | Opus (Stage 5) / Sonnet (6–7) | Medium–High |
| 🔍 Reviewer | 9, 11 | Sonnet (9) / Opus (11) | High–XHigh |
| 🧪 QA Engineer | 12, 13 | Sonnet | Medium |
| ⚙️ Codex (external) | 8, 10 | — | — |

### Design principles

1. **Designer ≠ Reviewer** — the agent that designed something must not sign off on it (confirmation bias).
2. **Stage 1 uses Opus** — getting direction wrong at brainstorm breaks everything downstream.
3. **Codex is a tool** — keep it out of the agent composition. Stages 8 and 10 belong to Codex.

### Lite agent composition

For Lite / hotfix work:

```
⚙️ Codex  →  🔍 Reviewer (light)  →  🧪 QA Engineer (checklist only)
```

---

## 11. Implementation stages — future operation-level breakdown

Stages 8, 10, and 13 are, in this version, described at a high level. A future version of jOneFlow is expected to break them down further for orchestration purposes. This section documents that intent so the reference flow is forward-compatible.

Planned operation-level steps within each Codex stage:

- **Stage 8 — Implementation** → generate code · run tests · fix test failures · update implementation log · create commit / checkpoint
- **Stage 10 — Revision** → apply review feedback · re-run tests · update implementation log · amend commit
- **Stage 13 — Deploy & Archive** → verify release checklist · tag release · deploy · update `HANDOFF.md` · archive stage docs

These operations do not change the canonical flow today. They are noted here so that when an engine or automation is added, the breakdown does not require a rewrite of the architecture.

---

## 12. Core operating principles

1. **No role mixing** — Claude does not implement; Codex does not validate.
2. **Plan before design** — do not enter Stage 5 without a confirmed Stage 4 (in Standard/Strict).
3. **Design before code** — no code without a confirmed Stage 5, except Lite mode (always logged).
4. **Documents first** — all outputs go to `docs/` before moving to the next stage.
5. **Single source of truth** — `docs/` > chat history > memory.
6. **Mode is a decision, not a default** — every task starts by choosing Lite / Standard / Strict out loud.

---

## 13. Session handoff and persistence

### Read order (every new session)

1. **CLAUDE.md** — project rules, security, key files
2. **HANDOFF.md** — current status, mode, recent changes, next tasks
3. **WORKFLOW.md** — this file (skim sections 1–3 for feature work)
4. **Relevant `docs/`** — only the document for the current stage

### Write order (end of session)

1. Update the current stage document
2. Append to `docs/notes/dev_history.md`: stage number, date, what was done, blockers, output links
3. Update `HANDOFF.md`: current mode, current status, next session tasks, blockers, document links
4. Write or refresh the "next session prompt" at the bottom of `HANDOFF.md`

### Next-session prompt rules

When the user says "set me up to continue next session":

1. Update `HANDOFF.md`
2. Add or refresh the `## 📋 Next Session Prompt` section at the bottom

**Prompt writing principles:**

- Copy-pasteable with no extra explanation needed
- Include today's summary (for context restoration)
- State the next task clearly (file names and stage numbers)
- Include relevant file paths
- Include key design decisions (so the next session does not re-debate them)

---

## 14. Independent validation protocol

**Required for Stage 11 in Strict mode. Recommended for any complex logic change.**

Reviewing code in the session that produced it introduces confirmation bias. Use a fresh Claude session with no prior context.

### Steps

1. Start a new Claude session (no context from the current session)
2. Paste only the changed code and minimal background
3. Ask for: bug/logic errors, security vulnerabilities, exception handling, improvements
4. Apply findings back to the current session

### When to apply

| Change size | Validation method |
|------------|-------------------|
| 1–10 lines | Current-session self-review is fine |
| 10–50 lines | Independent validation recommended |
| 50+ lines or a new file | Independent validation required |
| New agent or orchestrator | Independent validation required |

---

## 15. File and folder structure

```
project-root/
├─ CLAUDE.md                          ← Project rules + security (read first)
├─ HANDOFF.md                         ← Current status + next tasks (read second)
├─ WORKFLOW.md                        ← This file (reference as needed)
├─ README.md                          ← User-facing project docs (English)
├─ README.ko.md                       ← User-facing project docs (Korean)
├─ ATTRIBUTION.md                     ← Credits / influence acknowledgments
│
├─ .skills/
│  ├─ README.md                       ← How to write behavior-shaping skills
│  ├─ _templates/                     ← Starter SKILL.md template
│  └─ examples/                       ← Worked example skills
│
├─ docs/
│  ├─ 01_brainstorm/
│  │  └─ brainstorm.md               ← Stage 1: ideas, constraints, mode choice
│  ├─ 02_planning/
│  │  ├─ plan_draft.md               ← Stage 2
│  │  ├─ plan_review.md              ← Stage 3
│  │  └─ plan_final.md               ← Stage 4
│  ├─ 03_design/
│  │  ├─ technical_design.md         ← Stage 5
│  │  ├─ ui_requirements.md          ← Stage 6 (if has_ui)
│  │  └─ ui_flow.md                  ← Stage 7 (if has_ui)
│  ├─ 04_implementation/
│  │  └─ implementation_progress.md  ← Stages 8–10
│  ├─ 05_qa_release/
│  │  ├─ qa_scenarios.md             ← Stage 12
│  │  └─ release_checklist.md        ← Stage 12
│  └─ notes/
│     ├─ dev_history.md              ← Cumulative log of every stage + mode + rollback
│     ├─ decisions.md                ← Decision rationale
│     └─ final_validation.md         ← Stage 11
│
├─ prompts/
│  ├─ claude/                        ← Reusable prompts for Claude stages
│  └─ codex/                         ← Reusable prompts for Codex stages
│
├─ scripts/
│  ├─ init_project.sh
│  ├─ ai_step.sh
│  ├─ git_checkpoint.sh
│  ├─ setup_security.sh
│  ├─ append_history.sh
│  └─ zsh_aliases.sh
│
├─ security/
│  ├─ secret_loader.py
│  ├─ keychain_manager.py
│  └─ credential_manager.py
│
├─ src/
├─ tests/
├─ .claude/
│  ├─ settings.json
│  └─ language.json
├─ .env.example
├─ .gitignore
└─ LICENSE
```

---

## 16. CLI automation aliases

```bash
source ~/projects/my-project/scripts/zsh_aliases.sh
```

| Alias | Stage | Description |
|-------|-------|-------------|
| `aiinit` | — | Initialize project folders |
| `aib` | 1 | Brainstorm (Opus) |
| `aipd` | 2 | Plan Draft (Sonnet) |
| `aipr` | 3 | Plan Review (Sonnet) |
| `aipf` | 4 | Plan Final (Sonnet) |
| `aitd` | 5 | Technical Design (Opus) |
| `aiui` | 6 | UI Requirements (Sonnet) |
| `aiflow` | 7 | UI Flow (Sonnet) |
| `aiimpl` | 8 | Implementation (Codex) |
| `aireview` | 9 | Code Review (Sonnet) |
| `airevise` | 10 | Revision (Codex) |
| `aifinal` | 11 | Final Validation (Opus) |
| `aiqa` | 12 | QA & Release (Sonnet) |
| `aigit` | — | Git checkpoint + dev_history entry |
| `aihist` | — | Manual dev_history entry |

---

## 17. Version history

| Date | Version | Changes |
|------|---------|---------|
| 2026-04-21 | 2.0 | Introduced Lite / Standard / Strict modes. Reframed 13-stage flow as Canonical Strict Flow. Added stage types, execution conditions, completion criteria, re-entry rules. Noted future operation-level breakdown for Codex stages. |
| 2026-04-21 | 1.0 | Initial release. Generalized from stockpilot workflow. KIS/stock-specific content removed. Cross-platform security module added. |

---
---

# 🔄 jOneFlow — AI 기반 개발 워크플로우 아키텍처 (한국어)

> **버전:** 2.0
> **범위:** Claude를 오케스트레이터로, Codex를 구현자로 사용하는 모든 프로젝트에 적용 가능

---

## 0. 이 문서는 무엇인가

이 파일은 jOneFlow의 **워크플로우 아키텍처 기준 문서**다. 다음을 설명한다.

1. **계층형 워크플로우 모델** — Lite / Standard / Strict — 작업 위험도에 맞게 워크플로우 무게를 선택
2. **Canonical Strict Flow** (13단계) — 거버넌스의 상한선 정의
3. **Stage type** — 오케스트레이션 엔진이 재조합 가능한 공통 어휘
4. **실행 조건**, **완료 기준**, **재진입 규칙** — 직선이 아닌 실제 워크플로우

jOneFlow의 철학(문서 우선, 역할 분리, `HANDOFF.md` 기반 세션 지속성, 보안 우선)은 그대로다. v2에서 달라진 점은 이 원칙을 "고정 13단계 파이프라인"이 아니라 "확장/축소 가능한 모델"로 표현한다는 것이다.

---

## 1. 요약

jOneFlow는 **문서 중심, 역할 분리 개발 프로세스**다.

- **Claude**: 사고, 기획, 설계, 검증, QA
- **Codex**: 구현, 수정, 배포
- **문서** (`docs/`): 단일 정보원
- **HANDOFF.md**: 세션 간 상태 전달
- **워크플로우 모드** (Lite / Standard / Strict): 프로젝트 단위가 아니라 **작업 단위**로 선택

아래의 13단계는 **Strict Flow**다. 유일한 경로가 아니라, 경량 모드들이 파생되어 나오는 기준(canonical reference)이다.

---

## 2. 워크플로우 모드 — Lite / Standard / Strict

모든 작업을 13단계로 돌릴 필요는 없다. 위험도와 복잡도에 맞는 모드를 선택하라.

### 2.1 모드 비교

| 항목 | **Lite** | **Standard** | **Strict** |
|------|----------|--------------|------------|
| 사용 상황 | 핫픽스, 설정 수정, 문구 수정 | 신기능, 리팩토링, 일반 개발 | 아키텍처/보안/데이터 스키마/결제 등 고위험 |
| 복잡도 | 낮음 | 중간 | 높음 |
| 위험도 | 낮음 | 중간~높음 | 높음~치명적 |
| 기획 문서 | 최소 (1줄 노트) | 필수 | 필수 + 검토 |
| 사용자 승인 | 선택 | Stage 4에서 필수 | 더 엄격한 기준으로 필수 |
| 기술 설계 | 선택 / 인라인 | 필수 | 필수, Opus 수준 |
| 코드 리뷰 | 가볍게 세션 내 | 필수 (Stage 9) | 필수 + 독립 검증 |
| 최종 검증 | 생략 또는 Sonnet | Sonnet (High) | Opus (XHigh) |
| QA/릴리스 문서 | 체크리스트만 | 전체 | 전체 + 릴리스 체크리스트 |
| 일반적 소요 시간 | 분~2시간 | 4시간~2일 | 2일~주 |

### 2.2 모드 선택 기준

**Lite**를 쓸 때:

- 변경이 국소적이고 되돌리기 쉬움 (설정값, 문구, 로그 포맷)
- 사용자 관점 기능 변화가 없음
- 긴급하고 범위가 분명함 (운영 핫픽스)
- 한 문장으로 설명 가능

**Standard**를 쓸 때:

- 기능 추가, 모듈 리팩토링, 외부 서비스 연동
- 두 개 이상의 파일 또는 서브시스템이 관련됨
- Codex가 스펙을 받아 구현해야 함
- 평소 개발 작업의 기본값

**Strict**를 쓸 때:

- 아키텍처, 보안, 인증, 데이터 스키마, 결제에 영향
- 여러 시스템/외부 연동 포함
- 롤백이 어려움
- 규제/컴플라이언스/감사 대상

**애매할 때**: 더 무거운 모드를 고른다. 기획을 가볍게 하는 비용 < 검토를 빼먹은 복구 비용.

### 2.3 모드별 스테이지 커버리지

| 단계 | Stage type | Lite | Standard | Strict |
|------|-----------|------|----------|--------|
| 1 Brainstorm | ideation | 생략 | 간단 수행 | 수행 |
| 2 Plan Draft | planning | 생략 | 수행 | 수행 |
| 3 Plan Review | planning | 생략 | 선택 | 수행 |
| 4 Plan Final | planning | 최소 노트 | 수행 | 수행 |
| 4.5 Approval | approval_gate | 선택 | 수행 | 더 엄격 |
| 5 Technical Design | design | 생략/인라인 | 수행 | 수행 |
| 6 UI Requirements | design | 생략 | `has_ui`면 수행 | `has_ui`면 수행 |
| 7 UI Flow | design | 생략 | `has_ui`면 수행 | `has_ui`면 수행 |
| 8 Implementation | implementation | 수행 | 수행 | 수행 |
| 9 Code Review | review | 경량 | 수행 | 수행 |
| 10 Revision | implementation | 리뷰 실패 시 | 리뷰 실패 시 | 리뷰 실패 시 |
| 11 Final Validation | validation | 생략 또는 Sonnet | 수행 (High) | 수행 (XHigh) |
| 12 QA & Release | qa_release | 체크리스트만 | 수행 | 수행 |
| 13 Deploy & Archive | archive | 수행 (단순) | 수행 | 수행 |

---

## 3. Canonical Strict Flow — 13단계

모든 작업의 기본값이 아니라, **템플릿에서 규율의 상한선**이다. Lite와 Standard는 여기에서 파생된 부분집합이다.

| # | 단계 | Type | 담당 | 모델 | Effort | 입력 | 산출물 | 예상 시간 |
|---|------|------|------|------|--------|------|--------|----------|
| 1 | **아이디어 구상** ⚠️ | ideation | Claude + 사용자 | Opus | Medium | 사용자 요청 | `docs/01_brainstorm/brainstorm.md` | 15~30분 |
| 2 | **계획 초안** | planning | Claude | Sonnet | Medium | 구상 결과 | `docs/02_planning/plan_draft.md` | 15~30분 |
| 3 | **계획 검토** | planning | Claude | Sonnet | High | 계획 초안 | `docs/02_planning/plan_review.md` | 10~20분 |
| 4 | **계획 통합** ⚠️ | planning | Claude | Sonnet | Medium | 초안 + 검토 | `docs/02_planning/plan_final.md` | 10~15분 |
| 4.5 | **사용자 승인** 🔴 | approval_gate | 사용자 | — | — | plan_final.md | 승인 확인 | — |
| 5 | **기술 설계** | design | Claude | Opus | High | 승인된 계획 | `docs/03_design/technical_design.md` | 30~60분 |
| 6 | **UI 요구사항** *(`has_ui`)* | design | Claude | Sonnet | Medium | 기술 설계 | `docs/03_design/ui_requirements.md` | 15~30분 |
| 7 | **UI 플로우** *(`has_ui`)* | design | Claude | Sonnet | Medium | UI 요구사항 | `docs/03_design/ui_flow.md` | 20~40분 |
| 8 | **구현** | implementation | Codex | — | High | 기술 설계 | 코드 + 테스트 + 커밋 | 1~8시간 |
| 9 | **코드 리뷰** | review | Claude | Sonnet | High | Codex 결과 | `docs/04_implementation/implementation_progress.md` | 15~30분 |
| 10 | **수정** | implementation | Codex | — | Medium | 리뷰 피드백 | 수정된 코드 | 30분~2시간 |
| 11 | **최종 검증** | validation | Claude | Opus | XHigh 또는 High* | 수정된 코드 | `docs/notes/final_validation.md` | 30분~1시간 |
| 12 | **QA & 릴리스** | qa_release | Claude | Sonnet | Medium | 검증된 코드 | `docs/05_qa_release/qa_scenarios.md` | 15~30분 |
| 13 | **배포 & 아카이브** | archive | Codex | — | Medium | QA 승인 | 병합 + HANDOFF 업데이트 | 가변 |

---

## 4. Stage type — 재사용 가능한 어휘

| Stage type | 목적 | 담당 | 해당 단계 |
|-----------|------|------|-----------|
| `ideation` | 문제/제약/옵션 탐색 | Claude + 사용자 | 1 |
| `planning` | 기획 구체화 | Claude | 2, 3, 4 |
| `approval_gate` | 명시적 인간 승인 | 사용자 | 4.5 |
| `design` | 구현 방식 결정 | Claude | 5, 6, 7 |
| `implementation` | 코드/테스트/커밋 | Codex | 8, 10 |
| `review` | 독립 검수 | Claude | 9 |
| `validation` | 최종 go/no-go | Claude | 11 |
| `qa_release` | 릴리스 전 검증 | Claude | 12 |
| `archive` | 배포/태깅/인계 | Codex | 13 |

---

## 5. 실행 조건 요약

- `has_ui`: UI 포함 여부. UI 없으면 Stage 6, 7 생략
- `complexity >= medium`: Stage 3(Plan Review) 강하게 권장
- `risk_level >= medium` 또는 `mode == Strict`: Stage 11(Final Validation) 수행
- `approval_mode == manual` (Standard/Strict 기본값): Stage 4.5 필수

실제 오늘의 운영에서는 Stage 1 구상 시 Claude가 사용자에게 물어보고 `brainstorm.md`에 기록한다. 미래에는 이 값을 엔진이 프로젝트 메타데이터에서 읽어 자동 판단할 수 있게 설계했다.

---

## 6. 완료 기준 요약

각 단계는 문서를 쓴 것만으로 완료가 아니다. 최소 관찰 가능한 기준을 갖춰야 한다. 자세한 체크리스트는 영어 본문 섹션 6 참고.

핵심 기준:

- **Stage 1**: 문제/비목표/mode/has_ui/risk_level을 기록, 사용자 합의
- **Stage 4**: in/out-of-scope 분리, 측정 가능한 성공 기준, 상위 3 리스크 대응, 타임라인
- **Stage 5**: 모듈 경계, 데이터 흐름, 에러 경로, 테스트 전략, 보안 고려
- **Stage 9**: 테스트 통과, 시크릿 미노출, 명시적 PASS/NEEDS REVISION
- **Stage 11**: 모든 리뷰 지적 처리, 회귀 없음, 명시적 APPROVED/CHANGES REQUESTED
- **Stage 12**: 해피/실패 시나리오, 릴리스 체크리스트 서명

---

## 7. 재진입 / 롤백 규칙

| 트리거 | 행동 | 복귀 지점 |
|--------|------|-----------|
| Stage 9 = NEEDS REVISION | Codex 재작업 | 10 → 9 |
| Stage 11 = CHANGES REQUESTED (경미) | Codex 수정 | 10 → 9 → 11 |
| Stage 11 = CHANGES REQUESTED (설계 수준) | Claude 설계 수정 | 5 (또는 6/7) → 8 |
| Stage 4.5 = 승인 거절 | 재기획 | 2 (방향 자체가 틀리면 1) |
| Stage 12 QA 실패 | 수정 후 재검증 | 10 → 9 → 12 |
| Stage 13 배포 실패 | 배포 자산만 수정 | 13 |
| 배포 후 인시던트 | 새 Lite 작업 | 8 (Lite) |

**원칙:**

- 롤백은 문서를 **지우지 않는다**. 새 revision 섹션을 덧붙여 dev_history의 감사 가능성을 유지한다.
- 모든 롤백은 `docs/notes/dev_history.md`에 트리거/복귀지점/이유와 함께 기록한다.
- 같은 루프(예: 9→10)가 3회 반복되면 멈추고 Strict로 승격한다. 반복 루프는 보통 **코드 문제가 아니라 설계 문제**의 신호다.

---

## 8. 운영 컨텍스트 — feature vs hotfix vs architecture

### 8.1 기능 개발 (Standard 또는 Strict)

- 신기능, 리팩토링, 외부 연동, 아키텍처 변경, 아키텍처에 영향을 주는 버그 수정
- **트리거 문구:** "X 기능 구현", "Y 모듈 리팩토링", "Z 추가"

### 8.2 Lite / 핫픽스 실행 (Lite)

- 운영 긴급 수정 (Stage 8 → 9(경량) → 11(선택) → 13 직결)
- 설정/데이터 파일 업데이트
- 로그/캐시 유지보수
- 문서만 수정
- **트리거 문구:** "main.py 버그 수정", "설정 변경", "버전 올림"

### 8.3 모드 전환 규칙

세션 시작 시 `HANDOFF.md`에서:

- "feature development in progress" → 거기 기록된 모드 사용 (보통 Standard)
- "all systems nominal" → CLAUDE.md + HANDOFF.md 읽고 Stage 1에서 사용자와 모드 합의
- 사용자가 "빨리 하나만 고쳐줘" → Lite 모드를 소리내어 확인 후 진행

---

## 9. 핵심 운영 원칙

1. **역할 혼합 금지** — Claude는 구현 안 함, Codex는 검증 안 함
2. **설계 전에 계획** — Stage 4 확정 없이 Stage 5 진입 금지 (Standard/Strict)
3. **코드 전에 설계** — Stage 5 확정 없이 코드 금지. Lite 예외는 반드시 기록
4. **문서 우선** — 모든 산출물 → `docs/` → 다음 단계
5. **단일 정보원** — `docs/` > 채팅 기록 > 기억
6. **모드는 결정이지 기본값이 아니다** — 모든 작업은 Lite/Standard/Strict를 **소리내어** 고르는 것으로 시작

---

## 10. 세션 핸드오프

**읽기 순서 (매 세션):** CLAUDE.md → HANDOFF.md → WORKFLOW.md → 관련 docs/

**쓰기 순서 (세션 종료):**

1. 현재 단계 문서 업데이트
2. `docs/notes/dev_history.md` 항목 추가 (단계 번호/날짜/완료 내용/모드/차단 요인)
3. `HANDOFF.md` 업데이트 (모드, 상태, 다음 작업, 문서 링크)
4. `HANDOFF.md` 하단 "다음 세션 프롬프트" 갱신

---

*이 워크플로우는 살아있는 문서입니다. 피드백과 개선 사항을 환영합니다.*
