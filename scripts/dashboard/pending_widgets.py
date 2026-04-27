"""M4 — ``PendingPushBox`` / ``PendingQBox`` textual widgets (design_final Sec.9.2).

- read-only 표시 only — F-X-2 영구. git/file write 0건.
- 5개 truncate (drafter 자율). 초과 시 ``... 외 N건`` 마커.
- ⚠ staleness — ``timestamp`` > 2초 시 표시 (R-1 정정 정합).
- priority 정렬 — critical > high > medium > low.
"""
from __future__ import annotations

from datetime import datetime, timedelta
from typing import List

from textual.widgets import Static

from .models import PendingPush, PendingQuestion

MAX_VISIBLE_PUSHES: int = 5
MAX_VISIBLE_QUESTIONS: int = 5
STALE_THRESHOLD: timedelta = timedelta(seconds=2)
STALE_MARK: str = "⚠"


class PendingPushBox(Static):
    """push / commit 대기 박스 — read-only 표시 only."""

    DEFAULT_CSS = """
    PendingPushBox {
        border: round $secondary;
        padding: 0 1;
        margin: 0 1;
        height: auto;
    }
    """

    EMPTY_LABEL = "✓ 대기 항목 없음"

    def __init__(self, **kwargs) -> None:
        super().__init__(self._render_empty(), **kwargs)

    def update_data(self, pushes: List[PendingPush]) -> None:
        self.update(self._render(pushes))

    @classmethod
    def _render_empty(cls) -> str:
        return f"┌── Pending Push/Commit ──┐\n│ {cls.EMPTY_LABEL}\n└─────────────┘"

    def _render(self, pushes: List[PendingPush]) -> str:
        if not pushes:
            return self._render_empty()
        lines = ["┌── Pending Push/Commit ──┐"]
        for p in pushes[:MAX_VISIBLE_PUSHES]:
            mark = self._stale_mark(p.timestamp)
            lines.append(f"│ ⏳ {p.description} {mark}".rstrip())
            lines.append(f"│   [{p.severity}] initiator: {p.initiator}")
        overflow = max(0, len(pushes) - MAX_VISIBLE_PUSHES)
        if overflow > 0:
            lines.append(f"│   ... 외 {overflow}건")
        lines.append("└─────────────┘")
        return "\n".join(lines)

    @staticmethod
    def _stale_mark(ts: datetime) -> str:
        return STALE_MARK if (datetime.now() - ts) > STALE_THRESHOLD else ""


class PendingQBox(Static):
    """운영자 결정 대기 Q 박스 — priority 정렬, read-only."""

    DEFAULT_CSS = """
    PendingQBox {
        border: round $warning;
        padding: 0 1;
        margin: 0 1;
        height: auto;
    }
    """

    EMPTY_LABEL = "✓ 결정 대기 없음"
    _PRIORITY_ORDER = {"critical": 0, "high": 1, "medium": 2, "low": 3}

    def __init__(self, **kwargs) -> None:
        super().__init__(self._render_empty(), **kwargs)

    def update_data(self, questions: List[PendingQuestion]) -> None:
        self.update(self._render(questions))

    @classmethod
    def _render_empty(cls) -> str:
        return f"┌── Pending Q ──┐\n│ {cls.EMPTY_LABEL}\n└─────────────┘"

    def _render(self, questions: List[PendingQuestion]) -> str:
        if not questions:
            return self._render_empty()
        sorted_qs = sorted(
            questions, key=lambda q: self._PRIORITY_ORDER.get(q.priority, 99)
        )
        lines = ["┌── Pending Q ──┐"]
        for q in sorted_qs[:MAX_VISIBLE_QUESTIONS]:
            lines.append(f"│ ❓ {q.q_id} [{q.priority}] {q.description[:60]}")
            lines.append(f"│   src: {q.source}")
        overflow = max(0, len(sorted_qs) - MAX_VISIBLE_QUESTIONS)
        if overflow > 0:
            lines.append(f"│   ... 외 {overflow}건")
        lines.append("└─────────────┘")
        return "\n".join(lines)
