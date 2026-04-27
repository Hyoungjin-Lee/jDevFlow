"""tmux + git subprocess 격리 layer — 모듈 경계 #4 (design_final Sec.4.2).

``subprocess`` 직접 import는 본 모듈 + ``notifier.py`` 2건만 허용 (R-5).
capture-pane 의존 완전 제거 — 세션 존재 확인(list_sessions)에만 사용.
"""
from __future__ import annotations

import subprocess
from pathlib import Path
from typing import List, Optional


class TmuxAdapter:
    """tmux 세션 어댑터. 미가동 / 미설치 시 빈 list 폴백 (Q5 idle 통합)."""

    DEFAULT_TIMEOUT_SEC = 3.0

    def __init__(self, timeout_sec: float = DEFAULT_TIMEOUT_SEC) -> None:
        self.timeout_sec = timeout_sec

    def list_sessions(self) -> List[str]:
        """``tmux list-sessions -F '#{session_name}'`` → 세션명 list.

        tmux 미설치 / 세션 0개 / timeout 모두 빈 list 반환 (Q5 idle 폴백 정합).
        """
        result = self._run(["tmux", "list-sessions", "-F", "#{session_name}"])
        if result is None:
            return []
        return [line.strip() for line in result.splitlines() if line.strip()]

    def list_panes(self, session: str) -> List[str]:
        """``<session>:<window>.<pane>`` 형식 pane id list. 실패 시 빈 list."""
        result = self._run([
            "tmux", "list-panes", "-t", session, "-a",
            "-F", "#{session_name}:#{window_index}.#{pane_index}",
        ])
        if result is None:
            return []
        return [line.strip() for line in result.splitlines() if line.strip()]

    def _run(self, argv: List[str]) -> Optional[str]:
        """subprocess.run 단일 진입 — 격리 #4 정합. 실패 시 None."""
        try:
            res = subprocess.run(
                argv,
                capture_output=True,
                text=True,
                timeout=self.timeout_sec,
                check=False,
            )
        except (FileNotFoundError, subprocess.TimeoutExpired, OSError):
            return None
        if res.returncode != 0:
            return None
        return res.stdout


class GitAdapter:
    """git subprocess 격리 adapter — AC-T-4 = 2 유지.

    ``pending_collector.py``가 본 어댑터 위임으로 subprocess 직접 import 0건.
    """

    DEFAULT_TIMEOUT_SEC = 3.0

    def __init__(
        self,
        project_root: Optional[Path] = None,
        timeout_sec: float = DEFAULT_TIMEOUT_SEC,
    ) -> None:
        self.project_root = (project_root or Path.cwd()).resolve()
        self.timeout_sec = timeout_sec

    def run(self, argv: List[str]) -> Optional[str]:
        """git argv → stdout 문자열. 실패 시 None. cwd = project_root 고정."""
        try:
            res = subprocess.run(
                argv,
                capture_output=True,
                text=True,
                timeout=self.timeout_sec,
                check=False,
                cwd=str(self.project_root),
            )
        except (FileNotFoundError, subprocess.TimeoutExpired, OSError):
            return None
        if res.returncode != 0:
            return None
        return res.stdout
