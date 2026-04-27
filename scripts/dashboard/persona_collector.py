"""M2 — ``PersonaDataCollector`` sync polling (F-D1 + F-D4 + Q5 idle 통합).

design_final Sec.7.1 (인터페이스) + Sec.7.2 (idle 알고리즘) + Sec.7.4 (T 임계 10초)
+ Sec.7.5 (작업명 추론 A-1 > A-3 > A-2) verbatim 흡수.

- F-D1 SRP — 본 모듈은 페르소나 상태만 책임. ``PendingDataCollector``는 M4 영역.
- F-D4 — sync ``def`` 전면. async/await 0건. ``DashboardApp.run_worker(thread=True)``
  워커 thread에서 1초 주기 호출.
- Q5 — tmux 세션 미존재 = idle (offline 분리 옵션 0건, F-M2-5 흡수).
- R-1 — idle 폴백 시 ``last_update`` 이전 값 보존 (staleness ⚠ 자연 발동).
- R-2 — A-2 thinking → ``last_known_task`` 직전 작업명 유지 (None 회수).
"""
from __future__ import annotations

import re
from datetime import datetime
from typing import Dict, List, Optional, Set, Tuple

from .models import PersonaState
from .tmux_adapter import TmuxAdapter
from .token_hook import TokenHook


# F-X-6 18명 매핑 — 4팀 15명 (PM/CTO/CEO는 M5 status bar / placeholder 영역).
# operating_manual.md Sec.1.2 정규명 그대로.
PERSONAS_18: List[Tuple[str, str]] = [
    # 기획팀 4
    ("박지영", "기획"), ("김민교", "기획"), ("안영이", "기획"), ("장그래", "기획"),
    # 디자인팀 4
    ("우상호", "디자인"), ("이수지", "디자인"), ("오해원", "디자인"), ("장원영", "디자인"),
    # 개발팀 7
    ("공기성", "개발"), ("최우영", "개발"), ("현봉식", "개발"), ("카더가든", "개발"),
    ("백강혁", "개발"), ("김원훈", "개발"), ("지예은", "개발"),
]


# 팀 → Orc 세션명. drafter 자율 영역 (M5에서 personas_18.md 도착 후 갱신).
_TEAM_TO_ORC_SESSION: Dict[str, str] = {
    "기획": "Orc-064-plan",
    "디자인": "Orc-064-design",
    "개발": "Orc-064-dev",
}


# 페르소나 → pane index. design_final Sec.4 헌법 (왼쪽=PL / 오른쪽 stack=드래프터/리뷰어/파이널)
# 정합. 개발팀 BE 트리오 (1.x) + FE 트리오 (2.x, M5 진입 시 별도 pane 영역) 잠정 분리.
_PERSONA_TO_PANE_INDEX: Dict[str, str] = {
    # 기획팀
    "박지영": "1.1", "장그래": "1.2", "김민교": "1.3", "안영이": "1.4",
    # 디자인팀
    "우상호": "1.1", "장원영": "1.2", "이수지": "1.3", "오해원": "1.4",
    # 개발팀 BE 트리오
    "공기성": "1.1", "카더가든": "1.2", "최우영": "1.3", "현봉식": "1.4",
    # 개발팀 FE 트리오 — M5 진입 시 별도 Orc 세션 / pane 매핑 갱신 영역.
    "백강혁": "2.3", "지예은": "2.2", "김원훈": "2.4",
}


# Sec.7.4 채택값 — 갱신 주기 1초 / idle T 10초 / stale 2초 (settings.json 이월 영역).
# R-N reviewer 검증 (M2 PASS_WITH_PATCH) — Sec.7.4 채택값 정합 + AC-S8-3 이월.
IDLE_THRESHOLD_SEC = 10.0


class PersonaDataCollector:
    """M2 sync polling collector — F-D1 본문 단일 source.

    sync 인터페이스 (F-D4 Threaded sync wrapper). textual main thread에서 직접 호출
    금지 — ``run_worker(thread=True)`` 컨텍스트 강제.
    """

    def __init__(
        self,
        tmux: Optional[TmuxAdapter] = None,
        token_hook: Optional[TokenHook] = None,
    ) -> None:
        self.tmux = tmux or TmuxAdapter()
        self.token_hook = token_hook or TokenHook(tmux=self.tmux)
        # R-1 idle 폴백 last_update 보존용. R-2 A-2 last_known_task fallback도 활용.
        self._last_known_states: Dict[str, PersonaState] = {}

    def fetch_all_personas(self) -> List[PersonaState]:
        """18명 모든 페르소나 상태 — tmux 미존재도 idle yield (Q5 통합).

        Stage 10 M-2 fix — 1 polling 사이클당 subprocess.run 호출:
          - ``list_sessions``: 1
          - ``capture_panes_batch`` (활성 세션 pane 일괄): 1
          - 합계 ≤ 2 spawn/sec (기존 18~33 spawn/sec).
        """
        active_sessions: Set[str] = set(self.tmux.list_sessions())

        # M-2 batch capture — 활성 pane만 1회 subprocess로 일괄 capture.
        active_panes: List[str] = []
        for name, team in PERSONAS_18:
            pane_name = self._persona_to_pane(name, team)
            if pane_name is None:
                continue
            session = pane_name.split(":")[0]
            if session in active_sessions:
                active_panes.append(pane_name)
        # 100 lines = token regex(100) + task prompt(50)의 superset.
        pane_lines: Dict[str, List[str]] = (
            self.tmux.capture_panes_batch(active_panes, lines=100)
            if active_panes else {}
        )

        out: List[PersonaState] = []
        for name, team in PERSONAS_18:
            state = self._infer_state(name, team, active_sessions, pane_lines)
            self._last_known_states[name] = state
            out.append(state)
        return out

    def fetch_team(self, team: str) -> List[PersonaState]:
        return [p for p in self.fetch_all_personas() if p.team == team]

    def persona_by_name(self, name: str) -> Optional[PersonaState]:
        for p in self.fetch_all_personas():
            if p.name == name:
                return p
        return None

    # ------------------------------------------------------------------
    # 내부 추론
    # ------------------------------------------------------------------

    def _infer_state(
        self,
        name: str,
        team: str,
        active_sessions: Set[str],
        pane_lines: Dict[str, List[str]],
    ) -> PersonaState:
        """Q5 idle 통합 + R-1 last_update 보존 — design_final Sec.7.2 verbatim."""
        pane_name = self._persona_to_pane(name, team)
        session = pane_name.split(":")[0] if pane_name and ":" in pane_name else None

        if not pane_name or session not in active_sessions:
            # Q5 — tmux 미존재 = idle. R-1 last_update 보존.
            prev = self._last_known_states.get(name)
            last_update = prev.last_update if prev else datetime.fromtimestamp(0)
            return PersonaState(
                name=name, team=team, status="idle", task=None,
                tokens_k=0.0, last_update=last_update,
            )

        last_change = self.tmux.last_pane_change(pane_name)
        elapsed = (datetime.now() - last_change).total_seconds()
        # M-2 fix — pre-fetched lines를 token_hook에 전달하여 capture-pane 추가 호출 0건.
        cached_lines = pane_lines.get(pane_name)
        tokens_k = self.token_hook.get_tokens_k(pane_name, prefetched_lines=cached_lines)

        if elapsed > IDLE_THRESHOLD_SEC:
            # T 임계 초과 = idle. R-1 — tmux 마지막 변화 시각 보존.
            return PersonaState(
                name=name, team=team, status="idle", task=None,
                tokens_k=tokens_k, last_update=last_change,
            )

        return PersonaState(
            name=name, team=team, status="working",
            task=self._infer_task(name, cached_lines),
            tokens_k=tokens_k, last_update=last_change,
        )

    def _persona_to_pane(self, name: str, team: str) -> Optional[str]:
        session = _TEAM_TO_ORC_SESSION.get(team)
        pane_idx = _PERSONA_TO_PANE_INDEX.get(name)
        if not session or not pane_idx:
            return None
        return f"{session}:{pane_idx}"

    def _infer_task(
        self, name: str, last_lines: Optional[List[str]]
    ) -> Optional[str]:
        """A-1 prompt > A-3 로그 > A-2 last_known_task (F-X-7-#5 + R-2 정정).

        Stage 10 M-2 fix — pre-fetched lines 인입 (subprocess 0건). batch에서 가져온
        100줄 영역에서 마지막 50줄 effective window 활용.
        """
        if last_lines is None:
            last_lines = []
        # 마지막 50줄 effective window (기존 capture_pane(lines=50) 정합).
        scan_lines = last_lines[-50:] if len(last_lines) > 50 else last_lines

        # A-1: prompt 행 ">" 이후 텍스트 (5~80자).
        for line in reversed(scan_lines):
            m = re.search(r"^\s*>\s*(.{5,80})", line)
            if m:
                return self._normalize_task(m.group(1))

        # A-3: 로그 라인 — version / Stage / S\d.
        log_pat = re.compile(r"(v\d+\.\d+\.\d+\S*|Stage \d+|S\d+ \S+)")
        for line in reversed(scan_lines):
            m = log_pat.search(line)
            if m:
                return m.group(1).strip()

        # A-2: drafter R-2 정정 — last_known_task 직전 작업명 유지.
        prev = self._last_known_states.get(name)
        return prev.task if prev and prev.task else None

    @staticmethod
    def _normalize_task(text: str) -> str:
        """A-1 prompt 텍스트 → 80자 cap + 첫 줄만 (drafter 자율)."""
        cleaned = text.strip().split("\n", 1)[0]
        return cleaned[:80]
