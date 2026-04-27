"""M4 검증 — Pending + R-11 dict+TTL dedupe + osascript + F-D1 SRP M4 + F-X-2.

R-11 Critical 검증:
- ``lru_cache`` 잔존 0건.
- ``_is_recently_sent`` dict + TTL 패턴.
- DEDUPE_TTL = 5분.
"""
from __future__ import annotations

import ast
import dataclasses
import re
import sys
import unittest.mock as mock
from datetime import datetime, timedelta
from pathlib import Path

import pytest

PROJECT_ROOT = Path(__file__).resolve().parent.parent
PACKAGE_DIR = PROJECT_ROOT / "scripts" / "dashboard"

if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

M4_MODULES = (
    "pending.py", "pending_collector.py", "pending_widgets.py", "notifier.py",
)


# ---------------------------------------------------------------------------
# 헌법 — F-D1 SRP / F-D4 sync / F-X-2 / R-11
# ---------------------------------------------------------------------------


@pytest.mark.parametrize("module_name", M4_MODULES)
def test_no_async_def(module_name: str) -> None:
    """F-D4 sync def 강제."""
    tree = ast.parse((PACKAGE_DIR / module_name).read_text(encoding="utf-8"))
    asyncs = [n.name for n in ast.walk(tree) if isinstance(n, ast.AsyncFunctionDef)]
    assert not asyncs, f"F-D4 위반 ({module_name}): {asyncs}"


@pytest.mark.parametrize("module_name", M4_MODULES)
def test_no_write_commands(module_name: str) -> None:
    """F-X-2 — write 명령 0건 (AC-M4-N9)."""
    src = (PACKAGE_DIR / module_name).read_text(encoding="utf-8")
    pattern = re.compile(r"open\([^)]*['\"]w['\"]|git\s+push\s|git\s+commit\s")
    assert not pattern.findall(src), f"F-X-2 위반 ({module_name})"


def test_pending_collector_no_persona_class() -> None:
    """F-D1 SRP M4 — pending_collector.py에 PersonaDataCollector 박지 X."""
    tree = ast.parse(
        (PACKAGE_DIR / "pending_collector.py").read_text(encoding="utf-8")
    )
    classes = [n.name for n in ast.walk(tree) if isinstance(n, ast.ClassDef)]
    assert "PersonaDataCollector" not in classes, "F-D1 SRP 위반 — M2 클래스 침범"


def test_notifier_no_lru_cache() -> None:
    """R-11 Critical — ``lru_cache`` 잔존 0건 (dedupe 영구 미작동 회피)."""
    src = (PACKAGE_DIR / "notifier.py").read_text(encoding="utf-8")
    assert "lru_cache" not in src, (
        "R-11 위반 — ``lru_cache`` 잔존. dict + TTL 비교 패턴으로 정정 필요."
    )
    assert "_is_recently_sent" in src, "R-11 — _is_recently_sent 메서드 누락"
    assert "DEDUPE_TTL" in src, "R-11 — DEDUPE_TTL 상수 누락"
    assert "timedelta(minutes=5)" in src, "R-11 — 5분 TTL 누락"


def test_notifier_no_pushover() -> None:
    """Q3 — Pushover 회피 (외부 API DEFCON 회피)."""
    src = (PACKAGE_DIR / "notifier.py").read_text(encoding="utf-8").lower()
    assert "pushover" not in src, "Q3 위반 — Pushover 채택"
    assert "osascript" in src, "Q3 — osascript 본문 누락"


# ---------------------------------------------------------------------------
# PendingPush / PendingQuestion dataclasses (F-D1 Sec.3.2)
# ---------------------------------------------------------------------------


def test_pending_push_six_fields() -> None:
    from scripts.dashboard.models import PendingPush
    fields = {f.name for f in dataclasses.fields(PendingPush)}
    expected = {"item_id", "item_type", "description",
                "timestamp", "initiator", "severity"}
    assert fields == expected


def test_pending_question_six_fields() -> None:
    from scripts.dashboard.models import PendingQuestion
    fields = {f.name for f in dataclasses.fields(PendingQuestion)}
    expected = {"q_id", "category", "description",
                "source", "timestamp", "priority"}
    assert fields == expected


def test_dedupe_key_5min_truncate() -> None:
    """R-4 — timestamp 5분 단위 truncate (Notifier 측 5분 TTL과 이중 보장)."""
    from scripts.dashboard.models import PendingQuestion
    base = datetime(2026, 4, 27, 12, 0, 0)
    common = dict(category="decision", description="x", source="d.md", priority="high")
    q1 = PendingQuestion(q_id="Q1", timestamp=base, **common)
    q2 = PendingQuestion(q_id="Q1", timestamp=base.replace(second=30), **common)
    q3 = PendingQuestion(q_id="Q1", timestamp=base.replace(minute=4), **common)
    q4 = PendingQuestion(q_id="Q1", timestamp=base.replace(minute=5), **common)
    # 0~4분 = 동일 5분 윈도우.
    assert q1.dedupe_key() == q2.dedupe_key() == q3.dedupe_key()
    # 5분 이후 = 별도 윈도우.
    assert q1.dedupe_key() != q4.dedupe_key()


# ---------------------------------------------------------------------------
# OSAScriptNotifier R-11 dict+TTL 거동
# ---------------------------------------------------------------------------


def test_osascript_dedupe_within_ttl() -> None:
    """R-11 — 5분 내 동일 dedupe_key 중복 발화 skip."""
    from scripts.dashboard.notifier import OSAScriptNotifier
    from scripts.dashboard.models import PendingQuestion

    n = OSAScriptNotifier()
    q = PendingQuestion(
        q_id="Q1", category="decision", description="x",
        source="d.md", timestamp=datetime(2026, 4, 27, 12, 0), priority="high",
    )
    with mock.patch(
        "scripts.dashboard.notifier.subprocess.run",
        return_value=mock.Mock(returncode=0),
    ) as run:
        first = n.notify(q)
        second = n.notify(q)
    assert first is True, "첫 발화 성공 위반"
    assert second is False, "5분 내 중복 발화 skip 위반"
    assert run.call_count == 1, f"subprocess 호출 {run.call_count} (1 기대)"


def test_osascript_dedupe_max_eviction() -> None:
    """LRU 동등 — DEDUPE_MAX 초과 시 가장 오래된 키 제거 (메모리 leak 회피)."""
    from scripts.dashboard.notifier import OSAScriptNotifier
    n = OSAScriptNotifier()
    n.DEDUPE_MAX = 3
    base = datetime(2026, 4, 27, 12, 0, 0)
    for i in range(5):
        n._sent_keys[f"k-{i}"] = base + timedelta(seconds=i)
    n._is_recently_sent("k-new")
    assert len(n._sent_keys) <= n.DEDUPE_MAX + 1


def test_osascript_sanitize_injection() -> None:
    """AppleScript injection 회피 — ``"`` / ``\\`` / ``\\n`` escape."""
    from scripts.dashboard.notifier import OSAScriptNotifier
    s = OSAScriptNotifier._sanitize('hello "world"\nnext\\line')
    # 결과 = `hello \"world\" next\\line` — `\"` 패턴 제거 후 bare `"` 0건.
    assert '"' not in s.replace('\\"', "")
    assert "\n" not in s


def test_osascript_subprocess_failure_returns_false() -> None:
    """subprocess 실패 → False (F-X-2 fallback write 0건, Sec.14 에러 경로)."""
    from scripts.dashboard.notifier import OSAScriptNotifier
    from scripts.dashboard.models import PendingQuestion
    n = OSAScriptNotifier()
    q = PendingQuestion(q_id="Q1", category="decision", description="x",
                        source="d.md", timestamp=datetime(2026, 4, 27),
                        priority="high")
    with mock.patch(
        "scripts.dashboard.notifier.subprocess.run",
        side_effect=FileNotFoundError,
    ):
        assert n.notify(q) is False


def test_get_notifier_platform_branch() -> None:
    """``sys.platform`` 자동 분기."""
    from scripts.dashboard import notifier as N
    with mock.patch.object(sys, "platform", "darwin"):
        assert isinstance(N.get_notifier(), N.OSAScriptNotifier)
    with mock.patch.object(sys, "platform", "win32"):
        assert isinstance(N.get_notifier(), N.WindowsNotifier)


def test_windows_notifier_stub_returns_false() -> None:
    """Q4 P1 stub — v0.6.4 미가동."""
    from scripts.dashboard.notifier import WindowsNotifier
    from scripts.dashboard.models import PendingQuestion
    q = PendingQuestion(q_id="Q1", category="decision", description="x",
                        source="d.md", timestamp=datetime.now(), priority="high")
    assert WindowsNotifier().notify(q) is False


# ---------------------------------------------------------------------------
# PendingDataCollector — git status / dispatch md
# ---------------------------------------------------------------------------


def test_collector_no_dispatch_dir(tmp_path: Path) -> None:
    """dispatch dir 미존재 → 빈 list."""
    from scripts.dashboard.pending_collector import PendingDataCollector
    c = PendingDataCollector(
        dispatch_dir=tmp_path / "nonexistent", project_root=tmp_path,
    )
    assert c.get_pending_questions() == []


def test_collector_extract_questions(tmp_path: Path) -> None:
    """dispatch md 안 ``**Qxxx**`` 패턴 → PendingQuestion."""
    from scripts.dashboard.pending_collector import PendingDataCollector
    dispatch = tmp_path / "dispatch"
    dispatch.mkdir()
    (dispatch / "test.md").write_text(
        "## 운영자 결정 영역\n"
        "| **Q1** | 토큰량 정책 | high | decision |\n"
        "| **Q-NEW-2** | osascript 채택 | critical | approval |\n"
    )
    c = PendingDataCollector(dispatch_dir=dispatch, project_root=tmp_path)
    questions = c.get_pending_questions()
    q_ids = {q.q_id for q in questions}
    assert "Q1" in q_ids
    assert "Q-NEW-2" in q_ids
    q_crit = next(q for q in questions if q.q_id == "Q-NEW-2")
    assert q_crit.priority == "critical"


def test_collector_git_no_repo(tmp_path: Path) -> None:
    """git 미가동 → 빈 list (F-X-2 read-only)."""
    from scripts.dashboard.pending_collector import PendingDataCollector
    c = PendingDataCollector(project_root=tmp_path)
    with mock.patch(
        "scripts.dashboard.pending_collector.subprocess.run",
        side_effect=FileNotFoundError,
    ):
        assert c.get_pending_pushes() == []


def test_collector_git_ahead(tmp_path: Path) -> None:
    """git ahead N → N개 PendingPush."""
    from scripts.dashboard.pending_collector import PendingDataCollector
    c = PendingDataCollector(project_root=tmp_path)

    def fake_run(argv, **kwargs):
        if "status" in argv:
            return mock.Mock(
                returncode=0,
                stdout="## main...origin/main [ahead 2]\n",
                stderr="",
            )
        if "log" in argv:
            return mock.Mock(
                returncode=0,
                stdout="abc1234\tcommit 1\tHyoungjin-Lee\n"
                       "def5678\tcommit 2\tHyoungjin-Lee\n",
                stderr="",
            )
        return mock.Mock(returncode=1, stdout="", stderr="")

    with mock.patch(
        "scripts.dashboard.pending_collector.subprocess.run",
        side_effect=fake_run,
    ):
        pushes = c.get_pending_pushes()
    assert len(pushes) == 2
    assert all(p.item_type == "push" for p in pushes)
    assert pushes[0].item_id == "push-abc1234"


# ---------------------------------------------------------------------------
# Widgets — empty / overflow / priority sort
# ---------------------------------------------------------------------------


def test_pending_push_box_empty() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.pending_widgets import PendingPushBox
    assert "대기 항목 없음" in PendingPushBox()._render([])


def test_pending_push_box_overflow() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.pending_widgets import PendingPushBox, MAX_VISIBLE_PUSHES
    from scripts.dashboard.models import PendingPush
    pushes = [
        PendingPush(item_id=f"push-{i}", item_type="push", description=f"c{i}",
                    timestamp=datetime.now(), initiator="x", severity="medium")
        for i in range(MAX_VISIBLE_PUSHES + 3)
    ]
    text = PendingPushBox()._render(pushes)
    assert "외 3건" in text


def test_pending_q_box_priority_sort() -> None:
    pytest.importorskip("textual")
    from scripts.dashboard.pending_widgets import PendingQBox
    from scripts.dashboard.models import PendingQuestion
    qs = [
        PendingQuestion(q_id="Q-low", category="decision", description="x",
                        source="d.md", timestamp=datetime.now(), priority="low"),
        PendingQuestion(q_id="Q-crit", category="decision", description="y",
                        source="d.md", timestamp=datetime.now(),
                        priority="critical"),
    ]
    text = PendingQBox()._render(qs)
    crit_pos = text.find("Q-crit")
    low_pos = text.find("Q-low")
    assert 0 <= crit_pos < low_pos, "critical이 low보다 먼저 표시되어야 함"
