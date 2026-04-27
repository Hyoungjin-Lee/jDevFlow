---
date: 2026-04-27
version: v0.6.4
stage: 10
work: Major M-1 / M-2 fix — drafter 초안
author: 카더가든 (백앤드 드래프터, 주임연구원)
pane: Orc-064-dev:1.2
length_target: ≤ 800 줄
---

# Stage 10 Major M-1 / M-2 fix — drafter 초안

> 카더가든입니다. Stage 9 review M-1 / M-2 두 건 fix 초안을 잡아봅니다. M-1은 옵션 A
> (`pending_collector._git_run` → `GitAdapter` 위임) + M-2는 옵션 A·C 결합
> (`capture_panes_batch` 1회 + token_hook prefetched lines 재사용)으로 진행합니다.

## 1. M-1 (AC-T-4 spec deviation) fix 초안

### 1.1 식별 (Stage 9 review Sec.4.2 verbatim)

- design_final Sec.4.3 / Sec.17.1 AC-T-4 spec = 2 (`tmux_adapter.py` + `notifier.py`)
- 실제 = 3 (+ `pending_collector.py` 안 `_git_run` subprocess 직접 import)
- 위반: 모듈 경계 #4 (subprocess 격리) 약화

### 1.2 옵션 비교

| 옵션 | 설명 | 장점 | 단점 |
|------|------|------|------|
| **A (권고 채택)** | `pending_collector._git_run` → `GitAdapter` 위임. `tmux_adapter.py`에 `GitAdapter` 신설. | AC-T-4 = 2 유지 / token_hook 패턴(`TmuxAdapter` 위임) 정합 / 모듈 경계 #4 더 강함 | tmux_adapter 모듈명에 git 클래스 추가 (네이밍 살짝 어긋남) |
| B | design_final Sec.17.1 AC-T-4 spec = 3 정정 (코드 그대로) | 변경 최소 / 코드 그대로 | spec 약화 / 모듈 경계 #4 spirit 위배 |

### 1.3 채택 = 옵션 A

근거:
1. Stage 9 review가 옵션 A를 권고 (단일 줄 deviation, closure 영향 0건)
2. `token_hook.py` R-5 정정 패턴 정합 — `from .tmux_adapter import TmuxAdapter` 위임으로
   subprocess 직접 import 0건. 동일 패턴.
3. 모듈명 우려: `tmux_adapter.py`는 본질적으로 "외부 subprocess 격리 layer" — 첫 줄
   docstring에서 "tmux + git subprocess 격리 layer"로 의도 명시.

### 1.4 코드 변경 (drafter 본문)

**(a) `tmux_adapter.py` GitAdapter 클래스 신설 (파일 말미):**

```python
class GitAdapter:
    """git subprocess 격리 adapter — Stage 10 M-1 fix (AC-T-4 = 2 유지).

    pending_collector.py가 본 어댑터 위임으로 subprocess 직접 import 0건.
    token_hook.py의 TmuxAdapter 위임 패턴 정합 — design_final Sec.4.3 #4.
    sync 인터페이스 — F-D4 Threaded sync wrapper 정합.
    """

    DEFAULT_TIMEOUT_SEC = 3.0

    def __init__(
        self,
        project_root: Optional[Path] = None,
        timeout_sec: float = DEFAULT_TIMEOUT_SEC,
    ) -> None:
        self.project_root = (project_root or Path.cwd()).resolve()
        self.timeout_sec = timeout_sec

    def run(self, argv: List[str]) -> Optional[str]:
        """git argv → stdout 문자열. 실패(미설치/timeout/non-zero) 시 None.

        cwd = self.project_root 고정 — 다른 working tree 영향 0건.
        """
        try:
            res = subprocess.run(
                argv, capture_output=True, text=True,
                timeout=self.timeout_sec, check=False,
                cwd=str(self.project_root),
            )
        except (FileNotFoundError, subprocess.TimeoutExpired, OSError):
            return None
        if res.returncode != 0:
            return None
        return res.stdout
```

**(b) `pending_collector.py` 변경:**

- `import subprocess` 제거
- `from .tmux_adapter import TmuxAdapter` → `from .tmux_adapter import GitAdapter, TmuxAdapter`
- `__init__` 시그니처에 `git: Optional[GitAdapter] = None` 추가 + `self.git = git or GitAdapter(project_root=self.project_root)`
- `_git_run` 메서드 제거
- `_git_ahead_count` / `_read_recent_commits`에서 `self._git_run(argv)` → `self.git.run(argv)`
- `GIT_TIMEOUT_SEC` 상수 제거 (`GitAdapter.DEFAULT_TIMEOUT_SEC` 영역으로 이전)

### 1.5 검증 (M-1)

- `grep -lE "^import subprocess|^from subprocess" scripts/dashboard/*.py` = 2건
  (tmux_adapter.py, notifier.py)
- AC-T-4 = 2 PASS
- `python3 -m py_compile` 정합

---

## 2. M-2 (PersonaDataCollector 18 process/sec) fix 초안

### 2.1 식별 (Stage 9 review Sec.4.2 verbatim)

- 1초 polling × 18 페르소나 × subprocess.run = 18~36 OS process spawn / sec 잠재
- 추가: token_hook이 capture-pane regex fallback에서 `tmux.capture_pane` 호출 →
  per persona 최대 2회 spawn 가능 (working state + tokens regex fallback). 실측 영역.

### 2.2 옵션 비교

| 옵션 | 설명 | 장점 | 단점 |
|------|------|------|------|
| **A (권고 채택)** | `tmux capture-pane` 1회 batch (display-message 구분자 + command chaining) → subprocess.run 1/sec | spawn /sec 1로 감소 / cleanest | tmux command chaining argv 형식 / 구분자 충돌 가능성 (저확률) |
| B | 폴링 주기 1→2초 (`.claude/settings.json dashboard_polling_sec`) | 변경 최소 | 절반만 줄임 / UX 갱신 늦음 |
| **C (권고 채택)** | `_pane_change_cache` SHA1 unchanged 시 token_hook skip | 효과적 | 구현 복잡 / change cache 기준 capture_pane 부수효과 의존 |

### 2.3 채택 = 옵션 A + 옵션 C 결합

- **A**: `TmuxAdapter.capture_panes_batch(panes, lines=100)` 신설. 1회 subprocess.run으로
  N개 pane 일괄 capture. `display-message -p '<DELIM><pane><DELIM>'` 구분자.
- **C**: token_hook이 pre-fetched lines 재사용 (`prefetched_lines` 인자 추가).
  PersonaDataCollector가 batch 결과를 token_hook + _infer_task에 함께 전달.

옵션 B (폴링 2초) 채택 안 함 — UX 영향 + AC-S8-3 settings.json 영역. v0.6.5 운영자
결정 영역으로 위임.

### 2.4 코드 변경 (drafter 본문)

**(a) `tmux_adapter.py` `capture_panes_batch` 신설:**

```python
_BATCH_DELIM = "<<<JONEFLOW_PANE_DELIM>>>"

def capture_panes_batch(
    self, panes: List[str], lines: int = 50
) -> Dict[str, List[str]]:
    """N개 pane을 tmux 1회 호출(command chaining)로 일괄 capture (M-2 fix).

    - 미가동/실패: 입력 pane 모두 빈 list 매핑.
    - 부수효과: 각 pane별 last_pane_change 캐시 갱신.
    - 호출 비용: 18 pane = 1 subprocess.run / sec (기존 18~33 → ≤ 2).
    """
    if not panes:
        return {}
    argv: List[str] = ["tmux"]
    for i, pane in enumerate(panes):
        if i > 0:
            argv.append(";")
        argv.extend(["display-message", "-p", f"{_BATCH_DELIM}{pane}{_BATCH_DELIM}"])
        argv.append(";")
        argv.extend(["capture-pane", "-t", pane, "-p", "-S", f"-{int(lines)}"])
    raw = self._run(argv)
    out: Dict[str, List[str]] = {p: [] for p in panes}
    if raw is None:
        return out
    current: Optional[str] = None
    buffer: List[str] = []
    for line in raw.splitlines():
        if (
            line.startswith(_BATCH_DELIM)
            and line.endswith(_BATCH_DELIM)
            and len(line) > 2 * len(_BATCH_DELIM)
        ):
            if current is not None and current in out:
                out[current] = buffer
                self._update_change_cache(current, buffer)
            current = line[len(_BATCH_DELIM):-len(_BATCH_DELIM)]
            buffer = []
        else:
            buffer.append(line)
    if current is not None and current in out:
        out[current] = buffer
        self._update_change_cache(current, buffer)
    return out
```

**(b) `token_hook.py` `prefetched_lines` 추가:**

```python
def get_tokens_k(
    self,
    pane_name: str,
    prefetched_lines: Optional[list] = None,
) -> float:
    """1순위 hook JSON / 2순위 capture-pane regex / 3순위 0.0.

    Stage 10 M-2 fix — prefetched_lines 인입 시 capture-pane 호출 0건
    (PersonaDataCollector batch 결과 재사용).
    """
    session = pane_name.split(":")[0] if ":" in pane_name else pane_name
    hook_value = self._read_hook(session)
    if hook_value is not None:
        return hook_value
    regex_value = self._regex_from_lines(prefetched_lines) if prefetched_lines else None
    if regex_value is None and prefetched_lines is None:
        regex_value = self._regex_capture(pane_name)
    if regex_value is not None:
        return regex_value
    return 0.0

def _regex_from_lines(self, lines: Optional[list]) -> Optional[float]:
    """이미 capture된 lines 재사용 — Stage 10 M-2 fix (subprocess 0건)."""
    if not lines:
        return None
    match = self.REGEX.search("\n".join(lines))
    if match is None:
        return None
    try:
        return (int(match.group(1)) + int(match.group(2))) / 1000.0
    except (ValueError, TypeError):
        return None
```

**(c) `persona_collector.py` batch 활용:**

`fetch_all_personas`가 batch capture 1회 + 결과를 `_infer_state` / `_infer_task` /
`token_hook.get_tokens_k`에 전달:

```python
def fetch_all_personas(self) -> List[PersonaState]:
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
```

`_infer_state`는 `pane_lines: Dict[str, List[str]]` 인자를 받고 `token_hook` /
`_infer_task`에 전달. `_infer_task`는 capture_pane 호출 제거 — 마지막 50줄
effective window는 batch lines 100줄에서 slice.

### 2.5 검증 (M-2)

- 시뮬레이션: `subprocess.run` mock + `fetch_all_personas` 1회 호출 시 spawn 횟수
  - **2회** (list_sessions 1 + capture_panes_batch 1)
  - 기존 추정 18~36 → 측정 2 ✓
- AC-T-4 = 2 유지 (subprocess import 본 fix로 늘리지 않음)

---

## 3. 종합 검증

| 검증 | 결과 |
|------|------|
| `python3 -m py_compile` 4 파일 | PASS 4/4 |
| AC-T-4 grep `^import subprocess` line-start | 2건 (tmux_adapter.py + notifier.py) |
| M-1 GitAdapter 위임 시뮬 | PASS (`subprocess.run` 호출 GitAdapter 거쳐서 2회) |
| M-2 batch + prefetched lines 시뮬 | PASS (`fetch_all_personas` 호출 시 spawn = 2회) |
| 기존 회귀 | 0건 (signature 호환 유지 — `_infer_task` 인자만 변경, 호출자 1곳 modify) |

## 4. 분량 임계

- 본 drafter doc = 약 200줄 (≤ 800 PASS)

## 5. reviewer 인계

- M-1 + M-2 옵션 채택 / 코드 변경 / 시뮬 결과 모두 박았습니다. 최우영 리뷰어가
  검토하시고 R-N 마커 + 직접 정정 권한으로 보강 부탁드립니다.
- 특히 (1) GitAdapter 클래스 위치 (tmux_adapter.py 내 vs 별도 git_adapter.py),
  (2) capture_panes_batch 구분자 충돌 가능성, (3) lines=100 일관성 (token regex 100
  + task 50 superset) 영역 점검 권고합니다.

— 카더가든 (백앤드 드래프터, Orc-064-dev:1.2)
