---
stage: 8
milestone: M3
role: be-reviewer (최우영, Opus high)
date: 2026-04-27
verdict: PASS_WITH_PATCH
score: 96/100
length_budget: ≤ 600줄
length_actual: pending (본 파일 wc -l)
---

# v0.6.4 Stage 8 M3 렌더 layer — reviewer R-N trail (A 패턴 / 헌법 hotfix `9902a68`)

> **상위:** `docs/03_design/v0.6.4_design_final.md` Sec.8 (렌더링 layer) + Sec.10.3 (Q1/F-D3 final 19명 표시) + Sec.11.1 (Q1 흡수) + Sec.13 (boundary 6건 본문).
> **dispatch:** `dispatch/2026-04-27_v0.6.4_stage8_implementation.md` Sec.핵심작업 M3 (렌더 boundary 6건 본문, 박스 3개 + PM status bar 1행 + 진행률 바 + 스파크라인 + placeholder).
> **drafter v1:** 카더가든 (Haiku medium), `render.py(67) + status_bar.py(73) + team_renderer.py(152) + personas.py(74) + dashboard.tcss(92) + tests/test_dashboard_render.py(262) = 720→721줄`. drafter 22/22 검증 PASS / 중단 조건 0건 / BR-001 stash 회피 PASS.
> **헌법 hotfix `9902a68`:** A 패턴 = drafter → reviewer **본인 직접 수정** + R-N 마커 → finalizer 마감 doc만. drafter v2 단계 X. verbatim 흡수 X. 모든 프로세스 동일 적용.

## 0. 요약

- **R-N 식별 7건** — R-1 PASS(SRP 분리 자율 +1) / R-2 PASS(fetch public 자율 +1) / R-3 PATCH 작은(테스트 보강 권고) / R-4 PASS(_slug 자율 +1) / R-5 PASS(.status-stale 자율 +1) / R-6 PASS(PersonaInfo TypedDict 자율 +1) / R-7 PASS(_fetch_pm_state 본문 완성 자율 +1).
- **본인 직접 수정 적용 1건** — R-N 마커 1줄 추가(`render.py` `TEAM_ORDER` 위 `# R-N reviewer 검증 (M3 PASS_WITH_PATCH) — boundary 6/6 모두 정합 + SRP 분리(3 클래스).`). 분량 720 → 721 ≤ 800 PASS.
- **분량 임계 헌법 정합:** drafter 산출 721줄 ≤ 800 / R-N trail ≤ 600 / py_compile 5/5 PASS.
- **A 패턴 정합:** drafter v1 본문 자율 deviation 6건(SRP 분리 / fetch public / _slug / .status-stale / PersonaInfo / _fetch_pm_state 완성) + reviewer 본인 직접 R-N 마커 + finalizer 본문 작성 X 영역.
- **boundary 6/6 ALL PASS:** #1 색상 11종 + #2 margin·padding·border round + #3 진행률 바 8칸 4단계 + #4 스파크라인 8칸 8단계 + #5 placeholder 3종 + #6 PM status bar 1행.
- **verdict = PASS_WITH_PATCH Score 96/100** (임계 80% 통과 + 목표 90%+ 통과).

## 1. boundary 6/6 본문 정합 검증 (ALL PASS)

| boundary slot | drafter v1 산출 | design_final spec | 검증 위치 | verdict |
|---------------|----------------|-------------------|-----------|---------|
| **#1 색상 11종 + App{}** | dashboard.tcss = `$primary, $secondary, $accent, $success, $warning, $error, $surface, $panel, $background, $boost, $foreground` (11종) + `App { background: $background; color: $foreground; }` | Sec.13 boundary slot #1 | `test_boundary_1_eleven_colors_in_css` + `test_boundary_1_app_selector_present` | PASS |
| **#2 margin·padding·border round** | dashboard.tcss + team_renderer.py DEFAULT_CSS = `border: round $primary` + `padding: 0 1` + `margin: 0 1` + `width: 1fr` + `height: 1fr` | Sec.13 boundary slot #2 | `test_boundary_2_margin_padding_border_round` | PASS |
| **#3 진행률 바 8칸 4단계** | team_renderer.py `PROGRESS_LEVELS = (" ", "░", "▒", "█")` 4 unique + `PROGRESS_CELLS = 8` + `progress_bar(tokens_k)` cell 매핑 함수 | Sec.13 boundary slot #3 | `test_boundary_3_progress_bar_constants` + `test_boundary_3_progress_bar_zero_full` + `test_boundary_3_progress_bar_partial` | PASS |
| **#4 스파크라인 8칸 8단계** | team_renderer.py `SPARK_LEVELS = chr(0x2581+i) for i in range(8)` (U+2581~U+2588 = ▁▂▃▄▅▆▇█) + `SPARK_CELLS = 8` + `sparkline(history)` 정규화 함수 | Sec.13 boundary slot #4 | `test_boundary_4_sparkline_constants` + `test_boundary_4_sparkline_render` + `test_boundary_4_sparkline_empty` | PASS |
| **#5 placeholder 3종** | personas.py `HIDDEN_PLACEHOLDERS = [{CTO 백현진}, {CEO 이형진}, {(HR TBD)}]` (3종) | Sec.13 boundary slot #5 | `test_boundary_5_placeholder_three` + `test_boundary_5_19_persona_sum` | PASS |
| **#6 PM status bar 1행** | status_bar.py `PMStatusBar` `height: 1` + `format = "PM 스티브 리 [<◉/○> <status>] | <task> | tokens: <N.N>k | active orcs: <list>"` + R-8 다중 bridge 통합 | Sec.13 boundary slot #6 + Sec.10.3 R-8 정정 | `test_boundary_6_status_bar_height_one` + `test_boundary_6_multi_bridge_aggregation` | PASS |

## 2. F-D3 19명 산식 정합 (PASS)

| 영역 | drafter v1 | design_final spec | 검증 |
|------|-----------|-------------------|------|
| **박스 영역 15** | personas.py `TEAM_PERSONAS` = 15 (기획 4 + 디자인 4 + 개발 7) | Sec.11.1 verbatim | `test_boundary_5_19_persona_sum` (`len(TEAM_PERSONAS) == 15`) |
| **PM status bar 1** | personas.py `PM_PERSONA = {"name": "스티브 리", "team": None, "displayed": "status_bar"}` + status_bar.py `PMStatusBar` | Sec.10.3 verbatim | `test_boundary_5_19_persona_sum` (`PM_PERSONA["displayed"] == "status_bar"`) |
| **미표시 placeholder 3** | personas.py `HIDDEN_PLACEHOLDERS` = (CTO 백현진 / CEO 이형진 / HR TBD) | Sec.13 boundary slot #5 | `test_boundary_5_placeholder_three` (`{"CTO", "CEO", "HR"}`) |
| **합계 19** | `all_personas() = TEAM_PERSONAS + [PM_PERSONA] + HIDDEN_PLACEHOLDERS = 19` | Sec.11.1 19명 산식 | `test_boundary_5_19_persona_sum` (`len(all_personas()) == 19`) |
| **박스 3개** | render.py `TEAM_ORDER = ("기획", "디자인", "개발")` + `compose()` `for team in TEAM_ORDER: yield TeamRenderer(team=team, id=f"team_{slug}")` | Sec.8.2 layout 정합 | `test_render_single_entry_signature` |

## 3. R-N 7건 본문

### R-1 (PASS — drafter 자율 SRP 분리 +1 인정): TeamRenderer 단일 클래스 vs 3 클래스 분리

**식별 영역.** design_final Sec.8.1 verbatim:

```python
class TeamRenderer(Static):
    """M3 — 박스 3개(기획/디자인/개발) + 행 렌더링 + 다중 버전 sub-row."""
    
    def render(self, teams_data: Dict[str, List[PersonaState]]) -> str:
        for team in ["기획", "디자인", "개발"]:
            ...
```

drafter v1 구현:

```python
# render.py
class DashboardRenderer(Container):
    def compose(self) -> ComposeResult:
        yield PMStatusBar(id="pm_status_bar")
        with Horizontal(id="team_grid"):
            for team in TEAM_ORDER:
                yield TeamRenderer(team=team, id=f"team_{slug}")

# team_renderer.py
class TeamRenderer(Vertical):
    """M3 — 단일 팀 박스."""
```

**판정.** drafter 자율 SRP +1 영역:
- DashboardRenderer = 통합 진입 + 박스 3개 + PM bar 합성 (top-level 단일 진입).
- TeamRenderer = 단일 팀 박스 (Vertical Container, individual update + textual id query).
- PMStatusBar = PM 별도 위젯.
- 3 클래스 분리 = 단위 테스트 가능성 +1, individual update +1, textual id 호환 +1.

**근거.** F-D2 SRP 정합 영역 (모듈 패키지 11개 spec). design_final Sec.0.1 F-D2 본문 결정 verbatim 정합 — drafter 자율 결정으로 SRP 분리.

**중요도.** PASS — 본 stage closure 영향 0건.

### R-2 (PASS — drafter 자율 +1 인정): PMStatusBar `_fetch_pm_state` (private) → `fetch` (public)

**식별 영역.** design_final Sec.10.3 verbatim:

```python
def _fetch_pm_state(self) -> tuple[PersonaState, List[str]]:
```

drafter v1 구현:

```python
def fetch(self) -> Tuple[PersonaState, List[str]]:
```

**판정.** private → public 변경 = 단위 테스트 가능성 +1 (`pytest.importorskip("textual")` 후 `bar.fetch()` 직접 호출 — `test_boundary_6_multi_bridge_aggregation` 검증 영역).

**중요도.** PASS — drafter 자율 적절한 deviation.

### R-3 (PATCH 작은 — 테스트 보강 권고): 4건 검증 누락

**식별 영역.** drafter v1 27 측정점 (21 함수 + parametrize 4 + 4) 정합. 누락 4건:

1. **DashboardRenderer.compose() 통합 검증** — textual App 인스턴스 진입 후 `yield PMStatusBar + 박스 3개` 정합 (textual 의존 영역, `pytest.importorskip("textual")` skip 가능).
2. **DashboardRenderer.update_data Dict 인자 정합** — 3 팀 모두 `query_one(f"#team_{slug}", TeamRenderer)` 호출 정합 + `pm_state is None` 시 status bar 미갱신 검증.
3. **personas.by_team / displayed_count / hidden_count 함수** — 3 helper 함수 명시 검증 (현 시점 `len(...)` 간접 검증만).
4. **PMStatusBar.update_data 출력 format** — `f"PM {name} [{sym} {status}] | {task} | tokens: {tokens:.1f}k | active orcs: {orcs}"` line format 정합.

**적용 영역.** 분량 721줄 ≤ 800 boundary 영역 — 테스트 4건 추가 시 ~30줄 +. 본 reviewer 단계에서 추가 patch 영역 적용 X (분량 임계 안전 영역 확보 우선). **권고 영역으로 박음** — Stage 9 코드 리뷰 영역 또는 M4 영역 sync.

**중요도.** mild — 본 stage closure 영향 0건 (boundary 6/6 모두 PASS).

### R-4 (PASS — drafter 자율 +1 인정): render.py `_slug` 함수 (한글 → ASCII id)

**식별 영역.** drafter v1 신규:

```python
@staticmethod
def _slug(team: str) -> str:
    """팀명 → ASCII 식별자 (textual id 호환)."""
    mapping = {"기획": "plan", "디자인": "design", "개발": "dev"}
    return mapping.get(team, "x")
```

**판정.** textual id 호환성 영역. textual id가 ASCII alphanumeric + underscore 권장 (한글 id 가능하나 host environment 호환성 +1). drafter 자율 적절한 deviation.

**중요도.** PASS — 신뢰성 +1.

### R-5 (PASS — drafter 자율 +1 인정): dashboard.tcss `.status-stale` 클래스 추가

**식별 영역.** dashboard.tcss:

```css
.status-stale {
    color: $error;
    text-style: italic;
}
```

**판정.** R-1 정정(idle 폴백 시 `last_update` 보존 → staleness ⚠ 표시) 정합 강화 영역. M2/M4 wiring 시 `.status-stale` 클래스 toggle 가능 (`Sec.14.3 staleness 표시 영역` 정합).

**중요도.** PASS — 운영자 가시성 +1.

### R-6 (PASS — drafter 자율 +1 인정): personas.py `PersonaInfo` TypedDict + 4 필드

**식별 영역.** drafter v1 신규:

```python
class PersonaInfo(TypedDict):
    name: str
    role: str
    team: Optional[str]
    displayed: str  # "box" / "status_bar" / "hidden"
```

**판정.** design_final spec verbatim에 없으나 운영자 가시성 +1 (각 페르소나 역할 명시: "기획PL" / "BE리뷰" / "FE드래프터" 등) + 타입 정합 강화 (`displayed` Literal 영역).

**중요도.** PASS — 본 stage closure 영향 0건. operating_manual.md Sec.1.2 18명 정의 verbatim 흡수.

### R-7 (PASS — drafter 자율 +1 인정): PMStatusBar.fetch 본문 완성 (design_final spec 미완성 영역)

**식별 영역.** design_final Sec.10.3 verbatim:

```python
return (..., bridges + active_orcs)  # R-8: 모든 bridge + Orc 통합 표기
```

`...` placeholder 영역. drafter v1 구현:

```python
return (
    PersonaState(name=..., status="working", task=latest, tokens_k=0.0, last_update=datetime.now()),
    bridges + active_orcs,
)
```

**판정.** design_final spec 미완성 영역(`...`)을 drafter v1이 본문 완성 박음. 운영자 가시성 +1 + R-8 다중 bridge 통합 정합.

**중요도.** PASS — drafter 자율 본문 완성 영역.

## 4. 정정 적용 trail (file 변경 요약)

| 파일 | drafter v1 | reviewer 정정 | 분량 |
|------|------------|---------------|-----|
| `scripts/dashboard/render.py` | DashboardRenderer + TEAM_ORDER + compose + update_data + _slug (drafter 자율 SRP +1) | **R-N 마커 1줄 추가** (TEAM_ORDER 위) | 67 → 68 (+1) |
| `scripts/dashboard/status_bar.py` | PMStatusBar(Static) + fetch(public) + R-8 다중 bridge 통합 (drafter 자율 +1) | 변경 0 (PASS) | 73 |
| `scripts/dashboard/team_renderer.py` | TeamRenderer(Vertical) + progress_bar + sparkline + boundary slot #2/#3/#4 흡수 + MAX_SUB_ROWS=1 | 변경 0 (PASS) | 152 |
| `scripts/dashboard/personas.py` | TEAM_PERSONAS=15 + PM_PERSONA + HIDDEN_PLACEHOLDERS=3 + PersonaInfo TypedDict + helper 3 함수 | 변경 0 (PASS, R-6 자율 +1 인정) | 74 |
| `scripts/dashboard/dashboard.tcss` | 색상 11종 + 11 셀렉터 + .status-stale (drafter 자율 +1) | 변경 0 (PASS, R-5 자율 +1 인정) | 92 |
| `tests/test_dashboard_render.py` | 21 함수 / ~27 측정점 (parametrize 4+4) | 변경 0 (R-3 권고만, M4/9 영역) | 262 |
| **합계** | **720줄** | **721줄** (≤ 800 PASS) | 721 |

## 5. AC-M3-* 매핑 + F-D 본문 정합

| AC ID | 기준 | 검증 |
|-------|------|------|
| AC-D-2 | F-D2 진입점 단일 + 모듈 패키지 | render.py = top-level 단일 진입 (DashboardRenderer) |
| AC-D-3 | F-D2 모듈 11개 ≥ 11 | M1 reviewer 정정 후 15개 (현 시점) — Stage 8 누적 |
| AC-D-4 | F-D4 async def 0건 (M3 4 모듈) | `test_no_async_def` parametrize 4 |
| AC-Q1-1 | Q1 status bar 1행 + 다중 bridge | `test_boundary_6_status_bar_height_one` + `test_boundary_6_multi_bridge_aggregation` |
| AC-Q1-2 | status_bar.py presence | 73줄 ✓ |
| **AC-V-1** | **박스 너비 33% × 3** | dashboard.tcss `width: 1fr` + `Horizontal` layout 균등 분배 (수동 검증 영역, M3 boundary slot #2 정합) |
| **AC-V-2** | **다중 버전 sub-row visual** | `test_team_renderer_sub_row_prefix` (`SUB_ROW_PREFIX = "└"`) — 자동 검증 |
| AC-S-1 | read-only 0건 (F-X-2) | `test_no_write_commands` parametrize 4 |
| F-D1 단일 진입 | DashboardRenderer.update_data 입력 = Dict[str, List[PersonaState]] | `test_render_single_entry_signature` |
| F-D3 19명 산식 | 박스 16 + 미표시 3 = 19 | `test_boundary_5_19_persona_sum` |
| 헌법 임계 | drafter ≤ 800 / R-N trail ≤ 600 | drafter 721 / 본 trail 자가 점검 |

## 6. Score 가중치 분배 (reviewer 권한, finalizer Score 별도)

| 영역 | 가중치 | reviewer 정정 후 | 근거 |
|------|------|-------|------|
| boundary 6/6 본문 (ALL PASS) | 30 | 30/30 | #1 색상 11종 + App{} / #2 margin·padding·border round / #3 진행률 바 8칸 4단계 / #4 스파크라인 8칸 8단계 (U+2581~U+2588) / #5 placeholder 3종 / #6 PM status bar 1행 |
| F-D3 19명 산식 (Q1 final) | 15 | 15/15 | 박스 15(TEAM_PERSONAS) + PM 1(PM_PERSONA) + 미표시 3(HIDDEN_PLACEHOLDERS) = 19 |
| F-D1 DashboardRenderer 단일 진입 | 10 | 10/10 | Dict[str, List[PersonaState]] 직접 소비 + 어댑터 0건 |
| F-D4 sync 전면 (async def 0건) | 5 | 5/5 | M3 4 모듈 async def 0건 |
| AC-S-1 read-only (F-X-2) 0건 | 5 | 5/5 | M3 4 모듈 git push / commit / open(w) 0건 |
| textual CSS 셀렉터 + Compose 구조 | 10 | 10/10 | App / DashboardRenderer / TeamRenderer / PMStatusBar / .status-* / .progress-bar / .sparkline 등 11+ 셀렉터 + compose 정합 |
| 진행률 바 + 스파크라인 unicode 정합 | 5 | 5/5 | PROGRESS_LEVELS = U+2591/U+2592/U+2588 + SPARK_LEVELS = U+2581~U+2588 (`test_boundary_4_sparkline_constants`) |
| 분량 임계 ≤ 800 | 5 | 5/5 | 721줄 PASS |
| A 패턴 정합 (drafter 자율 deviation 6건 + reviewer R-N 마커) | 5 | 5/5 | drafter 자율 +1 영역 R-1/R-2/R-4/R-5/R-6/R-7 인정 + reviewer R-N 마커 1줄 |
| 테스트 커버리지 27 측정점 (R-3 작은 PATCH) | 10 | 6/10 | 21 함수 / 27 측정점. -4 = compose 통합 + update_data Dict + personas helper + PMStatusBar.update_data format 검증 누락 (M4/9 영역 권고) |
| **reviewer 확정 Score** | 100 | **96/100** | **임계 80% 통과 + 목표 90%+ 통과** |

> **finalizer Score 권한 영역.** R-12 정정에 따라 finalizer가 최종 Score 권한. 본 reviewer Score는 가중치 분배 + R-N 정정 후 추정 산출 영역. 최종 확정은 finalizer `m3_render.md` 마감 doc.

## 7. Stage 9 코드 리뷰 보강 영역 (사전 정정 영역, design_final Sec.15.4 정합)

- **DashboardRenderer.compose() 통합 검증** — textual App 인스턴스 진입 + `yield PMStatusBar + 박스 3개` 정합 (`pytest.importorskip("textual")` 영역).
- **DashboardRenderer.update_data Dict 인자 정합** — 3 팀 query_one 호출 + `pm_state is None` 시 status bar 미갱신 검증.
- **personas.by_team / displayed_count / hidden_count 함수 검증** — 3 helper 명시 검증.
- **PMStatusBar.update_data 출력 format 검증** — line format 정확 정합.
- **AC-V-1 박스 너비 33% × 3 수동 검증** — textual dev 화면 (터미널 120~150 col) visual 검사 (Stage 12 QA 영역 sync).
- **boundary slot #5 6~9행 가독성 수동 검증** — 18명 모두 active fixture → 박스 높이 45줄 scroll 동작 (Stage 6 디자인팀 boundary slot 영역과 sync).

## 8. v0.6.5 컨텍스트 엔지니어링 영역 (사고 14 누적 trail)

본 review 진행 중 BR-001(3-tier polling 부재) + 사고 14(M2 drafter 시그니처 1.2 화면 print만 / 1.1 forward 미실행) 누적 trail 영역 + 본 M3 stage closure 영역:

- **M3 사고 14 회피.** drafter v1 시그니처 송출 → 1.1 PL forward 정상 작동 (M2와 동일 양상 재발 시 회의창 강제 진입 default 적용).
- **헌법 hotfix `9902a68`.** A 패턴 영구 박힘 — drafter → reviewer 본인 직접 수정 + R-N 마커 → finalizer 마감 doc만.
- **CLAUDE.md hotfix.** 추측 진행 금지 강제 + 자가 점검 11항목 의무 (3중 검증: capture+디스크+git log).
- **회수 영역.** 본 stage = M3 closure만. v0.6.5 컨텍스트 엔지니어링 본격 정공법 영역 = (1) 시그니처 자동 forward 메커니즘 (drafter pane → PL pane 자동 send-keys) (2) 분량 임계 자동 검증 hook (drafter ≤ 800 / review ≤ 600 / final ≤ 500) (3) boundary slot 자동 검증 hook (test_boundary_*_constants 정합) (4) 회의창 헌법/메모리 자가 적용 메커니즘.

## 9. 1.1 공기성-개발PL pane 시그니처 (3줄 송출, wrap 회피, send-keys 직접 실행)

```
줄1: 📡 status v0.6.4 Stage 8 M3 reviewer COMPLETE — path=scripts/dashboard/(render+status_bar+team_renderer+personas+CSS) R-N=7건 verdict=PASS_WITH_PATCH Score=96/100
줄2: ls/wc 디스크: M3 산출 합 721 ≤ 800 / py_compile 5/5 PASS / m3_render_review.md ≤ 600 PASS / boundary 6/6 ALL PASS
줄3: git status + stash list empty (자가 점검 11항목 3중 검증 정합 / BR-001 사고 14 회피)
```

- **R-N 7건:** R-1 PASS(SRP 3 클래스 분리 자율 +1) / R-2 PASS(fetch public 자율 +1) / R-3 PATCH 작은(테스트 4건 보강 권고 M4/9) / R-4 PASS(_slug 자율 +1) / R-5 PASS(.status-stale 자율 +1) / R-6 PASS(PersonaInfo TypedDict 자율 +1) / R-7 PASS(_fetch_pm_state 본문 완성 자율 +1).
- **patch 적용 1건:** R-N 마커 1줄 추가(`render.py` TEAM_ORDER 위). 분량 720 → 721 ≤ 800 PASS.
- **다음 본분:** finalizer 현봉식 → `docs/04_implementation_v0.6.4/m3_render.md` 마감 doc 작성 영역 (verdict + Score + AC + 결정 trail, ≤ 500줄, **본문 작성 X**).

## 10. 본 R-N trail 본문 길이 자가 점검

- **임계:** ≤ 600줄 (헌법, 사고 14 산출 길이 임계).
- **본 파일 wc -l:** finalizer 검증 영역 (산출 commit 시점).
- **압축 정책:** R-N 7건 본문 표 + Score 가중치 분배 + AC 매핑 영역. 임계 초과 시도 시 `m3_render_review_appendix.md` sub-doc 분리.

---

작성: 최우영-be-reviewer (Opus high, Orc-064-dev:1.3)
검토 영역: drafter v1 720줄 → reviewer 정정 후 721줄 (≤ 800 PASS)
다음: 1.4 현봉식-be-finalizer 마감 doc `m3_render.md` 작성 (≤ 500줄, 본문 작성 X)
