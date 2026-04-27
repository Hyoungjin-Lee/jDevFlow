#!/usr/bin/env python3
"""jOneFlow 운영자 대시보드 단일 진입점 (F-D2 정합).

textual 0.50+ 기반 read-only TUI. 18명 페르소나 + PM 1명 = 19명 실시간 가시화 (F-X-2 영구).
M1 scaffold 단계 — 데이터 수집(M2) / 렌더링(M3) / Pending+알림(M4) / 18명 매핑(M5)은
`scripts/dashboard/` 모듈 패키지 영역에서 채워집니다 (design_final Sec.2 구조).

진입: ``venv/bin/python3 scripts/dashboard.py`` 또는 슬래시 ``/dashboard``.
종료: ``q``.
"""
from __future__ import annotations

import threading
import time

from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.widgets import Static


class DashboardApp(App):
    """jOneFlow 대시보드 textual App.

    F-D4 본문 결정 정합 — ``on_mount``는 sync ``def`` (R-3 정정). Threaded sync wrapper로
    1초 polling worker를 ``run_worker(thread=True)``에 위임하여 메인 thread blocking 회피.
    """

    CSS = """
    Screen {
        background: $surface;
    }
    #placeholder {
        padding: 1 2;
        color: $text;
    }
    """

    BINDINGS = [Binding("q", "quit", "Quit")]

    def __init__(self) -> None:
        super().__init__()
        # F-D4 thread-safety — worker 정상 종료 신호. action_quit이 set, _refresh_loop이 wait.
        self._exit_signal: threading.Event = threading.Event()

    def compose(self) -> ComposeResult:
        """M1 placeholder 위젯. M3에서 PMStatusBar / 박스 3개 / Pending 박스 2개로 대체."""
        yield Static(
            "jOneFlow 대시보드 — M1 scaffold\n"
            "데이터(M2) / 렌더(M3) / Pending+알림(M4) / 18명 매핑(M5) 본문 미구현.\n"
            "종료: q",
            id="placeholder",
        )

    def on_mount(self) -> None:
        """F-D4 sync 시작 훅. M2~M4 wiring 시 Collector / Notifier 초기화 추가 영역."""
        # Collector / Notifier 초기화는 M2~M4 영역:
        #   self.persona_collector = PersonaDataCollector()
        #   self.pending_collector = PendingDataCollector()
        #   self.notifier = OSAScriptNotifier()
        self.run_worker(self._refresh_loop, thread=True, exclusive=True)

    def _refresh_loop(self) -> None:
        """sync polling worker (1초 주기). M1은 exit 신호 wait만, M2가 collector fetch wiring.

        thread-safety 정책: 위젯 갱신은 ``call_from_thread``로 메인 thread에 push (M2 영역).
        """
        while not self._exit_signal.is_set():
            # M2~M4 wiring 영역:
            #   try:
            #       personas = self.persona_collector.fetch_all_personas()
            #       pushes = self.pending_collector.get_pending_pushes()
            #       questions = self.pending_collector.get_pending_questions()
            #   except Exception as exc:
            #       self.call_from_thread(self._show_stale, exc)
            #   else:
            #       self.call_from_thread(self._update_widgets, personas, pushes, questions)
            time.sleep(1.0)

    def _update_widgets(self, personas, pushes, questions) -> None:
        """M2~M4 wiring 영역 placeholder (Sec.6.1 6 메서드 정합).

        worker thread → ``call_from_thread`` 경유로 메인 thread 진입. 본문은 M3에서
        ``TeamRenderer`` / ``PendingPushBox`` / ``PendingQBox`` 위젯 갱신으로 대체.
        """

    def _show_stale(self, exc: BaseException) -> None:
        """Sec.14 에러 경로 폴백 — staleness ⚠ 표시 영역 placeholder (R-1 정정 정합).

        worker thread에서 collector 예외 발생 시 ``call_from_thread`` 경유 진입. M2~M4에서
        ``last_update`` 보존 + ⚠ 마커 위젯 표시로 대체.
        """

    def action_quit(self) -> None:  # noqa: D401 — textual action 시그니처
        """``q`` 바인딩. exit 신호 설정 후 textual 종료 — worker thread 정상 회수."""
        self._exit_signal.set()
        self.exit()


def main() -> None:
    """진입점. 슬래시 ``/dashboard``와 직접 실행 양방향 호출."""
    DashboardApp().run()


if __name__ == "__main__":
    main()
