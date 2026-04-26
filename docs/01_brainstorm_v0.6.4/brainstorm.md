---
version: v0.6.4
stage: 1 (Brainstorming)
date: 2026-04-27
session: 27
mode: Strict
has_ui: yes
risk_level: medium
prev: v0.6.3 in progress (별개 세션 병렬 진행 중)
parallel_window: Stage 1~4 (코드 충돌 0, 신규 디렉토리 한정). Stage 5+ 진입 시그널은 운영자가 준다 (회의창 monitoring X).
---

# v0.6.4 브레인스토밍 — Jonelab AI팀 운영자 대시보드

## 0. 컨텍스트

- v0.6.4 = **첫 실전 프로젝트** = Jonelab AI팀 운영자 대시보드 (운영자 read-only 정보 가시화)
- **v0.6.3 = 별개 세션 책임 영역**. 본 세션은 v0.6.4 전용 — v0.6.3 monitoring/대기 안 함.
- 본 세션은 **Stage 1~4까지만 코드 충돌 없이 진행**. Stage 5+ 진입 시그널은 운영자가 줌.
- 잠정 spec baseline = memory `project_v064_dashboard_spec.md` (세션 26 자유토론 결정)
- 디자인팀(`Orc-064-design`) 첫 등판 버전 — Stage 6/7 UI/UX 영역 진입
- v0.6.4 디자인팀 매핑은 v0.6.3 plan_review/personas_18.md 정밀화 결과를 참조 (해당 산출물 도착 시 운영자가 본 세션에 제공)

## 1. 의제별 결정

### 의제 1 — 모드 / has_ui / risk_level
**결정: Strict / yes / medium**
- Strict — 첫 실전 프로젝트 + 디자인팀 첫 등판 + 운영자 일상 도구. Stage 6/7/11 강제 검증 필요.
- has_ui yes — textual TUI = UI 영역. Stage 6/7 + 디자인팀 spawn 자연 진입.
- risk_level medium — read-only + 로컬 단독 + 외부 노출 0. 단, capture-pane 파싱은 신중 영역.

### 의제 2 — 사용자 / 호출 / 모드 (잠정 spec 유지)
**결정: 운영자 본인만 / `/dashboard` / 인터랙티브**
- 외부 사용자 / 백실장 / 다중 운영자 = **v0.6.4 scope 외** (v0.6.5+ 이월)
- `/dashboard` 슬래시 커맨드 — jOneFlow M-Slash wrapper 위에 등록
- 인터랙티브 (실시간 자동 갱신, 종료 `q`)

### 의제 3 — 시각화 / 작업 상태 / 다중 버전 (잠정 spec 유지)
**결정: textual / working·idle 2단계 + 작업명 / 박스 안 행**
- Python `textual` (rich 위, 마우스 + 키보드, CSS-like 스타일링)
- 작업 상태 = working / idle 2단계 + working일 때 작업명(버전/과제) 한 줄
- 다중 버전 동시 = 박스 안 행으로만 구분 (별도 영역 X)
- 6~9개 행 동시 가독성 = Stage 5 visual 검증 영역

### 의제 4 — 표시 항목 (잠정 spec 유지)
**결정: 박스 3개 (기획/디자인/개발) + Pending Push/Commit + Pending Decisions(Q)**

```
╔══ 기획팀 ════════════╦══ 디자인팀 ══════╦══ 개발팀 ════════════╗
║ <페르소나> [상태]     ║                  ║                      ║
║   <버전>/<과제>       ║                  ║                      ║
║   tokens: <N>k        ║                  ║                      ║
╚══════════════════════╩══════════════════╩══════════════════════╝

┌── Pending Push/Commit ──┐  ┌── Pending Decisions (Q) ──┐
│ ⏳ <항목>                │  │ • <Q>                       │
└─────────────────────────┘  └─────────────────────────────┘
```

- 팀별 박스 3개 = 기획 / 디자인 / 개발
- 페르소나별 행 = 이름 + 상태(◉ working / ○ idle) + 작업명 + 토큰량
- Pending Push/Commit 박스 = 운영자 승인 대기 push / commit
- Pending Decisions(Q) 박스 = 운영자 결정 영역 큐

### 의제 5 — 사고 9 충돌 해소 정책 유지
**결정: 대시보드 = read-only 정보 가시화. 결정/입력은 회의창 흐름 유지**
- Pending Q "deep-link"(클릭 → 회의창 활성화) = **v0.6.5+ 이월**
- v0.6.4는 가시화에 집중. Q 큐는 표시만, 응답은 회의창에서 기존 방식 그대로.

### 의제 6 — 알림 / 상태 보존 / 운영자 주관 모드
**결정: 알림 포함 / fresh 매번 / 별도 창 운영(scope 외)**
- **알림** — Pending Q 도착 시 macOS 시스템 알림 발화 (Stage 5 기술 설계에서 osascript / Pushover / CCNotify 중 선택). read-only 가시화의 "보조 신호"라 v0.6.4 scope.
- **상태 보존** — `q` 종료 후 재진입 시 fresh (직전 상태 복원 X). 첫 버전 단순성 우선, 필요 시 v0.6.5+ 후속.
- **운영자 주관 모드** — 대시보드 + 회의창 동시 사용은 **별도 창**으로만 운영. 스플릿/탭 정책 = v0.6.4 scope 외 (운영자 자율).

### 의제 7 — Parallel Window (v0.6.3 병렬 운영)
**결정: Stage 1~4까지만 병렬, 신규 디렉토리 3개로 한정**

| 영역 | 병렬 안전 | 비고 |
|---|---|---|
| `docs/01_brainstorm_v0.6.4/` | ✅ | 본 파일 |
| `docs/02_planning_v0.6.4/` | ✅ | Stage 2~4 |
| `docs/03_design/v0.6.4_*` | ✅ | Stage 5 기술 설계 (v0.6.3 완료 후 진입) |
| 그 외 (코드 / scripts / settings.json) | ❌ | v0.6.3 완료 대기 |

- Stage 5+ 진입 시그널 = **운영자가 본 세션에 알림**. 본 세션 회의창은 v0.6.3 monitoring 하지 않음.
- Stage 4 완료 후 운영자 시그널 부재 시 = 회의 모드 유지

### 의제 8 — 마일스톤 분할 (잠정안, Stage 2~4 정밀화)

| M | 내용 | 담당 팀 | 의존 |
|---|------|---------|------|
| **M1** | `/dashboard` 슬래시 커맨드 + textual scaffold | 개발팀 (Orc-064-dev) | — |
| **M2** | 데이터 수집 layer (capture-pane 파싱 / 토큰량 / 상태 추론) | 개발팀 | M1 |
| **M3** | 박스 3개 + 행 렌더링 + 다중 버전 동시 표시 | 개발팀 + 디자인팀 (Orc-064-design 첫 등판) | M1, M2 |
| **M4** | Pending Push·Q 박스 + 알림(notification) | 개발팀 | M2 |
| **M5** | Windows 호환 검증 + 18명 페르소나 매핑 적용 | 개발팀 | M3, M4 |

#### 의존 그래프
```
M1 (scaffold) ─┬─→ M2 (data) ─┬─→ M3 (render)
               │               └─→ M4 (pending+notif)
               │
               └─→ Stage 6/7 디자인팀 invite (M3 기간 중 병렬)

M3 ──┐
M4 ──┴─→ M5 (Windows + 18명 매핑)
```

- 정밀 마일스톤 / sub-task / 검증 기준 = Stage 2~4 (Orc-064-plan)에서 도출

## 2. Stage 5 이월 영역 (기술 설계 영역)

본 brainstorm은 **무엇을 만들지(What)**에 집중하고, **어떻게(How)**는 Stage 5에서 결정한다.

| 항목 | 잠정 방향 |
|---|---|
| 데이터 수집 방식 | tmux capture-pane 파싱 / claude CLI 메타 / 페르소나 자가 보고(파일/소켓) 후보 |
| 갱신 주기 | 1~2초 잠정 (Stage 5 검토) |
| 단축키 | q(종료), r(refresh), c(clear) 잠정 |
| 색상 팔레트 / 박스 스타일 / 진행률 바 / 스파크라인 | textual CSS-like 스타일링으로 정의 |
| 알림 채널 | osascript / Pushover / CCNotify 중 선택 |
| Windows 호환 | textual cross-platform 기본. Ghostty 외 환경(Windows Terminal / WSL) 검증 필요 |
| 18명 페르소나 ↔ 박스 매핑 | v0.6.3 `plan_review/personas_18.md` 정밀화 결과 반영 |
| 디자인팀 첫 가동 절차 | `Orc-064-design` spawn 시점 = Stage 6/7 진입. dispatch 발행 정책 정밀화 |

## 3. Non-goal (v0.6.4 본 릴리스)

- 외부 사용자 / 다중 운영자 / 백실장 영역 (v0.6.5+ 이월)
- Pending Q deep-link (대시보드 → 회의창 활성화) — v0.6.5+ 후속
- 상태 보존 (직전 세션 복원) — v0.6.5+ 후속
- 대시보드 ↔ 회의창 스플릿/탭 정책 — 운영자 자율 영역
- write 영역 (대시보드에서 commit/push/결정 입력) — read-only 정책 영구 유지
- v0.6.5 외부 통합 (CI / GitHub Actions / Codex 자동화 고도화)

## 4. 다음 단계

### 4-1. Stage 1 종료 — 본 파일 commit (회의창 자율)
- `git_checkpoint.sh` 경로로 `docs/01_brainstorm_v0.6.4/brainstorm.md` 1건 commit
- 메모리 `project_v064_dashboard_spec.md`는 baseline 그대로 유지 (본 brainstorm이 상위 정의)

### 4-2. Stage 2~4 dispatch 발행 (운영자 시그널 시 진입)
- 산출물: `dispatch/2026-04-27_v0.6.4_stage234_planning.md`
- 담당: `Orc-064-plan` (PL 박지영) — M1~M5 정밀화 (M5 18명 매핑 detail은 personas_18.md 도착 후)
- 진입 절차 = `bridge_protocol.md` Sec.5 표준 절차
- 회의창 자율 영역: brief 본문 / 검증 절차 / 분담은 오케 자율

### 4-3. Stage 6/7 디자인팀 첫 등판 (이월)
- `Orc-064-design` (PL 우상호) 첫 spawn = Stage 6 진입 시점
- personas_18.md 결과(운영자 제공) 반영 후 dispatch
- **터미널 헌법 강제 (운영자 세션 27 명시 — 박지영 사고 13 재발 방지)**:
  - Orc-064-design 세션 안 split panes 4개 (오케 1 + 팀원 3)
  - 좌 = **우상호** (디자인PL/Opus/high) 큰 pane
  - 우 = 세로 stack 3: **이수지**-reviewer (Opus/high) / **오해원**-finalizer (Sonnet/medium) / **장원영**-drafter (Haiku/medium)
  - `pane-border-status top` + `pane-border-format ' #T '` + `select-pane -T <페르소나명>` 필수
  - dispatch brief에 Agent tool 분담 폐기 명시
  - bridge_protocol.md Sec.4 표 / Sec.6 사고 13 / Sec.8 자가 점검 9번 그대로 적용
- 첫 등판 회고는 v0.6.4 Stage 13 release notes에 기록

## 5. 운영자 결정 trace (세션 27)

| # | 결정 | 의제 |
|---|------|------|
| 1 | 모드 = Strict / has_ui = yes / risk_level = medium | 의제 1 |
| 2 | 잠정 spec 7개 결정 그대로 유지 (사용자/호출/모드/시각화/상태/다중/충돌) | 의제 2~5 |
| 3 | Pending Q deep-link = v0.6.5+ 이월 | 의제 5 |
| 4 | 알림 v0.6.4 scope 포함 (macOS 알림) | 의제 6 |
| 5 | 상태 보존 = fresh 매번 (v0.6.5+ 이월) | 의제 6 |
| 6 | 운영자 주관 모드 (대시보드+회의창 동시) = scope 외 | 의제 6 |
| 7 | Parallel Window = Stage 1~4 한정, 신규 디렉토리 3개 | 의제 7 |
| 8 | 마일스톤 5개 잠정안 (Stage 2~4 정밀화) | 의제 8 |
