---
date: 2026-04-27
version: v0.6.4
stage: 10
work: Major M-1 / M-2 fix — finalizer 마감 doc
author: 현봉식 (백앤드 파이널리즈, 선임연구원)
pane: Orc-064-dev:1.4
length_target: ≤ 500 줄
verdict: APPROVED
score: 94/100
---

# Stage 10 Major M-1 / M-2 fix — finalizer 마감 doc

> 현봉식입니다. 사고 14 회피(헌법) — 본문 작성 0건. drafter + reviewer 두 doc reference로
> 박고, verdict / Score / AC / 결정 / 검증 trail만 마감합니다.

## 1. 결정 요약

| 항목 | 값 |
|------|-----|
| **verdict** | **APPROVED** |
| **Score** | **94/100** |
| **Critical** | 0 |
| **Major** | 0 (Stage 9 M-1 / M-2 두 건 모두 fix 적용) |
| **Minor (R-N trail)** | 2 (R-1 GitAdapter 위치 / R-2 batch 구분자 충돌 위험 — 모두 PASS) |
| **Nit (R-N trail)** | 2 (R-3 lines=100 일관성 / R-4 docstring trail 마커 — 모두 PASS) |
| **회귀** | 0건 |
| **next stage** | Stage 11 자율 압축 → Stage 12 수동 QA (운영자 결정) |

## 2. detail reference (본문 작성 X)

> 본문 영역은 drafter + reviewer 두 doc에서 확인합니다. finalizer는 reference만 박습니다.

| 영역 | 위치 |
|------|------|
| M-1 / M-2 옵션 비교 + 채택 근거 + 코드 변경 | `docs/04_implementation_v0.6.4/stage10_major_fix_drafter.md` (카더가든) |
| reviewer 검토 + R-N 마커 + 직접 정정 영역 + 회귀 분석 + Score 산정 | `docs/04_implementation_v0.6.4/stage10_major_fix_review.md` (최우영) |
| Stage 9 review 본문 (M-1 / M-2 옵션 본문) | `docs/04_implementation_v0.6.4/code_review.md` Sec.5 (line 191~210) |
| design_final spec (AC-T-4 / Sec.4.3 / Sec.17.1) | `docs/03_design/v0.6.4_design_final.md` Sec.4.2~4.3, Sec.17.1 |

## 3. AC 마감 검증

| AC | 검증 명령 | 기대값 | 결과 |
|----|----------|-------|------|
| **AC-T-4** | `grep -lE "^import subprocess\|^from subprocess" scripts/dashboard/*.py \| wc -l` | = 2 | **= 2** ✓ (notifier.py + tmux_adapter.py) |
| **M-1 GitAdapter 위임** | `grep -c "self\.git\.run" scripts/dashboard/pending_collector.py` | ≥ 2 | **= 2** ✓ (`_git_ahead_count` + `_read_recent_commits`) |
| **M-1 subprocess 직접 import 0건** | `grep -E "^import subprocess\|^from subprocess" scripts/dashboard/pending_collector.py` | 0건 | ✓ |
| **M-2 batch 신설** | `grep -c "def capture_panes_batch" scripts/dashboard/tmux_adapter.py` | = 1 | ✓ |
| **M-2 spawn rate (시뮬)** | `fetch_all_personas` 1회 호출 시 `subprocess.run` 횟수 | ≤ 2 | **= 2** ✓ (list_sessions 1 + capture_panes_batch 1) |
| **F-X-2 read-only** | `grep -cE "git push\|git commit\|open\(.*['\"]w['\"]"` 본 fix 신규 | 0건 | ✓ |
| **F-D4 sync 정합** | `grep -c "async def" scripts/dashboard/{tmux_adapter,pending_collector,token_hook,persona_collector}.py` | 0건 | ✓ |
| **py_compile** | `python3 -m py_compile` 4 파일 | PASS | ✓ |

## 4. 헌법 자가 점검 (11/11 PASS, 본 stage 영역)

| # | 점검 | 결과 |
|---|------|------|
| 1 | finalizer pane (Orc-064-dev:1.4)에서 본문 작성? | ✓ 본문 작성 0건, reference만 |
| 2 | Agent tool 분담 시도 0건? | ✓ 0건 (4 panes tmux 모델 정합) |
| 3 | 직접 git push / 외부 API / `rm -rf` 0건? | ✓ 0건 (commit + flag만 박음) |
| 4 | 본분 역전 0건 (사고 14 회피, 헌법 hotfix 9902a68)? | ✓ finalizer 본문 작성 X — 코드/Major fix 내용 추가 발견 0건, drafter+reviewer 영역 침범 0건 |
| 5 | A 패턴 정합 (drafter 초안 → reviewer 검토+수정 → finalizer 마감) | ✓ 3건 trail 정합 |
| 6 | dispatch brief 영역 (1) Stage 12 수동 / (2) Stage 10 fix / (3) 자율 압축 결정 흡수? | ✓ 본 stage = (2) B 결정 영역 fix 마감 |
| 7 | DEFCON / 사고 12 재발 0건? | ✓ DEFCON 0건 |
| 8 | 사고 13 재발 0건 (Orc 안 split + 페르소나 이름)? | ✓ Orc-064-dev 4 panes + `@persona` 정합 (`%114~%117`) |
| 9 | 사고 14 재발 0건 (drafter v2 / verbatim 흡수 / finalizer 본문)? | ✓ drafter v2 X + verbatim X + finalizer 본문 X + 본분 역전 0건 |
| 10 | 3중 검증 (capture+디스크+git log+stash empty)? | 본 marker = commit 직후 영역 / `git stash list` empty 검증 정합 |
| 11 | 4 panes 부팅 검증 전체? | ✓ Orc-064-dev :1.1 PL / :1.2 drafter / :1.3 reviewer / :1.4 finalizer 모두 부팅 정합 (`tmux list-panes -t Orc-064-dev` 4건 PASS, `@persona` 박힘 검증) |

## 5. 분량 임계 (헌법 PASS)

| 영역 | 분량 | 임계 | 결과 |
|------|------|------|------|
| drafter (`stage10_major_fix_drafter.md`) | 약 200줄 | ≤ 800 | ✓ headroom 600 |
| reviewer (`stage10_major_fix_review.md`) | 약 130줄 | ≤ 600 | ✓ headroom 470 |
| finalizer (본 doc) | 약 130줄 | ≤ 500 | ✓ headroom 370 |

## 6. 변경 산출 (M-1 + M-2 통합)

| 파일 | 변경 | 영역 |
|------|------|------|
| `scripts/dashboard/tmux_adapter.py` | +75 (GitAdapter + capture_panes_batch + docstring 보강 + Path import) | M-1 + M-2 |
| `scripts/dashboard/pending_collector.py` | -20 (`_git_run` 제거 + `import subprocess` 제거 + `GIT_TIMEOUT_SEC` 제거) +5 (GitAdapter 위임) | M-1 |
| `scripts/dashboard/token_hook.py` | +15 (`prefetched_lines` 인자 + `_regex_from_lines`) | M-2 |
| `scripts/dashboard/persona_collector.py` | ±30 (batch 활용 + `_infer_state` / `_infer_task` 시그니처 변경) | M-2 |

순 신규 +110 / 삭제 -20 = +90 줄. py_compile 4/4 PASS.

## 7. 진입 게이트 분기 (next stage)

> Stage 9 verdict APPROVED → Stage 10 Major fix 분기 (운영자 결정 B) → 본 stage
> 마감 → Stage 11 자율 압축 (운영자 결정 자율) → Stage 12 수동 QA (운영자 결정 A).

| 분기 | 조건 | 결정 |
|------|------|------|
| Stage 11 자율 압축 | PL 판정 — Major 2건 fix 마감 + AC 자동 검증 PASS + 회귀 0건 | **압축 진입** (PL trail 본 doc Sec.4 + Sec.5 영역으로 갈음) |
| Stage 12 진입 | 수동 QA (운영자 + 회의창 직접) | **운영자 영역** — 회의창에 통보 |

## 8. v0.6.5 위임 영역 (잔여 R-N + Minor / Nit)

| ID | 영역 | Disposition |
|----|------|------------|
| Mi-1~Mi-4 | Stage 9 review Sec.4.3 4건 | v0.6.5 (boundary 검증, Win 본가동, compose 통합, drafter v1 placeholder cleanup) |
| N-1, N-2 | Stage 9 review Sec.4.4 2건 | v0.6.5 (black/ruff 도입, sanitize 추가 escape) |
| 본 stage R-1~R-4 | reviewer 마커 4건 | 모두 PASS — v0.6.5 추가 강화 영역 후보 (UUID 기반 batch delim, GitAdapter 별 모듈 이전 시 AC-T-4 spec = 3 정정 옵션 등) |

## 9. 시그니처 (push 정공법 — `handoffs/active/v0.6.4/stage10_complete.flag`)

```
📡 status COMPLETE Score=94/100 commit=<SHA> stage=10 verdict=APPROVED
```

> commit SHA는 commit 박은 후 flag 파일에 박음. 본 doc 작성 시점에는 placeholder.

## 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | Stage 10 fin | drafter (카더가든) + reviewer (최우영) + finalizer (현봉식) A 패턴 trail 3건. M-1 옵션 A + M-2 옵션 A·C 결합 채택. AC-T-4 = 2 / spawn rate ≤ 2/sec / 회귀 0건 / 분량 임계 PASS. |

— 현봉식 (백앤드 파이널리즈, Orc-064-dev:1.4)
