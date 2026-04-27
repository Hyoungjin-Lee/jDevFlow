"""M3 — 페르소나 행 + 진행률 바 8칸 4단계 + 스파크라인 8칸 8단계 (boundary slot #3/#4).

design_final Sec.8.1 + Sec.13 boundary 본문:
- 박스 = ``Vertical`` Container, F-D1 PersonaState 직접 소비.
- 행 형식: 이름 + 상태(◉/○) + 작업명 + 토큰 + 진행률 바 + 스파크라인.
- 다중 버전 sub-row prefix ``└`` (F-M3-4), MAX_SUB_ROWS = 1 (drafter R-3).
- 빈 박스 옵션 A "(팀 대기 중)" (F-X-7-#6).
- 토큰 형식 ``%.1fk`` (F-M3-3).
"""
from __future__ import annotations

from typing import Dict, List

from textual.containers import Vertical
from textual.widgets import Static

from .models import PersonaState

# ---------------------------------------------------------------------------
# Boundary slot #3 — 진행률 바 8칸 4단계
# ---------------------------------------------------------------------------

# Stage 10d — idle placeholder cell ``░`` (LIGHT SHADE) 박음. 0% 시점에도 visual cell
# 보이게 정합 (운영자 정정 — 빈 공백 0칸 표시 영역 회피).
PROGRESS_LEVELS: tuple = ("░", "▒", "▓", "█")   # 4 단계 (idle placeholder / low / mid / full)
PROGRESS_CELLS: int = 8                         # 8 칸
PROGRESS_MAX_TOKEN_K: float = 80.0              # 0~80k 매핑 (cell 당 10k)


def progress_bar(tokens_k: float) -> str:
    """``tokens_k`` (0~PROGRESS_MAX_TOKEN_K) → 8칸 × 4단계 진행률 바.

    각 cell이 percent 구간 [i/N, (i+1)/N]에 해당하며 partial cell은 fraction에 따라
    low (1) / mid (2) / full (3)로 매핑됩니다.

    Stage 10d — idle (0%) cell = ``░`` placeholder. 운영자 정정 — 0% 시점에도 빈 cell
    보이게 정합. tokens_k=0.0이면 8칸 모두 ``░░░░░░░░`` 표시.
    """
    pct = max(0.0, min(tokens_k / PROGRESS_MAX_TOKEN_K, 1.0))
    cells: List[str] = []
    for i in range(PROGRESS_CELLS):
        cell_start = i / PROGRESS_CELLS
        cell_end = (i + 1) / PROGRESS_CELLS
        if pct <= cell_start:
            cells.append(PROGRESS_LEVELS[0])
            continue
        if pct >= cell_end:
            cells.append(PROGRESS_LEVELS[3])
            continue
        fraction = (pct - cell_start) / (cell_end - cell_start)
        cells.append(PROGRESS_LEVELS[1] if fraction < 0.5 else PROGRESS_LEVELS[2])
    return "".join(cells)


# ---------------------------------------------------------------------------
# Boundary slot #4 — 스파크라인 8칸 8단계
# ---------------------------------------------------------------------------

# U+2581 ~ U+2588 (▁▂▃▄▅▆▇█) 표준 sparkline.
SPARK_LEVELS: str = "".join(chr(0x2581 + i) for i in range(8))
SPARK_CELLS: int = 8


def sparkline(history: List[float]) -> str:
    """``tokens_k`` 시계열 → 8칸 × 8단계 스파크라인.

    8개 미만이면 좌측 0 padding (오래된 값 좌측). 빈 list → ``▁`` 반복.
    """
    if not history:
        return SPARK_LEVELS[0] * SPARK_CELLS
    recent = list(history[-SPARK_CELLS:])
    padded = [0.0] * (SPARK_CELLS - len(recent)) + recent
    peak = max(padded) or 1.0
    out: List[str] = []
    for v in padded:
        idx = int((v / peak) * (len(SPARK_LEVELS) - 1))
        idx = max(0, min(idx, len(SPARK_LEVELS) - 1))
        out.append(SPARK_LEVELS[idx])
    return "".join(out)


# ---------------------------------------------------------------------------
# 박스 + 행 렌더링 (boundary slot #2 흡수 — CSS DEFAULT_CSS + dashboard.tcss)
# ---------------------------------------------------------------------------

EMPTY_BOX_LABEL: str = "(팀 대기 중)"  # F-X-7-#6 옵션 A
SUB_ROW_PREFIX: str = "└"               # F-M3-4
TOKEN_FORMAT: str = "tokens: {:.1f}k"   # F-M3-3
MAX_SUB_ROWS: int = 1                   # drafter R-3 채택


class TeamRenderer(Vertical):
    """M3 — 단일 팀 박스 (F-D1 PersonaState 직접 소비).

    DEFAULT_CSS는 ``dashboard.tcss``의 ``TeamRenderer`` 룰과 cascade — boundary slot
    #1 색상 11종 + #2 margin·padding·border round 흡수 영역.
    """

    DEFAULT_CSS = """
    TeamRenderer {
        border: round $primary;
        padding: 0 1;
        margin: 0 1;
        width: 1fr;
        height: 1fr;
    }
    """

    def __init__(self, team: str, **kwargs) -> None:
        super().__init__(**kwargs)
        self.team = team
        self._title = Static(f"╔══ {team}팀 ══╗", classes="team-title")
        self._content = Static("", classes="team-content")

    def on_mount(self) -> None:
        self.mount(self._title, self._content)

    def update_data(self, personas: List[PersonaState]) -> None:
        self._content.update(self._compose_text(personas))

    def _compose_text(self, personas: List[PersonaState]) -> str:
        if not personas:
            return f"║ {EMPTY_BOX_LABEL}"
        grouped = self._group_by_name(personas)
        lines: List[str] = []
        for name, states in grouped.items():
            lines.extend(self._render_persona_lines(name, states))
        return "\n".join(lines)

    @staticmethod
    def _group_by_name(personas: List[PersonaState]) -> Dict[str, List[PersonaState]]:
        out: Dict[str, List[PersonaState]] = {}
        for p in personas:
            out.setdefault(p.name, []).append(p)
        return out

    @staticmethod
    def _render_persona_lines(name: str, states: List[PersonaState]) -> List[str]:
        first = states[0]
        sym = "◉ working" if first.status == "working" else "○ idle"
        lines = [f"║ {name} [{sym}]"]
        if first.task:
            lines.append(f"║   {first.task}")
        lines.append(f"║   {TOKEN_FORMAT.format(first.tokens_k)}")
        lines.append(f"║   {progress_bar(first.tokens_k)}")

        # MAX_SUB_ROWS = 1 — 다중 버전 sub-row.
        truncated = states[1:1 + MAX_SUB_ROWS]
        overflow = max(0, len(states) - 1 - len(truncated))
        for sub in truncated:
            sub_task = sub.task or "(idle)"
            lines.append(f"║ {SUB_ROW_PREFIX} {sub_task}")
            lines.append(f"║   {TOKEN_FORMAT.format(sub.tokens_k)}")
        if overflow > 0:
            lines.append(f"║   ... 외 {overflow}개 버전")
        lines.append("║")  # 사람 간 구분 공백
        return lines
