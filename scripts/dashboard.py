#!/usr/bin/env python3
"""jOneFlow 운영자 대시보드 단일 진입점 (F-D2 정합).

textual 0.50+ 기반 read-only TUI. 18명 페르소나 + PM 1명 = 19명 실시간 가시화 (F-X-2 영구).

Stage 10b — M2~M5 wiring 통합 본문 (Stage 10 16def78 → Stage 10b followup).
``scripts/dashboard/`` 모듈 (M2 collector / M3 renderer / M4 pending+notifier / M5 personas)
import + 인스턴스 생성 + 1초 polling worker → 위젯 갱신 + 알림 발송 wiring.

진입: ``venv/bin/python3 scripts/dashboard.py`` 또는 슬래시 ``/dashboard``.
종료: ``q``.
"""
from __future__ import annotations

import threading
from typing import Dict, List

from textual.app import App, ComposeResult
from textual.binding import Binding

from scripts.dashboard.models import PendingPush, PendingQuestion, PersonaState
from scripts.dashboard.notifier import get_notifier
from scripts.dashboard.pending import PendingArea
from scripts.dashboard.pending_collector import PendingDataCollector
from scripts.dashboard.persona_collector import PersonaDataCollector
from scripts.dashboard.render import DashboardRenderer
from scripts.dashboard.status_bar import compose_pm_state
from scripts.dashboard.tmux_adapter import TmuxAdapter

REFRESH_INTERVAL_SEC: float = 1.0
TEAM_ORDER: tuple = ("기획", "디자인", "개발")


class DashboardApp(App):
    """jOneFlow 대시보드 textual App.

    F-D4 본문 결정 정합 — ``on_mount``는 sync ``def`` (R-3 정정). Threaded sync wrapper로
    1초 polling worker를 ``run_worker(thread=True)``에 위임하여 메인 thread blocking 회피.

    Stage 10b wiring — DashboardRenderer (M3) + PendingArea (M4) compose. on_mount에서
    TmuxAdapter / PersonaDataCollector / PendingDataCollector / Notifier 초기화. worker가
    1초 주기로 collector fetch + ``call_from_thread`` 경유 위젯 갱신 + Notifier 발송.
    """

    CSS_PATH = "dashboard/dashboard.tcss"

    BINDINGS = [Binding("q", "quit", "Quit")]

    def __init__(self) -> None:
        super().__init__()
        # F-D4 thread-safety — worker 정상 종료 신호. action_quit이 set, _refresh_loop이 wait.
        self._exit_signal: threading.Event = threading.Event()

    def compose(self) -> ComposeResult:
        """M3 DashboardRenderer + M4 PendingArea 단일 진입 (design_final Sec.8 / Sec.9.2)."""
        yield DashboardRenderer(id="dashboard")
        yield PendingArea(id="pending_area")

    def on_mount(self) -> None:
        """F-D4 sync 시작 훅 — Collector 2개 / Notifier 초기화 + worker spawn."""
        self._tmux = TmuxAdapter()
        self.persona_collector = PersonaDataCollector(tmux=self._tmux)
        self.pending_collector = PendingDataCollector(tmux=self._tmux)
        self.notifier = get_notifier()
        self.run_worker(self._refresh_loop, thread=True, exclusive=True)

    def _refresh_loop(self) -> None:
        """sync polling worker (1초 주기). collector fetch + Notifier 발송 + call_from_thread.

        thread-safety 정책: 위젯 갱신은 ``call_from_thread``로 메인 thread에 push. Notifier
        발송은 worker thread 영역에서 직접 (subprocess osascript 호출, widget tree 무관).
        """
        while not self._exit_signal.is_set():
            try:
                personas = self.persona_collector.fetch_all_personas()
                pm_state, active_orcs = compose_pm_state(self._tmux)
                pushes = self.pending_collector.get_pending_pushes()
                questions = self.pending_collector.get_pending_questions()
            except Exception as exc:  # noqa: BLE001 — Sec.14 에러 경로 폴백
                self.call_from_thread(self._show_stale, exc)
            else:
                # M4 알림 발송 — worker thread 영역 (subprocess + dedupe). dedupe 5분 TTL은
                # Notifier 내부 영구 — 동일 dedupe_key 5분 내 재발화 0건.
                for q in questions:
                    try:
                        self.notifier.notify(q)
                    except Exception:  # noqa: BLE001 — 알림 실패는 dashboard 진행 영향 0건
                        pass
                self.call_from_thread(
                    self._update_widgets, personas, pushes, questions,
                    pm_state, active_orcs,
                )
            if self._exit_signal.wait(REFRESH_INTERVAL_SEC):
                break

    def _update_widgets(
        self,
        personas: List[PersonaState],
        pushes: List[PendingPush],
        questions: List[PendingQuestion],
        pm_state: PersonaState,
        active_orcs: List[str],
    ) -> None:
        """worker → call_from_thread 메인 thread 진입. M3 + M4 위젯 일괄 갱신."""
        teams_data: Dict[str, List[PersonaState]] = {team: [] for team in TEAM_ORDER}
        for p in personas:
            teams_data.setdefault(p.team, []).append(p)
        try:
            self.query_one("#dashboard", DashboardRenderer).update_data(
                teams_data, pm_state=pm_state, active_orcs=active_orcs,
            )
            self.query_one("#pending_area", PendingArea).update_data(
                pushes=pushes, questions=questions,
            )
        except Exception:  # noqa: BLE001 — 종료 단계 race 또는 위젯 detach 시 무시
            pass

    def _show_stale(self, exc: BaseException) -> None:
        """Sec.14 에러 경로 폴백 — staleness ⚠ 마커 (R-1 정정 정합).

        worker thread에서 collector 예외 발생 시 ``call_from_thread`` 경유 진입.
        PMStatusBar에 1행 stale 메시지 표기 (60자 cap). dashboard / pending_area는 마지막
        성공 상태 보존 (R-1 last_update 정합).
        """
        try:
            from scripts.dashboard.status_bar import PMStatusBar
            bar = self.query_one("#pm_status_bar", PMStatusBar)
            label = f"⚠ stale — {type(exc).__name__}: {str(exc)[:60]}"
            bar.update(label)
        except Exception:  # noqa: BLE001
            pass

    def action_quit(self) -> None:  # noqa: D401 — textual action 시그니처
        """``q`` 바인딩. exit 신호 설정 후 textual 종료 — worker thread 정상 회수."""
        self._exit_signal.set()
        self.exit()


def main() -> None:
    """진입점. 슬래시 ``/dashboard``와 직접 실행 양방향 호출."""
    DashboardApp().run()


if __name__ == "__main__":
    main()
