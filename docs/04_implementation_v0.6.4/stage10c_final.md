---
date: 2026-04-27
version: v0.6.4
stage: 10c
work: dashboard.py 이름 충돌 fix — finalizer 마감 doc
author: 현봉식 (백앤드 파이널리즈)
pane: Orc-064-dev:1.4
length_target: ≤ 500 줄
verdict: APPROVED
score: 96/100
---

# Stage 10c — 이름 충돌 fix finalizer 마감 doc

> 현봉식입니다. 사고 14 회피(헌법) — 본문 작성 0건. drafter + reviewer 두 doc reference로
> 박고, verdict / Score / AC / 결정 / 검증 trail만 마감합니다.

## 1. 결정 요약

| 항목 | 값 |
|------|-----|
| **verdict** | **APPROVED** |
| **Score** | **96/100** |
| **release blocker** | **닫힘** (실제 실행 ModuleNotFoundError 0건 + widget 본문 표시 PASS) |
| **검증 게이트 강제 (운영자 영역)** | **PASS** — PL 본인이 직접 `venv/bin/python3 scripts/run_dashboard.py` 실행해서 19명 박스 본문 표시 확인 후 commit |
| **Stage 9 / Stage 10b 패턴 (점수만 통과 / 진짜 동작 검증 누락) 회피** | ✓ 본 stage trail에 실제 실행 + textual run_test widget 검증 박힘 |
| **Critical** | 0 |
| **Major** | 0 |
| **Minor (R-N trail)** | 2 (R-1 _render rename / R-2 width: 1fr — 모두 PASS) |
| **Nit (R-N trail)** | 2 (R-3 sys.path idempotent / R-4 __init__.py empty — 모두 PASS) |
| **회귀** | 0건 |
| **next stage** | Stage 11 자율 압축 → Stage 12 수동 QA |

## 2. detail reference

| 영역 | 위치 |
|------|------|
| 이름 충돌 fix 본문 + sys.path 조정 + 추가 발견 fix 2건 + 검증 결과 | `docs/04_implementation_v0.6.4/stage10c_drafter.md` (카더가든) |
| reviewer 검토 + R-N 마커 + 회귀 분석 + Score 산정 | `docs/04_implementation_v0.6.4/stage10c_review.md` (최우영) |
| dispatch brief | `dispatch/2026-04-27_v0.6.4_stage10c_name_collision_fix.md` |

## 3. AC 마감 검증 (release blocker 닫음 영역)

| AC | 검증 | 결과 |
|----|------|------|
| **이름 충돌 해소** | `git ls-files scripts/run_dashboard.py` ≥ 1 + `git ls-files scripts/dashboard.py` = 0 | ✓ |
| **`scripts/__init__.py` 신규** | 파일 존재 + py_compile PASS | ✓ |
| **sys.path PROJECT_ROOT idempotent** | 코드 리뷰 정합 | ✓ |
| **`.claude/commands/dashboard.md` 정정** | `scripts/run_dashboard.py` 매치 ≥ 1 + 구 경로 매치 0 | ✓ |
| **py_compile** | 3 파일 (`__init__.py` + `run_dashboard.py` + `pending_widgets.py`) PASS | ✓ |
| **실제 실행 (subprocess + SIGTERM)** | ModuleNotFoundError 0건 / LayoutError 0건 / TypeError 0건 (stderr clean) | ✓ |
| **textual run_test widget tree** | DashboardRenderer + PendingArea + 3 TeamRenderer + PMStatusBar + PendingPushBox + PendingQBox | ✓ 6/6 |
| **19명 박스 본문 표시 (운영자 검증 게이트)** | 4팀 15명 + PM 1 = 16 visible + 미표시 placeholder 3 = 19 | ✓ |
| **진행률 바 + 스파크라인** | 박스 본문 sample에 8칸 진행률 + 8칸 스파크라인 표시 | ✓ |
| **Pending Push / Pending Q 박스 본문 표시** | placeholder 또는 항목 본문 표시 | ✓ |
| **Stage 10 M-1/M-2 fix 보존** | AC-T-4 = 2 + persona_collector batch | ✓ |
| **Stage 10b wiring 본문 보존** | run_dashboard.py wiring 본문 = a891d97 그대로 + sys.path 조정만 | ✓ |
| **F-X-2 read-only** | 본 fix 신규 git push / commit / open(w) 0건 | ✓ |

## 4. 헌법 자가 점검 (11/11 PASS)

| # | 점검 | 결과 |
|---|------|------|
| 1 | finalizer pane (Orc-064-dev:1.4)에서 본문 작성? | ✓ 본문 작성 0건 |
| 2 | Agent tool 분담 0건? | ✓ |
| 3 | 직접 git push / 외부 API / `rm -rf` 0건? | ✓ |
| 4 | 본분 역전 0건 (사고 14)? | ✓ |
| 5 | A 패턴 정합 | ✓ drafter ~200 + reviewer ~150 + finalizer 본 doc |
| 6 | dispatch brief 흡수 (운영자 결정 가)? | ✓ rename + `__init__.py` + 명령 정정 |
| 7 | DEFCON 0건? | ✓ |
| 8 | 사고 13 재발 0건 (Orc 안 split + 페르소나)? | ✓ Orc-064-dev :1.1~1.4 정합 |
| 9 | 사고 14 재발 0건 | ✓ |
| 10 | 3중 검증 (capture+디스크+git log+stash empty) | commit 시점 영역 — `git stash list` empty 검증 정합 |
| 11 | **검증 게이트 강제 통과 (운영자 영역)** | ✓ **Stage 9 / Stage 10b 패턴 회피** — PL 직접 실행 + widget 본문 표시 검증 PASS 후 commit |

## 5. 분량 임계 (헌법 PASS)

| 영역 | 분량 | 임계 | 결과 |
|------|------|------|------|
| drafter (`stage10c_drafter.md`) | ~200 | ≤ 800 | ✓ |
| reviewer (`stage10c_review.md`) | ~165 | ≤ 600 | ✓ |
| finalizer (본 doc) | ~120 | ≤ 500 | ✓ |

## 6. 변경 산출

| 파일 | 변경 |
|------|------|
| `scripts/dashboard.py` → `scripts/run_dashboard.py` | git mv (rename) |
| `scripts/run_dashboard.py` | +9줄 (sys.path 조정 + import os/sys + docstring 갱신) |
| `scripts/__init__.py` | 신규 5줄 (docstring) |
| `scripts/dashboard/pending_widgets.py` | +2줄 (width: 1fr × 2) + rename `_render*` → `_format_*` (4 매치) |
| `.claude/commands/dashboard.md` | 진입 명령 + 본문 정정 |
| `docs/04_implementation_v0.6.4/stage10c_*.md` | 신규 3건 (drafter + reviewer + finalizer) |
| `dispatch/2026-04-27_v0.6.4_stage10c_name_collision_fix.md` | 신규 (PL 진입 brief) |
| `handoffs/active/v0.6.4/stage10b_complete.flag` | 기존 (Stage 10b 영역) |

## 7. 진입 게이트 분기

> Stage 10 16def78 (M-1/M-2 fix) → Stage 10b a891d97 (wiring 통합) → Stage 10c (이름
> 충돌 fix + 검증 게이트 강제 통과) → Stage 11 자율 압축 → Stage 12 수동 QA.

| 분기 | 결정 |
|------|------|
| Stage 11 자율 압축 | **압축 진입** (PL trail 본 doc Sec.3·4로 갈음) |
| Stage 12 진입 | **운영자 영역** — 회의창 통보 후 운영자가 직접 `venv/bin/python3 scripts/run_dashboard.py` 실행 시각 검증 |

## 8. v0.6.5 위임 영역

| ID | 영역 | Disposition |
|----|------|------------|
| R-N 잔여 | history 영역 docs/dispatch md 경로 정정 (~10건) | v0.6.5 (필수 X) |
| 권고 | `pyproject.toml` + editable install | v0.6.5 (sys.path 조정 정공법 + editable은 별 영역) |
| 권고 | textual reserved 명 자가 검출 hook | v0.6.5 (drafter v1 layout 영역 사전 인지 부재 회피) |
| Stage 10/10b 잔여 | Mi-1~Mi-4 + N-1~N-2 + 본 stage R-N 4건 | v0.6.5 |

## 9. 시그니처 (push 정공법 — `handoffs/active/v0.6.4/stage10c_complete.flag`)

```
📡 status COMPLETE Score=96/100 commit=<SHA> stage=10c verdict=APPROVED
```

## 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | Stage 10c fin | drafter + reviewer + finalizer A 패턴 trail 3건. dashboard.py 이름 충돌 fix (rename `run_dashboard.py` + `__init__.py` + sys.path 조정 + 진입 명령 정정 + width: 1fr × 2 + `_render` rename). **검증 게이트 강제 통과** = PL 직접 실행 + textual run_test widget tree 본문 표시 PASS (Stage 9 / Stage 10b 패턴 회피). 회귀 0건 / 분량 임계 PASS. |

— 현봉식 (백앤드 파이널리즈, Orc-064-dev:1.4)
