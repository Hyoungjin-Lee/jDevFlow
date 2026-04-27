"""F-D1 본문 결정 — ``PersonaState`` dataclass 단일 spec (design_final Sec.3.1).

본 M2 drafter v1은 ``PersonaState``만 본문 박음. ``PendingPush`` / ``PendingQuestion``은
M4 drafter 영역(SRP 분리, design_final Sec.3.2). models.py는 횡단 단일 source라 M4
drafter가 본 파일에 두 dataclass를 추가합니다 (drafter v1 자율 권한 밖).
"""
from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime
from typing import Literal, Optional

PersonaStatus = Literal["working", "idle"]
"""Q5 idle 통합 confirm — tmux 세션 미존재 = idle. offline 분리 옵션 0건 (F-M2-5 흡수)."""

PersonaTeam = Literal["기획", "디자인", "개발"]
"""F-D3 박스 3개와 1:1 매핑. 영문 변환 어댑터는 M3 ``team_renderer.py`` 내부 격리."""


@dataclass(eq=True, frozen=False)
class PersonaState:
    """페르소나 실시간 상태 — F-D1 본문 결정, M2/M3/M4 횡단 단일 spec.

    필드 6종 (design_final Sec.3.1 verbatim):

    - ``name`` — 정규 페르소나명 (operating_manual.md Sec.1.2 18명 정의 그대로).
    - ``team`` — "기획" / "디자인" / "개발" (F-D3 박스 1:1).
    - ``status`` — "working" / "idle" 2단계. Q5 idle 통합 — offline = idle.
    - ``task`` — working일 때만 채워짐. idle 시 ``None`` (Optional).
    - ``tokens_k`` — float, k 단위 누적 (input + output) — Q2 정확 hook 인입.
    - ``last_update`` — datetime. **idle 폴백 시 이전 값 보존(R-1 정정)** —
      staleness ⚠ 표시(``last_update`` > 2초 → ⚠)가 정상 작동.

    ``frozen=False`` + ``eq=True`` — 단위 테스트 expected vs actual 비교 가능.
    set 멤버십 0건 (대신 ``name`` 기반 dict 키, design_final Sec.3.3).
    """

    name: str
    team: PersonaTeam
    status: PersonaStatus
    task: Optional[str]
    tokens_k: float
    last_update: datetime

    def to_json(self) -> dict:
        """직렬화 — ``dataclasses.asdict()`` + ``datetime.isoformat()`` 변환.

        Stage 8 테스트 fixture / M3 위젯 갱신 trace dump에 사용.
        """
        d = asdict(self)
        d["last_update"] = self.last_update.isoformat()
        return d
