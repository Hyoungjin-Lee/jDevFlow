"""Q2 정확 hook — claude CLI session-end hook 인입 + capture-pane regex fallback.

design_final Sec.7.3 + R-10 정정:

- 글로벌 ``~/.claude/`` → 프로젝트 ``.claude/dashboard_state/`` 이전 (F-62-4 글로벌
  영역 침범 회피).
- 파일명 namespace prefix ``joneflow_<project_path_hash>_<session>.json`` 추가 →
  다른 jOneFlow 프로젝트 인스턴스 간 isolation.
- ``TmuxAdapter`` 위임으로 subprocess 직접 import 0건 (R-5 정정 정합 — 모듈 경계
  #4 더 강함, AC-T-4 = 2).
"""
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path
from typing import Optional

from .tmux_adapter import TmuxAdapter


class TokenHook:
    """우선순위 chain: hook JSON → capture-pane regex → 0.0 폴백 (Sec.14 에러 경로)."""

    HOOK_DIR_NAME = ".claude/dashboard_state"
    REGEX = re.compile(
        r'"usage"\s*:\s*\{\s*"input_tokens"\s*:\s*(\d+)\s*,\s*"output_tokens"\s*:\s*(\d+)'
    )

    def __init__(
        self,
        tmux: Optional[TmuxAdapter] = None,
        project_root: Optional[Path] = None,
    ) -> None:
        self.tmux = tmux or TmuxAdapter()
        self._project_root = (project_root or Path.cwd()).resolve()
        self._hook_dir = self._project_root / self.HOOK_DIR_NAME
        # R-10 namespace prefix — sha1(project_root)[:8].
        self._project_hash = hashlib.sha1(
            str(self._project_root).encode("utf-8")
        ).hexdigest()[:8]

    def get_tokens_k(
        self,
        pane_name: str,
        prefetched_lines: Optional[list] = None,
    ) -> float:
        """1순위 hook JSON / 2순위 capture-pane regex / 3순위 0.0.

        Stage 10 M-2 fix — ``prefetched_lines`` 인입 시 capture-pane 호출 0건
        (PersonaDataCollector batch 결과 재사용). None일 때만 기존 폴백 호출.
        """
        session = pane_name.split(":")[0] if ":" in pane_name else pane_name
        hook_value = self._read_hook(session)
        if hook_value is not None:
            return hook_value
        regex_value = self._regex_from_lines(prefetched_lines) if prefetched_lines else None
        if regex_value is None and prefetched_lines is None:
            regex_value = self._regex_capture(pane_name)
        if regex_value is not None:
            return regex_value
        return 0.0

    # ------------------------------------------------------------------
    # 1순위 — 프로젝트 hook JSON 인입
    # ------------------------------------------------------------------

    def _read_hook(self, session: str) -> Optional[float]:
        """``.claude/dashboard_state/joneflow_<hash>_<session>.json`` → tokens_k."""
        f = self._hook_dir / f"joneflow_{self._project_hash}_{session}.json"
        if not f.is_file():
            return None
        try:
            data = json.loads(f.read_text(encoding="utf-8"))
            input_tokens = int(data.get("input_tokens", 0))
            output_tokens = int(data.get("output_tokens", 0))
        except (json.JSONDecodeError, OSError, ValueError, TypeError):
            return None
        return (input_tokens + output_tokens) / 1000.0

    # ------------------------------------------------------------------
    # 2순위 — capture-pane regex (TmuxAdapter 위임 — subprocess 0건)
    # ------------------------------------------------------------------

    def _regex_capture(self, pane_name: str) -> Optional[float]:
        """capture-pane 마지막 100줄에서 ``"usage": {...}`` 매치 → tokens_k."""
        try:
            lines = self.tmux.capture_pane(pane_name, lines=100)
        except Exception:
            return None
        return self._regex_from_lines(lines)

    def _regex_from_lines(self, lines: Optional[list]) -> Optional[float]:
        """이미 capture된 lines 재사용 — Stage 10 M-2 fix (subprocess 호출 0건)."""
        if not lines:
            return None
        match = self.REGEX.search("\n".join(lines))
        if match is None:
            return None
        try:
            return (int(match.group(1)) + int(match.group(2))) / 1000.0
        except (ValueError, TypeError):
            return None
