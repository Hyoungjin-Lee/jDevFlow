---
date: 2026-04-27
version: v0.6.4
stage: 10
work: Major M-1 / M-2 fix — reviewer 검토 + 직접 수정
author: 최우영 (백앤드 리뷰어, 책임연구원)
pane: Orc-064-dev:1.3
length_target: ≤ 600 줄
verdict: APPROVED
---

# Stage 10 Major M-1 / M-2 fix — reviewer 검토

> 최우영입니다. 카더가든 drafter 초안 + 본인이 직접 검토한 코드 영역 정합 확인했습니다.
> R-N 마커 trail + 직접 정정 영역 박고 finalizer 현봉식에 인계합니다.
> verdict = **APPROVED** / Score = **94/100**.

## 1. 검토 범위

| 영역 | 산출 | 검토 결과 |
|------|------|----------|
| drafter 본문 (`stage10_major_fix_drafter.md`) | 약 200줄 (≤ 800) | A 패턴 정합, 옵션 비교 + 채택 근거 명확 |
| `tmux_adapter.py` GitAdapter + capture_panes_batch | +75줄 영역 | 모듈 경계 #4 정합, 시그니처 적절 |
| `pending_collector.py` subprocess 격리 | -20줄 (`_git_run` 제거) | AC-T-4 = 2 유지 정합 |
| `token_hook.py` prefetched_lines | +15줄 | 기존 시그니처 호환 (Optional default None) |
| `persona_collector.py` batch 활용 | ±30줄 | `_infer_task` 시그니처 변경 — 호출자 단일(`_infer_state`)만 modify, 회귀 0건 |

## 2. R-N 마커 trail (4건, Critical 0 / Major 0 / Minor 2 / Nit 2)

### R-1 (Minor): GitAdapter 위치 — drafter 채택 그대로 정합

- **카더가든 drafter 권고 = (1) `tmux_adapter.py` 내 위치**
- **검토:** 별도 `git_adapter.py` 파일 분리 시 모듈 수 +1 (AC-T-4 = 3) → spec 위반
  영역 다시 발생. 한 파일 안 두 클래스(`TmuxAdapter` + `GitAdapter`)는 SRP 미세
  위반이지만, 모듈 경계 #4 (subprocess 격리) spirit이 우선. drafter 판정 정합.
- **정정:** docstring 첫 줄 "tmux subprocess 격리 layer" → "tmux + git subprocess
  격리 layer"로 의도 명시 (이미 drafter 코드에 박힘). PASS.

### R-2 (Minor): capture_panes_batch 구분자 충돌 위험

- **drafter 식별:** "구분자 충돌 가능성 (저확률)"
- **검토:** `_BATCH_DELIM = "<<<JONEFLOW_PANE_DELIM>>>"` — 30자 ASCII. tmux pane
  실제 출력에 동일 문자열이 등장할 확률 = 거의 0 (jOneFlow 내부 식별자 + brackets).
  추가로 `len(line) > 2 * len(_BATCH_DELIM)` 검증 + `pane_id ∈ panes` 검증
  (`current in out`) 박혀 있어서 충돌 시에도 안전 fallback (해당 line buffer로 흡수).
- **결정:** 추가 강화 불필요. v0.6.5+ 영역 (UUID 또는 sha hash 기반 delim 옵션 있으나
  현 spec에 충분).

### R-3 (Nit): lines=100 일관성 — drafter 권고 반영

- **drafter 식별:** "lines=100 일관성 (token regex 100 + task 50 superset)"
- **검토:** `_infer_task` 영역 `scan_lines = last_lines[-50:] if len(last_lines) > 50
  else last_lines` slice 박혀 있어 기존 50줄 effective window 정합. token_hook은
  100줄 그대로 사용. PASS.

### R-4 (Nit): docstring 영역 "Stage 10 M-1 fix" / "Stage 10 M-2 fix" 마커 박음

- **검토:** `tmux_adapter.py` / `pending_collector.py` / `token_hook.py` /
  `persona_collector.py` 4 파일 모두 docstring + 메서드 docstring에 "Stage 10 M-N
  fix" 마커 박힘. trail 추적 가능 — 다음 stage / v0.6.5 진입 시 영역 식별 용이.
- **정정:** 0건. 그대로 PASS.

## 3. 직접 수정 영역 — 0건

drafter 초안 코드 + 적용 본문 모두 정합 — 직접 정정 0건. R-N 마커 영역(R-1~R-4)
모두 drafter 본문 그대로 PASS. 본 stage = 단순 fix 영역으로 reviewer 정정 권한
사용 0건은 정상 (사고 14 회피 trail = drafter 본문 그대로 흡수가 아니라, drafter
본문이 검토 통과했다는 의미).

## 4. AC 검증 (Stage 9 review M-1 / M-2 영역만)

| AC | 검증 | 결과 |
|----|------|------|
| **AC-T-4** spec = 2 | `grep -lE "^import subprocess" scripts/dashboard/*.py \| wc -l` | **= 2** ✓ (notifier.py + tmux_adapter.py) |
| **M-1 옵션 A 채택 정합** | `pending_collector.py`에 `_git_run` 메서드 0건 + `self.git.run` 호출 2건 | ✓ |
| **M-2 spawn rate** | 시뮬 `fetch_all_personas` 1회 호출 시 `subprocess.run` 호출 횟수 | **= 2** (list_sessions 1 + capture_panes_batch 1) ✓ |
| **M-1 GitAdapter sync 인터페이스** | `async def` 0건 / F-D4 정합 | ✓ |
| **M-2 batch 부수효과 정합** | `_update_change_cache` 호출 — pane signature 갱신 정합 | ✓ |
| **F-X-2 read-only** | `git push|git commit|open\(.*['\"]w['\"]"` grep 본 fix 신규 0건 | ✓ |

## 5. 헌법 자가 점검 (5/5 PASS, 본 stage 영역 한정)

| # | 점검 | 결과 |
|---|------|------|
| 1 | A 패턴 정합 (drafter 초안 → reviewer 검토 + 정정 → finalizer 마감) | ✓ 본 doc = reviewer 영역 |
| 2 | drafter v2 단계 X / verbatim 흡수 X | ✓ drafter 본문 그대로 흡수 0건, R-N 마커만 trail |
| 3 | finalizer 본문 작성 X (사고 14 회피) | ✓ finalizer 진입 전 영역, 마감 doc 본문 작성 강제 X |
| 4 | 분량 임계 (drafter ≤ 800 / reviewer ≤ 600 / finalizer ≤ 500) | ✓ drafter 약 200, reviewer 본 doc 약 130 |
| 5 | py_compile 검증 PASS | ✓ 4/4 파일 정합 |

## 6. 회귀 분석

| 영역 | 검토 |
|------|------|
| `pending_collector.PendingDataCollector.__init__` 시그니처 | `git: Optional[GitAdapter] = None` 추가 — 기존 호출자 영향 0건 (kwargs default) |
| `token_hook.TokenHook.get_tokens_k` 시그니처 | `prefetched_lines: Optional[list] = None` 추가 — 기존 호출자 (자체 fallback) 영향 0건 |
| `persona_collector._infer_state` 시그니처 | `pane_lines` 인자 추가 — 호출자 단일(`fetch_all_personas`)만 modify, 외부 영향 0건 |
| `persona_collector._infer_task` 시그니처 | `pane_name` → `last_lines` (Optional[List[str]]) 변경 — 호출자 단일(`_infer_state`)만 modify, 외부 영향 0건 |
| 기존 dashboard 모듈 외부 호출 | `dashboard.py` / `render.py` 등에서 `fetch_all_personas()` / `get_pending_pushes()` 그대로 호출 — 시그니처 동일 PASS |

회귀 0건 ✓.

## 7. Score 산정 (94/100)

| 영역 | 점수 | 근거 |
|------|------|------|
| AC 정합 (M-1 + M-2) | 30/30 | 옵션 A·C 채택 정합 + 시뮬 측정값 정확 |
| 모듈 경계 정합 (AC-T-4) | 25/25 | subprocess import 2건 spec 정합 |
| 회귀 0건 | 20/20 | 시그니처 호환 유지 + 호출자 modify 영역 단일 |
| A 패턴 정합 (사고 14 회피) | 15/15 | drafter v2 X + verbatim X + finalizer 본문 X |
| 분량 임계 | 5/5 | drafter ~200 + reviewer ~130 (≤ 800/600 PASS) |
| docstring trail 마커 | 4/5 | 마커 박힘 정합. -1 = `dashboard.py` 메인 모듈에 본 fix 인지 주석 0건 (영향 0건이라 nit). |

**Score = 94/100. verdict = APPROVED.**

## 8. finalizer 인계

- M-1 / M-2 fix 정합 검증 모두 박았습니다. 현봉식 finalizer가 마감 doc(verdict +
  Score + AC + 결정 + 본문 작성 X) 작성 부탁드립니다.
- 본 reviewer doc + drafter doc 두 건 reference만 박고, finalizer 본문 작성은
  사고 14 영구 회피 영역(헌법) 정합 부탁드립니다.

— 최우영 (백앤드 리뷰어, Orc-064-dev:1.3)
