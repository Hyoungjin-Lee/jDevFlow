---
version: v0.6.2
stage: 4 (plan_final)
date: 2026-04-26
mode: Standard
status: pending_operator_approval
item: 03_slash
revision: v3 (final)
final_at: 2026-04-26
finalized_by: 안영이 (기획팀 선임연구원)
incorporates_review: planning_review.md
revisions_absorbed: [F-SLA-1, F-SLA-2, F-SLA-3, F-SLA-4, F-SLA-5]
cross_cutting_absorbed: [F-X-3, F-X-6, F-X-7]
---

# jOneFlow v0.6.2 — slash command 래퍼 3종 (planning_03_slash)

> **상위:** `docs/01_brainstorm_v0.6.2/brainstorm.md` Sec.5 (Stage 1, 세션 23)
> **본 문서:** `docs/02_planning_v0.6.2/planning_03_slash.md` (Stage 4 final, 세션 25)
> **상태 배너:** ⏳ **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.
> **다음:** Stage 4.5 운영자 승인 게이트 → Stage 5 기술 설계 → Stage 8 구현 (선행: planning_04 완료 후)
> 모드 근거: 비개발자 UX 개선을 위한 래퍼 추가는 신기능이지 아키텍처/보안 변경 아님. Standard 유지. 실패 시 기존 셸 스크립트로 fallback 가능.

---

## Sec. 0. v2 → final 변경 요약

| ID | 위치 | 변경 요지 |
|----|------|---------|
| F-SLA-1 | AC-Slash-1~3 | 자동(grep)/수동(QA) 두 단계로 분리 (v2에서 흡수 완료) |
| F-SLA-2 | Sec.6 의존성 | `/ai-step --auto` approval gate 의존성 명시 (v2에서 흡수 완료) |
| F-SLA-3 | Sec.7 위험 3 | .claude/commands/ ↔ settings.json 결합 범위 Stage 5 이월 (v2에서 흡수 완료) |
| F-SLA-4 | AC-Slash-4 | frontmatter spec 조사 Stage 5 이월 (v2에서 흡수 완료) |
| F-SLA-5 | AC-Slash-5 | "권장" → 강제 + grep 측정 (v2에서 흡수 완료) |
| **F-X-3 (횡단)** | Sec. 9 이월 표 | planning_04 hook 회귀 테스트 Stage 5 이월. `/ai-step --auto` 호출 시 archive hook 동작 확인 |
| **F-X-6 (횡단)** | Sec. 3 | 신규 .md 파일(`.claude/commands/<3개>.md`) SPDX 헤더 미적용 정책 명시 |
| **F-X-7 (횡단)** | Sec. 6 의존성 | 구현 순서 박음: 02 → 01 → 05 → 04 → **03(본 항목, 마지막)** |
| **Stage 5 이월 표** | Sec. 9 | F-SLA-4 + F-X-3 이월 항목 표 정비 |
| **운영자 결정 게이트** | Sec. 끝 | 해당 Q 없음 (본 항목은 운영자 결정 사항 없음) |

---

---

## Sec. 1. 목적 (Purpose)

v0.6 부터 jOneFlow는 세 가지 핵심 셸 스크립트(`init_project.sh`, `switch_team.sh`, `ai_step.sh`)를 통해 프로젝트 초기화, 팀 구성 전환, Stage 자동 진행을 수행합니다. 하지만 비개발자 사용자나 CLI 경로를 외우지 않은 사용자는 매번 `bash scripts/` 경로와 플래그(`--auto`, `--status`, `--force` 등)를 검색해야 합니다. 

**본 항목의 목표:**  
Claude Code의 slash command 기능을 활용하여 `/init-project`, `/switch-team`, `/ai-step` 단 3개의 대화형 명령어로 단순화하고, 사용자가 셸 스크립트 존재를 모르고도 jOneFlow 전체 워크플로우를 진행할 수 있게 합니다. 비개발자 진입 장벽을 제거하고 편의성을 높이는 것이 목적입니다.

---

## Sec. 2. 범위 (Scope)

### 변경 항목

- **`.claude/commands/` 폴더 신규 생성** — slash command markdown 파일 저장소
- **`.claude/commands/init-project.md`** — `/init-project` 커맨드 정의
- **`.claude/commands/switch-team.md`** — `/switch-team` 커맨드 정의
- **`.claude/commands/ai-step.md`** — `/ai-step` 커맨드 정의

### 미변경 항목

- `scripts/init_project.sh` — 원본 스크립트 미수정. 래퍼만 추가.
- `scripts/switch_team.sh` — 원본 스크립트 미수정.
- `scripts/ai_step.sh` — 원본 스크립트 미수정.
- CLAUDE.md, WORKFLOW.md, HANDOFF.md — 수정 없음.
- 다른 정규 파일 및 폴더 구조 — 변경 없음.

### 제외 범위

- `.claude/commands/` 외 다른 곳에 슬래시 명령어 생성 금지.
- 스크립트 인자 시그니처 변경. 슬래시 markdown에서는 기존 인터페이스를 **정확히** 래핑만 함.
- slash command 자동 검색/발견 로직 구현. Claude Code의 기본 명령어 로드 메커니즘만 활용.

---

## Sec. 3. 변경 대상 파일

| 파일 | 내용 | 라인 수(예상) |
|------|------|-------------|
| `.claude/commands/init-project.md` | `/init-project` 커맨드 정의 | 30~40줄 |
| `.claude/commands/switch-team.md` | `/switch-team` 커맨드 정의 | 30~40줄 |
| `.claude/commands/ai-step.md` | `/ai-step` 커맨드 정의 | 40~50줄 |
| `.claude/commands/` (폴더) | 신규 디렉토리 생성 | — |

**합계:** 3개 파일, 약 100~130줄.

---

## Sec. 4. 단계별 작업 분해 (Stage 8 구현 순서)

### 4.1 부분 ① — Claude Code slash command 마크다운 형식 조사

**목표:** `.claude/commands/` 안의 markdown 파일이 어떤 frontmatter와 본문 구조를 가져야 하는지 파악.

**작업:**
- Claude Code 공식 문서 또는 기존 slash command 예제(있다면 프로젝트 내 또는 Anthropic 예제)에서 frontmatter 필드 확인.
  - `name` — 슬래시 명령어 이름 (예: `init-project`)
  - `description` — 간단한 설명 (한 줄)
  - `arguments` — 인자 정의 (optional/required, type, description)
  - `allowed_tools` — 사용 가능한 도구 (예: `bash`, `file_read` 등)
  - 기타: `version`, `alias`, `help_text`, `category` 등 (있을 수 있음)
- 본문 구조 확인: instruction block의 형식 (지시문, 예제, 주의사항 등)
- 인자 전달 방식: 셸 스크립트로 어떻게 전달되는지 (환경변수 vs. 직접 argument)

**예상 산출물:**
- `.claude/commands/` 디렉토리 구조 및 마크다운 형식 정의서 (내부 참고용)
- 각 커맨드의 frontmatter 템플릿 스케치

### 4.2 부분 ② — 각 슬래시 명령어 인자 매핑

**목표:** 셸 스크립트의 CLI 인자를 slash command 정의의 `arguments` 섹션으로 변환.

**작업:**

#### init_project.sh
- `--with-env` — optional flag (boolean)
- `--no-prompt` — optional flag (boolean)
- `--force-reinit` — optional flag (boolean)
- 기본 동작 — 아무 인자 없으면 interactive 모드
- **slash command 인자:**
  - `--with-env` (optional, boolean, default: false) — "Copy .env.example → .env locally"
  - `--no-prompt` (optional, boolean, default: false) — "Use defaults, skip prompts (CI/automation mode)"
  - `--force-reinit` (optional, boolean, default: false) — "Rewrite settings.json v0.6 fields even if already v0.4"

#### switch_team.sh
- `<mode>` — required if not interactive. Values: `claude-only`, `claude-impl-codex-review`, `codex-impl-claude-review`
- `--status` — show current config (mutually exclusive with mode)
- `--force` — bypass background process check
- **slash command 인자:**
  - `mode` (optional string, one of: claude-only / claude-impl-codex-review / codex-impl-claude-review)
  - `--status` (optional, boolean, default: false) — "Display current team_mode without modification"
  - `--force` (optional, boolean, default: false) — "Bypass background process detection"

#### ai_step.sh
- `<stage_name>` — v0.5 호환 (예: `brainstorm`, `planning_draft`, ..., `qa`)
- `--stage <name>` — 명시적 형태
- `--status` — show current settings.json + next stage
- `--next` — run next 1 stage
- `--auto` — run until next approval gate (paused state)
- `--resume` — resume from paused state
- **slash command 인자:**
  - `stage_name` (optional string) — "V0.5-compatible stage name (e.g., brainstorm, planning_draft, ..., qa)"
  - `--status` (optional, boolean, default: false) — "Display current operation state"
  - `--next` (optional, boolean, default: false) — "Run next stage (1 step only, with gates)"
  - `--auto` (optional, boolean, default: false) — "Auto-run until next approval gate"
  - `--resume` (optional, boolean, default: false) — "Resume from paused state"

### 4.3 부분 ③ — 3개 slash command markdown 파일 작성

**작업:**

각 파일의 구조:
```
---
name: <명령어이름>
description: <한 줄 설명>
arguments:
  - name: <인자명>
    description: <설명>
    required: <true|false>
    type: <string|boolean|number>
    default: <기본값>
  - ...
allowed_tools:
  - bash
version: v0.6.2
---

# <커맨드 전체 이름>

## 용도

<목적 설명>

## 사용법

<예시>

## 주의사항

<경고/제한사항>

## 내부 매핑

이 커맨드는 다음 스크립트를 호출합니다:
```bash
bash scripts/<스크립트명>.sh [인자]
```
```

**각 파일의 내용 초안:**

#### `.claude/commands/init-project.md`
- 목적: "새 jOneFlow 프로젝트 초기화 + settings.json 세팅"
- 플래그 3개 모두 optional
- 기본 동작: interactive workflow_mode + team_mode 선택
- 내부: `bash scripts/init_project.sh [--with-env] [--no-prompt] [--force-reinit]`

#### `.claude/commands/switch-team.md`
- 목적: "런타임 team_mode 전환 (Stage 8/9/10 구현자 선택 변경)"
- mode 인자는 optional (없으면 interactive)
- `--status` 단독 사용 가능
- 내부: `bash scripts/switch_team.sh [<mode>] [--status] [--force]`

#### `.claude/commands/ai-step.md`
- 목적: "Stage 자동 진행 + v0.5 호환 prompt 출력"
- v0.5 호환 stage 이름 또는 `--next`/`--auto`/`--resume` 옵션
- `--status` 단독 사용 가능
- 내부: `bash scripts/ai_step.sh [<stage_name>|--stage <name>|--status|--next|--auto|--resume]`

### 4.4 부분 ④ — 동작 검증

**목표:** `.claude/commands/` 폴더와 3개 파일이 Claude Code 환경에서 정상 인식 및 호출되는지 확인.

**작업:**
- 슬래시 명령어 등록 확인: `/init-project` 입력 시 자동완성 + 도움말 표시 여부
- 인자 전달 검증: `/switch-team claude-only` 입력 시 대응 스크립트 호출 및 settings.json 갱신 확인
- 에러 처리: 알 수 없는 인자 입력 시 사용법 메시지 표시 여부
- 각 옵션 조합: `/ai-step --auto`, `/init-project --with-env --no-prompt` 등 조합 동작 확인

**산출물:**
- 슬래시 명령어 3개 모두 동작 로그 (stdout 캡처 또는 스크린샷)
- 오류 발생 시: 수정 로그 및 재테스트 결과

---

## Sec. 5. AC (Acceptance Criteria)

### AC-Slash-1 (F-SLA-1 분리): `/init-project` 명령어

| 측정 | 방법 |
|------|------|
| **AC-Slash-1a (자동)** | `grep -F "bash scripts/init_project.sh" .claude/commands/init-project.md` exit 0 |
| **AC-Slash-1b (수동, QA)** | Stage 12: `/init-project` 입력 시 stdout에 `init_project.sh: ...` 출력 확인 |

### AC-Slash-2 (F-SLA-1 분리): `/switch-team` 명령어

| 측정 | 방법 |
|------|------|
| **AC-Slash-2a (자동)** | `grep -F "bash scripts/switch_team.sh" .claude/commands/switch-team.md` exit 0 |
| **AC-Slash-2b (수동, QA)** | Stage 12: `/switch-team claude-only` 입력 시 settings.json 갱신 확인 |

### AC-Slash-3 (F-SLA-1, F-SLA-2 분리): `/ai-step` 명령어

| 측정 | 방법 |
|------|------|
| **AC-Slash-3a (자동)** | `grep -F "bash scripts/ai_step.sh" .claude/commands/ai-step.md` exit 0 |
| **AC-Slash-3b (수동, QA + approval gate 검증)** | Stage 12: `/ai-step --auto` 입력 시 Stage 4에서 approval gate 정상 멈춤 확인 (F-SLA-2 의존성) |

### AC-Slash-4 (F-SLA-4, Stage 5 이월): 파일 구조 정확성

- `.claude/commands/` 폴더만 신규 생성 (다른 경로 미변경)
- 3개 markdown 파일 정확히 생성 (오작성 0)
- frontmatter 필드 spec 확정은 Stage 5 기술 설계 (F-SLA-4)

### AC-Slash-5 (F-SLA-5 강화): 문서화 강제 + 측정

- **강제:** `docs/guides/` 또는 `README.md`에 slash command 사용법 추가
- **측정:** `grep -c "/init-project\|/switch-team\|/ai-step" README.md` ≥ 3

### AC-Slash-6: 호환성 확인

- `grep -F "bash scripts/init_project.sh" .claude/commands/init-project.md` 확인 (기존 스크립트 호출 명시)
- 기존 직접 호출 경로 유지 (래퍼만 추가)

---

## Sec. 6. 의존성 & 선행 조건

### 외부 의존성

- **Claude Code 환경:** slash command 실행 능력 필요 (v0.7+로 추정)
- **셸 스크립트:** `scripts/init_project.sh`, `switch_team.sh`, `ai_step.sh` v0.6 이상 (이미 구현 완료)
- **ai_step.sh approval gate 식별 (F-SLA-2):** `/ai-step --auto`가 Stage 4에서 approval gate 정확히 인식해야 AC-Slash-3b 통과

### 선행 작업 (F-X-7 구현 순서)

권장 구현 순서: **02(license) → 01(org) → 05(selfedu) → 04(handoffs) → 03(본 항목, 마지막)**.
본 항목은 5개 planning 중 **마지막**으로 구현. planning_04 hook 구현 완료 후 회귀 테스트 필수.

- planning_01_org.md — 비의존 (병렬 진행 가능, 그러나 구현 순서상 선행)
- planning_02_license.md — 비의존 (신규 .md 파일은 SPDX 헤더 미적용, F-X-6)
- **planning_04_handoffs.md** — **선행 필수:** `/ai-step` 자동화 hook이 planning_04에 포함. hook 구현 완료 후 본 slash command 회귀 테스트 (F-X-3, Stage 5 이월)

### 후행 작업

- **Stage 5 기술 설계** — 
  - frontmatter 필드 spec 조사 (F-SLA-4)
  - .claude/commands/ 마크다운 형식 확정
  - settings.json과의 상호작용 정의 (F-SLA-3, .claude/commands ↔ settings.json)
- **Stage 8 구현** — `.claude/commands/` 폴더 생성 + 3개 파일 작성
- **Stage 12 QA** — 각 슬래시 명령어 동작 테스트 (AC-Slash-1b/2b/3b)

---

## Sec. 7. 위험 요소 & 완화 전략

### 위험 1: Claude Code slash command spec 불확정 (F-SLA-4 이월)

**위험도:** 중 (spec 변경 가능성)

**원인:**  
Claude Code의 slash command 정의 형식이 공식 문서화되지 않았거나, 향후 마이너 버전에서 변경될 수 있음.

**완화 전략:**
- **Stage 5에서 Claude Code 공식 문서 또는 최신 예제 조사 필수 (F-SLA-4)**
- markdown frontmatter 필드 모두 명시적으로 주석화하여 향후 업데이트 용이하게 함
- fallback: 슬래시 명령어 인식 실패 시 사용자가 기존 `bash scripts/` 직접 호출로 복귀 가능 (안정성 확보)

### 위험 2: 인자 escape 및 특수문자 처리

**위험도:** 낮 (대부분 단순 플래그)

**원인:**  
slash command 인자 전달 시 공백, 따옴표, 특수문자(`--`, `=` 등)가 올바르게 escape되지 않을 수 있음.

**완화 전략:**
- Stage 5 기술 설계에서 인자 파싱 규칙 명확화 (quoted args, unquoted args 분리)
- 복잡한 인자(예: mode 문자열에 하이픈 포함)는 선택지 드롭다운 또는 enum으로 제한
- 테스트 케이스: `/switch-team codex-impl-claude-review` (긴 mode 문자열 with 하이픈)

### 위험 3: 환경변수 전달 & settings.json 결합 (F-SLA-3 Stage 5 이월)

**위험도:** 중 (설계 의존)

**원인:**  
slash command 실행 시 환경변수(예: `JONEFLOW_ROOT`)를 어떻게 inject할지, `.claude/commands/` frontmatter가 settings.json 필드를 동적으로 참조할 수 있는지 불명확.

**완화 전략:**
- **Stage 5에서 정책 명시 (F-SLA-3):** ".claude/commands/<cmd>.md frontmatter는 settings.json 필드 직접 참조 불가, bash 호출만 허용"
- 각 스크립트가 이미 `JONEFLOW_ROOT` 자동 감지 로직을 갖고 있으므로 의존성 최소화
- slash command 실행 컨텍스트가 현재 프로젝트 루트라고 가정하고 설계

### 위험 4: slash command 파일 경로 변경

**위험도:** 낮 (내부 정책)

**원인:**  
향후 `.claude/commands/` 경로가 다른 이름으로 변경될 가능성 (예: `.claude/tools/`, `.claude/macros/`).

**완화 전략:**
- 현재는 `.claude/commands/` 표준을 따라 생성
- CLAUDE.md 또는 README에 "slash command 파일 위치는 `.claude/commands/` 고정"이라고 명시
- 경로 변경 시 마이그레이션 스크립트 제공 (이월 사항)

---

## Sec. 8. 리소스 예상

| 작업 | 소요 시간 | 담당 |
|------|---------|------|
| 4.1 — spec 조사 | 30~40분 | 기술 설계 담당자 |
| 4.2 — 인자 매핑 | 20~30분 | 드래프터 |
| 4.3 — markdown 작성 | 1~1.5시간 | 드래프터 |
| 4.4 — 검증 | 30~45분 | QA 담당자 |
| **합계** | **약 2.5~3시간** | — |

**모드별 예상:**
- **Lite:** 기존 슬래시 명령어 복사 + 3개 파일 추가만 (1시간)
- **Standard:** 신규 설계 + 테스트 (2.5~3시간, 본 항목)
- **Strict:** 슬래시 명령어 spec 변경 대응 + 보안 검토 포함 (4시간+)

---

## Sec. 9. 참고 & 연관 문서

- **brainstorm.md Sec.5** — slash command 원래 요구사항
- **init_project.sh** — `/init-project` 대상 스크립트 + 인자 시그니처
- **switch_team.sh** — `/switch-team` 대상 스크립트 + 인자 시그니처
- **ai_step.sh** — `/ai-step` 대상 스크립트 + 인자 시그니처
- **CLAUDE.md Sec.2** (향후) — "slash command 소개" 섹션 추가 가능

---

## Sec. 10. 승인 체크리스트

**이 planning document는 아래 항목이 확인될 때 Stage 3 리뷰로 진행합니다:**

- [ ] 목적(Sec.1): "비개발자 진입 장벽 제거 + 셸 스크립트 경로 외우지 않고도 운영 가능" 명확 ✓
- [ ] 범위(Sec.2): 3개 파일 + `.claude/commands/` 폴더만 신규, 기존 스크립트 미수정 ✓
- [ ] 변경 대상(Sec.3): 100~130줄, 중규모 변경 ✓
- [ ] 단계 분해(Sec.4): 4개 부분으로 명확하게 분할 ✓
- [ ] AC(Sec.5): 6개 체크리스트, 각 슬래시 명령어 1개씩 + 파일 구조 + 문서화 ✓
- [ ] 위험(Sec.7): 4개 위험 식별 + 완화 전략 명시 ✓
- [ ] 리소스(Sec.8): 2.5~3시간 예상 ✓

---

## Sec. 9. Stage 5 이월 표

| 이월 ID | 내용 | 담당 | 시점 |
|--------|------|------|------|
| **F-SLA-4** | `.claude/commands/<cmd>.md` frontmatter 필드 spec 조사. Claude Code 공식 문서 또는 예제에서 name/description/arguments/allowed_tools 확정. AC-Slash-4 측정 명령(`yaml.safe_load`) 박음 | Stage 5 기술 설계 | **필수** |
| **F-SLA-3** | `.claude/commands/<cmd>.md` frontmatter는 settings.json 필드 직접 참조 불가 정책 명시. bash 호출만 허용 | Stage 5 기술 설계 | **필수** |
| **F-X-3** | planning_04 hook 회귀 테스트: ai_step.sh archive hook 추가 후 `/ai-step --auto` 경로에서도 정상 동작. init_project.sh `--no-prompt` 모드의 frontmatter mode 기본값 "Standard" 명시 | Stage 5 기술 설계 | **필수** |

---

## 변경 이력

### v3 final (2026-04-26, 세션 25, 안영이 finalizer)
- 횡단 F-X-3/F-X-6/F-X-7 흡수: planning_04 hook 회귀 테스트 이월, .md 파일 SPDX 미적용, 구현 순서(마지막) 박음
- Sec.0 변경 요약 추가 (v2→final 이력표)
- 의존 그래프 수렴: 선행 작업 구현 순서 명시 (F-X-7, 마지막 구현)
- Stage 5 이월 표 신설 (F-SLA-4 + F-SLA-3 + F-X-3)
- 운영자 결정 게이트: 본 항목 해당 Q 없음 (운영자 결정 사항 불요)

### v2 (2026-04-26, 세션 25, planning_review.md 흡수)
- F-SLA-1: AC-Slash-1~3을 자동(grep)/수동(QA) 단계로 분리 (AC-1a/1b, AC-2a/2b, AC-3a/3b)
- F-SLA-2: `/ai-step --auto` approval gate 의존성 명시 (Sec.6 추가)
- F-SLA-3: .claude/commands ↔ settings.json 결합 범위 명시 (Stage 5 이월)
- F-SLA-4: frontmatter spec 조사 Stage 5 이월 + AC-Slash-4 측정 방법 미정 명시
- F-SLA-5: AC-Slash-5 "권장"을 강제 + grep 측정으로 강화

**Authored by:** 장그래 (Drafter, Haiku/medium)  
**Finalized by:** 안영이 (Finalizer, Sonnet/medium)
**Date:** 2026-04-26  
**Mode:** Standard
