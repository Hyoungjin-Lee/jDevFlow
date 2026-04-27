---
version: v0.6.4
stage: 8 (M5 blocking 해소)
date: 2026-04-27
mode: Strict
status: v0.6.4 baseline
authored_by: 카더가든 (개발팀 BE 드래프터, Haiku/medium)
upstream:
  - docs/02_planning_v0.6.3/personas_18.md (v0.6.3 base verbatim)
  - docs/operating_manual.md Sec.1.2 (5계층 18명 정식판 영구 거주)
  - docs/03_design/v0.6.4_design_final.md Sec.10.3/Sec.11.1 (F-D3 19명 산식 본문)
  - dispatch/2026-04-27_v0.6.4_stage8_implementation.md (M5 blocking trail)
note: |
  drafter v0.6.4 — v0.6.3 base verbatim 흡수 + M5 dashboard 매핑 영역 신규:
  - F-X-6 blocking 해소: M5 dashboard 18명 매핑 detail Sec.8 박음 (Stage 8 진입 게이트 통과)
  - F-D3 19명 산식 본문: 박스 16 (4팀 15 + PM 1) + 미표시 placeholder 3 (CTO·CEO·HR) = 19
  - tmux 세션명 갱신: Orc-063-* → Orc-064-*
  - dashboard.py 모듈 reference 추가 (M2 persona_collector.PERSONAS_18 / M3 personas.TEAM_PERSONAS·PM_PERSONA·HIDDEN_PLACEHOLDERS / M5 status_bar.PMStatusBar)
  - Sec.7 Stage 가동 표 갱신: Stage 8 M5 시점 active 마커
  - 본 문서 도착 = M5 진입 게이트 통과 (F-X-6 blocking 해소 trail Sec.8.1)
session: 28
---

# jOneFlow v0.6.4 — 18명 페르소나 정식판 (M5 dashboard 매핑 영역 추가)

> **본 문서의 위치:** Stage 8 (M5 blocking 해소) — `docs/02_planning_v0.6.4/personas_18.md`
> **상위:** `docs/02_planning_v0.6.3/personas_18.md` (v0.6.3 base) + `docs/operating_manual.md` Sec.1.2 (영구 정식판) + `docs/03_design/v0.6.4_design_final.md` Sec.10.3 (F-D3 19명 산식)
> **목적:** v0.6.4 가동 시점의 18명 페르소나 정식판 + M5 dashboard 매핑 detail (F-X-6 blocking 해소). 본 문서가 도착한 시점부터 M5에서 dashboard.py 모듈 본문에 18명 매핑 detail을 박을 수 있습니다.

---

## Sec. 0. 본 문서 목적 및 위치

### 0.1 영구 위치
- `docs/operating_manual.md` Sec.1.2 — **18명 정식판 (영구 거주)**
  - Sec.1.1: 5계층 트리 (ASCII)
  - Sec.1.2: 18명 모델/effort 배정 (표)
  - Sec.1.3: 모델/effort 원칙 (설명)
  - Sec.1.4: HR팀 미결 표기

### 0.2 본 계획 문서의 역할 (v0.6.4 갱신)
v0.6.4 본 릴리스에서 필요한 추가 정보:
- **3팀 정밀화 배치:** 각 팀 4명/7명 구성 + 기획/디자인/개발 역할 분담
- **spawn 도구 매핑:** tmux 세션 / claude CLI 호출 명령 / 단계별 시점 (v0.6.4 = `Orc-064-*`)
- **페르소나별 톤:** 응답 어체 / 자주 쓰는 어휘 / 회피 어휘 가이드
- **리뷰어 conditional:** Codex 사용/미사용에 따른 동작 정의 (v0.6.4 = `claude` 고정)
- **가동 시점:** Stage × 페르소나별 active/standby/off 상태 (v0.6.4 = Stage 8 M1~M5 진행)
- **M5 dashboard 매핑 detail (v0.6.4 신규, Sec.8):** F-D3 19명 산식 + Dict 매핑 형식 + 페르소나↔pane 매핑

### 0.3 운영 연계
- **기획팀 (Orc-064-plan):** Stage 2~4에서 본 정의 기반 매핑 진행 (완료, plan_final v3 산출)
- **기술 설계 (Stage 5):** 환경 의존 항목 기술 설계 (완료, design_final v3 commit `8fbbfed`)
- **Stage 8 구현:** dashboard.py M1~M5 본 가동 (현재) — 본 문서 도착 시 M5 진입 가능

### 0.4 본 문서 정정 배경 (v0.6.4 갱신)
v0.6.3 base는 디자인팀 장원영 명의로 재작성된 정식판입니다(drafter2 정정). v0.6.4 본 문서는 v0.6.3 본문을 verbatim 흡수하며, 다음 영역을 신규 추가합니다:
1. **Sec.8 신규** — M5 dashboard 매핑 detail (F-X-6 blocking 해소, F-D3 19명 산식 본문, Dict 매핑 형식, 페르소나↔pane 매핑 표).
2. **Sec.4 갱신** — tmux 세션명 `Orc-063-*` → `Orc-064-*`.
3. **Sec.7 갱신** — Stage 8 M1~M5 active 마커 추가.
4. **본 drafter** — 카더가든 (개발팀 BE 드래프터) — M5 영역이 개발팀 dashboard 모듈에 직결되어 본 문서 갱신 책임 위임 영역. 18명 정의 위반 0건 (operating_manual Sec.1.2 verbatim 정합).

---

## Sec. 1. 5계층 트리 (v0.6.3 verbatim, operating_manual Sec.1.1 정합)

```
CEO 이형진
└── CTO 실장(Code) 백현진 (Sonnet, medium)
    └── PM – 브릿지(Code) 스티브 리 (Opus 4.7, xhigh)
        ├── 기획팀 (tmux, Code CLI)
        │   ├── 오케스트레이터 – 팀장(PL) 박지영 (Opus, high)
        │   ├── 리뷰어 – 책임연구원 김민교 (Opus, high)
        │   ├── 파이널리즈 – 선임연구원 안영이 (Sonnet, medium)
        │   └── 드래프터 – 주임연구원 장그래 (Haiku, medium)
        ├── 디자인팀 (tmux, Code CLI)
        │   ├── 오케스트레이터 – 팀장(PL) 우상호 (Opus, high)
        │   ├── 리뷰어 – 책임연구원 이수지 (Opus, high)
        │   ├── 파이널리즈 – 선임연구원 오해원 (Sonnet, medium)
        │   └── 드래프터 – 주임연구원 장원영 (Haiku, medium)
        └── 개발팀 (tmux, Code CLI)
            ├── 오케스트레이터 – 팀장(PL) 공기성 (Opus, high)
            ├── 백앤드 리뷰어 – 책임연구원 최우영 (Opus, high)
            ├── 백앤드 파이널리즈 – 선임연구원 현봉식 (Sonnet, medium)
            ├── 백앤드 드래프터 – 주임연구원 카더가든 (Haiku, medium)
            ├── 프론트 리뷰어 – 책임연구원 백강혁 (Opus, high)
            ├── 프론트 파이널리즈 – 선임연구원 김원훈 (Sonnet, medium)
            └── 프론트 드래프터 – 주임연구원 지예은 (Haiku, medium)
```

---

## Sec. 2. 18명 페르소나 모델/effort 배정 (v0.6.4 = `Orc-064-*` 갱신)

| 계층 | 팀 | 페르소나 | 직급 | 모델 | Effort | spawn 도구 | 가동 단계 | 응답 톤 |
|------|-----|---------|------|------|--------|-----------|---------|--------|
| 1 | — | 이형진 | CEO | (Cowork 운영자) | — | 회의창 (desk) | Stage 1, 13 | 결정/승인 |
| 2 | — | 백현진 | CTO 실장 (Code) | Sonnet | medium | 회의창 (desk) | Stage 1~13 | 전략/판단 |
| 3 | — | 스티브 리 | PM 브릿지 (Code) | **Opus 4.7** | **xhigh** | `tmux bridge-064` | Stage 1~13 | 중계/분배 |
| 4 | 기획팀 | 박지영 | 오케스트레이터 (PL) | Opus | high | `tmux Orc-064-plan` | Stage 2~4 | 지휘/판단 |
| 4 | 기획팀 | 김민교 | 리뷰어 (책임연구원) | Opus | high | `tmux Orc-064-plan` | Stage 2~4 | 피드백 |
| 4 | 기획팀 | 안영이 | 파이널리즈 (선임연구원) | Sonnet | medium | `tmux Orc-064-plan` | Stage 2~4 | 정리/검증 |
| 4 | 기획팀 | 장그래 | 드래프터 (주임연구원) | Haiku | medium | `tmux Orc-064-plan` | Stage 2~4 | 초안/설명 |
| 4 | 디자인팀 | 우상호 | 오케스트레이터 (PL) | Opus | high | `tmux Orc-064-design` | Stage 6~7 | 지휘/판단 |
| 4 | 디자인팀 | 이수지 | 리뷰어 (책임연구원) | Opus | high | `tmux Orc-064-design` | Stage 6~7 | 피드백 |
| 4 | 디자인팀 | 오해원 | 파이널리즈 (선임연구원) | Sonnet | medium | `tmux Orc-064-design` | Stage 6~7 | 정리/검증 |
| 4 | 디자인팀 | 장원영 | 드래프터 (주임연구원) | Haiku | medium | `tmux Orc-064-design` | Stage 6~7 | 초안/설명 |
| 4 | 개발팀 | 공기성 | 오케스트레이터 (PL) | Opus | high | `tmux Orc-064-dev` | Stage 5/8/9/10 | 지휘/판단 |
| 4 | 개발팀 | 최우영 | 백앤드 리뷰어 (책임연구원) | Opus | high | `tmux Orc-064-dev` | Stage 8/9 | 피드백 |
| 4 | 개발팀 | 현봉식 | 백앤드 파이널리즈 (선임연구원) | Sonnet | medium | `tmux Orc-064-dev` | Stage 8/9/10 | 정리/검증 |
| 4 | 개발팀 | 카더가든 | 백앤드 드래프터 (주임연구원) | Haiku | medium | `tmux Orc-064-dev` | Stage 8/9/10 | 초안/설명 |
| 4 | 개발팀 | 백강혁 | 프론트 리뷰어 (책임연구원) | Opus | high | `tmux Orc-064-dev` | Stage 8/9 | 피드백 |
| 4 | 개발팀 | 김원훈 | 프론트 파이널리즈 (선임연구원) | Sonnet | medium | `tmux Orc-064-dev` | Stage 8/9/10 | 정리/검증 |
| 4 | 개발팀 | 지예은 | 프론트 드래프터 (주임연구원) | Haiku | medium | `tmux Orc-064-dev` | Stage 8/9/10 | 초안/설명 |

**요약:**
- **총 18명** (CEO 1 + CTO 1 + PM 1 + 기획팀 4 + 디자인팀 4 + 개발팀 7)
- **3팀 동시 가동:** Stage 5 이후 1 bridge + 3 Orc tmux 세션 (최대 1+3 구성)
- **v0.6.4:** 기획팀(완료) + 개발팀 BE(현재 가동, M1~M5 dashboard 본 가동) / 디자인팀(Stage 6/7 진입 시 spawn)

---

## Sec. 3. 3팀 역할 분배 정밀화 (v0.6.3 verbatim)

### 3.1 기획팀 (4명)

| 역할 | 이름 | 모델 | 직급 | 책임 |
|------|------|------|------|------|
| **오케스트레이터** | 박지영 | Opus | PL | 팀 지휘 + 최종 판단 + 단계 분담 |
| **리뷰어** | 김민교 | Opus | 책임연구원 | 초안 검토 + 깊은 피드백 + 강점 보강 |
| **파이널리즈** | 안영이 | Sonnet | 선임연구원 | 피드백 흡수 + 일관성 마감 + 최종 검증 |
| **드래프터** | 장그래 | Haiku | 주임연구원 | 초안 5~10개 병렬 작성 + 기초 설명 |

**가동:** Stage 2~4 (plan_draft, plan_review, plan_final). v0.6.4 = 완료 (planning_index commit `7c139b6`).
**tmux 세션:** `Orc-064-plan` (4명 팀원 pane)

### 3.2 디자인팀 (4명)

| 역할 | 이름 | 모델 | 직급 | 책임 |
|------|------|------|------|------|
| **오케스트레이터** | 우상호 | Opus | PL | 팀 지휘 + UI/UX 최종 판단 |
| **리뷰어** | 이수지 | Opus | 책임연구원 | 디자인 검토 + 사용자 경험 피드백 |
| **파이널리즈** | 오해원 | Sonnet | 선임연구원 | 디자인 마감 + 최종 검증 |
| **드래프터** | 장원영 | Haiku | 주임연구원 | UI 프로토타입/목업 초안 |

**가동:** Stage 6~7 (has_ui=true). v0.6.4 = 미가동 (Stage 5 design_final boundary 6/6 박힘 후 Stage 6 진입 시 spawn).
**tmux 세션:** `Orc-064-design` (Stage 6 진입 시만 spawn)

### 3.3 개발팀 (7명)

| 부분 | 역할 | 이름 | 모델 | 직급 | 책임 |
|------|------|------|------|------|------|
| **전체** | 오케스트레이터 | 공기성 | Opus | PL | 팀 지휘 + 아키텍처 판단 + 백/프 조율 |
| **백엔드** | 리뷰어 | 최우영 | Opus | 책임연구원 | 백엔드 코드 리뷰 + 아키텍처 피드백 |
| **백엔드** | 파이널리즈 | 현봉식 | Sonnet | 선임연구원 | 백엔드 마감 + 최종 검증 |
| **백엔드** | 드래프터 | 카더가든 | Haiku | 주임연구원 | 백엔드 초안 구현 |
| **프론트** | 리뷰어 | 백강혁 | Opus | 책임연구원 | 프론트 코드 리뷰 + UI 피드백 |
| **프론트** | 파이널리즈 | 김원훈 | Sonnet | 선임연구원 | 프론트 마감 + 최종 검증 |
| **프론트** | 드래프터 | 지예은 | Haiku | 주임연구원 | 프론트 초안 구현 |

**가동:** Stage 5 (기술 설계, 완료) / Stage 8~10 (M1~M5 dashboard 본 가동, 현재).
**v0.6.4:** BE 트리오 가동 (M1=scaffold·M2=data·M3=render·M4=pending+notif 완료 + 본 M5 진입 게이트). FE 트리오 = Stage 8 진입 영역 (M5 personas_18 도착 후 자동 진입).
**tmux 세션:** `Orc-064-dev` (1 오케 + BE 3 + FE 3, 4 panes 헌법: 1.1 PL / 1.2 drafter / 1.3 reviewer / 1.4 finalizer + FE 트리오 별도 pane)

---

## Sec. 4. spawn 도구 매핑 (v0.6.4 갱신 — `Orc-064-*`)

### 4.1 기획팀 spawn

```bash
# 세션 생성 (회의창)
tmux new-session -d -s Orc-064-plan -c /Users/geenya/projects/Jonelab_Platform/jOneFlow

# Claude CLI 기동
tmux send-keys -t Orc-064-plan 'claude --teammate-mode tmux --dangerously-skip-permissions' Enter
```

**해제:** Stage 4 plan_final 완료 → `tmux kill-session -t Orc-064-plan` (v0.6.4 = 완료).

### 4.2 디자인팀 spawn

```bash
tmux new-session -d -s Orc-064-design -c /Users/geenya/projects/Jonelab_Platform/jOneFlow
tmux send-keys -t Orc-064-design 'claude --teammate-mode tmux --dangerously-skip-permissions' Enter
```

**v0.6.4 상태:** 미가동 (Stage 6 진입 시 spawn — design_final boundary 6/6 박힘 후 dispatch 발행 영역).

### 4.3 개발팀 spawn

```bash
tmux new-session -d -s Orc-064-dev -c /Users/geenya/projects/Jonelab_Platform/jOneFlow
tmux send-keys -t Orc-064-dev 'claude --teammate-mode tmux --dangerously-skip-permissions' Enter
```

**v0.6.4 상태:** 가동 중 (Stage 8 M1~M4 완료, M5 진입 게이트 통과 = 본 문서 도착).
**해제:** Stage 10 finalize 또는 13 release 완료 → `tmux kill-session -t Orc-064-dev`.

### 4.4 브릿지 (회의창 자율)

```bash
tmux new-session -d -s bridge-064 -c /Users/geenya/projects/Jonelab_Platform/jOneFlow
tmux send-keys -t bridge-064 'claude --teammate-mode tmux --dangerously-skip-permissions' Enter
```

---

## Sec. 5. 페르소나별 톤 가이드 (v0.6.3 verbatim)

본 섹션은 `docs/02_planning_v0.6.3/personas_18.md` Sec.5 verbatim입니다 (CEO/CTO/PM/오케/리뷰어/파이널리즈/드래프터 6 계층 톤). v0.6.4 변경 0건. 상세 어구·어휘·회피 표현은 v0.6.3 base 본문 참조.

---

## Sec. 6. 리뷰어 페르소나 조건부 정의 (v0.6.3 verbatim)

본 섹션은 v0.6.3 base Sec.6 verbatim입니다 (모드 A Codex 사용 / 모드 B fallback / 환경 감지 분기).

**v0.6.4 적용:** `.claude/settings.json` `stage_assignments.stage9_review = "claude"` (claude-only 모드). Codex plugin-cc 후속 운영자 결정 #15 정합 (v0.6.3 Stage 9 review final 박힘).

---

## Sec. 7. 페르소나 가동 시점 표 (v0.6.4 = Stage 8 M1~M5 active)

| 페르소나 | 계층 | Stage 1 | Stage 2 | Stage 3 | Stage 4 | Stage 5 | Stage 6 | Stage 7 | Stage 8 | Stage 9 | Stage 10 | Stage 11 | Stage 12 | Stage 13 |
|---------|------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 이형진 (CEO) | 1 | ✅ | — | — | — | — | — | — | — | — | — | — | ✅ | ✅ |
| 백현진 (CTO) | 2 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 스티브 리 (PM 브릿지) | 3 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **기획팀** |
| 박지영 (Orc) | 4 | — | ✅ | ✅ | ✅ | — | — | — | — | — | — | — | — | — |
| 김민교 (Rev) | 4 | — | ✅ | ✅ | ⬭ | — | — | — | — | — | — | — | — | — |
| 안영이 (Fin) | 4 | — | ✅ | ⬭ | ✅ | — | — | — | — | — | — | — | — | — |
| 장그래 (Dft) | 4 | — | ✅ | ⬭ | ⬭ | — | — | — | — | — | — | — | — | — |
| **디자인팀** |
| 우상호 (Orc) | 4 | — | — | — | — | — | ✅ | ✅ | — | — | — | — | — | — |
| 이수지 (Rev) | 4 | — | — | — | — | — | ✅ | ✅ | — | — | — | — | — | — |
| 오해원 (Fin) | 4 | — | — | — | — | — | ✅ | ✅ | — | — | — | — | — | — |
| 장원영 (Dft) | 4 | — | — | — | — | — | ✅ | ✅ | — | — | — | — | — | — |
| **개발팀** |
| 공기성 (Orc) | 4 | — | — | — | — | ✅ | — | — | **✅** | ✅ | ✅ | ⬭ | — | — |
| 최우영 (BE Rev) | 4 | — | — | — | — | ✅ | — | — | **✅** | ✅ | ✅ | — | — | — |
| 현봉식 (BE Fin) | 4 | — | — | — | — | ✅ | — | — | **✅** | ✅ | ✅ | — | — | — |
| 카더가든 (BE Dft) | 4 | — | — | — | — | ✅ | — | — | **✅** | ✅ | ✅ | — | — | — |
| 백강혁 (FE Rev) | 4 | — | — | — | — | — | — | — | ✅ | ✅ | ✅ | — | — | — |
| 김원훈 (FE Fin) | 4 | — | — | — | — | — | — | — | ✅ | ✅ | ✅ | — | — | — |
| 지예은 (FE Dft) | 4 | — | — | — | — | — | — | — | ✅ | ✅ | ✅ | — | — | — |

**범례:**
- ✅ = active (tmux 세션 가동) / **굵은 ✅** = v0.6.4 현재 활성 (Stage 8 M1~M4 완료, M5 진입 게이트 통과)
- ⬭ = standby (당 Stage에서 주 역할 종료, 오케 요청 시 재진입 가능)
- — = off (미가동)
- Stage 1 = 회의창 단독 (tmux 미사용)
- Stage 11 = 최종 검증 (Strict 모드만, v0.6.4 = Strict 적용)

---

## Sec. 8. M5 dashboard 매핑 detail (v0.6.4 신규 — F-X-6 blocking 해소)

### 8.1 F-X-6 blocking trail

v0.6.4 design_final Sec.10.4 + planning_index Sec.7 이월 #11 = "18명 매핑 detail (`personas_18.md` 도착 후)" — F-X-6 boundary에 따라 **Stage 8 진입 = blocking 시점**입니다. 본 문서가 v0.6.4 영역에서 도착함으로써 다음을 수행합니다:

1. **F-X-6 blocking 해소** — M5 진입 게이트 통과 (개발팀 BE 트리오 Stage 8 M5 진행 가능).
2. **F-D3 19명 산식 본문** — 박스 16 + 미표시 placeholder 3 = 19 (Sec.8.2 박힘).
3. **dashboard 매핑 detail** — Dict 매핑 형식 + 페르소나↔pane 매핑 표 (Sec.8.3~8.4 박힘).
4. **dashboard.py 모듈 reference** — M2 `persona_collector.PERSONAS_18` / M3 `personas.TEAM_PERSONAS·PM_PERSONA·HIDDEN_PLACEHOLDERS` / M5 `status_bar.PMStatusBar` (Sec.8.5 박힘).

### 8.2 F-D3 19명 산식 (design_final Sec.11.1 verbatim)

v0.6.4 대시보드 표시 페르소나 산식 = **19명**:

| 영역 | 카운트 | 페르소나 |
|------|-------|---------|
| 박스 4팀 | 15 | 기획 4 (박지영/김민교/안영이/장그래) + 디자인 4 (우상호/이수지/오해원/장원영) + 개발 7 (공기성/최우영/현봉식/카더가든/백강혁/김원훈/지예은) |
| PM status bar (별도 1행) | 1 | 스티브 리 |
| 미표시 placeholder | 3 | 백현진(CTO) + 이형진(CEO) + (HR TBD) |
| **합계** | **19** | F-D3 박스 16 (4팀 15 + PM 1) + 미표시 3 = 19 |

### 8.3 Dict[str, List[PersonaMeta]] dashboard 매핑

`scripts/dashboard/personas.py` 본문 사용 영역 (M3 boundary slot #5 정합):

```python
DASHBOARD_PERSONAS: Dict[str, List[PersonaInfo]] = {
    # 박스 영역 (M3 TeamRenderer 입력 = 4팀 15명)
    "기획": [
        {"name": "박지영", "role": "기획PL", "team": "기획", "displayed": "box"},
        {"name": "김민교", "role": "기획리뷰", "team": "기획", "displayed": "box"},
        {"name": "안영이", "role": "기획파이널", "team": "기획", "displayed": "box"},
        {"name": "장그래", "role": "기획드래프터", "team": "기획", "displayed": "box"},
    ],
    "디자인": [
        {"name": "우상호", "role": "디자인PL", "team": "디자인", "displayed": "box"},
        {"name": "이수지", "role": "디자인리뷰", "team": "디자인", "displayed": "box"},
        {"name": "오해원", "role": "디자인파이널", "team": "디자인", "displayed": "box"},
        {"name": "장원영", "role": "디자인드래프터", "team": "디자인", "displayed": "box"},
    ],
    "개발": [
        {"name": "공기성", "role": "개발PL", "team": "개발", "displayed": "box"},
        {"name": "최우영", "role": "BE리뷰", "team": "개발", "displayed": "box"},
        {"name": "현봉식", "role": "BE파이널", "team": "개발", "displayed": "box"},
        {"name": "카더가든", "role": "BE드래프터", "team": "개발", "displayed": "box"},
        {"name": "백강혁", "role": "FE리뷰", "team": "개발", "displayed": "box"},
        {"name": "김원훈", "role": "FE파이널", "team": "개발", "displayed": "box"},
        {"name": "지예은", "role": "FE드래프터", "team": "개발", "displayed": "box"},
    ],
    # PM status bar 1행 (boundary slot #6, M3 PMStatusBar)
    "_pm": [
        {"name": "스티브 리", "role": "PM", "team": None, "displayed": "status_bar"},
    ],
    # 미표시 placeholder 3종 (boundary slot #5, M3 HIDDEN_PLACEHOLDERS)
    "_hidden": [
        {"name": "백현진", "role": "CTO", "team": None, "displayed": "hidden"},
        {"name": "이형진", "role": "CEO", "team": None, "displayed": "hidden"},
        {"name": "(HR TBD)", "role": "HR", "team": None, "displayed": "hidden"},
    ],
}
```

### 8.4 페르소나 ↔ tmux pane 매핑 표 (F-X-6 detail)

| 페르소나 | 팀 | 역할 | tmux pane | 표시 영역 |
|---------|-----|------|----------|----------|
| 박지영 | 기획 | PL | `Orc-064-plan:1.1` | 박스 (M3 박스 #1) |
| 장그래 | 기획 | drafter | `Orc-064-plan:1.2` | 박스 |
| 김민교 | 기획 | reviewer | `Orc-064-plan:1.3` | 박스 |
| 안영이 | 기획 | finalizer | `Orc-064-plan:1.4` | 박스 |
| 우상호 | 디자인 | PL | `Orc-064-design:1.1` | 박스 (M3 박스 #2) |
| 장원영 | 디자인 | drafter | `Orc-064-design:1.2` | 박스 |
| 이수지 | 디자인 | reviewer | `Orc-064-design:1.3` | 박스 |
| 오해원 | 디자인 | finalizer | `Orc-064-design:1.4` | 박스 |
| 공기성 | 개발 | PL | `Orc-064-dev:1.1` | 박스 (M3 박스 #3) |
| 카더가든 | 개발 | BE drafter | `Orc-064-dev:1.2` | 박스 |
| 최우영 | 개발 | BE reviewer | `Orc-064-dev:1.3` | 박스 |
| 현봉식 | 개발 | BE finalizer | `Orc-064-dev:1.4` | 박스 |
| 지예은 | 개발 | FE drafter | `Orc-064-dev:2.2` | 박스 (M5 detail) |
| 백강혁 | 개발 | FE reviewer | `Orc-064-dev:2.3` | 박스 (M5 detail) |
| 김원훈 | 개발 | FE finalizer | `Orc-064-dev:2.4` | 박스 (M5 detail) |
| 스티브 리 | (PM) | bridge | `bridge-064:1.1` | status bar (1행) |
| 백현진 | (CTO) | — | (회의창 desk) | 미표시 placeholder |
| 이형진 | (CEO) | — | (Cowork desk) | 미표시 placeholder |
| (HR TBD) | (HR) | — | — | 미표시 placeholder |

**FE 트리오 pane 매핑 (M5 detail):** `Orc-064-dev` 세션 안 별도 window(2.x) 또는 별도 pane stack 영역. drafter 자율 영역으로 M5 진입 시 dashboard `_PERSONA_TO_PANE_INDEX` (M2 `persona_collector.py`)에 갱신.

### 8.5 dashboard.py 모듈 reference (M1~M5 산출 위치)

본 문서가 도착한 시점부터 M5에서 다음 모듈 본문에 매핑 detail을 박을 수 있습니다:

| 모듈 | 책임 | 본 문서 sync 영역 |
|------|------|---------------|
| `scripts/dashboard.py` | 단일 진입점 (M1) | — |
| `scripts/dashboard/persona_collector.py` `PERSONAS_18` | 4팀 15명 sync polling (M2) | Sec.8.3 박스 영역 15명 verbatim sync |
| `scripts/dashboard/persona_collector.py` `_TEAM_TO_ORC_SESSION` / `_PERSONA_TO_PANE_INDEX` | 페르소나 ↔ pane 매핑 (M2) | Sec.8.4 표 verbatim sync |
| `scripts/dashboard/personas.py` `TEAM_PERSONAS` | 박스 영역 메타 (M3 boundary #5) | Sec.8.3 verbatim sync |
| `scripts/dashboard/personas.py` `PM_PERSONA` | PM status bar 메타 (M3 boundary #6) | Sec.8.3 `_pm` verbatim sync |
| `scripts/dashboard/personas.py` `HIDDEN_PLACEHOLDERS` | 미표시 placeholder 3종 (M3 boundary #5) | Sec.8.3 `_hidden` verbatim sync |
| `scripts/dashboard/status_bar.py` `PMStatusBar` | PM 1행 status bar (M3 boundary #6) | Sec.8.4 PM 행 verbatim sync |
| `scripts/dashboard/render.py` `DashboardRenderer` | 단일 진입 + 4팀 박스 + PM bar (M3) | Sec.8.3 Dict 매핑 verbatim sync |

**M5 진입 가능 영역 (본 문서 도착 후):**
1. FE 트리오 pane 매핑 갱신 (`Orc-064-dev:2.x` 영역).
2. `personas.py` 본문에 본 문서 Sec.8.3 Dict 매핑 verbatim 박음.
3. Windows skeleton + 18명 매핑 detail final (M5 영역).
4. F-X-6 blocking trail commit msg에 박음 (`impl(v0.6.4): Stage 8 M5 — personas_18 v0.6.4 도착 + F-X-6 해소`).

---

## Sec. 9. 미결 사항 / Q 후보 (v0.6.4 갱신)

### Q-PER-1 (v0.6.3 잠정 → v0.6.4 잔존)
**디자인팀 v0.6.4 첫 실전 프로젝트 자동 가동 트리거는?**

현재:
- v0.6.3: 디자인팀 Non-goal (미가동)
- v0.6.4: design_final boundary 6/6 박힘 → Stage 6 진입 시 spawn 영역
- Stage 6 UI 변경 시점에 자동 진입 (예정)

**v0.6.4 진행:** Stage 6 dispatch는 design_final 완료 + 운영자 Stage 6 진입 시그널 후 발행 (F-M3-5 흡수). 자동 spawn 정책은 v0.6.5+ 영역.

### Q-PER-2 (v0.6.3 잠정 → v0.6.4 잔존)
**개발팀 PL 공기성이 백엔드/프론트 양쪽 단독 지휘할 때, 부 PL이 필요한가?**

**v0.6.4 진행:** Stage 8 M1~M4 완료 — 공기성 PL 단독 지휘로 4 panes 헌법 준수 + dispatch 정합 + verdict 산출. 부 PL 미필요 잠정 confirm. M5 진입 시 FE 트리오 가동 후 재검토 영역(v0.6.5+).

### Q-PER-3 (v0.6.4 신규)
**FE 트리오 (백강혁/김원훈/지예은) 가동 시점 + pane 매핑 final?**

현재:
- BE 트리오 가동 중 (`Orc-064-dev:1.1~1.4` 4 panes)
- FE 트리오 미가동 — Sec.8.4 잠정 매핑 (`Orc-064-dev:2.2~2.4`)

**의존:** Stage 8 M5 진입 후 dashboard.py 모듈 본문에 `_PERSONA_TO_PANE_INDEX` 갱신 영역 (drafter 자율). v0.6.4 본 가동 시점 = M5 완료 후.

---

## Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | v0.6.3 (장원영 drafter2) | 디자인팀 drafter 명의 재작성 — plan_draft + personas_18 명의 이원화 해소. 520줄. |
| 2026-04-27 | **v0.6.4** (카더가든 BE 드래프터) | v0.6.3 base verbatim 흡수 + Sec.8 신규(M5 dashboard 매핑 detail + F-X-6 blocking 해소 + F-D3 19명 산식). tmux 세션명 `Orc-063-*` → `Orc-064-*` 갱신. Sec.7 Stage 8 M1~M5 active 마커. dashboard.py 모듈 reference 박음. |

---

**마지막 라인:**

COMPLETE-V0.6.4-PERSONAS_18: file=docs/02_planning_v0.6.4/personas_18.md, authored_by=카더가든, F-X-6 blocking 해소, M5 진입 게이트 통과
