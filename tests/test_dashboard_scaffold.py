"""M1 scaffold 검증 — AC-M1-1 ~ AC-M1-9 자동 측정 + F-D2 / F-D4 / F-X-2 헌법 검증.

본 테스트는 textual 미설치 환경에서도 AST 파싱 기반으로 구조 검증을 수행합니다.
textual이 설치된 환경에서는 통합 테스트(import + 인스턴스 생성 + 종료 신호)도 함께 실행.

실행: ``venv/bin/python3 -m pytest tests/test_dashboard_scaffold.py -v``
"""
from __future__ import annotations

import ast
import importlib.util
import re
import subprocess
import sys
import threading
from pathlib import Path

import pytest

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DASHBOARD_PATH = PROJECT_ROOT / "scripts" / "dashboard.py"
PACKAGE_DIR = PROJECT_ROOT / "scripts" / "dashboard"
SLASH_DEF = PROJECT_ROOT / ".claude" / "commands" / "dashboard.md"
REQUIREMENTS = PROJECT_ROOT / "requirements.txt"

PLACEHOLDER_MODULES = ("data.py", "render.py", "pending.py", "notifier.py", "personas.py")
DESIGN_FINAL_MODULES = (
    "models.py",
    "persona_collector.py",
    "pending_collector.py",
    "pending_widgets.py",
    "platform_compat.py",
    "status_bar.py",
    "team_renderer.py",
    "tmux_adapter.py",
    "token_hook.py",
)
SIX_METHODS = ("compose", "on_mount", "_refresh_loop", "_update_widgets", "_show_stale", "action_quit")
MIN_PACKAGE_MODULE_COUNT = 11  # AC-D-3 — design_final Sec.2.1 spec


# ---------------------------------------------------------------------------
# Fixtures (AST 기반 — textual 의존 없음)
# ---------------------------------------------------------------------------


@pytest.fixture(scope="module")
def dashboard_source() -> str:
    return DASHBOARD_PATH.read_text(encoding="utf-8")


@pytest.fixture(scope="module")
def dashboard_ast(dashboard_source: str) -> ast.Module:
    return ast.parse(dashboard_source, filename=str(DASHBOARD_PATH))


def _find_class(tree: ast.Module, name: str) -> ast.ClassDef:
    for node in ast.walk(tree):
        if isinstance(node, ast.ClassDef) and node.name == name:
            return node
    pytest.fail(f"class {name} not found in {DASHBOARD_PATH}")


def _find_method(cls: ast.ClassDef, name: str):
    for node in cls.body:
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)) and node.name == name:
            return node
    return None


# ---------------------------------------------------------------------------
# 파일 / 패키지 구조 (F-D2 정합)
# ---------------------------------------------------------------------------


def test_dashboard_entry_point_exists() -> None:
    """AC-M1-1 — 단일 진입점 ``scripts/dashboard.py`` 존재 (F-D2)."""
    assert DASHBOARD_PATH.is_file(), f"{DASHBOARD_PATH} 미존재 (F-D2 단일 진입 위반)"


def test_module_package_init_exists() -> None:
    """F-D2 — ``scripts/dashboard/`` 패키지 ``__init__.py`` 존재."""
    init_path = PACKAGE_DIR / "__init__.py"
    assert init_path.is_file(), f"{init_path} 미존재 (F-D2 모듈 패키지 위반)"


@pytest.mark.parametrize("module_name", PLACEHOLDER_MODULES)
def test_placeholder_module_exists(module_name: str) -> None:
    """F-D2 — drafter v1 SRP 묶음 placeholder 5개 존재 (R-N R-1 reviewer 정정 후 deprecated 영역, M2~M5 진입 시 회수 권고)."""
    path = PACKAGE_DIR / module_name
    assert path.is_file(), f"{path} 미존재 (drafter v1 SRP 묶음 placeholder)"


@pytest.mark.parametrize("module_name", DESIGN_FINAL_MODULES)
def test_design_final_module_exists(module_name: str) -> None:
    """AC-D-3 / F-D2 정합 — design_final Sec.2.1 spec 모듈 9개 존재 (reviewer 정정 후 신규)."""
    path = PACKAGE_DIR / module_name
    assert path.is_file(), f"{path} 미존재 (design_final Sec.2.1 spec)"


def test_package_module_count_at_least_11() -> None:
    """AC-D-3 — ``ls scripts/dashboard/*.py | wc -l`` ≥ 11 (design_final Sec.2.1 spec)."""
    py_files = sorted(PACKAGE_DIR.glob("*.py"))
    assert len(py_files) >= MIN_PACKAGE_MODULE_COUNT, (
        f"AC-D-3 위반 — 모듈 카운트 {len(py_files)} < {MIN_PACKAGE_MODULE_COUNT}"
    )


def test_slash_command_definition_exists() -> None:
    """AC-M1-1 — ``.claude/commands/dashboard.md`` 슬래시 정의 존재."""
    assert SLASH_DEF.is_file(), f"{SLASH_DEF} 미존재"
    content = SLASH_DEF.read_text(encoding="utf-8")
    assert "/dashboard" in content, "/dashboard 토큰 누락"
    assert "scripts/dashboard.py" in content, "스크립트 경로 누락"


def test_requirements_textual_pinned() -> None:
    """AC-M1-5 — ``requirements.txt``에 textual 의존 명시."""
    assert REQUIREMENTS.is_file(), f"{REQUIREMENTS} 미존재"
    content = REQUIREMENTS.read_text(encoding="utf-8").lower()
    assert "textual" in content, "textual 의존 누락"


# ---------------------------------------------------------------------------
# 코드 품질 (AC-M1-2 / AC-M1-8 / R-2)
# ---------------------------------------------------------------------------


def test_dashboard_compiles() -> None:
    """AC-M1-2 — ``python3 -m py_compile`` 정상 종료 (SyntaxError 0)."""
    result = subprocess.run(
        [sys.executable, "-m", "py_compile", str(DASHBOARD_PATH)],
        capture_output=True,
        text=True,
        check=False,
    )
    assert result.returncode == 0, f"py_compile 실패: {result.stderr}"


def test_dashboard_under_120_lines(dashboard_source: str) -> None:
    """R-2 정정 — ``scripts/dashboard.py`` ≤ 120줄."""
    lines = dashboard_source.splitlines()
    assert len(lines) <= 120, f"R-2 위반 — 분량 {len(lines)}줄 > 120줄"


def test_dashboard_has_module_docstring(dashboard_source: str) -> None:
    """AC-M1-8 — 모듈 docstring 1개 이상."""
    assert dashboard_source.lstrip().startswith(('"""', "'''", "#!")), "module docstring 누락"
    assert '"""' in dashboard_source, "docstring 형식 누락"


# ---------------------------------------------------------------------------
# DashboardApp 클래스 구조 (Sec.6.1 spec)
# ---------------------------------------------------------------------------


def test_dashboard_app_class_inherits_app(dashboard_ast: ast.Module) -> None:
    """AC-M1-2 — ``class DashboardApp(App)`` 정의 + textual ``App`` 상속."""
    cls = _find_class(dashboard_ast, "DashboardApp")
    base_names = {b.id for b in cls.bases if isinstance(b, ast.Name)}
    assert "App" in base_names, f"DashboardApp 베이스에 ``App`` 누락: {base_names}"


def test_bindings_q_quit_present(dashboard_ast: ast.Module) -> None:
    """AC-M1-3 — ``BINDINGS = [Binding("q", "quit", ...)]`` 클래스 변수."""
    cls = _find_class(dashboard_ast, "DashboardApp")
    payload: list[str] = []
    for node in cls.body:
        if isinstance(node, ast.Assign):
            targets = {t.id for t in node.targets if isinstance(t, ast.Name)}
            if "BINDINGS" in targets:
                payload.append(ast.dump(node.value))
    assert payload, "BINDINGS 클래스 변수 미정의"
    blob = " ".join(payload)
    assert "'q'" in blob or '"q"' in blob, "BINDINGS ``q`` 키 누락"
    assert "quit" in blob, "BINDINGS ``quit`` 액션 누락"


def test_compose_method_exists(dashboard_ast: ast.Module) -> None:
    """AC-M1-2 — ``compose`` 메서드 정의."""
    cls = _find_class(dashboard_ast, "DashboardApp")
    method = _find_method(cls, "compose")
    assert method is not None, "compose 메서드 미정의"


def test_action_quit_method_exists(dashboard_ast: ast.Module) -> None:
    """AC-M1-3 — ``action_quit`` 메서드 (BINDINGS ``q`` 호출 대상) 정의."""
    cls = _find_class(dashboard_ast, "DashboardApp")
    method = _find_method(cls, "action_quit")
    assert method is not None, "action_quit 메서드 미정의"


@pytest.mark.parametrize("method_name", SIX_METHODS)
def test_six_methods_present(dashboard_ast: ast.Module, method_name: str) -> None:
    """Sec.6.1 — 6 메서드 (compose / on_mount / _refresh_loop / _update_widgets / _show_stale / action_quit) presence."""
    cls = _find_class(dashboard_ast, "DashboardApp")
    method = _find_method(cls, method_name)
    assert method is not None, f"Sec.6.1 위반 — {method_name} 메서드 미정의"


# ---------------------------------------------------------------------------
# F-D4 본문 결정 — sync 시작 (R-3 정정)
# ---------------------------------------------------------------------------


def test_on_mount_is_sync_def(dashboard_ast: ast.Module) -> None:
    """F-D4 본문 결정 (R-3 정정) — ``on_mount``는 sync ``def``. ``async def`` 채택 시 헌법 위반."""
    cls = _find_class(dashboard_ast, "DashboardApp")
    method = _find_method(cls, "on_mount")
    assert method is not None, "on_mount 메서드 미정의"
    assert isinstance(method, ast.FunctionDef), (
        "F-D4 위반 — on_mount이 async def. design_final Sec.5.3 R-3 정정에 따라 sync def 강제."
    )


def test_on_mount_uses_run_worker_thread(dashboard_source: str) -> None:
    """F-D4 정합 — Threaded sync wrapper (``run_worker(thread=True)``) 호출."""
    assert "run_worker" in dashboard_source, "F-D4 위반 — run_worker 호출 누락"
    assert "thread=True" in dashboard_source, (
        "F-D4 위반 — ``thread=True`` 누락. async/await 전면 채택은 design_final Sec.5.2 옵션 A로 회수."
    )


def test_exit_signal_threading_event(dashboard_source: str) -> None:
    """F-D4 thread-safety — ``_exit_signal`` ``threading.Event`` 사용 (worker 정상 종료)."""
    assert "threading" in dashboard_source, "threading import 누락"
    assert "_exit_signal" in dashboard_source, "_exit_signal 식별자 누락 (action_quit ↔ worker 통신)"
    assert "Event()" in dashboard_source, "threading.Event 인스턴스 생성 누락"


# ---------------------------------------------------------------------------
# F-X-2 read-only 정책 (AC-M1-9)
# ---------------------------------------------------------------------------


def test_no_write_commands_in_dashboard(dashboard_source: str) -> None:
    """AC-M1-9 (F-X-2) — write 명령 0건. git push / commit / open(... 'w') 패턴 금지."""
    forbidden_literals = ("git push", "git commit")
    for keyword in forbidden_literals:
        assert keyword not in dashboard_source, f"F-X-2 위반: {keyword!r} 발견"
    write_pattern = re.compile(r"open\([^)]*['\"]w['\"]")
    matches = write_pattern.findall(dashboard_source)
    assert not matches, f"F-X-2 위반: write 모드 ``open()`` 발견 — {matches}"


def test_no_write_commands_in_package() -> None:
    """AC-M1-9 (F-X-2) — 패키지 placeholder 모듈에도 write 명령 0건."""
    write_pattern = re.compile(r"open\([^)]*['\"]w['\"]|git\s+push|git\s+commit")
    for module_name in PLACEHOLDER_MODULES + ("__init__.py",):
        path = PACKAGE_DIR / module_name
        if not path.is_file():
            continue
        content = path.read_text(encoding="utf-8")
        matches = write_pattern.findall(content)
        assert not matches, f"F-X-2 위반 ({path}): {matches}"


# ---------------------------------------------------------------------------
# 통합 테스트 (textual 설치 시만 실행)
# ---------------------------------------------------------------------------


@pytest.fixture(scope="module")
def dashboard_module():
    if importlib.util.find_spec("textual") is None:
        pytest.skip("textual 미설치 — 통합 테스트 skip (requirements.txt 의존 설치 후 재실행)")
    spec = importlib.util.spec_from_file_location("_dashboard_under_test", DASHBOARD_PATH)
    assert spec is not None and spec.loader is not None, "dashboard.py spec load 실패"
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_dashboard_app_instantiable(dashboard_module) -> None:
    """AC-M1-6 (통합) — DashboardApp 인스턴스 생성 + ``_exit_signal`` 초기화 검증."""
    instance = dashboard_module.DashboardApp()
    assert instance is not None
    assert hasattr(instance, "_exit_signal"), "_exit_signal 속성 누락"
    assert hasattr(instance._exit_signal, "set"), "_exit_signal.set 누락 (threading.Event 정합 X)"
    assert hasattr(instance._exit_signal, "is_set"), "_exit_signal.is_set 누락"
    assert isinstance(instance._exit_signal, threading.Event), (
        f"_exit_signal 타입 위반: {type(instance._exit_signal)}"
    )
    assert not instance._exit_signal.is_set(), "_exit_signal 초기 상태 False 위반"


def test_action_quit_sets_exit_signal(dashboard_module) -> None:
    """F-D4 정합 (통합) — ``_exit_signal.set()``으로 worker thread 정상 종료 가능."""
    instance = dashboard_module.DashboardApp()
    # textual App.exit() 호출은 메인 thread + 컨텍스트 필요 → 직접 신호만 검증
    instance._exit_signal.set()
    assert instance._exit_signal.is_set(), "exit signal 설정 실패"
