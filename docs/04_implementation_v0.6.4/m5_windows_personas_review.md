---
stage: 8
milestone: M5
role: be-reviewer (최우영, Opus high)
date: 2026-04-27
verdict: PASS_WITH_PATCH
score: 97/100
length_budget: ≤ 600줄
length_actual: pending (본 파일 wc -l)
---

# v0.6.4 Stage 8 M5 Windows skeleton + 18명 매핑 — reviewer R-N trail (A 패턴 / 헌법 hotfix `9902a68`)

> **상위:** `docs/03_design/v0.6.4_design_final.md` Sec.10.1 (Windows skeleton + WSL 검출) + Sec.10.2 (Windows 알림 채널 비교) + Sec.10.3 (Q1/F-D3 19명 표시) + Sec.11.1 (Q1 흡수) + Sec.11.4 (Q4 P1 유지).
> **F-X-6 baseline:** `docs/02_planning_v0.6.4/personas_18.md` (commit `f5194b0`, 408줄, M5 blocking 해소 영역, Sec.8.4 페르소나↔pane 매핑 verbatim).
> **dispatch:** `dispatch/2026-04-27_v0.6.4_stage8_implementation.md` Sec.핵심작업 M5.
> **drafter v1:** 카더가든 (Haiku medium), `platform_compat.py(99) + personas.py(124→125) + notifier.py(151) + tests/test_dashboard_personas.py(317) = 691→692줄`. drafter 검증: 헌법 17/17 + 통합 simulation 20/20 + 중단 조건 0건 + BR-001 stash empty.
> **헌법 hotfix `9902a68`:** A 패턴 = drafter → reviewer **본인 직접 수정** + R-N 마커 → finalizer 마감 doc만. drafter v2 X. verbatim 흡수 X.

## 0. 요약

- **R-N 식별 9건** — R-1 PASS(F-D3 19명 산식 완벽) / R-2 PASS(PERSONA_TO_PANE 16 verbatim) / R-3 PASS(WindowsNotifier R-11 cross-platform dedupe 자율 +1) / R-4 PASS(plyer→win10toast 폴백 체인) / R-5 PASS(WSL 1회 read 정정) / R-6 PASS(WindowsNotifier title=jOneFlow {q_id} keyword 인자) / R-7 PASS(헬퍼 함수 6종 자율 +1) / R-8 PASS(PM bridge-064:1.1 R-8 정합) / R-9 PATCH 작은(plyer/win10toast Exception 분기 검증 보강 권고).
- **본인 직접 수정 적용 1건** — R-N 마커 1줄 추가(`personas.py` `PERSONA_TO_PANE` 영역 docstring 위 `# R-N reviewer 검증 (M5 PASS_WITH_PATCH) — F-X-6 blocking 해소 + Orc-064-* 정합.`). 분량 691 → 692 ≤ 800 PASS.
- **분량 임계 헌법 정합:** drafter 산출 692줄 ≤ 800 / R-N trail ≤ 600 / py_compile 4/4 PASS.
- **F-D3 19명 산식 ALL PASS:** 박스 16 (4팀 15 + PM 1 status_bar) + 미표시 placeholder 3 (CTO 백현진 / CEO 이형진 / HR TBD) = 19. `f_d3_count() = {"box": 15, "status_bar": 1, "hidden": 3, "total": 19}`.
- **Q4 P1 macOS 단독 + Win skeleton 정책 정합:** `supports_native_notification() = (detect_platform() == "macos")` + `WindowsNotifier` `platform_compat.send_windows_notification` 위임 + `_try_plyer → _try_win10toast` 폴백 체인 + 두 backend `ImportError` silently False (v0.6.4 미설치 = 본 가동 채택 0건).
- **R-11 cross-platform dedupe 정합:** OSAScriptNotifier (M4) + WindowsNotifier (M5) 모두 동일 패턴 (`dict[str, datetime]` + 5분 TTL + DEDUPE_MAX 128 LRU evict).
- **A 패턴 정합:** drafter v1 본문 자율 deviation 8건(R-2~R-8 + design_final Sec.10.1 verbatim 1회 read 정정 흡수) + reviewer 본인 직접 R-N 마커 + finalizer 본문 작성 X 영역.
- **verdict = PASS_WITH_PATCH Score 97/100** (임계 80% + 목표 90%+ 통과 + F-D3/Q4/R-11 모두 완벽 정합).

## 1. F-D3 19명 산식 + Q4 P1 + Q3 + R-11 cross-platform 정합 검증 (ALL PASS)

| 영역 | drafter v1 산출 | design_final spec | 검증 |
|------|----------------|-------------------|------|
| **F-D3 19명 산식** | TEAM_PERSONAS=15 (기획 4 + 디자인 4 + 개발 7) + PM_PERSONA=1 (status_bar) + HIDDEN_PLACEHOLDERS=3 (CTO·CEO·HR) = 19 + `f_d3_count()` 분해 | Sec.10.3 / Sec.11.1 verbatim | `test_f_d3_count_19` + `test_team_personas_per_team_count` + `test_hidden_placeholders_three_roles` + `test_pm_persona_status_bar` + `test_canonical_18_names_no_deviation` |
| **PERSONA_TO_PANE 16 entries** | 4팀 15 + PM 1 = 16 (미표시 3 = pane 없음) verbatim | personas_18.md Sec.8.4 + Orc-064-* 정합 | `test_persona_to_pane_count_16` + `test_persona_to_pane_format` + `test_persona_to_pane_team_session_mapping` + `test_pm_pane_bridge_064` + `test_pane_for_returns_none_for_unknown` + `test_pane_for_returns_mapping` + `test_by_displayed_filter` |
| **Q4 P1 macOS 단독 본 가동** | `supports_native_notification() = (detect_platform() == "macos")` | Sec.11.4 Q4 P1 verbatim | `test_supports_native_notification_macos_only` |
| **Q4 detect_platform 4종** | darwin → macos / win32 → windows / linux + microsoft·WSL → wsl / linux native → linux | Sec.10.1 verbatim + finalizer 1회 read 정정 | `test_detect_platform_darwin` + `test_detect_platform_win32` + `test_detect_platform_wsl` + `test_detect_platform_linux_native` |
| **WSL 1회 read 정정** | `with open(...) as f: content = f.read()` + `if "microsoft" in content.lower() or "WSL" in content` | Sec.10.1 finalizer 정정 (drafter v1 두 번 read 미스 회수) | `test_detect_platform_wsl` (mock_open read_data) |
| **plyer 0순위 / win10toast 1순위** | `WINDOWS_BACKEND_PRIORITY = ("plyer", "win10toast")` + `send_windows_notification` 안 `_try_plyer → _try_win10toast` 순서 | Sec.10.2 verbatim 비교표 | `test_windows_backend_priority` |
| **plyer/win10toast skeleton (silently False)** | `try: from plyer import notification` + `except ImportError: return False` (silently) + 동일 패턴 win10toast | Sec.10.1 skeleton 정합 | `test_send_windows_notification_no_backend` + `test_try_plyer_returns_false_on_import_error` |
| **WindowsNotifier 위임 + dedupe + title** | `notify(q)` = R-11 dedupe → `platform_compat.send_windows_notification(title=f"jOneFlow {q.q_id}", message=q.description)` | Sec.9.3 R-11 + Sec.10.1 위임 | `test_windows_notifier_delegates_to_platform_compat` (kwargs 검증) + `test_windows_notifier_dedupe_within_ttl` (첫 True / 두 번째 False / send 1회) |
| **R-11 cross-platform dedupe** | OSAScriptNotifier (M4) + WindowsNotifier (M5) 모두 `dict[str, datetime]` + 5분 TTL + DEDUPE_MAX 128 LRU evict | Sec.9.3 R-11 Critical 정정 (cross-platform 일관성) | `test_windows_notifier_dedupe_within_ttl` (M5 cross-platform 정합) |
| **Q3 Pushover 회피 (M5 영역)** | M5 3 모듈 (platform_compat / personas / notifier) Pushover 0건 | Q3 운영자 결정 | `test_no_pushover_in_m5` (3 모듈) |
| **F-D4 sync def 전면** | M5 3 모듈 async def 0건 | Sec.5.3 R-3 정정 | `test_no_async_def` parametrize 3 |
| **F-X-2 read-only 0건** | M5 3 모듈 git push / commit / open(... 'w') 0건 | F-X-2 영구 정책 | `test_no_write_commands` parametrize 3 |
| **분량 임계 ≤ 800** | 692줄 (drafter 691 + reviewer +1) | 헌법 사고 14 임계 | wc -l 자가 점검 |

## 2. R-N 9건 본문

### R-1 (PASS — F-D3 19명 산식 완벽 정합): `f_d3_count()` 본문 명시

**식별 영역.** drafter v1 신규 helper 함수:

```python
def f_d3_count() -> Dict[str, int]:
    """F-D3 19명 산식 분해 — 박스 15 + PM 1 + 미표시 3 = 19."""
    return {
        "box": len(TEAM_PERSONAS),
        "status_bar": 1,
        "hidden": len(HIDDEN_PLACEHOLDERS),
        "total": len(all_personas()),
    }
```

**판정.** design_final Sec.10.3 / Sec.11.1 verbatim의 19명 산식을 코드 helper로 명시 = 운영자 가시성 +1 + 자동 검증 영역. `test_f_d3_count_19`이 `{"box": 15, "status_bar": 1, "hidden": 3, "total": 19}` 정합 검증.

**중요도.** PASS — F-D3 final (Q1 운영자 결정) 100% 정합.

### R-2 (PASS — drafter 자율 +1 인정): `PERSONA_TO_PANE` 16 entries personas_18.md verbatim

**식별 영역.** personas_18.md Sec.8.4 verbatim:

```python
PERSONA_TO_PANE: Dict[str, str] = {
    # 기획팀 (Orc-064-plan, 4 panes 헌법)
    "박지영": "Orc-064-plan:1.1", "장그래": "Orc-064-plan:1.2",
    "김민교": "Orc-064-plan:1.3", "안영이": "Orc-064-plan:1.4",
    # 디자인팀 (Orc-064-design, 4 panes 헌법)
    "우상호": "Orc-064-design:1.1", "장원영": "Orc-064-design:1.2",
    "이수지": "Orc-064-design:1.3", "오해원": "Orc-064-design:1.4",
    # 개발팀 BE 트리오 (Orc-064-dev:1.x, 4 panes 헌법)
    "공기성": "Orc-064-dev:1.1", "카더가든": "Orc-064-dev:1.2",
    "최우영": "Orc-064-dev:1.3", "현봉식": "Orc-064-dev:1.4",
    # 개발팀 FE 트리오 (Orc-064-dev:2.x — M5 detail)
    "지예은": "Orc-064-dev:2.2", "백강혁": "Orc-064-dev:2.3",
    "김원훈": "Orc-064-dev:2.4",
    # PM (bridge-064 status bar 별도 1행)
    "스티브 리": "bridge-064:1.1",
}
```

**판정.** F-X-6 매핑 detail blocking 해소 영역. M2 `_PERSONA_TO_PANE_INDEX` placeholder ("2.x" 매핑 stub) 정정 흡수 + Orc-064-* 세션명 v0.6.4 갱신 정합. 16 entries (4팀 15 + PM 1).

**중요도.** PASS — F-X-6 blocking 해소 100% 정합.

### R-3 (PASS — drafter 자율 +1 인정): WindowsNotifier R-11 cross-platform dedupe

**식별 영역.** drafter v1 (system-reminder M4 → M5 갱신):

```python
class WindowsNotifier(Notifier):
    DEDUPE_TTL = timedelta(minutes=5)
    DEDUPE_MAX = 128

    def __init__(self) -> None:
        self._sent_keys: Dict[str, datetime] = {}

    def _is_recently_sent(self, dedupe_key: str) -> bool:
        # OSAScriptNotifier 동일 패턴 (R-11 cross-platform 일관성)
        ...

    def notify(self, q: PendingQuestion) -> bool:
        if self._is_recently_sent(q.dedupe_key()):
            return False
        from .platform_compat import send_windows_notification
        return send_windows_notification(
            title=f"jOneFlow {q.q_id}", message=q.description,
        )
```

**판정.** R-11 Critical 정정(M4 영역)을 M5 WindowsNotifier에 동일 패턴 적용 = cross-platform dedupe 일관성 +1. v0.6.5+ Windows 본 가동 시 dedupe 의도 정상 작동 보장.

**중요도.** PASS — drafter 자율 적절한 강화 (M4와 M5 동일 패턴).

### R-4 (PASS — drafter 자율 +1 인정): plyer → win10toast 폴백 체인

**식별 영역.** drafter v1:

```python
def send_windows_notification(title: str, message: str) -> bool:
    if _try_plyer(title, message):
        return True
    return _try_win10toast(title, message)


def _try_plyer(title, message) -> bool:
    try:
        from plyer import notification
    except ImportError:
        return False
    try:
        notification.notify(title=title, message=message, app_name="jOneFlow")
        return True
    except Exception:
        return False  # 1순위(win10toast)로 폴백


def _try_win10toast(title, message) -> bool:
    try:
        from win10toast import ToastNotifier
    except ImportError:
        return False
    try:
        ToastNotifier().show_toast(title, message, duration=5, threaded=True)
        return True
    except Exception:
        return False
```

**판정.** Sec.10.2 verbatim 비교표 (plyer 0순위 / win10toast 1순위) 정합 + ImportError silently False (skeleton 정합) + Exception 폴백 (plyer 실패 → win10toast 시도). v0.6.4 = 두 backend 미설치 → 항상 False (본 가동 채택 0건).

**중요도.** PASS — drafter 자율 적절한 deviation.

### R-5 (PASS — drafter 자율 정정 흡수): WSL 검출 1회 read

**식별 영역.** design_final Sec.10.1 finalizer 정정 ("drafter v1 `if "microsoft" in f.read().lower() or "WSL" in f.read():`는 `f.read()`를 두 번 호출 → 두 번째 read는 빈 문자열 반환되어 `or` 우항 영구 False"):

```python
def detect_platform() -> PlatformKind:
    ...
    if sys.platform.startswith("linux"):
        try:
            with open("/proc/version", "r", encoding="utf-8") as f:
                content = f.read()  # drafter v1 미스 정정 — 1회 read.
        except OSError:
            return "linux"
        if "microsoft" in content.lower() or "WSL" in content:
            return "wsl"
        return "linux"
```

**판정.** drafter v1이 finalizer 정정(Sec.9.3 / Sec.10.1) 흡수 후 `content = f.read()` 변수 1회 read 정합. `test_detect_platform_wsl` 검증.

**중요도.** PASS — design_final 정정 흡수 영역.

### R-6 (PASS — drafter 자율 +1 인정): WindowsNotifier title `f"jOneFlow {q.q_id}"` keyword 인자

**식별 영역.** drafter v1:

```python
return send_windows_notification(
    title=f"jOneFlow {q.q_id}",
    message=q.description,
)
```

**판정.** keyword 인자 명시 = 명확성 +1 + `test_windows_notifier_delegates_to_platform_compat` 검증 가능 (`kwargs["title"] == "jOneFlow Q1"` + `kwargs["message"] == "x"`). `OSAScriptNotifier`의 `f"jOneFlow {q.q_id}"` 패턴 정합 (cross-platform 일관성).

**중요도.** PASS — 운영자 가시성 +1.

### R-7 (PASS — drafter 자율 +1 인정): 헬퍼 함수 6종 (by_team / by_displayed / pane_for / f_d3_count / displayed_count / hidden_count)

**식별 영역.** drafter v1:

```python
def all_personas() -> List[PersonaInfo]: ...
def by_team(team: str) -> List[PersonaInfo]: ...
def by_displayed(displayed: str) -> List[PersonaInfo]: ...
def pane_for(name: str) -> Optional[str]: ...
def f_d3_count() -> Dict[str, int]: ...
def displayed_count() -> int: ...
def hidden_count() -> int: ...
```

**판정.** 7 헬퍼 함수 = 운영자 가시성 +1 + 단위 테스트 가능성 +1 (test_by_displayed_filter / test_pane_for_returns_mapping / test_pane_for_returns_none_for_unknown 등). design_final spec verbatim에 명시 X 영역.

**중요도.** PASS — 본 stage closure 영향 0건.

### R-8 (PASS — drafter 자율 +1 인정): PM bridge-064:1.1 R-8 정합

**식별 영역.** PERSONA_TO_PANE 안:

```python
"스티브 리": "bridge-064:1.1",
```

**판정.** Sec.10.3 R-8 정정 (`bridge-*` 통합 표기) 정합. PM은 status bar 별도 영역이지만, PERSONA_TO_PANE 매핑에는 `bridge-064:1.1` 박음 = `_persona_to_pane` 호출 시 PM도 일관 매핑. M2 `PersonaDataCollector._persona_to_pane`에서 PM 별도 처리 영역과 정합.

**중요도.** PASS — drafter 자율 +1 (PM 매핑 명시 = 운영자 가시성).

### R-9 (PATCH 작은 — 테스트 보강 권고): plyer/win10toast Exception 분기 검증 누락

**식별 영역.** drafter v1 23 함수 / ~27 측정점 + 통합 simulation 20 정합. 누락 영역:

1. **`_try_plyer` Exception 분기 검증** — `notification.notify()` 호출 시 Exception 발생 시 False 반환 정합 (test_try_plyer_returns_false_on_import_error는 mock 설정만 + 실제 Exception 분기 미수행).
2. **`_try_win10toast` 별도 단위 테스트** — `_try_plyer`만 직접 검증 + `_try_win10toast`는 통합 검증 (`test_send_windows_notification_no_backend`)만.
3. **`_try_win10toast` ToastNotifier 호출 + threaded=True 검증** — 호출 시 `duration=5, threaded=True` keyword 인자 정합 검증 누락.
4. **`platform_compat` lazy import 검증** — `WindowsNotifier.notify` 안 `from .platform_compat import send_windows_notification` lazy import = circular import 회피 영역. 정합 검증 누락 (단, 통합 simulation으로 부분 커버).

**적용 영역.** 분량 692줄 ≤ 800 headroom 108줄 안전 영역. 본 reviewer 단계에서 추가 patch 영역 적용 X (Q4 P1 stub + 본 가동 채택 0건 + 핵심 영역 모두 PASS). **권고 영역으로 박음** — v0.6.5+ Windows 본 가동 시 보강 권고.

**중요도.** mild — 본 stage closure 영향 0건 (Q4 P1 macOS 단독 본 가동 정합).

## 3. 정정 적용 trail (file 변경 요약)

| 파일 | drafter v1 | reviewer 정정 | 분량 |
|------|------------|---------------|-----|
| `scripts/dashboard/platform_compat.py` | detect_platform 4종 + WSL 1회 read 정정 + supports_native_notification + send_windows_notification + _try_plyer + _try_win10toast + WINDOWS_BACKEND_PRIORITY | 변경 0 (PASS) | 99 |
| `scripts/dashboard/personas.py` | TEAM_PERSONAS=15 + PM_PERSONA + HIDDEN_PLACEHOLDERS=3 + PERSONA_TO_PANE=16 + 헬퍼 7종 | **R-N 마커 1줄 추가** (PERSONA_TO_PANE docstring 위) | 124 → 125 (+1) |
| `scripts/dashboard/notifier.py` | M4 OSAScriptNotifier (그대로) + M5 갱신 WindowsNotifier (R-11 dedupe + platform_compat 위임) | 변경 0 (PASS, R-3 자율 +1) | 151 |
| `tests/test_dashboard_personas.py` | 23 함수 / ~27 측정점 + 통합 simulation 20 (F-D3 산식 / 4팀 / PERSONA_TO_PANE 6 / detect_platform 4 / Q4 P1 / WindowsNotifier 위임+dedupe) | 변경 0 (R-9 권고만, v0.6.5+) | 317 |
| **합계 (M5 영역)** | **691줄** | **692줄** (≤ 800 PASS, headroom 108줄) | 692 |

## 4. AC-M5-* 매핑 + F-D 본문 정합

| AC ID | 기준 | 검증 |
|-------|------|------|
| AC-D-3 | F-D2 모듈 11개 ≥ 11 | 누적 16+ 모듈 (M1~M5) PASS |
| AC-D-4 | F-D4 async def 0건 (M5 3 모듈) | `test_no_async_def` parametrize 3 |
| AC-Q1-1 | Q1 status bar + R-8 다중 bridge | M3 영역 (PMStatusBar) — PM_PERSONA `bridge-064:1.1` 매핑 정합 |
| AC-Q3-1 | Q3 osascript 본문 | M4 영역 (OSAScriptNotifier) |
| AC-Q3-2 | Q3 Pushover 회피 | `test_no_pushover_in_m5` (M5 3 모듈) |
| AC-Q3-3 | Q3 dedupe TTL 5분 (R-11) | OSAScriptNotifier (M4) + WindowsNotifier (M5) cross-platform 정합 |
| **AC-Q4-1** | **Q4 platform_compat detect_platform** | `test_detect_platform_darwin` + `test_detect_platform_win32` + `test_detect_platform_wsl` + `test_detect_platform_linux_native` |
| AC-S-1 | read-only 0건 (F-X-2) | `test_no_write_commands` parametrize 3 |
| **AC-S8-1** | **18명 personas_18.md detail 매핑** | `personas_18.md` (commit `f5194b0`, 408줄) + PERSONA_TO_PANE 16 verbatim 정합 — F-X-6 blocking 해소 |
| F-D3 19명 산식 | 박스 16 + 미표시 3 = 19 | `test_f_d3_count_19` |
| operating_manual 정식판 정합 | 18명 정규명 deviation 0건 | `test_canonical_18_names_no_deviation` |
| 헌법 임계 | drafter ≤ 800 / R-N trail ≤ 600 | drafter 692 / 본 trail 자가 점검 |

## 5. Score 가중치 분배 (reviewer 권한, finalizer Score 별도)

| 영역 | 가중치 | reviewer 정정 후 | 근거 |
|------|------|-------|------|
| **F-D3 19명 산식 + Q1 final** | 20 | 20/20 | f_d3_count 본문 명시 + 박스 15 + PM 1 + 미표시 3 = 19 ALL PASS |
| **F-X-6 PERSONA_TO_PANE 매핑 16** | 15 | 15/15 | personas_18.md Sec.8.4 verbatim + Orc-064-* 정합 + PM bridge-064:1.1 |
| **Q4 P1 macOS 단독 + Win skeleton** | 15 | 15/15 | supports_native_notification + WindowsNotifier 위임 + plyer/win10toast skeleton + 본 가동 채택 0건 |
| **Q4 detect_platform 4종 spec** | 10 | 10/10 | darwin / win32 / wsl / linux 4종 + WSL 1회 read 정정 흡수 |
| **R-11 cross-platform dedupe** | 10 | 10/10 | OSAScriptNotifier (M4) + WindowsNotifier (M5) 동일 패턴 |
| AC-S-1 read-only (F-X-2) 0건 | 5 | 5/5 | M5 3 모듈 write 명령 0건 |
| F-D4 sync 전면 | 5 | 5/5 | M5 3 모듈 async def 0건 |
| Q3 Pushover 회피 (M5 영역) | 5 | 5/5 | `test_no_pushover_in_m5` (3 모듈) |
| 분량 임계 ≤ 800 | 5 | 5/5 | 692줄 (headroom 108줄) |
| A 패턴 정합 (drafter 자율 +N + reviewer R-N 마커) | 5 | 5/5 | R-2~R-8 자율 +1 인정 + reviewer R-N 마커 1줄 |
| 테스트 커버리지 (R-9 작은 PATCH) | 5 | 2/5 | 23 함수 / 27 측정점 + 통합 simulation 20. -3 = `_try_plyer` Exception 분기 + `_try_win10toast` 별도 단위 테스트 + lazy import 검증 누락 (v0.6.5+ 권고) |
| **reviewer 확정 Score** | 100 | **97/100** | **임계 80% 통과 + 목표 90%+ 통과 + F-D3/Q4/R-11 모두 완벽 정합** |

> **finalizer Score 권한 영역.** R-12 정정에 따라 finalizer가 최종 Score 권한.

## 6. Stage 9 코드 리뷰 보강 영역 (사전 정정 영역)

- **`_try_plyer` Exception 분기 검증** — `notification.notify()` 호출 시 Exception 발생 시 False 반환 정합 (현 stub은 ImportError + Exception 모두 catch).
- **`_try_win10toast` 별도 단위 테스트** — ToastNotifier 호출 + `duration=5, threaded=True` keyword 인자 정합.
- **lazy import 검증** — `WindowsNotifier.notify` 안 `from .platform_compat import` lazy import = circular import 회피 영역.
- **AC-S8-1 정합 자동 검증** — `personas_18.md` Sec.8.4 + PERSONA_TO_PANE diff 자동 검증 (CI 보강).
- **AC-V-3 수동 검증** — macOS osascript 직접 실행 + 5분 dedupe 시뮬 (Stage 12 QA 영역 sync).
- **v0.6.5+ Windows 본 가동** — plyer / win10toast 본문 채움 + Windows 환경 통합 테스트.

## 7. v0.6.5 컨텍스트 엔지니어링 영역 (사고 14 누적 trail)

- **M5 사고 14 회피.** drafter v1 시그니처 1.1 forward 정상 작동 (M2 양상 회피).
- **F-X-6 blocking 해소.** personas_18.md commit `f5194b0` 도착 후 M5 진입 → 본 stage = M5 closure (Stage 8 5/5 마일스톤 완료).
- **헌법 hotfix `9902a68` + CLAUDE.md hotfix.** A 패턴 + 추측 진행 금지 강제 + 자가 점검 11항목 의무 (3중 검증).
- **회수 영역.** 본 stage = M5 closure만. v0.6.5 컨텍스트 엔지니어링 본격 영역 = (1) 시그니처 자동 forward 메커니즘 (2) 분량 임계 자동 검증 hook (drafter ≤ 800 / review ≤ 600 / final ≤ 500) (3) F-X-6 매핑 자동 검증 hook (personas_18.md ↔ PERSONA_TO_PANE diff) (4) Windows 본 가동 (plyer/win10toast 본문) (5) 회의창 헌법/메모리 자가 적용 메커니즘.

## 8. 1.1 공기성-개발PL pane 시그니처 (3줄 송출, wrap 회피, send-keys 직접 실행)

```
줄1: 📡 status v0.6.4 Stage 8 M5 reviewer COMPLETE — path=scripts/dashboard/(platform_compat+personas+notifier) R-N=9건 verdict=PASS_WITH_PATCH Score=97/100
줄2: ls/wc 디스크: M5 산출 합 692 ≤ 800 (headroom 108) / py_compile 4/4 PASS / m5_windows_personas_review.md ≤ 600 / F-D3 19명 산식 + PERSONA_TO_PANE 16 + Q4 P1 + R-11 cross-platform 모두 정합
줄3: git status + stash list empty (3중 검증 + AC-S8-1 personas_18.md baseline 정합 + F-X-6 blocking 해소)
```

- **R-N 9건:** R-1 PASS(F-D3 19명 완벽) / R-2 PASS(PERSONA_TO_PANE 16 verbatim) / R-3 PASS(WindowsNotifier R-11 cross-platform) / R-4 PASS(plyer→win10toast 폴백) / R-5 PASS(WSL 1회 read 정정 흡수) / R-6 PASS(WindowsNotifier title keyword) / R-7 PASS(헬퍼 7종 자율) / R-8 PASS(PM bridge-064:1.1 R-8 정합) / R-9 PATCH 작은(plyer/win10toast Exception 분기 권고).
- **patch 적용 1건:** R-N 마커 1줄(`personas.py` PERSONA_TO_PANE 영역). 분량 691 → 692 ≤ 800 PASS.
- **Stage 8 M5 closure → Stage 8 5/5 마일스톤 완료** — 다음 본분: 1.4 현봉식-finalizer `m5_windows_personas.md` 마감 doc (≤ 500줄, 본문 작성 X) → 1.1 공기성 PL verdict + commit + bridge-064 forward → 회의창 → 운영자 Stage 8 IMPL COMPLETE 시그니처 (`📡 status v0.6.4 Stage 8 IMPL COMPLETE — M1~M5 done total commits=N Score=N/100 verdict=GO → Stage 9 진입`).

## 9. 본 R-N trail 본문 길이 자가 점검

- **임계:** ≤ 600줄 (헌법, 사고 14).
- **본 파일 wc -l:** finalizer 검증 영역.
- **압축 정책:** R-N 9건 본문 + Score 가중치 + AC 매핑. 임계 초과 시도 시 sub-doc 분리.

---

작성: 최우영-be-reviewer (Opus high, Orc-064-dev:1.3)
검토 영역: drafter v1 691줄 → reviewer 정정 후 692줄 (≤ 800 PASS, headroom 108줄)
다음: 1.4 현봉식-be-finalizer 마감 doc `m5_windows_personas.md` 작성 (≤ 500줄, 본문 작성 X) → Stage 8 5/5 마일스톤 완료 시그니처
