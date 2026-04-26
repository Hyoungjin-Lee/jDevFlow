---
version: v0.6.4
stage: 4 (plan_final)
date: 2026-04-27
mode: Strict
status: pending_operator_approval
item: 01_M1_scaffold
revision: v3 (final)
draft_by: 장그래 (기획팀 주임연구원, Haiku) — v1 초안 + v2 review 흡수
finalized_by: 안영이 (기획팀 선임연구원, Sonnet/medium)
final_at: 2026-04-27
upstream:
  - docs/01_brainstorm_v0.6.4/brainstorm.md (의제 8 마일스톤 M1)
  - dispatch/2026-04-27_v0.6.4_stage234_planning.md
  - docs/02_planning_v0.6.4/planning_review.md (김민교 reviewer)
incorporates_review: docs/02_planning_v0.6.4/planning_review.md
incorporates_v2: 장그래 drafter v2 (revised, 세션 27 후속)
revisions_absorbed:
  - F-M1-1 (Sec.3 진입점 단일화 — `scripts/dashboard.py`)
  - F-M1-2 (Sec.5 AC 표 자동/수동 컬럼 + AC-M1-3 grep 패턴 정정)
  - F-M1-3 (init_project.sh 통합 = v0.6.4 scope, AC-M1-7 단순화)
  - F-X-2 (read-only 정책 명시 + AC-M1-9 신규)
  - F-X-7-#1 (Q-M1-3 → 단일 `requirements.txt` 결정)
  - F-M1-S5-1 (Stage 5 이월 유지, F-D4 sync vs async 통합 표시)
cross_cutting_absorbed:
  - F-D2 (정책 commit 본문 박음 — `scripts/dashboard.py` 단일 진입 + `scripts/dashboard/<module>.py` 패키지)
  - F-D4 (인터페이스 dataclass 일관성 명시, sync 시작 / async 채택은 Stage 5)
  - F-X-2 (read-only 정책 5개 doc 표준 — AC-M1-9 박힘)
  - F-X-3 (Stage 5 이월 통합 표 → planning_index.md 단일 source of truth, 본 doc Sec.9는 스냅샷 유지)
  - F-X-7-#1 (drafter 자율 영역 미회수 — 단일 `requirements.txt`)
---

# v0.6.4 M1: `/dashboard` 슬래시 커맨드 + textual scaffold

> **본 문서 위치:** `docs/02_planning_v0.6.4/planning_01_M1_scaffold.md`
> **상위:** `docs/01_brainstorm_v0.6.4/brainstorm.md` Sec.8 (의제 8 마일스톤 M1)
> **상태:** 🟡 plan_final v3 (Stage 4 finalizer 안영이, 운영자 승인 대기 — Stage 4.5 게이트)
> **다음:** Stage 4.5 운영자 승인 게이트 (Q1~Q5 답변) → 박지영 PL planning_index.md 통합 → Stage 5 기술 설계

> **v3 갱신 범위 (finalizer 안영이):** v2(장그래 drafter) 위에 정책 commit 본문 결정 문장(F-D2 / F-D4) + 횡단 흡수 추가 분(F-X-2 / F-X-3 / F-X-7-#1)을 박았습니다. F-D 본문 결정은 reviewer 권장(planning_review.md Sec.8) verbatim으로 흡수했으며, finalizer 임의 결정 영역이 아닙니다. F-D3(M5 PM/CTO/CEO)는 본 doc 영역 외라 미박음.

---

## Sec. 0. 요약 (v3 final 갱신)

### Sec. 0.1 v3 final 변경 요약 (finalizer 흡수)

본 v3는 v2(장그래 drafter, Stage 3 review 흡수 6건) 위에 finalizer 안영이가 정책 commit 본문 결정 + 횡단 흡수를 추가한 final 산출물입니다. 본 stage에서는 운영자 결정 게이트(Q5)는 표시만 박고 답변은 Stage 4.5에서 회수합니다.

| ID | 유형 | 위치 | 변경 요지 (drafter v2 → finalizer v3) |
|----|------|------|----------------------------------|
| F-M1-1 | 명시 추가 (v2 흡수 유지) | Sec.3 | 진입점 위치 `scripts/dashboard.py` 단일화. v3 finalizer가 F-D2 본문 결정으로 승격. |
| F-M1-2 | 명시 추가 (v2 흡수 유지) | Sec.5 AC 표 | 자동/수동 컬럼 + AC-M1-3 grep 패턴 정정. v3 변경 없음. |
| F-M1-3 | 명시 추가 (v2 흡수 유지) | Sec.4.5 / AC-M1-7 / R4 / Q-M1-4 | init_project.sh 통합 = v0.6.4 scope. v3 변경 없음. |
| F-X-2 | 횡단 흡수 (v2) | Sec.2 + AC-M1-9 | read-only 정책 명시 + AC-M1-9 자동 검증. v3 변경 없음. |
| F-X-7-#1 | 자율 영역 (v2 흡수 유지) | Sec.4.3 / Q-M1-3 | 단일 `requirements.txt`. v3 변경 없음. |
| **F-D2** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.3 머리말 + Sec.4.2** | **본 v0.6.4 대시보드 산출물 위치를 단일화하는 결정 문장으로 본문 박음** — 진입점 `scripts/dashboard.py` 단일 + 모듈 패키지 `scripts/dashboard/<module>.py` + 슬래시 정의 `.claude/commands/dashboard.md`. M3 `src/dashboard/...` / M4 `dashboard/...` 충돌을 닫음. |
| **F-D4** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.4.2 + Sec.7 R5 + Sec.9 F-M1-S5-1** | **인터페이스 dataclass 일관성 + sync 시작 / async = Stage 5** 결정을 본문 박음. M1 `on_mount()` 동기 훅과 정합성 확보. |
| F-X-3 | 횡단 흡수 (v3 finalizer) | Sec.9 머리말 | Stage 5 이월 통합 표 단일 source of truth = planning_index.md (박지영 PL 영역). 본 doc Sec.9는 M1 스냅샷 유지. |
| F-M1-S5-1 | Stage 5 이월 (v2 흡수 유지) | Sec.9 | App ↔ M2 인터페이스 정의 — F-D4 통합. v3 wording 정리. |

> **finalizer 흡수 결과:** 본 v3는 drafter 권한 밖 정책 commit 2건(F-D2 / F-D4)을 본문 결정 문장으로 닫고, 횡단 영역 1건(F-X-3)을 planning_index 포인터로 정리했습니다. 본 stage 잔존 운영자 결정 = Q-M1-1(M-Slash 구조) / Q-M1-5(테스트 형식) — 둘 다 Stage 5 영역.

### Sec. 0.2 v1 요약

M1은 `/dashboard` 슬래시 커맨드를 jOneFlow M-Slash wrapper에 등록하고, Python `textual` 기반 TUI 프레임워크(App 클래스, 종료 키 `q`, 기본 레이아웃)를 구축하는 단계입니다. 데이터 수집(M2), 렌더링(M3), 알림(M4) 등 후속 마일스톤의 진입점 역할을 합니다.

---

## Sec. 1. 목적 (Purpose)

Jonelab AI팀 운영자 대시보드는 실시간 팀 상태를 read-only로 가시화하는 도구입니다. M1은 이 대시보드의 **슬래시 커맨드 등록**과 **TUI 엔진 초기화**를 담당합니다. 구체적으로:

1. **슬래시 커맨드 진입점** — 기존 jOneFlow `init-project` / `switch-team` / `ai-step` 패턴에 맞추어 `/dashboard`를 jOneFlow M-Slash wrapper에 등록합니다. 운영자가 `/ dashboard`로 대시보드를 시작할 수 있도록 합니다.

2. **textual App scaffold** — Python `textual` 라이브러리(rich 기반 TUI, CSS-like 스타일링, 마우스 + 키보드 지원)를 초기화하며, 기본 App 클래스와 종료 키(`q`)를 구현합니다.

3. **후속 마일스톤 진입점** — M1 완료 후 M2(데이터 수집), M3(렌더링), M4(알림)가 hook을 통해 추가될 수 있도록 진입점만 확보합니다.

---

## Sec. 2. 범위 (Scope)

### 변경 항목 (M1에서 구현)

- `.claude/commands/dashboard.md` — 신규 슬래시 커맨드 정의 (jOneFlow M-Slash wrapper 위에 등록)
- `scripts/dashboard.py` — 단일 진입점 (textual App 클래스 골격, 종료 `q`). **v2 (F-M1-1 + F-D2 후보):** `scripts/dashboard.py` 단일 위치로 박았으며 finalizer 결정 대기. M3/M4 신규 모듈은 `scripts/dashboard/<module>.py` 패키지로 확장 가능 영역.
- `requirements.txt` — `textual >= 0.50.0` 의존성 추가 (**v2 F-X-7-#1 흡수:** 단일 파일, jOneFlow 컨벤션. 별도 `requirements-dashboard.txt` 옵션 회수)
- `scripts/init_project.sh` — 신규 프로젝트 scaffold 시 `scripts/dashboard.py` + `.claude/commands/dashboard.md` 복사 대상 포함 (**v2 F-M1-3 흡수:** v0.6.4 scope 박음)

### 미변경 항목 (read-only 정책 — brainstorm 의제 5 영구 적용)

> **v2 (F-X-2 흡수):** 본 마일스톤은 brainstorm 의제 5의 read-only 정책을 영구 적용합니다. 대시보드 코드 어디서도 git push / git commit / 파일 write 명령이 발생해서는 안 되며, write 영역 진입 신호 발견 시 즉시 Stage 4 review 회귀 대상이 됩니다 (M4 AC-M4-N9 패턴 참조, M1은 AC-M1-9 신규).

- `scripts/ai_step.sh`, `.claude/settings.json`, HANDOFF.md 등 기존 운영 파일 — 일절 변경 안 함
- 데이터 수집 로직 (tmux capture-pane 파싱, 토큰량 계산, working·idle 추론) — M2 이월
- UI 렌더링 (박스 3개, 행 배치, 다중 버전 동시 표시) — M3 이월
- 알림 채널 (macOS 알림, osascript/Pushover/CCNotify 선택) — M4/M5 이월
- 색상 팔레트, 단축키, CSS 스타일링 — Stage 5 기술 설계에서 정의

---

## Sec. 3. 변경 대상 파일

> **v3 finalizer (F-D2 정책 commit 본문 결정):** 본 v0.6.4 대시보드 산출물 위치는 다음과 같이 단일화합니다.
> 1. **진입점:** `scripts/dashboard.py` 단일 파일. jOneFlow `scripts/` 컨벤션 일관성 — `init_project.sh` / `ai_step.sh` / `git_checkpoint.sh`와 동등 위치.
> 2. **모듈 패키지:** `scripts/dashboard/<module>.py` (M3 `team_renderer.py` / `models.py`, M4 `pending.py` / `notifier.py` / `data_adapters.py` / `ui/pending_widgets.py`).
> 3. **슬래시 커맨드 정의:** `.claude/commands/dashboard.md`.
>
> 본 결정으로 doc 간 위치 충돌(M3 `src/dashboard/components/...` / M4 `dashboard/...` / M1 `scripts/dashboard.py 또는 dashboard/main.py`) 3개 후보를 닫습니다. 본 결정은 reviewer 권장(planning_review.md F-D2, F-X-1 후속) verbatim 흡수입니다.

| 파일 | 섹션/영역 | 작업 | 라인 수 예상 |
|------|---------|------|-----------|
| `.claude/commands/dashboard.md` | (신규) | 슬래시 커맨드 정의 (init-project 패턴 참조) | ~30 |
| `scripts/dashboard.py` | (신규, **v3 F-D2 본문 결정**) | textual App 클래스 + 종료 `q` + 기본 레이아웃 | ~80 |
| `scripts/dashboard/<module>.py` | (M3/M4 확장 영역, **v3 F-D2 패키지 단일**) | M3 `team_renderer.py` + `models.py` / M4 `pending.py` + `notifier.py` 등 | (M3/M4 산출) |
| `requirements.txt` | 의존성 | `textual >= 0.50.0` 한 줄 추가 (**v2 F-X-7-#1:** 단일 파일 jOneFlow 컨벤션) | 1 |
| `scripts/init_project.sh` | scaffold | `scripts/dashboard.py` + `.claude/commands/dashboard.md` 복사 대상 포함 (**v2 F-M1-3:** v0.6.4 scope) | 수정 |

---

## Sec. 4. 단계별 작업 분해

### 4.1 슬래시 커맨드 등록 (`/dashboard`)

- 기존 `scripts/init_project.sh` 또는 `scripts/ai_step.sh` 구조 분석 → M-Slash wrapper 호출 규칙 파악
- `.claude/commands/dashboard.md` 신규 작성 (명령어 이름, 설명, 호출 시 실행할 스크립트 경로)
- jOneFlow M-Slash 레지스트리에 `dashboard` 진입점 등록 (자동/수동 검토)

### 4.2 textual App 초기 구조

- `scripts/dashboard.py` 단일 진입점 (**v3 F-D2 본문 결정**). 별도 `dashboard/` 폴더 후보 회수.
- 최소 구성: `from textual.app import ComposeResult` / `class DashboardApp(App)` / `compose()` 메서드 / `on_mount()` 훅
- 종료 키 `q` 바인딩 (`self.exit()`)
- 기본 Container 또는 Screen 객체로 placeholder 레이아웃 준비 (실제 렌더링은 M3)

> **v3 finalizer (F-D4 정책 commit 본문 결정):** 본 v0.6.4 데이터 수집 인터페이스 dataclass 일관성은 다음과 같이 정리합니다.
> 1. M2 `PersonaDataCollector` / M4 `PendingDataCollector` 두 클래스의 메서드 시그니처는 dataclass(`PersonaState` / `PendingPush` / `PendingQuestion`) 입출력으로 통일 — primitive 타입(str/int/dict) 직접 노출은 회수합니다.
> 2. **sync vs async 결정은 Stage 5 기술 설계 영역**입니다 — M1 본 stage는 `on_mount()` 동기 훅 + sync 인터페이스로 시작하고, async wrapper 채택 여부는 textual `App.run_worker(thread=True)` 패턴과 함께 Stage 5에서 결정합니다.
>
> 본 결정으로 M1 `on_mount()` 동기 훅과 M2 인터페이스 정합성을 확보하고, M2 v1의 `persona_by_name`만 동기였던 일관성 깨짐을 닫습니다. 본 결정은 reviewer 권장(planning_review.md F-D4, F-X-4 흡수) verbatim입니다.

### 4.3 의존성 관리

- `requirements.txt`에 `textual >= 0.50.0` 추가 (**v2 F-X-7-#1 흡수:** 단일 파일, 별도 `requirements-dashboard.txt` 옵션 회수. jOneFlow 컨벤션 일관성)
- venv `venv/bin/python3` 표준 환경에서 설치 가능 확인 (자동 검증 = Stage 5 영역)
- textual 버전 호환성 (Python 3.8+, macOS/Linux/Windows 크로스 플랫폼)

### 4.4 진입점 테스트

- `python3 scripts/dashboard.py --help` 또는 해당 스크립트 실행으로 기본 App 시작 가능 여부 확인
- `q` 키 입력 시 정상 종료 확인
- `KeyError` / `ImportError` 등 import 오류 0건 (python3 -m py_compile로 문법 검사)

### 4.5 init_project.sh scaffold 통합 (v2: v0.6.4 scope 확정)

> **v2 (F-M1-3 흡수):** brainstorm Sec.3 Non-goal은 "상태 보존" 및 "스플릿/탭 정책"이지 "init_project.sh scaffold 복사"는 아닙니다. v1에서 Stage 8로 4번 미루던 결정을 v0.6.4 scope에 포함시켜 finalizer가 plan_final 본문에 박을 것을 권장합니다.

- 신규 프로젝트 `bash scripts/init_project.sh` 시 `scripts/dashboard.py` + `.claude/commands/dashboard.md`를 복사 대상에 포함 — **본 v0.6.4 Stage 8 구현 영역**.
- 결정 trail: F-M1-3 reviewer 권장 그대로 v2 흡수. AC-M1-7 측정 명령 단순화(`grep -E "dashboard" scripts/init_project.sh ≥ 1`).
- 본 결정 확정 시 Q-M1-4 회수 가능 영역 (finalizer 영역).

---

## Sec. 5. AC (Acceptance Criteria)

> **v2 (F-M1-2 + F-X-2 흡수):** "측정: 자동/수동" 컬럼 명시. AC-M1-3 grep 패턴 false-positive 회피로 정정. AC-M1-9 신규(read-only 정책 자동 검증, M4 AC-M4-N9 패턴 인용).

| AC ID | 기준 | 측정 | 측정 명령/방법 |
|-------|------|------|------------|
| **AC-M1-1** | 슬래시 커맨드 `/dashboard` 등록 완료. jOneFlow M-Slash wrapper에 `dashboard` 진입점이 명시적으로 등록됨. | 자동 | `grep -c "/dashboard\|dashboard" .claude/commands/dashboard.md` ≥ 1 |
| **AC-M1-2** | textual App 클래스 구현. `from textual.app import App` import + `class DashboardApp(App)` 정의 + `compose()` 메서드 기본 구현. | 자동 | `python3 -m py_compile scripts/dashboard.py` 정상 종료 (SyntaxError 0) |
| **AC-M1-3** | 종료 키 `q` 바인딩. `BINDINGS` 또는 `action_quit` 정의로 `q` 입력 시 앱 종료. | 자동 | `grep -E "BINDINGS.*\"q\"\|action_quit\|Binding\(.q." scripts/dashboard.py` ≥ 1 (**v2 정정:** false-positive 다발하던 단일 `q` grep 회수) |
| **AC-M1-4** | 기본 레이아웃 placeholder. Container/Screen 객체로 아무것도 렌더링 안 해도 앱이 정상 시작(M3 진입점만 확보). | 수동 | 앱 기동 시 화면 떠서 가시적 오류 0 (수동 visual 검사 — automation 불가 영역) |
| **AC-M1-5** | 의존성 명시. `requirements.txt`에 `textual >= 0.50.0` 추가. | 자동 | `grep -i "textual" requirements.txt` ≥ 1 |
| **AC-M1-6** | 진입점 호출 가능. `python3 scripts/dashboard.py`로 기본 App 시작 가능 (ImportError / NameError 0, exit code 0). | 자동 | `python3 scripts/dashboard.py & PID=$! ; sleep 1 ; kill $PID 2>/dev/null ; wait $PID 2>/dev/null ; [ $? -le 143 ]` 정상 시작/종료 검증 |
| **AC-M1-7** | init_project.sh 통합. v0.6.4 scope에 포함 — `scripts/init_project.sh`가 신규 프로젝트 scaffold 시 `scripts/dashboard.py` + `.claude/commands/dashboard.md` 복사 대상에 포함. | 자동 | `grep -E "dashboard" scripts/init_project.sh` ≥ 1 (**v2 단순화: F-M1-3 흡수**) |
| **AC-M1-8** | 코드 품질. python3 -m py_compile로 문법 검사 정상, 주요 함수/클래스에 docstring 기본 구현 (1줄 이상 설명, skeleton 단계 최소 기준). | 자동 | `python3 -m py_compile scripts/dashboard.py && grep -c "\"\"\"" scripts/dashboard.py` ≥ 1 |
| **AC-M1-9** (v2 신규, F-X-2) | read-only 정책 자동 검증. 대시보드 코드 어디에도 write 명령(git push / git commit / open with mode 'w') 0건. | 자동 | `grep -cE "git push\|git commit\|open\(.*['\"]w['\"]" scripts/dashboard.py scripts/dashboard/*.py 2>/dev/null \| awk -F: '{s+=$2} END{print s+0}'` = 0 |

---

## Sec. 6. 의존성

### 내부 의존성

- **M1은 cold start** — 선행 마일스톤 없음. brainstorm.md 의제 8 M1 정의만 필요.
- **M2/M3/M4/M5의 진입점** — M1 완료 후 이들 마일스톤이 의존. M1 hook 구조(App 클래스 구성, 데이터 레이어 연결점 위치)가 M2~ 설계에 영향.

### 외부 의존성

- **textual 라이브러리** — Python 3.8+ / macOS / Linux / Windows 크로스 플랫폼. 버전 >= 0.50.0 (2024년 현재 stable).
- **venv 환경** — `venv/bin/python3` 표준 jOneFlow 환경 가정.

### 다른 마일스톤과의 관계

| M | 관계 |
|---|------|
| M2 (데이터 수집) | M1 완료 후 M1의 App 클래스에 data layer hook 추가 |
| M3 (렌더링) | M1 App의 `compose()` 메서드 확장으로 박스 3개 추가 |
| M4 (알림) | M1 App의 이벤트 핸들러에 알림 trigger 추가 |
| M5 (Windows + 18명 매핑) | M1~M4 완료 후 크로스 플랫폼/페르소나 통합 |

---

## Sec. 7. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 |
|----|--------|-----------|--------|------|
| **R1** | textual 버전 호환성 — 설치된 textual 버전이 지정 버전과 충돌 | 낮음 | 중 | requirements.txt 버전 >= 0.50.0으로 지정. venv 신규 생성 시 자동 설치 스크립트로 검증. |
| **R2** | 슬래시 커맨드 등록 실패 — jOneFlow M-Slash wrapper 구조 미파악 | 중 | 높음 | init-project / switch-team / ai-step 기존 슬래시 커맨드 `.claude/commands/` 구조 분석 후 대칭 구현. Stage 3 plan_review에서 구조 검증. |
| **R3** | textual import 오류 — setup.py / requirements 누락으로 venv에 textual 미설치 | 중 | 높음 | requirements.txt 단계에서 명시적 추가 + python3 -m pip install -r requirements.txt 검증 스크립트 포함. |
| **R4** | init_project.sh 통합 시점 불명확 — scaffold 복사 대상이 모호해질 수 있음 | **낮음** (v2: 해소 진행 중) | 중 | **v2 (F-M1-3 흡수):** v0.6.4 scope 박힘 → Stage 8에서 `scripts/dashboard.py` + `.claude/commands/dashboard.md` 복사 대상 포함. AC-M1-7로 자동 검증. R4 closure 후보. |
| **R5** | 기본 레이아웃 placeholder 정의 불명확 — M2/M3 진입점 인터페이스 미정 | **낮음** (v3: F-D4 본문 결정으로 해소 진행 중) | 중 | **v3 (F-D4 본문 결정 흡수):** M1 App ↔ M2 data layer 인터페이스 = sync 시작 (Sec.4.2 본문 결정). textual `on_mount()` 동기 훅 + `PersonaDataCollector` sync 시그니처 정합. async wrapper 채택은 Stage 5 영역. R5 closure 후보 (Stage 5 final 후 closure). |

---

## Sec. 8. 열린 질문 (Stage 3 plan_review에서 판단 → v2 흡수 후 잔존)

> **v2 갱신:** Q-M1-2/3/4는 v2에서 흡수되어 회수됩니다. Q-M1-1/5만 잔존 — Stage 5 기술 설계 영역.

| # | 질문 | 담당 | 타겟 |
|----|------|------|------|
| **Q-M1-1** | jOneFlow M-Slash wrapper 구조 확정. `.claude/commands/` 레지스트리 형식 / hook 호출 방식 / 기존 커맨드와 호환성 | Stage 5 기술 설계 | brainstorm/dispatch에 명시되지 않은 기술 detail |
| ~~Q-M1-2~~ (v2 흡수) | ~~진입점 위치~~ → **F-D2 후보 plan_final 흡수**: `scripts/dashboard.py` 단일 (F-M1-1 reviewer 권장 v2 반영, finalizer 본문 결정 commit 대기) | finalizer | — |
| ~~Q-M1-3~~ (v2 흡수) | ~~의존성 격리~~ → **단일 `requirements.txt`** (F-X-7-#1 흡수, jOneFlow 컨벤션) | — | — |
| ~~Q-M1-4~~ (v2 흡수) | ~~init_project.sh 통합~~ → **v0.6.4 scope 포함** (F-M1-3 흡수, AC-M1-7 자동 검증) | — | — |
| **Q-M1-5** | 테스트 형식. M1 scaffold 검증을 "import test" 수준으로 할지, "실행 test"(앱 시작 후 `q` 입력)까지 할지 | finalizer 또는 Stage 5 | AC-M1-6 자동 검증 명령어 구체화 (v2: AC-M1-6에 exit code 검증 박음) |

---

## Sec. 9. Stage 5 이월 표

> **v3 (F-X-3 통합 표 finalizer 흡수):** 본 doc Sec.9는 M1 스냅샷으로 보존하며, 5개 doc 합산 통합 Stage 5 이월 표는 **`planning_index.md` 단일 source of truth**(박지영 PL 영역)로 수렴합니다. 본 표 항목 ID는 그대로 유지하되 통합 표에서 중복 제거 후 단일 표시 예정입니다.

| 이월 ID | 내용 | 담당 | 시점 |
|--------|------|------|------|
| **F-M1-S5-1** | M1 ↔ M2 데이터 레이어 인터페이스 정의 — App 클래스의 어느 메서드/이벤트에서 M2 data layer를 호출할지. **v3 (F-D4 본문 결정 흡수):** sync 시작 박힘, async wrapper 채택 여부만 Stage 5 잔존. | Stage 5 기술 설계 | 필수 (M1 hook 구조 확정) |
| **F-M1-S5-2** | textual CSS 스타일링 기본 정책 — color palette / font / 단축키 (r=refresh, c=clear 등) spec | Stage 5 | 권장 (현 M1은 skeleton 수준) |
| **F-M1-S5-3** | Windows 크로스 플랫폼 호환 — Ghostty / Windows Terminal / WSL 환경 검증 scope | Stage 5 | 권장 (M5와 통합) |
| **F-M1-S5-4** | 갱신 주기 기본값 — 1~2초 잠정, Stage 5에서 성능 검토 후 확정 (**v2:** M2 idle T 임계와 독립 변수, F-M2-4 sync) | Stage 5 기술 설계 | 권장 (M2와 통합) |

---

## Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | v1 초안 (세션 27) | brainstorm.md 의제 8 M1 기반. Sec.1~10 골격 작성. Q-M1 5건 / AC-M1 8건 / R1~R5 5건 리스크. |
| 2026-04-27 | v2 revised (장그래 drafter, 세션 27 후속) | Stage 3 plan_review 흡수 6건 (F-M1-1~3 / F-X-2 / F-X-7-#1 / F-D2 후보 표시). AC 8 → 9건(AC-M1-9 read-only 신규). Q-M1 5 → 2건(Q-M1-2/3/4 흡수). R4 closure 후보. 진입점 단일화 + read-only 정책 박음 + init_project.sh v0.6.4 scope 확정. |
| 2026-04-27 | **v3 final** (안영이 finalizer, 기획팀 선임연구원 Sonnet/medium) | v2 위에 정책 commit 본문 결정 박음 — **F-D2** Sec.3 머리말 + Sec.4.2(`scripts/dashboard.py` 단일 + `scripts/dashboard/<module>.py` 패키지), **F-D4** Sec.4.2 + Sec.7 R5 + Sec.9 F-M1-S5-1(인터페이스 dataclass 일관성 + sync 시작 / async = Stage 5). 횡단 흡수: F-X-3 Sec.9 머리말(planning_index 통합 포인터). Q5 잔존 = Stage 4.5 운영자 승인 게이트(M2 영역 Q5 sync). status: pending_operator_approval. plan_draft 5종은 Stage 2 스냅샷 보존(이력 한 줄 추가). |

---

## 참고: brainstorm 의제 8 M1 정의 (상위)

```
| M | 내용 | 담당 팀 | 의존 |
|---|------|---------|------|
| **M1** | `/dashboard` 슬래시 커맨드 + textual scaffold | 개발팀 (Orc-064-dev) | — |
```

마일스톤 5개 의존 그래프:
```
M1 (scaffold) ─┬─→ M2 (data) ─┬─→ M3 (render)
               │               └─→ M4 (pending+notif)
               │
               └─→ Stage 6/7 디자인팀 invite (M3 기간 중 병렬)

M3 ──┐
M4 ──┴─→ M5 (Windows + 18명 매핑)
```
