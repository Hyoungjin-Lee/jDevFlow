# 🔄 jOneFlow — AI 기반 개발 워크플로우 아키텍처

> **버전:** 2.1
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

**Standard**를 쓸 때:
- 기능 추가, 모듈 리팩토링, 외부 서비스 연동
- 두 개 이상의 파일 또는 서브시스템이 관련됨
- 평소 개발 작업의 기본값

**Strict**를 쓸 때:
- 아키텍처, 보안, 인증, 데이터 스키마, 결제에 영향
- 롤백이 어려움 / 규제·컴플라이언스·감사 대상

**애매할 때**: 더 무거운 모드를 고른다.

### 2.3 모드별 스테이지 커버리지

| 단계 | Stage type | Lite | Standard | Strict |
|------|-----------|------|----------|--------|
| 1 Brainstorm | ideation | 생략 | 간단 수행 | 수행 |
| 2 Plan Draft | planning | 생략 | 생략 (→ plan_final 직행) | 선택 |
| 3 Plan Review | planning | 생략 | 생략 | 생략 |
| 4 Plan Final | planning | 최소 노트 | 수행 | 수행 |
| 4.5 Approval | approval_gate | 선택 | 수행 | 더 엄격 |
| 5 Technical Design | design | 생략/인라인 | 수행 | 수행 |
| 6 UI Requirements | design | 생략 | `has_ui`면 수행 | `has_ui`면 수행 |
| 7 UI Flow | design | 생략 | `has_ui`면 수행 | `has_ui`면 수행 |
| 8 Implementation | implementation | 수행 | 수행 | 수행 |
| 9 Code Review | review | 경량 | 수행 | 수행 |
| 10 Revision | implementation | 리뷰 실패 시 | 리뷰 실패 시 | 리뷰 실패 시 |
| 11 Final Validation | validation | 생략 | 생략 (고위험 아니면) | 고위험 한정 (동일 세션 가능) |
| 12 QA & Release | qa_release | 체크리스트만 | 수행 | 수행 |
| 13 Deploy & Archive | archive | 수행 (단순) | 수행 | 수행 |

---

## 3. Canonical Strict Flow — 13단계

모든 작업의 기본값이 아니라, **템플릿에서 규율의 상한선**이다.

| # | 단계 | Type | 담당 | 모델 | Effort | 입력 | 산출물 | 예상 시간 |
|---|------|------|------|------|--------|------|--------|----------|
| 1 | **아이디어 구상** ⚠️ | ideation | Claude + 사용자 | Sonnet | Medium | 사용자 요청 | `docs/01_brainstorm/brainstorm.md` | 15~30분 |
| 2 | **계획 초안** | planning | Claude | Opus | Medium | 구상 결과 | `docs/02_planning/plan_draft.md` | 15~30분 |
| 3 | **계획 검토** | planning | Claude | Opus | High | 계획 초안 | `docs/02_planning/plan_review.md` | 10~20분 |
| 4 | **계획 통합** ⚠️ | planning | Claude | Opus | Medium | 초안 + 검토 | `docs/02_planning/plan_final.md` | 10~15분 |
| 4.5 | **사용자 승인** 🔴 | approval_gate | 사용자 | — | — | plan_final.md | 승인 확인 | — |
| 5 | **기술 설계** | design | Claude | Opus | High | 승인된 계획 | `docs/03_design/technical_design.md` | 30~60분 |
| 6 | **UI 요구사항** *(`has_ui`)* | design | Claude | Sonnet | Medium | 기술 설계 | `docs/03_design/ui_requirements.md` | 15~30분 |
| 7 | **UI 플로우** *(`has_ui`)* | design | Claude | Sonnet | Medium | UI 요구사항 | `docs/03_design/ui_flow.md` | 20~40분 |
| 8 | **구현** | implementation | Codex | — | High | 기술 설계 | 코드 + 테스트 + 커밋 | 1~8시간 |
| 9 | **코드 리뷰** | review | Claude | Opus | High | Codex 결과 | `docs/04_implementation/implementation_progress.md` | 15~30분 |
| 10 | **수정** | implementation | Codex | — | Medium | 리뷰 피드백 | 수정된 코드 | 30분~2시간 |
| 11 | **최종 검증** *(고위험 한정)* | validation | Claude | Opus | High* | 수정된 코드 | `docs/notes/final_validation.md` | 30분~1시간 |
| 12 | **QA & 릴리스** | qa_release | Claude | Sonnet | Medium | 검증된 코드 | `docs/05_qa_release/qa_scenarios.md` | 15~30분 |
| 13 | **배포 & 아카이브** | archive | Codex | — | Medium | QA 승인 | 병합 + HANDOFF 업데이트 | 가변 |

`*` Stage 11은 고위험 작업(Strict)에만 실행. 동일 세션 허용. 보안/결제/불가역 변경은 XHigh.

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

---

## 6. 완료 기준 요약

핵심 기준:
- **Stage 1**: 문제/비목표/mode/has_ui/risk_level 기록, 사용자 합의
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
| Stage 11 = CHANGES REQUESTED (설계 수준) | Claude 설계 수정 | 5 → 8 |
| Stage 4.5 = 승인 거절 | 재기획 | 2 (방향 자체가 틀리면 1) |
| Stage 12 QA 실패 | 수정 후 재검증 | 10 → 9 → 12 |
| 배포 후 인시던트 | 새 Lite 작업 | 8 (Lite) |

**원칙:**
- 롤백은 문서를 **지우지 않는다**. 새 revision 섹션을 덧붙인다.
- 모든 롤백은 `HANDOFF.md` + `CHANGELOG.md`에 기록.
- 같은 루프가 3회 반복되면 멈추고 Strict로 승격. 반복 루프는 보통 설계 문제의 신호다.

---

## 8. 운영 컨텍스트

### 8.1 기능 개발 (Standard 또는 Strict)
신기능, 리팩토링, 외부 연동, 아키텍처 변경.
**트리거 문구:** "X 기능 구현", "Y 모듈 리팩토링"

### 8.2 Lite / 핫픽스
운영 긴급 수정 (Stage 8 → 9(경량) → 13 직결), 설정/문서 수정.
**트리거 문구:** "버그 수정", "설정 변경", "버전 올림"

### 8.3 모드 전환 규칙
세션 시작 시 `HANDOFF.md`에서:
- 모드가 기록돼 있으면 그걸 사용
- "all systems nominal" → Stage 1에서 사용자와 모드 합의
- "빨리 하나만 고쳐줘" → Lite 모드를 소리내어 확인 후 진행

---

## 9. 모델 및 effort 전략

### 모델 선택 가이드

| 작업 유형 | 모델 | 이유 |
|-----------|------|------|
| Stage 1 브레인스토밍 | **Sonnet** | 방향 대화 — 빠른 iteration이 중요 |
| Stage 2–4 기획 | **Opus** | 계획 오류가 구현 전체를 망가뜨림 |
| Stage 5 기술 설계 | **Opus** | 아키텍처 결정 — 최고 추론 필요 |
| Stage 6–7 UI/UX | **Sonnet** | 반복 속도 우선 |
| Stage 9 코드 리뷰 | **Opus** | 깊은 리뷰 누락 시 Stage 10 재작업 비용 큼 |
| Stage 11 최종 검증 | **Opus** | 고위험 작업 전용 |
| Stage 12–13 QA/릴리스 | **Sonnet** | 체크리스트 수준 |
| 구현 | **Codex** | 전문 코딩 환경 |

> **Cowork 세션:** 모델은 세션 시작 시에만 선택 가능. Stage 1 → Sonnet, Stage 2+ → Opus로 새 세션 시작.
> HANDOFF.md 다음 세션 프롬프트에 권장 모델 명시됨.

### Effort 결정 트리

```
보안/결제/불가역 운영 변경?
├─ YES → XHigh (Stage 11 Strict)
└─ NO
   ├─ 핵심 아키텍처 또는 다중 시스템 영향?
   │  ├─ YES → High
   │  └─ NO
   │     ├─ 신기능 또는 주요 리팩토링?
   │     │  ├─ YES → Medium(기획) → High(리뷰)
   │     │  └─ NO → Medium 또는 Low
   │     └─ 문서/요약?
   │        └─ YES → Low 또는 Medium
```

---

## 10. 에이전트 구성

| 에이전트 | 담당 Stage | 모델 | Effort |
|---------|-----------|------|--------|
| 🧠 Planner | 1, 2, 3, 4 | Sonnet (Stage 1) / Opus (Stage 2–4) | Medium–High |
| 🏗️ Designer | 5, 6, 7 | Opus (Stage 5) / Sonnet (6–7) | Medium–High |
| 🔍 Reviewer | 9, 11 | Opus | High–XHigh |
| 🧪 QA Engineer | 12, 13 | Sonnet | Medium |
| ⚙️ Codex (외부) | 8, 10 | — | — |

**설계 원칙:**
1. **Designer ≠ Reviewer** — 설계한 에이전트가 서명 금지 (확증 편향).
2. **Stage 1 = Sonnet** — 브레인스토밍은 방향 대화. 빠른 iteration이 깊은 추론보다 중요.
3. **Stage 2–4, 9, 11 = Opus** — 계획 오류와 리뷰 누락은 하류 비용이 크다.
4. **Codex는 도구** — 에이전트 구성에서 제외. Stage 8, 10은 Codex 전용.

**Lite 에이전트 구성:**
```
⚙️ Codex  →  🔍 Reviewer (경량)  →  🧪 QA Engineer (체크리스트만)
```

---

## 11. 세션 핸드오프

**읽기 순서 (매 세션):** CLAUDE.md → HANDOFF.md → WORKFLOW.md → 관련 docs/

**쓰기 순서 (세션 종료):**
1. 현재 단계 문서 업데이트
2. `HANDOFF.md` 업데이트 (모드, 상태, 다음 작업, 문서 링크)
3. `CHANGELOG.md` `[Unreleased]` 갱신
4. 다음 세션 프롬프트를 HANDOFF.md 📋 섹션에 기록 (권장 모델 포함)

---

## 12. Claude Code CLI 단축 명령어

| 명령어 | Stage | 설명 |
|--------|-------|------|
| `aib` | 1 | 브레인스토밍 (Sonnet) |
| `aipd` | 2 | 계획 초안 (Opus) |
| `aipr` | 3 | 계획 검토 (Opus) |
| `aipf` | 4 | 계획 통합 (Opus) |
| `aitd` | 5 | 기술 설계 (Opus) |
| `aiui` | 6 | UI 요구사항 (Sonnet) |
| `aiuf` | 7 | UI 플로우 (Sonnet) |
| `aicr` | 9 | 코드 리뷰 (Opus) |
| `aifv` | 11 | 최종 검증 (Opus) |
| `aiqa` | 12 | QA & 릴리스 (Sonnet) |

---

*이 워크플로우는 살아있는 문서입니다.*
