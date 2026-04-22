# ✅ Stage 4 — Plan Final (jDevFlow v0.3) (한국어)

> **날짜:** 2026-04-22 (세션 3 → 세션 4 연속)
> **언어:** EN 원본 (한국어 번역: `plan_final.md`의 페어 파일)
> **모드:** Strict-hybrid (상위 Strict + 내부 번들 Standard)
> **상위:** `docs/02_planning/plan_draft.md` (v1, 세션 2) + `plan_review.md` (v1, 세션 3)
> **하위:** Stage 4.5 **사용자 승인 게이트** (Bundle 1 + 4 공동, M.1)
> **상태:** Stage 4.5 제출 준비 완료

---

## 0. KO 동기화 체크 (Stage 3 시작 / Stage 4 시작 시 필수)

`plan_review.md Sec. 4-3`에서 복사. `plan_final.md` (본 문서의 EN 페어)와 대조.

- [x] EN-KO 섹션 헤더 개수 일치
- [x] North-star 문장이 KO에 존재하고 동등
- [x] Deliverable ID (D1.a / D4.a / D4.x1 / DC.1–DC.6)가 양 파일에서 동일
- [x] Approval checklist 항목 수 양 파일에서 동일 (AC.1–AC.7)

---

## 0-1. 본 문서 읽는 법

Plan Final은 Plan Draft를 **대체**한다. `plan_review.md Sec. 6`의 8건 개정을 **흡수**하고, 7개 항목 Approval checklist를 ✅/❌ + 한 줄 메모로 **채우고**, Stage 4.5에 제출되는 **단일 문서**다.

- Bundle 1과 4는 함께 계획된다. validation group 1을 공유하며 **Stage 4.5 승인 게이트도 하나** (부분 승인 없음 — M.1).
- `kickoff goals`와 `scope_extras`(Bundle 4 옵션 β)는 추적성을 위해 Sec. 3에서 두 개의 별도 리스트로 유지.
- Open Questions Sec. 7은 plan_draft 대비 축소: `OQ.S11.2`는 commit 정책(M.5), `OQ.L2` Stage-3 쪽 해결, `OQ.N3`는 N7 서브불릿으로 병합.
- 모든 Stage-3 발견은 `[F-xx]` 태그로 반영 위치 명시.

---

## 0-2. plan_draft → plan_final 변경 요약

| 발견 | 유형 | 위치 | 변경 |
|------|------|------|------|
| F-a1 | 명시 | Sec. 3-2 D4.b / D4.c | `CONTRIBUTING.md`는 D4.c 소유; D4.b는 단일 섹션 기여. |
| F-b2 | 신규 secondary risk | Sec. 5-2 R9 | 공동 승인 커플링 (M.1 증폭기). |
| F-c1 | 신규 deliverable | Sec. 3-3 DC.6 | `prompts/claude/v03/stage11_joint_validation_prompt.md`. |
| F-c2 | commit 정책 | Sec. 4 M.5 | 판정 분기 정책. OQ.S11.2 삭제. |
| F-c3 | OQ 부분 해결 | Sec. 7-6 OQ.L2 | Stage-3 쪽 해결 (Sec. 0 KO 동기화 블록); Stage-9 쪽 유지. |
| F-o1 | 의존성 정밀화 | Sec. 6 DEP.1 | Bundle 4 D4.x2–x4를 Bundle 1 D1.b 전에 lock; 나머지는 병렬. |
| F-o2 | 릴리스 위생 | Sec. 4 M.6 | Stage 13은 단일 공동 `v0.3` git tag 배포. |
| F-o3 | 비목표 정리 | Sec. 2 N7 + Sec. 7-7 | `.github/` PR/issue 템플릿을 N7 서브불릿으로 병합; OQ.N3 삭제. |

---

## 1. 목표 (Goals)

### 1-1. North Star (brainstorm Sec. 1-4 계승, 변경 없음)

> **Jonelab 동료가 jDevFlow v0.3으로 30분 안에 새 백엔드 프로젝트를 혼자 시작할 수 있다.**

"시작" = 템플릿 clone → `CLAUDE.md` / `HANDOFF.md` 편집 → 보안 설정 → 첫 커밋 → Stage 1 브레인스토밍 진입.

### 1-2. 번들별 목표 (plan_draft Sec. 1-2와 동일)

**Bundle 1 — Tool-picker system** (`risk_level: medium-high`, kickoff goals 7, 11, 12)

- **G1.1** — 세션의 `stage`, `mode`, `risk_level` 메타데이터를 기반으로 다음 단계의 툴/문서/체크리스트를 추천하는 `tool-picker` 스킬 배포.
- **G1.2** — 추천 표면은 **자문 전용** (brainstorm Sec. 7의 D-B). 스킬은 사용자 의도를 차단하거나 재작성하지 않는다.
- **G1.3** — 추천은 Bundle 4의 확정된 문서 구조(이름, 헤더, 링크 규칙)를 참조해 추천기가 안정적인 파싱 대상을 갖게 한다.

**Bundle 4 — Doc discipline** (`risk_level: medium`, kickoff goals 5, 9, 10 + brainstorm Sec. 9-2 내부 구조, 옵션 β)

- **G4.1** — 깨끗한 **template** 파일을 live v0.3 dogfooding 상태와 분리.
- **G4.2** — 최소 **외부 문서 라이프사이클** 표면 도입: `HANDOFF.md` 자동 작성 스크립트, `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`.
- **G4.3** — **내부 문서 구조** 고정: 헤더 스키마, 번들 폴더 네이밍, 링크 규칙.

### 1-3. 공동 목표

- **GJ.1** — Bundle 1과 4는 fresh Claude 세션에서 **단일 Stage 11 공동 검증**(validation_group = 1)을 통과한다.
- **GJ.2** — Stage 4.5 사용자 승인은 **양 번들에 함께 부여되거나 함께 거절됨** (M.1).

---

## 2. 비목표 (Non-goals)

brainstorm Sec. 2 계승 (N1–N11) + Stage-2 추가 (N12–N14). F-o3로 기존 OQ.N3 (`.github/`)는 N7로 병합.

| # | 비목표 | 영향 번들 |
|---|--------|-----------|
| N1 | 전체 UI 워크플로우 | — (정책) |
| N2 | v0.1 프로젝트 자동 마이그레이션 | — |
| N3 | 13단계 플로우 재설계 | — |
| N4 | 비 Codex 구현 에이전트 지원 | — |
| N5 | 스킬 discovery 자동화 (예: `/skills list` UX) | Bundle 1 |
| N6 | 전면적 다국어 지원 | — |
| N7 | CI/CD 템플릿 — **`.github/` PR/issue 템플릿 포함** [F-o3] | — (v0.4+ 이월) |
| N8 | 비 Python 런타임 지원 | — |
| N9 | 스킬 버전 관리 시스템 | Bundle 1 |
| N10 | 기존 KO 문서의 EN 역번역 소급 | Bundle 4 |
| N11 | 복잡한 validation group 처리 (Group 2+ 자동 감지) | — |
| N12 | live link-check 자동화 (v0.3은 convention만) | Bundle 4 |
| N13 | 메타데이터 기반 자동 stage skip | — |
| N14 | Skill ↔ Claude Code native 등록 변경 | Bundle 1 |

---

## 3. 산출물 (Deliverables)

> **규칙:** kickoff goals와 scope_extras는 `prompts/claude/v03_kickoff.md` 추적성을 위해 **별도 리스트**로 관리.

### 3-1. Bundle 1 — Tool-picker

**kickoff goals (기본):**

- **D1.a** (goal 7) — `.skills/tool-picker/SKILL.md` — YAML frontmatter + description + instructions, Anthropic Skills 포맷.
- **D1.b** (goal 11) — SKILL.md 내 추천 로직 섹션: `(stage, mode, risk_level) → 추천 액션 리스트`.
- **D1.c** (goal 12) — SKILL.md 내 워크드 예시: Strict-hybrid 모드의 Stage 2 진입에서 스킬이 발화되는 예시.

**Scope extras:**

- **D1.x** — 스킬 호출 방법을 기록하는 짧은 참조/포인터 (discovery 자동화 아님 — N5 이월).

### 3-2. Bundle 4 — Doc discipline

**kickoff goals (기본):**

- **D4.a** (goal 5) — `scripts/update_handoff.sh` — CLI 플래그 기반 HANDOFF.md `## Status` / `## Recent Changes` idempotent 업데이터. `--dry-run` 기본; `--write`로 반영 [OQ.N2 lean].
- **D4.b** (goal 9) — 프로젝트 루트의 `CHANGELOG.md`. **유지 규칙은 `CONTRIBUTING.md` 내부에 단일 섹션(`## Changelog maintenance`)으로 위치** [F-a1]. D4.b는 이 섹션만 기여; 파일 소유권은 D4.c.
- **D4.c** (goal 10) — `CONTRIBUTING.md` + `CODE_OF_CONDUCT.md`. 기존 catch-all 문서에서 분리. **`CONTRIBUTING.md`는 D4.c 소유 파일; Stage 5 Bundle 4 design이 섹션별 소유권 테이블을 명시** [F-a1].

**Scope extras (옵션 β, brainstorm Sec. 9-2 + Addendum):**

- **D4.x1** — `templates/HANDOFF.template.md` — `HANDOFF.md`의 깨끗한 template 형태 (오래된 `template_vs_dogfooding_separation` 해결).
- **D4.x2** — 내부 문서 헤더 스키마 결정 (YAML frontmatter vs. 주석 헤더 vs. 없음) → `docs/notes/decisions.md`.
- **D4.x3** — 번들 폴더 네이밍 (`bundle{id}_{name}/` | `{name}/` | `{nn}_{name}/`) → 같은 곳.
- **D4.x4** — 문서 링크 규칙 (상대경로 규칙, 앵커 스타일, 번들 간 링크) → 같은 곳.

### 3-3. 번들 간 공통 산출물

- **DC.1** — v0.3 릴리스 상태를 반영한 `HANDOFF.md` (status, bundles, recent changes, next-session prompt).
- **DC.2** — v0.3 모든 스테이지 이력이 들어간 `docs/notes/dev_history.md` (파일 자체는 아직 미생성 — 세션 4에서 backfill).
- **DC.3** — `docs/notes/final_validation.md` — validation group 1의 Stage 11 공동 검증 기록.
- **DC.4** — `docs/05_qa_release/qa_scenarios.md` + `release_checklist.md` — Stage 12 산출물.
- **DC.5** — `prompts/claude/v03/stage5_bundle1_design_prompt_draft.md` + `.../stage5_bundle4_design_prompt_draft.md` — Stage 5 kickoff 프롬프트 드래프트 (Stage 5 진입 *전* 저장).
- **DC.6** [F-c1] — `prompts/claude/v03/stage11_joint_validation_prompt.md` — Stage 11 공동 검증 fresh 세션 kickoff 프롬프트. **pre-Stage-11 housekeeping** 중 작성 (DC.5의 새 카운터파트). OQ.S11.1(컨텍스트 전달)에 구체적 안착처 제공.

---

## 4. Milestones (번들 × 스테이지 매트릭스)

행 = canonical Strict 순 스테이지. 열 = 번들. ✅ = 완료, 🔄 = 진행 중, ⬜ = 예정.

| 단계 | Bundle 1 (tool-picker) | Bundle 4 (doc-discipline) | 공동 |
|------|------------------------|---------------------------|------|
| 1 Brainstorm | ✅ (2026-04-22) | ✅ (2026-04-22) | ✅ 단일 brainstorm.md |
| 2 Plan Draft | ✅ (2026-04-22, 세션 2) | ✅ (2026-04-22, 세션 2) | ✅ 공동 plan_draft.md |
| 3 Plan Review | ✅ (2026-04-22, 세션 3) | ✅ (2026-04-22, 세션 3) | ✅ 공동 plan_review.md |
| 4 Plan Final | 🔄 (본 파일) | 🔄 (본 파일) | 🔄 공동 plan_final.md |
| 4.5 Approval gate | ⬜ | ⬜ | ⬜ **양 번들 단일 사용자 결정** |
| 5 Technical Design | ⬜ `bundle1_tool_picker/technical_design.md` | ⬜ `bundle4_doc_discipline/technical_design.md` | — |
| 6 UI Requirements | n/a (has_ui=false) | n/a | n/a |
| 7 UI Flow | n/a | n/a | n/a |
| 8 Implementation | ⬜ Codex | ⬜ Codex | — |
| 9 Code Review | ⬜ Claude (Sonnet) | ⬜ Claude (Sonnet) | — |
| 10 Revision | ⬜ NEEDS REVISION 시 | ⬜ NEEDS REVISION 시 | — |
| 11 Final Validation | ⬜ | ⬜ | ⬜ **공동 fresh 세션, validation_group=1** |
| 12 QA & Release | ⬜ | ⬜ | ⬜ 공동 qa_scenarios.md |
| 13 Deploy & Archive | ⬜ | ⬜ | ⬜ **단일 공동 `v0.3` git tag** [F-o2] |

### 주요 마일스톤 규칙

- **M.1** — Stage 4.5는 양 번들에 대한 단일 승인(GJ.2). v0.3에서 부분 승인은 유효 상태가 아님.
- **M.2** — Stage 5는 번들별 설계 파일로 분할. 진입 전 `prompts/claude/v03/`에 설계 프롬프트 드래프트 저장 (DC.5).
- **M.3** — Stage 11은 **단일 공동 fresh 세션**. DC.6 프롬프트를 통해 양 번들의 코드 + 설계 문서를 입력으로 받음.
- **M.4** — 각 Stage 9 판정(`minor` / `bug_fix` / `design_level`)은 `HANDOFF.md` `bundles[i].verdict`에 기록. `design_level`만 Stage 4.5 재승인 강제 (brainstorm Sec. 5 Rule 5 + D-D).
- **M.5** [F-c2, **commit된 정책 — OQ.S11.2 대체**] — **판정 분기 정책.** 하나의 validation group 내 번들들이 Stage 11 판정에서 분기하면, 그룹 판정은 **둘 중 나쁜 쪽** (`CHANGES REQUESTED`가 `APPROVED`를 이김). Stage 4.5 재승인은 **번들 중 최소 하나의 판정이 `design_level`일 때만** 트리거. 재승인 시 공동 재승인 (M.1 지속 적용). 개별 번들 판정 **과** 그룹 판정 양쪽 모두를 `HANDOFF.md`에 기록.
- **M.6** [F-o2] — Stage 13은 양 번들을 **단일 공동 `v0.3` git tag**로 배포. 번들별 태그 없음.

---

## 5. 리스크 & 완화책

### 5-1. Top 3 리스크 (WORKFLOW.md Stage 4 기준 요건)

| # | 리스크 | Likelihood | Impact | 완화 | 담당 |
|---|--------|-----------|--------|------|------|
| R1 | Bundle 4 옵션-β 스코프 크립 — 내부 구조 결정(D4.x2–x4)이 Bundle 4 내 제2의 미니 프로젝트로 비대화 | medium | high | 내부 결정을 **세 개의 yes/no성 선택**(헤더 스키마, 폴더 네이밍, 링크 스타일)으로 제한. 선택별 근거는 한 문단씩; 선택별 논의 문서 금지. Stage 3 review에서 강제(PASS ✅), Stage 5 Bundle 4 진입 시 재점검. | Claude (planner / designer) |
| R2 | Tool-picker 스킬(Bundle 1)이 N5 영역으로 표류 — 추천 스킬이 아니라 discovery UX를 짓기 시작 | medium | high | Stage 5 Bundle 1 설계가 **스킬의 표면을 Claude 기존 스킬 메커니즘이 소비하는 read-only Markdown**으로 선언 **필수**. 셸 명령 없음, 상호작용 CLI 없음. Stage 9 재점검. | Claude (designer) + Claude (reviewer) |
| R3 | Stage 11 공동 검증 익사 — validation group 1의 출력 부피가 약 2배. fresh 세션에서 컨텍스트 고갈 위험 | medium-high | medium | Stage 11 진입 전 입력 pre-compact: `technical_design.md` + 델타 diff + 번들별 1페이지 요약. 원본 코드는 참조 경로, 붙여넣기 금지. DC.6 프롬프트가 이 포맷을 강제. | Claude (QA-orchestrator at Stage 11 entry) |

### 5-2. Secondary risks

| # | 리스크 | 완화 |
|---|--------|------|
| R4 | 빠른 편집 중 KO 번역이 EN 원본과 벌어짐 | KO 업데이트는 stage close 시점(편집마다 X). Stage 3 / Stage 4 KO 동기화 체크(Sec. 0 블록)로 검증. OQ.L2 Stage-9 쪽은 code-review 체크리스트에 추가(Bundle 4 tech design). |
| R5 | `scripts/update_handoff.sh` (D4.a)가 셸 호환성 통증 유발 (bash vs zsh, macOS vs Linux) | POSIX `sh` 타깃, `shellcheck` 실행, v0.3는 macOS만; Windows/WSL은 future. |
| R6 | 번들 폴더 네이밍(D4.x3)이 `docs/03_design/` 숫자 prefix 스타일과 충돌 | Stage 5 Bundle 4 설계에서 사전 결정: `docs/03_design/` 내부에는 `bundle{id}_{name}/` 사용해 정렬. |
| R7 | `CHANGELOG.md` 유지 규칙(D4.b)은 쓰이지만 v0.3 자체에서 따르지 않음 (dogfooding 실패) | 첫 CHANGELOG 항목은 v0.3 릴리스 그 자체, Stage 12에서 생성. |
| R8 | Stage 5 설계 프롬프트 드래프트(DC.5)가 Stage 5 시작 *후*에 작성돼 목적 상실 | Hard pre-condition: Stage 5 진입에는 DC.5 드래프트 둘 **과** DC.6가 `prompts/claude/v03/`에 존재해야 함. HANDOFF.md에 체크 기록. |
| R9 [F-b2] | **공동 승인 커플링(M.1 증폭기)** — 어느 한 번들의 중대 이슈가 다른 번들의 shipment를 차단 | Stage 9에서 한 번들이 `design_level`, 다른 번들이 `minor`면 공동 규칙에 따라 **양쪽 모두** Stage 4.5 재승인 트리거 (M.5 로직). 개별 번들 verdict + 그룹 verdict 모두 `HANDOFF.md bundles[].verdict`에 명시 기록. 완화는 프로세스 위생이지 설계 변경 아님: 세션 계획 시 버퍼 확보. |

### 5-3. P1–P10 재점검 (brainstorm Sec. 7-1, plan_draft Sec. 5-3 계승)

계획 단계에서 차단 요인 된 것 없음. Stage 2 → Stage 3 관점 유지:

- **P1, P6** (UI 정책 vs 스킬 행동) — `has_ui=false` 정책. 조치 없음.
- **P2, P3, P5, P9** (스키마 / 폴더 / 링크 / 스케일) — D4.x2–x4 + M.3 + M.5로 대응.
- **P4, P7** (판정 권한, Codex 타이밍) — M.4 + M.5 + brainstorm Rule 5로 대응.
- **P8, P10** (Stage 11 컨텍스트 전달, 이중 언어 파싱) — P8은 R3 완화 + DC.6로 흡수; P10은 "스킬은 YAML 헤더를 읽지 본문 산문을 읽지 않는다"로 정리.

Stage 5 기술 설계가 구체적 API / 스키마 제안에 대해 재점검.

---

## 6. 의존성

### 6-1. 내부 (v0.3 내부)

- **DEP.1** [F-o1, **정밀화**] — **Bundle 4 Stage 5의 구조적 결정(D4.x2–x4)은 Bundle 1 Stage 5의 추천 로직 섹션(D1.b) 작성 전에 lock.** 그 외 Bundle 4 · Bundle 1 tech design은 병렬 진행 가능. 즉 Stage 5 Bundle 4의 첫 산출물은 이 세 개의 결정(한 문단씩), 그 다음 Bundle 4 tech design 나머지와 Bundle 1 tech design 전체가 병렬 실행 가능.
- **DEP.2** — `scripts/update_handoff.sh` (D4.a)는 `HANDOFF.md`의 Status/Recent Changes 섹션 최종 형태에 의존하며, 이 자체가 Bundle 4 deliverable(D4.x1 template). 해결: `update_handoff.sh`를 현재 dogfooding 형태가 아니라 *template* 형태 기준으로 작성.
- **DEP.3** — DC.5 + DC.6 (Stage 5 프롬프트 + Stage 11 공동 검증 프롬프트)는 Stage 4.5 승인과 본 계획 최종 형태 양쪽에 의존. DC.5는 Stage 4.5 승인과 Stage 5 진입 사이에, DC.6는 Stage 11 진입 전에 작성.

### 6-2. 외부 (v0.3 외부 / 기존)

- **DEP.4** — Anthropic Skills 포맷(YAML frontmatter 관례) — stable. v0.3 실행 중 Anthropic이 포맷을 변경하면 Bundle 1이 비용 흡수.
- **DEP.5** — v0.2 계승 `security/` 모듈 — frozen. v0.3 범위 내 변경 없음.
- **DEP.6** — Claude Code 내장 `Skill` 툴 동작 — Bundle 1은 native API로 등록하지 않고 CLAUDE.md에서 *참조*되는 Markdown (N14).

### 6-3. v0.3 외부에 대한 blocking 없음

- **DEP.7** — v0.4 Bundles 2·3이 v0.3 Bundle 1에 의존. v0.3는 스킬 파일 구조를 확장 가능하게 두는 것 이상으로는 고려할 필요 없음.

---

## 7. 열린 질문 (Open questions — 잔여)

plan_draft Sec. 7에서 축소. 제거/해결: **OQ.S11.2** (→ M.5로 commit, F-c2), **OQ.L2 Stage-3 쪽** (Sec. 0 KO 동기화 블록, F-c3), **OQ.N3** (N7로 병합, F-o3).

### 7-1. Bundle 1 (tool-picker)

- **OQ1.1** — 단일 `SKILL.md` vs. `SKILL.md + rules/*.md`. *Lean: 단일 파일; 규칙 본문이 ~300줄 초과 시에만 분할.*
- **OQ1.2** — 추천 트리거: stage-entry 자동 / 사용자 요청 on-demand / 둘 다. *Lean: 둘 다; stage-entry는 chat에 advisory 출력, 모달 아님.*
- **OQ1.3** — Claude Code native `Skill` 툴에 바인딩? *Lean: CLAUDE.md read-order에서 참조되는 순수 Markdown; native 등록 없음 (N14).*

### 7-2. Bundle 4 (doc-discipline)

- **OQ4.1** — 헤더 메타데이터 스키마: YAML frontmatter vs. Markdown 주석 vs. 없음. *Lean: **Stage 5+ 문서에만 YAML frontmatter**; Stage 1–4의 서술형/이중 언어 문서는 frontmatter 없음.*
- **OQ4.2** — 번들 폴더 네이밍. *Lean: `bundle{id}_{name}/` (`HANDOFF bundles[].id`와 매칭).*

### 7-3. HANDOFF.md 스키마 업그레이드

- **OQ.H1** — `bundles[]` 위치. *이미 해결: 현재 HANDOFF.md의 `## Bundles` 섹션 유지.*
- **OQ.H2** — v0.1/v0.2 HANDOFF.md 하위 호환. *Lean: 자동 마이그레이션 없음 (N2); `CONTRIBUTING.md`에 수동 마이그레이션 절차.*

### 7-4. Stage 11 독립 검증

- **OQ.S11.1** — 공동 검증 세션이 컨텍스트를 어떻게 받는가. *Lean: DC.6 프롬프트 템플릿이 인코딩 — technical_design.md + 델타 diff + 번들별 1페이지 요약 + 참조 경로 (원본 붙여넣기 금지). DC.6 자체가 답.*
- ~~OQ.S11.2~~ — **M.5로 commit; Sec. 4 참조.**

### 7-5. Codex 위임

- **OQ.C1** — Bundle 1 Codex 위임 범위. *Lean: Codex가 초기 SKILL.md 생성, Claude가 다듬음.*
- **OQ.C2** — Stage 5 설계 → Codex 프롬프트 매핑. *Lean: 각 `technical_design.md` 끝에 copy-paste-ready "Codex handoff" appendix.*

### 7-6. 언어 정책 실행

- **OQ.L1** — 번역 타이밍. *Lean: EN 먼저 작성, KO는 Stage close 시 번역 (R4 규칙).*
- **OQ.L2** — "KO 누락" 체크 위치. *Stage-3 쪽은 Sec. 0 KO 동기화 블록으로 **해결** [F-c3]. Stage-9 쪽: Bundle 4 tech design이 code-review 체크리스트에 "stage-closing 문서의 KO freshness" 추가.*

### 7-7. Stage 2 작성 중 새로 등장한 열린 질문

- **OQ.N1** — `CHANGELOG.md` 스펙 — "Keep a Changelog" vs 커스텀. *Stage 5 Bundle 4 design으로 이월.*
- **OQ.N2** — `scripts/update_handoff.sh` 기본 모드. *Sec. 3-2 D4.a에서 해결: dry-run 기본 + `--write` 플래그.*
- ~~OQ.N3~~ — **F-o3로 N7(Sec. 2)에 병합.**

---

## 8. Approval checklist (Stage 4 → Stage 4.5)

### 8-1. WORKFLOW.md Sec. 6 기본 (Stage 4 완료 기준)

- [x] **AC.1** — In-scope / out-of-scope가 명확히 분리. ✅ *Deliverables Sec. 3 (D1.a–D1.c, D1.x, D4.a–D4.c, D4.x1–x4, DC.1–DC.6) vs Non-goals Sec. 2 (N1–N14); 겹침 없음.*
- [x] **AC.2** — 성공 기준이 측정 가능, 열망형이 아님. ✅ *North-star는 타임드 dry-run (30분); deliverable ID 열거; milestone은 번들 × 스테이지 매트릭스.*
- [x] **AC.3** — Top 3 리스크 각각 완화 담당자. ✅ *R1 (planner/designer), R2 (designer + reviewer), R3 (QA-orchestrator); 의도가 아닌 구체적 완화.*
- [x] **AC.4** — 타임라인이 최소한 coarse-grained. ✅ *Milestone 매트릭스가 스테이지 수준 순서 제공; 스테이지 내부 상세 시간은 Stage 5 tech design.*

### 8-2. Strict-hybrid 추가 항목 (v0.3 고유)

- [x] **AC.5** — Validation group 1 인지: 양 번들 한 단위 sign-off; Stage 11 = 단일 fresh-session 공동 검증. ✅ *GJ.1, M.3, M.5, DC.6로 코드화.*
- [x] **AC.6** — Bundle 4 옵션-β 범위 명시: kickoff goals 5/9/10 **과** brainstorm Sec. 9-2 내부 구조 항목 모두 범위 내; 리스크 범프(low-medium → medium) 수용. ✅ *Sec. 3-2 scope extras D4.x1–x4; risk_level=medium은 HANDOFF.md에 기록.*
- [x] **AC.7** — v0.3 UI base-only 정책 수용: v0.3에는 UI 워크플로우 없음; downstream 프로젝트가 `has_ui=true`가 되면 warning 트리거 (brainstorm Sec. 6 계승). ✅ *전체에 걸쳐 `has_ui=false`; N1 + N13 + N14로 정책 lock.*

### 8-3. Non-blocking notes (게이트 아님, 사용자 인지)

- **AN.1** — DC.5 + DC.6 (`prompts/claude/v03/`의 프롬프트)는 **Stage 5 / Stage 11 진입의 선행 조건**이지 Stage 4 게이트 아님. DC.5는 Stage 4.5 승인 후 Stage 5 kickoff 전; DC.6는 Stage 11 전.
- **AN.2** — 잔여 Open Questions (Sec. 7)은 Stage 5의 `technical_design.md`에서 답함 (Sec. 7 본문에 resolved/lean으로 표시된 건 제외).
- **AN.3** — `docs/notes/dev_history.md`는 여전히 미생성(세션 1부터 이월). 세션 4에서 본 Stage 4 작업과 함께 backfill 예정.

**체크리스트 판정: 7 / 7 ✅. Stage 4.5 제출 준비 완료.**

---

## 9. 본 plan이 결정하지 **않는** 것 (후속 스테이지로 이월)

- `.skills/tool-picker/` 내부 모듈 수준 구조 → **Stage 5 Bundle 1 design**.
- `scripts/update_handoff.sh` 플래그 표면 (dry-run / --write 기본 초과 부분) → **Stage 5 Bundle 4 design**.
- Codex 프롬프트 verbatim → **Stage 5 design appendices**.
- Stage 11 kickoff 프롬프트 본문 → **pre-Stage-11 housekeeping (DC.6)**.
- QA 시나리오 → **Stage 12**.
- OQ.L2 Stage-9 쪽 (code-review 체크리스트의 KO freshness) → **Stage 5 Bundle 4 design**.

---

## 10. 본 문서 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-22 | v1 — Stage 4 plan_final 작성 | 세션 3 → 4 연속. 8건의 plan_review 개정 흡수 (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3). Approval checklist 기재 (7/7 ✅). |

---

## 📌 다음 스테이지

**Stage 4.5 — 사용자 승인 게이트** (Bundle 1 + 4 공동, M.1).

본 문서를 사용자에게 제시. AC.1–AC.7 및 AN.1–AN.3를 참조해 명시적 승인을 요청. 승인 시 pre-Stage-5 housekeeping(DC.5 + DC.6 드래프트)으로 진행 후 번들별 Stage 5 Technical Design. 거절 시 Stage 2로 복귀 (방향 자체가 틀리면 Stage 1), WORKFLOW.md Sec. 7.1에 따름.

---
