---
date: 2026-04-27
version: v0.6.4
stage: 10c
work: dashboard.py 이름 충돌 fix + __init__.py + 진입 명령 정정 — drafter 초안
author: 카더가든 (백앤드 드래프터)
pane: Orc-064-dev:1.2
length_target: ≤ 800 줄
---

# Stage 10c — 이름 충돌 fix drafter 초안

> 카더가든입니다. Stage 10b a891d97 = wiring 코드는 통합됐으나 운영자 실제 실행 시
> ModuleNotFoundError. Stage 9 / Stage 10b 패턴 반복 = 점수만 통과 / 진짜 동작 검증
> 누락. 본 drafter에서 (1) 이름 충돌 fix (2) sys.path 안전 (3) **검증 게이트 강제
> 실제 widget 본문 표시 확인** 박습니다.

## 1. 운영자 발견 = release blocker (재발)

```
$ venv/bin/python3 scripts/dashboard.py
ModuleNotFoundError: No module named 'scripts'
```

원인 2건:
1. **이름 충돌**: `scripts/dashboard.py` (파일) ↔ `scripts/dashboard/` (패키지) — Python
   import 시 패키지가 우선 (PEP 328). 직접 실행 진입 시 `from scripts.dashboard.X` =
   `scripts.dashboard` namespace = 패키지를 가리킴. 모듈 vs 파일 우선순위 충돌 영역
   잠재 + Stage 10c 운영자 결정 영역으로 명확화.
2. **sys.path**: 직접 실행 (`venv/bin/python3 scripts/dashboard.py`) 시 sys.path =
   `[scripts/, ...]`이고 PROJECT_ROOT (`.`) 미박힘. `from scripts.dashboard.X import Y`
   = `scripts` 패키지 찾기 실패 = ModuleNotFoundError.

## 2. 운영자 결정 (가) — 채택 그대로

- `scripts/dashboard.py` → `scripts/run_dashboard.py` 이름 변경
- `scripts/__init__.py` 신규 (빈 패키지 docstring)
- `.claude/commands/dashboard.md` 진입 명령 정정

추가 PL 자율:
- `run_dashboard.py` 안 sys.path 조정 (직접 실행 시 PROJECT_ROOT 자동 추가, idempotent)

## 3. 코드 변경

### 3.1 `scripts/__init__.py` 신규 (5줄)

```python
"""jOneFlow scripts 패키지 — Stage 10c 추가.

기존 ``scripts/dashboard.py`` ↔ ``scripts/dashboard/`` (패키지) 이름 충돌 해소 영역에서
``scripts/`` 자체를 명시 패키지로 박음. ``scripts/run_dashboard.py``의 절대 import
``from scripts.dashboard.X import Y`` 안전 동작 정합.
"""
```

### 3.2 `scripts/run_dashboard.py` (구 dashboard.py)

`git mv scripts/dashboard.py scripts/run_dashboard.py` + 진입점 sys.path 조정:

```python
import os
import sys
# Stage 10c — 직접 실행 진입 시 PROJECT_ROOT를 sys.path에 추가하여 ``scripts.*``
# 절대 import 안전 동작. ``python -m`` 또는 외부 import 진입은 idempotent.
_HERE = os.path.dirname(os.path.abspath(__file__))
_PROJECT_ROOT = os.path.dirname(_HERE)
if _PROJECT_ROOT not in sys.path:
    sys.path.insert(0, _PROJECT_ROOT)

from textual.app import App, ComposeResult
# ... 이하 wiring 본문 (Stage 10b 그대로)
```

### 3.3 `.claude/commands/dashboard.md` 정정

- `scripts/dashboard.py` → `scripts/run_dashboard.py`
- M1 placeholder 문구 제거 → Stage 10b 정합 본문 (M2~M5 wiring 통합)

## 4. 검증 게이트 추가 fix (PL이 직접 실행해서 발견)

검증 게이트 = `venv/bin/python3 scripts/run_dashboard.py` 실제 실행 → 19명 박스 본문
표시 확인. PL이 직접 실행하면서 추가 layout 에러 2건 발견 → 즉시 fix:

### 4.1 PendingArea horizontal layout LayoutError

- **증상**: `resolve_box_models` 실패 — `PendingPushBox` / `PendingQBox`가
  `PendingArea` (horizontal) 안 `width` 미정의로 box model resolve 불가.
- **fix**: 두 박스 `DEFAULT_CSS`에 `width: 1fr` 추가.

```css
PendingPushBox {
    border: round $secondary;
    padding: 0 1;
    margin: 0 1;
    height: auto;
    width: 1fr;  /* Stage 10c — horizontal layout box model 정합 */
}
```
(PendingQBox 동일)

### 4.2 textual `Static._render` 시그니처 충돌

- **증상**: `TypeError: PendingPushBox._render() missing 1 required positional argument:
  'pushes'`
- **원인**: textual `Widget` 또는 `Static` base 클래스에 `_render()` (인자 0개) 메서드.
  drafter v1이 `_render(self, pushes)` 정의하면서 base override + 시그니처 충돌.
  textual rendering 사이클이 `widget._render()` (no-arg) 호출 → TypeError.
- **fix**: `_render` → `_format_content` rename. `_render_empty` → `_format_empty` rename.

## 5. 검증 결과

### 5.1 py_compile (3 파일)

`scripts/__init__.py` + `scripts/run_dashboard.py` + `scripts/dashboard/pending_widgets.py`
PASS 3/3.

### 5.2 실제 실행 (subprocess background + SIGTERM)

```
$ venv/bin/python3 scripts/run_dashboard.py
returncode: -15 (SIGTERM)
stderr: clean (Traceback / Error / Exception 0건)
```

ModuleNotFoundError 0건 ✓ / LayoutError 0건 ✓.

### 5.3 textual run_test pilot widget 검증

```
=== Stage 10c 검증 게이트 ===
  [✓] DashboardRenderer: True
  [✓] PendingArea: True
  [✓] TeamRenderer count == 3: True
  [✓] PMStatusBar: True
  [✓] PendingPushBox: True
  [✓] PendingQBox: True
=== 팀 박스 본문 ===
  [✓] 기획팀: 4/4 페르소나 표시 (박지영 / 김민교 / 안영이 / 장그래)
  [✓] 디자인팀: 4/4 페르소나 표시 (우상호 / 이수지 / 오해원 / 장원영)
  [✓] 개발팀: 7/7 페르소나 표시 (공기성 / 최우영 / 현봉식 / 카더가든 / 백강혁 / 김원훈 / 지예은)
=== PM status bar ===
  [✓] 스티브 리 표시: True
  본문: PM 스티브 리 [◉ working] | bridge-064 | tokens: 0.0k | active orcs: ...
=== Pending boxes ===
  [✓] PendingPush: ✓ 대기 항목 없음 placeholder
  [✓] PendingQ: 6 Q 표시 (dispatch md 추출, 606 chars)
=== 검증 게이트: PASS ===
```

19명 산식 정합 (F-D3):
- 박스 15 (기획 4 + 디자인 4 + 개발 7)
- PM 1 (status bar)
- 미표시 placeholder 3 (CTO 백현진 / CEO 이형진 / HR TBD)
- 합계 **19** ✓

박스 본문 = 페르소나 이름 + working 상태 ◉ + 작업명 + tokens 0.0k + 진행률 바 8칸 +
스파크라인 8칸 모두 표시 정합.

## 6. 회귀 분석

| 영역 | 검토 |
|------|------|
| 기존 `scripts/dashboard.py` 직접 호출 | grep 결과 외부 호출자 0건 — 영향 0건 (`.claude/commands/dashboard.md` 1건만 해당, 본 stage에서 정정) |
| `scripts.dashboard.X` 모듈 import (tests 등) | 그대로 (`scripts/dashboard/` 패키지 그대로 + `scripts/__init__.py` 신규로 안전 강화) |
| Stage 10b wiring 본문 | 그대로 (rename + sys.path 조정만, 본문 코드 0건 변경) |
| PendingPushBox / PendingQBox 외부 호출자 | `update_data` / `compose` 시그니처 그대로 (`_render` 내부 protected method rename) |

회귀 0건 ✓.

## 7. 분량 임계

본 drafter doc = 약 200줄 (≤ 800 PASS).

## 8. reviewer 인계

- 이름 충돌 fix + 패키지화 + sys.path 조정 + 추가 layout/시그니처 fix 2건 박았습니다.
  최우영 reviewer가 검토 + R-N 마커 부탁드립니다.
- 특히 (1) `scripts/__init__.py` empty package vs `__all__` 명시, (2) sys.path
  insert 위치 (idempotent 정합), (3) `_render` → `_format_content` 시그니처 충돌
  영역에서 다른 위젯도 잠재 영역 점검 권고합니다.

— 카더가든 (백앤드 드래프터, Orc-064-dev:1.2)
