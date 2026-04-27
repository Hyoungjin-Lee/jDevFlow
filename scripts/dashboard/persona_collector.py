"""M2 — ``PersonaDataCollector`` sync polling (F-D1 + F-D4 + Q5 idle 통합).

JSONL 기반 상태 판단 (터미널 닫힘 무관):
- status: JSONL 마지막 엔트리 type==user → working / type==assistant → idle
- task: 마지막 user str-content (dispatch 프롬프트 첫 80자)
- tokens_k: 마지막 assistant.message.usage 기준

tmux capture-pane 의존 완전 제거. tmux는 세션 존재 여부 확인에만 사용.
"""
from __future__ import annotations

from datetime import datetime
from typing import Dict, List, Optional, Set, Tuple

from .models import PersonaState
from .tmux_adapter import TmuxAdapter
from .token_hook import TokenHook


# F-D3 산식 — dashboard 가시화 박스 17 = 4팀 15 + PM 1 + CTO 1. CEO(이형진)는 운영자이므로 제외.
# HR만 미표시. CTO/CEO는 정적 idle 박스 (tokens / 진행률 / 시그널 추적 0건).
# operating_manual.md Sec.1.2 정규명 그대로.
PERSONAS_18: List[Tuple[str, str]] = [
    # 기획팀 4
    ("박지영", "기획"), ("김민교", "기획"), ("안영이", "기획"), ("장그래", "기획"),
    # 디자인팀 4
    ("우상호", "디자인"), ("이수지", "디자인"), ("오해원", "디자인"), ("장원영", "디자인"),
    # 개발팀 7
    ("공기성", "개발"), ("최우영", "개발"), ("현봉식", "개발"), ("카더가든", "개발"),
    ("백강혁", "개발"), ("김원훈", "개발"), ("지예은", "개발"),
    # 관리자 2 — PM bridge-064 트래킹 / CTO 정적 idle. CEO(이형진)는 운영자이므로 제외.
    ("스티브 리", "관리자"), ("백현진", "관리자"),
]


# 팀 → tmux 세션명. Stage 10d — "관리자" team에 PM(스티브 리) bridge-064 매핑.
# CTO/CEO는 본 매핑에 없음 → _persona_to_pane이 None 반환 → idle yield (Q5 통합).
_TEAM_TO_ORC_SESSION: Dict[str, str] = {
    "기획": "Orc-064-plan",
    "디자인": "Orc-064-design",
    "개발": "Orc-064-dev",
    "관리자": "bridge-064",
}


# 페르소나 → pane index. design_final Sec.4 헌법 (왼쪽=PL / 오른쪽 stack=드래프터/리뷰어/파이널)
# 정합. 개발팀 BE 트리오 (1.x) + FE 트리오 (2.x, M5 진입 시 별도 pane 영역) 잠정 분리.
# Stage 10d — PM(스티브 리) → bridge-064:1.1 매핑 추가. CTO 백현진 / CEO 이형진은
# _persona_to_pane None 반환 영역 (정적 idle).
_PERSONA_TO_PANE_INDEX: Dict[str, str] = {
    # 기획팀
    "박지영": "1.1", "장그래": "1.2", "김민교": "1.3", "안영이": "1.4",
    # 디자인팀
    "우상호": "1.1", "장원영": "1.2", "이수지": "1.3", "오해원": "1.4",
    # 개발팀 BE 트리오
    "공기성": "1.1", "카더가든": "1.2", "최우영": "1.3", "현봉식": "1.4",
    # 개발팀 FE 트리오 — Orc-064-dev window 2 (2.1/2.2/2.3).
    "백강혁": "2.1", "지예은": "2.2", "김원훈": "2.3",
    # 관리자 PM (Stage 10d) — bridge-064:1.1
    "스티브 리": "1.1",
    # CTO/CEO 미매핑 — _persona_to_pane None → idle yield 정합
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
        """17명 모든 페르소나 상태 — tmux 미존재도 idle yield (Q5 통합).

        subprocess 호출: list_sessions 1회만. capture-pane 0건.
        상태/작업명/토큰 모두 JSONL 파일에서 직접 읽음 (터미널 상태 무관).
        """
        active_sessions: Set[str] = set(self.tmux.list_sessions())

        out: List[PersonaState] = []
        for name, team in PERSONAS_18:
            state = self._infer_state(name, team, active_sessions)
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
    ) -> PersonaState:
        """JSONL 기반 상태 판단 — 터미널 상태 무관.

        tmux 세션 미존재 → idle (Q5). 세션 존재 시 JSONL 파일에서
        status/task/tokens_k/last_update 모두 읽음.
        """
        pane_name = self._persona_to_pane(name, team)
        session = pane_name.split(":")[0] if pane_name and ":" in pane_name else None

        if not pane_name or session not in active_sessions:
            prev = self._last_known_states.get(name)
            last_update = prev.last_update if prev else datetime.fromtimestamp(0)
            return PersonaState(
                name=name, team=team, status="idle", task=None,
                tokens_k=0.0, last_update=last_update,
            )

        state = self.token_hook.get_pane_state(pane_name)

        if state["last_update"] is None:
            prev = self._last_known_states.get(name)
            last_update = prev.last_update if prev else datetime.fromtimestamp(0)
        else:
            last_update = state["last_update"]

        return PersonaState(
            name=name,
            team=team,
            status=state["status"],
            task=state["task"],
            tokens_k=state["tokens_k"],
            last_update=last_update,
        )

    def _persona_to_pane(self, name: str, team: str) -> Optional[str]:
        session = _TEAM_TO_ORC_SESSION.get(team)
        pane_idx = _PERSONA_TO_PANE_INDEX.get(name)
        if not session or not pane_idx:
            return None
        return f"{session}:{pane_idx}"
