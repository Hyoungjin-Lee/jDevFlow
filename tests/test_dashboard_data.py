"""M2 데이터 layer 검증 — F-D1 / F-D4 / F-X-2 / Q2 / Q5 / R-1 / R-2 헌법.

검증 영역:
- ``PersonaState`` 6 필드 + 직렬화 (F-D1).
- ``PersonaDataCollector`` Q5 idle 통합 + R-1 last_update 보존 + working 추론.
- ``TmuxAdapter`` sync 인터페이스 + capture-pane 변화 감지 + 미가동 폴백.
- ``TokenHook`` JSON 인입 + R-10 namespace prefix + regex fallback (Q2 정확 hook).
- F-D4 sync def 강제 (M2 모듈 ``async def`` 0건).
- F-D1 SRP 강제 (``PendingDataCollector`` M4 영역 침범 0건).
- F-X-2 read-only (write 명령 0건).

실행: ``venv/bin/python3 -m pytest tests/test_dashboard_data.py -v``
"""
from __future__ import annotations

import ast
import dataclasses
import json
import re
import sys
import unittest.mock as mock
from datetime import datetime
from pathlib import Path

import pytest

PROJECT_ROOT = Path(__file__).resolve().parent.parent
PACKAGE_DIR = PROJECT_ROOT / "scripts" / "dashboard"

# scripts.* 네임스페이스 패키지 진입 (PEP 420) — scripts/__init__.py 미존재 환경 정합.
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))


M2_MODULES = ("models.py", "persona_collector.py", "tmux_adapter.py", "token_hook.py")


# ---------------------------------------------------------------------------
# AST 검증 — F-D4 sync def + F-D1 SRP + F-X-2 read-only (textual / tmux 의존 없음)
# ---------------------------------------------------------------------------


def _ast_of(module_name: str) -> ast.Module:
    src = (PACKAGE_DIR / module_name).read_text(encoding="utf-8")
    return ast.parse(src, filename=module_name)


@pytest.mark.parametrize("module_name", M2_MODULES)
def test_no_async_def_in_m2(module_name: str) -> None:
    """F-D4 본문 결정 — M2 모듈 sync ``def`` 전면. ``async def`` 0건 (R-3 정합)."""
    tree = _ast_of(module_name)
    asyncs = [
        n.name for n in ast.walk(tree) if isinstance(n, ast.AsyncFunctionDef)
    ]
    assert not asyncs, f"F-D4 위반 ({module_name}): async def {asyncs}"


def test_persona_collector_no_pending_class() -> None:
    """F-D1 SRP — ``persona_collector.py``에 ``PendingDataCollector`` 박지 X (M4 영역)."""
    tree = _ast_of("persona_collector.py")
    classes = [n.name for n in ast.walk(tree) if isinstance(n, ast.ClassDef)]
    assert "PendingDataCollector" not in classes, (
        "F-D1 SRP 위반 — PersonaDataCollector 모듈에 PendingDataCollector 박힘 (M4 영역)"
    )


def test_persona_state_in_models() -> None:
    """F-D1 — ``models.py``에 ``PersonaState`` 본문 박힘."""
    tree = _ast_of("models.py")
    classes = [n.name for n in ast.walk(tree) if isinstance(n, ast.ClassDef)]
    assert "PersonaState" in classes, "PersonaState 누락 (F-D1 단일 spec)"


def test_token_hook_no_subprocess_import() -> None:
    """AC-T-4 = 2 (R-5 정정) — ``token_hook.py``에 ``import subprocess`` 0건."""
    src = (PACKAGE_DIR / "token_hook.py").read_text(encoding="utf-8")
    assert "import subprocess" not in src, (
        "AC-T-4 위반 — token_hook.py에 subprocess 직접 import. TmuxAdapter 위임 강제."
    )


def test_tmux_adapter_has_subprocess() -> None:
    """모듈 경계 #4 — ``tmux_adapter.py``는 subprocess 격리 1/2 모듈."""
    src = (PACKAGE_DIR / "tmux_adapter.py").read_text(encoding="utf-8")
    assert "import subprocess" in src or "from subprocess" in src, (
        "tmux_adapter.py에 subprocess import 누락 — 격리 layer 책임 위반"
    )


@pytest.mark.parametrize("module_name", M2_MODULES)
def test_no_write_commands(module_name: str) -> None:
    """F-X-2 read-only — write 명령 0건 (AC-M2-9)."""
    src = (PACKAGE_DIR / module_name).read_text(encoding="utf-8")
    pattern = re.compile(r"open\([^)]*['\"]w['\"]|git\s+push|git\s+commit")
    assert not pattern.findall(src), f"F-X-2 위반 ({module_name})"


# ---------------------------------------------------------------------------
# PersonaState dataclass — F-D1 6 필드 + 직렬화
# ---------------------------------------------------------------------------


def test_persona_state_six_fields() -> None:
    from scripts.dashboard.models import PersonaState

    fields = {f.name for f in dataclasses.fields(PersonaState)}
    expected = {"name", "team", "status", "task", "tokens_k", "last_update"}
    assert fields == expected, f"F-D1 필드 위반: {fields} ≠ {expected}"


def test_persona_state_eq_true_frozen_false() -> None:
    """``frozen=False`` + ``eq=True`` (Sec.3.3 정합)."""
    from scripts.dashboard.models import PersonaState

    now = datetime(2026, 4, 27, 12, 0, 0)
    a = PersonaState(name="박지영", team="기획", status="working",
                     task="dispatch", tokens_k=12.3, last_update=now)
    b = PersonaState(name="박지영", team="기획", status="working",
                     task="dispatch", tokens_k=12.3, last_update=now)
    assert a == b, "eq=True 위반"
    a.tokens_k = 99.9
    assert a.tokens_k == 99.9, "frozen=False 위반"


def test_persona_state_to_json_serializable() -> None:
    """``to_json()`` = ``asdict()`` + ``datetime.isoformat()`` — JSON dump 가능."""
    from scripts.dashboard.models import PersonaState

    now = datetime(2026, 4, 27, 12, 0, 0)
    s = PersonaState(name="박지영", team="기획", status="idle", task=None,
                     tokens_k=0.0, last_update=now)
    payload = s.to_json()
    assert payload["name"] == "박지영"
    assert payload["status"] == "idle"
    assert payload["task"] is None
    assert payload["last_update"] == "2026-04-27T12:00:00"
    json.dumps(payload)  # 직렬화 가능성 확인


# ---------------------------------------------------------------------------
# TmuxAdapter — sync 호출, 미가동 폴백, signature 변화 감지
# ---------------------------------------------------------------------------


def test_tmux_adapter_no_tmux_returns_empty() -> None:
    """tmux 미설치 = ``FileNotFoundError`` → 빈 list (Q5 idle 통합 폴백)."""
    from scripts.dashboard.tmux_adapter import TmuxAdapter

    with mock.patch(
        "scripts.dashboard.tmux_adapter.subprocess.run",
        side_effect=FileNotFoundError,
    ):
        assert TmuxAdapter().list_sessions() == []


def test_tmux_adapter_no_active_sessions() -> None:
    """tmux 가동 + 세션 0개 → 빈 list."""
    from scripts.dashboard.tmux_adapter import TmuxAdapter

    fake = mock.Mock(returncode=1, stdout="", stderr="no server running")
    with mock.patch(
        "scripts.dashboard.tmux_adapter.subprocess.run", return_value=fake
    ):
        assert TmuxAdapter().list_sessions() == []


def test_tmux_adapter_parses_session_names() -> None:
    """세션명 줄별 파싱 + strip + 빈 줄 제외."""
    from scripts.dashboard.tmux_adapter import TmuxAdapter

    fake = mock.Mock(
        returncode=0, stdout="bridge-064\nOrc-064-dev\n  \n", stderr=""
    )
    with mock.patch(
        "scripts.dashboard.tmux_adapter.subprocess.run", return_value=fake
    ):
        assert TmuxAdapter().list_sessions() == ["bridge-064", "Orc-064-dev"]


def test_tmux_adapter_capture_pane_signature_change() -> None:
    """capture-pane 부수효과 — 출력 변화 시 ``last_pane_change`` 갱신."""
    from scripts.dashboard.tmux_adapter import TmuxAdapter

    ta = TmuxAdapter()
    initial = ta.last_pane_change("X:0.0")
    assert initial == datetime.fromtimestamp(0), "미관측 pane = epoch (R-1 staleness)"

    fake1 = mock.Mock(returncode=0, stdout="line A\nline B\n", stderr="")
    with mock.patch(
        "scripts.dashboard.tmux_adapter.subprocess.run", return_value=fake1
    ):
        ta.capture_pane("X:0.0", lines=10)
    after_first = ta.last_pane_change("X:0.0")
    assert after_first > initial, "최초 capture 시 갱신 안 됨"

    # 같은 출력 → signature 동일 → 변화 없음
    with mock.patch(
        "scripts.dashboard.tmux_adapter.subprocess.run", return_value=fake1
    ):
        ta.capture_pane("X:0.0", lines=10)
    assert ta.last_pane_change("X:0.0") == after_first, "동일 signature인데 갱신됨"

    # 다른 출력 → 갱신
    fake2 = mock.Mock(
        returncode=0, stdout="line A\nline B\nline C\n", stderr=""
    )
    with mock.patch(
        "scripts.dashboard.tmux_adapter.subprocess.run", return_value=fake2
    ):
        ta.capture_pane("X:0.0", lines=10)
    assert ta.last_pane_change("X:0.0") > after_first, "출력 변화 감지 안 됨"


# ---------------------------------------------------------------------------
# TokenHook — Q2 정확 hook + R-10 namespace prefix + regex fallback
# ---------------------------------------------------------------------------


def test_token_hook_namespace_prefix(tmp_path: Path) -> None:
    """R-10 — namespace prefix = ``sha1(project_root)[:8]`` 8자."""
    from scripts.dashboard.token_hook import TokenHook

    assert len(TokenHook(project_root=tmp_path)._project_hash) == 8


def test_token_hook_reads_json_first(tmp_path: Path) -> None:
    """1순위 — ``.claude/dashboard_state/joneflow_<hash>_<session>.json`` 인입."""
    from scripts.dashboard.token_hook import TokenHook

    th = TokenHook(project_root=tmp_path)
    hook_dir = tmp_path / ".claude" / "dashboard_state"
    hook_dir.mkdir(parents=True)
    (hook_dir / f"joneflow_{th._project_hash}_bridge-064.json").write_text(
        json.dumps({"input_tokens": 12000, "output_tokens": 3500})
    )
    assert th.get_tokens_k("bridge-064:0.0") == pytest.approx(15.5)


def test_token_hook_falls_back_to_regex(tmp_path: Path) -> None:
    """2순위 — JSON 미존재 → capture-pane regex (TmuxAdapter 위임)."""
    from scripts.dashboard.token_hook import TokenHook

    fake_tmux = mock.Mock()
    fake_tmux.capture_pane.return_value = [
        "log",
        '{"usage": {"input_tokens": 5000, "output_tokens": 2500}}',
    ]
    th = TokenHook(tmux=fake_tmux, project_root=tmp_path)
    assert th.get_tokens_k("bridge-064:0.0") == pytest.approx(7.5)
    fake_tmux.capture_pane.assert_called_once()


def test_token_hook_zero_on_corrupt_and_no_capture(tmp_path: Path) -> None:
    """JSON 파싱 실패 + capture-pane 빈 → 3순위 0.0 (Sec.14 에러 경로)."""
    from scripts.dashboard.token_hook import TokenHook

    th = TokenHook(project_root=tmp_path)
    hook_dir = tmp_path / ".claude" / "dashboard_state"
    hook_dir.mkdir(parents=True)
    (hook_dir / f"joneflow_{th._project_hash}_bridge-064.json").write_text("not json {")
    fake_tmux = mock.Mock()
    fake_tmux.capture_pane.return_value = []
    th.tmux = fake_tmux
    assert th.get_tokens_k("bridge-064:0.0") == 0.0


# ---------------------------------------------------------------------------
# PersonaDataCollector — Q5 idle 통합 + R-1 보존 + working 추론
# ---------------------------------------------------------------------------


def test_personas_18_count_and_teams() -> None:
    """F-X-6 — PERSONAS_18은 4팀 15명 (PM/CTO/CEO M5 영역)."""
    from scripts.dashboard.persona_collector import PERSONAS_18

    assert len(PERSONAS_18) == 15
    teams = {t for _, t in PERSONAS_18}
    assert teams == {"기획", "디자인", "개발"}
    counts = {team: sum(1 for _, t in PERSONAS_18 if t == team) for team in teams}
    assert counts == {"기획": 4, "디자인": 4, "개발": 7}


def test_collector_q5_all_idle_when_no_sessions() -> None:
    """Q5 — tmux 세션 0개 = 모두 idle (offline 분리 옵션 0건)."""
    from scripts.dashboard.persona_collector import PersonaDataCollector

    fake_tmux = mock.Mock()
    fake_tmux.list_sessions.return_value = []
    pc = PersonaDataCollector(tmux=fake_tmux, token_hook=mock.Mock())
    states = pc.fetch_all_personas()
    assert len(states) == 15
    assert all(s.status == "idle" for s in states), "Q5 idle 통합 위반"
    assert all(s.task is None for s in states)
    assert all(s.tokens_k == 0.0 for s in states)


def test_collector_r1_idle_preserves_epoch_initially() -> None:
    """R-1 — 첫 폴링 idle 시 ``last_update`` = epoch 0 → staleness 자연 발동."""
    from scripts.dashboard.persona_collector import PersonaDataCollector

    fake_tmux = mock.Mock()
    fake_tmux.list_sessions.return_value = []
    pc = PersonaDataCollector(tmux=fake_tmux, token_hook=mock.Mock())
    first = pc.fetch_all_personas()
    epoch = datetime.fromtimestamp(0)
    assert all(s.last_update == epoch for s in first)


def test_collector_working_when_session_active() -> None:
    """Orc 세션 활성 + last_pane_change 최근 → status=working + task 추론."""
    from scripts.dashboard.persona_collector import PersonaDataCollector

    now = datetime.now()
    fake_tmux = mock.Mock()
    fake_tmux.list_sessions.return_value = ["Orc-064-plan"]
    fake_tmux.last_pane_change.return_value = now
    fake_tmux.capture_pane.return_value = [
        "log",
        "> v0.6.4 Stage 8 M2 작업 중",
    ]
    fake_token = mock.Mock()
    fake_token.get_tokens_k.return_value = 12.5

    pc = PersonaDataCollector(tmux=fake_tmux, token_hook=fake_token)
    state = pc.persona_by_name("박지영")
    assert state is not None
    assert state.status == "working"
    assert state.tokens_k == pytest.approx(12.5)
    assert state.task is not None
    assert "v0.6.4" in state.task


def test_collector_idle_when_pane_stale_preserves_change_ts() -> None:
    """elapsed > 10초 → idle, ``last_update`` = ``last_pane_change`` 보존 (R-1)."""
    from scripts.dashboard.persona_collector import PersonaDataCollector

    stale = datetime.fromtimestamp(datetime.now().timestamp() - 60)
    fake_tmux = mock.Mock()
    fake_tmux.list_sessions.return_value = ["Orc-064-plan"]
    fake_tmux.last_pane_change.return_value = stale
    fake_tmux.capture_pane.return_value = []
    fake_token = mock.Mock()
    fake_token.get_tokens_k.return_value = 5.0

    pc = PersonaDataCollector(tmux=fake_tmux, token_hook=fake_token)
    state = pc.persona_by_name("박지영")
    assert state is not None
    assert state.status == "idle"
    assert state.last_update == stale, "R-1 last_update 보존 위반"
    assert state.tokens_k == pytest.approx(5.0)


def test_collector_fetch_team_filter() -> None:
    """``fetch_team`` — 팀 필터 정확성."""
    from scripts.dashboard.persona_collector import PersonaDataCollector

    fake_tmux = mock.Mock()
    fake_tmux.list_sessions.return_value = []
    pc = PersonaDataCollector(tmux=fake_tmux, token_hook=mock.Mock())
    plan = pc.fetch_team("기획")
    assert len(plan) == 4
    assert all(s.team == "기획" for s in plan)
    dev = pc.fetch_team("개발")
    assert len(dev) == 7
    assert all(s.team == "개발" for s in dev)


def test_collector_r2_last_known_task_fallback() -> None:
    """R-2 — A-2 prompt+로그 미발견 시 ``last_known_task`` 직전 작업명 유지."""
    from scripts.dashboard.persona_collector import PersonaDataCollector
    from scripts.dashboard.models import PersonaState

    now = datetime.now()
    fake_tmux = mock.Mock()
    fake_tmux.list_sessions.return_value = ["Orc-064-plan"]
    fake_tmux.last_pane_change.return_value = now
    # capture_pane = 빈 list → A-1 / A-3 모두 미발견 → A-2 fallback
    fake_tmux.capture_pane.return_value = []
    fake_token = mock.Mock()
    fake_token.get_tokens_k.return_value = 0.0

    pc = PersonaDataCollector(tmux=fake_tmux, token_hook=fake_token)
    # last_known_task 사전 주입
    pc._last_known_states["박지영"] = PersonaState(
        name="박지영", team="기획", status="working",
        task="이전 작업명", tokens_k=0.0, last_update=now,
    )
    state = pc.persona_by_name("박지영")
    assert state is not None
    assert state.status == "working"
    assert state.task == "이전 작업명", "R-2 last_known_task fallback 위반"
