---
version: v0.6.3
stage: 9 (code_review)
date: 2026-04-27
authored_by: 최우영 (개발팀 백엔드 리뷰어, Opus/high, Orc-063-dev:1.3)
upstream:
  - Stage 8 commit chain — 5ac2e16 (M1+M4 critical) + 868de75 (M2+M3+M5 final) + ea2fd16 (잔존 + Stage 9~13 dispatch)
  - docs/03_design/v0.6.3_stage9_review_sketch.md (본인 사전 작성, 검토 포인트 20건)
  - docs/03_design/v0.6.3_design_final.md (Score 89.9%, AC 26 = 21자동 + 5수동)
related_br: docs/bug_reports/BR-002_codex_review_failure.md
mode: self-review (모드 B fallback) — 분기 trigger 인터페이스는 모드 A 매칭, plugin-cc 자동 호출은 v0.6.4 후속 (운영자 결정 #15, BR-002 trace)
session: 27
status: review
---

# jOneFlow v0.6.3 — Stage 9 코드 리뷰

> **상위:** Stage 8 commit chain (`5ac2e16` + `868de75` + `ea2fd16`)
> **본 문서:** `docs/04_implementation_v0.6.3/code_review.md`
> **하위:** Stage 10 (필요 시 패치) → Stage 11 verify → Stage 12 QA → Stage 13 release
> **상태:** ✅ **APPROVED — Score 잠정 89.8% / AC 회귀 0건 / 운영자 결정 영역 0건 / Stage 12 게이트 PASS**

---

## Sec. 0. 리뷰 개요 + 분기 판정 trace

### 0.0 fallback note (BR-002 trace)

**본 review = self-review fallback (모드 B).** Codex 자동 호출 보류 사유 = `docs/bug_reports/BR-002_codex_review_failure.md` 참조 (운영자 결정 #15 — v0.6.3 = conditional 인터페이스만 / plugin-cc 자동 호출 = v0.6.4 후속). 본 stage는 분기 인터페이스(F-62-8 모드 A) 동작 검증만 본문에 포함하고, actual review는 1.3 최우영(Opus/high) self-review로 진행한다. BR-002 = 백실장 BR 패턴 흡수 — 외부 API 자동 호출 권한 외 영역에서 발생하는 fallback 사유를 사고 trace로 영구 기록.

### 0.1 분기 판정 (모드 A 매칭 발견 → self-review 진행)

| 항목 | 결과 |
|------|------|
| Codex CLI 환경 감지 | ✅ 발견 (`/opt/homebrew/bin/codex`) |
| `.claude/settings.json` `stage_assignments.stage9_review` | ✅ `"codex"` 확인 |
| F-62-8 모드 A trigger 매칭 | ✅ 매칭 |
| **결정 진입 경로** | **self-review 진행 (모드 B fallback) — 운영자 결정 #15 흡수** |

**결정 근거 (trace):**
- 운영자 결정 #15 (plan_final F-9 / Q-NEW-1 / 운영자 회의창 자율 결정): **v0.6.3 = conditional 분기 인터페이스(로직)만 / plugin-cc 자동 호출 고도화 = v0.6.4 후속.**
- 외부 API 자동 호출은 본 stage 자율 권한 외 → 분기 인터페이스 동작 검증만 본 stage에 포함, actual review는 self-review 1.3 최우영(Opus/high) 진행.
- F-n3 (운영 정책) 계승: openai-codex CLI 직접 호출 금지, plugin-cc 슬래시 커맨드 안내만.

### 0.2 검토 범위

| 입력 | 결과물 |
|------|------|
| Stage 8 commit chain 3건 | 본 review 1건 (`code_review.md`) |
| sketch 20건 (MR1-1 ~ MR1-12 + MR4-1 ~ MR4-8) | cross-check 분류 표 (통과/보강/회귀) |
| AC 21건 (자동) | 회귀 검증 결과 |
| shellcheck 7개 스크립트 + py_compile | 정합 결과 |

### 0.3 종합 판정 잠정

- **verdict: APPROVED**
- **Score 잠정 89.8%** (Sec.6 상세)
- **AC 회귀 0건** (21/21 PASS)
- **shellcheck error 0** (warning 3 / info 9, gradual adoption Q3 정합)
- **운영자 결정 영역 0건**
- **보강 영역 9건 (v0.6.4 이월) + 회귀 1건 (chmod, 비차단)**

---

## Sec. 1. M1 cross-check (MR1-1 ~ MR1-12)

### 1.1 `scripts/monitor_bridge.sh` (신규, commit `5ac2e16`)

| MR# | 검토 포인트 | 결과 | 근거 (line / 명령) |
|-----|-----------|------|------------------|
| MR1-1 | signal injection 안전성 (printf vs echo) | 🟡 **보강** | l.49~50 입력 파싱은 `echo`, l.53 출력은 `printf '📡 status %s %s %s\n'` ✅. 입력 echo 시 ANSI escape 주입 가능성. 비차단. |
| MR1-2 | capture-pane 무한 루프 + sleep + trap | 🟡 **보강** | sleep ✅ (l.71 / l.99), `trap` 핸들러 부재. SIGTERM 정상 종료 처리 미구현. v0.6.4 이월. |
| MR1-3 | `-S -20` 범위 (F-62-7c) | ✅ **통과** | l.86 `tmux capture-pane -t "$target_session" -p -S -20`. design_final F-62-7c 정합. |
| MR1-4 | timestamp 함수 (F-62-7a) | 🟡 **보강** | l.37 `date +%Y-%m-%d\ %H:%M:%S` (back-slash escape). single quote 패턴(`date '+%Y-%m-%d %H:%M:%S'`) 권장. 동작 정상. |
| MR1-5 | stage 명시 (F-62-7b) | ✅ **통과** | `Stage` / `stage` 12회 매치. l.49 `grep -q "Stage [0-9]"` 정합. |
| MR1-6 | 환경 변수 fallback (Q1) | ✅ **통과** | l.25 `target_session="${TMUX_SESSION_BRIDGE:-bridge}"` 패턴 정합. |
| MR1-7 | chmod +x | ❌ **회귀(비차단)** | `-rw-r--r--` — 실행 권한 누락. 단 호출 패턴은 `bash scripts/monitor_bridge.sh`이므로 작동. 직접 `./monitor_bridge.sh` 호출은 실패. **Stage 10 패치 권고 (1줄: `chmod +x`).** |
| MR1-8 | shellcheck CLEAN | ✅ **통과** | error 0 / warning 0 / info 0 (개별 파일). gradual adoption Q3 정합. |

### 1.2 `scripts/update_handoff.sh` (개정 — Windows fallback)

| MR# | 검토 포인트 | 결과 | 근거 |
|-----|-----------|------|-----|
| MR1-9 | BSD/GNU sed 분기 (F-62-6) | 🟡 **v0.6.4 이월** | `sed --version` / `BSD` / `GNU` 모두 0 hits. F-62-6 본문 결정에 명시되었으나 본 commit chain에는 인터페이스만 진입. design_final Sec.5.2 sample 코드는 sketch 의도 (운영자 결정 #15). |
| MR1-10 | globbing 배열 안전성 | 🟡 **v0.6.4 이월** | `files=(...)` / `${files[0]}` 0 hits. design_review R-6 정정 영역이 본 stage 미진입. v0.6.4 후속. |
| MR1-11 | readlink 호환성 | 🟡 **v0.6.4 이월** | `readlink` 0 hits. Windows fallback 자체가 sketch 단계 (운영자 결정 #15). |

**보강 코멘트 (M1.2):** update_handoff.sh는 v0.3.0 (v0.6.2 산출물) 그대로. v0.6.3 Windows fallback 본문 결정(F-62-6)은 plan_final 결정 + design_final 결정 단계까지 명시되었으나, Stage 8 구현은 운영자 결정 #15 정책에 따라 **인터페이스 기록(F-62-6)만 진입 / 실 구현은 v0.6.4 후속**. AC M1-4(`grep -qiE "windows|fallback|copy|sync|DRY-RUN"`)는 case-insensitive `dry-run` 단어로 PASS — AC 자체가 인터페이스 진입 검증 수준. **AC 보강 영역으로 식별 (Stage 12 QA 또는 v0.6.4).**

### 1.3 `scripts/setup_tmux_layout.sh` (개정)

| MR# | 검토 포인트 | 결과 | 근거 |
|-----|-----------|------|-----|
| MR1-12 | Monitor 자동 재가동 hook 추가 | ✅ **통과** | l.76~89 "Monitor 자동 재가동 hook (M1 — F-62-7)" — `pgrep` / `pkill` / `bash scripts/monitor_bridge.sh &` 백그라운드 spawn. design_final M1 결정 정합. |

### 1.4 (M3 본인 작성) `scripts/hook_post_tool_use.sh`

본인 1.3 최우영이 직접 작성 (commit `868de75` + `5ac2e16`). 본 review 시점 self-검증 결과:
- 실행 권한 ✅ (-rwxr-xr-x)
- shellcheck CLEAN
- jq 우선 + grep fallback ✅
- exit 0 강제 ✅
- 본 review 영역 외 (자기 산출물). 단순 회귀 검증으로만 포함.

---

## Sec. 2. M4 cross-check (MR4-1 ~ MR4-8)

### 2.1 `scripts/spawn_team.sh` (신규, commit `5ac2e16`)

| MR# | 검토 포인트 | 결과 | 근거 |
|-----|-----------|------|-----|
| MR4-1 | F-62-9 `--dangerously-skip-permissions` 옵션 강제 | 🟡 **인터페이스만** | 4 hits (l.79/l.85/l.91 + 헤더). 그러나 모두 **주석 형태** (`# Stage 8 구현: ... + --dangerously-skip-permissions`). 실 `tmux split-window` + `claude` 호출 코드는 미진입. 운영자 결정 #15 정합 (v0.6.3 = 인터페이스만). |
| MR4-2 | pane title 강제 (`select-pane -T`) | 🟡 **인터페이스만** | l.6 헤더 주석에 명시. 실 호출 코드 미진입. v0.6.4 이월. |
| MR4-3 | sequential vs parallel spawn (Q4) | 🟡 **v0.6.4 이월** | mock 시뮬레이션 자체 미구현. design_final Sec.6.4 Q4 답변 = "Stage 8 mock 시뮬레이션 후 fallback 분기" → 본 stage 인터페이스만. |
| MR4-4 | 세션명 환경 변수 | 🟡 **부분 통과** | `TMUX_SESSION_BRIDGE` (M1) ✅, `TMUX_SESSION_ORC` 등 spawn_team 측은 hardcode. v0.6.4 환경변수화 권고. |

**MR4-1 ~ MR4-4 종합:** spawn_team.sh는 v0.6.3 단계에서 **함수 골격 + 주석 spec** 단계. 운영자 결정 #15 흡수 — 실 spawn은 v0.6.4 후속. 본 commit chain은 정합 (인터페이스 기록).

### 2.2 `scripts/ai_step.sh` Stage 9 분기 (commit `868de75`)

| MR# | 검토 포인트 | 결과 | 근거 |
|-----|-----------|------|-----|
| MR4-5 | `stage9_review` 키 파싱 안전성 (jq 우선) | ✅ **통과** | l.390 `jq -r '.stage_assignments.stage9_review // empty'`. design_review B2-3 권고 흡수 완료. |
| MR4-6 | jq 미설치 fallback | ✅ **통과** | l.389 `command -v jq` 검사 + l.394 grep+cut fallback. 본인 hook 동일 패턴. |
| MR4-7 | 미정 값 처리 | ✅ **통과** | l.402~414 case 분기 — `codex+available` / `codex+missing` / 기타 3분기. 미정 값(`""`) 시 self-review fallback + "(미설정)" 출력. |
| MR4-8 | settings.json 키 보존 (백업) | ✅ **통과** | `.claude/settings.json.bak.20260427` + `.bak.20260427-pre-m3` 2건 보존. |

---

## Sec. 3. 모드 A 분기 인터페이스 동작 검증

### 3.1 `bash scripts/ai_step.sh --status` 직접 실행

```
ai_step.sh — 현재 운영 상태:
  workflow_mode: desktop-cli
  team_mode:    claude-impl-codex-review
  stage_assignments:
    stage8_impl:    claude
    stage9_review:  codex   ← F-62-8 모드 A trigger 매칭
    stage10_fix:    claude
    stage11_verify: claude
```

### 3.2 `ai_step_stage9_review_route()` 함수 동작 시뮬

| 분기 조건 | 본 환경 | 출력 |
|---------|--------|------|
| `_as9_reviewer` 값 | `"codex"` (jq 추출 성공) | ✅ |
| `_as9_codex_available` | `1` (`/opt/homebrew/bin/codex` 발견) | ✅ |
| 매칭 분기 | "codex+available" → "Stage 9: Codex review 경로 활성화 (...)" 출력 + `/codex:review` 안내 + Stage 10 fix loop 안내 | ✅ |

**판정:** 모드 A 분기 인터페이스 **동작 정합**. design_final Sec.5.4 결정 + plan_final F-62-8 흡수 정합. 운영자 결정 #15에 따라 **실제 plugin-cc 호출은 본 stage에서 안내 메시지 출력만** (F-n3 계승).

### 3.3 fallback 시뮬 (codex CLI 가상 부재 시)

함수 본문 분석 결과:
- "codex+missing" 분기 → "stage9_review=codex 설정됐으나 codex CLI 미감지" 출력 + self-review 안내
- "기타" 분기 (`stage9_review` 미정/오타) → "Codex 환경 미감지" 출력 + 값 표시 + self-review 안내

**판정:** 3분기 모두 정합. 회귀 0건.

---

## Sec. 4. AC 회귀 + shellcheck 회귀 검증

### 4.1 AC 21건 회귀 (`tests/v0.6.3/run_ac_v063.sh`)

| 카테고리 | 통과 | 결과 |
|---------|-----|------|
| M1 (5건) | M1-1/2/3/4/5 | ✅ 5/5 |
| M2 (4건) | M2-1/2/3/4 | ✅ 4/4 |
| M3 (5건) | M3-1/2/3/4/5 | ✅ 5/5 |
| M4 (4건) | M4-1/2/3/4 | ✅ 4/4 |
| M5 (3건) | M5-1/2/3 | ✅ 3/3 |
| **합계** | **21/21** | ✅ **회귀 0건** |

**Stage 9 진입 게이트 PASS** (≥19/21 충족).

### 4.2 AC 자체 보강 영역 (Stage 12 QA / v0.6.4)

- **M1-4 (`update_handoff.sh --dry-run windows/fallback`)**: 현 명령 `grep -qiE "windows|fallback|copy|sync|DRY-RUN"`은 case-insensitive `dry-run` 단어로 PASS. F-62-6 실 구현 검증과 무관. **AC 강화 권고 — Stage 12 QA 또는 v0.6.4 이월**.
- 그 외 20건은 design 의도와 정합.

### 4.3 shellcheck 회귀

| 스크립트 | error | warning | info |
|---------|-------|---------|------|
| `scripts/monitor_bridge.sh` | 0 | 0 | 0 |
| `scripts/update_handoff.sh` | 0 | 0 | 0 |
| `scripts/setup_tmux_layout.sh` | 0 | 1 (SC1007) | 0 |
| `scripts/ai_step.sh` | 0 | 0 | 0 |
| `scripts/spawn_team.sh` | 0 | 1 (SC2034 ROOT 미사용) | 0 |
| `scripts/hook_post_tool_use.sh` | 0 | 0 | 0 |
| `tests/v0.6.3/run_ac_v063.sh` | 0 | 1 (SC2164) | 9 (SC2016) |
| **합계** | **0** | **3** | **9** |

**판정:** error 0건 → 회귀 0건 / Q3 gradual adoption 정합 (warning only first).

**보강:**
- SC1007 (setup_tmux_layout.sh:33 `ROOT=$(...)` empty assign 의심): 실제 정상 패턴, 1줄 수정 권고 (Stage 10 또는 v0.6.4).
- SC2034 (spawn_team.sh:36 `ROOT` 미사용): 변수 정리 권고 (v0.6.4).
- SC2164 (run_ac_v063.sh:8 `cd "$ROOT" || exit` 누락): Stage 12 QA 보강.
- SC2016 (run_ac_v063.sh single quote eval 9건): **의도된 패턴** (AC 명령 문자열 그대로 보존, eval 안에서 expansion). 비보강.

### 4.4 py_compile 회귀

본 commit chain에 `*.py` 변경 0건 → py_compile 회귀 검증 N/A.

---

## Sec. 5. 보강 영역 분류 (B-시리즈)

### 5.1 분류 정책

- **🔴 Stage 10 패치 후보:** AC 또는 design 명시 위반 (즉시 정정 권고).
- **🟡 Stage 12 QA 후보:** AC 보강 또는 명령 정확성 강화 (QA 단계 진입).
- **🟢 v0.6.4 이월:** 운영자 결정 #15에 따른 sketch 의도 영역 (인터페이스만 / 고도화 v0.6.4).

### 5.2 보강 표

| B# | 영역 | 분류 | 출처 | 적용 위치 |
|----|------|-----|------|----------|
| **B-1** | `monitor_bridge.sh` chmod +x 누락 | 🔴 Stage 10 | MR1-7 | `chmod +x scripts/monitor_bridge.sh scripts/spawn_team.sh tests/v0.6.3/run_ac_v063.sh` (1줄) |
| **B-2** | `monitor_bridge.sh` SIGTERM trap 핸들러 | 🟢 v0.6.4 | MR1-2 | `trap 'kill $(jobs -p) 2>/dev/null' EXIT INT TERM` 추가 |
| **B-3** | `monitor_bridge.sh` timestamp single quote | 🟢 v0.6.4 | MR1-4 | `date '+%Y-%m-%d %H:%M:%S'` 패턴 |
| **B-4** | `monitor_bridge.sh` 입력 파싱 echo → printf | 🟢 v0.6.4 | MR1-1 | l.49~50 `echo` → `printf '%s' "$signal_line"` |
| **B-5** | `update_handoff.sh` Windows fallback BSD/GNU sed 분기 | 🟢 v0.6.4 | MR1-9~11 | F-62-6 본문 구현 진입 |
| **B-6** | `spawn_team.sh` 실 spawn 코드 (claude CLI + tmux split-window) | 🟢 v0.6.4 | MR4-1~3 | 운영자 결정 #15 흡수 — 인터페이스만 v0.6.3 |
| **B-7** | `spawn_team.sh` `select-pane -T` pane title 호출 | 🟢 v0.6.4 | MR4-2 | 실 함수 본체 구현 |
| **B-8** | `spawn_team.sh` 세션명 환경변수화 | 🟢 v0.6.4 | MR4-4 | `TMUX_SESSION_ORC` 등 hardcode 제거 |
| **B-9** | `spawn_team.sh` SC2034 ROOT 미사용 변수 정리 | 🟡 Stage 12 | shellcheck | `ROOT` 제거 또는 사용 |
| **B-10** | `setup_tmux_layout.sh` SC1007 정정 | 🟡 Stage 12 | shellcheck | `ROOT=$(CDPATH=...` → `ROOT=$(unset CDPATH; ...)` 또는 quote 정정 |
| **B-11** | `tests/v0.6.3/run_ac_v063.sh` SC2164 cd 안전화 | 🟡 Stage 12 | shellcheck | `cd "$ROOT" || exit 1` |
| **B-12** | AC M1-4 강화 (현 명령은 `dry-run` 단어 매칭으로 PASS) | 🟡 Stage 12 | Sec.4.2 | F-62-6 실 구현 진입 후 검증 강화 |

**합계:** 12건 (Stage 10 = 1건 / Stage 12 = 4건 / v0.6.4 이월 = 7건).

### 5.3 회귀 영역

- **B-1 (`monitor_bridge.sh` chmod +x)**: 단일 회귀. 현 호출 패턴(`bash scripts/monitor_bridge.sh`)은 작동하나, `setup_tmux_layout.sh` l.89도 `bash` prefix 사용 — 비차단. 그러나 일관성 + 실수 방지 차원 Stage 10 1줄 패치 권고.

**Stage 10 자동 진입 권고 강도:** 🟡 권고 (비차단, 다음 commit 시 chmod +x 동시 처리 가능). 본 review는 APPROVED 판정 유지.

---

## Sec. 6. Stage Transition Score (Stage 9 자체 평가)

### 6.1 점수 산정

| 항목 | 가중치 | 추정 점수 | 가중 점수 | 산정 근거 |
|------|-------|---------|---------|---------|
| (1) Design 정합성 | 30% | 80% | 24.0 | sketch 20건 — 통과 10 + 보강(v0.6.4 의도) 9 + 회귀(chmod) 1. 운영자 결정 #15 흡수 정합. |
| (2) AC 회귀 | 20% | 100% | 20.0 | 21/21 PASS, 회귀 0건. |
| (3) shellcheck/py_compile | 15% | 95% | 14.25 | error 0 / warning 3 / info 9 (Q3 gradual adoption 정합). |
| (4) F-62-x 흡수 | 20% | 90% | 18.0 | F-62-1~F-62-9 본문 흡수: F-62-7/8/9 ✅ / F-62-5/6 인터페이스만 (운영자 결정 #15). |
| (5) 보강 영역 명료성 | 15% | 90% | 13.5 | Stage 10=1 / Stage 12=4 / v0.6.4=7 분류 명확. |
| **합계** | **100%** | | **89.75%** | |

### 6.2 Stage 12 게이트 평가

- ✅ Score ≥ 80% (89.8% 충족)
- ✅ AC 회귀 0건 (21/21)
- ✅ 운영자 결정 영역 0건
- ✅ shellcheck error 0건

**→ 게이트 4/4 PASS → Stage 12 QA 진입 가능.**

---

## Sec. 7. 종합 판정 + Stage 12 진입 권고

### 7.1 verdict

**verdict: ✅ APPROVED**

**근거:**
1. AC 21/21 (자동) PASS — 회귀 0건.
2. shellcheck error 0건 — gradual adoption Q3 정합.
3. 분기 인터페이스(F-62-8 모드 A) 동작 정합 — 3분기 case 모두 정합.
4. F-62-1~F-62-9 9건 본문 흡수 정합 (F-62-5/F-62-6은 운영자 결정 #15에 따라 인터페이스만).
5. 보강 영역 12건 분류 명확 (Stage 10=1 / Stage 12=4 / v0.6.4=7).
6. 운영자 결정 영역 0건 — 본 stage 자율 처리 완료.

### 7.2 Stage 10 패치 권고

- **B-1 (chmod +x)**: 비차단 1줄 패치. 다음 commit 또는 Stage 12 QA 시점 동시 처리 권고. **본 review APPROVED 판정 유지.**

### 7.3 Stage 12 진입 조건

- ✅ Score ≥ 80%
- ✅ AC 회귀 0건
- ✅ 운영자 결정 영역 0건
- ✅ shellcheck error 0건

**→ Stage 12 (QA) 즉시 진입 가능.**

### 7.4 v0.6.4 이월 영역 (요약)

본 review가 v0.6.4 이월로 분류한 7건 (B-2 ~ B-8) 모두 운영자 결정 #15 정합. v0.6.4 brainstorm 의제 후보로 trace.

---

## Sec. 8. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | 초안 (세션 27) | 1.3 최우영 작성. sketch 20건 cross-check + AC 21/21 회귀 + shellcheck 7개 + 분기 인터페이스 동작 검증. verdict APPROVED, Score 89.75%, 보강 12건 분류. |

---

**마지막 라인:**

COMPLETE-REVIEWER-S9: 315 lines, verdict=APPROVED, score=89.75%, AC=21/21, 보강=12건(Stage10=1, Stage12=4, v0.6.4=7), related_br=BR-002, file=docs/04_implementation_v0.6.3/code_review.md
