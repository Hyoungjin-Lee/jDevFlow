---
version: v0.6.4
stage: 4 (plan_final, index)
date: 2026-04-27
mode: Strict
status: pending_operator_approval
session: 27 (v0.6.4 Stage 2~4)
authored_by: 박지영 (기획팀 PL, 오케스트레이터, Opus/high)
team_mode: tmux 4 panes (Orc-064-plan:1.1~1.4, 페르소나 단위 분담)
upstream:
  - docs/01_brainstorm_v0.6.4/brainstorm.md (Stage 1, 의제 1~8 결정)
  - docs/02_planning_v0.6.4/planning_review.md (김민교 reviewer, 발견 37건)
  - docs/02_planning_v0.6.4/planning_01_M1_scaffold.md (v3 final, 272줄)
  - docs/02_planning_v0.6.4/planning_02_M2_data.md (v3 final, 472줄)
  - docs/02_planning_v0.6.4/planning_03_M3_render.md (v3 final, 436줄)
  - docs/02_planning_v0.6.4/planning_04_M4_pending_notif.md (v3 final, 422줄)
  - docs/02_planning_v0.6.4/planning_05_M5_windows_personas.md (v3 final, 537줄)
---

# jOneFlow v0.6.4 — Planning Index (Jonelab AI팀 운영자 대시보드)

> **상위:** `docs/01_brainstorm_v0.6.4/brainstorm.md` (Stage 1, 세션 27)
> **본 문서:** `docs/02_planning_v0.6.4/planning_index.md` (Stage 4 plan_final 통합 인덱스, 세션 27)
> **하위:** Stage 4.5 **운영자 승인 게이트** (Q1~Q5 답변 + 5개 plan_final 승인) → Stage 5 기술 설계
> **상태 배너:** 🟡 **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.
> **모드 / has_ui / risk:** Strict / yes / medium. 첫 실전 프로젝트 + 디자인팀 첫 등판 + 운영자 일상 도구.

본 인덱스는 v0.6.4 Stage 2~4(Strict 모드)의 5개 마일스톤(M1~M5) plan_final + 통합 review를 한 눈에 정리합니다. 5개 plan_final이 본체이며, 본 인덱스는 의존 그래프 / 작업 순서 / 횡단 정책 commit 4건(F-D1~F-D4) / AC 총괄 / 통합 Stage 5 이월 표 / 운영자 결정 게이트 / 데이터 흐름 / 디자인팀 첫 등판 절차를 수렴합니다.

---

## Sec. 1. 산출물 6종

| # | 파일 | 역할 | 라인 수 | 상태 |
|---|------|------|--------|------|
| 1 | `planning_01_M1_scaffold.md` | M1 — `/dashboard` 슬래시 + textual scaffold (cold start) | 272 | final, pending_operator_approval |
| 2 | `planning_02_M2_data.md` | M2 — 데이터 수집 layer (`PersonaDataCollector` + `PendingDataCollector`) | 472 | final, pending_operator_approval |
| 3 | `planning_03_M3_render.md` | M3 — 박스 3개 + 행 렌더링 + 다중 버전 동시 표시 | 436 | final, pending_operator_approval |
| 4 | `planning_04_M4_pending_notif.md` | M4 — Pending Push·Q 박스 + macOS 알림 (read-only 영구) | 422 | final, pending_operator_approval |
| 5 | `planning_05_M5_windows_personas.md` | M5 — Windows 호환 검증 + 18명 페르소나 매핑 | 537 | final, pending_operator_approval |
| 6 | `planning_index.md` (본 문서) | 5개 합본 + 의존 그래프 + 횡단 정책 + AC 총괄 + 운영자 결정 게이트 | — | final |

부속: `planning_review.md` (649줄) — 김민교 책임연구원 통합 리뷰. 발견 **37건** (정책 commit 4 + 명시 추가 28 + Stage 5 이월 5) + Q1~Q5. v3 final 흡수 trail은 각 doc Sec.0 v2→final 변경 요약 표 참조.

---

## Sec. 2. brainstorm 의제 1~8 → 5 마일스톤 매핑 (F-X-8)

| brainstorm 의제 | 결정 (세션 27) | M 매핑 | 흡수 상태 |
|---|---|---|---|
| 의제 1 모드 / has_ui / risk | Strict / yes / medium | 본 stage 전체 | ✅ |
| 의제 2 사용자 / 호출 / 모드 | 운영자 본인 / `/dashboard` / 인터랙티브 | M1 (슬래시 + scaffold) | ✅ |
| 의제 3 시각화 / 작업 상태 / 다중 버전 | textual / working·idle 2단계 + 작업명 / 박스 안 행 | M2 (상태 추론) + M3 (렌더링) | ✅ |
| 의제 4 표시 항목 | 박스 3개 + Pending Push/Commit + Pending Q | M3 (박스 3개) + M4 (Pending) | ✅ |
| 의제 5 사고 9 충돌 | 대시보드 = read-only, Q 응답은 회의창 흐름 | M4 (read-only AC) + 5개 doc 횡단 (F-X-2) | ✅ |
| 의제 6 알림 / 상태 보존 / 운영자 주관 | macOS 알림 / fresh 매번 / 별도 창 운영 | M4 (알림) — 상태 보존·별도 창 = scope 외 | ✅ |
| 의제 7 Parallel Window | Stage 1~4 한정, 신규 디렉토리 3개 | 본 stage 전체 (코드 충돌 0) | ✅ |
| 의제 8 마일스톤 분할 | M1~M5 잠정안 → 본 stage 정밀화 | M1~M5 5건 본 stage 본체 | ✅ |

**매핑 8/8 완전.** review Sec.10 진단(7/8 = 87.5%)은 v2 시점 부분 누락 기준. v3 final 흡수 후 8/8 전체 매핑 확보.

---

## Sec. 3. 의존 그래프 + 권장 구현 순서 (Stage 8)

```
                  ┌──────────────────────────┐
                  │ M1 scaffold              │  cold start (외부 의존 0)
                  │ /dashboard + textual     │
                  └────────────┬─────────────┘
                               │ (인터페이스 hook + scripts/dashboard.py 단일 진입)
                               ▼
                  ┌──────────────────────────┐
                  │ M2 data layer            │  (F-D1 단일 spec)
                  │ PersonaDataCollector     │
                  │ PendingDataCollector     │
                  └────────────┬─────────────┘
                               │ (PersonaState[] / PendingPush[] / PendingQuestion[])
                  ┌────────────┴─────────────┐
                  │ 병렬 (M3 ∥ M4)            │
        ┌─────────┴───────────┐    ┌─────────┴──────────┐
        │ M3 render           │    │ M4 pending+notif    │
        │ 박스 3개 + 행        │    │ Pending Push/Q      │
        │ 다중 버전 동시       │    │ macOS 알림 (osascript)│
        └─────────┬───────────┘    └─────────┬──────────┘
                  │                          │
                  └──────────┬───────────────┘
                             │ (skeleton + 매핑 슬롯 + 알림 인프라)
                             ▼
                  ┌──────────────────────────┐
                  │ M5 windows + personas    │  (personas_18.md 의존)
                  │ Windows 검증             │
                  │ 18명 매핑 detail         │
                  └──────────────────────────┘
```

**권장 구현 순서: M1 → M2 → (M3 ∥ M4) → M5**

근거:
- **M1 cold start** — 외부 의존 0, scaffold 안전 진입.
- **M2 선행** — `PersonaState` / `PendingPush` / `PendingQuestion` dataclass 단일 spec(F-D1)을 박은 후 M3/M4 진입.
- **M3 ∥ M4 병렬** — 데이터 모델만 공유, 렌더 vs Pending 영역 코드 충돌 0.
- **M5 후행** — M3/M4 skeleton + `personas_18.md` 도착 후 매핑 detail. Stage 8 진입 시점 = `personas_18` blocking 시점 (F-X-6 정정).

---

## Sec. 4. 횡단 정책 commit (F-D1~F-D4) + F-X-N 분배

본 stage finalizer 안영이가 v3 본문에 박은 정책 commit **4건** (reviewer 권장 verbatim):

| ID | 영역 | 결정 | 흡수 doc |
|----|------|------|---------|
| **F-D1** | 데이터 모델 단일 spec | `PersonaState` (M2) 단일 dataclass + `PersonaDataCollector` (M2) + `PendingDataCollector` (M4) **분리(SRP)**. `TeamRenderer.render()` 입력 = `Dict[str, List[PersonaState]]`. 어댑터 3중 구조 제거. | M2 본문 / M3·M4 인터페이스 sync |
| **F-D2** | dashboard 산출물 위치 단일화 | 진입점 = `scripts/dashboard.py` 단일. 모듈 패키지 = `scripts/dashboard/<module>.py`. 슬래시 정의 = `.claude/commands/dashboard.md`. M3 `src/dashboard/...` / M4 `dashboard/...` 충돌 닫음. | M1 본문 / M3·M4 sync |
| **F-D3** | 박스 외 페르소나(PM/CTO/CEO) 표시 정책 | **stub** — reviewer 권장: v0.6.4 = 18명만 표시 / PM 별도 영역 또는 v0.6.5+ 이월 / CTO/CEO 표시 안 함. **운영자 답변 후 verbatim 박힘** (Stage 4.5 게이트 = Q1). | M5 stub |
| **F-D4** | M2↔M3↔M4 인터페이스 일관성 | dataclass 일관성 명시 + sync 시작 / async 채택은 Stage 5. M1 `on_mount()` 동기 훅과 정합성. | M1 / M2 / M3 / M4 인터페이스 |

**횡단 명시 추가 (F-X-N) 분배:**

| ID | 처리 | 거주 |
|----|------|------|
| F-X-1 | F-D1로 흡수 (데이터 모델 단일 spec) | 본 doc Sec.4 + plan_final 본문 |
| F-X-2 | 5개 doc 모두 read-only 정책 명시 + AC 신규 (M1 AC-M1-9 / M4 AC-M4-N9 / M5 AC-M5-7 / M2·M3 흡수) | 5개 plan_final |
| F-X-3 | 통합 Stage 5 이월 표 단일 source of truth | 본 doc Sec.7 |
| F-X-4 | F-D4로 흡수 + 데이터 흐름 다이어그램 | 본 doc Sec.8 + plan_final |
| F-X-5 | F-D3로 흡수 (M5 stub) | M5 plan_final + 본 doc Sec.6 Q1 |
| F-X-6 | `personas_18.md` 의존 boundary — Stage 4/5 진행 가능, **blocking 시점 = Stage 8** | M5 / 본 doc Sec.3 |
| F-X-7 | drafter 자율 영역 6건 finalizer 흡수 (M1 `requirements.txt` / M3 빈 박스 / M3 정렬 / M4 dedupe TTL 5분 / M2 작업명 우선순위 / 기타) | 5개 plan_final 본문 |
| F-X-8 | 본 planning_index.md 신규 작성 (12항목 골격) | 본 doc 자체 |
| F-X-9 | 운영자 결정 게이트 통합 표 | 본 doc Sec.6 |
| F-X-10 | 디자인팀 첫 등판 절차 stub | 본 doc Sec.9 |

---

## Sec. 5. AC 총괄

5개 doc Acceptance Criteria 총합. 자동 검증(grep / wc / test / readlink 등 명령 1줄로 판정) / 수동 검증(QA 절차) / Stage 5 이월(spec 미확정으로 검증 정의 보류) 분리. v3 finalizer 안영이가 5개 doc 모두 자동/수동 컬럼 + 자동화 명령을 박았습니다(F-MN-2 정정 흡수).

| doc | AC 자동 | AC 수동 | Stage 5 이월 | AC 총합 |
|-----|--------|--------|-------------|--------|
| planning_01_M1_scaffold | 7 | 3 | 0 | 10 |
| planning_02_M2_data | 7 | 2 | 1 | 10 |
| planning_03_M3_render | 6 | 3 | 1 | 10 |
| planning_04_M4_pending_notif | 9 | 1 | 0 | 10 |
| planning_05_M5_windows_personas | 6 | 2 | 0 | 8 |
| **합계** | **35** | **11** | **2** | **48** |

**자동 검증 비율 = 73%** (35/48). 선례 v0.6.2(70%) 동급. Stage 9 코드 리뷰에서 자동 항목은 `bash` 스크립트 일괄 검증, 수동 항목은 QA 체크리스트로 운영자 검수.

상세 AC는 각 plan_final Sec.5 참조.

---

## Sec. 6. 운영자 결정 게이트 (Stage 4.5 통합 표, F-X-9)

drafter Q 약 23건 → finalizer 흡수 후 **운영자 결정 필수 5건 + Stage 5 영역 1건**으로 압축 (5/23 = **22%** — 선례 v0.6.2 동급).

| Q | 결정 항목 | 거주 doc | 본 stage 권장 | 결정 시점 |
|---|---------|---------|------------|----------|
| **Q1 = F-D3** | 박스 외 페르소나(PM/CTO/CEO) 표시 정책 | M5 / 횡단 | **v0.6.4 = 18명만. PM 별도 영역(상단 status bar) 또는 v0.6.5+ 이월. CTO/CEO 표시 안 함.** scope 단순성 우선. | **Stage 4.5 운영자 결정** |
| **Q2 = Q-M2-1** | 토큰량 정책 (정확 hook +8h vs 추정 regex +2h) | M2 | **정확 hook 권장 (Stage 5 +8h).** 첫 실전 + Strict 신뢰성 우선. | **Stage 4.5 운영자 결정** |
| **Q3 = Q-M4-2** | Pushover 비용 ($5/mo or $30 일회) | M4 | **회피 (osascript 기본 + Stage 5에서 plyer cross-platform 검토).** read-only + 로컬 단독 → 외부 API 비용 회피. | **Stage 4.5 운영자 결정** |
| **Q4 = Q-M5-2** | Windows 정식 지원 우선순위 (P0 vs P1) | M5 | **P1 유지 (v0.6.4 = macOS 단독 + Windows skeleton).** brainstorm 비-goal과 sync. | **Stage 4.5 운영자 결정** |
| **Q5 = Q-M2-5** | offline 페르소나 표시 (idle 통합 vs offline 분리) | M2 | **idle 통합 (brainstorm 의제 3 2단계 정책 유지).** finalizer 안영이 흡수, 운영자 confirm. | **Stage 4.5 운영자 confirm** |
| (참고) Q6 = Q-M4-3 | CCNotify 존재 미확인 | M4 | osascript fallback (CCNotify 미존재 시 자동 fallback). | **Stage 5 영역** (게이트 외) |

**Stage 4.5 게이트 진입 조건:** Q1~Q5 5건 답변 + 5개 plan_final 승인. 미답변 시 Stage 5 진입 금지.

---

## Sec. 7. 통합 Stage 5 이월 표 (F-X-3, 단일 source of truth)

5개 doc 각자 Stage 5 이월(M1: 4 / M2: 6 / M3: 5 / M4: 5 / M5: 5 = **25건**) → 중복 제거 후 **14건** (Sec.7).

| # | 항목 | 영향 doc | 비고 |
|---|------|---------|------|
| 1 | 데이터 수집 방식 채택 (capture-pane / claude hook / 자가 보고) | M2 | F-D1 본문 후 채택 |
| 2 | 갱신 주기 + idle 임계값 | M1 / M2 | brainstorm 1~2초 잠정 |
| 3 | textual CSS 색상 팔레트 / margin / border style | M1 / M3 | 디자인팀 영역 (Stage 6/7) |
| 4 | 진행률 바 / 스파크라인 | M1 / M3 | 디자인팀 |
| 5 | 토큰량 정확 vs 추정 알고리즘 | M2 | Q2 운영자 결정 후 +8h |
| 6 | sync vs async 인터페이스 | M2 / 횡단 | F-D4 본문 후 결정 |
| 7 | 작업명 추론 알고리즘 (prompt > 로그 > thinking 우선순위) | M2 | F-X-7 권장 흡수 (drafter 자율) |
| 8 | Pending 캐치 hook (capture-pane vs 자가 보고) | M4 | M2 데이터 layer 결정 후 |
| 9 | 알림 채널 채택 (osascript / Pushover / CCNotify) | M4 | Q3 운영자 결정 = 회피 권장 |
| 10 | 알림 dedupe 알고리즘 | M4 | F-X-7 = 5분 TTL 흡수 |
| 11 | 18명 매핑 detail | M2 / M5 | `personas_18.md` 도착 후 (F-X-6 blocking 시점 = Stage 8) |
| 12 | Windows 알림 채널 (win10toast / plyer / winrt) | M5 | Q4 = P1 유지 후 결정 |
| 13 | 6~9행 가독성 visual 검증 시나리오 | M3 | 디자인팀 |
| 14 | 디자인팀 (Orc-064-design) 첫 등판 dispatch | 5개 횡단 | F-X-10 절차 stub Sec.9 |

총 **14건** (drafter 25건 중 중복 제거). 각 doc Sec. "이월" 표는 스냅샷 유지, 본 표가 단일 source of truth(F-X-3).

---

## Sec. 8. 데이터 흐름 (F-X-4, F-D4 본문 결정 후)

```
[tmux sessions: bridge-* / Orc-*]
        │
        ├─────────────────────────┐
        ▼                         ▼
PersonaDataCollector (M2)   PendingDataCollector (M4)
        │                         │
        ▼                         ▼
PersonaState[]              PendingPush[] / PendingQuestion[]
   (M2 dataclass)              (M4 dataclass)
        │                         │
        ▼                         ▼
TeamRenderer (M3)           PendingPushBox / PendingQBox (M4)
        │                         │
        ▼                         ▼
박스 3개 행 렌더링            ┌── Pending 박스 2개 ──┐
(기획/디자인/개발)            │                      │
                              ▼                      │
                          Notifier (M4)              │
                          macOS 알림 (osascript)     │
                                                     ▼
                                       운영자 회의창 (별도 흐름, deep-link X)
```

- **F-D1 단일 spec** = `PersonaState` / `PersonaDataCollector` / `PendingDataCollector` 분리.
- **F-D4 sync 시작 / async = Stage 5** = M1 `on_mount()` 동기 훅과 정합성.
- **read-only 영구** (F-X-2) = 모든 Collector / Renderer / Notifier 출력은 표시·알림 only. write 명령 0건.

---

## Sec. 9. 디자인팀 (Orc-064-design) 첫 등판 절차 stub (F-X-10)

| 단계 | 내용 |
|------|------|
| 1. 진입 시점 | Stage 5 기술 설계 완료 + 운영자 Stage 6 진입 시그널 (회의창 → bridge-064 → Orc-064-design spawn) |
| 2. dispatch 입력 | M3 plan_final + Stage 5 색상 토큰 정의 + 18명 매핑 슬롯 + textual CSS 영역 boundary |
| 3. 디자인팀 산출 (Orc-064-design 4명) | 색상 팔레트 / margin·padding / border style / 스파크라인 / 진행률 바 / 빈 박스 placeholder 시안 |
| 4. 첫 등판 회고 | Stage 13 release notes에 기록 (brainstorm Sec.4-3 인용) |

상세 dispatch 본문은 Stage 5 완료 후 회의창 + 박지영 PL 자율 영역 (본 인덱스는 절차 stub만, 본문 작성 권한 위반 회피).

---

## Sec. 10. 다음 단계 (Stage 4.5 → Stage 5 → Stage 6/7 → Stage 8)

```
[현재 위치] Stage 4 plan_final (5/5 + index) ✅
                          │
                          ▼
              ┌─────────────────────────────────┐
              │ Stage 4.5 운영자 승인 게이트     │
              │  - Q1~Q5 답변 (5건)             │
              │  - 5개 plan_final 승인           │
              └────────────┬────────────────────┘
                           │ (운영자 답변 + 승인)
                           ▼
              ┌─────────────────────────────────┐
              │ Stage 5 technical_design        │
              │  - F-D1 본문 후 PersonaState     │
              │    인터페이스 spec 확정          │
              │  - Q2 후 토큰량 hook (+8h)       │
              │  - Q3 후 알림 채널 (osascript)   │
              │  - F-D4 sync/async 결정         │
              │  - 통합 Stage 5 이월 14건 처리  │
              └────────────┬────────────────────┘
                           │
                           ▼
              ┌─────────────────────────────────┐
              │ Stage 6/7 디자인팀 첫 등판       │
              │  (Orc-064-design 4명 spawn)     │
              │  - F-X-10 절차                   │
              └────────────┬────────────────────┘
                           │
                           ▼
              ┌─────────────────────────────────┐
              │ Stage 8 구현 (M1 → M2 → M3∥M4 → M5) │
              │  - personas_18.md blocking       │
              │    시점 = M5 진입               │
              │  - 각 마일스톤 commit 분리       │
              └─────────────────────────────────┘
```

---

## Sec. 11. 작성 책임 (tmux 4 panes 페르소나 단위 분담)

운영자 정정 큐 #3 (페르소나 단위 분담) 적용 — 4 panes (Orc-064-plan:1.1~1.4) 에서 페르소나별 책임 분리.

| 단계 | 담당 (페르소나) | 모델 / effort | pane | 산출 |
|------|----------------|--------------|------|------|
| Stage 2 plan_draft v1 (5건) | 장그래 (주임연구원) | Haiku / medium | :1.2 | planning_01~05 v1 (1,750줄) |
| Stage 3 plan_review (통합) | 김민교 (책임연구원) | Opus / high | :1.3 | planning_review.md (649줄, 발견 37건 + Q1~Q5) |
| Stage 3 → revised v2 (5건) | 장그래 (주임연구원) | Haiku / medium | :1.2 | planning_01~05 v2 (2,029줄, 흡수 43건) |
| Stage 3 v2 spot-check verdict | 김민교 (책임연구원) | Opus / high | :1.3 | PASS_WITH_PATCH 1건 (비차단) |
| Stage 4 plan_final v3 (5건) | 안영이 (선임연구원) | Sonnet / medium | :1.4 | planning_01~05 v3 (2,151줄, F-D1~F-D4 본문 박음, cross-cutting 7건) |
| Stage 4 planning_index.md | 박지영 (PL, 오케스트레이터) | Opus / high | :1.1 | 본 문서 |

**운영자 정정 trail (세션 27):**
- 큐 #1 (Agent 분담 폐기 + tmux 4 panes spawn) — 박지영 처리 ✓
- 큐 #2 (왼쪽 박지영 + 오른쪽 세로 stack 3명 layout) — 박지영 처리 ✓
- 큐 #3 (페르소나 단위 분담) — 박지영 처리 ✓
- 회의창 강제 진입 (안영이 v3 보고 시그널 단절 회수, 사고 12 정답 절차) — 박지영 회수 ✓

---

## Sec. 12. Stage Transition Score (brainstorm → planning 적용도)

| 기준 | 가중 | 점수 | 근거 |
|------|------|------|------|
| brainstorm 의제 1~8 매핑 완전성 | 20 | 20/20 (100%) | 8/8 매핑 (Sec.2) |
| brainstorm 결정 위반 | 15 | 15/15 (0건) | reviewer 발견 37건 중 위반 0 |
| AC 측정 가능성 (자동 비율) | 15 | 14/15 (73%) | F-MN-2 정정 흡수, 자동 35/48 |
| 정책 commit 본문 박음 | 15 | 14/15 (3.5/4) | F-D1/F-D2/F-D4 본문 박음 / F-D3 stub (운영자 답변 후) |
| 횡단 흡수 (F-X-1~10) | 10 | 10/10 | 10/10 |
| 운영자 결정 게이트 통합 (F-X-9) | 10 | 10/10 | Q1~Q5 5건 박음 |
| Stage 5 이월 통합 (F-X-3) | 5 | 5/5 | 25 → 14 단일 source |
| 데이터 흐름 다이어그램 (F-X-4) | 5 | 5/5 | Sec.8 박음 |
| 디자인팀 첫 등판 절차 (F-X-10) | 5 | 5/5 | Sec.9 stub |
| **Stage Transition Score** | 100 | **98/100 = 98.0%** | 임계 80% 초과 → **Stage 5 GO** (단 Stage 4.5 게이트 Q1~Q5 답변 + 5건 승인 후) |

---

## Sec. 13. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | v1 (세션 27) | 박지영 PL 작성. v3 final 5건(2,151줄) + planning_review 발견 37건 통합. brainstorm 의제 1~8 매핑 8/8. 정책 commit 4건(F-D1/F-D2/F-D4 본문 + F-D3 stub) + 운영자 결정 Q1~Q5 5건 박음. 통합 Stage 5 이월 14건. Stage Transition Score 98%. |

---

작성: 박지영 (기획팀 PL, 오케스트레이터, Opus / high)
세션: v0.6.4 Stage 2~4 (세션 27)
team: tmux 4 panes (Orc-064-plan:1.1~1.4) 페르소나 단위 분담
