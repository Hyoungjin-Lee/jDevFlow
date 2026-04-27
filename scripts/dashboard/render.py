"""M3 — Top-level dashboard render entry (F-D1 단일 진입, design_final Sec.8).

본 모듈은 ``DashboardRenderer`` Container를 export하며 다음 어댑터 3중 (TeamMember/
DataCollector/PersonaState)을 PersonaState 단일 spec으로 닫습니다 — F-D1 본문 정합.

boundary slot 흡수 위치:
- #1 색상 11종 + #2 margin·padding·border round → ``dashboard.tcss``.
- #3 진행률 바 + #4 스파크라인 → ``team_renderer.py``.
- #5 placeholder 3종 → ``personas.py``.
- #6 PM status bar 1행 → ``status_bar.py``.
"""
from __future__ import annotations

from typing import Dict, List, Optional

from textual.app import ComposeResult
from textual.containers import Container, Horizontal

from .models import PersonaState
from .status_bar import PMStatusBar
from .team_renderer import TeamRenderer

# F-D3 19명 산식 — 박스 16 (4팀 15 + PM 1) + 미표시 placeholder 3 (CTO·CEO·HR) = 19.
# R-N reviewer 검증 (M3 PASS_WITH_PATCH) — boundary 6/6 모두 정합 + SRP 분리(3 클래스).
TEAM_ORDER: tuple = ("기획", "디자인", "개발")


class DashboardRenderer(Container):
    """M3 단일 진입 — PersonaState List 직접 소비, 어댑터 0건 (F-D1)."""

    DEFAULT_CSS = """
    DashboardRenderer {
        layout: vertical;
        height: 1fr;
    }
    DashboardRenderer > #team_grid {
        layout: horizontal;
        height: 1fr;
    }
    """

    def compose(self) -> ComposeResult:
        yield PMStatusBar(id="pm_status_bar")
        with Horizontal(id="team_grid"):
            for team in TEAM_ORDER:
                yield TeamRenderer(team=team, id=f"team_{self._slug(team)}")

    def update_data(
        self,
        teams_data: Dict[str, List[PersonaState]],
        pm_state: Optional[PersonaState] = None,
        active_orcs: Optional[List[str]] = None,
    ) -> None:
        """F-D1 단일 진입 — Dict[str, List[PersonaState]] verbatim 소비."""
        for team in TEAM_ORDER:
            renderer = self.query_one(
                f"#team_{self._slug(team)}", TeamRenderer
            )
            renderer.update_data(teams_data.get(team, []))
        if pm_state is not None:
            status_bar = self.query_one("#pm_status_bar", PMStatusBar)
            status_bar.update_data(pm_state, active_orcs or [])

    @staticmethod
    def _slug(team: str) -> str:
        """팀명 → ASCII 식별자 (textual id 호환)."""
        mapping = {"기획": "plan", "디자인": "design", "개발": "dev"}
        return mapping.get(team, "x")
