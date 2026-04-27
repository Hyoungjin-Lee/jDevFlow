"""M5 — 19명 페르소나 매핑 + 미표시 placeholder 3종 + 페르소나↔pane 매핑 detail.

F-D3 19명 산식 (design_final Sec.11.1):
- 박스 16 = 4팀 15 (기획 4 + 디자인 4 + 개발 7) + PM 스티브 리 1 (status bar 별도).
- 미표시 placeholder 3 = CTO 백현진 / CEO 이형진 / HR (TBD).
- 합계 19.

operating_manual.md Sec.1.2 정규명 그대로. F-X-6 매핑 detail = personas_18.md
v0.6.4 Sec.8.4 verbatim sync (M5 진입 게이트 통과 본문 박힘).
"""
from __future__ import annotations

from typing import Dict, List, Optional, TypedDict


class PersonaInfo(TypedDict):
    name: str
    role: str
    team: Optional[str]
    displayed: str  # "box" / "status_bar" / "hidden"


# 4팀 15명 — 박스 영역 (M2 ``PERSONAS_18`` 리스트와 sync).
TEAM_PERSONAS: List[PersonaInfo] = [
    # 기획팀 4
    {"name": "박지영", "role": "기획PL", "team": "기획", "displayed": "box"},
    {"name": "김민교", "role": "기획리뷰", "team": "기획", "displayed": "box"},
    {"name": "안영이", "role": "기획파이널", "team": "기획", "displayed": "box"},
    {"name": "장그래", "role": "기획드래프터", "team": "기획", "displayed": "box"},
    # 디자인팀 4
    {"name": "우상호", "role": "디자인PL", "team": "디자인", "displayed": "box"},
    {"name": "이수지", "role": "디자인리뷰", "team": "디자인", "displayed": "box"},
    {"name": "오해원", "role": "디자인파이널", "team": "디자인", "displayed": "box"},
    {"name": "장원영", "role": "디자인드래프터", "team": "디자인", "displayed": "box"},
    # 개발팀 7 (BE 트리오 + FE 트리오 + PL)
    {"name": "공기성", "role": "개발PL", "team": "개발", "displayed": "box"},
    {"name": "최우영", "role": "BE리뷰", "team": "개발", "displayed": "box"},
    {"name": "현봉식", "role": "BE파이널", "team": "개발", "displayed": "box"},
    {"name": "카더가든", "role": "BE드래프터", "team": "개발", "displayed": "box"},
    {"name": "백강혁", "role": "FE리뷰", "team": "개발", "displayed": "box"},
    {"name": "김원훈", "role": "FE파이널", "team": "개발", "displayed": "box"},
    {"name": "지예은", "role": "FE드래프터", "team": "개발", "displayed": "box"},
]

# PM (status bar 별도 1행, boundary slot #6).
PM_PERSONA: PersonaInfo = {
    "name": "스티브 리", "role": "PM", "team": None, "displayed": "status_bar",
}

# 미표시 placeholder 3종 (boundary slot #5 — CTO·CEO·HR 자리만 예약, v0.6.4 미가동).
HIDDEN_PLACEHOLDERS: List[PersonaInfo] = [
    {"name": "백현진", "role": "CTO", "team": None, "displayed": "hidden"},
    {"name": "이형진", "role": "CEO", "team": None, "displayed": "hidden"},
    {"name": "(HR TBD)", "role": "HR", "team": None, "displayed": "hidden"},
]


def all_personas() -> List[PersonaInfo]:
    """F-D3 19명 합계 = 박스 15 + PM 1 + 미표시 3."""
    return TEAM_PERSONAS + [PM_PERSONA] + HIDDEN_PLACEHOLDERS


def by_team(team: str) -> List[PersonaInfo]:
    return [p for p in TEAM_PERSONAS if p["team"] == team]


def displayed_count() -> int:
    """박스 15 + PM 1 = 16 (status_bar 포함)."""
    return sum(1 for p in all_personas() if p["displayed"] != "hidden")


def hidden_count() -> int:
    """미표시 placeholder 3 (boundary slot #5)."""
    return len(HIDDEN_PLACEHOLDERS)


# ---------------------------------------------------------------------------
# F-X-6 매핑 detail — 페르소나 ↔ tmux pane (personas_18.md v0.6.4 Sec.8.4 verbatim)
# R-N reviewer 검증 (M5 PASS_WITH_PATCH) — F-X-6 blocking 해소 + Orc-064-* 정합.
# ---------------------------------------------------------------------------


PERSONA_TO_PANE: Dict[str, str] = {
    # 기획팀 (Orc-064-plan, 4 panes 헌법)
    "박지영": "Orc-064-plan:1.1",
    "장그래": "Orc-064-plan:1.2",
    "김민교": "Orc-064-plan:1.3",
    "안영이": "Orc-064-plan:1.4",
    # 디자인팀 (Orc-064-design, 4 panes 헌법)
    "우상호": "Orc-064-design:1.1",
    "장원영": "Orc-064-design:1.2",
    "이수지": "Orc-064-design:1.3",
    "오해원": "Orc-064-design:1.4",
    # 개발팀 BE 트리오 (Orc-064-dev:1.x, 4 panes 헌법)
    "공기성": "Orc-064-dev:1.1",
    "카더가든": "Orc-064-dev:1.2",
    "최우영": "Orc-064-dev:1.3",
    "현봉식": "Orc-064-dev:1.4",
    # 개발팀 FE 트리오 (Orc-064-dev:2.x — M5 detail)
    "지예은": "Orc-064-dev:2.2",
    "백강혁": "Orc-064-dev:2.3",
    "김원훈": "Orc-064-dev:2.4",
    # PM (bridge-064 status bar 별도 1행)
    "스티브 리": "bridge-064:1.1",
}


def pane_for(name: str) -> Optional[str]:
    """페르소나명 → tmux pane id. 미매핑 = None (idle 폴백 정합)."""
    return PERSONA_TO_PANE.get(name)


def by_displayed(displayed: str) -> List[PersonaInfo]:
    """displayed 영역(``box`` / ``status_bar`` / ``hidden``) 필터."""
    return [p for p in all_personas() if p["displayed"] == displayed]


def f_d3_count() -> Dict[str, int]:
    """F-D3 19명 산식 분해 — 박스 15 + PM 1 + 미표시 3 = 19."""
    return {
        "box": len(TEAM_PERSONAS),
        "status_bar": 1,
        "hidden": len(HIDDEN_PLACEHOLDERS),
        "total": len(all_personas()),
    }
