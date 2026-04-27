# 컨텍스트 로딩 가이드 (Stage별 선별 로드)

> **목적:** 각 세션/stage 진입 시 필독 문서를 stage별로 선별 제시. MD 파일 경량화 정책.
> **버전:** v0.6.5+ (context engineering phase)

---

## 1. R2 진입 순서 (모든 세션 필수)

모든 Claude Code 세션은 다음 순서로 읽기. **순서 변경 금지** (jOneFlow 컨벤션 학습 오류).

```
1. CLAUDE.md (~85줄)                     [프로젝트 절대 규칙 + 포인터]
         ↓
2. docs/bridge_protocol.md (~340줄)      [회의창 ↔ 브릿지 ↔ 오케 통신 + 사고 사례]
         ↓
3. docs/operating_manual.md (~362줄)     [5계층 조직도 + 16-stage 워크플로 + 모델 정책]
         ↓
4. handoffs/active/HANDOFF_v<X>.md       [현재 진행 상태 + 결정 사항]
```

**읽기 시간 목표:** 총 15~20분 (모든 문서 포함).

---

## 2. Stage별 추가 로드 (역할별)

R2 완료 후, 본인 역할/stage에 맞는 문서만 로드.

### 2.1 회의창 역할 (박지영 CTO 실장)

**필독:**
- `docs/bridge_protocol.md` Sec.1~4 (회의창 본분 + 금지 행위)
- `docs/bridge_protocol.md` Sec.8 (자가 점검 11항목)
- `HANDOFF_v<X>.md` Sec.2 (현재 의제 + 결정 사항)

**dispatch 작성 시점:**
- `docs/operating_manual.md` Sec.1.2 (18명 페르소나 + 역할)
- `docs/operating_manual.md` Sec.2 (모드 정의)
- `docs/bridge_protocol.md` Sec.4 (환경/도구 표준 + A 패턴)

---

### 2.2 오케스트레이터 역할 (팀장 PL)

**필독:**
- `docs/operating_manual.md` Sec.5 (Stage 플로우 + 모드별 압축)
- `docs/operating_manual.md` Sec.3 (모델 정책)
- `docs/bridge_protocol.md` Sec.6~7 (사고 사례 + Monitor 패턴)

**dispatch 수신 시점:**
- dispatch 파일 (결정 + 컨텍스트 + 자율 영역)
- `docs/bridge_protocol.md` Sec.4 표 (Orc-XXX 세션 split panes + 페르소나)

---

### 2.3 드래프터 역할 (주임연구원)

**필독:**
- `docs/operating_manual.md` Sec.1.2 (본인 + 리뷰어/파이널리즈 역할)
- `docs/bridge_protocol.md` Sec.4 표 "dispatch 작성 정책" (A 패턴: ≤ 800줄)
- 현재 단계 dispatch 파일

**작성 시점:**
- 리뷰어와 파이널리즈의 MBTI / 성향 (operating_manual.md Sec.1.2.1)
- 이전 stage 산출물 (reference 목록)

---

### 2.4 리뷰어 역할 (책임연구원)

**필독:**
- `docs/bridge_protocol.md` Sec.4 표 "dispatch 작성 정책" (A 패턴: ≤ 600줄 수정)
- 드래프터 초안 + R-N 마커 trail

**검토 시점:**
- `docs/operating_manual.md` Sec.1.2 (파이널리즈의 직급/role)
- 정정 사항 명시 후 파이널리즈에 전달

---

### 2.5 파이널리즈 역할 (선임연구원)

**필독:**
- `docs/bridge_protocol.md` Sec.4 표 "dispatch 작성 정책" (A 패턴: ≤ 500줄 마감)
- 리뷰어 수정본

**마감 시점:**
- Stage Transition Score 임계값 80% (operating_manual.md Sec.5.4)
- **본문 작성 금지** — verdict + Score + AC + 통합 trail만

---

## 3. MD 파일 분량 정책 (F-62-3)

각 파일의 분량 임계값입니다. 초과 시 하위 폴더로 분할.

### 3.1 코어 문서 (이식 가능)

| 파일 | 임계값 | 현재 (2026-04-27 R1 reviewer 검증) | 정책 |
|------|--------|------|------|
| `CLAUDE.md` | ≤ 200줄 | 87줄 | 프로젝트 절대 규칙 + 포인터만 (검토 포인트 정합) |
| `docs/operating_manual.md` | ≤ 1000줄 | 425줄 | 6개 섹션 자기-완결 (F-62-3) |
| `docs/bridge_protocol.md` | ≤ 400줄 | 362줄 | 회의창 영구 지침 + 사고 사례 |
| `docs/context_loading.md` | ≤ 200줄 | 본 파일 | 로드 가이드 |

> **R-7, R-8 reviewer 정정 (2026-04-27 최우영):** CLAUDE.md 임계값 ≤ 85줄 → ≤ 200줄 정정 (검토 포인트와 정합 + 자기 위반 해소). 분량 현황 stale(362/340/179) → 실측치(414/358/187) 갱신. 본 표는 reviewer 정정 시점 기준 — 변경 시 실측 갱신.

### 3.2 Stage별 산출물 (분할 정책)

| 영역 | 파일명 | 임계값 | 분할 기준 |
|------|--------|--------|---------|
| 기획 | `docs/02_planning_v<X>/plan_draft.md` | ≤ 1200줄 | 초과 시 `plan_draft_1.md` / `plan_draft_2.md` 분할 |
| 디자인 | `docs/07_ux/design_spec.md` | ≤ 1200줄 | 초과 시 `design_spec_<domain>.md` 분할 (UI/UX 영역별) |
| 개발 | `docs/03_design/v<X>_technical_design.md` | ≤ 1500줄 | 초과 시 `architecture.md` / `data_flow.md` 분할 |

### 3.3 분할 패턴

**단일 파일 초과 시:**
```
docs/02_planning_v<X>/
├── plan_draft.md           (≤ 1200줄, main narrative)
├── plan_draft_1_market.md  (= plan_draft에서 시장분석 섹션 → 분할)
└── plan_draft_index.md     (포인터만, 통합 index)
```

**분할 후 main 파일:**
- 원본 파일명은 유지 (포인터 역할)
- "상세 = `plan_draft_1_market.md` 참조" 식 inline 포인터 삽입
- 통합 trail은 main 파일에만 기록

---

## 4. 컨텍스트 타임아웃 정책 (v0.6.6 예정)

세션 간 컨텍스트 재사용 최소화를 위한 정책 (현재는 운영자 메모리 + handoff 의존).

| 이벤트 | 정책 |
|--------|------|
| 세션 1시간 이상 유휴 | handoff.md 갱신 권고 |
| stage 경계 넘을 때 | 다음 stage dispatch에 critical files 명시 |
| dispatch 발행 시 | 필독 파일 목록 > 본 가이드 Sec.2 참조 |

---

## 5. 메모리 vs MD 파일

**메모리 사용 (`.claude/projects/.../memory/`):**
- 세션 간 학습된 패턴 (feedback / user preference)
- 프로젝트 상태 스냅샷 (현재 진행 중인 타겟)
- 외부 자원 포인터 (Linear 프로젝트, Grafana 보드)

**MD 파일 사용:**
- 공식 규칙 (CLAUDE.md / bridge_protocol.md / operating_manual.md)
- stage별 산출물 (planning / design / implementation)
- commit trail + 의사결정 로그

**교집합 금지:**
- "메모리에만 박으면 새 세션에서 또 안 된다" (bridge_protocol.md 사고 4)
- 규칙은 항상 MD에 → 메모리는 예외/확장만

---

## 6. R2 로드 자동화 (v0.6.6+ hook)

미래 계획: 세션 진입 시 자동 로드 script.

```bash
# 예상 패턴 (구현 예정)
before_session_start:
  1. check git branch + HANDOFF_v<X>.md
  2. determine role (회의창 / 오케 / 드래프터 / ...)
  3. load Sec.2 recommended files 자동 제시
  4. call agent with auto-loaded context
```

현재(v0.6.5 Lite MVP)는 수동 로드 — 각 세션이 "의도적으로" R2 순서 준수.

---

**본 가이드 최종 검증:** 신규 세션이 R2 → Sec.2 → dispatch만 읽고 해당 stage를 올바르게 진행할 수 있는가?
