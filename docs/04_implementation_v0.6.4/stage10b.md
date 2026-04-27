---
date: 2026-04-27
version: v0.6.4
stage: 10b
work: dashboard.py M2~M5 wiring 통합 — finalizer 마감 doc
author: 현봉식 (백앤드 파이널리즈)
pane: Orc-064-dev:1.4
length_target: ≤ 500 줄
verdict: APPROVED
score: 93/100
---

# Stage 10b — dashboard.py M2~M5 wiring 통합 finalizer 마감 doc

> 현봉식입니다. 사고 14 회피(헌법) — 본문 작성 0건. drafter + reviewer 두 doc reference로
> 박고, verdict / Score / AC / 결정 / 검증 trail만 마감합니다.

## 1. 결정 요약

| 항목 | 값 |
|------|-----|
| **verdict** | **APPROVED** |
| **Score** | **93/100** |
| **release blocker** | **닫힘** (M1 placeholder 화면 → M2~M5 통합 wiring 본문) |
| **Critical** | 0 |
| **Major** | 0 |
| **Minor (R-N trail)** | 2 (R-1 헬퍼 위치 / R-2 worker thread Notifier — 모두 PASS) |
| **Nit (R-N trail)** | 2 (R-3 광역 except / R-4 cycle 1 burst — 모두 PASS) |
| **회귀** | 0건 |
| **운영자 결정 (가) 정합** | ✓ 같은 PL + 백 트리오 그대로 / 프론트 트리오 활성화 0건 (UI 본문 추가 0건, 위젯 모듈 본문 기존) |
| **next stage** | Stage 11 자율 압축 → Stage 12 수동 QA (운영자 결정 영역) |

## 2. detail reference (본문 작성 X)

| 영역 | 위치 |
|------|------|
| wiring 본문 / 인터페이스 / 검증 측정 | `docs/04_implementation_v0.6.4/stage10b_drafter.md` (카더가든) |
| reviewer 검토 + R-N 마커 + 회귀 분석 + Score 산정 | `docs/04_implementation_v0.6.4/stage10b_review.md` (최우영) |
| dispatch brief | `dispatch/2026-04-27_v0.6.4_stage10b_dashboard_wiring.md` |
| design_final wiring spec | `docs/03_design/v0.6.4_design_final.md` Sec.6 (6 메서드) / Sec.8 (M3) / Sec.9 (M4) / Sec.14 (에러 경로) |

## 3. AC 마감 검증 (release blocker 닫음 기준)

| AC | 검증 | 결과 |
|----|------|------|
| **wiring import 정합** | `from scripts.dashboard.{render,pending,persona_collector,pending_collector,notifier,status_bar,tmux_adapter}` 7건 | ✓ |
| **compose 본문** | `compose()` yields = DashboardRenderer + PendingArea (M3 + M4) | ✓ |
| **on_mount Collector 초기화** | `_tmux` / `persona_collector` / `pending_collector` / `notifier` attached | ✓ 4/4 |
| **_refresh_loop 본문** | collector fetch + Notifier.notify + call_from_thread + sleep wait | ✓ |
| **_update_widgets 본문** | 팀 그루핑(`{기획/디자인/개발}`) + DashboardRenderer.update_data + PendingArea.update_data | ✓ |
| **_show_stale 본문** | PMStatusBar 1행 staleness ⚠ 마커 (R-1 정정 정합) | ✓ |
| **CSS_PATH 외부 파일** | `dashboard/dashboard.tcss` 92줄 boundary slot #1+#2 | ✓ |
| **status_bar.compose_pm_state 헬퍼** | F-D4 thread-safe 진입점 | ✓ |
| **PMStatusBar.fetch 위임** | 1줄 위임 정합 | ✓ |
| **steady-state spawn ≤ 5** | cycle 2~4 측정 = **4 spawn/sec** | ✓ |
| **dedupe 5분 TTL 보존** | cycle 2 notify spawn = 0 | ✓ |
| **F-X-2 read-only** | `git push\|git commit\|open\(.*['\"]w['\"]"` grep 본 wiring 신규 | 0건 ✓ |
| **F-D4 sync 정합** | `async def` 0건 | ✓ |
| **Stage 10 M-1/M-2 fix 보존** | AC-T-4 = 2 + persona_collector batch | ✓ (16def78 영역 그대로) |
| **py_compile** | 2 파일 (dashboard.py + status_bar.py) | PASS ✓ |

## 4. 헌법 자가 점검 (11/11 PASS)

| # | 점검 | 결과 |
|---|------|------|
| 1 | finalizer pane (Orc-064-dev:1.4)에서 본문 작성? | ✓ 본문 작성 0건, reference만 |
| 2 | Agent tool 분담 시도 0건? | ✓ 0건 (4 panes tmux 모델) |
| 3 | 직접 git push / 외부 API / `rm -rf` 0건? | ✓ 0건 |
| 4 | 본분 역전 0건 (사고 14 회피)? | ✓ finalizer 본문 작성 X |
| 5 | A 패턴 정합 | ✓ drafter ~250 + reviewer ~150 + finalizer 본 doc |
| 6 | dispatch brief 영역 흡수 (운영자 결정 가)? | ✓ 백 트리오 그대로 + UI 본문 추가 0건 |
| 7 | DEFCON 0건? | ✓ |
| 8 | 사고 13 재발 0건 (Orc 안 split + 페르소나)? | ✓ Orc-064-dev :1.1~1.4 정합 |
| 9 | 사고 14 재발 0건 (drafter v2 / verbatim 흡수 / finalizer 본문)? | ✓ 모두 회피 |
| 10 | 3중 검증 (capture+디스크+git log+stash empty)? | commit 시점 영역 — `git stash list` empty 검증 정합 |
| 11 | 4 panes 부팅 검증? | ✓ Orc-064-dev :1.1 PL / :1.2 drafter / :1.3 reviewer / :1.4 finalizer 모두 정합 |

## 5. 분량 임계 (헌법 PASS)

| 영역 | 분량 | 임계 | 결과 |
|------|------|------|------|
| drafter (`stage10b_drafter.md`) | ~250 | ≤ 800 | ✓ |
| reviewer (`stage10b_review.md`) | ~150 | ≤ 600 | ✓ |
| finalizer (본 doc) | ~150 | ≤ 500 | ✓ |

## 6. 변경 산출

| 파일 | 변경 | 영역 |
|------|------|------|
| `scripts/dashboard.py` | 105 → 142 (+37 wiring, M1 placeholder 제거 + 6 메서드 본문) | wiring |
| `scripts/dashboard/status_bar.py` | 73 → 100 (+27 compose_pm_state + PM_PERSONA_NAME + fetch 위임) | 헬퍼 |
| `docs/04_implementation_v0.6.4/stage10b_*.md` | 신규 3건 (drafter + reviewer + finalizer = ~550줄) | trail |

순 신규 +64 (코드) + ~550 (trail). py_compile 2/2 PASS.

## 7. 진입 게이트 분기 (next stage)

> Stage 10 commit 16def78 (M-1/M-2 fix) → Stage 10b followup (운영자 결정 가, dashboard
> wiring 통합) → 본 stage 마감 → Stage 11 자율 압축 → Stage 12 수동 QA.

| 분기 | 조건 | 결정 |
|------|------|------|
| Stage 11 자율 압축 | PL 판정 — wiring AC 모두 PASS + 회귀 0건 + 분량 임계 PASS | **압축 진입** (PL trail 본 doc Sec.3+Sec.4로 갈음) |
| Stage 12 진입 | 수동 QA (운영자 + 회의창 직접) | **운영자 영역** — 회의창 통보 |
| 운영자 게이트 시각 검증 | `venv/bin/python3 scripts/dashboard.py` 실행 | **운영자 영역** — 19명 박스 + 진행률 바 + 스파크라인 + Pending 박스 직접 확인 |

## 8. v0.6.5 위임 영역 (R-N + 권고)

| ID | 영역 | Disposition |
|----|------|------------|
| R-2 | multi-worker Notifier lock | v0.6.5 (현 worker 단일이라 영향 0건) |
| R-3 | `_update_widgets` narrow except | v0.6.5 (textual 표준 예외 한정) |
| R-4 | dedupe history 영구화 | v0.6.5 (`.claude/dashboard_state/dedupe.json`) |
| 추가 1 | spawn 추가 최적화 (-2 spawn 가능) | v0.6.5 (active_sessions 재사용 + git status caching) |
| 추가 2 | `_show_stale` 박스별 ⚠ 마커 강화 | v0.6.5 (UI 본문 — 프론트 트리오 영역) |
| Stage 10 잔여 (Mi-1~Mi-4 + N-1~N-2) | 그대로 | v0.6.5 (Stage 9 review Sec.4.3~4.4) |

## 9. 시그니처 (push 정공법 — `handoffs/active/v0.6.4/stage10b_complete.flag`)

```
📡 status COMPLETE Score=93/100 commit=<SHA> stage=10b verdict=APPROVED
```

## 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | Stage 10b fin | drafter + reviewer + finalizer A 패턴 trail 3건. dashboard.py M2~M5 wiring 통합 (운영자 발견 release blocker 닫음). compose 2 widgets / 6 메서드 본문 / 헬퍼 1건 / CSS_PATH 외부 파일. steady-state spawn 4/sec / dedupe 5분 TTL 보존 / 회귀 0건 / 분량 임계 PASS. |

— 현봉식 (백앤드 파이널리즈, Orc-064-dev:1.4)
