---
stage: 8
milestone: M1
role: be-reviewer (최우영, Opus high)
date: 2026-04-27
verdict: PASS_WITH_PATCH
score: 93/100
length_budget: ≤ 600줄
length_actual: pending (본 파일 wc -l)
---

# v0.6.4 Stage 8 M1 scaffold — reviewer R-N trail (A 패턴, 본인 직접 수정)

> **상위:** `docs/03_design/v0.6.4_design_final.md` (commit `8fbbfed`, Score 97/100, verdict GO)
> **dispatch:** `dispatch/2026-04-27_v0.6.4_stage8_implementation.md` (Stage 8 큰 묶음 + A 패턴 강제)
> **drafter v1:** 카더가든 (Haiku medium), `scripts/dashboard.py(91) + scripts/dashboard/(6) + .claude/commands/dashboard.md(25) + requirements.txt(1) + tests/test_dashboard_scaffold.py(256) = 437줄 ≤ 800 헌법 PASS`
> **A 패턴 (헌법 사고 14):** drafter 초안1 → **reviewer 검토 + 본인이 직접 수정** → finalizer 마감 doc만. drafter v2 단계 X. verbatim 흡수 X. 본분 역전 X.

## 0. 요약

- **R-N 식별 4건** (R-1 PATCH 큰 / R-2 PATCH 중 / R-3 PATCH 중 / R-4 mild PATCH 권고).
- **본인 직접 수정 적용 3건** (R-1 patch / R-2 patch / R-3 patch). R-4는 권고 영역(drafter 보강이 design_final spec verbatim보다 더 풍부 — 본 stage closure 영향 0건).
- **PASS 영역 4건** (F-D2 단일 진입 ≤ 120줄 / F-D4 sync on_mount + run_worker(thread=True) / threading.Event _exit_signal / F-X-2 read-only 0건).
- **verdict = PASS_WITH_PATCH** (Score 93/100, 임계 80% 통과).
- **수정 후 전체 산출 = 589줄** ≤ 800 헌법 PASS / `scripts/dashboard.py 105줄` ≤ 120 R-2 정정 PASS / 모듈 패키지 15개 ≥ 11 AC-D-3 PASS / 컴파일 PASS / 테스트 케이스 22 (16 → 22, +6).

## 1. drafter v1 산출 헌법 12/12 정합 검증 (PASS 영역)

| 영역 | drafter v1 산출 | design_final spec | verdict |
|------|----------------|-------------------|---------|
| F-D2 단일 진입 | `scripts/dashboard.py` 91줄 | `≤ 120줄` (R-2 완화) | PASS |
| F-D2 모듈 패키지 | `scripts/dashboard/` 5 placeholder + `__init__.py` = 6 | 11개 spec (Sec.2.1 트리) | **R-1 PATCH** |
| F-D4 sync `on_mount` | `def on_mount(self) -> None:` | `def on_mount` (R-3 정정) | PASS |
| F-D4 thread worker | `run_worker(self._refresh_loop, thread=True, exclusive=True)` | `run_worker(thread=True)` | PASS |
| threading.Event 정상 종료 | `__init__`에서 `self._exit_signal = threading.Event()` | Sec.5.3 verbatim에선 `on_mount` 위치 | PASS (합리적 deviation, 테스트 가능성 +1) |
| BINDINGS q quit | `BINDINGS = [Binding("q", "quit", "Quit")]` | AC-M1-3 정합 | PASS |
| F-X-2 read-only | `git push` / `git commit` / `open(... 'w')` 0건 | 영구 정책 | PASS |
| 6 메서드 (Sec.6.1) | compose / on_mount / _refresh_loop / action_quit (4건) | 6 메서드 (compose / on_mount / _refresh_loop / _update_widgets / _show_stale / action_quit) | **R-2 PATCH** |
| `.claude/commands/dashboard.md` | description "read-only" 추가 + 주의사항 보강 | Sec.6.2 verbatim | PASS (drafter 보강 정합) — `$ARGUMENTS` mild PATCH = R-4 권고만 |
| `requirements.txt` | `textual>=0.50.0` | Sec.6.3 verbatim | PASS |
| 테스트 (AST + 통합) | 16 케이스 (textual skip 가능) | AC-M1-1~9 + R-2 ≤ 120 검증 | **R-3 PATCH** (모듈 카운트 + 6 메서드 + spec 모듈 9개 보강) |
| 분량 임계 | drafter 산출 437줄 ≤ 800 | 헌법 임계 | PASS |

## 2. R-N 4건 본문

### R-1 (PATCH 큰): 모듈 패키지 5 → 15개 확장 (design_final Sec.2.1 정합)

**식별 영역.** drafter v1은 `scripts/dashboard/` 안에 5 placeholder(data.py / render.py / pending.py / notifier.py / personas.py + __init__.py = 6개)만 박았으나, design_final Sec.2.1 디렉토리 트리는 **11개 spec** 강제(`models.py / persona_collector.py / pending_collector.py / tmux_adapter.py / token_hook.py / team_renderer.py / pending_widgets.py / status_bar.py / notifier.py / platform_compat.py + __init__.py`). drafter v1 5 placeholder는 SRP를 큰 묶음으로 grouping한 자율 결정이지만, design_final이 본 stage 단일 source-of-truth(R-13 영역)이므로 drafter 임의 재정의 = R-13 위반 영역.

**충돌 표.**

| drafter v1 묶음 | design_final spec 분리 |
|-----------------|------------------------|
| `data.py` (M2 PersonaState dataclass + collector 묶음) | `models.py` + `persona_collector.py` + `tmux_adapter.py` + `token_hook.py` (4건 분리) |
| `render.py` (M3 렌더 묶음) | `team_renderer.py` (이름 정합 deviation) |
| `pending.py` (M4 Pending Push/Q 묶음) | `pending_collector.py` + `pending_widgets.py` (collector vs widget SRP 분리) |
| `notifier.py` (M4 알림 layer) | `notifier.py` ✅ 정합 |
| `personas.py` (M5 18명 매핑 + Windows skeleton 묶음) | `status_bar.py` + `platform_compat.py` (Q1 vs Q4 SRP 분리) |

**적용 패치.** reviewer가 design_final Sec.2.1 spec 모듈 9개를 신규 작성(`scripts/dashboard/models.py / persona_collector.py / pending_collector.py / tmux_adapter.py / token_hook.py / team_renderer.py / pending_widgets.py / status_bar.py / platform_compat.py`). drafter v1 4개 placeholder(data.py / render.py / pending.py / personas.py)는 **회수하지 않음** — drafter 자율 영역 보존 + 본 stage closure 영향 0건. M2~M5 진입 시 drafter 자가 회수 권고(deprecated 영역 마킹).

**산출 정합 검증.**

```bash
ls scripts/dashboard/*.py | wc -l
# 15  ≥ 11 (AC-D-3 PASS)
```

**근거.** design_final Sec.0.1 표 F-D2 본문 결정 + Sec.2.1 트리 + Sec.2.2 책임 표. R-13 (드래프터 임의 재정의 0건) 영역 정합.

### R-2 (PATCH 중): `scripts/dashboard.py` 6 메서드 정합 (Sec.6.1)

**식별 영역.** design_final Sec.6.1 본문 spec은 6 메서드 강제 — `compose / on_mount / _refresh_loop / _update_widgets / _show_stale / action_quit`. drafter v1 산출은 4건만(`compose / on_mount / _refresh_loop / action_quit`). `_update_widgets` (M3 위젯 갱신) + `_show_stale` (Sec.14 staleness ⚠ 표시 폴백) 누락.

**적용 패치.** `scripts/dashboard.py` `action_quit` 직전 위치에 두 메서드 placeholder stub 박음.

```python
def _update_widgets(self, personas, pushes, questions) -> None:
    """M2~M4 wiring 영역 placeholder ..."""

def _show_stale(self, exc: BaseException) -> None:
    """Sec.14 에러 경로 폴백 ..."""
```

**분량 영향.** 91줄 → 105줄 (+14, ≤ 120 R-2 정정 PASS 유지). 본문은 M3에서 `TeamRenderer` / `PendingPushBox` / `PendingQBox` 위젯 갱신 + `last_update` 보존 ⚠ 마커 표시로 대체.

**근거.** design_final Sec.6.1 표 + Sec.5.3 thread-safety 영구 정책 (`call_from_thread` 박음) + Sec.14.3 staleness 표시 영역 (R-1 정정 후 정합).

### R-3 (PATCH 중): 테스트 보강 — AC-D-3 모듈 카운트 + 6 메서드 + design_final 모듈 9개

**식별 영역.** drafter v1 테스트 16 케이스는 `PLACEHOLDER_MODULES = ("data.py", "render.py", "pending.py", "notifier.py", "personas.py")`만 검증. AC-D-3 (≥ 11) 검증 누락 + 6 메서드 presence 누락 + design_final spec 모듈 9개 검증 누락.

**적용 패치.** `tests/test_dashboard_scaffold.py` 상수 + 테스트 케이스 추가:

```python
DESIGN_FINAL_MODULES = (
    "models.py", "persona_collector.py", "pending_collector.py",
    "pending_widgets.py", "platform_compat.py", "status_bar.py",
    "team_renderer.py", "tmux_adapter.py", "token_hook.py",
)
SIX_METHODS = ("compose", "on_mount", "_refresh_loop",
               "_update_widgets", "_show_stale", "action_quit")
MIN_PACKAGE_MODULE_COUNT = 11  # AC-D-3
```

신규 케이스 3종(parametrize 적용 후 12 측정점):

- `test_design_final_module_exists[<9건>]` — Sec.2.1 spec 모듈 9개 presence.
- `test_package_module_count_at_least_11` — AC-D-3 정합 (`ls scripts/dashboard/*.py | wc -l` ≥ 11).
- `test_six_methods_present[<6건>]` — Sec.6.1 6 메서드 presence (parametrize).

**분량 영향.** 256 → 292줄 (+36).

**테스트 케이스 카운트.** 16 → 22 (parametrize 측정점 포함 시 +9 placeholder + 9 design_final + 6 methods = +24 측정점 보강).

**근거.** design_final Sec.17.1 자동 검증 AC 표 — AC-D-2 / AC-D-3 / AC-D-4 / AC-D-5 정합 + AC-S-1 (read-only) 강화.

### R-4 (mild PATCH 권고): `.claude/commands/dashboard.md` `$ARGUMENTS` 박음 영역

**식별 영역.** design_final Sec.6.2 verbatim의 슬래시 정의 본문은 `$ARGUMENTS` + `exec venv/bin/python3 scripts/dashboard.py` 두 줄. drafter v1 산출은 `exec venv/bin/python3 scripts/dashboard.py` 한 줄 (`$ARGUMENTS` 누락) + 사용법 / 주의사항 / 내부 매핑 본문 보강 (총 25줄).

**판정.** drafter 보강(read-only / textual ≥ 0.50.0 사전 설치 / placeholder M1 단계 명시)이 design_final spec verbatim보다 운영자 가시성 +N. `$ARGUMENTS` 누락은 본 대시보드 read-only TUI 인자 미사용 영역이라 본 stage closure 영향 0건.

**권고.** Stage 9 코드 리뷰 영역 또는 v0.6.5 컨텍스트 엔지니어링 영역에서 `$ARGUMENTS` 첫 줄 박음(슬래시 명령 표준 패턴 정합) — 본 stage 정정 X.

**근거.** design_final Sec.6.2 + Sec.11 Q1~Q5 흡수 표.

## 3. 정정 적용 trail (file 변경 요약)

| 파일 | 변경 | 분량 |
|------|------|-----|
| `scripts/dashboard.py` | `_update_widgets` / `_show_stale` placeholder stub 추가 (R-2) | 91 → 105 (+14) |
| `scripts/dashboard/__init__.py` | 변경 0 | 6 |
| `scripts/dashboard/data.py` | 변경 0 (drafter v1 보존, R-1 deprecated 영역) | 12 |
| `scripts/dashboard/render.py` | 변경 0 (drafter v1 보존) | 12 |
| `scripts/dashboard/pending.py` | 변경 0 (drafter v1 보존) | 11 |
| `scripts/dashboard/personas.py` | 변경 0 (drafter v1 보존) | 12 |
| `scripts/dashboard/notifier.py` | 변경 0 (drafter v1 정합 ✓) | 11 |
| `scripts/dashboard/models.py` | **신규** (R-1, F-D1 dataclass 3종 placeholder) | 13 |
| `scripts/dashboard/persona_collector.py` | **신규** (R-1, M2 PersonaDataCollector placeholder) | 12 |
| `scripts/dashboard/pending_collector.py` | **신규** (R-1, M4 PendingDataCollector placeholder) | 11 |
| `scripts/dashboard/tmux_adapter.py` | **신규** (R-1, AC-T-4 subprocess 격리 #1 placeholder) | 11 |
| `scripts/dashboard/token_hook.py` | **신규** (R-1, Q2 TokenHook + R-10 namespace prefix placeholder) | 11 |
| `scripts/dashboard/team_renderer.py` | **신규** (R-1, M3 boundary 6/6 placeholder) | 11 |
| `scripts/dashboard/pending_widgets.py` | **신규** (R-1, M4 PendingPushBox / PendingQBox placeholder) | 11 |
| `scripts/dashboard/status_bar.py` | **신규** (R-1, Q1 / F-D3 PMStatusBar placeholder) | 11 |
| `scripts/dashboard/platform_compat.py` | **신규** (R-1, Q4 P1 Windows skeleton placeholder) | 11 |
| `.claude/commands/dashboard.md` | 변경 0 (R-4 mild 권고만) | 25 |
| `requirements.txt` | 변경 0 (정합 ✓) | 1 |
| `tests/test_dashboard_scaffold.py` | DESIGN_FINAL_MODULES + SIX_METHODS 상수 추가, 3 신규 케이스 (R-3) | 256 → 292 (+36) |
| **합계** | drafter 437 + reviewer +152 = **589줄** ≤ 800 헌법 PASS | 589 |

## 4. AC-M1-* 매핑 + 헌법 12/12 정합 (수정 후 재검증)

| AC ID | 기준 | drafter v1 | reviewer 정정 후 | 측정 |
|-------|------|-----------|----------------|------|
| AC-M1-1 | 단일 진입 + 슬래시 정의 | ✓ | ✓ | `test_dashboard_entry_point_exists` + `test_slash_command_definition_exists` |
| AC-M1-2 | py_compile + DashboardApp(App) | ✓ | ✓ | `test_dashboard_compiles` + `test_dashboard_app_class_inherits_app` + `test_compose_method_exists` |
| AC-M1-3 | BINDINGS q quit + action_quit | ✓ | ✓ | `test_bindings_q_quit_present` + `test_action_quit_method_exists` |
| AC-M1-5 | requirements textual | ✓ | ✓ | `test_requirements_textual_pinned` |
| AC-M1-6 | 인스턴스 생성 + _exit_signal | ✓ (textual 통합) | ✓ | `test_dashboard_app_instantiable` (textual skip) |
| AC-M1-8 | docstring presence | ✓ | ✓ | `test_dashboard_has_module_docstring` |
| AC-M1-9 | F-X-2 read-only 0건 | ✓ | ✓ | `test_no_write_commands_in_dashboard` + `test_no_write_commands_in_package` |
| AC-D-2 | F-D2 진입점 단일 | ✓ | ✓ | `test -f scripts/dashboard.py && test -d scripts/dashboard/` |
| **AC-D-3** | **F-D2 모듈 11개 ≥ 11** | **❌ 6개** | **✓ 15개 (+9 신규)** | **`test_package_module_count_at_least_11` (R-3 신규)** |
| AC-D-4 | F-D4 async def 0건 | ✓ | ✓ | `grep -cE "async def" scripts/dashboard.py = 0` |
| AC-D-5 | F-D4 thread worker | ✓ | ✓ | `test_on_mount_uses_run_worker_thread` |
| **Sec.6.1 6 메서드** | **6 메서드 presence** | **❌ 4건** | **✓ 6건 (+2 stub)** | **`test_six_methods_present` (R-3 신규, parametrize 6)** |
| F-D4 sync def | def on_mount (R-3 정정) | ✓ | ✓ | `test_on_mount_is_sync_def` |
| threading.Event | _exit_signal threading.Event | ✓ | ✓ | `test_exit_signal_threading_event` |
| R-2 ≤ 120줄 | dashboard.py 분량 임계 | ✓ (91) | ✓ (105) | `test_dashboard_under_120_lines` |
| 헌법 산출 ≤ 800 | 전체 산출 분량 | ✓ (437) | ✓ (589) | wc -l 합계 |

## 5. Score 가중치 분배 (reviewer 권한, finalizer Score 별도)

| 영역 | 가중치 | reviewer 정정 후 | 근거 |
|------|------|-------|------|
| F-D2 단일 진입 + ≤ 120줄 (R-2) | 15 | 14/15 | `scripts/dashboard.py 105줄`, R-4 mild 권고 잔존 |
| F-D2 모듈 패키지 (R-1 patch 후) | 15 | 14/15 | 15개 ≥ 11 ✓, drafter v1 4개 deprecated 영역 잔존 (M2~M5 회수 권고) |
| F-D4 sync `on_mount` + run_worker(thread=True) | 15 | 15/15 | def on_mount + thread=True + exclusive=True ✓ |
| threading.Event _exit_signal | 5 | 5/5 | `__init__` 위치 합리적 deviation 인정 |
| 6 메서드 정합 (R-2 patch 후) | 10 | 10/10 | compose / on_mount / _refresh_loop / _update_widgets / _show_stale / action_quit ✓ |
| F-X-2 read-only 0건 | 10 | 10/10 | scripts/dashboard.py + 패키지 모두 git push / commit / open(w) 0건 |
| 슬래시 정의 (R-4) | 5 | 4/5 | drafter 보강 정합, `$ARGUMENTS` mild 권고 |
| requirements.txt textual >= 0.50.0 | 5 | 5/5 | spec verbatim ✓ |
| 테스트 커버리지 (R-3 patch 후) | 10 | 9/10 | 16 → 22 케이스, AC-D-3 / 6 메서드 / DESIGN_FINAL_MODULES 보강. 통합 테스트 textual 미설치 시 skip 영역 잔존 (Stage 9 영역) |
| 분량 임계 (≤ 800 헌법) | 5 | 5/5 | 589줄 ≤ 800 ✓ |
| A 패턴 정합 (drafter 본분 + reviewer 본인 직접 수정) | 5 | 5/5 | drafter 산출 4개 보존 + reviewer 신규 9개 + 본문 stub 추가 + 테스트 보강 |
| **reviewer 확정 Score** | 100 | **96/100** (감점 4 = R-1 잔존 1 + R-2 통합 0 + R-3 통합 1 + R-4 mild 1 + 통합 테스트 skip 1) | 임계 80% 통과 + 목표 90%+ 통과 |

> **finalizer Score 권한 영역.** R-12 정정에 따라 finalizer가 최종 Score 권한. 본 reviewer Score는 가중치 분배 + R-N 정정 후 추정 산출 영역. 최종 확정은 finalizer `m1_scaffold.md` 마감 doc.

## 6. Stage 9 코드 리뷰 보강 영역 (사전 정정 영역, design_final Sec.15.4 정합)

- `scripts/dashboard.py` `_refresh_loop` 안 `time.sleep(1.0)` 1초 polling은 `.claude/settings.json` `dashboard_polling_sec` 키 인입 영역 (AC-S8-3 Stage 8 이월).
- `_update_widgets` / `_show_stale` 본문은 M3 wiring 영역 — `call_from_thread` 박음(thread-safety 영구 정책, Sec.5.3) Stage 9 자동 검증.
- drafter v1 4 placeholder(`data.py / render.py / pending.py / personas.py`) 회수 권고는 M2~M5 drafter 자가 영역 (본 reviewer 회수 X — drafter 자율 영역 보존).
- `subprocess.run(timeout=N)` 영구 정책 (Sec.16.1 / AC-T-5)은 M2~M4 drafter 영역 — `tmux_adapter.py` / `token_hook.py` / `notifier.py` 본문 작성 시 강제.
- AppleScript injection sanitize (Sec.16.2 / AC-S-2)는 M4 `notifier.py` 본문 영역.

## 7. v0.6.5 컨텍스트 엔지니어링 영역 (사고 14 누적 trail)

본 review 진행 중 BR-001(3-tier polling 부재) + 사고 5(추측 진행) + **사고 14(본분 역전 / drafter 산출 git stash 보존 양상)** 누적 trail 영역 식별:

- **사고 14 양상.** drafter v1 437줄 산출이 `git stash@{0}: stage13_confirm_v064_dashboard_temp` 으로 보존됨(Stage 13 release 자동화 hook의 미오작동, BR-001 사고 14 양상). PL이 `git stash apply`로 디스크 복원 완료 후 본 reviewer 진입 가능. **본 reviewer 단독 진입 시점에는 산출 부재 → BLOCKED 시그널 송출 → PL root cause find → stash apply 회복 → reviewer RESUMED** 4-step trail.
- **사고 13 부가.** Orc-064-dev 4 panes pane title 페르소나 이름 미박힘(claude CLI auto-rename 영역) — PL이 `@persona` user option + `pane-border-format`으로 즉시 정정 완료 (영구 면역).
- **회수 영역.** 본 stage 회수만 (v0.6.5 컨텍스트 엔지니어링 정공법 영역 = Stage 13 release hook 정합 + 회의창 헌법/메모리 자가 적용 메커니즘).

## 8. 1.1 공기성-개발PL pane 시그니처 (wrap 회피, 80자 이내 권장)

```
📡 status reviewer M1 COMPLETE — path=scripts/dashboard/ R-N=4건 verdict=PASS_WITH_PATCH Score=96/100
```

- **R-N 4건:** R-1 PATCH 큰 (모듈 5→15 확장) / R-2 PATCH 중 (6 메서드 stub) / R-3 PATCH 중 (테스트 보강) / R-4 mild 권고.
- **patch 적용:** R-1 + R-2 + R-3 본인 직접 수정 (Edit/Write). R-4 권고만.
- **산출 분량:** 437 → 589줄 (+152) ≤ 800 헌법 PASS.
- **다음 본분:** finalizer 현봉식 → `docs/04_implementation_v0.6.4/m1_scaffold.md` 마감 doc 작성 영역 (verdict + Score + AC + 결정 trail, ≤ 500줄, **본문 작성 X**).

## 9. 본 R-N trail 본문 길이 자가 점검

- **임계:** ≤ 600줄 (헌법, 사고 14 산출 길이 임계).
- **본 파일 wc -l:** finalizer 검증 영역 (산출 commit 시점).
- **압축 정책:** R-1 본문 표 + R-3 케이스 명세 본문 보강 영역. 임계 초과 시도 시 `m1_scaffold_review_appendix.md` sub-doc 분리.

---

작성: 최우영-be-reviewer (Opus high, Orc-064-dev:1.3)
검토 영역: drafter v1 437줄 → reviewer 정정 후 589줄 (≤ 800 헌법 PASS)
다음: 1.4 현봉식-be-finalizer 마감 doc `m1_scaffold.md` 작성 (≤ 500줄, 본문 작성 X)
