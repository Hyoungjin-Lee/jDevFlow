"""M4 — Top-level Pending area (PendingPushBox + PendingQBox 가로 배치).

design_final Sec.9.2 layout 정합. F-D1 — ``PendingDataCollector`` 출력 직접 소비.
``PendingArea`` Container = M3 ``DashboardRenderer`` 패턴 정합 (단일 진입).
"""
from __future__ import annotations

from typing import List, Optional

from textual.app import ComposeResult
from textual.containers import Container

from .models import PendingPush, PendingQuestion
from .pending_widgets import PendingPushBox, PendingQBox


class PendingArea(Container):
    """M4 단일 진입 — Pending Push 박스 + Pending Q 박스 가로 배치 (read-only)."""

    DEFAULT_CSS = """
    PendingArea {
        layout: horizontal;
        height: auto;
    }
    """

    def compose(self) -> ComposeResult:
        yield PendingPushBox(id="pending_push")
        yield PendingQBox(id="pending_q")

    def update_data(
        self,
        pushes: Optional[List[PendingPush]] = None,
        questions: Optional[List[PendingQuestion]] = None,
    ) -> None:
        """F-D1 단일 진입 — PendingDataCollector 출력 직접 소비."""
        self.query_one("#pending_push", PendingPushBox).update_data(pushes or [])
        self.query_one("#pending_q", PendingQBox).update_data(questions or [])
