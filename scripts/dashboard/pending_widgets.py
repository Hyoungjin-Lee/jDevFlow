"""M4 — ``PendingPushBox`` / ``PendingQBox`` textual widgets (design_final Sec.9.2).

- read-only 표시 only — F-X-2 영구. git/file write 0건.
- ⚠ staleness — ``timestamp`` > 2초 시 표시 (R-1 정정 정합).
- priority 정렬 — critical > high > medium > low.

Stage 10d 디자인 정정:
- ASCII 박스 라인(``┌──┐`` / ``│`` / ``└──┘``) 제거 → textual ``border: round`` 단일 사용
  (외곽 깨짐 회피, drafter 잘못 그린 ASCII 박스 + textual border 중복 영역).
- 제목은 ``border-title`` 활용 (textual Widget native).
- ``MAX_VISIBLE_QUESTIONS`` 5 → 10 + truncation 60 → 100자 (Q5 누락 정정).
"""
from __future__ import annotations

from datetime import datetime, timedelta
from typing import List

from textual.widgets import Static

from .models import PendingPush, PendingQuestion

MAX_VISIBLE_PUSHES: int = 10
MAX_VISIBLE_QUESTIONS: int = 10
STALE_THRESHOLD: timedelta = timedelta(seconds=2)
STALE_MARK: str = "⚠"
DESC_TRUNCATE: int = 100


class PendingPushBox(Static):
    """push / commit 대기 박스 — read-only 표시 only."""

    # Stage 10c width: 1fr + Stage 10d ``border-title-align`` 추가 (textual native 박스 영역).
    DEFAULT_CSS = """
    PendingPushBox {
        border: round $secondary;
        border-title-align: left;
        padding: 0 1;
        margin: 0 1;
        height: auto;
        width: 1fr;
    }
    """

    EMPTY_LABEL = "✓ 대기 항목 없음"

    def __init__(self, **kwargs) -> None:
        super().__init__(self.EMPTY_LABEL, **kwargs)
        # textual native border-title — 박스 외곽이 textual round border로 그려지고
        # 제목은 border 위쪽에 박힘. ASCII 박스 중복 0건.
        self.border_title = "Pending Push/Commit"

    def update_data(self, pushes: List[PendingPush]) -> None:
        self.update(self._format_content(pushes))

    def _format_content(self, pushes: List[PendingPush]) -> str:
        if not pushes:
            return self.EMPTY_LABEL
        lines: List[str] = []
        for p in pushes[:MAX_VISIBLE_PUSHES]:
            mark = self._stale_mark(p.timestamp)
            desc = p.description[:DESC_TRUNCATE]
            lines.append(f"⏳ {desc} {mark}".rstrip())
            lines.append(f"   [{p.severity}] initiator: {p.initiator}")
        overflow = max(0, len(pushes) - MAX_VISIBLE_PUSHES)
        if overflow > 0:
            lines.append(f"   ... 외 {overflow}건")
        return "\n".join(lines)

    @staticmethod
    def _stale_mark(ts: datetime) -> str:
        return STALE_MARK if (datetime.now() - ts) > STALE_THRESHOLD else ""


class PendingQBox(Static):
    """운영자 결정 대기 Q 박스 — priority 정렬, read-only."""

    DEFAULT_CSS = """
    PendingQBox {
        border: round $warning;
        border-title-align: left;
        padding: 0 1;
        margin: 0 1;
        height: auto;
        width: 1fr;
    }
    """

    EMPTY_LABEL = "✓ 결정 대기 없음"
    _PRIORITY_ORDER = {"critical": 0, "high": 1, "medium": 2, "low": 3}

    def __init__(self, **kwargs) -> None:
        super().__init__(self.EMPTY_LABEL, **kwargs)
        self.border_title = "Pending Q"

    def update_data(self, questions: List[PendingQuestion]) -> None:
        self.update(self._format_content(questions))

    def _format_content(self, questions: List[PendingQuestion]) -> str:
        if not questions:
            return self.EMPTY_LABEL
        sorted_qs = sorted(
            questions, key=lambda q: self._PRIORITY_ORDER.get(q.priority, 99)
        )
        lines: List[str] = []
        for q in sorted_qs[:MAX_VISIBLE_QUESTIONS]:
            desc = q.description[:DESC_TRUNCATE]
            lines.append(f"❓ {q.q_id} [{q.priority}] {desc}")
            lines.append(f"   src: {q.source}")
        overflow = max(0, len(sorted_qs) - MAX_VISIBLE_QUESTIONS)
        if overflow > 0:
            lines.append(f"   ... 외 {overflow}건")
        return "\n".join(lines)
