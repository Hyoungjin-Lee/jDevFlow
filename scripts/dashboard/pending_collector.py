"""M4 — ``PendingDataCollector`` sync polling (F-D1 SRP M4 영역, design_final Sec.9.1).

- F-D1 SRP — Pending Push/Q 수집만. ``PersonaDataCollector``는 M2 영역 침범 0건.
- F-D4 sync ``def`` 전면, ``async def`` 0건.
- F-X-2 read-only 영구 — write 명령 0건 (AC-M4-N9). git/dispatch md/tmux 모두 read-only.
- Stage 10 M-1 fix — ``import subprocess`` 제거 → ``GitAdapter`` 위임 (AC-T-4 = 2).
"""
from __future__ import annotations

import re
from datetime import datetime
from pathlib import Path
from typing import List, Optional, Tuple

from .models import PendingPush, PendingQuestion
from .tmux_adapter import GitAdapter, TmuxAdapter


# 운영자 결정 Q 패턴 — dispatch md 안 ``**Q1**`` / ``**Q-NEW-1**`` / ``**Q-M2-3**`` 등.
Q_HEADER_PATTERN = re.compile(r"\*\*(Q[\w\-]+)\*\*")

# 우선순위·카테고리 키워드 — 같은 줄 내에서 인입.
Q_PRIORITY_PATTERN = re.compile(
    r"\b(critical|high|medium|low)\b", re.IGNORECASE
)
Q_CATEGORY_PATTERN = re.compile(
    r"\b(scope|decision|risk|approval)\b", re.IGNORECASE
)

# git ahead — ``git status -sb`` 헤더의 ``[ahead N]``.
GIT_AHEAD_PATTERN = re.compile(r"\[ahead\s+(\d+)\]")


class PendingDataCollector:
    """M4 sync polling collector — F-D1 SRP M4 영역."""

    DEFAULT_DISPATCH_DIR = Path("dispatch")

    def __init__(
        self,
        tmux: Optional[TmuxAdapter] = None,
        dispatch_dir: Optional[Path] = None,
        project_root: Optional[Path] = None,
        git: Optional[GitAdapter] = None,
    ) -> None:
        self.tmux = tmux or TmuxAdapter()
        self.project_root = (project_root or Path.cwd()).resolve()
        self.git = git or GitAdapter(project_root=self.project_root)
        candidate = dispatch_dir or self.DEFAULT_DISPATCH_DIR
        self.dispatch_dir = (
            candidate if candidate.is_absolute()
            else self.project_root / candidate
        )

    # ------------------------------------------------------------------
    # Pending Push (git ahead)
    # ------------------------------------------------------------------

    def get_pending_pushes(self) -> List[PendingPush]:
        """git ahead 커밋 → ``PendingPush`` list. 미가동/실패 시 빈 list."""
        ahead = self._git_ahead_count()
        if ahead == 0:
            return []
        commits = self._read_recent_commits(ahead)
        now = datetime.now()
        out: List[PendingPush] = []
        for sha, msg, author in commits:
            out.append(PendingPush(
                item_id=f"push-{sha[:7]}",
                item_type="push",
                description=msg[:200],
                timestamp=now,
                initiator=author,
                severity="medium",
            ))
        return out

    def _git_ahead_count(self) -> int:
        result = self.git.run(["git", "status", "-sb"])
        if result is None:
            return 0
        first = result.splitlines()[0] if result else ""
        match = GIT_AHEAD_PATTERN.search(first)
        return int(match.group(1)) if match else 0

    def _read_recent_commits(self, count: int) -> List[Tuple[str, str, str]]:
        result = self.git.run(
            ["git", "log", f"-{count}", "--format=%h\t%s\t%an"]
        )
        if result is None:
            return []
        commits: List[Tuple[str, str, str]] = []
        for line in result.splitlines():
            parts = line.split("\t", 2)
            if len(parts) == 3:
                commits.append((parts[0], parts[1], parts[2]))
        return commits

    # ------------------------------------------------------------------
    # Pending Question (dispatch md regex)
    # ------------------------------------------------------------------

    def get_pending_questions(self) -> List[PendingQuestion]:
        """dispatch md 안 ``**Qxxx**`` 패턴 → ``PendingQuestion`` list (read-only)."""
        if not self.dispatch_dir.is_dir():
            return []
        out: List[PendingQuestion] = []
        for md_path in sorted(self.dispatch_dir.glob("*.md")):
            try:
                content = md_path.read_text(encoding="utf-8", errors="ignore")
            except OSError:
                continue
            out.extend(self._extract_questions(content, md_path))
        return out

    def _extract_questions(
        self, content: str, source: Path
    ) -> List[PendingQuestion]:
        out: List[PendingQuestion] = []
        now = datetime.now()
        try:
            source_label = str(source.relative_to(self.project_root))
        except ValueError:
            source_label = str(source)
        seen_ids: set = set()
        for match in Q_HEADER_PATTERN.finditer(content):
            q_id = match.group(1)
            line_start = content.rfind("\n", 0, match.start()) + 1
            line_end = content.find("\n", match.end())
            line = content[line_start:line_end if line_end > 0 else None]
            key = (q_id, source_label)
            if key in seen_ids:
                continue
            seen_ids.add(key)
            out.append(PendingQuestion(
                q_id=q_id,
                category=self._category_of(line),
                description=line.strip()[:200],
                source=source_label,
                timestamp=now,
                priority=self._priority_of(line),
            ))
        return out

    @staticmethod
    def _priority_of(line: str) -> str:
        m = Q_PRIORITY_PATTERN.search(line)
        return m.group(1).lower() if m else "medium"

    @staticmethod
    def _category_of(line: str) -> str:
        m = Q_CATEGORY_PATTERN.search(line)
        return m.group(1).lower() if m else "decision"
