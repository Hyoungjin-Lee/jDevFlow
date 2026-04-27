---
stage: 8
milestone: M2
role: be-reviewer (최우영, Opus high)
date: 2026-04-27
verdict: PASS_WITH_PATCH
score: 95/100
length_budget: ≤ 600줄
length_actual: pending (본 파일 wc -l)
---

# v0.6.4 Stage 8 M2 데이터 layer — reviewer R-N trail (A 패턴 / 헌법 hotfix `9902a68`)

> **상위:** `docs/03_design/v0.6.4_design_final.md` (commit `8fbbfed`, Score 97/100, verdict GO) Sec.3 (F-D1) + Sec.5 (F-D4 Threaded sync wrapper) + Sec.7 (M2 데이터 수집 layer) + Sec.7.3 (Q2 정확 hook + R-10 namespace prefix).
> **dispatch:** `dispatch/2026-04-27_v0.6.4_stage8_implementation.md` Sec.핵심작업 M2 (데이터 layer F-D1 본문).
> **drafter v1:** 카더가든 (Haiku medium), `models.py(52) + persona_collector.py(168→169) + tmux_adapter.py(98) + token_hook.py(90) + tests/test_dashboard_data.py(391) = 799→800줄`. py_compile 5/5 OK / 헌법 14/15 PASS (1 false positive — R-4 식별 영역) / 통합 simulation 5/5 / 디스크 영구화 OK (BR-001 stash 회피).
> **헌법 hotfix `9902a68` 영구 박힘:** A 패턴 = drafter → reviewer **본인 직접 수정** + R-N 마커 → finalizer 마감 doc만. drafter v2 단계 X. verbatim 흡수 X. 모든 프로세스 동일 적용 (기획/디자인/개발/QA/release). (세션 28 운영자 결정 — 단순함 정공법)

## 0. 요약

- **R-N 식별 6건** — R-1 PATCH 작은(테스트 보강) / R-2 PASS(모듈 레벨 deviation 자율) / R-3 PASS(FE 트리오 placeholder M5 영역) / R-4 mild PATCH(헌법 false positive 식별) / R-5 PASS(regex compile 자율 +1) / R-6 PASS(TokenHook project_root 인자 자율 +1).
- **본인 직접 수정 적용 1건** — R-N 마커 1줄 추가(`persona_collector.py` `IDLE_THRESHOLD_SEC` 위 `# R-N reviewer 검증 (M2 PASS_WITH_PATCH) — Sec.7.4 채택값 정합 + AC-S8-3 이월.`). 분량 168→169줄 / 합계 799→800 정확 boundary PASS.
- **분량 임계 헌법 정합:** drafter 산출 800줄 = ≤ 800 boundary PASS. R-N trail ≤ 600 (본 파일 자가 점검).
- **A 패턴 정합:** drafter v1 본문 verbatim 흡수 X(Sec.7.1 spec verbatim 코드 영역 1건만 docstring 흡수, 본문은 자율 deviation 6건 박힘) + reviewer 본인 직접 R-N 마커 1줄 + finalizer 본문 작성 X 영역.
- **verdict = PASS_WITH_PATCH Score 95/100** (임계 80% 통과 + 목표 90%+ 통과).

## 1. drafter v1 산출 헌법 검증 (PASS 영역, 14/15 + R-4 false positive 식별)

| 영역 | drafter v1 산출 | design_final spec | verdict |
|------|----------------|-------------------|---------|
| F-D1 PersonaState 6 필드 | name/team/status/task/tokens_k/last_update + frozen=False + eq=True + to_json | Sec.3.1 verbatim | PASS |
| F-D1 SRP 분리 (M4 영역 0건) | persona_collector.py에 PendingDataCollector 박힘 0건 | Sec.7.1 SRP 강제 | PASS (test_persona_collector_no_pending_class) |
| F-D4 sync def 전면 | M2 4 모듈 async def 0건 | Sec.5.3 R-3 정정 | PASS (test_no_async_def_in_m2 parametrize 4) |
| Q2 정확 hook 2단 fallback | hook JSON → capture-pane regex → 0.0 (Sec.14 에러 경로) | Sec.7.3 verbatim | PASS (3 테스트) |
| R-10 namespace prefix | sha1(project_root)[:8] + `joneflow_<hash>_<session>.json` | Sec.7.3 R-10 정정 | PASS (test_token_hook_namespace_prefix) |
| Q5 idle 통합 | tmux 미존재 = idle, offline 분리 옵션 0건, PersonaStatus = Literal["working", "idle"] | Sec.7.2 / Sec.11.5 verbatim | PASS (test_collector_q5_all_idle_when_no_sessions) |
| R-1 last_update 보존 | epoch 0 fallback + last_pane_change 보존 | Sec.7.2 R-1 정정 | PASS (2 테스트) |
| R-2 last_known_task fallback | A-1 prompt > A-3 로그 > A-2 last_known | Sec.7.5 drafter R-2 정정 | PASS (test_collector_r2_last_known_task_fallback) |
| AC-T-4 = 2 (subprocess 격리 #4) | tmux_adapter.py 1 모듈 import (M4 notifier.py 미작성 = 1) | R-5 정정 = 2 | **R-4 false positive** (M4 진입 시 자연 정합) |
| AC-T-5 subprocess timeout 영구 | `subprocess.run(..., timeout=self.timeout_sec)` | Sec.16.1 영구 정책 | PASS |
| AC-S-1 read-only 0건 | git push / git commit / open(... 'w') 패턴 0건 | F-X-2 영구 정책 | PASS (test_no_write_commands parametrize 4) |
| PERSONAS_18 = 15 (4팀 4+4+7) | 모듈 레벨 List[Tuple[str, str]] = 15 entry | Sec.7.1 verbatim (class 레벨, 변수명 PERSONAS_18) | PASS (R-2 자율 +1 인정 — 모듈 레벨 deviation) |
| TmuxAdapter signature diff | SHA1 cache + last_pane_change 갱신 부수효과 | Sec.7.4 stale 임계 정합 | PASS (test_tmux_adapter_capture_pane_signature_change) |
| 분량 임계 ≤ 800 | 799 → 800 (R-N 마커 1줄 추가) | 헌법 사고 14 임계 | PASS (boundary) |
| 테스트 커버리지 24 함수 / ~30 측정점 (parametrize 포함) | F-D1/F-D4/F-X-2/Q2/Q5/R-1/R-2/AC-T-4 모두 커버 | Sec.15 단위 테스트 분담 | **R-1 작은 PATCH** (boundary + 80자 cap 누락) |

## 2. R-N 6건 본문

### R-1 (PATCH 작은 — 테스트 보강 권고): IDLE_THRESHOLD_SEC boundary + `_normalize_task` 80자 cap 검증 누락

**식별 영역.** drafter v1 24 테스트 함수 + parametrize 측정점은 F-D1/F-D4/F-X-2/Q2/Q5/R-1/R-2/AC-T-4를 모두 커버하나 다음 2건 누락:

1. **IDLE_THRESHOLD_SEC boundary 검증** — `_infer_state`의 `if elapsed > IDLE_THRESHOLD_SEC` 조건 boundary. `elapsed = 10.0` (정확 임계) → working / `elapsed > 10.0` → idle 명확화. 현 `test_collector_idle_when_pane_stale_preserves_change_ts`는 `stale = -60초`로 한참 idle 영역만 검증.
2. **`_normalize_task` 80자 cap 검증** — `cleaned[:80]` 잘라내기 정합성. 80자 초과 prompt 입력 시 정확히 80자로 truncate되는지 검증 누락.

**적용 영역.** 분량 임계 800줄 정확 boundary 도달로 본 reviewer 단계에서 추가 patch 영역 없음 (테스트 추가 시 800 초과). **권고 영역으로 박음** — Stage 9 코드 리뷰 영역(Sec.15.4 Stage 9 자동 검증 영역) 또는 M3 영역에서 추가 검증 권고.

**근거.** design_final Sec.7.4 갱신 주기 + Sec.7.5 작업명 추론 우선순위 + R-2 last_known_task fallback의 직접 boundary 검증 영역.

**중요도.** mild — 본 stage closure 영향 0건 (드래프터 산출 분량 boundary + 24 함수 커버리지 충분 정합).

### R-2 (PASS — drafter 자율 +1 인정): PERSONAS_18 모듈 레벨 vs class 레벨 deviation

**식별 영역.** design_final Sec.7.1 verbatim:

```python
class PersonaDataCollector:
    PERSONAS_18 = [...]
```

drafter v1 구현:

```python
PERSONAS_18: List[Tuple[str, str]] = [...]  # 모듈 레벨

class PersonaDataCollector:
    def __init__(...): ...
```

**판정.** 둘 다 valid Python. 모듈 레벨은 `from scripts.dashboard.persona_collector import PERSONAS_18` 직접 import 가능 + 테스트에서 `_last_known_states` 주입 시 PersonaState 객체 생성 가능 + 운영자 가시성 +1 (변수 위치 명확). drafter 자율 +1 영역으로 인정.

**중요도.** PASS — 본 stage closure 영향 0건. design_final Sec.7.1 verbatim의 spec 정확 흡수 보다 drafter 자율 결정이 더 합리적 영역.

### R-3 (PASS — drafter 자율 placeholder 인정): `_PERSONA_TO_PANE_INDEX` FE 트리오 매핑 placeholder

**식별 영역.** drafter v1 `_PERSONA_TO_PANE_INDEX`에 BE 트리오는 `1.x` (공기성 1.1 / 카더가든 1.2 / 최우영 1.3 / 현봉식 1.4) 정확 매핑. FE 트리오는 `2.x` placeholder (백강혁 2.3 / 지예은 2.2 / 김원훈 2.4) — `Orc-064-dev:2.x` pane 미존재.

**판정.** F-X-6 18명 매핑 detail은 M5 진입 시점 blocking 영역 (`personas_18.md` 작성 후 정정). 본 M2 단계 = stub OK. FE 트리오는 `Orc-064-dev:2.x` 매핑 → tmux capture-pane 실패 → 빈 list → `_update_change_cache` 미호출 → `last_pane_change = epoch 0` → `elapsed > 10.0` → idle 통합 자연 폴백. Q5 정합 영역.

**중요도.** PASS — M5 영역 blocking 정합 + idle 자연 폴백.

### R-4 (mild PATCH 권고 — 헌법 false positive 식별): AC-T-4 = 2 본 M2 단계 시점 = 1 (M4 미작성)

**식별 영역.** drafter v1 자가 헌법 검증 14/15 PASS + 1 false positive 표기. 본 reviewer 식별 영역 = **AC-T-4 = 2 (subprocess import 격리 #4 = 2 모듈)**:

- design_final Sec.4.3 / Sec.17.1 AC-T-4 정의 = `grep -lE "import subprocess" scripts/dashboard/*.py | wc -l` = **2** (R-5 정정, drafter v1 "3" 회수 — token_hook.py가 TmuxAdapter 위임으로 subprocess 직접 import 0건).
- 정합 모듈 = `tmux_adapter.py` (M2) + `notifier.py` (M4).
- 본 M2 단계 시점 = 1 모듈만 (tmux_adapter.py). M4 notifier.py 본문 작성 시 = 2 도달.
- 따라서 본 stage closure 시점 AC-T-4 검증 = `1 != 2` 미달, 단 M4 진입 시 자연 정합 = **false positive** 분류.

**판정.** drafter 자가 헌법 검증의 false positive 영역으로 인정. 본 reviewer 정정 영역 X (M4 영역에서 자연 정합). M2 단계 closure 영향 0건.

**근거.** dispatch md Sec.핵심작업 M4 본문 ("`Notifier` ABC + `OSAScriptNotifier` (Q3 운영자 결정 — macOS osascript 기본)") + design_final Sec.9.3 Q3 osascript 본문 spec.

**중요도.** mild 권고 — Stage 9 코드 리뷰 영역에서 M4 작성 후 AC-T-4 = 2 자동 검증 정합 박음 영역.

### R-5 (PASS — drafter 자율 +1 인정): TokenHook regex pattern compile + spaces 유연성

**식별 영역.** design_final Sec.7.3 verbatim:

```python
REGEX = r'"usage":\s*\{\s*"input_tokens":\s*(\d+),\s*"output_tokens":\s*(\d+)'
```

drafter v1 구현:

```python
REGEX = re.compile(
    r'"usage"\s*:\s*\{\s*"input_tokens"\s*:\s*(\d+)\s*,\s*"output_tokens"\s*:\s*(\d+)'
)
```

**판정.** drafter 자율 +2 영역:
- `re.compile()` = 재사용 시 성능 +1 (1초 polling worker가 매 호출마다 컴파일 회피).
- `\s*:\s*` / `\s*,\s*` = JSON 출력 spaces 유연성 +1 (claude CLI hook이 pretty-print하든 minify하든 매치).

**중요도.** PASS — design_final spec verbatim보다 합리적 deviation 영역.

### R-6 (PASS — drafter 자율 +1 인정): TokenHook `__init__` project_root 인자 받음

**식별 영역.** design_final Sec.7.3 verbatim:

```python
def __init__(self, tmux: Optional[TmuxAdapter] = None) -> None:
    self.tmux = tmux or TmuxAdapter()
    self._project_hash = hashlib.sha1(str(Path.cwd()).encode()).hexdigest()[:8]
```

drafter v1 구현:

```python
def __init__(self, tmux=None, project_root: Optional[Path] = None) -> None:
    self.tmux = tmux or TmuxAdapter()
    self._project_root = (project_root or Path.cwd()).resolve()
    self._hook_dir = self._project_root / self.HOOK_DIR_NAME
    self._project_hash = hashlib.sha1(str(self._project_root).encode("utf-8")).hexdigest()[:8]
```

**판정.** drafter 자율 +N 영역:
- `project_root` 인자 받음 = 테스트에서 `tmp_path` 주입 가능 (pytest fixture 정합) → test_token_hook_reads_json_first / test_token_hook_zero_on_corrupt_and_no_capture에서 활용.
- `.resolve()` 호출 = 심볼릭 링크 resolve 후 hash 계산 → namespace prefix 일관성 +1.
- `encode("utf-8")` 명시 = 시스템 default encoding fallback 회피.

**중요도.** PASS — 테스트 가능성 +1 + 신뢰성 +1.

## 3. 정정 적용 trail (file 변경 요약)

| 파일 | drafter v1 | reviewer 정정 | 분량 |
|------|------------|---------------|-----|
| `scripts/dashboard/models.py` | F-D1 PersonaState 6 필드 + frozen=False + eq=True + to_json | 변경 0 (PASS) | 52 |
| `scripts/dashboard/persona_collector.py` | PERSONAS_18=15 + Q5 idle 통합 + R-1 last_update + R-2 last_known + Sec.7.4 채택값 | **R-N 마커 1줄 추가** (IDLE_THRESHOLD_SEC 위) | 168 → 169 (+1) |
| `scripts/dashboard/tmux_adapter.py` | sync API + FileNotFoundError/Timeout 폴백 + signature diff cache | 변경 0 (PASS) | 98 |
| `scripts/dashboard/token_hook.py` | JSON 1순위 + regex 2순위 + R-10 namespace + project_root 인자 + re.compile | 변경 0 (PASS, R-5/R-6 자율 +1 인정) | 90 |
| `tests/test_dashboard_data.py` | 24 함수 / ~30 측정점 (parametrize 포함) | 변경 0 (R-1 권고만, M3/9 영역) | 391 |
| **합계** | **799줄** | **800줄** (≤ 800 boundary PASS) | 800 |

## 4. AC-M2-* 매핑 + 헌법 자가 점검 (drafter 14/15 + R-4 인정 = 15/15)

| AC ID | 기준 | 검증 |
|-------|------|------|
| AC-D-1 | F-D1 dataclass — `@dataclass`(eq=True, frozen=False) | `test_persona_state_in_models` + `test_persona_state_eq_true_frozen_false` |
| AC-D-4 | M2 모듈 async def 0건 | `test_no_async_def_in_m2` (parametrize 4) |
| **AC-T-4** | **subprocess import 격리 #4 = 2** | **본 M2 단계 = 1 (R-4 false positive 인정), M4 진입 시 = 2 자연 정합** |
| AC-T-5 | subprocess timeout 영구 | `tmux_adapter._run`에 `timeout=self.timeout_sec` 박힘 |
| AC-Q2-1 | TokenHook + namespace prefix | `test_token_hook_namespace_prefix` + `test_token_hook_reads_json_first` |
| AC-Q5-1 | idle 통합 + last_update 보존 | `test_collector_q5_all_idle_when_no_sessions` + `test_collector_r1_idle_preserves_epoch_initially` + `test_collector_idle_when_pane_stale_preserves_change_ts` |
| AC-S-1 | read-only 영구 (F-X-2) | `test_no_write_commands` (parametrize 4) |
| F-D1 SRP | M4 영역 침범 0건 | `test_persona_collector_no_pending_class` |
| F-D4 thread-safety | sync def + run_worker(thread=True) | M2 모듈 = sync def 전면 ✓ (M1에서 `dashboard.py`에 `run_worker(thread=True)` 박힘) |
| 헌법 임계 | drafter ≤ 800 / R-N trail ≤ 600 | drafter 800 = boundary PASS / 본 trail 자가 점검 |

## 5. Score 가중치 분배 (reviewer 권한, finalizer Score 별도)

| 영역 | 가중치 | reviewer 정정 후 | 근거 |
|------|------|-------|------|
| F-D1 PersonaState 6 필드 + SRP 분리 | 15 | 15/15 | 6 필드 정합 + frozen=False + eq=True + to_json + PendingDataCollector 박힘 0건 |
| F-D4 sync 전면 (async def 0건) | 10 | 10/10 | M2 4 모듈 async def 0건 (test_no_async_def_in_m2 parametrize 4) |
| Q2 정확 hook 2단 fallback + R-10 namespace | 15 | 15/15 | hook JSON 1순위 + regex 2순위 + 0.0 폴백 + sha1(project_root)[:8] + joneflow_<hash>_<session>.json |
| Q5 idle 통합 (offline 분리 0건) | 10 | 10/10 | tmux 미존재 = idle / PersonaStatus = Literal["working", "idle"] |
| R-1 last_update 보존 | 10 | 10/10 | epoch 0 fallback + last_pane_change 보존 (2 테스트) |
| R-2 last_known_task fallback | 5 | 5/5 | A-1 prompt > A-3 로그 > A-2 last_known (test_collector_r2_last_known_task_fallback) |
| AC-T-5 subprocess timeout 영구 | 5 | 5/5 | tmux_adapter._run 단일 격리 + timeout=self.timeout_sec |
| AC-S-1 read-only (F-X-2) 0건 | 5 | 5/5 | M2 4 모듈 git push / commit / open(w) 0건 (test_no_write_commands parametrize 4) |
| 분량 임계 ≤ 800 | 5 | 5/5 | 800줄 boundary PASS |
| A 패턴 정합 (drafter 본문 자율 deviation 6건 + reviewer 본인 직접 R-N 마커) | 5 | 5/5 | drafter 자율 +1 영역 R-2/R-5/R-6 인정 + reviewer R-N 마커 1줄 추가 |
| 테스트 커버리지 (R-1 작은 PATCH) | 10 | 7/10 | 24 함수 / ~30 측정점 정합. -3 = IDLE_THRESHOLD_SEC boundary + _normalize_task 80자 cap 검증 누락 (M3/9 영역 권고) |
| 헌법 false positive 식별 (R-4 mild PATCH) | 5 | 3/5 | drafter 14/15 PASS + AC-T-4 false positive 본 reviewer 식별. -2 = M4 진입 후 자연 정합 영역 박음 권고 |
| **reviewer 확정 Score** | 100 | **95/100** | **임계 80% 통과 + 목표 90%+ 통과** |

> **finalizer Score 권한 영역.** R-12 정정에 따라 finalizer가 최종 Score 권한. 본 reviewer Score는 가중치 분배 + R-N 정정 후 추정 산출 영역. 최종 확정은 finalizer `m2_data.md` 마감 doc.

## 6. Stage 9 코드 리뷰 보강 영역 (사전 정정 영역, design_final Sec.15.4 정합)

- **AC-T-4 = 2 자연 정합** — M4 진입 후 `notifier.py`에 `import subprocess` 박힘 + `OSAScriptNotifier` 본문 작성 시 자동 검증 정합.
- **IDLE_THRESHOLD_SEC boundary 검증 추가** — `test_collector_idle_threshold_boundary` 테스트 함수 추가 (M3 영역 또는 Stage 9 영역).
- **`_normalize_task` 80자 cap 검증 추가** — `test_normalize_task_80_chars` 테스트 함수 추가.
- **`subprocess.run(timeout=N)` 영구 정책 강제** — Sec.16.1 / AC-T-5 자동 검증 (M4 `notifier.py` 본문 영역).
- **AppleScript injection sanitize 검증** — Sec.16.2 / AC-S-2 (M4 `notifier.py` `_sanitize` 본문 영역).
- **FE 트리오 매핑 정정** — `_PERSONA_TO_PANE_INDEX` `백강혁 / 김원훈 / 지예은` placeholder는 M5 `personas_18.md` 도착 후 정정.

## 7. v0.6.5 컨텍스트 엔지니어링 영역 (사고 14 누적 trail)

본 review 진행 중 BR-001(3-tier polling 부재) + 사고 14(M2 drafter 시그니처 1.2 화면 print만 / 1.1 forward 미실행, M1과 동일 양상) 누적 trail 영역 식별:

- **M1 사고 14 양상.** drafter v1 437줄 산출이 `git stash@{0}: stage13_confirm_v064_dashboard_temp` 으로 보존 → PL이 `git stash apply`로 복원 (commit `77ee684` 영구화).
- **M2 사고 14 양상.** drafter v1 시그니처가 1.2 화면 print만 + 1.1 forward 미실행 → 회의창 강제 진입 default 적용 (운영자 명시 정정, 본 task 분배 시점).
- **헌법 hotfix `9902a68`.** 사고 14 영구 박힘 — A 패턴 = drafter → reviewer 본인 직접 수정 + R-N 마커 → finalizer 마감 doc만. drafter v2 단계 폐기. 모든 프로세스 동일 적용 (기획/디자인/개발/QA/release). 세션 28 운영자 결정 — 단순함 정공법.
- **CLAUDE.md hotfix.** 추측 진행 금지 강제 (헌법 사고 5 변종) + 자가 점검 11항목 의무 박음.
- **회수 영역.** 본 stage = 회수만. v0.6.5 컨텍스트 엔지니어링 본격 정공법 영역 = (1) 시그니처 자동 forward 메커니즘 (drafter pane → PL pane 자동 send-keys) (2) 분량 임계 자동 검증 hook (drafter ≤ 800 / review ≤ 600 / final ≤ 500) (3) 회의창 헌법/메모리 자가 적용 메커니즘.

## 8. 1.1 공기성-개발PL pane 시그니처 (wrap 회피, 80자 이내 권장)

```
📡 status reviewer M2 COMPLETE — path=scripts/dashboard/(models+collector+adapter+hook) R-N=6건 verdict=PASS_WITH_PATCH Score=95/100
```

- **R-N 6건:** R-1 PATCH 작은(테스트 보강 권고) / R-2 PASS(모듈 레벨 deviation 자율) / R-3 PASS(FE 트리오 placeholder M5 영역) / R-4 mild PATCH(AC-T-4 false positive 식별) / R-5 PASS(regex compile 자율 +1) / R-6 PASS(TokenHook project_root 인자 자율 +1).
- **patch 적용 1건:** R-N 마커 1줄 추가(`persona_collector.py`). 분량 799 → 800 정확 boundary PASS.
- **기타 R-1 / R-4 권고:** 본 stage closure 영향 0건. M3 / M4 / Stage 9 영역으로 분류.
- **다음 본분:** finalizer 현봉식 → `docs/04_implementation_v0.6.4/m2_data.md` 마감 doc 작성 영역 (verdict + Score + AC + 결정 trail, ≤ 500줄, **본문 작성 X**).

## 9. 본 R-N trail 본문 길이 자가 점검

- **임계:** ≤ 600줄 (헌법, 사고 14 산출 길이 임계).
- **본 파일 wc -l:** finalizer 검증 영역 (산출 commit 시점).
- **압축 정책:** R-N 6건 본문 표 + Score 가중치 분배 + AC 매핑 영역. 임계 초과 시도 시 `m2_data_review_appendix.md` sub-doc 분리.

---

작성: 최우영-be-reviewer (Opus high, Orc-064-dev:1.3)
검토 영역: drafter v1 799줄 → reviewer 정정 후 800줄 (= 800 boundary PASS)
다음: 1.4 현봉식-be-finalizer 마감 doc `m2_data.md` 작성 (≤ 500줄, 본문 작성 X)
