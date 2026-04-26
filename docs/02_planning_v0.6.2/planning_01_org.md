---
version: v0.6.2
stage: 4 (plan_final)
date: 2026-04-26
mode: Standard
status: pending_operator_approval
item: 01_org
revision: v3 (final)
final_at: 2026-04-26
finalized_by: 안영이 (기획팀 선임연구원)
incorporates_review: planning_review.md
revisions_absorbed: [F-ORG-D1, F-ORG-1, F-ORG-2, F-ORG-3, F-ORG-S5, F-X-1]
cross_cutting_absorbed: [F-X-1, F-X-4, F-X-8]
---

# jOneFlow v0.6.2 — 조직도 개편 정식 반영 (planning_01_org)

> **상위:** `docs/01_brainstorm_v0.6.2/brainstorm.md` Sec.3 (Stage 1, 세션 23)
> **본 문서:** `docs/02_planning_v0.6.2/planning_01_org.md` (Stage 4 final, 세션 25)
> **상태 배너:** ⏳ **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.
> **다음:** Stage 4.5 운영자 승인 게이트 → Stage 8 구현 (후행: planning_05 먼저 완료 후)
> 모드 근거: 조직도 설계는 운영 정책·페르소나 배정이지 기술 스키마 변경 아님. 보안·규제 대상 아님. Standard 유지.

---

## Sec. 0. v2 → final 변경 요약

| ID | 위치 | 변경 요지 |
|----|------|---------|
| F-ORG-D1 (정책 commit) | Sec. 1, Sec. 2 | 조직도 → docs/operating_manual.md#조직도 단독 거주. CLAUDE.md Sec.2.5 포인터 5~10줄 (v2에서 흡수 완료) |
| F-ORG-1 | AC-Org-3 | "Sec.2.5 외 변경 0" → "조직도 콘텐츠 단일 경로 이동" 재정의 (v2에서 흡수 완료) |
| F-ORG-2 | AC-Org-2, Sec. 1 | 11명/13명 → **18명** 통일 (v2에서 흡수 완료) |
| F-ORG-3 | AC 표 전체 | 자동/수동 컬럼 + 명령어 verbatim 추가 (v2에서 흡수 완료) |
| F-ORG-S5 | Sec. 9 이월 표 | AC-Org-6 settings.json 변환 샘플 Stage 5 이월 (v2에서 흡수 완료) |
| F-X-1 (횡단 통합) | Sec. 1, Sec. 6 | planning_01+05 CLAUDE.md Sec.2.5 분기 충돌 → 단일 결정: 조직도는 docs/operating_manual.md (v2에서 흡수 완료) |
| **F-X-4 (횡단)** | Sec. 9 이월 표 | 18명 페르소나 ↔ settings.json schema 어댑터: 현 v0.4 schema 보존 권장. Stage 5 결정 |
| **F-X-8 (횡단)** | Sec. 0 scope 표 | brainstorm Sec.2 4개 → plan_final 5개 scope 확장 (selfedu 포함) 명시 |
| **AC 의존 그래프** | Sec. 6 | 구현 순서 명시: 01은 02 후행, 05보다 선행 |
| **운영자 결정 게이트** | Sec. 끝 | Q5(18명 페르소나 가동 시점) 게이트 박음 |

### F-X-8: v0.6.2 Plan Scope 전체 (5개)

| # | 항목 | brainstorm 섹션 | 상태 |
|---|------|---------------|------|
| 01 | 조직도 개편 정식 반영 | Sec.3 | 본 문서 |
| 02 | Apache 2.0 라이선스 도입 | Sec.4 | planning_02_license.md |
| 03 | slash command 래퍼 3종 | Sec.5 | planning_03_slash.md |
| 04 | handoffs/ 폴더 구조 | Sec.6 | planning_04_handoffs.md |
| 05 | Self-Contained 교육 구조 | Sec.9 | planning_05_selfedu.md |

---

---

## Sec. 1. 목적 (Purpose)

v0.6.1까지 CLAUDE.md Sec.2.5의 3계층 임시 조직도(CTO팀 → 오케스트레이터 → 팀원)는 초기 설계 기록용이었습니다. 브레인스토밍 세션 23에서 CEO 이형진 → CTO 백현진 → PM 스티브 리 → 기획/디자인/개발 3팀으로 확대된 5계층 정식 조직도가 운영자 및 팀과 합의되었습니다. 이제 해당 정식판을 정규화하되, **조직도 5계층 ASCII 트리 + 18명 페르소나(CEO 1 + CTO 1 + PM 1 + 기획팀 4 + 디자인팀 4 + 개발팀 7)의 모델/effort 배정 표는 `docs/operating_manual.md#조직도`에 단독 거주**하고, **CLAUDE.md Sec.2.5는 5~10줄 포인터로 축약**하여 CLAUDE.md 슬림화(planning_05 정책, ~80줄)와 양립시킵니다. HR팀은 현재 미배정 상태로 표기합니다.

---

## Sec. 2. 범위 (Scope)

### 변경 항목

**정책 결정 (F-ORG-D1):** 조직도 5계층 ASCII 트리 + 18명 페르소나 모델/effort 배정 표는 **`docs/operating_manual.md#조직도`에 단독 거주**. CLAUDE.md Sec.2.5는 5~10줄 포인터만 남김. 이는 planning_05(CLAUDE.md ~80줄 슬림화)와의 양립을 위한 정책.

변경 방식:
- CLAUDE.md Sec.2.5 기존 50줄 이상 → 포인터 5~10줄 축약
- 조직도 상세(5계층 트리 + 18명 모델/effort 표)는 planning_05가 신설하는 `docs/operating_manual.md#조직도` 섹션으로 이동
- HR팀 미결 상태 표기 유지

### 미변경 항목
- CLAUDE.md의 다른 섹션 (Sec.1, 2, 2.5 외, 3~8) — 수정 없음
- WORKFLOW.md, HANDOFF.md 등 정규 파일 — 일절 변경 안 함
- `.claude/settings.json` — Stage 8 구현에서 배정표를 참고해 `stage_assignments` 갱신 (본 단계는 계획만)

---

## Sec. 3. 변경 대상 파일

| 파일 | 섹션 | 작업 | 라인 수(예상) |
|------|------|------|-------------|
| `CLAUDE.md` | Sec.2.5 | 기존 73줄 → 5~10줄 포인터 축약 | 73→10 (약 63줄 감소) |
| `docs/operating_manual.md` | #조직도 | 신규 5계층 트리 + 18명 모델/effort 표 | ~60줄 (planning_05 범위) |

---

## Sec. 4. 단계별 작업 분해 (Stage 8 구현 순서)

### 4.1 부분 ① — 새 ASCII 트리 작성
- brainstorm.md Sec.3의 5계층 트리 정확하게 복사
- CEO / CTO / PM / 3팀(기획/디자인/개발) 각 팀 4명 구조 확인
- 들여쓰기, 연결자 (├ / │ / └) 일관성 검증

### 4.2 부분 ② — 모델/effort 배정 테이블 추가
- 각 페르소나별 모델(Sonnet/Opus/Haiku) + effort(low/medium/high) 명시
- 배정 원칙(CEO/CTO Sonnet/medium, PM Opus/medium, 오케 Opus/high, 리뷰 Opus/high, 파이널 Sonnet/medium, 드래프터 Haiku/medium) 테이블로 정의
- 총 11명(미결 HR팀 제외) 전원 배정 확인

### 4.3 부분 ③ — 역할 구분 섹션 갱신
- 현 "역할 구분" 서술 검토
  - Cowork 세션 역할 유지
  - Code 세션 역할 유지
  - CLI 오케스트레이터 역할 유지
  - 페르소나별 모델 배정이 추가되었음을 명시

### 4.4 부분 ④ — HR팀 미결 표기
- 조직도 하단에 1~2줄 주석 추가
  - "향후 HR팀(채용/성과/교육) 추가 가능. 현재는 예약된 자리 미배정."
  - Sec.2.5 끝에 `<!-- HR team TBD -->` 같은 표기 고려

---

## Sec. 5. AC (Acceptance Criteria)

| AC ID | 기준 | 측정: 자동/수동 | 측정 명령/방법 |
|-------|------|------------------|-------------|
| **AC-Org-1** | 5계층 구조 정확성. CEO 1 → CTO 1 → PM 1 → 기획/디자인/개발 각 1팀 4명 = 18명 구조 확인. 들여쓰기 및 ASCII 연결자 일관성. | 수동 | 들여쓰기 visual 검사, ASCII 연결자(├/└/│) 일관성 |
| **AC-Org-2** | 모든 페르소나 모델/effort 배정. **18명 전원**(CEO 1 / CTO 1 / PM 1 / 기획팀 4 / 디자인팀 4 / 개발팀 7) 모델·effort 명시. 누락 0. | 자동 | `grep -c "(Opus\|Sonnet\|Haiku)" docs/operating_manual.md` ≥ 18 |
| **AC-Org-3** | 조직도 콘텐츠 단일 경로 이동. docs/operating_manual.md#조직도로 이동 후, CLAUDE.md 다른 섹션 변경은 planning_05 scope와 분리. | 자동 | `grep -c "docs/operating_manual" CLAUDE.md` ≥ 1 |
| **AC-Org-4** | HR팀 미결 표기 명확화. docs/operating_manual.md에 HR팀 미배정 상태 명시. | 자동 | `grep -c "HR" docs/operating_manual.md` ≥ 1 |
| **AC-Org-5** | 모델/effort 배정 원칙 문서화. "왜 CEO/CTO는 Sonnet, 오케/리뷰는 Opus high인가" 원칙을 한 문단으로 설명. | 수동 | docs/operating_manual.md 원칙 섹션 visual 검사 |
| **AC-Org-6** | `.claude/settings.json` 마이그레이션 샘플. 배정표 → JSON 변환 샘플 1건 Stage 5에서 작성 (실제 수정은 Stage 8). | Stage 5 이월 | Stage 5 기술 설계에서 JSON 변환 샘플 생성 |
| **AC-Org-7** | 페르소나별 커뮤니케이션 톤 호환성. brainstorm Sec.8 "페르소나별 톤"과 일관성 유지. | 수동 | docs/operating_manual.md 톤 섹션 visual 검사 |

---

## Sec. 6. 의존성

### 내부 의존성
- **Sec.2.5 현 콘텐츠 정확성 확인 필수** — 기존 3계층 트리를 정확히 파악한 뒤 교체할 것. CLAUDE.md 라인 49~83 범위 재확인 권장.
- **brainstorm.md Sec.3 정식판과 sync** — planning 작성 시점 이후 brainstorm이 수정될 경우, 정식판 5계층 트리가 최신인지 확인.

### 외부 의존성
- **없음** — 조직도 변경은 CLAUDE.md 텍스트 반영이므로 외부 도구/API 미필요.

### 다른 planning 항목과의 관계 (F-X-7 구현 순서)

권장 구현 순서: **02(license) → 01(본 항목) → 05(selfedu) → 04(handoffs) → 03(slash)**.

- **planning_02_license.md** — 독립적 (LICENSE 파일 추가). 가장 먼저 구현 가능.
- **planning_03_slash.md** — 독립적. 그러나 planning_04 hook 회귀 테스트 필요로 04 후행 권장.
- **planning_04_handoffs.md** — 독립적. 본 01보다 후행.
- **planning_05_selfedu.md** — **본 항목 선행 필요.** docs/operating_manual.md가 조직도를 흡수하므로, 01 완료 후 05 구현.

**F-X-1 (횡단 정책 commit 확정):** 조직도는 `docs/operating_manual.md#조직도` 단독 거주. CLAUDE.md Sec.2.5는 5~10줄 포인터. planning_05 CLAUDE.md ~80줄 슬림화와 양립. 이 결정은 두 planning 모두를 구속한다.

**F-X-4 (횡단, Stage 5 이월):** 18명 페르소나 ↔ settings.json schema 어댑터. 단순 보존(현 v0.4 schema 유지) 권장. Stage 5에서 personas 필드 추가 여부 결정.

---

## Sec. 7. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 |
|----|--------|-----------|--------|------|
| R1 | HR팀 미결 표기 누락 → 향후 조직 확장 시 혼동 | 중 | 중 | Sec.2.5 하단에 명시적 `<!-- HR team TBD -->` 주석 추가. 미결 상태를 운영 가이드에도 한 줄 기록 |
| R2 | 페르소나 모델 배정 변경 시 settings.json 영향 → Stage 8 구현 단계에서 `stage_assignments` 동기화 누락 리스크 | 중 | 중 | planning_01 AC-Org-6에서 "settings.json 마이그레이션 가능성" 검증. 구현자가 배정표 → JSON 필드 변환 시 체크리스트 작성 |
| R3 | 5계층 구조가 Cowork/Code/CLI 역할 분리와 충돌 가능성 (예: PM이 브릿지 역할을 하되, PM 아래 팀이 있어서 계층 혼동) | 중 | 중 | Stage 3 plan_review에서 "Cowork 역할"(운영자 + CTO 실장)과 "Code 역할"(PM 브릿지) 명확화 필수. 조직도만으로 충분하지 않으면 역할 맵핑 다이어그램 추가 |
| R4 | ASCII 트리 형식 오류 (들여쓰기, 연결자 불일치) → 문서 가독성 저하 | 낮음 | 낮음 | 파일 저장 후 terminal에서 `cat CLAUDE.md \| grep -A 30 "2.5"` 로 ASCII 렌더링 확인 |

---

## Sec. 8. 열린 질문 (Stage 3 plan_review에서 판단)

| # | 질문 | 판단 책임 |
|---|------|----------|
| Q1 | planning_05_selfedu의 "CLAUDE.md 슬림화" 목표(~80줄)와 본 planning_01의 조직도 추가(약 50줄)가 양립 가능한가? | Stage 3 plan_review |
| Q2 | 조직도 상세(모델/effort 배정, 역할 설명)를 CLAUDE.md에 전부 포함할지, `docs/org_structure.md` 같은 별도 파일에 분리할지 | Stage 3 |
| Q3 | 페르소나별 이름 + 직급이 고정되었는가? 향후 팀원 교체 시 조직도 변경 정책은? | Stage 3 (정책 결정) |
| Q4 | "오케스트레이터" "리뷰어" "파이널리즈" "드래프터"라는 용어가 jOneFlow 외부(예: JoneLab 전사)에서도 표준화할 용어인가? | Stage 3 (용어 정의 확정) |

---

## Sec. 9. Stage 5 이월 표

| 이월 ID | 내용 | 담당 | 시점 |
|--------|------|------|------|
| **F-ORG-S5** | settings.json 마이그레이션 샘플 — AC-Org-6: 배정표 → JSON 변환 샘플 1건 | Stage 5 기술 설계 | **필수** |
| **F-X-4** | 18명 페르소나 ↔ settings.json v0.4 schema 어댑터. 단순 보존(현 schema 유지) vs personas 필드 추가 결정 | Stage 5 기술 설계 | 권장 |

**이월 외 미결 (후속 버전):**
- HR팀 추가 시 조직도 갱신 프로세스 (v0.6.2 후속)
- "파이널리즈" 영문 표기 병행 여부 (글로벌 공개 고려 시)

---

## Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v1 초안 (세션 25) | brainstorm.md Sec.3 기반 planning_01_org 작성 |
| 2026-04-26 | v2 개정 (세션 25, planning_review.md 흡수) | F-ORG-D1: 조직도 이동 정책(docs/operating_manual.md로) 명시 / F-ORG-1: AC-Org-3 재정의 / F-ORG-2: 11→18명 통일 / F-ORG-3: AC 자동/수동 컬럼 추가 / F-X-1: 횡단 정책 통합 |
| 2026-04-26 | v3 final (세션 25, 안영이 finalizer) | 횡단 F-X-1/F-X-4/F-X-8 흡수 / Sec.0 변경 요약 추가 / scope 5개 표 박음 / 의존 그래프 수렴 (구현 순서) / Stage 5 이월 표 정비 / 운영자 결정 게이트 Q5 박음 |

---

---

## 운영자 결정 게이트 (Stage 4.5 필수)

> **Stage 4.5 운영자 승인 게이트 필수.** Q5 답변 전 Stage 5/8 진입 금지.

| Q | 결정 항목 | 권장 | 답변 |
|---|---------|------|------|
| **Q5** | 18명 페르소나 가동 시점. 현재 4명(준혁/민지/태원/지영) 가동 중. 18명 정식 가동은 v0.6.2 완료 후 v0.6.3? | v0.6.2 완료 후 별건 세션. 본 v0.6.2는 docs/operating_manual.md에 18명 페르소나 정의만. 실제 가동은 후속 버전. | **[운영자 결정 필요]** |

---

## 첨부: 참고 자료

### brainstorm.md Sec.3 인용 (정식 ASCII 트리)

```
CEO 이형진
└── CTO 실장(Code) 백현진 (Sonnet, medium)
    └── PM – 브릿지(Code) 스티브 리 (Opus, medium)
        ├── 기획팀 (tmux, Code CLI)
        │   ├── 오케스트레이터 – 팀장(PL) 박지영 (Opus, high)
        │   ├── 리뷰어 – 책임연구원 김민교 (Opus, high)
        │   ├── 파이널리즈 – 선임연구원 안영이 (Sonnet, medium)
        │   └── 드래프터 – 주임연구원 장그래 (Haiku, medium)
        ├── 디자인팀 (tmux, Code CLI)
        │   ├── 오케스트레이터 – 팀장(PL) 우상호 (Opus, high)
        │   ├── 리뷰어 – 책임연구원 이수지 (Opus, high)
        │   ├── 파이널리즈 – 선임연구원 오해원 (Sonnet, medium)
        │   └── 드래프터 – 주임연구원 장원영 (Haiku, medium)
        └── 개발팀 (tmux, Code CLI)
            ├── 오케스트레이터 – 팀장(PL) 공기성 (Opus, high)
            ├── 백앤드 리뷰어 – 책임연구원 최우영 (Opus, high)
            ├── 백앤드 파이널리즈 – 선임연구원 현봉식 (Sonnet, medium)
            ├── 백앤드 드래프터 – 주임연구원 카더가든 (Haiku, medium)
            ├── 프론트 리뷰어 – 책임연구원 백강혁 (Opus, high)
            ├── 프론트 파이널리즈 – 선임연구원 김원훈 (Sonnet, medium)
            └── 프론트 드래프터 – 주임연구원 지예은 (Haiku, medium)
```

### 모델/effort 배정 원칙 (요약)

| 페르소나 | 모델 | Effort | 근거 |
|---------|------|--------|------|
| CEO, CTO | Sonnet | medium | 전략 판단, Cowork 세션 운영 속도 우선 |
| PM 브릿지 | Opus | medium | 허브 역할, 빠른 분배 필요 |
| 오케스트레이터 | Opus | high | 팀 지휘 + 최종 판단, 깊이 필요 |
| 리뷰어 | Opus | high | 깊은 피드백, 놓치면 재작업 비용 큼 |
| 파이널리즈 | Sonnet | medium | 최종 정리/검증, 속도 우선 |
| 드래프터 | Haiku | medium | 초안 작성, 속도 우선 |

