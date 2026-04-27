---
date: 2026-04-27
version: v0.6.4
stage: 10b
work: dashboard.py M2~M5 wiring 통합 — drafter 초안
author: 카더가든 (백앤드 드래프터)
pane: Orc-064-dev:1.2
length_target: ≤ 800 줄
---

# Stage 10b — dashboard.py M2~M5 wiring 통합 drafter 초안

> 카더가든입니다. 운영자 발견 = `dashboard.py` M1 scaffold만 남고 M2~M5 모듈 wiring
> 0건 (release blocker). Stage 9 review도 못 잡은 영역. 본 drafter 초안에서 wiring
> 통합 본문 박습니다. UI 본문 추가 0건 — 위젯 모듈 본문은 이미 작성됨(M3
> team_renderer / status_bar / render / dashboard.tcss + M4 pending_widgets / pending /
> notifier + M5 personas), backend wiring (collector ↔ widget) 통합만 필요. 운영자
> 결정 (가) 정합 — 백 트리오 영역 / 프론트 트리오 활성화 0건.

## 1. blocker 식별

| 영역 | 기존 | 부족 |
|------|------|------|
| `dashboard.py` `compose()` | M1 placeholder Static 1개 | DashboardRenderer + PendingArea yield 누락 |
| `dashboard.py` `on_mount()` | `self.run_worker(self._refresh_loop, thread=True, exclusive=True)` | TmuxAdapter / Collector 2개 / Notifier 초기화 누락 |
| `dashboard.py` `_refresh_loop()` | `time.sleep(1.0)` 빈 루프 | collector fetch + Notifier 발송 + call_from_thread 누락 |
| `dashboard.py` `_update_widgets()` | 빈 메서드 | 팀 그루핑 + DashboardRenderer.update_data + PendingArea.update_data 누락 |
| `dashboard.py` `_show_stale()` | 빈 메서드 | staleness ⚠ 마커 누락 |
| `scripts/dashboard/` 모듈 import | 0건 | M2~M5 모듈 7개 진입점 import 누락 |

운영자 게이트 = `venv/bin/python3 scripts/dashboard.py` 시점 placeholder 화면만 출력 →
release blocker.

## 2. 모듈 export 형태 (wiring 인터페이스)

| 모듈 | export | 호출 시그니처 |
|------|--------|------|
| `persona_collector.PersonaDataCollector(tmux=)` | `.fetch_all_personas() → List[PersonaState]` | sync, F-D4 정합 |
| `pending_collector.PendingDataCollector(tmux=, git=)` | `.get_pending_pushes() → List[PendingPush]` / `.get_pending_questions() → List[PendingQuestion]` | sync |
| `render.DashboardRenderer` | Container — `compose()` yields PMStatusBar + 3 TeamRenderer / `update_data(teams_data, pm_state, active_orcs)` | M3 본문 |
| `pending.PendingArea` | Container — `compose()` yields PendingPushBox + PendingQBox / `update_data(pushes, questions)` | M4 본문 |
| `notifier.get_notifier()` | macOS=OSAScriptNotifier / Windows=WindowsNotifier 자동 분기 / `.notify(q) → bool` | M4 |
| `status_bar.PMStatusBar` | Static (height=1) — `fetch() → (PersonaState, List[str])` / `update_data(pm_state, active_orcs)` | DashboardRenderer 내부 mount |

PM status는 worker thread에서 widget tree 접근 0건이어야 함 (textual thread-safety 정합).
`PMStatusBar.fetch()`는 widget instance method — worker가 직접 호출하면 안 됨. 새
`compose_pm_state(tmux)` 모듈 함수를 `status_bar.py`에 추가, worker thread-safe 진입점
박음. `PMStatusBar.fetch()`는 본 함수 위임으로 정합.

## 3. wiring 본문 설계

### 3.1 import 체인

```python
from textual.app import App, ComposeResult
from textual.binding import Binding

from scripts.dashboard.models import PendingPush, PendingQuestion, PersonaState
from scripts.dashboard.notifier import get_notifier
from scripts.dashboard.pending import PendingArea
from scripts.dashboard.pending_collector import PendingDataCollector
from scripts.dashboard.persona_collector import PersonaDataCollector
from scripts.dashboard.render import DashboardRenderer
from scripts.dashboard.status_bar import compose_pm_state
from scripts.dashboard.tmux_adapter import TmuxAdapter
```

### 3.2 클래스 메서드 본문

**compose()** — design_final Sec.8 / Sec.9.2 단일 진입:
```python
yield DashboardRenderer(id="dashboard")
yield PendingArea(id="pending_area")
```

**on_mount()** — TmuxAdapter 단일 source, Collector 2개에 동일 인스턴스 주입 (Stage 10
M-2 fix change cache 공유 활용):
```python
self._tmux = TmuxAdapter()
self.persona_collector = PersonaDataCollector(tmux=self._tmux)
self.pending_collector = PendingDataCollector(tmux=self._tmux)
self.notifier = get_notifier()
self.run_worker(self._refresh_loop, thread=True, exclusive=True)
```

**_refresh_loop()** — Stage 14 에러 경로 + Notifier 발송:
```python
while not self._exit_signal.is_set():
    try:
        personas = self.persona_collector.fetch_all_personas()
        pm_state, active_orcs = compose_pm_state(self._tmux)
        pushes = self.pending_collector.get_pending_pushes()
        questions = self.pending_collector.get_pending_questions()
    except Exception as exc:
        self.call_from_thread(self._show_stale, exc)
    else:
        for q in questions:
            try:
                self.notifier.notify(q)
            except Exception:
                pass  # 알림 실패는 dashboard 진행 영향 0건
        self.call_from_thread(
            self._update_widgets, personas, pushes, questions,
            pm_state, active_orcs,
        )
    if self._exit_signal.wait(REFRESH_INTERVAL_SEC):
        break
```

**_update_widgets()** — 메인 thread + 팀 그루핑:
```python
teams_data: Dict[str, List[PersonaState]] = {team: [] for team in TEAM_ORDER}
for p in personas:
    teams_data.setdefault(p.team, []).append(p)
try:
    self.query_one("#dashboard", DashboardRenderer).update_data(
        teams_data, pm_state=pm_state, active_orcs=active_orcs,
    )
    self.query_one("#pending_area", PendingArea).update_data(
        pushes=pushes, questions=questions,
    )
except Exception:
    pass  # 종료 단계 race 또는 위젯 detach 시 무시
```

**_show_stale()** — staleness ⚠ 마커, PMStatusBar 1행 갱신:
```python
try:
    from scripts.dashboard.status_bar import PMStatusBar
    bar = self.query_one("#pm_status_bar", PMStatusBar)
    label = f"⚠ stale — {type(exc).__name__}: {str(exc)[:60]}"
    bar.update(label)
except Exception:
    pass
```

**action_quit()** — 기존 그대로 (exit_signal + textual exit).

### 3.3 CSS_PATH 정정

기존 `CSS = """..."""` 인라인 → `CSS_PATH = "dashboard/dashboard.tcss"` 외부 파일 참조.
`scripts/dashboard/dashboard.tcss` (이미 작성, 92줄) 활용 — boundary slot #1 (색상 11종)
+ #2 (margin/padding/border round) 흡수 영역 정합.

### 3.4 status_bar.py 헬퍼 추가

```python
PM_PERSONA_NAME: str = "스티브 리"

def compose_pm_state(tmux: TmuxAdapter) -> Tuple[PersonaState, List[str]]:
    """PM status 계산 — PMStatusBar.fetch() 동등. widget tree 무관, worker thread-safe."""
    sessions = tmux.list_sessions()
    bridges = sorted(s for s in sessions if s.startswith("bridge-"))
    active_orcs = sorted(s for s in sessions if s.startswith("Orc-"))
    if not bridges:
        return (PersonaState(name=PM_PERSONA_NAME, team="기획", status="idle", task=None,
                             tokens_k=0.0, last_update=datetime.fromtimestamp(0)), [])
    return (PersonaState(name=PM_PERSONA_NAME, team="기획", status="working",
                         task=bridges[-1], tokens_k=0.0, last_update=datetime.now()),
            bridges + active_orcs)
```

`PMStatusBar.fetch()`는 본 헬퍼 위임 (1줄):
```python
def fetch(self) -> Tuple[PersonaState, List[str]]:
    return compose_pm_state(self.tmux)
```

## 4. 검증 결과

### 4.1 py_compile (2 파일)

`scripts/dashboard.py` + `scripts/dashboard/status_bar.py` PASS 2/2.

### 4.2 import smoke (textual mock 환경 — 시스템 미설치)

- `DashboardApp` 인스턴스화 정합
- `compose()` yields 2 widgets (DashboardRenderer + PendingArea)
- `on_mount()` 후 `persona_collector` / `pending_collector` / `notifier` / `_tmux` 모두 attached
- `BINDINGS = [Binding("q", ...)]` 정합
- `CSS_PATH = "dashboard/dashboard.tcss"` 파일 존재 ✓

### 4.3 worker 1 사이클 spawn 측정 (textual mock + subprocess mock)

| cycle | spawn 분해 | 합 |
|-------|-----------|-----|
| **1 (initial)** | list_sessions(persona) 1 + capture_panes_batch 1 + list_sessions(pm) 1 + git status 1 + osascript×Q수 6 | **10** |
| **2 (steady)** | list_sessions×2 + capture_panes_batch + git status (notify 0건 dedupe) | **4** |
| 3 / 4 | (동일) | 4 / 4 |

cycle 2 dedupe 5분 TTL 정합 — Notifier 발송 0건. steady-state 4 spawn/sec PASS
(기존 Stage 10 측정 2 spawn/sec + compose_pm_state list_sessions 1 + git status 1).

추가 최적화 영역 (v0.6.5 권고):
- `compose_pm_state`가 `PersonaDataCollector` cached active_sessions 재사용 → −1 spawn
- `git status` 결과 캐싱 (변경 없으면 skip) → −1 spawn
- = steady-state 2 spawn/sec 가능

본 stage = wiring 통합 영역, 추가 최적화는 v0.6.5 위임.

## 5. 회귀 분석

| 영역 | 검토 |
|------|------|
| 기존 `dashboard.py` 진입점 | M1 placeholder 화면 → M2~M5 통합 화면. 외부 호출자(`bash scripts/ai_step.sh` 등) 영향 0건 — `python3 scripts/dashboard.py` 실행 인터페이스 그대로 |
| `status_bar.PMStatusBar.fetch()` 시그니처 | 그대로 (본 헬퍼 위임). 외부 호출자 영향 0건 |
| `status_bar.PERSONA_NAME` 클래스 변수 | `PM_PERSONA_NAME` 모듈 상수 alias (역호환). 외부 호출자 영향 0건 |
| `notifier.get_notifier()` | 기존 그대로 (factory 함수) |
| `persona_collector` / `pending_collector` 시그니처 | Stage 10 fix 영역 그대로 (Optional default 패턴 유지) |

회귀 0건.

## 6. 분량 임계

본 drafter doc = 약 250줄 (≤ 800 PASS).

## 7. reviewer 인계

- M2~M5 wiring 본문 + 헬퍼 1건 (`compose_pm_state`) + CSS_PATH 정정 박았습니다. 최우영
  reviewer가 검토 + R-N 마커 + 직접 정정 권한 부탁드립니다.
- 특히 (1) `compose_pm_state` 위치 (status_bar.py 안 vs 별 모듈), (2) worker thread에서
  Notifier.notify 호출 (subprocess osascript = thread-safe 가정), (3) `_update_widgets`
  try/except 광역(BLE001), (4) cycle 1 spawn 10 (Q notify) 영역 점검 권고합니다.

— 카더가든 (백앤드 드래프터, Orc-064-dev:1.2)
