"""M5 — Q4 P1 platform detection + Windows skeleton (design_final Sec.10.1).

- ``detect_platform()`` — ``sys.platform`` + ``/proc/version`` Microsoft·WSL feature detection.
- ``supports_native_notification()`` — macOS 단독 본 가동 (Q4 P1, Sec.11.4).
- ``send_windows_notification()`` — plyer 0순위 / win10toast 1순위 skeleton (Sec.10.2 비교).
- v0.6.4 = macOS 단독, Windows = stub. v0.6.5+ 본 가동 시 plyer/win10toast 본문 채움.
- WSL 검출 = ``content = f.read()`` 1회 read (drafter v1 두 번 read 미스 정정).
"""
from __future__ import annotations

import sys
from typing import Literal

PlatformKind = Literal["macos", "windows", "linux", "wsl"]

# Q4 P1 — Windows backend 권장 순서 (Sec.10.2 verbatim).
WINDOWS_BACKEND_PRIORITY = ("plyer", "win10toast")


def detect_platform() -> PlatformKind:
    """``sys.platform`` 자동 감지 + WSL 분기 (Sec.10.1 verbatim).

    - ``darwin`` → macos.
    - ``win32`` → windows.
    - linux + ``/proc/version`` 안 ``microsoft`` / ``WSL`` 키워드 → wsl.
    - 기타 linux → linux.
    """
    if sys.platform == "darwin":
        return "macos"
    if sys.platform == "win32":
        return "windows"
    if sys.platform.startswith("linux"):
        try:
            with open("/proc/version", "r", encoding="utf-8") as f:
                content = f.read()  # drafter v1 미스 정정 — 1회 read.
        except OSError:
            return "linux"
        if "microsoft" in content.lower() or "WSL" in content:
            return "wsl"
        return "linux"
    return "linux"


def supports_native_notification() -> bool:
    """v0.6.4 = macOS 단독 본 가동 (Q4 P1 결정, design_final Sec.11.4)."""
    return detect_platform() == "macos"


# ---------------------------------------------------------------------------
# Windows skeleton — plyer 0순위 / win10toast 1순위 (Sec.10.2 비교)
# ---------------------------------------------------------------------------


def send_windows_notification(title: str, message: str) -> bool:
    """Q4 P1 stub — Windows 알림 wrapper.

    backend 채택 우선순위 (Sec.10.2):
        1. plyer (0순위) — cross-platform / pip 단일 / icon 제한.
        2. win10toast (1순위) — Windows native toast / icon 지원 / Windows 한정.

    v0.6.4 = 두 backend 미설치 가정 → ImportError silently 처리 → False 반환.
    v0.6.5+ 본 가동 시 본 함수 본문이 실제 backend 호출로 채워짐.

    F-X-2 read-only 정합 — 외부 alert 발송(read 없음) 외 write 명령 0건.
    """
    if _try_plyer(title, message):
        return True
    return _try_win10toast(title, message)


def _try_plyer(title: str, message: str) -> bool:
    """plyer.notification.notify() — 미설치 시 False (skeleton)."""
    try:
        from plyer import notification  # type: ignore[import-not-found]
    except ImportError:
        return False
    try:
        notification.notify(  # type: ignore[attr-defined]
            title=title, message=message, app_name="jOneFlow",
        )
        return True
    except Exception:
        # 채택 실패 → 1순위(win10toast)로 폴백.
        return False


def _try_win10toast(title: str, message: str) -> bool:
    """win10toast ToastNotifier — 미설치 시 False (skeleton)."""
    try:
        from win10toast import ToastNotifier  # type: ignore[import-not-found]
    except ImportError:
        return False
    try:
        ToastNotifier().show_toast(  # type: ignore[attr-defined]
            title, message, duration=5, threaded=True,
        )
        return True
    except Exception:
        return False
