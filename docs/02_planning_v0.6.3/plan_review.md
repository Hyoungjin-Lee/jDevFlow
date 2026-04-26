---
version: v0.6.3
stage: 3 (plan_review)
date: 2026-04-26
mode: Standard
status: review
authored_by: 김민교 (기획팀 책임연구원, 리뷰어, Opus/high)
upstream:
  - docs/02_planning_v0.6.3/plan_draft.md (454 lines, COMPLETE-DRAFTER1, Q1~Q6)
  - docs/02_planning_v0.6.3/personas_18.md (재작성 — COMPLETE-DRAFTER2-REWRITE, 장원영 디자인팀 명의, 운영자 결정 #16 흡수)
  - docs/01_brainstorm_v0.6.3/brainstorm.md (의제 9건 + 운영자 결정 13건)
  - dispatch/2026-04-26_v0.6.3_stage234_planning.md
session: 26
---

# jOneFlow v0.6.3 — 기획 리뷰

> **상위:** `docs/02_planning_v0.6.3/plan_draft.md` (Stage 2 drafter1) + `docs/02_planning_v0.6.3/personas_18.md` (Stage 2 drafter2)
> **본 문서:** `docs/02_planning_v0.6.3/plan_review.md` (Stage 3, 세션 26)
> **하위:** Stage 4 plan_final (안영이 선임연구원 + 박지영 PL 오케)
> **상태:** 🔍 **리뷰 진행 — 권고형 피드백 + 보강 영역 식별**, finalizer 통합 시 정정 영역 명시

---

## Sec. 0. 리뷰 개요

### 0.1 리뷰 범위

본 리뷰는 dispatch (`2026-04-26_v0.6.3_stage234_planning.md`) 명시 6항을 기준으로 합니다:

| 항목 | 주제 | 본 doc 위치 |
|------|------|-----------|
| (a) | drafter1/drafter2 강점/보강 | Sec.1 |
| (b) | 페르소나 정정 영역 — drafter2 신규 spawn (장원영, 디자인팀 일시 동원) | Sec.2 |
| (c) | 의제 9건 → 마일스톤 매핑 정합성 | Sec.3 |
| (d) | F-62-5~F-62-8 신규 설계 제약 타당성 | Sec.4 |
| (e) | Stage Transition Score 5항목 × 가중치 적합성 | Sec.5 |
| (f) | Q 후보 통합 (drafter1 6 + drafter2 2 + 신규 식별) | Sec.6 |

### 0.2 리뷰 어조

- **단호하되 권고형** — "X 해야 합니다" 대신 "X를 권고합니다 / 검토가 필요합니다"
- **강점 먼저, 보강 다음** — drafter의 작업을 가시화한 뒤 개선 영역 제시
- **정밀 인용** — 모호한 지적 회피, 줄 번호 / 섹션 위치 명시
- **운영자 권한 영역 표기** — 리뷰어 권한 외 결정은 finalizer / 운영자 위임 명시

### 0.3 종합 판정 (잠정)

- **drafter1 (plan_draft.md):** 마일스톤 정밀화·의존 그래프 견고. Score 계산식 가중치 검증 필요.
- **drafter2 (personas_18.md):** 5계층 트리·spawn 매핑·톤 가이드 완비. v0.6.3 가동 범위(Sec.7) 표 정확성 미세 보강 필요.
  *(본 판정은 본 리뷰 시점 산출물 기준. 운영자 결정 #16 — drafter2 재작성(장원영, 디자인팀 일시 동원) — 흡수에 따라 재작성 산출물에 대한 별도 재리뷰는 후속 영역으로 위임. 본 판정 자체는 유지하되 명의 trace는 Sec.2 정정 완료 영역 참조.)*
- **finalizer 통합 시 정정 영역 4건 명시** (Sec.7 참조).

---

## Sec. 1. drafter1 / drafter2 강점 및 보강 (검토 항목 a)

### 1.1 drafter1 (`plan_draft.md`, 454줄) 강점

**(S1-1) 마일스톤 ↔ 의제 매핑 표(Sec.1)**
의제 9건 × M1~M5 매트릭스가 ●●●/●●/● 가중치로 명료하게 표현됨. 의제 8(마일스톤 자체)이 ↓로 표현된 처리가 우아함.

**(S1-2) 의존 그래프 시각화(Sec.3)**
ASCII 그래프 + critical path(M1+M4) + 독립(M2) + 느슨한 의존(M5) 구분이 명확. Stage 5 기술 설계 인풋으로 즉시 활용 가능.

**(S1-3) AC 검증 자동화 지향(Sec.2 각 M)**
`grep`/`wc -l`/`command -v` 기반 검증 명령이 명시됨. CI 파이프라인 통합 시 그대로 적용 가능한 수준.

**(S1-4) 운영자 결정 trace(Sec.7)**
brainstorm Sec.5 13건 결정 → plan 흡수 위치 매핑 표가 누락 없이 완비.

**(S1-5) 미결 사항 명시(Sec.8)**
Q1~Q6이 주제 / 의존 / 대상 컬럼으로 구조화. 리뷰어/오케/운영자 위임 영역 구분이 적절.

### 1.2 drafter1 보강 권고

**(B1-1) Sec.0 외부 일정 맥락 — Windows 마감 표현 정확도 [낮음]**
`l.28` "2026-05 초 Windows 사용자 진입 전 완료 필수"는 brainstorm `l.18`의 "외부 일정. v0.6.3 작업 자체는 그 한참 전에 완료"보다 톤이 강함. **권고:** "외부 일정(2026-05 초 Windows 진입)에 선행 완료 — v0.6.3 due 2026-04-27"로 표현 정정.

**(B1-2) Sec.2 M1 변경 대상 — 신규/개정 구분 모호 [중간]**
`l.65` `monitor_bridge.sh`가 "(신규 또는 개정)"으로 양가적. 기존 파일 존재 여부 확인 후 finalizer 시점에 단일화 권고. (실제 `scripts/` 디렉토리 검증 필요.)

**(B1-3) Sec.2 M3 AC — `python3 -m py_compile` 호출 위치 모호 [중간]**
`l.131` "shell script 또는 hook"으로 표기. brainstorm 의제 5는 "PostToolUse" 명시 → **권고:** AC를 "`.claude/settings.json` hooks.PostToolUse 내에서 .py 대상 시 `python3 -m py_compile` 호출 명시"로 구체화.

**(B1-4) Sec.2 M4 AC — `wc -l ≥ 10` 검증 부정확 [낮음]**
`l.161` `grep -A5 "Codex" personas_18.md | wc -l ≥ 10`은 grep 결과 파이프 후 비교 연산 누락. **권고:** `[ "$(grep -A5 ... | wc -l)" -ge 10 ]` 형태로 정정.

**(B1-5) Sec.5 F-62-x 후보 — 운영자 결정 4번(claude CLI 자동화) 누락 가능 [중간]**
brainstorm 운영자 결정 #4(`claude CLI 자동화 호출 + 옵션 필수`)는 plan_draft Sec.7에서 "F-62-x 후보 또는 Stage 5 기술 설계"로 미정. **권고:** F-62-9(claude CLI `--dangerously-skip-permissions` 강제) 신규 후보 추가 검토. (Sec.4 상세 참조.)

**(B1-6) Sec.6 Score — 마일스톤별 분리 미적용 [중간]**
"각 마일스톤별 5개 항목 × 가중치"라 명시했으나 계산식은 단일 합산 형태. M별 Score → 평균/최소값 정책이 미정. (Sec.5 상세 참조.)

### 1.3 drafter2 (`personas_18.md`, 512줄) 강점

**(S2-1) 5계층 트리 + 18명 매트릭스 완비(Sec.1, Sec.2)**
ASCII 트리 + 모델/effort/spawn/단계/톤 8개 컬럼 표가 일관됨. operating_manual.md Sec.1.2 영구 거주판과의 분기 명시(Sec.0.1) 양호.

**(S2-2) spawn 도구 매핑 구체성(Sec.4)**
`tmux new-session` + `claude --teammate-mode tmux --dangerously-skip-permissions` 명령이 그대로 실행 가능 수준. 해제 명령(`tmux kill-session`)도 포함.

**(S2-3) 페르소나별 톤 가이드(Sec.5)**
응답 시작 어구 / 자주 쓰는 어휘 / 회피 어휘 3축 구조가 운영 시점에 즉시 활용 가능. 직급별 차별화(CEO/PM/Orc/Rev/Fin/Dft) 명료.

**(S2-4) 리뷰어 conditional 정의(Sec.6)**
모드 A(통합 검증자) / 모드 B(원래 코드 리뷰어) + 환경 감지 분기(`stage_assignments.stage9_review`) 명시. brainstorm 의제 4-3 → 그대로 흡수.

**(S2-5) 가동 시점 표(Sec.7)**
13 stage × 18명 매트릭스로 active/off 명시. 디자인팀 v0.6.3 미가동(Non-goal) 처리 일관됨.

### 1.4 drafter2 보강 권고

**(B2-1) Sec.2 PM 브릿지 — 모델 표기 일관성 [낮음]**
`l.80` 스티브 리(PM 브릿지) 모델이 **Opus 4.7 / xhigh** 굵게 강조됨. operating_manual.md Sec.1.2 거주판과 동일 강조 여부 확인 필요. (강조 자체는 무방하나 일관성 차원.)

**(B2-2) Sec.2 백현진 CTO — 모델 Sonnet/medium [중간]**
`l.79` CTO Sonnet/medium은 brainstorm Sec.0 컨텍스트에 명시 없음. v0.6.2 또는 이전 버전 결정 사항인지 확인 필요. **권고:** 출처 인용 `← operating_manual.md Sec.1.2 (영구판)` 추가.

**(B2-3) Sec.3.3 개발팀 PL — 부 PL 미배정 결정 근거 보강 [중간]**
`l.151` "공기성 PL 단독 지휘 (부 PL 미배정, 추후 검토)"는 Q-PER-2로 미결화. 좋음. 다만 "추후"의 시점이 모호 → **권고:** "Stage 5 기술 설계 또는 v0.6.4 운영"로 명시.

**(B2-4) Sec.7 가동 시점 표 — Stage 11/12 공기성 누락 [중간 → 정정 영역]**
`l.376` 공기성(Orc) 가동 단계가 "Stage 5/8/9/10"으로 표시. 그러나 brainstorm 워크플로우(Stage 11=Strict 검증, Stage 12=QA, Stage 13=Release) 진행 시 개발팀 PL의 standby/active 여부 미정. **권고:** Stage 11~13 표기에 "standby" 컬럼 추가 또는 "—"의 의미 보완.

**(B2-5) Sec.7 — Stage 4 안영이/박지영 — 파이널라이저 + 오케 가동만 [낮음]**
드래프터(장그래)와 리뷰어(김민교)는 Stage 2 종료 후 standby가 자연스러움. 표상 ✅로 동일 처리되어 미세 모호. **권고:** Stage 4 셀에 ✅(active) vs ✅(standby) 구분 추가 검토. (자율 영역.)

**(B2-6) Sec.6.3 환경 감지 — `stage_assignments.stage9_review` 키 schema 미존재 가능 [높음]**
`.claude/settings.json` schema v0.4에 `stage9_review` 필드 존재 여부 미검증. 실제 schema 확인 후 finalizer 시점에 정정 권고. (CLAUDE.md Sec.2 인용: schema v0.4.)

---

## Sec. 2. 페르소나 정정 영역 — 정정 완료 trace (검토 항목 b)

### 2.1 정정 완료 사실 관계 (운영자 결정 #16 흡수 후)

| 항목 | 내용 |
|------|------|
| brainstorm Sec.8 정의 | 기획팀 drafter = **장그래 1명** (Haiku/medium) |
| operating_manual.md Sec.1.2 | 동일 (영구판) — 18명 정식판 |
| **운영자 결정 #16** (본 리뷰 시점 흡수) | **drafter2 페르소나 재작성 = 가** (추가 commit, amend X) |
| 신규 drafter2 명의 | **장원영 (디자인팀 주임연구원, Haiku/medium, 1.3 pane 재spawn 완료)** |
| 정정 후 산출물 명의 | `plan_draft.md` = 장그래 (기획팀) / `personas_18.md` = 장원영 (디자인팀, 재작성) |
| 18명 정의 위반 | **0건** (각 산출물 1 drafter 명의 = 정의 정합) |
| 디자인팀 v0.6.3 Non-goal 충돌 | **회피** (디자인팀 미가동 정책 유지 + 페르소나 일시 spawn으로 conflict 해소) |

### 2.2 정정 trace 분석

**(A) 운영자 결정 #16 흡수 경로**
- 본 리뷰 초안 시점(이전): drafter1/drafter2 모두 장그래 단일 명의 → "재작성 X, finalizer 정정 영역 표시" 잠정안
- 운영자 결정 #16: **재작성 = 가** (추가 commit, amend X) → 신규 drafter spawn 채택
- drafter2 신규 = 장원영 (디자인팀, Haiku/medium) → **1.3 pane 재spawn 완료**

**(B) 18명 정의 정합성 — 최종 판정**
- brainstorm Sec.8 + operating_manual Sec.1.2 = 기획팀 drafter 1명(장그래) + 디자인팀 drafter 1명(장원영) = **위반 0건**
- 산출물 1개당 drafter 1명 원칙 충족 (`plan_draft.md` ← 장그래 / `personas_18.md` ← 장원영 재작성판)

**(C) 디자인팀 v0.6.3 Non-goal 정책과의 정합성**
- brainstorm Sec.3 Non-goal: "디자인팀 가동 (Stage 8 UI 변경 시점에 자연 진입)"
- 본 정정에서 장원영(디자인팀)은 **일시 동원**(temporary spawn) — 정식 디자인팀 가동 아님 → Non-goal 정책과 충돌 없음
- 운영 의미: drafter 권한 영역(초안 작성)만 활용, 디자인팀 정식 4명 동시 가동 없음 → Stage 6~7 디자인팀 단계 진입은 여전히 미가동 상태로 보존

### 2.3 정정 완료 영역 (운영자 결정 #16 후 finalizer 적용 가이드)

**[정정-1 — 완료] drafter 명의 분리**
- 본 리뷰 시점: 양 산출물 모두 장그래 → 재작성 후 `personas_18.md` = 장원영
- finalizer 적용: plan_final.md `upstream` 항목 = "plan_draft (장그래, 기획팀) + personas_18 재작성판 (장원영, 디자인팀 일시 동원, 운영자 결정 #16)" 명시 권고

**[정정-2 — 완료] frontmatter `authored_by` 정합화**
- `personas_18.md` 재작성판 frontmatter `authored_by` = "장원영 (디자인팀 주임연구원, 드래프터, Haiku/medium)"으로 변경 확인
- `version` / `stage` / `session` 필드는 유지 (본 v0.6.3 / Stage 2 / 세션 26)
- 버전 식별: 마지막 라인 = `COMPLETE-DRAFTER2-REWRITE`로 재작성 trace 명시

**[정정-3 — finalizer 검증 영역] 산출물 간 cross-reference 일관성**
- `plan_draft.md` Sec.2 M4 → `personas_18.md` 위임 (변경 없음)
- `personas_18.md` 재작성판 Sec.0.2 자기 정의 → 디자인팀 명의 변경 외 본문 골격 유지 권고
- → finalizer가 cross-reference 체인 검증 권고 (변경 영역: drafter 명의만, 본문 의미 변경 X)

**[정정-4 — finalizer 보강 영역] Sec.7 가동 시점 표 ↔ plan_draft Sec.4 진행 순서**
- `personas_18.md` 재작성판 Sec.7 (페르소나 단위 stage 가동) ↔ `plan_draft.md` Sec.4 (세션 단위 N/N+1/N+2/N+3) 매핑 일치 여부 finalizer 검증
- 본 정정으로 표 골격 변경 없음. drafter2 재spawn은 작성 권한만 영향 (가동 시점 표 자체는 18명 정식판 그대로)

### 2.4 후속 영역 (본 v0.6.3 비차단)

- **재작성 산출물(`personas_18.md` 재작성판)에 대한 별도 재리뷰**: 후속 영역으로 위임. 본 리뷰는 본 시점 기존 산출물 + 정정 trace 흡수까지 포함.
- **drafter 분배 정책 (v0.6.4 이후)**: Q-NEW-5 연계 — 부 드래프터 도입 vs 세션 분리 vs 일시 동원 패턴 정식화. 운영자 후속 결정.

---

## Sec. 3. 의제 9건 → 마일스톤 매핑 정합성 (검토 항목 c)

### 3.1 매핑 표 검증

drafter1 Sec.1 매핑 표 vs brainstorm 의제 결정 사항 대조:

| 의제 | brainstorm 결정 | M 매핑(plan_draft) | 평가 |
|------|---------------|------------------|------|
| 1 | 옵션 A 통합 (6+1) | M1~M5 ●(전체) | ✅ 적합 |
| 2 | 글로벌 통합 (가) | M2 ●●● | ✅ 적합 |
| 3 | Windows 5월 초 | M1 ●●● | ✅ 적합 |
| 4 | 18명 + 리뷰어 conditional | M3 ●●, M4 ●●●, M5 ●● | ✅ 적합 (다중 의존 명확) |
| 5 | D6 Hooks 경고 | M3 ●●● | ✅ 적합 |
| 6 | gstack ETHOS 3종 | M3 ●●●, M5 ● | ✅ 적합 |
| 7 | Stage 9 Codex conditional | M5 ●●● | ✅ 적합 |
| 8 | 마일스톤 5개 병렬 | ↓(전체 메타) | ✅ 적합 |
| 9 | Monitor 인프라 | M1 ●●●, M3 ● | ✅ 적합 |

**총평:** 매핑 정합성 9/9 PASS. 의제 → M 누락 없음.

### 3.2 의존 그래프 검증

drafter1 Sec.3 의존 그래프 vs brainstorm 의제 8 잠정안 비교:

| 항목 | brainstorm 의제 8 | plan_draft Sec.3 | 평가 |
|------|------------------|----------------|------|
| critical path | M1 + M4 → 5월 초 | 동일 | ✅ |
| 독립 | M2 | 동일 | ✅ |
| M3 → M5 의존 | YES | YES (fix loop) | ✅ |
| M4 → M5 의존 | YES | YES (리뷰어 conditional) | ✅ |
| M5 = 마지막 | YES (느슨) | YES (Stage 8 이후) | ✅ |

**보강 권고 (B3-1):** drafter1 Sec.3 그래프에서 "M4 → M3" 화살표(ETHOS 활용)는 brainstorm 의제 8 그래프(`l.97~106`)에 명시 없음. 의제 6/4 결합 해석 결과로 보임. → **finalizer가 brainstorm 인용 보강** 권고. (정정 권고-X, 보강만.)

### 3.3 진행 순서 정합

drafter1 Sec.4 N/N+1/N+2/N+3 분할 vs brainstorm `l.108~112` 잠정 순서:

| 세션 | brainstorm 잠정 | plan_draft | 평가 |
|------|---------------|-----------|------|
| N | M1 + M2 병렬 | Stage 2~4 기획 (단일) | 🟡 차이 |
| N+1 | M3 + M4 병렬 | Stage 5 기술 설계 | 🟡 차이 |
| N+2 | M5 | Stage 8 구현 (M1+M4 병렬) | 🟡 차이 |
| N+3 | Stage 9 + 12 + 13 | Stage 9~13 | ✅ |

**평가:** brainstorm 잠정안은 "마일스톤별 세션 분배", plan_draft는 "Stage별 세션 분배"로 관점 자체가 상이. → drafter1 관점이 더 정밀(Stage 13단계 모드 정합)하나 brainstorm 변환 trace 보강 필요.

**보강 권고 (B3-2):** plan_draft Sec.4에 "brainstorm 잠정안(M 단위) → Stage 단위 변환 trace" 1행 추가. 예: "본 표는 brainstorm `l.108~112` 잠정안을 Stage 13단계로 재정렬(Stage 8에서 M1+M4 병렬 = brainstorm 세션 N의 M1 + 세션 N+1의 M4 결합)."

---

## Sec. 4. F-62-5~F-62-8 신규 설계 제약 타당성 (검토 항목 d)

### 4.1 후보별 검토

**F-62-5: 글로벌 통합 충돌 우선순위 (의제 2)**
- 영향: 설정 로드 메커니즘
- 타당성: 🔴 **타당** — brainstorm 의제 2 결정 "프로젝트 > 글로벌 specificity 원칙"의 코드화 필수
- 권고: 명문화 위치 = `~/.claude/CLAUDE.md` + 프로젝트 `CLAUDE.md` 양쪽 cross-reference

**F-62-6: Windows fallback sync 책임 (의제 3)**
- 영향: `update_handoff.sh` 설계
- 타당성: 🟡 **조건부 타당** — Stage 5 기술 설계에서 구체화 가능. 본 단계 F-62-x 부여는 조기일 수 있으나, 5월 초 마감 압박 고려 시 우선순위 신호로는 적정.
- 권고: F-62-6 자체는 인정. **단** 영향 범위에 "BSD/GNU sed 호환성" 항목 추가 검토.

**F-62-7: Monitor 인프라 강화 (의제 9)**
- 영향: `monitor_bridge.sh` 구조
- 타당성: 🔴 **타당** — brainstorm 의제 9가 "실수요 증명"으로 채택된 신규 항목. 설계 제약화는 적정.
- 권고: timestamp/stage/범위 3축 모두 F-62-7 산하 sub-제약(F-62-7a/b/c)으로 분할 가능성 검토 (Stage 5 영역).

**F-62-8: 리뷰어 페르소나 conditional (의제 4)**
- 영향: `personas_18.md` 조건부 정의
- 타당성: 🟡 **타당하나 영역 모호** — 페르소나 정의는 일반적으로 운영 영역(operating_manual)에 가까움. F-62-x(설계 제약)로 분류 시 "환경 감지 + 분기 로직"이 본질이므로 영향 범위를 "환경 분기 메커니즘"으로 재정의 권고.
- 권고: 영향 컬럼을 "환경 분기 메커니즘 (`.claude/settings.json` `stage9_review` 키)"로 정정.

### 4.2 신규 후보 식별 (drafter1 누락 가능)

**F-62-9 (신규 권고): claude CLI 자동화 호출 강제 옵션**
- 출처: brainstorm 운영자 결정 #4 + 운영 정책 6건
- 영향: spawn 시 `--dangerously-skip-permissions` 누락 시 기능 정지 위험
- 우선도: 🟡 중간 (자동화 안정성)
- 권고: drafter1 Sec.5 표에 추가 검토 (finalizer 시점). 운영자 결정 #4가 plan_draft Sec.7 trace에서 "F-62-x 후보 또는 Stage 5 기술 설계"로 미정 처리됨 → 본 리뷰가 F-62-9로 명시 권고.

**F-62-10 (검토 후보): 위험 명령 스크립트화 의무**
- 출처: brainstorm 운영자 결정 #5 ("뼈에 사무침")
- 영향: 모든 위험 명령은 스크립트 파일 작성 후 `bash <스크립트>` 형태로 1줄 실행
- 우선도: 🟢 낮음 (이미 운영 정책으로 박힘. 설계 제약화 필요성 검토)
- 권고: F-62-10으로 추가하지 않고, 운영 매뉴얼 / bridge_protocol.md 강화로 대체 가능. **운영자 판단 영역.**

### 4.3 종합 평가

- F-62-5/F-62-7: 🔴 즉시 채택 권고
- F-62-6: 🟡 조건부 채택 (영향 범위 보강)
- F-62-8: 🟡 영역 재정의 권고
- F-62-9: 🟡 신규 추가 권고
- F-62-10: 🟢 채택 보류 (운영자 판단)

**총 4건 채택 → 5~6건 채택 권고**

---

## Sec. 5. Stage Transition Score 5항목 × 가중치 적합성 (검토 항목 e)

### 5.1 drafter1 제안 (Sec.6)

| 항목 | 가중치 | drafter1 정의 |
|------|-------|--------------|
| (1) AC 통과율 | 30% | M1~M5 AC 자동 검증 통과 / 전체 |
| (2) 의존 명확성 | 20% | Sec.3 그래프 vs 실제 진행 일치도 |
| (3) 리스크 식별 | 20% | Sec.2 각 M 리스크 항목 명시 여부 |
| (4) 변경 대상 명세 | 15% | "변경 대상 파일" 정합성 |
| (5) 운영자 결정 trace | 15% | brainstorm 운영자 결정 13건 ↔ plan 흡수 |
| **합계** | **100%** | |

### 5.2 평가

**강점:**
- 5항목 × 가중치 합 100% 정합
- AC 통과율 30%(최대) → v0.6.2 패턴(자동 검증 우선) 계승
- 운영자 결정 trace 항목이 별도 설정됨 → 본 v0.6.3 거버넌스 추적성 강화

**보강 권고:**

**(B5-1) 항목 (3) 리스크 식별 — 정성적 판단의 정량화 [중간]**
"리스크 항목 명시 여부"는 boolean에 가까움. 모든 M이 리스크 1+건 식별 시 100%, 미식별 시 0%로 양극화. → **권고:** "M별 리스크 ≥ 2건 식별 + 완화책 1+건 명시" 정량 기준 도입.

**(B5-2) 항목 (4) 명세 정합성 15% — 가중치 약함 [중간]**
변경 대상 파일이 실제 존재하지 않거나 신규/개정 구분 모호 시 구현 단계 비용 증가. v0.6.2 Stage 9 APPROVED 사례(93.8%, 30+ AC 검증)와 대비 시 명세 정합성은 더 높은 가중치(20%)가 적정. → **권고 가중치 조정안:**

| 항목 | 현 | 조정안 | 근거 |
|------|---|-------|------|
| (1) AC 통과율 | 30% | 30% | 유지 |
| (2) 의존 명확성 | 20% | 15% | -5% (리스크 식별과 일정 부분 중복) |
| (3) 리스크 식별 | 20% | 20% | 유지 (단 정량 기준 도입) |
| (4) 명세 정합성 | 15% | 20% | +5% (구현 단계 영향) |
| (5) 운영자 trace | 15% | 15% | 유지 |
| **합계** | 100% | 100% | |

**(B5-3) 마일스톤별 분리 vs 단일 합산 — 정책 미정 [높음]**
plan_draft `l.293` "각 마일스톤별 5개 항목 × 가중치"로 명시했으나 계산식은 단일. 두 가지 정책 후보:
- **(α) M별 Score → 평균** = M 5개 모두 균등 가중
- **(β) M별 Score → 최소값** = 최약 M이 게이트 결정
- **(γ) 단일 합산** (현 표현)

**권고:** 운영자 결정 영역. v0.6.2 패턴(전체 통합 Score) 따라 (γ) 채택이 자연스러우나, M 5개 병렬 진행 특성상 (β)도 합리적. → **Q 후보로 추가** (Sec.6 Q-NEW-1 참조).

**(B5-4) 임계값 80% — v0.6.2 사례 대비 검토 [낮음]**
v0.6.2 Stage 9 APPROVED Score = 93.8% (commit `a6ef4be`). 80% 임계값은 적정 buffer. → 유지 권고.

---

## Sec. 6. Q 후보 통합 (검토 항목 f)

### 6.1 drafter1 Q1~Q6

| Q# | 주제 | 대상 | 평가 |
|----|------|------|------|
| Q1 | M1 세션명 변수 주입 패턴 | Orc-063-dev | ✅ 유지 (Stage 5 기술 설계) |
| Q2 | M2 충돌 우선순위 해석 상세화 | Reviewer | ✅ 유지 — **본 리뷰 Sec.4 F-62-5에서 일부 답변** |
| Q3 | M3 shellcheck 엄격도 | Orc-063-dev | ✅ 유지 |
| Q4 | M4 tmux 1+3 안정성 검증 범위 | Reviewer/Orc | ✅ 유지 |
| Q5 | M5 plugin-cc 고도화 일정 | 운영자 | 🔴 **운영자 결정 필수** |
| Q6 | AC 자동화 CI/CD 추가 시점 | Orc-063-dev | ✅ 유지 |

### 6.2 drafter2 Q-PER-1~2

| Q# | 주제 | 대상 | 평가 |
|----|------|------|------|
| Q-PER-1 | 디자인팀 v0.6.4 자동 가동 트리거 | 운영 정책(후속) | 🟡 v0.6.4 영역 (본 v0.6.3 비차단) |
| Q-PER-2 | 개발팀 부 PL 필요성 | Stage 5 기술 설계 | ✅ 유지 |

### 6.3 신규 식별 Q (리뷰어 추가)

**Q-NEW-1 (Score 정책): M별 Score 통합 방식 — 평균(α) / 최소값(β) / 단일합산(γ) 중 채택**
- 출처: 본 리뷰 Sec.5.2 (B5-3)
- 의존: Stage 4 plan_final / 운영자
- 대상: **운영자 결정**
- 우선도: 🔴 높음 (Score 게이트 핵심 정책)

**Q-NEW-2 (Score 가중치): 5항목 가중치 조정안 — 30/20/20/15/15 vs 30/15/20/20/15**
- 출처: 본 리뷰 Sec.5.2 (B5-2)
- 의존: Stage 4 plan_final / 운영자
- 대상: **운영자 결정**
- 우선도: 🟡 중간

**Q-NEW-3 (F-62-x): F-62-9(claude CLI 자동화) / F-62-10(위험 명령 스크립트화) 채택 여부**
- 출처: 본 리뷰 Sec.4.2
- 의존: Stage 5 기술 설계
- 대상: Orc-063-dev / 운영자
- 우선도: 🟡 중간

**Q-NEW-4 (Schema): `.claude/settings.json` schema v0.4 → `stage_assignments.stage9_review` 키 존재 여부 검증**
- 출처: 본 리뷰 Sec.1.4 (B2-6)
- 의존: Stage 5 기술 설계
- 대상: Orc-063-dev
- 우선도: 🔴 높음 (리뷰어 conditional 분기 메커니즘 핵심)

**Q-NEW-5 (drafter 분배): v0.6.4 이후 드래프터 단일 명의 다산출물 정책 — 부 드래프터 도입 vs 세션 분리**
- 출처: 본 리뷰 Sec.2.3 [정정-1]
- 의존: v0.6.4 운영 정책
- 대상: **운영자 결정 (후속)**
- 우선도: 🟢 낮음 (본 v0.6.3 비차단)

### 6.4 통합 Q 표 (drafter1 6 + drafter2 2 + 신규 5 = **총 13건**)

| Q# | 주제 | 우선도 | 대상 |
|----|------|-------|------|
| Q1 | M1 세션명 변수 주입 패턴 | 🔴 | Orc-063-dev |
| Q2 | M2 충돌 우선순위 상세화 | 🟡 | Reviewer (일부 본 리뷰 답변) |
| Q3 | M3 shellcheck 엄격도 | 🟡 | Orc-063-dev |
| Q4 | M4 tmux 1+3 안정성 | 🟡 | Reviewer/Orc |
| Q5 | M5 plugin-cc 고도화 일정 | 🔴 | **운영자** |
| Q6 | AC 자동화 CI/CD | 🟡 | Orc-063-dev |
| Q-PER-1 | 디자인팀 v0.6.4 트리거 | 🟢 | 운영 정책(후속) |
| Q-PER-2 | 개발팀 부 PL | 🟡 | Stage 5 |
| Q-NEW-1 | Score 통합 방식(α/β/γ) | 🔴 | **운영자** |
| Q-NEW-2 | Score 가중치 조정안 | 🟡 | **운영자** |
| Q-NEW-3 | F-62-9/F-62-10 채택 | 🟡 | Orc-063-dev/운영자 |
| Q-NEW-4 | settings.json stage9_review schema | 🔴 | Orc-063-dev |
| Q-NEW-5 | drafter 분배(v0.6.4) | 🟢 | 운영 정책(후속) |

---

## Sec. 7. finalizer 통합 시 정정 영역 명시 위치 (자율 영역)

본 리뷰가 식별한 정정/보강 영역을 plan_final.md 통합 시 안영이(파이널라이저)가 적용할 위치 가이드:

| # | 영역 | 출처 | plan_final.md 적용 위치 (권고) |
|---|------|------|------------------------------|
| F-1 | drafter 단일 명의 인지 | Sec.2.3 [정정-1] | frontmatter `upstream` 또는 Sec.0 개요 |
| F-2 | M1 변경 대상 신규/개정 단일화 | Sec.1.2 (B1-2) | M1 변경 대상 표 |
| F-3 | M3 AC PostToolUse 명시 | Sec.1.2 (B1-3) | M3 AC 항목 |
| F-4 | M4 AC `wc -l` 비교 연산 정정 | Sec.1.2 (B1-4) | M4 AC 항목 |
| F-5 | F-62-9 신규 추가 | Sec.4.2 + Sec.6.3 (Q-NEW-3) | F-62-x 후보 표 |
| F-6 | F-62-8 영역 재정의 | Sec.4.1 | F-62-x 후보 표 |
| F-7 | Score 가중치 조정 (15→20 명세 정합성) | Sec.5.2 (B5-2) | Score 계산식 표 |
| F-8 | Score 정량 기준 도입 (리스크 식별) | Sec.5.2 (B5-1) | Score 항목 (3) 정의 |
| F-9 | Score M 통합 방식 결정 | Sec.5.2 (B5-3) + Q-NEW-1 | Score 계산식 + 운영자 결정 trace |
| F-10 | personas_18.md Sec.7 standby 보강 | Sec.1.4 (B2-4) | (separate doc) 또는 plan_final 부록 |
| F-11 | settings.json schema 검증 | Sec.1.4 (B2-6) + Q-NEW-4 | F-62-8 또는 Stage 5 기술 설계 |
| F-12 | brainstorm Sec.4 진행 순서 trace 보강 | Sec.3.3 (B3-2) | plan_final Sec.4 |

**총 12건 정정/보강 영역 → finalizer 안영이 통합 시 우선순위 적용**

---

## Sec. 8. 종합 판정 및 Stage 4 진입 권고

### 8.1 drafter1 (`plan_draft.md`) 종합 판정

- **강점:** 5건 (S1-1 ~ S1-5)
- **보강 권고:** 6건 (B1-1 ~ B1-6)
- **정합성 (의제→M):** 9/9 PASS (Sec.3.1)
- **F-62-x 타당성:** 4/4 채택 가능 (1건 영역 재정의, 1건 영향 보강)
- **Score 적합성:** 골격 유효, 가중치 미세 조정 + 정량 기준 도입 권고
- **종합 평가:** 🟢 **Stage 4 진입 가능** (보강 영역 12건은 finalizer가 통합 시 적용)

### 8.2 drafter2 (`personas_18.md`) 종합 판정

- **강점:** 5건 (S2-1 ~ S2-5)
- **보강 권고:** 6건 (B2-1 ~ B2-6)
- **운영자 결정 흡수:** brainstorm 의제 4 (3 sub-항목) 모두 흡수
- **종합 평가:** 🟢 **Stage 4 진입 가능** (B2-4 / B2-6은 finalizer 보강 필수)

### 8.3 Stage Transition Score 잠정 (리뷰어 추정)

본 리뷰 시점 추정치(Score 계산식 잠정 적용):

| 항목 | 가중치 | 추정 점수 | 가중 점수 |
|------|-------|---------|---------|
| AC 통과율 | 30% | 85% (자동 검증 명령 명시, 일부 미세 정정 필요) | 25.5 |
| 의존 명확성 | 20% | 95% (그래프 + critical path 명료) | 19.0 |
| 리스크 식별 | 20% | 80% (M별 1~2건, 정량 기준 보강 필요) | 16.0 |
| 명세 정합성 | 15% | 75% (신규/개정 모호 일부) | 11.25 |
| 운영자 trace | 15% | 100% (13/13 매핑) | 15.0 |
| **합계** | 100% | **86.75%** | **86.75** |

**Score ≈ 86.8% → ✅ 임계값 80% 초과 → Stage 4 (plan_final) 진입 게이트 PASS**

(본 추정치는 리뷰어 잠정. 정식 Score는 Stage 4 finalizer 또는 Stage 11 검증 시점에 산정.)

### 8.4 운영자 결정 필요 영역 (요약)

| # | 결정 사항 | Q# |
|---|---------|----|
| 1 | Score M 통합 방식 (α/β/γ 중 채택) | Q-NEW-1 |
| 2 | Score 가중치 조정안 (30/20/20/15/15 → 30/15/20/20/15) | Q-NEW-2 |
| 3 | M5 plugin-cc 고도화 일정 (v0.6.3 vs 후속) | Q5 |
| 4 | F-62-9/F-62-10 채택 범위 | Q-NEW-3 |
| 5 | drafter 분배 정책 (v0.6.4 후속) | Q-NEW-5 |

---

**마지막 라인:**

COMPLETE-REVIEWER: 475 lines, 12 보강 영역, file=docs/02_planning_v0.6.3/plan_review.md
PATCH-REVIEWER-1: drafter2 페르소나 정정 흡수 (운영자 결정 #16, drafter2=장원영)
