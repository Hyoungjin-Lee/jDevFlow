"""M5 — PM 스티브 리 status bar 1행 (boundary slot #6, F-D3 19명 산식).

design_final Sec.10.3 + R-8 정정:
- height = 1 (1행 표기).
- format: ``PM <name> [<◉/○> <status>] | <task> | tokens: <N.N>k | active orcs: <list>``.
- R-8 다중 bridge 통합 — ``tmux ls``의 ``bridge-*`` + ``Orc-*`` 모두 표기.
"""
from __future__ import annotations

from datetime import datetime
from typing import List, Optional, Tuple

from textual.widgets import Static

from .models import PersonaState
from .tmux_adapter import TmuxAdapter


class PMStatusBar(Static):
    """F-D3 19번째 페르소나 (status bar 별도 행). brainstorm 의제 7 Parallel Window 정합."""

    DEFAULT_CSS = """
    PMStatusBar {
        background: $primary 20%;
        color: $foreground;
        height: 1;
        padding: 0 1;
        border-bottom: heavy $primary;
    }
    """

    PERSONA_NAME = "스티브 리"
    EMPTY_LINE = (
        f"PM {PERSONA_NAME} [○ idle] | (idle) | tokens: 0.0k | active orcs: (none)"
    )

    def __init__(self, tmux: Optional[TmuxAdapter] = None, **kwargs) -> None:
        super().__init__(self.EMPTY_LINE, **kwargs)
        self.tmux = tmux or TmuxAdapter()

    def fetch(self) -> Tuple[PersonaState, List[str]]:
        """R-8 정정 — bridge-* 패턴 모두 통합 + Orc-* 통합."""
        sessions = self.tmux.list_sessions()
        bridges = sorted(s for s in sessions if s.startswith("bridge-"))
        active_orcs = sorted(s for s in sessions if s.startswith("Orc-"))
        if not bridges:
            return (
                PersonaState(
                    name=self.PERSONA_NAME, team="기획", status="idle", task=None,
                    tokens_k=0.0, last_update=datetime.fromtimestamp(0),
                ),
                [],
            )
        # 가장 최근 spawn bridge = working 인입 source (drafter 자율).
        latest = bridges[-1]
        return (
            PersonaState(
                name=self.PERSONA_NAME, team="기획", status="working", task=latest,
                tokens_k=0.0, last_update=datetime.now(),
            ),
            bridges + active_orcs,
        )

    def update_data(self, pm_state: PersonaState, active_orcs: List[str]) -> None:
        sym = "◉" if pm_state.status == "working" else "○"
        orcs = " ".join(active_orcs) if active_orcs else "(none)"
        line = (
            f"PM {pm_state.name} [{sym} {pm_state.status}] | "
            f"{pm_state.task or '(idle)'} | "
            f"tokens: {pm_state.tokens_k:.1f}k | "
            f"active orcs: {orcs}"
        )
        self.update(line)
