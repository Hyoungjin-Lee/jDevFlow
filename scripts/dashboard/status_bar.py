"""M5 — PM 스티브 리 status bar 1행 (boundary slot #6, F-D3 19명 산식).

design_final Sec.10.3 + R-8 정정:
- height = 1 (1행 표기).
- format: ``PM <name> [<◉/○> <status>] | <task> | tokens: <N.N>k | active orcs: <list>``.
- R-8 다중 bridge 통합 — ``tmux ls``의 ``bridge-*`` + ``Orc-*`` 모두 표기.

Stage 10b — ``compose_pm_state`` 모듈 함수 추가. PMStatusBar.fetch() 동등 로직이지만
widget tree 무관 → DashboardApp worker thread에서 안전 호출 가능 (F-D4 thread-safety).
"""
from __future__ import annotations

from datetime import datetime
from typing import List, Optional, Tuple

from textual.widgets import Static

from .models import PersonaState
from .tmux_adapter import TmuxAdapter

PM_PERSONA_NAME: str = "스티브 리"


def compose_pm_state(tmux: TmuxAdapter) -> Tuple[PersonaState, List[str]]:
    """PM status 계산 — ``PMStatusBar.fetch()`` 동등. widget tree 무관, worker thread-safe.

    Stage 10b wiring fix — DashboardApp worker가 본 함수를 호출, ``call_from_thread``로
    PMStatusBar.update_data에 결과 push.
    """
    sessions = tmux.list_sessions()
    bridges = sorted(s for s in sessions if s.startswith("bridge-"))
    active_orcs = sorted(s for s in sessions if s.startswith("Orc-"))
    if not bridges:
        return (
            PersonaState(
                name=PM_PERSONA_NAME, team="기획", status="idle", task=None,
                tokens_k=0.0, last_update=datetime.fromtimestamp(0),
            ),
            [],
        )
    return (
        PersonaState(
            name=PM_PERSONA_NAME, team="기획", status="working", task=bridges[-1],
            tokens_k=0.0, last_update=datetime.now(),
        ),
        bridges + active_orcs,
    )


class PMStatusBar(Static):
    """F-D3 19번째 페르소나 (status bar 별도 행). brainstorm 의제 7 Parallel Window 정합."""

    # Stage 10d — 시각 강조 (background full primary + bold). 상단 PM status bar가
    # 화면에서 명확히 보이도록 정합. height=1 유지 (1행 표기 design_final Sec.10.3).
    DEFAULT_CSS = """
    PMStatusBar {
        background: $primary;
        color: $background;
        text-style: bold;
        height: 1;
        padding: 0 1;
        dock: top;
    }
    """

    PERSONA_NAME = PM_PERSONA_NAME
    EMPTY_LINE = (
        f"PM {PERSONA_NAME} [○ idle] | (idle) | tokens: 0.0k | active orcs: (none)"
    )

    def __init__(self, tmux: Optional[TmuxAdapter] = None, **kwargs) -> None:
        super().__init__(self.EMPTY_LINE, **kwargs)
        self.tmux = tmux or TmuxAdapter()

    def fetch(self) -> Tuple[PersonaState, List[str]]:
        """R-8 정정 — ``compose_pm_state`` 위임 (Stage 10b 헬퍼 정합)."""
        return compose_pm_state(self.tmux)

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
