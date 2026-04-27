"""tmux subprocess 격리 layer — 모듈 경계 #4 (design_final Sec.4.2).

``subprocess`` 직접 import는 본 모듈 + ``notifier.py`` 2건만 허용 (R-5 정정 = AC-T-4 = 2).
``token_hook.py``는 본 어댑터 위임으로 subprocess 호출 0건.

sync 인터페이스 전면 (F-D4 Threaded sync wrapper). textual ``run_worker(thread=True)``
워커 thread에서 1초 주기 호출됩니다 — 메인 thread blocking 없음.
"""
from __future__ import annotations

import hashlib
import subprocess
from datetime import datetime
from typing import Dict, List, Optional, Tuple


class TmuxAdapter:
    """tmux 세션 / pane sync 어댑터. 미가동 / 미설치 시 빈 list 폴백 (Q5 idle 통합)."""

    DEFAULT_TIMEOUT_SEC = 3.0

    def __init__(self, timeout_sec: float = DEFAULT_TIMEOUT_SEC) -> None:
        self.timeout_sec = timeout_sec
        # pane signature → 마지막 변화 시각 캐시 (R-1 staleness 정합).
        self._pane_change_cache: Dict[str, Tuple[str, datetime]] = {}

    def list_sessions(self) -> List[str]:
        """``tmux list-sessions -F '#{session_name}'`` → 세션명 list.

        tmux 미설치(``FileNotFoundError``) / 세션 0개(``returncode != 0``) / timeout
        모두 빈 list 반환 — Q5 idle 통합 폴백 정합.
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

    def capture_pane(self, pane: str, lines: int = 50) -> List[str]:
        """``tmux capture-pane -p -S -<lines>`` → 마지막 N줄 list.

        부수효과: pane signature 변화 감지 → ``last_pane_change`` 캐시 갱신
        (idle 임계 판정용, design_final Sec.7.4 t=10초 정합).
        """
        result = self._run(
            ["tmux", "capture-pane", "-t", pane, "-p", "-S", f"-{int(lines)}"]
        )
        if result is None:
            return []
        captured = result.splitlines()
        self._update_change_cache(pane, captured)
        return captured

    def last_pane_change(self, pane: str) -> datetime:
        """pane 마지막 변화 시각. 미관측 = epoch 0 → staleness 자연 발동 (R-1).

        ``capture_pane`` 부수효과로 갱신됨. 직접 호출 시 cache lookup만 수행.
        """
        cached = self._pane_change_cache.get(pane)
        if cached is None:
            return datetime.fromtimestamp(0)
        return cached[1]

    # ------------------------------------------------------------------
    # 내부 helper
    # ------------------------------------------------------------------

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

    def _update_change_cache(self, pane: str, captured: List[str]) -> None:
        """pane 출력 SHA1 변화 시 ``last_pane_change`` 갱신."""
        signature = hashlib.sha1("\n".join(captured).encode("utf-8")).hexdigest()
        prev = self._pane_change_cache.get(pane)
        if prev is None or prev[0] != signature:
            self._pane_change_cache[pane] = (signature, datetime.now())
