"""M4 — Notifier ABC + OSAScriptNotifier (Q3) + WindowsNotifier (Q4 P1 stub).

design_final Sec.9.3 R-11 Critical 정정 본문:
    drafter v1 메모이제이션 데코레이터 패턴은 항상 cached True 반환 → dedupe 영구
    미작동. 본 stage 정정 = ``dict[str, datetime] + 5분 TTL 비교`` 패턴
    (``_is_recently_sent``). LRU 동등 동작(128 초과 시 가장 오래된 키 제거).

Q3 운영자 결정: macOS osascript 기본, **외부 유료 알림 서비스 회피** (외부 API DEFCON 회피).
Q4 P1: Windows skeleton만 (plyer 0순위 / win10toast 1순위, v0.6.5+ 본 가동).
"""
from __future__ import annotations

import subprocess
import sys
from abc import ABC, abstractmethod
from datetime import datetime, timedelta
from typing import Dict

from .models import PendingQuestion


class Notifier(ABC):
    """알림 채널 abstraction — Q3 = osascript 기본."""

    @abstractmethod
    def notify(self, q: PendingQuestion) -> bool:
        """알림 발송. dedupe 적용 — 5분 윈도우 내 중복 발화 0건. True = 발송 성공."""


# ---------------------------------------------------------------------------
# OSAScriptNotifier — macOS 기본 (Q3), R-11 dict + TTL dedupe
# ---------------------------------------------------------------------------


class OSAScriptNotifier(Notifier):
    """macOS ``osascript -e 'display notification'`` 기본 (Q3 결정 verbatim).

    R-11 Critical 정정 (옵션 1 본 stage 정정):
        drafter v1 메모이제이션 데코레이터 → ``dict[str, datetime] + 5분 TTL 비교``로
        정정. ``dedupe_key`` 5분 truncate (R-4) + 본 5분 TTL 비교 = 이중 5분 보장.
    """

    # R-N reviewer 검증 (M4 PASS_WITH_PATCH) — R-11 Critical 정정 완벽 정합 (lru_cache 0건).
    DEDUPE_TTL: timedelta = timedelta(minutes=5)
    DEDUPE_MAX: int = 128
    SUBPROCESS_TIMEOUT_SEC: float = 5.0
    SOUND_NAME: str = "Submarine"  # drafter R-5 영구 (디자인팀 boundary 후보)

    def __init__(self) -> None:
        # R-11 정정: 메모이제이션 → dict (key = dedupe_key, value = 첫 발화 시각).
        self._sent_keys: Dict[str, datetime] = {}

    def _is_recently_sent(self, dedupe_key: str) -> bool:
        """5분 TTL 비교 — 동일 ``dedupe_key`` 5분 내 재발화 skip.

        R-11 정정 정합: 메모이제이션 X, time-based comparison O.
        """
        now = datetime.now()
        last_sent = self._sent_keys.get(dedupe_key)
        if last_sent is not None and (now - last_sent) < self.DEDUPE_TTL:
            return True
        self._sent_keys[dedupe_key] = now
        # LRU 동등 동작 — 128 초과 시 가장 오래된 키 제거 (메모리 leak 회피).
        if len(self._sent_keys) > self.DEDUPE_MAX:
            oldest = min(self._sent_keys, key=lambda k: self._sent_keys[k])
            del self._sent_keys[oldest]
        return False

    def notify(self, q: PendingQuestion) -> bool:
        if self._is_recently_sent(q.dedupe_key()):
            return False
        msg = self._sanitize(q.description)
        title = self._sanitize(f"jOneFlow {q.q_id}")
        cmd = [
            "osascript",
            "-e",
            (
                f'display notification "{msg}" with title "{title}" '
                f'sound name "{self.SOUND_NAME}"'
            ),
        ]
        try:
            res = subprocess.run(
                cmd,
                capture_output=True,
                timeout=self.SUBPROCESS_TIMEOUT_SEC,
                check=False,
            )
        except (FileNotFoundError, subprocess.TimeoutExpired, OSError):
            # Sec.14 에러 경로 — F-X-2 read-only, write fallback 0건.
            return False
        return res.returncode == 0

    @staticmethod
    def _sanitize(s: str) -> str:
        """AppleScript injection 회피 — backslash / double-quote / newline escape."""
        return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ")


# ---------------------------------------------------------------------------
# WindowsNotifier — Q4 P1 stub (v0.6.5+ 본 가동)
# ---------------------------------------------------------------------------


class WindowsNotifier(Notifier):
    """Q4 P1 — plyer 0순위 / win10toast 1순위 (Sec.10.2 권고). v0.6.5+ 본 가동.

    M5 갱신: ``platform_compat.send_windows_notification()``에 위임 — backend 호출
    detail이 격리되며 R-11 dedupe도 OSAScriptNotifier와 동일 패턴 적용.
    """

    BACKEND_PRIORITY = ("plyer", "win10toast")
    DEDUPE_TTL = timedelta(minutes=5)
    DEDUPE_MAX = 128

    def __init__(self) -> None:
        self._sent_keys: Dict[str, datetime] = {}

    def _is_recently_sent(self, dedupe_key: str) -> bool:
        """R-11 정합 — dict + 5분 TTL (Windows에서도 dedupe 동일 보장)."""
        now = datetime.now()
        last_sent = self._sent_keys.get(dedupe_key)
        if last_sent is not None and (now - last_sent) < self.DEDUPE_TTL:
            return True
        self._sent_keys[dedupe_key] = now
        if len(self._sent_keys) > self.DEDUPE_MAX:
            oldest = min(self._sent_keys, key=lambda k: self._sent_keys[k])
            del self._sent_keys[oldest]
        return False

    def notify(self, q: PendingQuestion) -> bool:
        if self._is_recently_sent(q.dedupe_key()):
            return False
        # platform_compat 위임 — plyer/win10toast skeleton (v0.6.5+ 본 가동).
        from .platform_compat import send_windows_notification
        return send_windows_notification(
            title=f"jOneFlow {q.q_id}",
            message=q.description,
        )


# ---------------------------------------------------------------------------
# OS 자동 감지 — sys.platform 기반 분기
# ---------------------------------------------------------------------------


def get_notifier() -> Notifier:
    """``sys.platform`` 자동 감지 — darwin → osascript, 기타 → Windows stub."""
    if sys.platform == "darwin":
        return OSAScriptNotifier()
    return WindowsNotifier()
