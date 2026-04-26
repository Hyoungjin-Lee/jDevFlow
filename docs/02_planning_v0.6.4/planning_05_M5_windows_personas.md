---
version: v0.6.4
stage: 4 (plan_final)
date: 2026-04-27
mode: Strict
status: pending_operator_approval
item: 05_M5_windows_personas
revision: v3 (final)
draft_by: 장그래 (기획팀 주임연구원, Haiku) — v1 초안 + v2 review 흡수
finalized_by: 안영이 (기획팀 선임연구원, Sonnet/medium)
final_at: 2026-04-27
upstream:
  - docs/01_brainstorm_v0.6.4/brainstorm.md (의제 8 마일스톤 M5)
  - dispatch/2026-04-27_v0.6.4_stage234_planning.md
  - docs/operating_manual.md (Sec.1 5계층 18명 조직도)
  - docs/02_planning_v0.6.4/planning_review.md (김민교 reviewer)
incorporates_review: docs/02_planning_v0.6.4/planning_review.md
incorporates_v2: 장그래 drafter v2 (revised, 세션 27 후속)
external_dependency:
  - v0.6.3 personas_18.md (별개 세션, 도착 시 매핑 detail 확정 — F-X-6 boundary: Stage 8 진입 = blocking 시점)
revisions_absorbed:
  - F-M5-1 (Sec.B2 정적 매핑 + 동적 sub-row 공존 명시 — `└` prefix, F-M3-4 sync)
  - F-M5-2 (AC-M5-3 단계 분리 — Stage 4 final skeleton vs Stage 5 진입 18명 채움)
  - F-M5-3 (Sec.4 AC 표 자동/수동 컬럼 + AC-M5-4/5/6 자동화 명령)
  - F-M5-4 (Sec.B2 박스 높이 45줄 우려 → R6 신규 등급 상승)
  - F-M5-5 (Sec.2.1 "Q1~Q3" → "Sec.9 Q1" 정정 — drafter typo)
  - F-M5-S5-1 (Stage 5 이월 유지, F-M5-Detail-1 blocking 시점 = Stage 8 박음)
cross_cutting_absorbed:
  - F-D2 (정책 commit 본문 박음 — `scripts/dashboard/...` 위치 일관성 sync)
  - F-D3 (정책 commit final 본문 박음 — 운영자 결정 인수 세션 27 Stage 4.5 게이트: 18명 박스 + PM 스티브 리 별도 상단 status bar 1행 = 19명 표시 / CTO·CEO 미표시)
  - F-X-2 (read-only 정책 5개 doc 표준 — AC-M5-7 박힘)
  - F-X-3 (Stage 5 이월 통합 표 → planning_index.md 단일 source of truth, 본 doc Sec.10은 스냅샷 유지)
  - F-X-5 (F-D3로 흡수 — PM/CTO/CEO 표시 정책)
  - F-X-6 (personas_18.md 의존 boundary — Stage 8 진입 = blocking 시점, Stage 4/5 진행 가능)
---

# v0.6.4 M5 — Windows 호환 검증 + 18명 페르소나 매핑 적용

> **상위:** `docs/01_brainstorm_v0.6.4/brainstorm.md` 의제 8 (마일스톤 M5)
> **본 문서:** Stage 4 plan_final v3 (finalizer 안영이, 운영자 승인 대기 — Stage 4.5 게이트)
> **상태:** 🟢 plan_final v4 (final-revised) — F-D3 운영자 결정 인수 (세션 27 Stage 4.5 게이트 PASS). 본문 final 박음.
> **다음:** Stage 5 기술 설계 (회의창이 Orc-064-dev 별도 spawn 진행). 박지영 PL plan 영역 책임 종료.
> **의존:** M3(박스 렌더링), M4(Pending Push·Q 박스 + 알림). v0.6.3 `personas_18.md` 도착 후 detail 적용 (Stage 8 진입 = blocking 시점, F-X-6 boundary).
> **범위:** Windows 호환 검증 기준 + 18명 페르소나 매핑 슬롯. 페르소나별 데이터 수집 detail = 스킵 가능 영역(personas_18.md 의존).

> **v3 갱신 범위 (finalizer 안영이):** v2(장그래 drafter) 위에 정책 commit 본문 결정 박음 — F-D2(위치 sync), F-D3 stub(reviewer 권장 verbatim, 운영자 답변 후 본문 verbatim 박힘 영역) + 횡단 흡수 추가 분(F-X-2 / F-X-3 / F-X-6 / F-X-5)을 박았습니다. **F-D3는 finalizer 임의 결정 영역 아님** — 본 stage는 reviewer 권장 stub만 박고, 운영자 Stage 4.5 답변 후 verbatim으로 본문 박힘 예정.

---

## Sec. 0. 목적 (v3 final 갱신)

### Sec. 0.1 v3 final 변경 요약 (finalizer 흡수)

본 v3는 v2(장그래 drafter, Stage 3 review 흡수 9건) 위에 finalizer 안영이가 정책 commit 본문 결정 + 횡단 흡수를 추가한 final 산출물입니다. 본 stage에서는 운영자 결정 게이트(Q1=F-D3 / Q2)는 reviewer 권장 stub만 박고 답변은 Stage 4.5에서 회수합니다.

| ID | 유형 | 위치 | 변경 요지 (drafter v2 → finalizer v3) |
|----|------|------|----------------------------------|
| F-M5-1 | 명시 추가 (v2 흡수 유지) | Sec.B2 | 정적 매핑 + 동적 sub-row 공존 명시 (`└` prefix, F-M3-4 sync). v3 변경 없음. |
| F-M5-2 | 명시 추가 (v2 흡수 유지) | AC-M5-3 | 단계 분리(Stage 4 final = skeleton, Stage 5 진입 = 18명 채움). v3 변경 없음. |
| F-M5-3 | 명시 추가 (v2 흡수 유지) | Sec.4 AC 표 | 자동/수동 컬럼 + AC-M5-4/5/6 자동화. v3 변경 없음. |
| F-M5-4 | 명시 추가 (v2 흡수 유지) | Sec.B2 + R6 신규 | 박스 높이 45줄 우려 → R6 P0 등급 상승. v3 변경 없음. |
| F-M5-5 | 명시 추가 (v2 흡수 유지) | Sec.2.1 | "Q1~Q3" → "Sec.9 Q1" 정정. v3 변경 없음. |
| **F-D2** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.2 변경 대상 파일 머리말** | M5 영역 코드(환경 폴백 / Windows 알림 / WSL bridge)는 M1/M3/M4와 통일된 `scripts/dashboard/...` 패키지에 위치. 본 doc은 검증 기준 영역이 주이므로 신규 코드 위치는 Stage 5 기술 설계가 본 결정에 따라 박음. |
| **F-D3 (final, 운영자 결정 인수 — 세션 27 Stage 4.5 게이트 PASS)** | **정책 commit final 본문 박음** (CTO 실장 회의창 자율 결정 + CEO 운영자 위임) | **Sec.2.1 제외 영역 + Sec.9 Q1 + Sec.B 매핑 슬롯** | **v0.6.4 대시보드 표시 페르소나 범위 = 18명 박스 + PM 스티브 리 별도 상단 status bar 1행 = 총 19명 표시. CTO 백현진 / CEO 이형진 미표시.** 운영자 결정 근거: (1) 운영자=CEO / 회의창=CTO 자기 자신 비표시. (2) PM=브릿지 라우팅 모니터링 가치 → status bar 1행으로 PM 작업 상태 가시화. (3) operating_manual.md Sec.1.2 18명 정의 위반 0건 sync — PM은 박스 외 별도 영역. **M3 layout 영향:** 박스 3개 (기획/디자인/개발) + 상단 status bar 1행 (PM 스티브 리) — Stage 5/6/7 디자인팀이 status bar 시안 반영. |
| F-X-2 | 횡단 흡수 (v2) | Sec.2 + AC-M5-7 | read-only 정책 명시 + AC-M5-7 자동 검증. v3 변경 없음. |
| F-X-3 | 횡단 흡수 (v3 finalizer) | Sec.10 머리말 | Stage 5 이월 통합 표 단일 source of truth = planning_index.md (박지영 PL 영역). 본 doc Sec.10은 M5 스냅샷 유지. |
| F-X-5 | F-D3로 흡수 (v3) | Sec.2.1 + Sec.9 Q1 | PM/CTO/CEO 표시 정책 — F-D3 stub에서 닫힘 (운영자 답변 대기). |
| F-X-6 | 횡단 흡수 (v2 boundary 명시) | Sec.5.2 + Sec.10 | personas_18.md 의존 boundary — Stage 4/5 진행 가능, Stage 8 진입 = blocking. v3 변경 없음. |
| F-M5-S5-1 | Stage 5 이월 (v2 흡수 유지) | Sec.10 | F-M5-Detail-1 blocking 시점 = Stage 8 진입 박음. v3 변경 없음. |

> **finalizer 흡수 결과 + Stage 4.5 게이트 답변 인수 (v4 final-revised, 세션 27 박지영 PL 박음):** 본 v4는 v3 위에 운영자 결정 인수를 흡수한 final 산출물입니다. 정책 commit 본문 박음 = **F-D2 본문 + F-D3 final 본문 (운영자 결정 — 18명 + PM status bar 1행 = 19명 표시 / CTO·CEO 미표시) + F-D4 본문**. 횡단 1건(F-X-3)은 planning_index 포인터. **잔존 운영자 결정 0건** (Q1=F-D3 인수 / Q2=정확 hook 인수 / Q3=osascript 기본·Pushover 회피 인수 / Q4=P1 유지 인수 / Q5=idle 통합 confirm). Stage 5 영역 = WSL 알림 fallback / Windows 알림 채널 (plyer or win10toast). 회의창 monitoring 영역 = personas_18.md 도착(F-X-6 blocking 시점 = Stage 8 진입).

### Sec. 0.2 v1 목적

M5는 **실운영 환경 다중 플랫폼 검증 + 조직도 페르소나 정밀 매핑**을 담당합니다. 운영자 일상 환경(macOS Ghostty)에서 완성된 대시보드를, Windows Terminal / WSL 등 미래 운영 환경에서도 문제없이 동작하도록 검증합니다. 동시에 v0.6.3 planning_review에서 도출된 `personas_18.md`의 페르소나별 데이터 수집 방식을 대시보드 박스 행(row)에 매핑하여, 각 페르소나 상태 가시화의 정확성을 보장합니다.

**핵심 산출:**
- Windows 호환 검증 시나리오 + 기준 + 보고서
- 18명 페르소나 매핑 슬롯 (operating_manual.md Sec.1 기준)
- 데이터 수집 방식 × 페르소나 매핑 detail (personas_18.md 도착 후)

---

## Sec. 1. 범위 (Scope)

### A. Windows 호환 검증 (자체 진행 가능)

#### 1.1 검증 환경

| 환경 | 대상 | 우선순위 | 비고 |
|------|------|---------|------|
| **1차** | macOS Ghostty | P0 (필수) | 운영자 일상 환경. 현재 M3/M4 완성 환경. |
| **2차** | Windows Terminal | P1 (향후) | Windows 운영자 환경 가능성. 미래 scope. |
| **3차** | WSL Ubuntu | P2 (fallback) | Windows 운영자가 WSL로 jOneFlow 운영 시. |

**현재 상태:** 1차(macOS)는 M3/M4 완성으로 기본 확보. M5는 2차/3차 검증 시나리오 정의 + 1차 재검증.

#### 1.2 검증 항목

각 환경에서 다음을 확인합니다.

| 항목 | 세부 내용 | 확인 대상 |
|------|---------|---------|
| **ASCII 박스 렌더링** | 테두리(╔═╗║╚╩╝) / 행 구분(─) / 모서리 일관성 | textual TUI가 각 환경의 폰트로 정확하게 렌더링하는가 |
| **색상 표현** | textual CSS-like 스타일(foreground/background/bold/dim) 적용 결과 | 색상 팔레트 일관성 (pale blue / bright yellow 등) |
| **키보드 입력** | q(종료), r(refresh), c(clear) 등 단축키 응답 | 입력 이벤트 수신 + 정상 동작 |
| **마우스 입력** | 클릭 / 드래그 / 스크롤 (design stage에서 도입 여부 결정) | 터미널 에뮬레이터 마우스 지원 수준 |
| **종료 동작** | q 입력 → 깔끔한 종료 / 화면 정리 / return-to-shell | textual exit() / context manager 동작 정상 |

#### 1.3 textual cross-platform 기본 정책

Python `textual` 라이브러리는 Linux/macOS/Windows를 모두 지원하도록 설계되었습니다. M5 검증은 **"textual이 지원한다"는 가정을 검증하되, 호환성 버그가 발견되면 Stage 5 기술 설계에서 patch 후보 평가**를 수행합니다.

- **textual 버전:** `requirements.txt`에 명시된 버전 사용 (pinned version).
- **polyfill 고려:** Windows Terminal의 ANSI 색상 미지원 → VT100 emulation 확인.
- **fallback 경로:** textual 내부 feature detection 활용. Stage 5에서 환경별 feature flag 검토.

#### 1.4 macOS 알림 ↔ Windows 알림 매핑 (후보)

M4에서 도입된 macOS `osascript` 알림은 Windows에서 동작하지 않습니다. M5에서는 **Windows 알림 후보를 조사하여 stage 5에서 채택할 방안**을 검토합니다.

| 방식 | 설명 | 장점 | 단점 | 권장도 |
|------|------|------|------|--------|
| **win10toast** | Windows 10+ 네이티브 toast | 외관 일관성 | 버전 의존, 복잡도 | P1 |
| **plyer** | Cross-platform notification 통합 | 코드 단순, 지원 광범위 | 스타일 제한 | P0 |
| **winrt** | Windows Runtime API (UWP) | 최신 기능 지원 | Python binding 부재/불안정 | P2 |
| **조건부 import** | macOS `osascript` / Windows `win10toast` / Linux skip | 각 플랫폼 최적 | 코드 분기 증가 | P1 |

**M5 scope:** 후보 조사 + Stage 5 기술 설계에서 채택 결정.

#### 1.5 WSL fallback 정책

Windows 운영자가 WSL Ubuntu 환경에서 jOneFlow를 운영하는 경우, macOS Ghostty 대신 WSL의 터미널(bash on Windows Terminal)을 사용합니다. 이 경우:

- **textual 동작:** Linux 호환성이므로 기본 지원.
- **알림 채널:** WSL에서 macOS `osascript` 불가능 → Windows native toast 활용 (plyer via WSL bridge) 또는 skip.
- **시스템 통신:** tmux capture-pane 가능 (WSL tmux 인스턴스).
- **검증 기준:** WSL Ubuntu 내 textual 기본 테스트 (2차).

**현재 운영자 환경:** macOS 단독. **향후 가능성:** Windows Terminal + WSL (v0.6.4 후속).

---

### B. 18명 페르소나 매핑 적용 (personas_18.md 의존)

#### 2.1 매핑 대상 (operating_manual.md Sec.1.2 기준)

대시보드는 다음 **18명 페르소나를 박스 3개(기획/디자인/개발) 내 행(row)으로 표시**합니다.

**기획팀 4명:**
1. 박지영 (PL) — 오케스트레이터
2. 김민교 (책임연구원) — 리뷰어
3. 안영이 (선임연구원) — 파이널리즈
4. 장그래 (주임연구원) — 드래프터

**디자인팀 4명:**
5. 우상호 (PL) — 오케스트레이터
6. 이수지 (책임연구원) — 리뷰어
7. 오해원 (선임연구원) — 파이널리즈
8. 장원영 (주임연구원) — 드래프터

**개발팀 7명:**
9. 공기성 (PL) — 오케스트레이터
10. 최우영 (책임연구원) — 백앤드 리뷰어
11. 현봉식 (선임연구원) — 백앤드 파이널리즈
12. 카더가든 (주임연구원) — 백앤드 드래프터
13. 백강혁 (책임연구원) — 프론트 리뷰어
14. 김원훈 (선임연구원) — 프론트 파이널리즈
15. 지예은 (주임연구원) — 프론트 드래프터

**별도 영역 / 미표시 (F-D3 final — 운영자 결정 인수, 세션 27 Stage 4.5 게이트 PASS):**

> **v4 final 운영자 결정 (F-D3 본문 박음, CTO 실장 회의창 자율 결정 + CEO 운영자 위임, 세션 27 Stage 4.5 게이트 PASS):** v0.6.4 대시보드 표시 페르소나 범위 = **18명 박스 + PM 스티브 리 별도 상단 status bar 1행 = 총 19명 표시**. CTO 백현진 / CEO 이형진 미표시.
>
> **운영자 결정 본문 (Q1 답변 인수):**
> - **스티브 리 (PM 브릿지):** **박스 외 상단 status bar 1행에 표시** (기획팀 박스 위, 가로 폭 전체). 근거: PM=브릿지 라우팅 모니터링 가치 → 작업 상태 / 토큰량 / 활성 Orc 라우팅 1행 가시화.
> - **백현진 (CTO 실장):** 표시 안 함. 근거: 회의창=CTO 자기 자신 비표시.
> - **이형진 (CEO):** 표시 안 함. 근거: 운영자=CEO 자기 자신 비표시 (대시보드는 운영자가 본인 작업이 아닌 팀 작업을 보는 도구).
>
> 본 결정은 operating_manual.md Sec.1.2의 18명 페르소나 정의(기획팀 4 + 디자인팀 4 + 개발팀 7) 위반 0건 sync — PM은 박스 외 별도 영역으로 분리 (Sec.1.2 박스 정의 = 4-tier Sub-team 페르소나만).
>
> **M3 layout 영향:** 박스 3개 (기획/디자인/개발) 위에 상단 status bar 1행 추가. Stage 5 기술 설계 + Stage 6/7 디자인팀 시안에서 layout 정밀화.

#### 2.2 매핑 슬롯 (박스 구조)

```
╔══ 기획팀 ════════════╦══ 디자인팀 ══════╦══ 개발팀 ════════════╗
║ 1. 박지영 [상태]      ║ 5. 우상호 [상태]  ║ 9. 공기성 [상태]    ║
║   <버전>/<과제>       ║   <버전>/<과제>   ║   <버전>/<과제>     ║
║   tokens: <N>k        ║   tokens: <N>k    ║   tokens: <N>k      ║
║                       ║                   ║                     ║
║ 2. 김민교 [상태]      ║ 6. 이수지 [상태]  ║ 10. 최우영 [상태]   ║
║   <버전>/<과제>       ║   <버전>/<과제>   ║    <버전>/<과제>    ║
║   tokens: <N>k        ║   tokens: <N>k    ║    tokens: <N>k     ║
║                       ║                   ║                     ║
║ 3. 안영이 [상태]      ║ 7. 오해원 [상태]  ║ 11. 현봉식 [상태]   ║
║   <버전>/<과제>       ║   <버전>/<과제>   ║    <버전>/<과제>    ║
║   tokens: <N>k        ║   tokens: <N>k    ║    tokens: <N>k     ║
║                       ║                   ║                     ║
║ 4. 장그래 [상태]      ║ 8. 장원영 [상태]  ║ 12. 카더가든 [상태] ║
║   <버전>/<과제>       ║   <버전>/<과제>   ║    <버전>/<과제>    ║
║   tokens: <N>k        ║   tokens: <N>k    ║    tokens: <N>k     ║
║                       ║                   ║                     ║
║                       ║                   ║ 13. 백강혁 [상태]   ║
║                       ║                   ║    <버전>/<과제>    ║
║                       ║                   ║    tokens: <N>k     ║
║                       ║                   ║                     ║
║                       ║                   ║ 14. 김원훈 [상태]   ║
║                       ║                   ║    <버전>/<과제>    ║
║                       ║                   ║    tokens: <N>k     ║
║                       ║                   ║                     ║
║                       ║                   ║ 15. 지예은 [상태]   ║
║                       ║                   ║    <버전>/<과제>    ║
║                       ║                   ║    tokens: <N>k     ║
╚══════════════════════╩══════════════════╩═════════════════════╝
```

각 행 구조:
- **이름 + 상태 표시:** `<이름> [◉ working]` 또는 `<이름> [○ idle]`
- **작업 정보:** `<버전>/<과제명>` (v0.6.4-dev / plan_draft 등)
- **토큰량 참고:** `tokens: NNk` (연세션 누적 또는 현재 세션)

> **v2 (F-M5-1 / F-M3-4 sync 흡수) — 정적 매핑 + 동적 sub-row 공존:** 본 매핑 슬롯은 페르소나 18명을 정적으로 박스 3개에 배치합니다. 동일 페르소나가 다중 버전 작업 중이면 (예: 박지영이 v0.6.3 + v0.6.4 동시), 첫 행은 일반 행으로, 2번째+는 **sub-row(`└` prefix)로 누적**하여 박스 영역 1개를 유지합니다 (brainstorm 의제 3 "박스 안 행으로만 구분, 별도 영역 X" 호환).

> **v2 (F-M5-4 / R6 신규) — 박스 높이 우려:** 위 ASCII 기준 총 높이 = 기획 12줄 + 디자인 12줄 + 개발 21줄 = **45줄**. macOS Ghostty 기본 터미널 높이(24~30줄)의 1.5~2배를 초과합니다. brainstorm 의제 3 "6~9개 행 동시 가독성" 보장 위배 가능성 → R6 신규 리스크. Stage 5 visual 검증 + 가변 높이(scroll vs collapse) 결정 권장.

#### 2.3 데이터 수집 방식 (M2 기준, personas_18.md 도착 후 detail)

**현재 후보 (M2에서 정의):**
1. **tmux capture-pane 파싱** — 각 오케 pane의 상태 추출
2. **claude CLI 메타** — 실행 중인 Claude 세션 상태(working/idle) 조회
3. **페르소나 자가 보고** — 파일/소켓 기반 상태 업로드

**M5 scope:** 각 방식과 페르소나별 최적 수집 전략을 **stage 5 기술 설계에서** 확정. M5는 **"18명 페르소나 × 3가지 수집 방식" 매트릭스**만 정의하여, persons_18.md 도착 시 매핑을 완성할 수 있도록 준비합니다.

| 페르소나 | 역할 | 데이터 수집 방식 후보 | 결정 시점 |
|---------|------|-------|---------|
| 박지영 | Orc-064-plan (PL) | capture-pane / claude CLI 메타 | Stage 5 |
| 김민교 | reviewer | 〃 | Stage 5 |
| 안영이 | finalizer | 〃 | Stage 5 |
| 장그래 | drafter | 〃 | Stage 5 |
| (기획팀 4명) | 〃 | 페르소나별 세부 최적화 = personas_18.md 참조 | Stage 5 |
| 우상호 ~ 장원영 | 디자인팀 | 〃 | Stage 5 |
| 공기성 ~ 지예은 | 개발팀 | 〃 | Stage 5 |

---

## Sec. 2. 변경 대상 파일

> **v3 finalizer (F-D2 sync):** M5 영역 신규 코드(환경 폴백 / Windows 알림 / WSL bridge)는 M1/M3/M4와 통일된 `scripts/dashboard/...` 패키지에 위치합니다. 본 doc은 검증 기준 영역이 주이므로 신규 모듈 위치(예: `scripts/dashboard/platform_compat.py` / `scripts/dashboard/wsl_bridge.py` 등)는 Stage 5 기술 설계가 F-D2 본문 결정에 따라 박습니다.

| 파일 | 작업 | 범위 |
|------|------|------|
| 대시보드 코드 (M3/M4 완성, `scripts/dashboard/...`) | Windows 호환 검증 적용 (환경별 폴백 추가) | Python 코드 + textual CSS-like 스타일 |
| `docs/02_planning_v0.6.4/` | 본 planning_05_M5 최종본 | planning doc |
| (향후 Stage 5) | Windows 알림 채널 채택 — `scripts/dashboard/notifier.py` 확장 | requirements.txt / notification 모듈 |
| (향후 Stage 5) | WSL fallback 환경변수 | .env.example / secret_loader.py |

**현재 단계 수정 사항:**
- planning_05_M5 초안 작성 (본 문서)
- planning 검증 기준 정의
- 18명 매핑 슬롯 skeleton 정의 (detail은 personas_18.md 도착 후)

### read-only 정책 (brainstorm 의제 5 영구 적용 — v2 F-X-2 흡수)

> **v2:** M5 검증 영역(Windows 호환 + 18명 매핑 적용)은 brainstorm 의제 5의 read-only 정책을 영구 적용합니다. 환경별 폴백 코드 / Windows 알림 채널 / WSL fallback 어디서도 git push / git commit / 파일 write 명령이 발생해서는 안 되며, write 영역 진입 신호 발견 시 즉시 Stage 4 review 회귀 대상이 됩니다. 자동 검증은 AC-M5-7 신규 항목(M4 AC-M4-N9 패턴 인용).

---

## Sec. 3. 단계별 작업 분해

### 3.1 Part A — Windows 호환 검증 기준 수립

#### A1. 환경별 검증 체크리스트

**1차 (macOS Ghostty) — 현재 기본:**
- [ ] textual TUI 기동 성공
- [ ] ASCII 박스 테두리 정상 렌더링 (╔═╗ 등)
- [ ] textual CSS-like 색상 적용 확인 (foreground/background)
- [ ] q 입력 → 종료 / r 입력 → 새로고침 정상 동작
- [ ] 종료 후 shell prompt 정상 반환
- [ ] 다중 버전 행 동시 표시 (6~9개 행) 가독성 확인

**2차 (Windows Terminal) — 미래 환경:**
- [ ] textual TUI 기동 시도 (Python 3.x + textual 설치)
- [ ] ASCII 렌더링 문제 (encoding 이슈 → UTF-8 확인)
- [ ] ANSI 색상 적용 (Windows Terminal은 기본 지원, VT100 emulation)
- [ ] 키보드 입력 응답 (q, r, c 정상 동작)
- [ ] 종료 후 shell 상태 정상

**3차 (WSL Ubuntu) — fallback 경로:**
- [ ] WSL 내 textual 설치 및 기동
- [ ] Ubuntu 터미널 폰트 (monospace 확인)
- [ ] macOS와 동일 검증 항목 수행

#### A2. 호환성 버그 분류

발견 시 다음 기준으로 분류하여 Stage 5 기술 설계로 올립니다.

| 심각도 | 분류 | 예시 | 조치 |
|--------|------|------|------|
| **Critical** | 기동 불가 / 완전 오류 | textual import fail / 강제 종료 | 즉시 patch 또는 폴백 구현 (Stage 5) |
| **Major** | 기능 손상 | 색상 미표시 / 입력 미응답 | Stage 5 patch 후보, 우선순위 높음 |
| **Minor** | 미학적 이슈 | 박스 모양 약간 어색 / 폰트 mismatch | Stage 5 미래 개선 (v0.6.5+) |

#### A3. cross-platform feature detection

textual 내부의 환경 감지 메커니즘 확인:

```python
# 예상 구현 (Stage 5 기술 설계에서 정밀화)
from textual.pilot import Pilot
from textual import get_app

app = get_app()
terminal_info = app.driver.legacy_windows  # Windows Terminal 감지
ansi_color_support = app.driver.palette  # ANSI 색상 지원
```

M5 scope: 후보 메커니즘 조사. Stage 5에서 실제 적용.

---

### 3.2 Part B — 18명 페르소나 매핑 슬롯 정의

#### B1. 데이터 수집 × 페르소나 매핑 매트릭스

v0.6.3 `personas_18.md`이 도착하면, 다음 매트릭스를 완성합니다. **M5 draft stage는 skeleton만 제공:**

```
┌─────────────────────────────────────────────────────────────────┐
│ 18명 페르소나 × 데이터 수집 방식 매핑 (Stage 5 확정)             │
├─────────────────┬──────────────┬──────────────┬─────────────────┤
│ 페르소나        │ 역할         │ 수집 방식    │ 행 형식         │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ 박지영          │ Orc-064-plan │ (M2 후보)    │ 이름 [상태]     │
│ 김민교          │ reviewer     │ (M2 후보)    │ 버전/과제       │
│ ...             │ ...          │ ...          │ tokens: Nk      │
└─────────────────┴──────────────┴──────────────┴─────────────────┘
```

**M5 현재 상태:** skeleton 제공. **M5 final (Stage 4에서):** personas_18.md 도착 후 detail 채우기.

#### B2. 매핑 슬롯 레이아웃

박스 3개 내 행 배치:
- **기획팀:** 4행 고정 (이름 4명)
- **디자인팀:** 4행 고정 (이름 4명)
- **개발팀:** 7행 가변 (백앤드 4명 + 프론트 3명)

각 행 높이: **3줄 (이름 + 버전/과제 + 토큰량)**

총 높이: 기획 12줄 + 디자인 12줄 + 개발 21줄 = **45줄** (브라우저 스크롤 가능, 또는 레이아웃 최적화 stage 5)

#### B3. 상태 표시 기준

각 페르소나 상태:
- **◉ working:** 현재 작업 중 (활성 claue 세션 또는 tmux pane 점유)
- **○ idle:** 대기 중 (최근 활동 없음)

상태 추론 로직 (M2 기술 설계에서 정의, M5는 후보만):
1. claude CLI 메타 조회 → `working` / `idle` 직접 감지
2. tmux capture-pane 파싱 → prompt 상태 추론
3. 시간 기반 추론 → 마지막 활동 시간과 갱신 주기 비교

---

### 3.3 Part C — Pending Q 박스 내 매핑

Pending Decisions(Q) 박스는 **페르소나별 Q 큐를 추적**할 수 있도록 설계합니다 (향후):

```
┌─ Pending Decisions (Q) ──────┐
│ • [기획팀] Q1: M1 범위       │
│ • [개발팀] Q2: Windows 알림   │
│ • [운영자] Q3: 다중 운영자   │
└──────────────────────────────┘
```

**M5 현재 scope:** Q 큐 구조만 정의. **Stage 5/6에서:** 페르소나별 Q 추적 로직 구현.

---

## Sec. 4. AC (Acceptance Criteria)

> **v2 (F-M5-2 + F-M5-3 + F-X-2 흡수):** "측정: 자동/수동" 컬럼 명시. AC-M5-3 단계 분리(Stage 4 final = skeleton, Stage 5 진입 = 18명 채움). AC-M5-4/5/6 자동화 명령 박음. AC-M5-7 신규(read-only 정책 자동 검증).

| AC ID | 기준 | 측정 | 측정 명령/방법 |
|-------|------|------|-------------|
| **AC-M5-1** | Windows 호환 검증 기준 수립. 환경별(macOS / Windows Terminal / WSL) 체크리스트 4개 항목 이상 정의. | 수동 | 본 planning doc Sec.3.1 체크리스트 visual 검사 |
| **AC-M5-2** | 18명 페르소나 매핑 슬롯 정의. 박스 3개(기획/디자인/개발) 내 이름 순서 + 행 형식(이름/버전/토큰) 정확성. | 자동 | `grep -cE "박지영\|김민교\|안영이\|장그래\|우상호\|이수지\|오해원\|장원영\|공기성\|최우영\|현봉식\|카더가든\|백강혁\|김원훈\|지예은" docs/02_planning_v0.6.4/planning_05_M5_windows_personas.md` ≥ 18 |
| **AC-M5-3a** (Stage 4 final 시점, **v2 F-M5-2 분리**) | 데이터 수집 × 페르소나 매트릭스 skeleton presence. 최소 3가지 수집 방식 × 3팀 매트릭스 테이블 골격 제공. | 수동 | Sec.3.2 Part B 매트릭스 테이블 골격 presence |
| **AC-M5-3b** (Stage 5 진입 시점, **v2 F-M5-2 분리**) | personas_18.md 도착 후 18명 전체 매트릭스 채움 (group placeholder 회수). | 자동 | personas_18.md 도착 후 매트릭스 18행 모두 채워짐 grep 검증 |
| **AC-M5-4** | Windows 알림 후보 조사. 최소 3가지 방식(win10toast / plyer / winrt) 비교 테이블 작성. | 자동 | `grep -cE "win10toast\|plyer\|winrt" docs/02_planning_v0.6.4/planning_05_M5_windows_personas.md` ≥ 3 (**v2 자동화**) |
| **AC-M5-5** | WSL fallback 정책 명문화. WSL 환경에서 textual/tmux/알림 채널 동작 기준 정의. | 자동 | `grep -A 5 "WSL fallback" docs/02_planning_v0.6.4/planning_05_M5_windows_personas.md \| wc -l` ≥ 3 (**v2 자동화**) |
| **AC-M5-6** | 운영자 결정 영역 명시. "PM 브릿지/CTO/CEO 표시 정책" + "Windows 정식 지원 우선순위" + "WSL 알림 fallback" = Q1~Q3 게이트 명시. | 자동 | `grep -cE "Q[1-3]" docs/02_planning_v0.6.4/planning_05_M5_windows_personas.md` ≥ 3 (**v2 자동화**) |
| **AC-M5-7** (v2 신규, F-X-2) | read-only 정책 자동 검증. M5 영역 코드(환경 폴백 / Windows 알림 / WSL bridge) 어디에도 write 명령(git push / git commit / open with mode 'w') 0건. | 자동 | `grep -cE "git push\|git commit\|open\(.*['\"]w['\"]" scripts/dashboard/notifier.py scripts/dashboard/*platform*.py 2>/dev/null \| awk -F: '{s+=$2} END{print s+0}'` = 0 |

---

## Sec. 5. 의존성

### 5.1 내부 의존성

| 의존 | 방향 | 설명 |
|------|------|------|
| **M3 (박스 렌더링)** | 선행 필수 | M5 Windows 호환 검증의 대상은 M3 완성된 박스 렌더링. M3 미완료 시 M5 검증 불가. |
| **M4 (Pending Push·Q + 알림)** | 선행 필수 | M5의 "Windows 알림 후보" 평가는 M4의 macOS 알림 구현 완료 후 |
| **M2 (데이터 수집)** | 참조 | M2에서 정의한 3가지 수집 방식을 M5 매핑 매트릭스에서 활용 |

### 5.2 외부 의존성 — v2 (F-X-6 boundary 박음)

| 의존 | 소스 | 도착 시점 | 영향 |
|------|------|---------|------|
| **personas_18.md** | v0.6.3 별개 세션 | Stage 3~4 (M5 plan_review 이후) | M5 final에서 18명 페르소나별 데이터 수집 detail 매핑 완성. dispatch Sec.6 중단 조건 #2. |

> **v2 (F-X-6 흡수) — personas_18.md 의존 boundary:**
> - **Stage 4 final 진행 가능** (skeleton presence — AC-M5-3a)
> - **Stage 5 기술 설계 진행 가능** (보강 항목만, blocking 없음)
> - **Stage 8 구현 직전 매핑 detail 채움 = blocking 시점** (AC-M5-3b)
>
> 즉 personas_18.md 도착 전에도 본 v0.6.4의 Stage 4 / Stage 5는 진행 가능합니다. blocking 시점은 Stage 8 진입으로 박힙니다 (Sec.10 F-M5-Detail-1 정정 — v1의 P0 "blocking" 표기는 Stage 8 한정 영역으로 boundary).

### 5.3 다른 planning 항목과의 관계

- **planning_01_M1 (scaffold)** — 별도, 관계 없음
- **planning_02_M2 (data)** — M5에서 M2 후보 수집 방식 참조
- **planning_03_M3 (render)** — M5에서 M3 렌더링 결과를 Windows 호환 검증
- **planning_04_M4 (pending_notif)** — M5에서 알림 채널(macOS vs Windows) 평가
- **planning_index** — M5 포함 5개 마일스톤 통합 인덱스

---

## Sec. 6. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 |
|----|--------|-----------|--------|------|
| **R1** | Windows Terminal 미지원 환경 → ANSI 색상 rendering 실패 | 중 | 중 | textual 내부 feature detection 확인 (app.driver.palette). Stage 5에서 환경별 palette 폴백 구현 (grayscale / 256-color 대안). |
| **R2** | WSL tmux → Windows host 간 통신 지연 → capture-pane 파싱 오류 | 중 | 낮음 | M2에서 timeout 기준 설정. M5에서 WSL 환경 갭 문서화. Stage 5 기술 설계에서 WSL bridge 별도 모듈화. |
| **R3** | personas_18.md 지연 → M5 18명 매핑 detail 미완성 | 높음 | 중 | dispatch Sec.6 중단 조건 #2 명시. M5 draft는 skeleton + 스킵 가능 영역 표시. M5 final은 persons_18.md 도착 후 진행 (수동 gate). |
| **R4** | PM 브릿지 / CTO / CEO 표시 정책 미정 → 매핑 슬롯 모호 | 중 | 중 | Sec.8 Q1~Q3 운영자 결정 게이트 명시. M5 final 전 운영자 확인 필수. |
| **R5** | 대시보드 박스 높이(45줄) → 스크롤/레이아웃 복잡도 증가 | 낮음 | 중 | Stage 5 visual 검증에서 UI/UX 팀과 조정. M5는 후보 레이아웃만 제시. |
| **R6** (v2 신규, F-M5-4 흡수) | **박스 높이 45줄 = macOS Ghostty 기본 터미널 높이(24~30줄) 1.5~2배 초과** → "한눈에" 안 보임. brainstorm 의제 3 "6~9개 행 동시 가독성" 보장 위배 가능성. | **높음** (R5에서 등급 상승) | **높음** | Stage 5 visual 검증에서 가변 높이(scroll vs collapse) 결정 필수. F-X-4 데이터 layer ↔ 렌더 인터페이스와 한 묶음. M5 final 또는 Stage 5 진입 시 우선 영역. |

---

## Sec. 7. 자율 영역 (회의창 사전 결정 X)

- Windows Terminal 환경 실제 테스트 장비 확보 방식 (가상머신 / remote desktop / CI 환경)
- WSL Ubuntu 버전 선택 (WSL2 + Ubuntu 22.04 / 24.04 등)
- 토큰량 표시 단위 (bytes / tokens / k단위 / 반올림 기준)
- 상태 갱신 주기 (M2에서 결정된 값 재확인)
- Pending Q 큐 크기 제한 (무한 스크롤 vs 고정 높이)

---

## Sec. 8. 중단 조건 (운영자 결정 영역)

다음 발생 시 회의창에 📡 status로 즉시 보고하고 일시 정지:

1. **PM 브릿지 / CTO / CEO 표시 정책 미정** (Q1)
   - M5 매핑 슬롯이 18명으로 정해졌으나, **스티브 리(PM) / 백현진(CTO) / 이형진(CEO)의 표시 여부**가 정책 미정. 각각:
     - 스티브 리: 박스 외 별도 hint 추가? (예: "Bridge 활성화")
     - 백현진: 표시하지 않음 (Cowork 영역, scope 외)?
     - 이형진: 표시하지 않음 (운영자 본인)?

2. **Windows 정식 지원 우선순위** (Q2)
   - M5 검증이 "미래 가능성"(P1/P2) 정도이나, **운영자가 Windows 환경으로 전환 계획**이 있다면 우선순위 상향 검토 필요.
   - 현재: P0 = macOS, P1 = Windows Terminal, P2 = WSL.

3. **v0.6.3 personas_18.md 의존** (dispatch Sec.6 #2) — **v2 (F-X-6 boundary 정정):**
   - M5 18명 매핑 detail은 v0.6.3 `personas_18.md` 도착 후.
   - **본 M5 draft는 매핑 슬롯 + 검증 기준까지만 진행. detail은 별도 표시(스킵 가능 영역).**
   - **v2 boundary:** Stage 4 final / Stage 5 기술 설계 = 진행 가능, **Stage 8 진입 = blocking 시점**. v1의 무조건 blocking 표기 정정.

4. **WSL 환경 macOS 알림 fallback 정책 미정** (Q3)
   - WSL에서 macOS `osascript` 불가능 시 대체 방안:
     - 알림 skip?
     - Windows native toast (plyer)?
     - WSL-host bridge (복잡도 증가)?

---

## Sec. 9. 열린 질문 (Stage 3 plan_review + 운영자 결정) — v2 reviewer 분류

> **v4 final 분류 (세션 27 Stage 4.5 게이트 PASS):**
> - 운영자 결정 게이트(Stage 4.5): Q1(F-D3) ✅ 답변 인수 / Q2 Windows ✅ 답변 인수
> - Stage 5 기술 설계: Q3
> - 회의창 monitoring(본 doc 영역 외): Q4

| Q | 질문 | 답변 / 책임 | 시점 |
|---|------|------------|------|
| **Q1** (F-D3 final) | PM 브릿지(스티브 리) / CTO 실장(백현진) / CEO(이형진) 대시보드 표시 정책. | ✅ **답변 인수 (세션 27 Stage 4.5 게이트 PASS):** 18명 박스 + PM 스티브 리 별도 상단 status bar 1행 = **19명 표시** / CTO·CEO 미표시. | **PASS (게이트 통과)** |
| **Q2** | Windows Terminal 정식 지원을 v0.6.4에서 수행할지, 미래(v0.6.5+)로 미룰지. | ✅ **답변 인수 (세션 27 Stage 4.5 게이트 PASS):** **P1 유지** — v0.6.4 = macOS 단독 + Windows skeleton. Windows 정식은 v0.6.5+. brainstorm 비-goal sync. | **PASS (게이트 통과)** |
| **Q3** | WSL 환경에서 알림 채널(plyer / skip / WSL bridge) 정책 | Stage 5 기술 설계 — Windows = plyer or win10toast 검토 (운영자 답변: Q3=Pushover 회피·osascript 기본 sync). | Stage 5 |
| **Q4** | personas_18.md 도착 일정 (v0.6.3 병렬 진행) — **F-X-6:** 도착 일정과 무관하게 Stage 4/5 진행 가능. blocking은 Stage 8 진입에서만. | 회의창 monitoring (본 doc 영역 외) | 비-blocking |

---

## Sec. 10. Stage 5 이월 표

> **v3 (F-X-3 통합 표 finalizer 흡수):** 본 doc Sec.10은 M5 스냅샷으로 보존하며, 5개 doc 합산 통합 Stage 5 이월 표는 **`planning_index.md` 단일 source of truth**(박지영 PL 영역)로 수렴합니다. F-M5-Detail-1 blocking 시점 = Stage 8 진입으로 정정(F-X-6 sync) — Stage 4 final / Stage 5 기술 설계는 personas_18.md 도착 전에도 진행 가능.

| 이월 ID | 내용 | 담당 | 우선순위 |
|--------|------|------|---------|
| **F-M5-Tech-1** | Windows Terminal / WSL 환경 실제 검증 스크립트 작성 + 자동화 | Stage 5 기술설계 (오케) | P1 |
| **F-M5-Tech-2** | Windows 알림 채널 채택 (win10toast / plyer / skip) + requirements.txt 반영 | Stage 5 기술설계 | P1 |
| **F-M5-Tech-3** | textual cross-platform feature detection 구현 (환경별 폴백) | Stage 5 기술설계 | P1 |
| **F-M5-Detail-1** | personas_18.md 도착 후 → 18명 매핑 detail 확정 (수집 방식 × 페르소나). **v2 (F-X-6 boundary):** blocking 시점 = **Stage 8 진입** (Stage 4 final / Stage 5 진행 가능). | Stage 8 진입 직전 (M5 implementation) | P0 (Stage 8 blocking) |
| **F-M5-Stage5-UI** | 개발팀 대시보드 박스 높이(45줄) 시각적 최적화 검토 (Stage 5 → 디자인팀). **v2 (F-M5-4 / R6 신규):** 우선순위 P2 → **P0 (운영자 가시성)**. | Stage 5 visual + Stage 6/7 UX | **P0 (R6 신규)** |

---

## Sec. 11. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | v1 draft (장그래, 기획팀 주임) | M5 기본 구조 + Windows 호환 검증 기준 + 18명 매핑 skeleton. personas_18.md 의존 영역 명시. Q1~Q3 운영자 결정 게이트. |
| 2026-04-27 | v2 revised (장그래 drafter, 세션 27 후속) | Stage 3 plan_review 흡수 9건 (F-M5-1~5 + F-X-2/F-X-6 + F-D3 후보 + F-M5-S5-1 boundary 정정). AC 6 → 8건(AC-M5-3 단계 분리 + AC-M5-7 read-only 신규). R6 신규(박스 높이 45줄, P0 등급 상승). F-M5-Detail-1 blocking 시점 = Stage 8 박음. F-D3(PM/CTO/CEO 표시) 운영자 결정 게이트 명시. |
| 2026-04-27 | **v3 final** (안영이 finalizer, 기획팀 선임연구원 Sonnet/medium) | v2 위에 정책 commit 본문 결정 박음 — **F-D2** Sec.2 머리말(M5 신규 코드 위치도 `scripts/dashboard/...` 패키지로 sync), **F-D3 stub** Sec.2.1 제외 영역(reviewer 권장 verbatim 박음 — 18명만 표시 / PM 별도 영역 또는 v0.6.5+ / CTO·CEO 표시 안 함, **operating_manual.md Sec.1.2 18명 정의 위반 0건 sync**, 운영자 답변 후 본문 verbatim 박힘 영역 명시). 횡단 흡수: F-X-3 Sec.10 머리말(planning_index 통합 포인터), F-X-5 → F-D3 stub으로 닫힘, F-X-6 boundary 명시. 잔존 운영자 결정 = Q1 F-D3(Stage 4.5) + Q2 Windows 우선순위(Stage 4.5). status: pending_operator_approval. plan_draft 5종은 Stage 2 스냅샷 보존. |
| 2026-04-27 | **v4 final-revised** (박지영 PL, 기획팀 PL Opus/high) | Stage 4.5 운영자 결정 게이트 답변 인수 (CTO 실장 회의창 자율 결정 + CEO 운영자 위임, 세션 27): **F-D3 stub → final 본문 박음** = 18명 박스 + PM 스티브 리 별도 상단 status bar 1행 = 19명 표시 / CTO·CEO 미표시. M3 layout 영향 명시(박스 3개 + status bar 1행, Stage 5/6/7 디자인팀 시안 반영). Q2 Windows P1 유지 답변 인수. 잔존 운영자 결정 0건. status: ✅ Stage 4.5 게이트 PASS → Stage 5 GO. |

---

## Sec. 12. 요약 (Summary)

**M5 = Windows 호환 검증 + 18명 페르소나 매핑 적용**

**A. Windows 호환 검증:**
- 환경 3가지(macOS / Windows Terminal / WSL) 체크리스트 정의
- textual cross-platform 기본 정책 + feature detection
- macOS 알림 ↔ Windows 알림(win10toast / plyer) 후보 평가 (Stage 5 채택)
- WSL fallback 정책 기본 정의

**B. 18명 페르소나 매핑:**
- operating_manual.md Sec.1의 18명을 박스 3개 행으로 매핑
- 데이터 수집 × 페르소나 매트릭스 skeleton (persons_18.md 도착 후 detail)
- PM / CTO / CEO 표시 정책 = Q1~Q3 운영자 결정

**C. 의존:**
- M3/M4 선행 필수
- v0.6.3 personas_18.md 도착 후 detail 적용 (dispatch Sec.6 중단 조건 #2)

**D. AC/리스크:**
- AC 6건 (검증 기준 + 매핑 슬롯 + 매트릭스 + 알림 후보 + WSL 정책 + 운영자 Q)
- R1~R5 (색상 렌더링 / WSL 통신 / personas 지연 / 정책 미정 / 박스 높이)

---

**v1 초안 완료. 280줄. AC 6건. Q 3건(+Q4 personas_18 도착). 매핑 detail = persons_18.md 의존(스킵 영역 명시).**
