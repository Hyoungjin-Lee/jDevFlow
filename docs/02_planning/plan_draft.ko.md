# 📐 Stage 2 — 계획 초안 (jOneFlow v0.3)

> **작성일:** 2026-04-22 (세션 2)
> **언어:** KO 번역 (원본: `plan_draft.md` — EN primary, 페어 파일)
> **모드:** Strict-hybrid (상위 Strict + 하위 번들 Standard)
> **상위 문서:** `docs/01_brainstorm/brainstorm.md` (2026-04-22 Addendum 포함)
> **하위 문서:** `plan_review.md` (Stage 3) → `plan_final.md` (Stage 4) → Stage 4.5 사용자 승인 게이트

---

## 0. 본 문서 읽는 법

- Bundle 1 (tool-picker)과 Bundle 4 (doc-discipline)은 **하나의 파일에서 함께 기획**된다. 두 번들은 validation group 1을 공유하며 **Stage 4 승인 게이트를 공동으로 통과**해야 한다.
- **Deliverables** 섹션은 `kickoff goals`와 `scope_extras`(brainstorm Addendum 유래)를 **별도의 두 목록**으로 유지한다. 기계 판독성과 향후 goal 재매핑을 위해 하나로 합치지 않는다.
- **Milestones** 섹션은 `번들 × 스테이지` 매트릭스를 사용하여, 공동 Stage 11 검증이 시각적으로 드러나게 한다.
- 하단 **Approval checklist**는 **초안**이다 — Stage 2에서 의도적으로 미리 채워두고, Stage 3에서 재검토, Stage 4에서 최종 서명한다.

---

## 1. 목표 (Goals)

### 1-1. North Star (brainstorm Sec. 1-4 계승)

> **Jonelab 팀원이 jOneFlow v0.3로 새 백엔드 프로젝트를 혼자 30분 이내에 시작할 수 있다.**

"시작"의 정의 = 템플릿 clone → `CLAUDE.md` / `HANDOFF.md` 편집 → security 셋업 → 첫 커밋 → Stage 1 Brainstorm 진입.

### 1-2. 번들별 목표

**Bundle 1 — Tool-picker 시스템** (`risk_level: medium-high`, kickoff goals 7, 11, 12)

- **G1.1** — 세션의 `stage`, `mode`, `risk_level` 메타데이터를 근거로 다음 단계의 도구/문서/체크리스트를 추천하는 `tool-picker` 스킬을 출시.
- **G1.2** — 추천 표면은 **권고만 (advisory only)** — brainstorm Sec. 7 D-B 기준. 스킬은 절대 사용자 의도를 차단하거나 덮어쓰지 않는다.
- **G1.3** — 추천은 Bundle 4의 확정된 문서 구조(파일명, 헤더, 링크 규칙)를 참조하므로, 추천기는 안정적인 파싱 대상을 가진다.

**Bundle 4 — Doc discipline** (`risk_level: medium`, kickoff goals 5, 9, 10 + brainstorm Sec. 9-2 내부 구조, 옵션 β 하)

- **G4.1** — 깨끗한 **템플릿** 파일을 실제 v0.3 dogfooding 상태로부터 분리 (오래 이월돼 있던 `template_vs_dogfooding_separation`을 이번에 흡수).
- **G4.2** — 최소 수준의 **외부 문서 생명주기** 표면 도입: `HANDOFF.md` auto-writer 스크립트, `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`.
- **G4.3** — **내부 문서 구조** 고정: 헤더 스키마, 번들 폴더 명명, 링크 규칙 — Bundle 1의 스킬이 예측 가능한 표면을 파싱할 수 있도록.

### 1-3. 공동 목표 (cross-bundle)

- **GJ.1** — Bundle 1과 4는 **단일 Stage 11 공동 검증**(validation_group = 1)을 fresh Claude 세션에서 통과한다.
- **GJ.2** — Stage 4.5 사용자 승인은 **두 번들에 대해 한 번에** 부여되거나 거부된다 (v0.3에는 "Bundle 1만 승인, Bundle 4 보류" 경로는 없음 — 세트로 출시).

---

## 2. 비목표 (Non-goals)

brainstorm Sec. 2 (N1–N11) 계승. Stage 2~5에서 바로 참조하도록 여기 재게시.

| # | 비목표 | 영향 번들 |
|---|--------|----------|
| N1 | 전체 UI 워크플로우 | — (정책) |
| N2 | v0.1 프로젝트 자동 마이그레이션 | — |
| N3 | 13단계 재설계 | — |
| N4 | Codex 외 구현 에이전트 지원 | — |
| N5 | 스킬 디스커버리 자동화 (예: `/skills list` UX) | Bundle 1 |
| N6 | 전체 다국어 지원 | — |
| N7 | CI/CD 템플릿 | — (v0.4+ 이월) |
| N8 | Python 외 런타임 지원 | — |
| N9 | 스킬 버전 관리 시스템 | Bundle 1 |
| N10 | 기존 KO 문서 EN 소급 역번역 | Bundle 4 |
| N11 | 복잡한 validation group 처리 (Group 2+ 자동 감지) | — |

### v0.3 고유 비목표 (Stage 2에서 추가)

- **N12** — v0.3에 **link-check 자동화** 없음. Bundle 4는 규칙만 정의하고, 강제 집행 도구는 v0.4 이월.
- **N13** — 메타데이터 기반 **자동 스테이지 skip** 없음. 메타데이터(`has_ui`, `risk_level`)는 *기록*만 되고 Claude가 수동으로 읽는 기존 Strict-hybrid 관행 유지.
- **N14** — **스킬의 Claude Code 네이티브 등록** 변경 없음. Bundle 1 스킬은 CLAUDE.md 읽기 순서에서 참조되는 Markdown 파일이며, v0.3에서는 `.claude/settings.json` 스키마를 건드리지 않는다.

---

## 3. 산출물 (Deliverables)

> **원칙:** kickoff goals와 scope_extras는 **별도 목록**으로 추적한다. `prompts/claude/v03_kickoff.md` 추적성을 유지하고, goal 분할 시 Stage 5 재매핑을 가능하게 한다.

### 3-1. Bundle 1 — Tool-picker

**Kickoff goals (주):**

- **D1.a** (goal 7) — `.skills/tool-picker/SKILL.md` — 스킬 파일 자체, Anthropic SKILL.md 포맷 (YAML frontmatter + 설명 + 지시사항).
- **D1.b** (goal 11) — SKILL.md 내부의 `(stage, mode, risk_level) → 추천 액션 목록` 추천 로직 섹션.
- **D1.c** (goal 12) — Strict-hybrid 모드의 Stage 2 진입 시 스킬 발화를 보여주는 Worked example 블록.

**Scope extras (Bundle 4 의존 해소로부터):**

- **D1.x** — 스킬이 어떻게 호출되는지 문서화하는 짧은 참조 파일 또는 README 포인터 (완전한 discovery 자동화 아님 — N5로 이월).

### 3-2. Bundle 4 — Doc discipline

**Kickoff goals (주):**

- **D4.a** (goal 5) — `scripts/update_handoff.sh` — CLI 플래그로부터 `HANDOFF.md`의 `## Status`와 `## Recent Changes` 섹션을 업데이트하는 idempotent 스크립트.
- **D4.b** (goal 9) — 프로젝트 루트의 `CHANGELOG.md` + `CONTRIBUTING.md`에 명시된 경량 유지 규칙.
- **D4.c** (goal 10) — 기존 catch-all 문서로부터 분리된 `CONTRIBUTING.md` + `CODE_OF_CONDUCT.md`.

**Scope extras (옵션 β, brainstorm Sec. 9-2 + Addendum):**

- **D4.x1** — `templates/HANDOFF.template.md` — `HANDOFF.md`의 깨끗한 템플릿 형태 (이월된 `template_vs_dogfooding_separation` 충족).
- **D4.x2** — 내부 문서 헤더 스키마 결정 (YAML frontmatter vs. comment-header vs. 없음) — `docs/notes/decisions.md`에 문서화.
- **D4.x3** — 번들 폴더 명명 규칙 선택: `bundle1_tool_picker/` | `tool-picker/` | `01_tool_picker/` 중 하나 — 같은 파일에 문서화.
- **D4.x4** — 문서 링크 규칙 (상대경로 규칙, anchor 스타일, 번들 간 링크) — 같은 파일에 문서화.

### 3-3. 번들 간 공통 산출물

- **DC.1** — v0.3 릴리스 상태를 반영한 `HANDOFF.md` 업데이트 (status, bundles, recent changes, next-session prompt).
- **DC.2** — v0.3에서 실행한 모든 단계가 기록된 `docs/notes/dev_history.md` 업데이트.
- **DC.3** — `docs/notes/final_validation.md` — validation group 1 Stage 11 공동 검증 기록.
- **DC.4** — `docs/05_qa_release/qa_scenarios.md` + `release_checklist.md` — Stage 12 산출물.
- **DC.5** — `prompts/claude/v03/stage5_bundle1_design_prompt_draft.md` 및 `.../stage5_bundle4_design_prompt_draft.md` — Stage 5 kickoff 프롬프트 초안 (Stage 5 진입 *전* 저장).

---

## 4. Milestones (번들 × 스테이지 매트릭스)

행 = canonical Strict 순서의 스테이지. 열 = 번들. ✅ = 완료, 🔄 = 이번 세션에서 진행 중, ⬜ = 계획됨.

| Stage | Bundle 1 (tool-picker) | Bundle 4 (doc-discipline) | 공동 |
|-------|------------------------|---------------------------|------|
| 1 Brainstorm | ✅ (2026-04-22) | ✅ (2026-04-22) | ✅ 단일 brainstorm.md |
| 2 Plan Draft | 🔄 (본 파일) | 🔄 (본 파일) | 🔄 공동 plan_draft.md |
| 3 Plan Review | ⬜ | ⬜ | ⬜ 공동 plan_review.md |
| 4 Plan Final | ⬜ | ⬜ | ⬜ 공동 plan_final.md |
| 4.5 승인 게이트 | ⬜ | ⬜ | ⬜ **두 번들에 대한 단일 사용자 결정** |
| 5 기술 설계 | ⬜ 번들별 `bundle1_tool_picker/technical_design.md` | ⬜ 번들별 `bundle4_doc_discipline/technical_design.md` | — |
| 6 UI 요구사항 | 해당 없음 (has_ui=false) | 해당 없음 | 해당 없음 |
| 7 UI 플로우 | 해당 없음 | 해당 없음 | 해당 없음 |
| 8 구현 | ⬜ Codex | ⬜ Codex | — |
| 9 코드 리뷰 | ⬜ Claude (Sonnet) | ⬜ Claude (Sonnet) | — |
| 10 수정 | ⬜ NEEDS REVISION 시 | ⬜ NEEDS REVISION 시 | — |
| 11 최종 검증 | ⬜ | ⬜ | ⬜ **공동 세션, validation_group=1** |
| 12 QA & 릴리스 | ⬜ | ⬜ | ⬜ 공동 qa_scenarios.md |
| 13 배포 & 아카이브 | ⬜ | ⬜ | ⬜ 공동 `v0.3` 태그 |

### 주요 마일스톤 규칙

- **M.1** — Stage 4.5는 두 번들에 대한 단일 승인 (GJ.2). 부분 승인은 v0.3에서 유효한 상태가 아님.
- **M.2** — Stage 5는 번들별 설계 파일로 분기. Stage 5 진입 전에 **설계 프롬프트 초안**을 `prompts/claude/v03/`에 저장 (DC.5). HANDOFF.md에 언급된 "pre-Stage-5 housekeeping".
- **M.3** — Stage 11은 **하나의 공동 fresh 세션**이며, 두 개의 병렬 세션이 아니다. 두 번들의 코드 + 설계 문서를 입력으로 받는다.
- **M.4** — 각 Stage 9 verdict(`minor` / `bug_fix` / `design_level`)는 HANDOFF.md `bundles[i].verdict`에 기록된다. `design_level`만 Stage 4.5 재승인을 강제 (brainstorm Sec. 5 Rule 5 + D-D).

---

## 5. 리스크 & 완화책

### 5-1. Top 3 risks (WORKFLOW.md Stage 4 요구: top-3 각각 완화책)

| # | 리스크 | 가능성 | 영향 | 완화책 | 담당 |
|---|--------|-------|-----|-------|------|
| R1 | Bundle 4 옵션-β scope creep — 내부 구조 결정(D4.x2–x4)이 Bundle 4 내부의 두 번째 mini-project로 확대 | 중 | 높음 | 내부 결정을 **세 개의 yes/no에 가까운 선택**(헤더 스키마, 폴더 명명, 링크 스타일)으로 제한. 각각 근거는 한 단락씩; 선택별 토론 문서를 만들지 **않음**. Stage 3 리뷰에서 강제. | Claude (planner) |
| R2 | Tool-picker 스킬(Bundle 1)이 N5 영역으로 drift — 추천 스킬이 아니라 discovery UX 빌드로 번짐 | 중 | 높음 | Bundle 1 Stage 5 설계 문서는 **스킬 표면을 Claude 기존 스킬 메커니즘이 소비하는 read-only Markdown으로 선언해야 한다**. shell 명령 금지, 인터랙티브 CLI 금지. Stage 9에서 재확인. | Claude (designer) + Claude (reviewer) |
| R3 | Stage 11 공동 검증 익사 — validation group 1이 fresh 세션에서 ~2× 출력량을 짊어지면서 독립 검토 중 context 고갈 위험 | 중~높음 | 중 | Stage 11 전 입력 사전 압축: `technical_design.md` + delta diff + 번들당 1페이지 요약만 fresh 세션에 전달. 전체 소스는 경로 참조로만, 붙여넣지 않음. | Claude (Stage 11 진입 시 QA-orchestrator) |

### 5-2. 부차 리스크 (명시, 가볍게 완화)

| # | 리스크 | 완화책 |
|---|--------|-------|
| R4 | KO 번역이 급한 수정 중 EN primary와 어긋남 | 규칙: KO 업데이트는 **Stage 종료 시**에만, 편집 단위 아님. Stage 3 리뷰가 KO freshness 검사. |
| R5 | `scripts/update_handoff.sh` (D4.a)가 쉘 호환성 고통을 유발 (bash vs. zsh, macOS vs. Linux) | POSIX `sh` 타겟, `shellcheck` 실행, v0.3에서는 macOS만 테스트; Windows/WSL은 미래로 명시. |
| R6 | 번들 폴더 명명(D4.x3)이 기존 `docs/03_design/` 숫자 prefix 스타일과 충돌 | Stage 5 Bundle 4 설계에서 선결: `docs/03_design/` 내부는 `bundle{id}_{name}/`를 사용해 정렬. |
| R7 | `CHANGELOG.md` 유지 규칙(D4.b)이 작성만 되고 v0.3 자체에서 지켜지지 않음 (dogfooding 실패) | CHANGELOG 첫 엔트리는 v0.3 릴리스 자체; 해당 엔트리는 Stage 12 작업으로 생성. |
| R8 | Stage 5 설계 프롬프트 초안(DC.5)이 Stage 5 시작 후에 써져서 목적을 상실 | 하드 사전조건: Stage 5 진입에는 `prompts/claude/v03/`에 두 초안 모두 존재해야 함. HANDOFF.md에 기록. |

### 5-3. P1–P10 재점검 (brainstorm Sec. 7-1)

brainstorm Sec. 7-1이 Stage 1에서 제기한 10개 잠재 충돌. Stage 2에서 어느 것도 blocker가 되지 않았다. Stage 2 시점 판단:

- **P1, P6** (UI 정책 vs. 스킬 동작) — v0.3의 `has_ui=false`로 여전히 처리; 조치 불요.
- **P2, P3, P5, P9** (스키마 / 폴더 / 링크 / 규모 우려) — Bundle 4 D4.x2–x4 + M.3로 처리.
- **P4, P7** (verdict 권한, Codex 타이밍) — M.4 + brainstorm Rule 5로 처리.
- **P8, P10** (Stage 11 context 전달, 이중 언어 파싱) — P8은 R3 완화책으로 흡수; P10은 "스킬은 YAML 헤더 파싱, 본문 산문 파싱 안 함"으로 해결.

Stage 5 기술 설계에서 구체 API / 스키마 제안에 대해 재점검.

---

## 6. 의존성

### 6-1. 내부 (v0.3 내부)

- **DEP.1** — Bundle 1의 SKILL.md는 Bundle 4의 D4.x2–x4 결정이 먼저 잠긴 후(또는 최소한 Bundle 1 Stage 5 시작 전)에 가능. 순서: Bundle 4 Stage 5가 Bundle 1 Stage 5 이전 또는 동시 *시작*, 단 Bundle 4의 구조 결정은 먼저 확정.
- **DEP.2** — `scripts/update_handoff.sh` (D4.a)는 `HANDOFF.md` Status/Recent Changes 섹션의 최종 형태에 의존, 이는 곧 Bundle 4 산출물(D4.x1 템플릿). 해결: `update_handoff.sh`는 현재 dogfooding 형태가 아니라 *템플릿* 형태를 대상으로 작성.
- **DEP.3** — DC.5 (Stage 5 설계 프롬프트)는 Stage 4.5 승인과 본 plan의 최종 형태에 의존. 초안은 Stage 4.5 승인과 Stage 5 진입 **사이에** 작성.

### 6-2. 외부 (v0.3 외부 / 기존)

- **DEP.4** — Anthropic Skills 포맷 (YAML frontmatter 규약) — 안정적으로 간주. v0.3 실행 중 Anthropic이 포맷을 바꾸면 Bundle 1이 비용을 흡수.
- **DEP.5** — v0.2에서 승계된 기존 `security/` 모듈 — 동결로 간주; v0.3 범위에서 변경 없음.
- **DEP.6** — Claude Code 내장 `Skill` tool 동작 — Bundle 1은 CLAUDE.md에서 *참조되는* Markdown 문서로 설계, Claude Code 네이티브 API로 등록하지 않음 (N14) — 커플링 회피.

### 6-3. v0.3 외부에 대해서는 blocking 없음

- **DEP.7** (명시) — v0.4 Bundle 2, 3은 v0.3 Bundle 1에 의존. v0.3는 스킬 파일 구조를 확장 가능하게 남겨두는 것 외에 별도 고려 불요.

---

## 7. Open questions (열린 질문)

brainstorm Sec. 9-1 ~ Sec. 9-6 계승 + 본 plan 작성 중 새로 등장한 것들. Stage 5가 답할 입력; Stage 3 리뷰가 누락 여부를 확인해야 함.

### 7-1. Bundle 1 (tool-picker) — brainstorm Sec. 9-1

- **OQ1.1** — 단일 `SKILL.md` vs. `SKILL.md + rules/*.md`. *성향: v0.3에서는 단일 파일; 규칙 본문이 ~300줄 초과 시에만 분할.*
- **OQ1.2** — 추천 트리거: 스테이지 진입 시 자동, 사용자 요청 시 on-demand, 또는 둘 다. *성향: 둘 다, 단 스테이지 진입은 "채팅에 권고를 출력"하는 방식이지 모달 아님.*
- **OQ1.3** — Claude Code 네이티브 `Skill` tool에 어떻게 바인딩할지. *성향: CLAUDE.md 읽기 순서에서 참조되는 순수 Markdown; 네이티브 등록 없음 (N14).*

### 7-2. Bundle 4 (doc-discipline) — brainstorm Sec. 9-2

- **OQ4.1** — 헤더 메타데이터 스키마: YAML frontmatter vs. Markdown 주석 블록 vs. 없음. *성향: **Stage 5+ 문서에만 YAML frontmatter**. Stage 1–4 문서는 서사형이고 이중언어 헤더가 가독성을 해치므로.*
- **OQ4.2** — 번들 폴더 명명: `bundle{id}_{name}/` vs. `{name}/` vs. `{nn}_{name}/`. *성향: `bundle{id}_{name}/` (HANDOFF bundles[].id와 정렬).*
- **OQ4.3** — Link-check 자동화 범위 내 vs. 이월. *N12로 결정됨: 이월.*

### 7-3. HANDOFF.md 스키마 업그레이드 — brainstorm Sec. 9-3

- **OQ.H1** — `bundles[]` 위치: `## Status` 하위 vs. 독립 `## Bundles`. *현재 HANDOFF.md에 이미 `## Bundles` 섹션 있음 — 유지.*
- **OQ.H2** — v0.1/v0.2 HANDOFF.md 하위호환성. *성향: 자동 마이그레이션 없음 (N2). 수동 마이그레이션 절차를 CONTRIBUTING.md에 문서화.*

### 7-4. Stage 11 독립 검증 — brainstorm Sec. 9-4

- **OQ.S11.1** — 공동 검증 세션이 context를 어떻게 받을지. *성향: DC.5와 같은 타이밍에 `prompts/claude/`에 저장되는 Stage 11 kickoff 프롬프트 템플릿.*
- **OQ.S11.2** — 두 번들의 검증이 갈라지면 (한쪽 APPROVED, 다른 쪽 CHANGES REQUESTED) HANDOFF 상태는 어떻게. *성향: 그룹 verdict = 최악 (CHANGES REQUESTED 승리); Stage 4.5 재승인 규칙은 `design_level`일 때만 발화.*

### 7-5. Codex 위임 — brainstorm Sec. 9-5

- **OQ.C1** — Bundle 1 (SKILL .md 파일)의 Codex 위임 범위. *성향: Codex가 초기 SKILL.md 생성, Claude가 다듬음. v0.4에서 Claude 주도 스킬로 이동 가능.*
- **OQ.C2** — Stage 5 설계 → Codex 프롬프트 매핑. *성향: 각 `technical_design.md` 끝에 복사-붙여넣기 가능한 "Codex handoff" 부록.*

### 7-6. 언어 정책 실행 — brainstorm Sec. 9-6

- **OQ.L1** — 번역 타이밍: 동시 작성 vs. 승인 후. *성향: EN 먼저 초안, KO는 **Stage 종료 시** 번역 (R4 완화책과 일관).*
- **OQ.L2** — "KO 누락" 체크 위치. *성향: Stage 3 plan_review.md 템플릿과 Stage 9 코드 리뷰 체크리스트.*

### 7-7. Stage 2 작성 중 새로 등장한 열린 질문

- **OQ.N1** — `CHANGELOG.md` (D4.b)는 "Keep a Changelog" 규격을 따를지, 커스텀 경량 포맷을 쓸지. *Stage 5 Bundle 4 설계로 이월.*
- **OQ.N2** — `scripts/update_handoff.sh` (D4.a): 파일을 in-place로 변경할지, 먼저 diff 리뷰를 위해 stdout에 출력할지. *성향: dry-run 기본값 + `--write` 플래그 — CLAUDE.md "변경 전 반드시 --dry-run" 준수.*
- **OQ.N3** — `.github/` 디렉터리 (이슈 템플릿, PR 템플릿) — Bundle 4 범위 내 vs. 이월. *성향: v0.4 이월 (옵션 β 범위 외).*

---

## 8. Approval checklist (Stage 4 서명용)

> **초안** — 세션 1 합의에 따라 Stage 2 단계에서 미리 박음. Stage 3에서 재검토, Stage 4에서 채워넣기(✅/❌ + 간단 메모) 후 Stage 4.5 사용자 제출.

### 8-1. WORKFLOW.md Sec. 6 기준 (Stage 4 완료 기준)

- [ ] **AC.1** — In-scope와 out-of-scope가 명확히 분리됨 (Deliverables Sec. 3 vs. Non-goals Sec. 2).
- [ ] **AC.2** — 성공 기준이 측정 가능 (North star "30분 온보딩"은 timed dry-run으로 측정 가능. 번들 산출물은 ID로 열거됨).
- [ ] **AC.3** — Top 3 리스크 각각 완화책과 담당 보유 (Sec. 5-1 R1–R3).
- [ ] **AC.4** — Timeline이 최소 coarse-grained 수준 (Sec. 4 마일스톤 매트릭스; 번들별 세부 시간은 Stage 5).

### 8-2. Strict-hybrid 추가 항목 (v0.3 고유)

- [ ] **AC.5** — Validation group 1 인지: 두 번들은 한 단위로 서명되고, Stage 11은 단일 fresh-session 공동 리뷰.
- [ ] **AC.6** — Bundle 4 옵션-β 범위 명시: kickoff goals 5/9/10 **과** brainstorm Sec. 9-2 내부 구조 항목 **모두** 포함. 리스크 상승(low-medium → medium) 수용.
- [ ] **AC.7** — v0.3 UI base-only 정책 수용: v0.3에는 UI 워크플로우 없음, 그리고 하위 프로젝트의 `has_ui=true` 경고 트리거는 brainstorm Sec. 6에서 계승됨.

### 8-3. Non-blocking notes (게이트 아님, 사용자가 인지)

- **AN.1** — DC.5 (`prompts/claude/v03/`의 Stage 5 설계 프롬프트 초안)는 **Stage 5 진입의 사전조건**이지 Stage 4 게이트가 아님. Stage 4.5 승인 후 Stage 5 kickoff 전에 실행.
- **AN.2** — 열린 질문 Sec. 7은 본 문서가 아니라 Stage 5의 `technical_design.md` 내부에서 답해질 것으로 예상.

---

## 9. 본 plan이 결정하지 **않는** 것 (후속 스테이지로 이월)

plan_draft의 범위를 정직하게 유지하기 위해 (Sec. 2 비목표의 보완):

- `.skills/tool-picker/` 내부 모듈-수준 코드 구조 → **Stage 5 Bundle 1 설계**.
- `scripts/update_handoff.sh` 플래그 표면 → **Stage 5 Bundle 4 설계**.
- Codex 프롬프트 본문 — 그대로 → **Stage 5 설계 부록**.
- Stage 11 kickoff 프롬프트 본문 → **pre-Stage-11 housekeeping** (DC.5의 새로운 대응물).
- QA 시나리오 → **Stage 12**.

---

## 10. 본 문서 변경 이력

| 날짜 | 변경 | 비고 |
|------|------|------|
| 2026-04-22 | v1 — Stage 2 초안 작성 | 세션 2. Bundle 1 + 4 통합. Approval checklist 사전 박음. |

---

## 📌 다음 스테이지

**Stage 3 — 계획 검토** (`docs/02_planning/plan_review.md`).

셀프 리뷰 포커스:
1. Sec. 3 Deliverables가 kickoff goals 5/7/9/10/11/12을 중복 없이 커버하는가?
2. Sec. 5의 top-3 리스크가 진짜 top-3인가 (작성 편의로 고른 것 아닌가)?
3. Sec. 7 열린 질문이 Stage 5 *내부*에서 해결 가능한가, 아니면 Stage 4로 역류하는 게 있는가?
4. Stage 3 시작 시점에 KO 번역(`plan_draft.ko.md`)이 동기화돼 있는가?

---
