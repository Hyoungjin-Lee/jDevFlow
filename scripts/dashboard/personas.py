"""M5 — 19명 페르소나 매핑 + 미표시 placeholder 3종 (boundary slot #5, F-D3 산식).

F-D3 19명 산식 (design_final Sec.11.1):
- 박스 16 = 4팀 15 (기획 4 + 디자인 4 + 개발 7) + PM 스티브 리 1 (status bar 별도).
- 미표시 placeholder 3 = CTO 백현진 / CEO 이형진 / HR (TBD).
- 합계 19.

operating_manual.md Sec.1.2 정규명 그대로. F-X-6 매핑 detail은 본 stage 진입 영역
(personas_18.md 도착 시 갱신).
"""
from __future__ import annotations

from typing import List, Optional, TypedDict


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
