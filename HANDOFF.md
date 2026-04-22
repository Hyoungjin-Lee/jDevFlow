# 📋 HANDOFF — Session State

> **Read this second**, after CLAUDE.md.
> Update this file at the end of every session.
> Korean version below (한국어 버전: 파일 하단)

> ⚠️ **Note (2026-04-22):** This file currently tracks **jOneFlow's own v0.3 dogfooding**
> state (Option 1). A clean template version will be separated into
> `templates/HANDOFF.template.md` at v0.3 release (Bundle 4 — Doc discipline scope).
> Until then, new projects should copy this file and clear state sections manually.

---

## Status

**Current version:** v0.3 (in progress)
**Last updated:** 2026-04-22 (session 3 resumed — Stage 5 complete for both bundles; Stage 8 Codex handoff package ready; next Claude session = Stage 9 code review after Codex finishes)
**Workflow mode:** Strict-hybrid
**Current stage:** Stage 5 ✅ complete for **both bundles**. Stage 8 Codex **handoff package prepared** (`prompts/codex/v03/stage8_bundle4_codex_kickoff.md` + `stage8_bundle1_codex_kickoff.md` + `stage8_coordination_notes.md`); next Claude session resume prompt at `prompts/claude/v03/session4_post_codex_resume_prompt.md`. **Awaiting Codex Stage 8 runs** (Bundle 4 first, then Bundle 1, per M.1 + DEP.1). Stage 6/7 skipped (`has_ui=false`).
**has_ui:** false
**risk_level:** medium

### ✅ Completed
- [x] Project initialized (folders, CLAUDE.md, WORKFLOW.md present — inherited from v0.2)
- [x] Language selected: EN primary + KO translation (applies from `plan_draft.md` onward)
- [x] Security setup: inherited from v0.2 (no changes in v0.3 scope)
- [x] Git initialized (local tracking assumed; inherited from v0.2)
- [x] **Stage 1 — Brainstorm** → `docs/01_brainstorm/brainstorm.md`
- [x] Mode & bundle selection: Strict-hybrid, Bundle 1 + Bundle 4
- [x] Validation group declared: Group 1 = {Bundle 1, Bundle 4}
- [x] **Stage 2 — Plan Draft** → `docs/02_planning/plan_draft.md` (EN) + `plan_draft.ko.md` (KO)
- [x] Language policy first application: EN primary written, KO paired translation committed same session (per R4 mitigation rule in plan_draft Sec. 5-2)
- [x] **Stage 3 — Plan Review** → `docs/02_planning/plan_review.md` (EN) + `plan_review.ko.md` (KO). Verdict: PASS all 4 focus points (coverage / top-3 risks / OQ containment / KO sync). 8 revisions forwarded to plan_final (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3). One true leak caught: **OQ.S11.2 → promote to committed policy M.5** (divergent-verdict policy).
- [x] **Stage 4 — Plan Final** → `docs/02_planning/plan_final.md` (EN) + `plan_final.ko.md` (KO). All 8 plan_review revisions absorbed. Approval checklist 7/7 ✅. Ready for Stage 4.5 presentation.
- [x] **Stage 4.5 — User approval gate** ✅ APPROVED (2026-04-22, session 3 resumed). Joint approval for Bundle 1 + Bundle 4 (M.1 satisfied, no partial approval). Bundle approval_status → approved for both. Stage 5 unblocked.
- [x] **Pre-Stage-5 housekeeping (DC.5 + DC.6)** ✅ complete — drafts saved in `prompts/claude/v03/`:
  - `stage5_bundle4_design_prompt_draft.md` (DC.5 half #1; Bundle 4 first per DEP.1)
  - `stage5_bundle1_design_prompt_draft.md` (DC.5 half #2; gated on Bundle 4 Sec. 0 locked)
  - `stage11_joint_validation_prompt.md` (DC.6; enforces dossier-based context delivery + M.3/M.5/M.6)
- [x] **Stage 5 Bundle 4 — Technical Design** ✅ complete (2026-04-22, session 3 resumed) — `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN) + `technical_design.ko.md` (KO). Sec. 0 locks D4.x2/x3/x4; AC.B4.1–16 acceptance criteria enumerated; 12-section Codex handoff appendix; YAML frontmatter applied per D4.x2; KO sync check block ticked (18/18 headers, 16/16 AC items). **DEP.1 unblocked** — Bundle 1 Stage 5 can now begin.
- [x] **Stage 5 Bundle 1 — Technical Design** ✅ complete (2026-04-22, session 3 resumed) — `docs/03_design/bundle1_tool_picker/technical_design.md` (EN) + `technical_design.ko.md` (KO). Quotes Bundle 4 D4.x2/x3/x4 verbatim in Sec. 0 per DEP.1. Single-file skill design (D1.a/D1.b/D1.c in one SKILL.md ≤ 300 lines) + D1.x usage reference doc. Decision table covers stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high}. AC.B1.1–10 enumerated (headline: AC.B1.7 R2 read-only invariant). Closes OQ1.1 (single file), OQ1.2 (both triggers, one pipeline), OQ1.3 (no native API registration). YAML frontmatter + KO sync check block ticked (17/17 headers, 10/10 AC items).
- [x] **Stage 8 Codex handoff package prepared** ✅ (2026-04-22, session 3 resumed, session-close housekeeping) — 4 new files:
  - `prompts/codex/v03/stage8_bundle4_codex_kickoff.md` — Bundle 4 first per M.1 (owns `docs/notes/decisions.md`)
  - `prompts/codex/v03/stage8_bundle1_codex_kickoff.md` — Bundle 1 second; Precondition checklist gates on Bundle 4 complete
  - `prompts/codex/v03/stage8_coordination_notes.md` — run-order, single-vs-two-session, failure escalations, report shape
  - `prompts/claude/v03/session4_post_codex_resume_prompt.md` — post-Codex Claude resume prompt (EN + KO mirror) for starting session 4 at Stage 9

### 🔄 In Progress
- **Awaiting Codex Stage 8 execution** (external to Claude session). Hyoungjin runs Bundle 4 kickoff → receives completion report → runs Bundle 1 kickoff → receives completion report → starts new Claude session using the resume prompt. Next Claude session enters **Stage 9 code review**.

### ⏭️ Next (session 3 continuation or session 4)
1. ~~Pre-Stage-5 housekeeping (DC.5 + DC.6)~~ ✅ complete (all 3 drafts saved).
2. Stage 5 — Technical Design per bundle (DC.5/DC.6 drafts exist ✅ + Stage 4.5 approved ✅; Bundle 4 structural decisions D4.x2–x4 lock first per DEP.1 tightened by F-o1)
3. Backfill: start `docs/notes/dev_history.md` with entries for sessions 1–3 (still deferred since session 1)

### 🚧 Blockers
- None. Stage 4.5 approval obtained; housekeeping → Stage 5 flow unblocked.
- Housekeeping soft-prereq: DC.5 + DC.6 prompt drafts should exist before entering Stage 5 (per AN.1 in plan_final Sec. 8-3).

---

## Bundles (v0.3 scope)

```yaml
bundles:
  - id: 1
    name: tool-picker
    goals: [7, 11, 12]          # from prompts/claude/v03_kickoff.md
    risk_level: medium-high
    stage: 1                     # Stage 1 complete; planned collectively Stages 2-4
    verdict: null                # minor | bug_fix | design_level | null
    validation_group: 1
    approval_status: approved  # Stage 4.5 joint approval 2026-04-22 (M.1 satisfied)
  - id: 4
    name: doc-discipline
    goals: [5, 9, 10]              # from v03_kickoff.md
    scope_option: beta              # α = goals only, β = goals + brainstorm Sec. 9-2, γ = split
    scope_extras:                   # added under option β (2026-04-22 session 1 close)
      - internal_doc_header_schema
      - bundle_folder_naming
      - doc_link_conventions
      - template_vs_dogfooding_separation  # earlier deferral folded in
    risk_level: medium               # bumped from low-medium under option β
    stage: 1
    verdict: null
    validation_group: 1
    approval_status: approved  # Stage 4.5 joint approval 2026-04-22 (M.1 satisfied)

deferred:
  - id: 2
    name: metadata-refinement
    goals: [1, 2, 3]
    reason: depends on Bundle 1 real-world use; re-scope in v0.4
  - id: 3
    name: codex-handoff-ux
    goals: [4, 6, 8]
    reason: depends on Bundle 1 skill surface; re-scope in v0.4

validation_groups:
  - id: 1
    bundles: [1, 4]
    stage_11_required: true
```

---

## Recent Changes

| Date | Description |
|------|-------------|
| 2026-04-22 | Stage 1 Brainstorm complete: mode=strict-hybrid, bundles 1+4 selected, validation group 1 declared, UI base-only policy set (through v0.5 or first downstream has_ui=true) |
| 2026-04-22 | HANDOFF.md converted from template into v0.3 dogfooding tracker (Option 1); template separation deferred to Bundle 4 |
| 2026-04-22 | Bundle 4 scope clarified (option β): covers both goals 5/9/10 AND brainstorm Sec. 9-2 internal doc structure items; risk_level bumped low-medium → medium; brainstorm.md Addendum added |
| 2026-04-22 | Session 1 closed before plan_draft.md to preserve context; session 2 resumes at Stage 2 |
| 2026-04-22 | Session 2: Stage 2 Plan Draft complete — `plan_draft.md` (EN) + `plan_draft.ko.md` (KO) written. Scope: bundles combined, kickoff goals and scope_extras kept as separate lists, bundle×stage milestone matrix, 7-item approval checklist (WORKFLOW Sec. 6 baseline 4 + Strict-hybrid extras 3) pre-baked. Session 3 resumes at Stage 3. |
| 2026-04-22 | Session 2: added operational wiki `docs/notes/session_token_economics.md` — living doc capturing the "continue session vs. new session" decision framework, derived from session 2's own 76%-usage judgment. KO-only; EN pair deferred to OSS release. |
| 2026-04-22 | Session 3: Stage 3 Plan Review complete — `plan_review.md` (EN) + `plan_review.ko.md` (KO). All 4 focus points PASS. 8 revisions forwarded to plan_final. Key finding: **OQ.S11.2 (divergent-verdict policy) was a true Stage-4 leak** — promoted to committed rule M.5. 2 traceability upgrades (DC.6, DEP.1 tightening). Session closed before Stage 4 at ~95% UI token usage; plan_final work fully pre-staged in plan_review Sec. 6 for session 4. |
| 2026-04-22 | Session 3 (resumed after token refill): Stage 4 Plan Final complete — `plan_final.md` (EN) + `plan_final.ko.md` (KO). All 8 plan_review revisions absorbed (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3). Approval checklist 7/7 ✅. Stage 4.5 approval gate now presented to user; Stage 5 is blocked until approval. |
| 2026-04-22 | Session 3 (resumed): **Stage 4.5 APPROVED** by user (joint Bundle 1 + 4, M.1 satisfied). Both bundles `approval_status: approved` in HANDOFF YAML. Stage 5 unblocked. Next: DC.5 + DC.6 prompt drafts → Stage 5 Bundle 4 (per DEP.1 tightened) → Bundle 1. Note: the U+00A7 section-sign character will be dropped in new documents for readability (replaced by literal "Sec. " prefix). |
| 2026-04-22 | Session 3 (resumed): **DC.5 + DC.6 housekeeping complete**. 3 new files under `prompts/claude/v03/`: `stage5_bundle4_design_prompt_draft.md`, `stage5_bundle1_design_prompt_draft.md`, `stage11_joint_validation_prompt.md`. Bundle 4 prompt enforces D4.x2–x4 as Sec. 0 locked-first requirement; Bundle 1 prompt hard-gates on Bundle 4 Sec. 0 existence; Stage 11 prompt commits to pre-compacted dossier format (resolves OQ.S11.1). Section-sign U+00A7 convention dropped from new files. |
| 2026-04-22 | Session 3 (resumed): **`§ → Sec. ` batch migration** across 8 v0.3 working docs (plan_draft/review/final + KO pairs, HANDOFF.md, brainstorm.md). Canonical prompt templates left untouched for v0.2 compatibility. Zero U+00A7 remaining in migrated files; zero double-space artifacts. |
| 2026-04-22 | Session 3 (resumed): **`dev_history.md` backfill complete** — EN + KO pair. Covers sessions 1/2/3 (pre- and post-refill) at stage granularity with per-entry template. Fulfills plan_final AN.3 + partial DC.2. Going forward, append a new entry at every stage close or significant housekeeping step. |
| 2026-04-22 | Session 3 (resumed): **Stage 5 Bundle 4 Technical Design complete** — `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN, 14 sections, ~640 lines) + `technical_design.ko.md` (KO pair, same session per R4). **Sec. 0 locks D4.x2 / D4.x3 / D4.x4** (YAML frontmatter on Stage-5+ docs; `bundle{id}_{name}/` snake_case folder; always-relative-to-current-file links with GitHub anchor slugs) — DEP.1 satisfied, Bundle 1 Stage 5 unblocked. Closes OQ.N1, OQ4.1, OQ4.2, OQ.H2, OQ.L2 Stage-9 half. Acceptance criteria AC.B4.1–16 enumerated. Both files carry YAML frontmatter per D4.x2; KO sync check block ticked (18/18 headers, 16/16 AC items). |
| 2026-04-22 | Session 3 (resumed): **Stage 5 Bundle 1 Technical Design complete** — `docs/03_design/bundle1_tool_picker/technical_design.md` (EN, 14 sections) + `technical_design.ko.md` (KO pair, same session per R4). Sec. 0 quotes Bundle 4 D4.x2/x3/x4 verbatim per DEP.1. Single-file `.skills/tool-picker/SKILL.md` scope (D1.a+D1.b+D1.c in one file ≤ 300 lines) + D1.x `docs/notes/tool_picker_usage.md` reference. Decision table: stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high}. Closes OQ1.1/1.2/1.3. AC.B1.1–10 enumerated; R2 read-only invariant locked as AC.B1.7. YAML frontmatter applied; KO sync check ticked (17/17 headers, 10/10 AC items). **Both bundles' Stage 5 now complete**; Stages 6–7 n/a (has_ui=false); next stage = Stage 8 Codex implementation. |
| 2026-04-22 | Session 3 (resumed, close): **Stage 8 Codex handoff package prepared** — 3 files under `prompts/codex/v03/` (Bundle 4 kickoff, Bundle 1 kickoff, coordination notes) + 1 file under `prompts/claude/v03/` (post-Codex session-4 resume prompt, EN + KO mirror). Run order fixed: Bundle 4 first (owns `docs/notes/decisions.md`), Bundle 1 second with precondition checklist. Claude session 4 starts at Stage 9 code review after Codex completion reports are pasted into the resume prompt. |

---

## Key Document Links

| Document | Stage | Status |
|----------|-------|--------|
| `docs/01_brainstorm/brainstorm.md` | Stage 1 | ✅ Complete (2026-04-22) |
| `docs/02_planning/plan_draft.md` | Stage 2 | ✅ Complete (2026-04-22, session 2) |
| `docs/02_planning/plan_draft.ko.md` | Stage 2 (KO) | ✅ Complete (2026-04-22, session 2) |
| `docs/02_planning/plan_review.md` | Stage 3 | ✅ Complete (2026-04-22, session 3) |
| `docs/02_planning/plan_review.ko.md` | Stage 3 (KO) | ✅ Complete (2026-04-22, session 3) |
| `docs/02_planning/plan_final.md` | Stage 4 | ✅ Complete (2026-04-22, session 3 resumed) |
| `docs/02_planning/plan_final.ko.md` | Stage 4 (KO) | ✅ Complete (2026-04-22, session 3 resumed) |
| `docs/03_design/bundle1_tool_picker/technical_design.md` | Stage 5 | ✅ Complete (2026-04-22, session 3 resumed) — EN + KO pair, AC.B1.1–10 enumerated |
| `docs/03_design/bundle4_doc_discipline/technical_design.md` | Stage 5 | ✅ Complete (2026-04-22, session 3 resumed) — EN + KO pair, D4.x2/x3/x4 locked |
| `docs/04_implementation/implementation_progress.md` | Stage 8–10 | ⬜ Not started |
| `docs/notes/final_validation.md` | Stage 11 | ⬜ Not started (Group 1 joint validation) |
| `docs/05_qa_release/qa_scenarios.md` | Stage 12 | ⬜ Not started |
| `docs/notes/dev_history.md` | All | ✅ Backfilled (2026-04-22, session 3 resumed) — EN + KO pair |
| `prompts/claude/v03_kickoff.md` | Stage 0 | ✅ Reference |

---

## 📋 Next Session Prompt

> Copy and paste this at the start of your next Claude session (session 4, **after Codex has run Stage 8**).
> Full standalone copy also at: `prompts/claude/v03/session4_post_codex_resume_prompt.md` (EN + KO mirror).
>
> Before running this Claude prompt, Hyoungjin runs two Codex jobs:
> 1. Bundle 4 first — prompt at `prompts/codex/v03/stage8_bundle4_codex_kickoff.md`
> 2. Bundle 1 second — prompt at `prompts/codex/v03/stage8_bundle1_codex_kickoff.md`
> 3. Coordination notes (order, single-vs-two-session, failure escalation) — `prompts/codex/v03/stage8_coordination_notes.md`

```
Continue jOneFlow v0.3 (session 4 — post-Codex resumption).

Please read in this order:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md  (in particular Sec. 10 Stages 9, 10, 11, 12, 13)
4. docs/notes/dev_history.md  (latest entries: 3.7, 3.8)
5. docs/03_design/bundle4_doc_discipline/technical_design.md  (AC.B4.1–16 rubric)
6. docs/03_design/bundle1_tool_picker/technical_design.md     (AC.B1.1–10 rubric)
7. docs/04_implementation/implementation_progress.md          (Codex's Stage 8 log — NEW)
8. Whatever Codex created — skim tree with: find .skills CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md templates/ scripts/ docs/notes/decisions.md docs/notes/tool_picker_usage.md docs/notes/tool_picker_usage.ko.md tests/bundle1 tests/bundle4 -maxdepth 3 2>/dev/null

Path: ~/projects/Jonelab_Platform/jOneFlow/

Current status:
- Workflow mode: Strict-hybrid
- Validation group 1 = {Bundle 1 tool-picker, Bundle 4 doc-discipline (option β)}
- Stages 1–5 ✅ complete (EN + KO pairs, YAML frontmatter on Stage-5 docs per D4.x2)
- Stages 6–7 skipped (has_ui=false)
- Stage 8 Codex implementation: SEE CODEX REPORTS BELOW
- has_ui=false, risk_level=medium (Bundle 4) / medium-high (Bundle 1)

=== CODEX STAGE 8 COMPLETION REPORT — BUNDLE 4 ===
[paste Codex's Bundle 4 completion report here, or note "pending" if not yet run]

=== CODEX STAGE 8 COMPLETION REPORT — BUNDLE 1 ===
[paste Codex's Bundle 1 completion report here, or note "pending" if not yet run]

Next task in this session: Stage 9 — Code Review (per bundle, then cross-bundle)

Stage 9 plan:
1. Bundle 4 code review against AC.B4.1–16
   - Headline items: AC.B4.1 (POSIX-sh contract + 6 exit codes), AC.B4.3 (Keep-a-Changelog
     v1.1.0 shape), AC.B4.7 (CONTRIBUTING.md 12-section presence + F-a1 appendix),
     AC.B4.14 (KO freshness bullet), AC.B4.16 (Stage 1–4 frontmatter-free check).
   - Read actual files, run shellcheck output against Sec. 6 error table.
   - Write findings to a Stage-9 section of implementation_progress.md with verdicts
     (PASS / NEEDS REVISION — minor | bug_fix | design_level).
2. Bundle 1 code review against AC.B1.1–10
   - Headline items: AC.B1.7 (R2 read-only invariant grep test), AC.B1.10 (KO pair sync),
     AC.B1.4 (frontmatter mandatory triggers present), AC.B1.3 (≤ 300 lines).
   - Read actual .skills/tool-picker/SKILL.md and tool_picker_usage.{md,ko.md}.
   - If decision-table cell wording needs Claude polish (per Sec. 9-1 of Bundle 1 design),
     do the polish inline as part of Stage 9.
   - Write findings to implementation_progress.md.
3. Write a consolidated Stage 9 verdict per bundle in HANDOFF.md Recent Changes
   (EN + KO mirror) + a dev_history entry (3.9 + 3.10 or merged).

If either bundle's verdict is NEEDS REVISION:
- Trigger Stage 10 (debug) — hand back to Codex with a focused revise prompt
  (prompts/codex/revise.md canonical template; specific findings list from Stage 9).
- Re-enter Stage 9 on the revised output.

Once both bundles are at PASS (Stage 9 + 10 loop closed):
- Stage 11 joint validation is a FRESH SESSION (M.3 invariant). Do NOT run it in
  this same session. At the end of Stage 9/10 close, the operator runs the Stage 11
  prompt at prompts/claude/v03/stage11_joint_validation_prompt.md in a new Claude
  session with only the pre-compacted dossiers (DC.6).

Language policy reminders:
- EN primary + KO translation; KO updated at stage close (R4).
- New documents avoid the U+00A7 section-sign — use literal "Sec. " prefix.
- Stage 5+ docs carry YAML frontmatter (D4.x2). Stage 1–4 docs stay prose-only.

Where should we start? Suggested: begin with Bundle 4 Stage 9 (AC.B4.1 first).
```

---
---

# 📋 HANDOFF — 세션 인계 문서 (한국어)

> **두 번째로 읽는 파일** (CLAUDE.md 다음).
> 매 세션 종료 시 반드시 업데이트하세요.

> ⚠️ **참고 (2026-04-22):** 이 파일은 현재 **jOneFlow v0.3 자기-dogfooding** 상태를
> 추적합니다 (옵션 1). 순수 템플릿 버전은 v0.3 릴리스 시
> `templates/HANDOFF.template.md`로 분리됩니다 (Bundle 4 — Doc discipline 설계 범위).
> 그 전까지 신규 프로젝트는 이 파일을 복사해서 상태 섹션을 수동으로 초기화하세요.

---

## 현재 상태

**현재 버전:** v0.3 (진행 중)
**마지막 업데이트:** 2026-04-22 (세션 3 재개 — Stage 5 양 번들 완료; Stage 8 Codex 핸드오프 패키지 준비; Codex 완료 후 다음 Claude 세션 = Stage 9 코드 리뷰)
**워크플로우 모드:** Strict-hybrid
**현재 단계:** Stage 5 ✅ **양 번들** 완료. Stage 8 Codex **핸드오프 패키지 준비 완료** (`prompts/codex/v03/stage8_bundle4_codex_kickoff.md` + `stage8_bundle1_codex_kickoff.md` + `stage8_coordination_notes.md`); 다음 Claude 세션 재개 프롬프트는 `prompts/claude/v03/session4_post_codex_resume_prompt.md`. **Codex Stage 8 실행 대기 중** (M.1 + DEP.1 에 따라 Bundle 4 먼저, Bundle 1 다음). Stage 6/7 스킵 (`has_ui=false`).
**has_ui:** false
**risk_level:** medium

### ✅ 완료
- [x] 프로젝트 초기화 (폴더, CLAUDE.md, WORKFLOW.md 존재 — v0.2 승계)
- [x] 언어 선택 완료: EN primary + KO translation (`plan_draft.md`부터 적용)
- [x] 보안 설정: v0.2 승계 (v0.3 범위 외)
- [x] Git 초기화 (v0.2 상태 승계)
- [x] **Stage 1 — 브레인스토밍** → `docs/01_brainstorm/brainstorm.md`
- [x] 모드 & 번들 선택: Strict-hybrid, Bundle 1 + Bundle 4
- [x] Validation group 선언: Group 1 = {Bundle 1, Bundle 4}
- [x] **Stage 2 — Plan Draft** → `docs/02_planning/plan_draft.md` (EN) + `plan_draft.ko.md` (KO)
- [x] 언어 정책 최초 적용: EN primary 작성, 같은 세션에 KO 페어 번역 커밋 (plan_draft Sec. 5-2 R4 규칙 준수)
- [x] **Stage 3 — Plan Review** → `docs/02_planning/plan_review.md` (EN) + `plan_review.ko.md` (KO). 판정: 4개 포커스 모두 PASS. plan_final로 8건 개정 포워드. 핵심 발견: **OQ.S11.2 (판정 분기 정책)는 Stage 4로의 진짜 leak** — committed 규칙 M.5로 승격.
- [x] **Stage 4 — Plan Final** → `docs/02_planning/plan_final.md` (EN) + `plan_final.ko.md` (KO). plan_review 개정 8건 전부 흡수. Approval checklist 7/7 ✅. Stage 4.5 제출 준비 완료.
- [x] **Stage 4.5 — 사용자 승인 게이트** ✅ APPROVED (2026-04-22, 세션 3 재개). Bundle 1 + 4 공동 승인 (M.1 충족, 부분 승인 없음). 두 번들 approval_status → approved. Stage 5 차단 해제.
- [x] **Pre-Stage-5 housekeeping (DC.5 + DC.6)** ✅ 완료 — `prompts/claude/v03/`에 3개 드래프트 저장:
  - `stage5_bundle4_design_prompt_draft.md` (DC.5 #1; DEP.1에 따라 Bundle 4 먼저)
  - `stage5_bundle1_design_prompt_draft.md` (DC.5 #2; Bundle 4 Sec. 0 잠금 게이트)
  - `stage11_joint_validation_prompt.md` (DC.6; dossier 기반 컨텍스트 전달 + M.3/M.5/M.6 강제)
- [x] **Stage 5 Bundle 4 — 기술 설계** ✅ 완료 (2026-04-22, 세션 3 재개) — `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN) + `technical_design.ko.md` (KO). Sec. 0 에서 D4.x2/x3/x4 잠금; AC.B4.1–16 수락 기준 열거; 12 섹션 Codex 핸드오프 부록; D4.x2 에 따른 YAML 프론트매터 적용; KO 동기화 체크 완료 (헤더 18/18, AC 16/16). **DEP.1 차단 해제** — Bundle 1 Stage 5 진입 가능.
- [x] **Stage 5 Bundle 1 — 기술 설계** ✅ 완료 (2026-04-22, 세션 3 재개) — `docs/03_design/bundle1_tool_picker/technical_design.md` (EN) + `technical_design.ko.md` (KO). Sec. 0 에서 Bundle 4 D4.x2/x3/x4 를 DEP.1 에 따라 원문 인용. 단일 파일 스킬 설계 (D1.a+D1.b+D1.c 를 한 SKILL.md ≤ 300 줄에) + D1.x `docs/notes/tool_picker_usage.md` 참조. 결정 테이블: stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high}. OQ1.1 (단일 파일), OQ1.2 (두 트리거, 단일 파이프라인), OQ1.3 (네이티브 API 없음) 해결. AC.B1.1–10 열거 (헤드라인: AC.B1.7 R2 읽기 전용 불변식). YAML 프론트매터 + KO 동기화 체크 완료 (헤더 17/17, AC 10/10).
- [x] **Stage 8 Codex 핸드오프 패키지 준비** ✅ (2026-04-22, 세션 3 재개, 세션-종료 housekeeping) — 신규 파일 4개:
  - `prompts/codex/v03/stage8_bundle4_codex_kickoff.md` — M.1 에 따라 Bundle 4 먼저 (Bundle 4 가 `docs/notes/decisions.md` 소유)
  - `prompts/codex/v03/stage8_bundle1_codex_kickoff.md` — Bundle 1 다음; Precondition checklist 로 Bundle 4 완료 게이트
  - `prompts/codex/v03/stage8_coordination_notes.md` — 실행 순서 / 단일-vs-2-세션 / 실패 escalation / 보고 형식
  - `prompts/claude/v03/session4_post_codex_resume_prompt.md` — Codex 작업 이후 Claude 세션 4 재개 프롬프트 (EN + KO 미러), Stage 9 진입

### 🔄 진행 중
- **Codex Stage 8 실행 대기 중** (Claude 세션 외부). Hyoungjin 이 Bundle 4 킥오프 실행 → 완료 보고서 수령 → Bundle 1 킥오프 실행 → 완료 보고서 수령 → 위 재개 프롬프트로 새 Claude 세션 시작. 다음 Claude 세션은 **Stage 9 코드 리뷰** 진입.

### ⏭️ 다음 (세션 3 연속 또는 세션 4)
1. ~~Pre-Stage-5 housekeeping (DC.5 + DC.6)~~ ✅ 완료 (3개 드래프트 저장됨).
2. Stage 5 — 번들별 기술 설계 (DC.5/DC.6 드래프트 존재 ✅ + Stage 4.5 승인 ✅; F-o1로 정밀화된 DEP.1에 따라 Bundle 4 D4.x2–x4 lock 먼저)
3. Backfill: `docs/notes/dev_history.md` 생성 + 세션 1~3 이력 기재 (세션 1부터 미시작)

### 🚧 차단 요인
- 없음. Stage 4.5 승인 획득; housekeeping → Stage 5 흐름 차단 해제.
- Housekeeping 소프트 선결조건: Stage 5 진입 전 DC.5 + DC.6 프롬프트 드래프트 존재 필요 (plan_final Sec. 8-3 AN.1).

---

## 번들 (v0.3 범위)

상단 EN 섹션의 `bundles:` YAML 블록 참조. v0.3는 **Bundle 1 + Bundle 4** 두 개만 다루고,
Bundle 2·3는 v0.4로 이월.

- **Bundle 1** — tool-picker system (goals 7, 11, 12), risk medium-high
- **Bundle 4** — doc discipline (goals 5, 9, 10), risk low-medium
- **Validation Group 1** — {Bundle 1, Bundle 4} 공동 Stage 11 검증

---

## 최근 변경 이력

| 날짜 | 설명 |
|------|------|
| 2026-04-22 | Stage 1 브레인스토밍 완료: 모드 strict-hybrid, 번들 1+4 선택, validation group 1 선언, UI base-only 정책 확정 (v0.5 또는 첫 downstream has_ui=true 중 먼저) |
| 2026-04-22 | HANDOFF.md를 템플릿에서 v0.3 dogfooding 트래커로 전환 (옵션 1); 템플릿 분리는 Bundle 4로 이월 |
| 2026-04-22 | 세션 2: Stage 2 Plan Draft 완료 — `plan_draft.md` (EN) + `plan_draft.ko.md` (KO) 작성. 번들 통합 / kickoff goals·scope_extras 분리 유지 / 번들×스테이지 milestone 매트릭스 / 7개 항목 approval checklist (WORKFLOW Sec. 6 기본 4 + Strict-hybrid 추가 3) 사전 박음. 세션 3에서 Stage 3 재개. |
| 2026-04-22 | 세션 2: 운영 wiki `docs/notes/session_token_economics.md` 추가 — "현재 세션 유지 vs 새 세션 전환" 판단 프레임워크 (living doc). 이번 세션의 76% 사용량 하 실제 판단 사례에서 유도. KO 단독, EN 페어는 OSS 공개 시점에 추가. |
| 2026-04-22 | 세션 3: Stage 3 Plan Review 완료 — `plan_review.md` (EN) + `plan_review.ko.md` (KO). 4개 포커스 모두 PASS. plan_final로 8건 개정 포워드. 핵심 발견: **OQ.S11.2 (판정 분기 정책)는 진짜 Stage-4 leak** — commit된 규칙 M.5로 승격. DC.6 신규(Stage 11 kickoff 프롬프트), DEP.1 순서 표현 정밀화 등 2건의 추적성 업그레이드. UI 사용량 약 95% 시점에 Stage 4 진입 전에 조기 종료; Stage 4 작업은 `plan_review.md Sec. 6`에 사전 스테이징. |
| 2026-04-22 | 세션 3 (토큰 충전 후 재개): Stage 4 Plan Final 완료 — `plan_final.md` (EN) + `plan_final.ko.md` (KO). plan_review 개정 8건 전부 흡수 (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3). Approval checklist 7/7 ✅. Stage 4.5 승인 게이트 사용자에게 제출; 승인 전 Stage 5 차단. |
| 2026-04-22 | 세션 3 (재개): **Stage 4.5 사용자 승인 완료** (Bundle 1 + 4 공동, M.1 충족). 두 번들 `approval_status: approved`. Stage 5 차단 해제. 다음: DC.5 + DC.6 프롬프트 드래프트 → Stage 5 Bundle 4 (DEP.1 정밀화 기준) → Bundle 1. 메모: 신규 문서부터는 가독성을 위해 U+00A7 섹션 기호 사용 중단 (리터럴 "Sec. " 접두어로 대체). |
| 2026-04-22 | 세션 3 (재개): **DC.5 + DC.6 housekeeping 완료**. `prompts/claude/v03/` 하위에 3개 신규 파일: `stage5_bundle4_design_prompt_draft.md`, `stage5_bundle1_design_prompt_draft.md`, `stage11_joint_validation_prompt.md`. Bundle 4 프롬프트는 D4.x2–x4를 Sec. 0 잠금-우선 요구로 고정; Bundle 1 프롬프트는 Bundle 4 Sec. 0 존재를 하드 게이트; Stage 11 프롬프트는 pre-compacted dossier 포맷 확정 (OQ.S11.1 해결). 신규 파일은 U+00A7 사용 안 함. |
| 2026-04-22 | 세션 3 (재개): **`§ → Sec. ` 일괄 마이그레이션** — v0.3 작업 문서 8개 (plan_draft/review/final + KO 페어, HANDOFF.md, brainstorm.md). Canonical 프롬프트 템플릿은 v0.2 호환성 위해 보존. 변환 대상 파일 내 U+00A7 잔존 0건, double-space 아티팩트 0건. |
| 2026-04-22 | 세션 3 (재개): **`dev_history.md` backfill 완료** — EN + KO 페어. 세션 1/2/3 (충전 전후)를 stage 단위로 기록하고 entry 템플릿 포함. plan_final AN.3 + DC.2 부분 충족. 이후부터는 stage 종료 또는 중대 housekeeping 때마다 신규 entry 추가. |
| 2026-04-22 | 세션 3 (재개): **Stage 5 Bundle 4 기술 설계 완료** — `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN, 14 섹션, 약 640 줄) + `technical_design.ko.md` (KO 페어, R4 에 따라 같은 세션). **Sec. 0 에서 D4.x2 / D4.x3 / D4.x4 잠금** (Stage-5+ 문서에 YAML 프론트매터; `bundle{id}_{name}/` snake_case 폴더; 항상 현재 파일 기준 상대경로 + GitHub 앵커 슬러그) — DEP.1 충족, Bundle 1 Stage 5 차단 해제. OQ.N1, OQ4.1, OQ4.2, OQ.H2, OQ.L2 Stage-9 half 해결. 수락 기준 AC.B4.1–16 열거. 양쪽 파일이 D4.x2 에 따른 YAML 프론트매터 소유; KO 동기화 체크 완료 (헤더 18/18, AC 16/16). |
| 2026-04-22 | 세션 3 (재개): **Stage 5 Bundle 1 기술 설계 완료** — `docs/03_design/bundle1_tool_picker/technical_design.md` (EN, 14 섹션) + `technical_design.ko.md` (KO 페어, R4 에 따라 같은 세션). Sec. 0 에서 Bundle 4 D4.x2/x3/x4 를 DEP.1 에 따라 원문 인용. 단일 파일 `.skills/tool-picker/SKILL.md` 범위 (D1.a+D1.b+D1.c 를 한 파일 ≤ 300 줄) + D1.x `docs/notes/tool_picker_usage.md` 참조. 결정 테이블: stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high}. OQ1.1/1.2/1.3 해결. AC.B1.1–10 열거 (헤드라인: AC.B1.7 R2 읽기 전용 불변식). YAML 프론트매터 적용; KO 동기화 체크 완료 (헤더 17/17, AC 10/10). **양 번들 Stage 5 모두 완료**; Stage 6–7 n/a (has_ui=false); 다음 stage = Stage 8 Codex 구현. |
| 2026-04-22 | 세션 3 (재개, 종료): **Stage 8 Codex 핸드오프 패키지 준비** — `prompts/codex/v03/` 하위 3 개 파일 (Bundle 4 킥오프, Bundle 1 킥오프, coordination notes) + `prompts/claude/v03/` 하위 1 개 파일 (Codex 작업 이후 세션-4 재개 프롬프트, EN + KO 미러). 실행 순서 고정: Bundle 4 먼저 (`docs/notes/decisions.md` 소유), Bundle 1 다음 (Precondition checklist 게이트). Codex 완료 보고서를 재개 프롬프트에 붙여넣으면 Claude 세션 4 가 Stage 9 코드 리뷰 진입. |

---

## 주요 문서 링크

| 문서 | 단계 | 상태 |
|------|------|------|
| `docs/01_brainstorm/brainstorm.md` | Stage 1 | ✅ 완료 (2026-04-22) |
| `docs/02_planning/plan_draft.md` | Stage 2 | ✅ 완료 (2026-04-22, 세션 2) |
| `docs/02_planning/plan_draft.ko.md` | Stage 2 (KO) | ✅ 완료 (2026-04-22, 세션 2) |
| `docs/02_planning/plan_review.md` | Stage 3 | ✅ 완료 (2026-04-22, 세션 3) |
| `docs/02_planning/plan_review.ko.md` | Stage 3 (KO) | ✅ 완료 (2026-04-22, 세션 3) |
| `docs/02_planning/plan_final.md` | Stage 4 | ✅ 완료 (2026-04-22, 세션 3 재개) — Stage 4.5 승인 |
| `docs/02_planning/plan_final.ko.md` | Stage 4 (KO) | ✅ 완료 (2026-04-22, 세션 3 재개) — Stage 4.5 승인 |
| `docs/03_design/bundle1_tool_picker/technical_design.md` | Stage 5 | ✅ 완료 (2026-04-22, 세션 3 재개) — EN + KO 페어, AC.B1.1–10 열거 |
| `docs/03_design/bundle4_doc_discipline/technical_design.md` | Stage 5 | ✅ 완료 (2026-04-22, 세션 3 재개) — EN + KO 페어, D4.x2/x3/x4 잠금 |
| `docs/04_implementation/implementation_progress.md` | Stage 8~10 | ⬜ 미시작 |
| `docs/notes/final_validation.md` | Stage 11 | ⬜ 미시작 (Group 1 공동 검증) |
| `docs/05_qa_release/qa_scenarios.md` | Stage 12 | ⬜ 미시작 |
| `docs/notes/dev_history.md` | 전체 | ✅ Backfill 완료 (2026-04-22, 세션 3 재개) — EN + KO 페어 |
| `prompts/claude/v03_kickoff.md` | Stage 0 | ✅ 참조 |

---

## 📋 다음 세션 시작 프롬프트

> 다음 Claude 세션 (세션 4, **Codex Stage 8 실행 이후**) 시작 시 복사해서 붙여넣으세요.
> 독립 파일 사본: `prompts/claude/v03/session4_post_codex_resume_prompt.md` (EN + KO 미러).
>
> 이 Claude 프롬프트를 실행하기 전에 Hyoungjin 이 Codex 작업 2건을 먼저 수행:
> 1. Bundle 4 먼저 — `prompts/codex/v03/stage8_bundle4_codex_kickoff.md`
> 2. Bundle 1 다음 — `prompts/codex/v03/stage8_bundle1_codex_kickoff.md`
> 3. 조정 참고 (순서 / 단일-vs-2-세션 / 실패 escalation) — `prompts/codex/v03/stage8_coordination_notes.md`

```
jOneFlow v0.3 이어서 진행해줘 (세션 4 — Codex 작업 이후 재개).

다음 순서로 먼저 읽어줘:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md  (특히 Sec. 10 Stage 9, 10, 11, 12, 13)
4. docs/notes/dev_history.md  (최신 Entry: 3.7, 3.8)
5. docs/03_design/bundle4_doc_discipline/technical_design.md  (AC.B4.1–16 루브릭)
6. docs/03_design/bundle1_tool_picker/technical_design.md     (AC.B1.1–10 루브릭)
7. docs/04_implementation/implementation_progress.md          (Codex Stage 8 로그 — NEW)
8. Codex 가 생성한 것: 트리 스킴 — find .skills CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md templates/ scripts/ docs/notes/decisions.md docs/notes/tool_picker_usage.md docs/notes/tool_picker_usage.ko.md tests/bundle1 tests/bundle4 -maxdepth 3 2>/dev/null

경로: ~/projects/Jonelab_Platform/jOneFlow/

현재 상태:
- 워크플로우 모드: Strict-hybrid
- Validation group 1 = {Bundle 1 tool-picker, Bundle 4 doc-discipline (옵션 β)}
- Stage 1–5 ✅ 완료 (EN + KO 페어, D4.x2 에 따라 Stage-5 문서에 YAML 프론트매터)
- Stage 6–7 스킵 (has_ui=false)
- Stage 8 Codex 구현: 아래 CODEX 보고서 참조
- has_ui=false, risk_level=medium (Bundle 4) / medium-high (Bundle 1)

=== CODEX STAGE 8 완료 보고서 — BUNDLE 4 ===
[Codex 의 Bundle 4 완료 보고서를 여기 붙여넣기, 또는 미실행이면 "pending"]

=== CODEX STAGE 8 완료 보고서 — BUNDLE 1 ===
[Codex 의 Bundle 1 완료 보고서를 여기 붙여넣기, 또는 미실행이면 "pending"]

이 세션에서 할 작업: Stage 9 — 코드 리뷰 (번들별 → 번들 간 교차)

Stage 9 계획:
1. Bundle 4 코드 리뷰 — AC.B4.1–16 기준
   - 헤드라인: AC.B4.1 (POSIX-sh 계약 + 6 종료 코드), AC.B4.3 (Keep-a-Changelog
     v1.1.0 형태), AC.B4.7 (CONTRIBUTING.md 12 섹션 + F-a1 부록 존재),
     AC.B4.14 (KO 신선도 bullet), AC.B4.16 (Stage 1–4 프론트매터 없음 확인).
   - 실제 파일 읽고, shellcheck 출력을 Sec. 6 오류 테이블과 대조.
   - 판정을 implementation_progress.md 의 Stage-9 섹션에 기록
     (PASS / NEEDS REVISION — minor | bug_fix | design_level).
2. Bundle 1 코드 리뷰 — AC.B1.1–10 기준
   - 헤드라인: AC.B1.7 (R2 읽기 전용 불변식 grep 테스트), AC.B1.10 (KO 페어 동기화),
     AC.B1.4 (프론트매터 필수 트리거 키워드 존재), AC.B1.3 (≤ 300 줄).
   - 실제 .skills/tool-picker/SKILL.md 와 tool_picker_usage.{md,ko.md} 읽기.
   - 결정 테이블 셀 문구가 Claude polish 필요하면 (Bundle 1 설계 Sec. 9-1 에 따라)
     Stage 9 안에서 인라인 polish.
   - 판정을 implementation_progress.md 에 기록.
3. 번들별 Stage 9 최종 판정을 HANDOFF.md 최근 변경 이력 (EN + KO 미러) + dev_history
   Entry (3.9 + 3.10, 또는 병합) 에 기록.

둘 중 하나라도 NEEDS REVISION 이면:
- Stage 10 (debug) 진입 — Codex 에게 focused revise 프롬프트로 되돌려보냄
  (prompts/codex/revise.md 표준 템플릿 + Stage 9 의 구체적 findings 리스트).
- 수정본으로 Stage 9 재진입.

양 번들이 PASS 가 되면 (Stage 9 + 10 루프 종료):
- Stage 11 공동 검증은 **반드시 새 세션** (M.3 불변식). 같은 세션에서 돌리지 말 것.
  Stage 9/10 종료 시 운영자가 prompts/claude/v03/stage11_joint_validation_prompt.md
  프롬프트를 새 Claude 세션에서 실행; DC.6 pre-compacted dossier 만 컨텍스트로 제공.

언어 정책 상기:
- EN primary + KO translation; KO 는 stage 종료 시 업데이트 (R4).
- 신규 문서는 U+00A7 섹션 기호 사용 안 함 — 리터럴 "Sec. " 접두어 사용.
- Stage 5 이후 문서에 YAML 프론트매터 (D4.x2). Stage 1–4 는 prose-only 유지.

어디서부터 시작할까? 권장: Bundle 4 Stage 9 (AC.B4.1 부터).
```
