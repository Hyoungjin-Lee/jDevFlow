---
version: v0.6.3
stage: 1 (Brainstorming)
date: 2026-04-26
session: 26
mode: Standard
due: 2026-04-27 (운영자 명시 — 1세션 분량 목표)
prev: v0.6.2 release pending (Stage 9 APPROVED PASS, Score 93.8%, commit a6ef4be)
---

# v0.6.3 브레인스토밍

## 0. 컨텍스트

- v0.6.2 Stage 9 APPROVED PASS (Score 93.8%, commit `a6ef4be`)
- v0.6.3 Stage 1 진입 = Code 단일 창구 회의창 (Cowork 폐기 후 첫 번째 풀 v0.x 회차)
- **v0.6.3 due = 2026-04-27** (운영자 명시 — 1세션 분량 목표)
- **2026-05 초 = Windows 사용자 테스트베드 진입 시점** (외부 일정. v0.6.3 작업 자체는 그 한참 전에 완료)
- **옵션 A 통합 결정** = 6+1 항목 한 번에 (분할 X)

## 1. 의제별 결정

### 의제 1 — 본 릴리스 범위
**결정: 옵션 A 통합 (6+1 항목 한 번에)**
- 분할 / 미니멀 / 환경 우선 / 자동화 우선 옵션 모두 기각
- 기간 추정 = 1세션 분량 목표 (due 2026-04-27)

### 의제 2 — 글로벌 ~/.claude/CLAUDE.md 통합 [F-62-4]
**결정: 옵션 (가) 보편 정책만 + 점진적 확장**
- 글로벌화 대상: 보안 / 언어 / 톤 / CLI 자동화 / 모델 정책
- 충돌 우선순위: 프로젝트 > 글로벌 (specificity 원칙, 회의창 추천)
- 적용 메커니즘: 1단계 수동 복사, 자동화는 후속 (회의창 추천)

### 의제 3 — Windows 지원
**결정: YES — Windows 사용자 진입(2026-05 초) 전 완료**
- v0.6.3 due 2026-04-27 안에 완료 → 외부 일정에 충분히 선행
- 잠정 미지원 / 후속 이월 옵션 기각 (실수요 발생 시점)
- 기술 방식 = Stage 5 기술 설계 영역
  - 잠정 = HANDOFF symlink fallback 복사 + sync 도구 (`update_handoff.sh` 또는 D6 Hooks)
  - macOS/Linux/WSL = 현재 symlink 그대로
- 추가 점검 사전: BSD vs GNU sed / pgrep / 경로 구분자 / shellcheck shell 종류

### 의제 4 — HR팀 + 18명 페르소나 정식 가동
**결정: HR=NO, 18명=YES, 리뷰어 conditional 변환**

#### 4-1. 조직도 확정
- 기획 / 디자인 / 개발 3팀 (HR 신설 보류)
- 한 버전당 인프라: bridge 1개 + Orc 0~3개 (단계 진입 시 호출)
- Stage 1 = 회의창 단독, 터미널 미사용
- 다중 팀 협업 시 1+N (최대 1+3 동시)

#### 4-2. 18명 페르소나 매핑 (잠정 — Stage 2~4에서 정밀화)
- brainstorm Sec.8 18명 정의 기반 (v0.5/v0.6 기존)
- 매핑 영역 = Stage 2~4 기획 (Orc-063-plan dispatch)
- 정밀 매핑 산출물 = `docs/02_planning_v0.6.3/personas_18.md`

#### 4-3. 리뷰어 페르소나 conditional 변환
| 환경 | 동작 | 페르소나 정의 |
|---|---|---|
| Codex 사용 | Codex가 1차 코드 리뷰 | (c) **통합 검증자** — Codex 결과 응답 + fix 적용 + 회귀 검증 |
| Codex 미사용 | self-review fallback | **원래 코드 리뷰어 역할 유지** (코드 리뷰 직접) |

→ 페르소나 정의 시 두 모드 명시. 런타임에 환경 감지 → 동작 분기.

### 의제 5 — D6 Hooks PostToolUse
**결정: 경고 모드 (편집은 진행 + 알림)**
- 차단 모드 기각 — AI 자체 fix loop가 자연스러움
- 진짜 안전판 = commit 시점 별도 hook (D6 영역과 분리, v0.6.3+ 후속 검토)
- 대상: `.py` → `python3 -m py_compile`, `.sh` → `shellcheck`

### 의제 6 — gstack ETHOS 흡수
**결정: YES + 3개 다**
- Boil the Lake 경계 (회의창 사고 1·2 회피)
- autoplan 패턴 (작업 진입 전 자체 plan 출력 → 운영자 가시성 강화)
- /investigate 참조 (사고 5 추측 진행 회피 자동화)
- 흡수 위치 = Stage 5 기술 설계 영역 (잠정 = 글로벌 + 운영 매뉴얼 양쪽)

### 의제 7 — Stage 9 Codex 자동 호출
**결정: YES + Codex conditional**
- Codex 사용 환경 → Stage 8 완료 시 자동 호출 + 결과 회수 + Stage 10/13 분기
- 미사용 환경 → self-review fallback (**운영자에게 fallback 사용 알림 필수**)
- 환경 제약 해소 방향 = Stage 5 기술 설계 영역
  - 잠정 옵션: plugin-cc 고도화 / Codex CLI 직접 호출 / 우회 패턴

### 의제 8 — 마일스톤 분할
**결정: 5개 병렬 마일스톤** (잠정안 — Stage 2~4에서 정밀화)

| M | 내용 | 담당 팀 | 5월 초 마감 |
|---|------|---------|:---:|
| **M1** | Monitor 인프라 강화 + Windows fallback | 개발팀 (Orc-063-dev) | ✅ 필수 |
| **M2** | 글로벌 ~/.claude 통합 (보편 정책만) | 기획팀 (Orc-063-plan) | 🟡 권장 |
| **M3** | D6 Hooks(경고) + D7 gstack ETHOS 3종 | 개발팀 (Orc-063-dev) | 🟡 권장 |
| **M4** | 18명 페르소나 정식 가동 + 리뷰어 conditional | 기획팀 + 개발팀 | ✅ 필수 |
| **M5** | Stage 9 Codex 자동 호출 conditional (M3/M4 의존) | 개발팀 (Orc-063-dev) | 🟢 후순 |

#### 의존 그래프
```
M1 (인프라) ──┐
              ├─→ 5월 초 진입 가능
M4 (페르소나) ┘

M2 (글로벌) ──→ 독립
M3 (Hooks/ETHOS) ──→ M5 의존
M4 ──────────────→ M5 의존
M5 (Codex 자동) ──→ 마지막
```

#### 진행 순서 (잠정)
- 세션 N: M1 + M2 병렬
- 세션 N+1: M3 + M4 병렬
- 세션 N+2: M5
- 세션 N+3: Stage 9 review + Stage 12 QA + Stage 13 release

### 의제 9 — Monitor 인프라 강화 [세션 26 신규]
**결정: YES (실수요 증명)**

CTO실장(bridge-062) 진단 + 본 회의창 새 Monitor 노이즈 + Stage 8 완료 미캐치 사례로 실수요 검증.

| 원인 | 잠정 해법 (Stage 5 기술 설계 영역) |
|---|---|
| 세션명 불일치 | Monitor 가동 시 세션명 변수 주입. 버전별 spawn 스크립트가 자동 |
| /clear 이후 소멸 | 회의창 진입 직후 Monitor 자동 재가동 hook (D6 PostToolUse / Stop hook 활용) |
| 잔재 오감지 | capture-pane 범위 좁힘 (`-S -20`) + 시그널에 timestamp / 단계 명시 |

## 2. 운영 정책 신규 (세션 26 박힘 — 영구)

| 정책 | 위치 |
|---|---|
| tmux 세션 1+3 모델 (단계 진입 시 호출) | `bridge_protocol.md` Sec.4 + memory `reference_tmux_naming.md` |
| claude CLI 자동화 호출 (--dangerously-skip-permissions 필수) | `bridge_protocol.md` Sec.3 + memory `feedback_cli_auto_invocation.md` |
| 위험 명령 = 스크립트 작성 후 1줄 실행 | `bridge_protocol.md` Sec.3 + memory `feedback_dangerous_commands.md` |
| 기간 추정 단위 = 세션/시간 (사람 단위 X) | memory `feedback_estimation_unit.md` |
| 평이한 말 사용 (의제 던질 때) | memory `feedback_tone.md` 갱신 |
| 운영자 환경 = MacBook + 5월 초 Windows 테스트베드 | memory `user_environment.md` |

## 3. Non-goal (v0.6.3 본 릴리스)

- HR팀 페르소나 추가 (보류 — 4팀 체제 미진입)
- 글로벌 통합 완전 자동화 (점진적, v0.6.4+ 후속)
- v0.6.4 첫 실전 프로젝트 (다음 버전)
- 디자인팀 가동 (Stage 8 UI 변경 시점에 자연 진입)

## 4. 다음 단계

### 4-1. v0.6.2 release 마무리 (병렬)
- bridge-062에 dispatch 발행 완료 (`dispatch/2026-04-26_v0.6.2_stage13_release.md`)
- Orc-062가 `scripts/release_v0.6.2.sh` 작성 → dry-run → 운영자 `--confirm` → 실 실행
- 신규 위험 명령 정책 첫 적용 사례 = bridge-062/Orc-062 학습

### 4-2. Stage 2~4 기획 dispatch (v0.6.3 본 진입)
- 산출물: `dispatch/2026-04-26_v0.6.3_stage234_planning.md`
- 담당: Orc-063-plan (M2/M4 기획) + Orc-063-dev (M1/M3/M5 기술 설계 trail)
- 회의창 자율 영역: drafter/reviewer/finalizer 3 서브에이전트 병렬 또는 tmux 팀모드

### 4-3. Stage 5 기술 설계 (M1~M5 디테일)
- F-62-x 패턴 신규 설계 제약 도입 (의제 2/3/9 환경 의존 영역)

## 5. 운영자 결정 trace (세션 26)

| # | 시각 | 결정 |
|---|------|------|
| 1 | 18명 정식 가동 + HR=NO + 리뷰어 conditional | 의제 4 |
| 2 | 옵션 A 통합 + 기간 추정 = 세션 단위 | 의제 1 |
| 3 | tmux 1+3 모델 + 단계 진입 spawn + 영문 명명 | 조직도 |
| 4 | claude CLI 자동화 호출 + 옵션 필수 | 운영 정책 |
| 5 | 위험 명령 = 스크립트화 ("뼈에 사무침") | 운영 정책 |
| 6 | 글로벌 보편 정책만 + 점진 | 의제 2 |
| 7 | Windows 5월 초 마감 | 의제 3 |
| 8 | D6 Hooks 경고 모드 | 의제 5 |
| 9 | gstack ETHOS 3개 다 흡수 | 의제 6 |
| 10 | Stage 9 Codex 자동 (conditional) + 리뷰어 conditional | 의제 7 |
| 11 | 마일스톤 5개 병렬 잠정안 | 의제 8 |
| 12 | Monitor 인프라 강화 (의제 9 신규) | 의제 9 |
| 13 | v0.6.2 release dispatch A — bridge-062 위임 | 정책 첫 적용 |
