"""M3 boundary 6/6 본문 검증 — 색상 11종 / margin·padding·border / 진행률 바 /
스파크라인 / placeholder / PM status bar + F-D1 / F-D3 / F-D4 / F-X-2.

textual 의존 영역은 ``pytest.importorskip("textual")``로 격리. AST/grep 검증은
의존 없이 실행 가능.
"""
from __future__ import annotations

import ast
import re
import sys
from pathlib import Path

import pytest

PROJECT_ROOT = Path(__file__).resolve().parent.parent
PACKAGE_DIR = PROJECT_ROOT / "scripts" / "dashboard"
TCSS = PACKAGE_DIR / "dashboard.tcss"

if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

M3_MODULES = ("render.py", "team_renderer.py", "status_bar.py", "personas.py")


# ---------------------------------------------------------------------------
# Boundary slot #1 — 색상 11종 textual CSS App{}
# ---------------------------------------------------------------------------

REQUIRED_COLORS = (
    "$primary", "$secondary", "$accent",
    "$success", "$warning", "$error",
    "$surface", "$panel", "$background",
    "$boost", "$foreground",
)


def test_boundary_1_eleven_colors_in_css() -> None:
    """boundary #1 — 11종 색상 모두 dashboard.tcss에 등장."""
    assert TCSS.is_file(), f"{TCSS} 미존재"
    content = TCSS.read_text(encoding="utf-8")
    missing = [c for c in REQUIRED_COLORS if c not in content]
    assert not missing, f"색상 누락: {missing}"
    assert len(REQUIRED_COLORS) == 11, "색상 정의 카운트 위반"


def test_boundary_1_app_selector_present() -> None:
    """boundary #1 — App{} 셀렉터 본문."""
    content = TCSS.read_text(encoding="utf-8")
    assert re.search(r"^App\s*\{", content, re.MULTILINE), "App{} 셀렉터 누락"


# ---------------------------------------------------------------------------
# Boundary slot #2 — margin / padding / border round
# ---------------------------------------------------------------------------


def test_boundary_2_margin_padding_border_round() -> None:
    content = TCSS.read_text(encoding="utf-8")
    assert "margin:" in content, "margin 누락"
    assert "padding:" in content, "padding 누락"
    assert re.search(r"border:\s*round", content), "border round 누락"


# ---------------------------------------------------------------------------
# Boundary slot #3 — 진행률 바 8칸 4단계
# ---------------------------------------------------------------------------


def test_boundary_3_progress_bar_constants() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import (
        PROGRESS_CELLS, PROGRESS_LEVELS,
    )
    assert PROGRESS_CELLS == 8, "8칸 위반"
    assert len(set(PROGRESS_LEVELS)) == 4, "4단계 unique 위반"


def test_boundary_3_progress_bar_zero_full() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import (
        progress_bar, PROGRESS_CELLS, PROGRESS_LEVELS, PROGRESS_MAX_TOKEN_K,
    )
    bar0 = progress_bar(0.0)
    assert len(bar0) == PROGRESS_CELLS
    assert bar0 == PROGRESS_LEVELS[0] * PROGRESS_CELLS
    bar_full = progress_bar(PROGRESS_MAX_TOKEN_K)
    assert bar_full == PROGRESS_LEVELS[3] * PROGRESS_CELLS


def test_boundary_3_progress_bar_partial() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import (
        progress_bar, PROGRESS_CELLS, PROGRESS_MAX_TOKEN_K,
    )
    half = progress_bar(PROGRESS_MAX_TOKEN_K / 2)
    assert len(half) == PROGRESS_CELLS
    assert half[0] != half[-1], "절반 시점 좌우 다름 (단조 채움)"


# ---------------------------------------------------------------------------
# Boundary slot #4 — 스파크라인 8칸 8단계
# ---------------------------------------------------------------------------


def test_boundary_4_sparkline_constants() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import SPARK_CELLS, SPARK_LEVELS
    assert SPARK_CELLS == 8, "8칸 위반"
    assert len(SPARK_LEVELS) == 8, "8단계 위반"
    expected = "".join(chr(0x2581 + i) for i in range(8))
    assert SPARK_LEVELS == expected, f"unicode 위반: {SPARK_LEVELS!r}"


def test_boundary_4_sparkline_render() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import sparkline, SPARK_CELLS, SPARK_LEVELS
    line = sparkline([1.0, 5.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0])
    assert len(line) == SPARK_CELLS
    assert line[-1] == SPARK_LEVELS[-1], "단조 증가 끝 = █"


def test_boundary_4_sparkline_empty() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import sparkline, SPARK_LEVELS
    assert sparkline([]) == SPARK_LEVELS[0] * 8


# ---------------------------------------------------------------------------
# Boundary slot #5 — placeholder 3종 (CTO·CEO·HR)
# ---------------------------------------------------------------------------


def test_boundary_5_placeholder_three() -> None:
    from scripts.dashboard.personas import HIDDEN_PLACEHOLDERS
    assert len(HIDDEN_PLACEHOLDERS) == 3, "placeholder 3종 위반"
    roles = {p["role"] for p in HIDDEN_PLACEHOLDERS}
    assert roles == {"CTO", "CEO", "HR"}, f"역할 위반: {roles}"
    assert all(p["displayed"] == "hidden" for p in HIDDEN_PLACEHOLDERS)


def test_boundary_5_19_persona_sum() -> None:
    """F-D3 산식 — 박스 15 + PM 1 + 미표시 3 = 19."""
    from scripts.dashboard.personas import (
        all_personas, TEAM_PERSONAS, PM_PERSONA, HIDDEN_PLACEHOLDERS,
    )
    assert len(TEAM_PERSONAS) == 15
    assert PM_PERSONA["displayed"] == "status_bar"
    assert len(HIDDEN_PLACEHOLDERS) == 3
    assert len(all_personas()) == 19


# ---------------------------------------------------------------------------
# Boundary slot #6 — PM status bar 1행 (F-D3)
# ---------------------------------------------------------------------------


def test_boundary_6_status_bar_height_one() -> None:
    src = (PACKAGE_DIR / "status_bar.py").read_text(encoding="utf-8")
    assert "PMStatusBar" in src, "PMStatusBar 클래스 누락"
    assert "height: 1" in src, "1행 height 누락"
    assert "스티브 리" in src, "PM 페르소나명 누락"
    assert "active orcs" in src, "active orcs 표기 누락 (R-8)"


def test_boundary_6_multi_bridge_aggregation() -> None:
    """R-8 — 다중 bridge 모두 통합."""
    pytest.importorskip("textual")
    from unittest import mock
    from scripts.dashboard.status_bar import PMStatusBar
    fake = mock.Mock()
    fake.list_sessions.return_value = ["bridge-063", "bridge-064", "Orc-064-dev"]
    bar = PMStatusBar(tmux=fake)
    pm_state, orcs = bar.fetch()
    assert pm_state.status == "working"
    assert "bridge-063" in orcs and "bridge-064" in orcs
    assert "Orc-064-dev" in orcs


# ---------------------------------------------------------------------------
# F-D1 단일 진입 + PersonaState 직접 소비
# ---------------------------------------------------------------------------


def test_render_single_entry_signature() -> None:
    """F-D1 — DashboardRenderer.update_data 입력 = Dict[str, List[PersonaState]]."""
    src = (PACKAGE_DIR / "render.py").read_text(encoding="utf-8")
    assert "DashboardRenderer" in src
    assert "Dict[str, List[PersonaState]]" in src


def test_team_renderer_persona_state_consumption() -> None:
    """F-D1 — TeamRenderer가 PersonaState List 직접 소비."""
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import TeamRenderer
    tr = TeamRenderer(team="기획")
    assert tr.team == "기획"


def test_team_renderer_compose_empty_box() -> None:
    """F-X-7-#6 옵션 A — 빈 팀 = '(팀 대기 중)'."""
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import TeamRenderer, EMPTY_BOX_LABEL
    tr = TeamRenderer(team="디자인")
    assert EMPTY_BOX_LABEL in tr._compose_text([])


def test_team_renderer_compose_persona_row() -> None:
    pytest.importorskip("textual")
    from datetime import datetime
    from scripts.dashboard.models import PersonaState
    from scripts.dashboard.team_renderer import TeamRenderer
    state = PersonaState(name="박지영", team="기획", status="working",
                         task="v0.6.4 Stage 8 M3", tokens_k=12.5,
                         last_update=datetime.now())
    text = TeamRenderer(team="기획")._compose_text([state])
    assert "박지영" in text
    assert "◉ working" in text
    assert "v0.6.4 Stage 8 M3" in text
    assert "12.5k" in text


def test_team_renderer_sub_row_prefix() -> None:
    """F-M3-4 — 다중 버전 sub-row prefix └."""
    pytest.importorskip("textual")
    from datetime import datetime
    from scripts.dashboard.models import PersonaState
    from scripts.dashboard.team_renderer import TeamRenderer, SUB_ROW_PREFIX
    s1 = PersonaState(name="장그래", team="기획", status="working",
                      task="v0.6.4/M3", tokens_k=10.0, last_update=datetime.now())
    s2 = PersonaState(name="장그래", team="기획", status="working",
                      task="v0.6.3/M2", tokens_k=20.0, last_update=datetime.now())
    text = TeamRenderer(team="기획")._compose_text([s1, s2])
    assert SUB_ROW_PREFIX in text


def test_token_format_one_decimal_k() -> None:
    """F-M3-3 — tokens %.1fk format."""
    pytest.importorskip("textual")
    from scripts.dashboard.team_renderer import TOKEN_FORMAT
    assert "{:.1f}k" in TOKEN_FORMAT


# ---------------------------------------------------------------------------
# F-X-2 read-only + F-D4 sync def 강제
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("module_name", M3_MODULES)
def test_no_write_commands(module_name: str) -> None:
    """F-X-2 — write 명령 0건 (AC-M3-9)."""
    src = (PACKAGE_DIR / module_name).read_text(encoding="utf-8")
    pattern = re.compile(r"open\([^)]*['\"]w['\"]|git\s+push|git\s+commit")
    assert not pattern.findall(src), f"F-X-2 위반 ({module_name})"


@pytest.mark.parametrize("module_name", M3_MODULES)
def test_no_async_def(module_name: str) -> None:
    """F-D4 — M3 모듈 async def 0건."""
    tree = ast.parse((PACKAGE_DIR / module_name).read_text(encoding="utf-8"))
    asyncs = [n.name for n in ast.walk(tree) if isinstance(n, ast.AsyncFunctionDef)]
    assert not asyncs, f"F-D4 위반 ({module_name}): {asyncs}"
