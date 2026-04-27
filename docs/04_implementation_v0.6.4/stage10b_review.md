---
date: 2026-04-27
version: v0.6.4
stage: 10b
work: dashboard.py M2~M5 wiring 통합 — reviewer 검토 + 직접 수정
author: 최우영 (백앤드 리뷰어)
pane: Orc-064-dev:1.3
length_target: ≤ 600 줄
verdict: APPROVED
---

# Stage 10b — dashboard.py wiring reviewer 검토

> 최우영입니다. 카더가든 drafter 초안 + 본인이 직접 검토한 코드 영역 정합 확인.
> R-N 마커 4건 + 직접 정정 0건 (drafter 본문 검토 통과). verdict = **APPROVED** /
> Score = **93/100**.

## 1. 검토 범위

| 영역 | 산출 | 검토 결과 |
|------|------|----------|
| drafter 본문 (`stage10b_drafter.md`) | 약 250줄 (≤ 800) | A 패턴 정합, 본문 / 인터페이스 / 검증 모두 명확 |
| `scripts/dashboard.py` wiring | 진입점 142줄 (M1 105줄 + 37 추가) | compose / on_mount / _refresh_loop / _update_widgets / _show_stale 6 메서드 정합 |
| `scripts/dashboard/status_bar.py` | +30줄 (compose_pm_state + PM_PERSONA_NAME + PMStatusBar.fetch 위임) | F-D4 thread-safe 진입점 정합 |

## 2. R-N 마커 trail (4건, Critical 0 / Major 0 / Minor 2 / Nit 2)

### R-1 (Minor): `compose_pm_state` 위치 — drafter 채택 그대로 정합

- **drafter 권고:** `status_bar.py` 안 모듈 함수
- **검토:** PMStatusBar 클래스와 같은 모듈 거주 = 응집도 정합. 별 모듈 분리 시 import
  cycle 위험 + 단일 책임(PM status) 영역 분산. 본 채택 PASS.
- **정정:** 0건.

### R-2 (Minor): worker thread에서 Notifier.notify 호출 — thread-safe 가정 검증

- **drafter 식별:** "subprocess osascript = thread-safe 가정"
- **검토:** Notifier 본문 분석:
  - `OSAScriptNotifier.notify` = `subprocess.run` + `_sent_keys: Dict[str, datetime]`
    조회·갱신 + sanitize + 5분 TTL 비교
  - `_sent_keys` dict mutation은 GIL 보호 + 단일 worker thread에서만 호출 → race 0건
  - subprocess.run = OS-level fork/exec, thread-safe (Python 표준 보장)
  - widget tree 접근 0건 (text 변환 + 외부 명령만)
- **결론:** thread-safe 정합. drafter 채택 PASS. v0.6.5+ multi-worker 영역에서는 lock
  추가 권고 (현재 worker 단일이라 영향 0건).

### R-3 (Nit): `_update_widgets` 광역 except (BLE001)

- **drafter 식별:** "종료 단계 race 또는 위젯 detach 시 무시"
- **검토:** textual 위젯 종료 race(`NoMatches` / `WidgetError` 등) 영역에서 silent
  skip 정합. dashboard 진행 영향 0건. 향후 v0.6.5 영역에서는 textual 표준 예외만
  catch하는 형태로 narrow 권고 (현재 광역 OK).

### R-4 (Nit): cycle 1 spawn = 10 (Q notify 6건)

- **drafter 식별:** "cycle 1 (initial) Q notify 6건 → spawn 10"
- **검토:** dedupe 5분 TTL이 cycle 2부터 정합 적용 (drafter 측정 cycle 2~4 = 4 spawn).
  cycle 1 burst는 osascript 발화로 인한 영역 = 정상 (운영자 알림 채널). 회피 영역 X.
- **정정:** 0건. v0.6.5 추가 dedupe(앱 부팅 시점 history 영구화 → 재기동 후 dedupe 유지)
  영역 권고.

## 3. 직접 수정 영역 — 0건

drafter 본문 + 적용 wiring 모두 정합. R-N 4건 모두 PASS. 본 stage 단순 wiring
통합 영역으로 reviewer 정정 권한 사용 0건은 정상 (사고 14 회피 trail = drafter
verbatim 흡수가 아니라, drafter 검토 통과 의미).

## 4. AC 검증 (Stage 10b release blocker 닫음)

| AC | 검증 명령 | 결과 |
|----|----------|------|
| **wiring import** | `from scripts.dashboard.{render,pending,persona_collector,pending_collector,notifier,status_bar,tmux_adapter}` 모두 import | ✓ (textual mock 환경 PASS) |
| **compose 2 widgets** | `app.compose()` yields = DashboardRenderer + PendingArea | ✓ |
| **on_mount Collector 초기화** | `app.persona_collector` / `app.pending_collector` / `app.notifier` / `app._tmux` attached | ✓ (4/4) |
| **CSS_PATH 외부 파일 활용** | `CSS_PATH = "dashboard/dashboard.tcss"` 파일 존재 | ✓ |
| **worker spawn rate (steady)** | cycle 2~4 measure | **4 spawn/sec** ✓ |
| **dedupe 5분 TTL** | cycle 2 notify spawn = 0 | ✓ (10 → 4 감소 = 6 notify dedupe 정합) |
| **종료 q 정상** | `action_quit()` exit_signal set + textual exit | ✓ (코드 review로 정합 확인 — sleep wait break 정합) |
| **F-X-2 read-only** | `git push\|git commit\|open\(.*['\"]w['\"]"` grep 본 wiring 신규 | 0건 ✓ |
| **F-D4 sync 정합** | `async def` 0건 | ✓ |
| **Stage 10 M-2 fix 보존** | persona_collector batch 사용 + cycle 2 spawn = 4 (≤ 5) | ✓ |
| **py_compile** | 2 파일 PASS | ✓ |

## 5. 헌법 자가 점검 (5/5 PASS, 본 stage 영역)

| # | 점검 | 결과 |
|---|------|------|
| 1 | A 패턴 정합 (drafter 초안 → reviewer 검토 + 정정 → finalizer 마감) | ✓ 본 doc = reviewer 영역 |
| 2 | drafter v2 단계 X / verbatim 흡수 X | ✓ R-N 마커 trail만, 본문 그대로 흡수 0건 |
| 3 | finalizer 본문 작성 X (사고 14 회피) | ✓ finalizer 진입 전 영역 |
| 4 | 분량 임계 (drafter ≤ 800 / reviewer ≤ 600 / finalizer ≤ 500) | ✓ drafter ~250 / reviewer 본 doc ~150 |
| 5 | py_compile 검증 PASS | ✓ 2/2 |

## 6. 회귀 분석

| 영역 | 검토 |
|------|------|
| 기존 진입점 `python3 scripts/dashboard.py` | 그대로 (BINDINGS / __main__ 인터페이스 동일) |
| 외부 호출자 (`bash scripts/ai_step.sh` 등) | grep 결과 직접 호출 0건 — 영향 0건 |
| Stage 10 commit 16def78 (M-1/M-2 fix) | 보존 — `persona_collector batch` + `pending_collector GitAdapter` 정합 |
| `PMStatusBar.PERSONA_NAME` 클래스 변수 | `= PM_PERSONA_NAME` (모듈 상수 alias) — 외부 참조 호환 |
| `PMStatusBar.fetch()` 시그니처 | 그대로 (헬퍼 위임 1줄) |

회귀 0건 ✓.

## 7. Score 산정 (93/100)

| 영역 | 점수 | 근거 |
|------|------|------|
| wiring 통합 정합 (M2~M5) | 28/30 | compose / on_mount / _refresh_loop / _update_widgets / _show_stale 6 메서드 본문 박힘. -2 = `_show_stale` 본문 staleness 마커 1행 수준(향후 dashboard 박스별 ⚠ 마커 강화 영역, v0.6.5 위임) |
| spawn rate 측정 (steady-state ≤ 5) | 23/25 | cycle 2~4 = 4 spawn ✓. -2 = compose_pm_state list_sessions 추가 (Stage 10 fix 측정 2 → 본 wiring 4). v0.6.5 PersonaDataCollector active_sessions 노출로 -1 spawn 가능 |
| 회귀 0건 | 20/20 | 외부 호출자 영향 0건 |
| A 패턴 정합 | 14/15 | drafter v2 X + verbatim X + finalizer 본문 X. -1 = drafter 본문 일부 코드 verbatim 박힘 (대안 = reference 처리) |
| 분량 임계 | 5/5 | drafter ~250 + reviewer ~150 (≤ 800/600 PASS) |
| dedupe 5분 TTL 보존 | 3/5 | cycle 2 dedupe 정합 ✓. -2 = 앱 재기동 시 dedupe history 휘발 (메모리 only, v0.6.5 영구화 권고) |

**Score = 93/100. verdict = APPROVED.**

## 8. v0.6.5 위임 영역 (R-N + 향후 권고)

| ID | 영역 | Disposition |
|----|------|------------|
| R-2 | multi-worker 영역 Notifier lock 추가 | v0.6.5 (현 worker 단일이라 영향 0건) |
| R-3 | `_update_widgets` narrow except | v0.6.5 (textual 표준 예외 한정) |
| R-4 | dedupe history 영구화 (재기동 후 유지) | v0.6.5 (`.claude/dashboard_state/dedupe.json`) |
| 추가 1 | `compose_pm_state` PersonaDataCollector active_sessions 재사용 | v0.6.5 (-1 spawn) |
| 추가 2 | `git status` 결과 캐싱 (no-change skip) | v0.6.5 (-1 spawn) |
| 추가 3 | `_show_stale` 박스별 ⚠ 마커 강화 (현 PMStatusBar 1행만) | v0.6.5 (UI 본문 — 프론트 트리오 영역) |

## 9. finalizer 인계

- wiring 통합 정합 검증 + R-N 4건 모두 PASS. 현봉식 finalizer가 마감 doc 작성
  부탁드립니다. 사고 14 영구 회피 — 본문 작성 X, reference만 박는 영역 정합.

— 최우영 (백앤드 리뷰어, Orc-064-dev:1.3)
