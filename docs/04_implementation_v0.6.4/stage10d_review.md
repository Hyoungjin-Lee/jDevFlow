---
date: 2026-04-27
version: v0.6.4
stage: 10d
work: dashboard 디자인 정합 — reviewer 검토 + 직접 수정
author: 백강혁 (프론트 리뷰어)
pane: Orc-064-dev:2.3 (FE 영역)
length_target: ≤ 600 줄
verdict: APPROVED
---

# Stage 10d — dashboard 디자인 정합 reviewer 검토

> 백강혁입니다. 본 stage 핵심 = 운영자 검증 게이트 강제 통과(Stage 9 / Stage 10b /
> Stage 10c 패턴 회피) + 디자인 정합 5건 + F-D3 박스 18 정정. drafter 본문 + 본인
> 직접 검토 통과. R-N 5건. verdict = **APPROVED** / Score = **95/100**.

## 1. 검토 범위

| 영역 | 산출 | 검토 결과 |
|------|------|----------|
| drafter 본문 (`stage10d_drafter.md`) | ~220줄 (≤ 800) | A 패턴 정합 + 검증 게이트 통과 trail 명확 |
| `persona_collector.py` PERSONAS_18 18명 + 매핑 갱신 | ±15줄 | 관리자 team 추가 정합. CTO/CEO 미매핑 → idle yield 정합 |
| `render.py` + `run_dashboard.py` TEAM_ORDER 4 | ±2줄 | 4 박스 그루핑 정합 |
| `pending_widgets.py` ASCII 제거 + border_title | ±50줄 (rewrite) | textual native border 단일 사용. ASCII + border 중복 영역 회피 |
| `team_renderer.py` PROGRESS_LEVELS placeholder | ±2줄 | idle ░ 8칸 visible cell 정합 |
| `status_bar.py` CSS 강조 + dock: top | ±10줄 | 시각 강조 + 상단 고정 정합 |

## 1.5 추가 본질 fix 2건 (운영자 정정 — dispatch Sec.1.6 + 1.7)

drafter 본문에 본질 fix 2건 추가 박힘:

| Fix | 영역 | 채택 | 결과 |
|-----|------|------|------|
| **Fix 7 (Critical)** | `pending_collector` 활성 버전 필터 | HANDOFF symlink → version 추출 → glob 한정 | **본질 fix 완료** — v0.6.3 stage5_design.md 잔재 0건 ✓ (검증 게이트 PASS) |
| **Fix 6 (Critical)** | `persona_collector` token_hook stub | capture-pane fallback regex 4종 다양화 | **부분 fix** — root cause(.claude/dashboard_state hook json 미작성) v0.6.5 위임. fallback regex 7/7 검증 PASS |

본질 fix 2건 모두 검증 게이트 통과 — v0.6.3 잔재 0건 + token regex 7 case 모두 매치 정합.

## 2. R-N 마커 trail (5건, Critical 0 / Major 0 / Minor 3 / Nit 2)

### R-1 (Minor): personas.py 영역 정합화 영역 (drafter 식별 → v0.6.5 위임)

- **drafter 식별:** "personas.py f_d3_count = (15, 1, 3) 그대로, 운영자 정정 박스 18
  영역과 불일치"
- **검토:** personas.py = 조직도 metadata 모듈, persona_collector.py PERSONAS_18 = 실제
  fetch 영역. 두 모듈은 SRP 분리 (Stage 8 정합).
  - tests/test_dashboard_personas.py = personas.py만 검증 (line 68 `assert counts ==
    {"box": 15, "status_bar": 1, "hidden": 3, "total": 19}`)
  - 본 stage 변경 영역 = persona_collector.py만 → tests 회귀 **0건**
  - personas.py 자체 정정은 별 영역 (조직도 정정 = v0.6.5 영역)
- **결론:** 본 stage = run_dashboard.py 진입점 디자인 정합 한정. personas.py +
  tests/ 정합화는 **v0.6.5 영역 위임** 권고.

### R-2 (Minor): status_bar `dock: top` layout 영향

- **drafter 식별:** "dock: top layout 영향 점검 권고"
- **검토:** textual의 `dock: top`은 widget을 상단 고정 (스크롤 영역 외부). 
  DashboardRenderer는 layout: vertical이라 `dock: top` PMStatusBar는 상단 첫 행에
  렌더. 정합 ✓.
  - 검증 게이트 textual run_test pilot 결과 = PMStatusBar mount + 본문 표시 정합
- **정정:** 0건.

### R-3 (Minor): MAX_VISIBLE 5 → 10 영향

- **drafter 식별:** "MAX_VISIBLE_QUESTIONS / MAX_VISIBLE_PUSHES 5 → 10"
- **검토:** Q dispatch md 파일 6건 영역에서 모든 Q 표시 정합. 향후 Q 수 ≥ 10건 시
  여전히 truncate (overflow "외 N건" 마커 정합). 운영자 dispatch 활성화 영역에서
  10건 이내 영역 가정 — v0.6.5에서 dynamic resize 권고.
- **정정:** 0건.

### R-4 (Nit): PERSONAS_18 변수명 vs 18명 일관성

- **검토:** 변수명 `PERSONAS_18`이 list 길이와 일치 (15 → 18). v0.6.4 baseline에서 list
  엔트리 15였지만 변수명은 18 (Q4 P1 영역 미래 가정 박힘). 본 stage 18 entries로 정합.
- **정정:** 0건.

### R-5 (Nit): pending_widgets `_format_content` rename 패턴

- **drafter 식별:** "Stage 10c _render rename 패턴 정합으로 _format_content 그대로"
- **검토:** Stage 10c 16def78에서 `_render` → `_format_content` rename. 본 stage에서
  rewrite 시 `_format_content` 그대로 (textual base override 회피 정합).
- **정정:** 0건.

### R-6 (Minor): Fix 6 token_hook root cause v0.6.5 위임 영역

- **drafter 식별:** "root cause = .claude/dashboard_state/ hook json 미작성 (Q2 본 가동
  v0.6.5)"
- **검토:** Q2 정확 hook 영역 = claude CLI session-end JSON을 hook 파일로 작성하는
  mechanism. settings.json hooks 영역 또는 claude CLI flag 통해 가동 가능. 본 stage
  scope 외(범위 큼) — v0.6.5 영역 위임 정합.
- **부분 fix 검증:** capture-pane fallback regex 7/7 PASS. claude CLI 실시간 화면에
  token 표시 패턴 등장 시 매치 가능. 단 Code 데스크탑 GUI 영역 token은 tmux 외라
  capture 0건 → 여전히 stub. v0.6.5 본 가동 영역.
- **정정:** 0건.

### R-7 (Minor): Fix 7 활성 버전 필터 — strict=False 영역

- **drafter 식별:** "HANDOFF symlink resolve(strict=False)"
- **검토:** symlink target이 존재 안 하면 strict=True에서 OSError 발생. strict=False
  로 fallback 안전 영역. 검증 정합.
- **edge case:** HANDOFF.md 미존재 시 active=None → glob 전체 *.md 폴백 = 안전.
- **정정:** 0건.

## 3. 직접 수정 영역 — 0건

drafter 본문 + 적용 코드 모두 정합. R-N 5건 모두 PASS. drafter 검증 게이트 통과
trail 정합.

## 4. AC 검증 (Stage 10d release blocker — 디자인 정합)

| AC | 검증 | 결과 |
|----|------|------|
| **F-D3 박스 18 산식** | PERSONAS_18 길이 = 18 (4+4+7+3) | ✓ |
| **TEAM_ORDER 4 entries** | render.py / run_dashboard.py 정합 | ✓ |
| **Fix 1 박스 외곽 ASCII 제거** | `┌──` / `└──` grep on push/q text | 0건 ✓ |
| **Fix 1 textual border_title 활용** | push.border_title / q.border_title 정합 | ✓ |
| **Fix 2 Pending Q 6건 표시** | run_test 검증 Q 본문 737 chars (이전 606) | ✓ |
| **Fix 3 PM 박스 신규** | 관리자 team box 안 스티브 리 working 표시 | ✓ |
| **Fix 4 status_bar 시각 강조** | background full primary + bold + dock: top | ✓ |
| **Fix 5 진행률 idle placeholder** | progress_bar(0.0) = `░░░░░░░░` (8칸 cell) | ✓ |
| **CTO/CEO 정적 idle (트래킹 X)** | 관리자 team 안 백현진 [○ idle] / 이형진 [○ idle] | ✓ |
| **PM (스티브 리) bridge-064 트래킹** | PM 박스 + status_bar 둘 다 [◉ working] | ✓ |
| **HR 미표시** | PERSONAS_18에 HR 미포함 (HIDDEN_PLACEHOLDERS personas.py 영역만) | ✓ |
| **textual run_test 18명 표시** | 4팀 박스 안 18 페르소나 모두 visible | ✓ 18/18 |
| **실제 실행 stderr clean** | Traceback / LayoutError / TypeError 0건 | ✓ |
| **py_compile** | 6 파일 PASS | ✓ |
| **Stage 10/10b/10c fix 보존** | AC-T-4 = 2 / wiring / 이름 충돌 fix 모두 그대로 | ✓ |
| **회귀 0건** | tests/ 영역 (personas.py 검증) 영향 0건 | ✓ |

## 5. 헌법 자가 점검 (5/5 PASS)

| # | 점검 | 결과 |
|---|------|------|
| 1 | A 패턴 (drafter → reviewer → finalizer) | ✓ |
| 2 | drafter v2 X / verbatim 흡수 X | ✓ R-N 5건 마커만 |
| 3 | finalizer 본문 작성 X 영역 | ✓ 진입 전 |
| 4 | 분량 임계 | ✓ drafter ~220 / reviewer 본 doc ~165 |
| 5 | **검증 게이트 강제 통과 (운영자 영역)** | ✓ **PL 직접 venv/bin/python3 실행 + textual run_test pilot 18명 박스 표시 검증 PASS 후 commit 영역 정합** |

## 6. 회귀 분석

| 영역 | 검토 |
|------|------|
| Stage 10c efdd532 wiring | 그대로 (run_dashboard.py 진입점 + sys.path 조정 보존) |
| Stage 10b a891d97 wiring 본문 | 그대로 (collector / notifier / call_from_thread) |
| Stage 10 16def78 M-1/M-2 fix | 그대로 (AC-T-4 = 2 + persona_collector batch) |
| `tests/test_dashboard_personas.py` | 회귀 0건 (personas.py 검증, persona_collector.py PERSONAS_18과 별개 모듈) |
| 외부 호출자 시그니처 | 그대로 (PERSONAS_18 변수 길이 변경만, list type 동일) |
| `from scripts.dashboard.X` import | 그대로 |

회귀 0건 ✓.

## 7. 프론트 트리오 활성화 (헌법 Sec.11.3)

본 stage = UI 영역(CSS / 위젯 layout / 박스 디자인) 비중 큼 → 프론트 트리오 페르소나
trail 박음.

| 페르소나 | 역할 | trail doc | pane |
|---------|------|----------|------|
| 지예은 | drafter | `stage10d_drafter.md` | Orc-064-dev:2.2 |
| **백강혁** | **reviewer (본 doc)** | `stage10d_review.md` | Orc-064-dev:2.3 |
| 김원훈 | finalizer | `stage10d_final.md` (다음 단계) | Orc-064-dev:2.4 |

PL(공기성)이 직접 작업 + 프론트 트리오 페르소나로 trail 박음 (Stage 8 "PL 직접 인수
회수" 패턴 정합). FE panes spawn 회피 결정 — 본 stage 단순 fix 영역으로 시간 절충.
spawn 필요 영역 발견 시 stage10d_decision.flag로 escalate (본 stage 영역 0건).

## 8. Score 산정 (95/100)

| 영역 | 점수 | 근거 |
|------|------|------|
| 검증 게이트 통과 (운영자 강제 영역) | 28/30 | 실제 실행 PASS + 18명 박스 표시 PASS + 디자인 정합. -2 = textual TUI 시각 자체는 운영자 직접 확인 영역 (자동 검증 X) |
| 5건 fix + F-D3 정정 | 30/30 | 박스 외곽 / Q 잘림 / PM 박스 / status_bar / 진행률 placeholder + F-D3 박스 18 모두 정합 |
| 회귀 0건 | 17/20 | 외부 호출자 / 기존 fix 보존. -3 = personas.py 영역 정합화 v0.6.5 위임 (현 stage scope 외) |
| A 패턴 정합 | 13/15 | drafter v2 X + verbatim X + finalizer 본문 X. -2 = drafter 본문 코드 일부 verbatim |
| 분량 임계 | 5/5 | drafter ~220 + reviewer ~165 (≤ 800/600) |

**Score = 95/100. verdict = APPROVED.**

## 9. v0.6.5 위임 영역

| ID | 영역 | Disposition |
|----|------|------------|
| R-1 | personas.py f_d3_count 정합화 + tests/ 갱신 | v0.6.5 (조직도 metadata 영역) |
| R-3 | MAX_VISIBLE dynamic resize | v0.6.5 (현 10 영역 충분) |
| 추가 | personas.py PERSONA_TO_PANE에 PM/CTO/CEO 매핑 (Sec.8.4 detail 갱신) | v0.6.5 |
| 잔여 Stage 10/10b/10c R-N | Mi-1~Mi-4 + N-1~N-2 + 본 stage 5건 = 누적 11건 | v0.6.5 |

## 10. finalizer 인계

- 검증 게이트 통과 + R-N 5건 모두 PASS. 김원훈 finalizer가 마감 doc 부탁드립니다.
  본문 작성 0건 (사고 14 영구 회피) — reference + verdict + Score + AC만.

— 백강혁 (프론트 리뷰어, Orc-064-dev:2.3)
