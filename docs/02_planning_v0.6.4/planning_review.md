---
version: v0.6.4
stage: 3 (plan_review)
date: 2026-04-27
mode: Strict
status: review
reviewer: 김민교 (기획팀 책임연구원, Opus/high)
upstream: planning_01_M1_scaffold / planning_02_M2_data / planning_03_M3_render / planning_04_M4_pending_notif / planning_05_M5_windows_personas
---

# jOneFlow v0.6.4 — Stage 3 Plan Review (planning_review)

> **상위:** `docs/02_planning_v0.6.4/planning_01_M1_scaffold.md` ~ `planning_05_M5_windows_personas.md` (Stage 2 drafter 5종, 장그래 작성)
> **상-상위:** `docs/01_brainstorm_v0.6.4/brainstorm.md` (의제 1~8 결정, 세션 27)
> **dispatch:** `dispatch/2026-04-27_v0.6.4_stage234_planning.md`
> **하위:** `docs/02_planning_v0.6.4/plan_final.md` (Stage 4 finalizer 안영이) → planning_index.md → Stage 5 진입 시그널 대기 (운영자 영역)
> **선례 형식:** `docs/02_planning_v0.6.2/planning_review.md` (F-XX-N / F-X-N / F-D<N> 패턴 + 종합표)
> **모드 근거:** Strict — 첫 실전 프로젝트 + 디자인팀 첫 등판 + 운영자 일상 도구. read-only 정책이 단일 위반으로도 v0.6.5+ 이월 boundary 침범으로 직결되므로 본 리뷰는 평소 Standard보다 한 단계 깊이 적용.

---

## Sec. 0. 리뷰 방식 및 발견 ID 규칙

5개 plan_draft를 1차 통독, 2차로 brainstorm 의제 1~8 결정 + Sec.2 Stage 5 이월 + Sec.3 Non-goal에 1:1 매핑한 뒤, 3차로 마일스톤 간 인터페이스(M1↔M2↔M3↔M4↔M5)·횡단 정책(read-only / personas_18.md 의존 / 디자인팀 첫 등판) 모순을 점검했다. 본 리뷰는 다음 세 종류 발견을 분리한다.

| 종류 | 의미 | 처리 |
|------|------|------|
| **정책 commit (F-D<N>)** | plan_final 본문에 명시 결정 문장으로 흡수 필요. drafter 권한 밖 정책 결정. | finalizer 안영이가 plan_final 또는 planning_index에 결정 문장으로 박음. |
| **명시 추가 (F-MN-N / F-X-N)** | drafter 의도와 일치하나 문구·범위·측정 방법이 불충분. 한두 줄 보강. | finalizer가 5개 planning doc 또는 plan_final 해당 위치에 한 줄 추가. |
| **Stage 5 이월 (F-MN-S5* / F-X-S5)** | Stage 3 단계에서 결정 불가. 기술 설계로 forward. | finalizer가 Sec. "Stage 5 이월" 표에 명시. |

발견 ID 패턴:

- `F-M1-N` — planning_01_M1_scaffold N번째 발견
- `F-M2-N` — planning_02_M2_data
- `F-M3-N` — planning_03_M3_render
- `F-M4-N` — planning_04_M4_pending_notif
- `F-M5-N` — planning_05_M5_windows_personas
- `F-X-N` — 횡단(cross-cutting) 발견. 2개 이상 doc에 걸침.
- `F-D<번호>` — 정책 commit 등급(선례 v0.6.2 F-EDU-D1/F-ORG-D1/F-04-D1 패턴). plan_final 본문에 결정 문장 박을 것.

---

## Sec. 1. 종합 평가

**판정: PASS_WITH_REVISIONS.**

5개 초안은 brainstorm 의제 1~8(모드/사용자/시각화/표시 항목/충돌 해소/알림·상태/parallel window/마일스톤)을 빠짐없이 매핑하고, 각 doc의 Sec.0~Sec.10 골격(요약/목적/범위/변경 대상/단계 분해/AC/의존/리스크/Q/이월) 표준이 일관되게 유지된다. 5건 합계 약 1,750줄 / AC 약 40건 / Q 약 23건. brainstorm 결정을 정면 위반한 곳은 없으며, Stage 2 롤백을 요구할 구조적 결함도 없다.

다만 **핵심 정책 결정 4건**(F-D1: 데이터 수집 방식 채택 책임자 / F-D2: dashboard 산출물 위치 단일화 / F-D3: 박스 외 페르소나(PM/CTO/CEO) 표시 정책 / F-D4: M2↔M3↔M4 인터페이스 dataclass 단일 정의)이 미결 상태로 finalizer 또는 Stage 5에 떠넘겨져 있다. **AC 측정 가능성**에서 5개 초안 모두 자동 grep/wc/test 명령으로 즉시 판정 불가능한 항목이 1~3개씩 잠복한다(F-M1-2, F-M2-1, F-M3-2, F-M4-2, F-M5-3). 또한 **횡단 측면에서 데이터 모델 dataclass 명칭이 doc마다 다르다**(M2: `PersonaState` + `PersonaDataCollector`, M3: `TeamMember` + `TeamRenderer`, M4: `DataCollector` + `PendingPush` + `PendingQuestion`). 같은 객체를 세 doc이 세 이름으로 부르고 있다 — 이는 Stage 8 구현자가 plan을 모두 만족할 수 없는 상태로 직결되므로 finalizer 단계에서 단일 spec으로 수렴해야 한다(F-X-1).

**dispatch 자율 영역 활용도:** drafter는 자율 영역(sub-task 정밀화 / 데이터 수집 옵션 비교 / 갱신 주기 잠정안 / AC 항목수 / 표 구조)을 충실히 활용하여 후보 비교표·우선순위·정량 수치를 채웠다. 단 M1 Q-M1-3(`requirements.txt` vs `requirements-dashboard.txt`), M3 Q-M3-4(파일 위치), M4 알림 채널 dedupe TTL 같은 명백한 자율 영역 결정을 Stage 5 또는 운영자 결정으로 떠넘긴 경우가 6건 식별된다 — 이는 finalizer가 흡수 가능한 영역으로 회수해야 한다(Sec.7 F-X-7 참조).

**brainstorm 의제 1~8 매핑 점수:**

| 의제 | 매핑 doc | 매핑 충실도 |
|------|---------|------------|
| 의제 1 (Strict/yes/medium) | 5개 doc 전체 frontmatter | ✅ 완벽 |
| 의제 2 (운영자 본인 / `/dashboard`) | M1 Sec.1, Sec.4.1 | ✅ 완벽 |
| 의제 3 (textual / working·idle / 박스 안 행) | M2 Sec.7, M3 Sec.4.1~4.2, M5 Sec.B3 | ✅ 완벽 |
| 의제 4 (박스 3개 + Pending 2개) | M3 Sec.0.2, M4 Sec.4.3 | ✅ 완벽 |
| 의제 5 (read-only) | M4 Sec.2 미변경 항목 + AC-M4-N9 | ⚠ M2/M3/M5 doc은 read-only 명시 누락 (F-X-2) |
| 의제 6 (알림 / fresh / 별도 창) | M4 Sec.4.4 + M5 Sec.1.4 | ✅ 알림 / ⚠ fresh 정책 5개 doc 모두 누락 (F-X-2) |
| 의제 7 (Parallel window) | dispatch Sec.7 박힘, 5개 doc 자체엔 명시 없음 | ⚠ planning_index에서 박을 것 (F-X-8) |
| 의제 8 (마일스톤 5개) | 5개 doc 자체가 마일스톤 정밀화 결과물 | ✅ 완벽 |

**Stage 4 plan_final 진행 조건:** 본 리뷰 Sec.8 종합표의 정책 commit 4건(F-D1~F-D4)을 plan_final 본문 또는 planning_index 결정 문장으로 흡수, 명시 추가 N건(F-MN-N / F-X-N)을 5개 planning doc 해당 위치에 흡수, Stage 5 이월 N건은 통합 "이월" 표에 합치(F-X-3). plan_draft 5종 자체는 Stage 2 스냅샷으로 보존(변경 이력 한 줄만 추가).

**다음 단계:** finalizer 안영이가 본 리뷰 Sec.8을 흡수해 5개 planning_<NN>_M<N>.md를 v2로 정리 + planning_index.md 신규 작성 → 박지영 PL이 Stage Transition Score 계산 → 회의창 보고. 운영자 시그널 부재 시 Stage 5 진입 보류(brainstorm 의제 7 + dispatch Sec.6 #1).

---

## Sec. 2. planning_01_M1_scaffold — `/dashboard` 슬래시 커맨드 + textual scaffold

### 2.1 강점

- **brainstorm 의제 2(`/dashboard` 슬래시) + 의제 3(textual)을 verbatim 인용**하여 Stage 8 구현자가 결정 사항을 재해석할 여지가 없도록 박았다. Sec.1 목적·Sec.4.1 등록 절차가 일관.
- **Sec.7 R5("M2/M3 진입점 인터페이스 미정")가 자체 적발**되어 Stage 5로 forward — drafter의 횡단 인식이 정상 작동했다.
- **AC-M1-2 `python3 -m py_compile`**, **AC-M1-5 `grep -i "textual" requirements.txt`** 등 자동 검증 가능 명령이 verbatim 박혀 Stage 9 코드 리뷰가 즉시 판정 가능.
- **Sec.3 라인 수 예상(~30 / ~80 / 1)**이 명시되어 Stage 8 구현자가 분량 expectation으로 활용 가능.

### 2.2 이슈

#### F-M1-1 (명시 추가) — Sec.3 변경 대상 파일에서 위치 후보가 두 개로 병기됨

drafter Sec.3은 `scripts/dashboard.py` 또는 `dashboard/main.py` 두 후보를 병기한다. Q-M1-2도 동일 미결. 그러나 brainstorm 의제 2가 "jOneFlow M-Slash wrapper 위에 등록"으로 박혀 있고, 기존 jOneFlow는 `scripts/` 폴더 컨벤션이다(scripts/init_project.sh, scripts/ai_step.sh, scripts/git_checkpoint.sh — `init_project.sh` scaffold 시 `scripts/` 자체가 복사 대상). 본 리뷰는 **drafter가 자율 영역에서 결정해야 할 것을 미결로 떠넘긴 경우**로 분류한다.

**제안 (finalizer 흡수):** plan_final에서 `scripts/dashboard.py` 단일 진입점으로 박음. M3/M4가 신규 추가하는 widget/notifier 모듈은 `scripts/dashboard/<module>.py` 패키지화 가능 영역으로 명시. F-X-1(데이터 모델 단일화)과 함께 박을 것.

#### F-M1-2 (명시 추가) — AC 자동/수동 컬럼 누락 + AC-M1-3/4/7 측정 모호

| AC | 현재 측정 방법 | 자동 판정 가능? | 보강 |
|----|--------------|----------------|------|
| AC-M1-1 | `grep -c "/dashboard\|dashboard" .claude/commands/dashboard.md ≥ 1` | ✅ 자동 | (있음) |
| AC-M1-2 | `python3 -m py_compile` | ✅ 자동 | (있음) |
| AC-M1-3 | `grep -E "q\|exit\(\)\|action_quit"` | ⚠ 부정확 — `q`는 한 글자라 false-positive 다발 | `grep -E "BINDINGS.*\"q\"\|action_quit"` 또는 `grep -E "Binding\(.q." scripts/dashboard.py` 패턴화 |
| AC-M1-4 | "가시적 오류 0" — 수동 시각 검사 | 수동 | "측정: 수동" 명시 |
| AC-M1-5 | `grep -i "textual" requirements.txt ≥ 1` | ✅ 자동 | (있음) |
| AC-M1-6 | `python3 scripts/dashboard.py & sleep 1; pkill` | ✅ 자동 | exit code 0 검증 명시 |
| AC-M1-7 | "decision trail 기록" — 수동 | 수동 | F-D2와 함께 결정 후 흡수 |
| AC-M1-8 | `grep -c "\"\"\"" ≥ 1` | ⚠ 약함 — docstring "있음" 검증이지 "충실함" 아님 | 그대로 두되 "skeleton 단계 최소 기준" 주석 |

**제안 (finalizer 흡수):** Sec.5 AC 표에 "측정: 자동/수동" 컬럼 추가. AC-M1-3 grep 패턴 교체.

#### F-M1-3 (명시 추가) — Sec.4.5 init_project.sh 통합이 "Stage 8 결정"으로 두 번 미뤄짐

Sec.4.5 본문 + AC-M1-7 + R4 + Q-M1-4 모두 같은 결정(scaffold 복사 대상 여부)을 Stage 8로 미룬다. 같은 결정점이 4번 등장하나 어느 것도 결정하지 않는 구조 — drafter가 brainstorm 비-goal("상태 보존/스플릿 정책 v0.6.4 scope 외")을 잘못 인용했다. brainstorm Sec.3 Non-goal은 "상태 보존"과 "스플릿/탭 정책"이지 "init_project.sh scaffold 복사"는 아니다.

**제안 (finalizer 흡수):** Stage 8 init_project.sh 수정 여부 = **본 v0.6.4 scope에 포함**. plan_final에서 "init_project.sh가 신규 프로젝트 scaffold 시 `scripts/dashboard.py` + `.claude/commands/dashboard.md` 복사 대상에 포함" 결정으로 박음. AC-M1-7 단순화: `grep -E "dashboard" scripts/init_project.sh ≥ 1`.

#### F-M1-S5-1 (Stage 5 이월) — App ↔ M2 data layer 인터페이스 정의

drafter Sec.9 F-M1-S5-1 그대로 유지. 단 본 리뷰 F-X-1(데이터 모델 단일화)와 한 묶음으로 finalizer가 처리.

### 2.3 AC 측정 가능성 종합

8개 AC 중 자동 grep/wc 검증 가능: AC-M1-1, AC-M1-2, AC-M1-5, AC-M1-6, AC-M1-8 — **5/8**. 나머지는 수동 또는 결정 보류 → finalizer 흡수 필요.

---

## Sec. 3. planning_02_M2_data — 데이터 수집 layer

### 3.1 강점

- **데이터 수집 3가지 옵션(A/B/C) 비교표(Sec.4)가 정확도/난이도/외부 의존/Windows 호환/토큰 신뢰도 5축으로 평가**되어 Stage 5 채택 시 입력으로 즉시 사용 가능. drafter 자율 영역 활용의 모범.
- **Sec.3 dataclass `PersonaState` 6필드 + Collection interface 3메서드** 명시로 M3/M4 의존자가 인터페이스 가정을 할 수 있다.
- **Q1(토큰량 정확 vs 추정)이 비용 영향(+8h vs +2h)까지 정량화**되어 운영자 결정에 즉시 입력으로 사용 가능. drafter가 Q를 잘 만들었다.
- **Sec.6 토큰량 정책의 D 후보(추정값)** — 단순 heuristic 명시로 fallback 시나리오 확보.

### 3.2 이슈

#### F-M2-1 (명시 추가) — AC-M2-1/5/6/7이 모두 "수동 visual 검사"로 grep 검증 불가

| AC | 현재 측정 | 자동 판정 가능? | 보강 |
|----|---------|----------------|------|
| AC-M2-1 | "Sec.3 체크" 수동 | 수동 | `grep -c "PersonaState\|PersonaDataCollector" planning_02_M2_data.md ≥ 2` 자동화 가능 |
| AC-M2-2 | `grep -c "옵션" ≥ 3` | ✅ 자동 | (있음) |
| AC-M2-3 | `grep -c "A-[1-4]" ≥ 4` | ✅ 자동 | (있음) |
| AC-M2-4 | `grep -c "Q1" ≥ 1` | ✅ 자동 | (있음) |
| AC-M2-5 | "Sec.3.2 존재 확인" 수동 | 수동 | `grep -c "fetch_all_personas\|fetch_team\|persona_by_name"` ≥ 3 자동화 가능 |
| AC-M2-6 | "Sec.3.1 ↔ M3 매핑 확인" 수동 | 수동 | M3 final과 cross-doc grep 명시 |
| AC-M2-7 | "Sec.6 의존 그래프" 수동 (실제 위치는 Sec.9) | 수동 | Sec 번호 오류 — Sec.9가 의존성. drafter typo. |
| AC-M2-8 | `Sec.8 Q 섹션 ≥ 1` | ⚠ Sec.8은 AC, Q는 Sec.12 | drafter Sec 번호 오류 — Sec.12 기준으로 수정 필요 |

**제안 (finalizer 흡수):** AC 표 "측정: 자동/수동" 컬럼 추가. **Sec 번호 오류 2건(AC-M2-7, AC-M2-8)** 수정 — drafter가 본인 doc 자체 cross-reference에 실수했다. 자동화 가능한 AC 4건은 명령 verbatim 박음.

#### F-M2-2 (명시 추가) — Sec.3.2 Collection interface가 `async def`인데 textual app 진입점 동기성 미정

drafter Sec.3.2는 `async def fetch_all_personas() -> List[PersonaState]`로 비동기 정의했으나, M1 Sec.4.2 textual App scaffold에는 `on_mount()` 동기 훅만 명시. textual은 async 지원하지만 M1 doc에서는 async event loop 채택 여부 미박음. 또한 Sec.3.2 `persona_by_name`만 동기(`def`), 나머지 두 메서드는 비동기로 일관성도 깨져 있다.

**제안 (finalizer 흡수):** plan_final에서 "PersonaDataCollector는 동기 인터페이스로 시작, async wrapper는 Stage 5 결정"으로 박거나, "textual `App.run_worker(thread=True)` 패턴 채택" 중 택일. M1 final + M2 final이 같은 결정으로 sync.

#### F-M2-3 (명시 추가) — Sec.5 작업명 추론 알고리즘 4가지(A-1~A-4)가 우선순위 미결

drafter는 "Stage 5에서 우선순위 순서 결정. (현재는 A-1 > A-2 > A-3 순 제안)"으로 떠넘긴다. 그러나 A-4(자가 보고)는 옵션 C 채택 시에만 가능하므로 옵션 A 채택 시 우선순위에서 자동 제외된다. 이 의존 관계가 명시 안 됨.

**제안 (finalizer 흡수):** Sec.5에 "옵션 A 채택 시 A-1 > A-2 > A-3, 옵션 C 채택 시 A-4 > A-1 > A-2 > A-3" 분기 표 추가. F-D1과 같은 묶음.

#### F-M2-4 (명시 추가) — Sec.7 working/idle 임계값 T 후보(3/10/30초)에서 권장값 결정 누락

drafter는 "T = 10초 — 균형 (Stage 5 권장)"으로 권장만 박았으나 brainstorm 의제 3은 "1~2초 잠정"으로 명시했다. 이 두 수치(2초 갱신 주기 vs 10초 idle 임계)는 모순이 아니지만 같은 doc에서 명시 안 되면 Stage 5에서 충돌. **갱신 주기 = 1~2초**(brainstorm), **idle 판정 무변화 임계 = T초**는 다른 변수.

**제안 (finalizer 흡수):** Sec.7 표 머리말에 "갱신 주기(brainstorm 1~2초)와 idle 임계 T는 독립 변수" 1줄 추가.

#### F-M2-5 (명시 추가) — Sec.10 R3 "오프 페르소나 → idle 표시 안 됨"이 read-only 정책 영역 침범

R3은 "offline 상태 추가 또는 'no data' 표시"를 Stage 5로 미룬다. 그런데 brainstorm 의제 3은 "working/idle 2단계"로 명시 박았다. **3번째 상태 추가 = brainstorm 의제 3 정정** = drafter 권한 밖 결정.

**제안 (finalizer 흡수):** Sec.10 R3을 "offline은 idle로 통합 표시(brainstorm 의제 3 2단계 정책 유지)"로 박음. 운영자 결정 게이트 후보 Q5(Sec.9 후보)로 별도 표기.

#### F-M2-S5-1 (Stage 5 이월) — drafter Sec.11 F-M2-S5a~f 6건 그대로 유지

단 F-M2-S5a(데이터 수집 방식 채택)는 본 리뷰 F-D1로 등급 상승. drafter는 Stage 5 이월로 분류했으나 본 결정이 M2/M3/M4 모두를 묶는 정책 commit이라 finalizer 단계에서 결정 책임자(Stage 5 오케 = Stage 2~4 PL과 동일 박지영)를 plan_final에 박아야 한다.

### 3.3 AC 측정 가능성 종합

8개 AC 중 자동 grep/wc 검증 가능: AC-M2-2, AC-M2-3, AC-M2-4 — **3/8** (Sec 번호 오류 수정 + 명령 보강 후 5/8). drafter Sec 번호 typo 2건은 critical 수준 아니나 finalizer가 반드시 정정.

---

## Sec. 4. planning_03_M3_render — 박스 3개 + 행 렌더링 + 다중 버전

### 4.1 강점

- **Sec.0.2 M3 핵심 / M3 외 영역 분리**가 명시되어 Stage 5/6/7 디자인팀 진입 시점 boundary가 분명하다. 드래프터가 cross-stage 책임 분배에 능숙.
- **Sec.4.2 행 형식 ASCII 예시(`╔═══ 기획팀 ═══╗`)와 Sec.4.3 다중 버전 시나리오 3개**가 brainstorm 의제 4를 발전시킨 정밀안. drafter 자율 영역 우수.
- **Sec.4.4 빈 박스 처리 옵션 A/B/C 후보 명시**로 Stage 6/7 디자인팀 dispatch 시 입력 즉시 사용 가능.
- **Sec.6.3 병렬 진행(Stage 6/7 디자인팀 첫 등판) 절차** 박힘 — brainstorm Sec.4-3 디자인팀 첫 등판 영역 인계 trail 마련.

### 4.2 이슈

#### F-M3-1 (명시 추가) — Sec.3.1 신규 파일 위치 `src/dashboard/components/...`가 M1 결정과 불일치

drafter Sec.3.1은 `src/dashboard/components/team_renderer.py` + `src/dashboard/models.py`로 박았다. 그러나 M1 Sec.3은 `scripts/dashboard.py` 또는 `dashboard/main.py` 두 후보(F-M1-1)다. **`src/`도 아니고 `scripts/`도 아닌 제3의 위치**가 M3 단독으로 등장 — drafter doc 간 위치 합치 안 됨.

**제안 (finalizer 흡수):** F-M1-1 결정(`scripts/dashboard.py` 단일)과 한 묶음으로 박음. M3 신규 모듈은 `scripts/dashboard/team_renderer.py` + `scripts/dashboard/models.py` (또는 단일 파일 inline) 둘 중 finalizer 결정. Q-M3-4 자동 흡수.

#### F-M3-2 (명시 추가) — AC 자동/수동 컬럼 + AC-M3-2/4/5/8 측정 모호

| AC | 현재 측정 | 자동? | 보강 |
|----|---------|-------|------|
| AC-M3-1 | "3개 박스 visual 확인" | 수동 | OK (수동 명시) |
| AC-M3-2 | "행 형식 일관성 — grep or 코드 인스펙션" | 모호 | regex 패턴 박음: `grep -E "\\[◉ working\|○ idle\\]"` ≥ N |
| AC-M3-3 | "테스트 시나리오 visual" | 수동 | OK |
| AC-M3-4 | "박스 너비 33% ± 5%" | 수동 | textual snapshot 비교 또는 수동 명시 |
| AC-M3-5 | "코드 review + visual" | 모호 | `grep -c "◉\|○" scripts/dashboard/team_renderer.py` 자동화 가능 |
| AC-M3-6 | "Stage 6/7 시나리오" | 모호 | "측정: Stage 6/7 결과 도착 후 수동" 명시 |
| AC-M3-7 | "M2 final spec ↔ M3 호환" | 수동 | F-X-1 결정 후 자동화 (dataclass 필드 grep) |
| AC-M3-8 | "format string code inspection" | 모호 | `grep -E "tokens: %\\.1f\|tokens: \\{.*:\\.1f\\}"` 자동화 가능 |

**제안 (finalizer 흡수):** "측정: 자동/수동" 컬럼 추가 + 자동화 가능 4건 명령 verbatim 박음.

#### F-M3-3 (명시 추가) — Sec.4.2 토큰 형식이 모델 분류 표기와 혼합

drafter Sec.4.2 본문 표는 행 형식(`tokens: 45.2k`)을 정의하나, 그 아래 "**토큰 형식**" subsection이 갑자기 모델 분류(Haiku 15~35k / Sonnet / Opus)로 점프한다. **토큰 형식 = 표시 형식**(`%.1fk`)인데 drafter는 모델 분류표(어떤 모델이 얼마나 쓰는지)를 토큰 형식 정의로 잘못 박았다. 두 개념 혼동.

**제안 (finalizer 흡수):** Sec.4.2 "토큰 형식" subsection을 두 개로 분리 — (1) **표시 형식**: `tokens: <소수점 1자리>k` 통일, (2) **모델별 토큰 사용 참고치**: 별도 참고 정보로 Sec.4.2에서 분리. M2 dataclass `tokens_k: float` 정합성 유지.

#### F-M3-4 (명시 추가) — Sec.4.3 다중 버전 표시 정책에서 brainstorm 의제 3 "박스 안 행으로만 구분" 위반 가능성

drafter Sec.4.3 "경우의 수 2"는 동일 페르소나 다중 버전 시 행을 N개로 늘리고 빈 줄로 구분한다. 그러나 brainstorm 의제 3은 "**다중 버전 동시 = 박스 안 행으로만 구분 (별도 영역 X)**"로 박혀 있다. drafter의 빈 줄 구분 = 새 영역 분할로 해석될 위험. 또한 동일 페르소나가 v0.6.3 + v0.6.4 동시 작업 사례는 본 v0.6.4가 첫 시도이므로 검증 안 된 시나리오.

**제안 (finalizer 흡수):** Sec.4.3 "동일 페르소나 × 다중 버전" 시 행 분할 시 **prefix 기호**(예: `└` 또는 `▸`) 사용하여 동일 페르소나 sub-row 명시. 빈 줄 구분 옵션은 회수. brainstorm 의제 3 호환.

#### F-M3-5 (명시 추가) — Sec.6.3 디자인팀 dispatch 발행 시점이 plan_final 종료 후로 명시 안 됨

Sec.6.3 "M3 draft 완료 후 즉시 디자인팀 dispatch 발행 권장"이 두 번 등장. 그러나 brainstorm Sec.4-3은 "Orc-064-design 첫 spawn = Stage 6 진입 시점"으로 박았다. 즉 Stage 4 plan_final 완료 → Stage 5 기술 설계 → Stage 6 진입 시그널 = 운영자 → 디자인팀 dispatch. drafter가 Stage 4에서 dispatch 발행 가능한 듯 표현 = brainstorm 위반.

**제안 (finalizer 흡수):** Sec.6.3 "M3 draft 완료 후 즉시" → "Stage 5 기술 설계 완료 + 운영자 Stage 6 진입 시그널 후" 정정. F-X-5(디자인팀 첫 등판 절차)와 한 묶음.

#### F-M3-S5-1 (Stage 5 이월) — drafter Sec.10 F-M3-1~5 그대로 유지

단 F-M3-1(색상 팔레트)은 Stage 5 vs Stage 6 책임자 모호. plan_final에서 "Stage 5 기술 설계가 토큰명 정의(--color-working / --color-idle 등), Stage 6 디자인팀이 색값 채택" 분리.

### 4.3 AC 측정 가능성 종합

8개 AC 중 자동 grep/regex 검증 가능: 보강 후 AC-M3-2, AC-M3-5, AC-M3-7, AC-M3-8 — **4/8**. 나머지는 visual/cross-doc 의존.

---

## Sec. 5. planning_04_M4_pending_notif — Pending Push·Q + macOS 알림

### 5.1 강점

- **AC 10개 중 7개(AC-M4-N1, N2, N3, N6, N8, N9, N10)가 grep/import 자동 검증 가능 명령 박힘** — 5개 doc 중 AC 자동성 최상.
- **AC-M4-N9 read-only 정책 자동 검증**(`grep -c "git push|git commit|open(" ... = 0`)이 brainstorm 의제 5를 코드 레벨로 강제 — 본 리뷰가 가장 환영하는 항목.
- **Sec.4.4 알림 채널 3종(osascript/Pushover/CCNotify)**이 비용($5/mo, $30 일회) + 외부 의존 + 구현 코드 sample까지 정리되어 Stage 5 채택 즉시 가능.
- **Sec.4.4 dedupe 메커니즘 2종(해시 / 윈도우)** + sha256 + TTL 5분 명시 — 알림 폭주 R3을 자체 통제.

### 5.2 이슈

#### F-M4-1 (명시 추가) — Sec.3 변경 대상 파일 위치가 `dashboard/...`로 박혔으나 M1/M3 위치와 불일치

drafter Sec.3은 `dashboard/pending.py` / `dashboard/ui/pending_widgets.py` / `dashboard/notifier.py` / `dashboard/data_adapters.py` / `dashboard/main.py`로 박았다. **`dashboard/` 폴더**는 M1 Q-M1-2 후보 중 하나(`dashboard/main.py`)로만 등장하고 결정 안 됨. M3는 `src/dashboard/...`. M4는 `dashboard/...` (src 없음). **세 doc이 세 위치를 사용** — Stage 8 구현자가 만족 불가능.

**제안 (finalizer 흡수):** F-M1-1 / F-M3-1과 한 묶음 단일 위치 결정. F-X-1 또는 F-D2 정책 commit으로 박음.

#### F-M4-2 (명시 추가) — AC-M4-N4/N5/N7 측정 방법 모호

| AC | 현재 측정 | 자동? | 보강 |
|----|---------|-------|------|
| AC-M4-N1 | grep dataclass | ✅ | (있음) |
| AC-M4-N2 | grep dataclass | ✅ | (있음) |
| AC-M4-N3 | python3 -c import | ✅ | (있음) |
| AC-M4-N4 | "가독성 > 80% visual" | 수동 | "측정: 수동 visual" 명시. % 기준 회수 (수치화 불가) |
| AC-M4-N5 | "placeholder 텍스트 확인" 수동 | 수동 | `grep -E "No pending\|✓ 대기" scripts/dashboard/ui/pending_widgets.py ≥ 1` 자동화 가능 |
| AC-M4-N6 | grep | ✅ | (있음) |
| AC-M4-N7 | "코드 리뷰 + 모의 테스트" | 수동 | 단위 테스트 함수명(`test_dedupe_5min`) 명시 후 `pytest -k test_dedupe` 자동화 |
| AC-M4-N8 | grep | ✅ | (있음) |
| AC-M4-N9 | grep write 0 | ✅ | (있음 — 본 리뷰 강추) |
| AC-M4-N10 | "Sec.8 3건 기록" 수동 | 수동 | `grep -c "F-M4-S5" planning_04_M4_pending_notif.md ≥ 3` 자동화 가능 |

**제안 (finalizer 흡수):** AC-M4-N4 "% 기준" 회수, N5/N7/N10 자동화 가능 명령 박음.

#### F-M4-3 (명시 추가) — Sec.4.4 Channel C(CCNotify) 존재 검증 안 됨

drafter Sec.4.4 Channel C "CCNotify (jOneFlow 내부)" + Q-M4-3 모두 "CCNotify 존재 여부 검증 필요"를 명시한다. 본 리뷰가 grep 검증한 결과 **jOneFlow 리포에 `CCNotify` 문자열 0건**(코드 + dispatch + brainstorm 모두). brainstorm 의제 6 "osascript / Pushover / CCNotify 중 선택"의 CCNotify 출처가 운영자 자유 토론 단계 명명일 뿐 실체 미확인. drafter가 brainstorm 그대로 옮겼지만 실체 검증 없는 옵션을 비교표에 동등 박은 것은 Stage 5 채택 시 혼선 야기.

**제안 (finalizer 흡수):** Sec.4.4 Channel C "CCNotify" → "(현재 미확인 — jOneFlow 자체 알림 인프라 신설 가능성, Stage 5에서 존재 여부 결정 후 채택 또는 제외)" 명시. 비교표에서 "★★ (협력 비용 높음)"을 "(존재 미확인)"으로 정정. Q-M4-3을 운영자 결정 게이트로 분류.

#### F-M4-4 (명시 추가) — Sec.4.5 M2와의 협력 계약이 M2 doc Sec.3.2와 메서드 시그니처 불일치

drafter Sec.4.5는 `class DataCollector` + `get_pending_pushes()` + `get_pending_questions()`로 박았다. 그러나 M2 doc Sec.3.2는 `class PersonaDataCollector` + `fetch_all_personas()` + `fetch_team()` + `persona_by_name()`로 박았다. **M4의 `DataCollector` ≠ M2의 `PersonaDataCollector`**, M4의 `get_pending_*` 메서드는 M2 인터페이스에 존재 안 함. drafter doc 간 inteface contract 불일치.

**제안 (finalizer 흡수):** F-X-1과 한 묶음으로 단일 spec. 옵션 (1) M2가 `PersonaDataCollector` + `PendingDataCollector` 두 클래스로 분리 / 옵션 (2) M2 단일 클래스에 메서드 추가. 본 리뷰는 (1) 권장(SRP, M2/M4 독립 진행).

#### F-M4-5 (명시 추가) — Sec.7 R5 read-only 정책 위반 위험 + AC-M4-N9가 같은 결정인데 별도 명시

drafter Sec.7 R5와 AC-M4-N9는 같은 정책(write 0)을 두 번 다룬다. R5의 "code review 시 정책 재확인"은 Stage 9가 아니라 Stage 8/9 모두 강제하면 좋다.

**제안 (finalizer 흡수):** R5 완화 칸에 "Stage 8 git pre-commit hook 추가 권장 — F-X-2 횡단 정책 commit과 한 묶음" 추가.

#### F-M4-S5-1 (Stage 5 이월) — drafter Sec.9 F-M4-S5-1~5 그대로 유지

단 F-M4-S5-1(알림 채널 최종 선택)은 본 리뷰 F-D1과 별개의 정책 commit 후보 — Q-M4-2 비용 영향 때문에 운영자 결정 게이트 필수.

### 5.3 AC 측정 가능성 종합

10개 AC 중 자동 grep/import 검증 가능: 보강 후 AC-M4-N1/N2/N3/N5/N6/N7/N8/N9/N10 — **9/10**. **5개 doc 중 AC 자동성 최상.** AC-M4-N4(% 기준 visual)만 수동.

---

## Sec. 6. planning_05_M5_windows_personas — Windows 호환 + 18명 매핑

### 6.1 강점

- **Sec.3.1 환경별 체크리스트(macOS / Windows Terminal / WSL × 5~6 항목)**가 textual cross-platform 검증 trail 즉시 사용 가능. drafter 자율 영역 우수.
- **Sec.1.4 Windows 알림 후보 4종(win10toast / plyer / winrt / 조건부 import) 비교표**에 P0/P1/P2 우선도까지 박힘 — Stage 5 채택 즉시 가능.
- **Sec.B2 18명 매핑 슬롯 ASCII**가 operating_manual.md Sec.1.2 18명 트리를 정확히 박스 3개에 매핑 — 본 doc이 v0.6.3 personas_18.md 의존을 가장 깔끔하게 분리.
- **Sec.1.1 표 P0 macOS / P1 Windows / P2 WSL 우선도** + **Sec.5.2 personas_18.md 도착 시점 표시(Stage 3~4)** — 의존 관리 trail 명확.

### 6.2 이슈

#### F-M5-1 (명시 추가) — Sec.B2 매핑 슬롯이 brainstorm 의제 3 "박스 안 행으로만" 위반 가능성

drafter Sec.B2 매핑 ASCII는 기획팀 4명 / 디자인팀 4명 / 개발팀 7명을 행 번호(1~15)로 박았다. 그런데 brainstorm 의제 3은 "다중 버전 = 박스 안 행으로만 구분 (별도 영역 X)"이므로 **18명 정적 매핑 + 다중 버전 동적 행**이 동일 박스에서 어떻게 공존하는지 미박음. drafter Sec.B2 ASCII는 정적 18명만 가정.

**제안 (finalizer 흡수):** Sec.B2 직후 "정적 매핑(페르소나 18명) + 동적 행(같은 페르소나가 다중 버전 작업 시) 공존 시 동일 페르소나는 sub-row(└ prefix)로 누적, 박스 영역 1개 유지" 1줄 추가. F-M3-4 prefix 결정과 sync.

#### F-M5-2 (명시 추가) — Sec.B1 매트릭스 skeleton이 personas_18.md 도착 전엔 채울 수 없는데 AC-M5-3은 "presence" 기준

drafter AC-M5-3 "최소 3가지 수집 방식 × 3팀 매트릭스 테이블 제공"은 skeleton presence만 검증. **현재 doc에서 표는 Sec.B1에 있고 행은 박지영/김민교/안영이/장그래 4명만 채우고 나머지는 "(기획팀 4명) / 우상호 ~ 장원영 / 공기성 ~ 지예은"로 group placeholder.** 18명 모두 행으로 채워야 매트릭스가 의미 있는데 drafter는 group placeholder로 떠넘김 = personas_18.md 도착 전엔 진행 불가.

**제안 (finalizer 흡수):** AC-M5-3을 두 단계로 분리 — (1) **Stage 4 final 시점**: skeleton presence(현 Sec.B1 그대로 OK), (2) **Stage 5 진입 시점**: 18명 전체 매트릭스 채움(personas_18.md 도착 후). dispatch Sec.6 #2 중단 조건과 sync.

#### F-M5-3 (명시 추가) — AC 자동/수동 컬럼 + AC-M5-1/3/4/5/6 모두 visual

| AC | 현재 측정 | 자동? | 보강 |
|----|---------|-------|------|
| AC-M5-1 | "Sec.3.1 visual" | 수동 | OK (수동 명시) |
| AC-M5-2 | `grep -c "박지영\|김민교..."` 18명 | ✅ 자동 | (있음) — 본 리뷰 환영 |
| AC-M5-3 | "Sec.3.2 presence" | 수동 | F-M5-2 분리 후 자동/수동 단계화 |
| AC-M5-4 | "Sec.1.4 5행 이상" | 수동 | `grep -c "win10toast\|plyer\|winrt" planning_05_M5_windows_personas.md ≥ 3` 자동화 가능 |
| AC-M5-5 | "Sec.1.5 3줄 이상" | 수동 | `grep -A 5 "WSL fallback" ... | wc -l ≥ 3` 자동화 가능 |
| AC-M5-6 | "Sec.8/9 presence" | 수동 | `grep -c "Q[1-3]" planning_05_M5_windows_personas.md ≥ 3` 자동화 가능 |

**제안 (finalizer 흡수):** "측정: 자동/수동" 컬럼 추가 + AC-M5-4/5/6 자동화 명령 박음.

#### F-M5-4 (명시 추가) — Sec.B2 매핑 슬롯 박스 높이 45줄이 macOS Ghostty 일반 터미널 높이 초과

drafter Sec.B2 직후 "총 높이: 기획 12줄 + 디자인 12줄 + 개발 21줄 = 45줄 (브라우저 스크롤 가능, 또는 레이아웃 최적화 stage 5)"로 박았다. 그러나 일반 macOS Ghostty 기본 높이 ≈ 24~30줄. **45줄 박스 = 1.5~2배 화면 초과** = 운영자 대시보드 가시화 목적 위배(스크롤 필요 시 "한눈에" 안 보임). brainstorm 의제 3 "6~9개 행 동시 가독성" 보장 불가.

**제안 (finalizer 흡수):** Sec.B2 "총 높이 45줄" 우려를 **R6 신규 리스크**로 등급 상승. 완화 = "Stage 5 visual 검증 + 가변 높이(scroll vs collapse) 결정". F-X-4(데이터 layer ↔ 렌더 인터페이스)와 한 묶음.

#### F-M5-5 (명시 추가) — Sec.2.1 PM/CTO/CEO 표시 정책 미정이 Q1과 별개 표기

Sec.2.1 "제외 (표시 정책 운영자 결정 — Q1~Q3)"가 Q1로 박혔으나, Sec.9 Q1은 PM/CTO/CEO만 다루고 Sec.9 Q2는 Windows, Q3은 WSL. drafter가 같은 Q1 번호를 두 의미로 사용 → cross-reference 깨짐.

**제안 (finalizer 흡수):** Sec.2.1 "Q1~Q3" → "Sec.9 Q1" 1건만 참조하도록 정정. drafter typo.

#### F-M5-S5-1 (Stage 5 이월) — drafter Sec.10 F-M5-Tech-1~3 + F-M5-Detail-1 + F-M5-Stage5-UI 그대로 유지

단 F-M5-Detail-1(personas_18.md 도착 후 매핑 detail)은 본 v0.6.4 진행 차단(blocking) 표기. dispatch Sec.6 #2 중단 조건과 sync. plan_final이 "personas_18.md 도착 전이라도 Stage 4 final + Stage 5 기술 설계 진입 가능, Stage 8 구현 직전 매핑 detail 채움" boundary 박음 권장.

### 6.3 AC 측정 가능성 종합

6개 AC 중 자동 grep 검증 가능: 보강 후 AC-M5-2, AC-M5-4, AC-M5-5, AC-M5-6 — **4/6**. AC-M5-1/3은 visual/단계화.

---

## Sec. 7. 횡단 발견 (F-X-N) — 2개 이상 doc에 걸침

### F-X-1 (정책 commit 후보 = F-D1) — 데이터 모델 dataclass / 인터페이스 단일 spec 수렴

본 리뷰의 가장 큰 횡단 모순. 같은 객체를 세 doc이 세 이름으로 부른다.

| doc | dataclass | Collector class | Collector 메서드 |
|-----|-----------|-----------------|-----------------|
| M2 | `PersonaState` (6필드) | `PersonaDataCollector` | `fetch_all_personas` / `fetch_team` / `persona_by_name` |
| M3 | `TeamMember` (예시 의사 코드) | `TeamRenderer` | `render(teams_data: Dict[str, List[TeamMember]])` |
| M4 | `PendingPush` / `PendingQuestion` | `DataCollector` | `get_pending_pushes` / `get_pending_questions` |

**위반 영향:** Stage 8 구현자가 plan을 모두 만족할 수 없다(M2의 `PersonaState`를 받아 M3가 `TeamMember` dict로 변환하고 M4가 `DataCollector`로 다시 호출하는 어댑터 3중 구조 필요).

**제안 (정책 commit F-D1):** plan_final 본문 + planning_index에 단일 spec 박음. 권장:
- `PersonaState` (M2 정의) 단일 dataclass.
- `PersonaDataCollector` (M2 정의) + `PendingDataCollector` (M4 정의) 두 클래스 분리(SRP).
- M3 `TeamRenderer.render()`는 `Dict[str, List[PersonaState]]` 입력 (M2 dataclass 그대로 소비).

### F-X-2 (정책 commit 후보 = F-D2) — read-only 정책 일관성 (모든 doc Sec.2 변경금지 항목 박혔는가)

| doc | "미변경 항목 (read-only 정책)" 명시 | grep 검증 AC |
|-----|---------------------------------|-------------|
| M1 Sec.2 | ✅ 명시 | ❌ 없음 |
| M2 Sec.2 | ⚠ "범위 밖 (Stage 5 이월)"만 있음, read-only 명시 없음 | ❌ 없음 |
| M3 Sec.2 | ❌ 명시 없음 | ❌ 없음 |
| M4 Sec.2 | ✅ 명시 | ✅ AC-M4-N9 |
| M5 Sec.2 | ❌ 명시 없음 | ❌ 없음 |

**위반 영향:** brainstorm 의제 5(read-only)는 v0.6.4 영구 정책. 5개 doc 중 명시 0~AC까지 박힌 곳은 M4뿐. M2/M3/M5는 write 영역 진입 위험 식별 안 됨.

**제안 (정책 commit F-D2):** plan_final 본문에 "5개 마일스톤 모두 read-only 정책 영구 적용. write 영역 진입 시 즉시 Stage 4 review 회귀" 박음. 5개 doc Sec.2에 read-only 1줄 + AC-M4-N9 패턴(`grep "git push|git commit|open(.*'w'" ... = 0`)을 5개 doc 각자 AC로 추가. brainstorm 의제 5 강제.

### F-X-3 (명시 추가) — Stage 5 이월 항목 통합

5개 doc이 각자 Stage 5 이월 표(Sec.9 / Sec.11 / Sec.10 / Sec.9 / Sec.10)를 갖고 있다. 합계:
- F-M1-S5-1~4 = 4건
- F-M2-S5a~f = 6건
- F-M3-1~5 = 5건
- F-M4-S5-1~5 = 5건
- F-M5-Tech-1~3 + Detail-1 + Stage5-UI = 5건
- 합계 **25건**

이 중 중복 항목 다수:
- Windows 호환 검증: F-M1-S5-3 + F-M3-5 + F-M5-Tech-1/2/3 = 5건이 같은 영역
- 갱신 주기: F-M1-S5-4 + F-M2-S5b = 2건이 같은 결정
- 색상 팔레트: F-M1-S5-2 + F-M3-1/2 = 3건이 같은 영역
- 18명 매핑 detail: F-M2-S5f + F-M5-Detail-1 = 2건이 같은 결정

**제안 (명시 추가 F-X-3):** finalizer가 planning_index.md에 통합 Stage 5 이월 표(중복 제거 후 약 12~15건 추정)를 단일 source of truth로 박음. 5개 doc Sec. "이월" 표는 그대로 두되 "통합표는 planning_index.md" 1줄 포인터.

### F-X-4 (Stage 5 이월 후보 = F-D4) — M2↔M3↔M4 인터페이스 dataclass 일관성

F-X-1의 결정이 들어간 후, **M3 renderer가 M2 PersonaState를 입력으로 소비할 때의 데이터 흐름**이 명시 안 됨. M3 Sec.6.1은 "M2 final spec ↔ M3 호환성"을 AC-M3-7으로 박았으나 M2 final이 출현 전이라 검증 시점이 Stage 4 finalizer 종료 직후로 미뤄짐. M4 Sec.4.5도 동일.

**제안 (명시 추가):** finalizer가 planning_index.md "데이터 흐름" 다이어그램 박음:
```
[tmux] → PersonaDataCollector → PersonaState[] → TeamRenderer → 박스 3개 행
                                              → PendingDataCollector → Pending* → PendingPushBox / PendingQBox
                                              → Notifier (Pending Q 도착 시)
```
F-X-1 결정 후 1회만 박으면 cross-doc 모순 closed.

### F-X-5 (정책 commit 후보 = F-D3) — 박스 외 페르소나(PM/CTO/CEO) 표시 정책

M5 Sec.2.1 + Sec.9 Q1이 "스티브 리(PM) / 백현진(CTO) / 이형진(CEO) 표시 여부 운영자 결정"으로 박힘. 그러나 M5 외 doc은 18명 vs 21명(전체 5계층) 매핑을 다루지 않음. brainstorm 의제 4의 박스 3개(기획/디자인/개발)도 PM/CTO/CEO 박스를 미정의.

**제안 (정책 commit F-D3):** plan_final 본문에 운영자 결정 → "v0.6.4는 18명만 표시(기획4 + 디자인4 + 개발7). PM 스티브 리는 박스 외 별도 영역(예: 상단 status bar) 또는 v0.6.5+ 이월. 백현진/이형진은 표시 안 함" 등 boundary 박음. 본 리뷰 권장: **v0.6.4 = 18명만, 그 외는 v0.6.5+ 이월**(scope 단순성 우선).

### F-X-6 (Stage 5 이월) — v0.6.3 personas_18.md 의존 분리

| doc | personas_18.md 의존 | 현재 상태 |
|-----|---------------------|----------|
| M1 | 없음 | OK |
| M2 | F-M2-S5f "18명 매핑 알고리즘" | Stage 5 |
| M3 | 없음 (정적 박스 구조만) | OK |
| M4 | 없음 | OK |
| M5 | F-M5-Detail-1 "blocking", AC-M5-3 매트릭스, Sec.B1 매트릭스 | M5 final 진행 차단 가능 |

**위반 영향:** brainstorm 의제 7 + dispatch Sec.6 중단 조건 #2가 "personas_18.md 의존 영역만 별도 표시(스킵 가능)"로 박혔으나, M5 doc 자체는 "blocking"으로 두 등급 다르게 표기.

**제안 (Stage 5 이월 + 명시 추가):** finalizer가 planning_index.md에 "v0.6.3 personas_18.md 도착 전 진행 가능 boundary": Stage 4 final 진행 가능 / Stage 5 기술 설계 진행 가능 / Stage 8 구현 직전 매핑 detail 채움 = blocking 시점이 Stage 8 진입으로 박힘. M5 F-M5-Detail-1 "blocking"의 "blocking 시점 = Stage 8 진입"으로 정정.

### F-X-7 (명시 추가) — drafter 자율 영역 미회수 6건

drafter가 자율 영역(sub-task / 옵션 비교 / 갱신 주기 / 색상 / 표 구조)을 활용했으나 다음 6건은 명백한 자율 영역인데도 Stage 5 / 운영자 결정으로 떠넘김:

| # | 떠넘긴 결정 | 본 리뷰 권장 (finalizer 흡수) |
|---|-----------|--------------------------|
| 1 | M1 Q-M1-3 `requirements.txt` vs `requirements-dashboard.txt` | 단일 `requirements.txt` 추가(jOneFlow 컨벤션) |
| 2 | M3 Q-M3-4 모듈 위치 `src/dashboard/components/` vs `src/dashboard/render/` | F-D2 결정에 흡수(`scripts/dashboard/`) |
| 3 | M4 dedupe TTL 5분 vs 10분 vs 60초 | 본 리뷰 5분 권장(brainstorm 단순성) |
| 4 | M3 Q-M3-1 다중 버전 정렬 (페르소나명 고정 vs working 우선) | 페르소나명 고정 권장(가시화 일관성) |
| 5 | M2 Sec.5 작업명 추론 우선순위 A-1/A-2/A-3 | A-1 > A-3 > A-2(prompt > 로그 > thinking) 권장 |
| 6 | M3 Sec.4.4 빈 박스 처리 A/B/C | A(팀명 + "대기 중") 권장 |

**제안 (명시 추가 F-X-7):** finalizer가 6건을 plan_final 본문에 흡수, Q에서 제거. Stage 5/운영자 결정 큐 부하 감소.

### F-X-8 (명시 추가) — planning_index.md 골격

dispatch Sec.3은 `planning_index.md`를 6번째 산출로 명시 박았다. 5개 doc 중 어느 doc도 planning_index를 참조하거나 자기 위치를 인덱스에 매핑하지 않는다 — drafter 단계에서 누락된 영역.

**제안 (명시 추가 F-X-8):** finalizer 또는 PL 박지영이 planning_index.md를 신규 작성. 최소 골격:
1. 5개 마일스톤 한 눈에 표(M번호 / 이름 / 산출 파일 / 의존 / 상태)
2. brainstorm 의제 1~8 → 5개 마일스톤 매핑 표
3. 의존 그래프 (brainstorm Sec.99 ASCII 인용)
4. 작업 순서(M1 → M2 → M3/M4 병렬 → M5)
5. AC 총괄 (40건 합계)
6. **통합 Stage 5 이월 표** (F-X-3 결정)
7. **데이터 흐름** (F-X-4 결정)
8. **운영자 결정 게이트 통합 표** (F-X-9 결정)

### F-X-9 (명시 추가) — 운영자 결정 게이트 통합 표

5개 doc Q 합계 약 23건(M1: 5 / M2: 4 / M3: 4 / M4: 6 / M5: 4). 이 중 운영자 결정 필수 vs finalizer 결정 가능 vs Stage 5/8 영역 분리 안 됨.

| 분류 | 후보 Q (본 리뷰 분류) |
|------|---------------------|
| **운영자 결정 필수 (Stage 4.5 게이트)** | M2 Q1 (토큰량 정책 +8h vs +2h), M4 Q-M4-2 (Pushover 비용), M5 Q1 (PM/CTO/CEO 표시), M5 Q2 (Windows 정식 지원), F-D3 (박스 외 페르소나) |
| **finalizer 결정 가능** | F-X-7 6건 + M2 Sec.5 우선순위 + M3 Sec.4.4 빈 박스 + M4 dedupe TTL |
| **Stage 5 기술 설계 영역** | M2 Q2/Q3, M3 Q-M3-2, M4 Q-M4-1/3/4/5/6, M5 Q3/Q4, F-D1, F-D4 |
| **Stage 8 영역** | F-M1-3 init_project.sh 결정 |

**제안 (명시 추가 F-X-9):** finalizer가 planning_index.md 또는 plan_final에 통합 표 박음. Stage 4.5 운영자 승인 게이트에서 운영자 결정 필수 5건만 답변하면 Stage 5 진입 가능. 본 리뷰 선례 v0.6.2 Sec.9 패턴 호환.

### F-X-10 (명시 추가) — 디자인팀(Orc-064-design) 첫 등판 절차

M3 Sec.6.3 + brainstorm Sec.4-3은 디자인팀 첫 등판 시점을 다루나 5개 doc 어디도 디자인팀에 무엇을 넘길지 dispatch 골격을 박지 않는다. F-M3-5 정정 후에도 절차는 미박음.

**제안 (명시 추가 F-X-10):** finalizer 또는 PL 박지영이 planning_index.md 또는 별도 dispatch 메모에 디자인팀 첫 등판 절차 stub 박음:
1. 진입 시점: Stage 5 기술 설계 완료 + 운영자 Stage 6 진입 시그널
2. dispatch 입력: M3 plan_final + Stage 5 색상 토큰 정의 + 18명 매핑 슬롯
3. 디자인팀 산출: 색상 팔레트 / margin·padding / border style / 스파크라인·진행률 바
4. 첫 등판 회고: Stage 13 release notes에 기록(brainstorm Sec.4-3 인용)

상세 dispatch 본문은 회의창/PL 자율(본 리뷰가 작성하면 권한 위반).

---

## Sec. 8. 개정 제안 종합표

본 리뷰 발견은 모두 **plan_final 또는 planning_index에서 흡수**. plan_draft 5종은 Stage 2 스냅샷으로 보존(변경 이력 한 줄만 추가).

| ID | 항목 | 유형 | 위치 | 요지 |
|----|------|------|------|------|
| **F-D1** | 횡단 / M2 / M3 / M4 | **정책 commit** | plan_final 본문 + planning_index | 데이터 모델 단일 spec — `PersonaState` + `PersonaDataCollector` + `PendingDataCollector` 분리. F-X-1 흡수. |
| **F-D2** | 횡단 / M1 / M3 / M4 | **정책 commit** | plan_final 본문 + planning_index | dashboard 산출물 위치 단일화 — `scripts/dashboard.py` 진입 + `scripts/dashboard/<module>.py` 패키지. F-M1-1 / F-M3-1 / F-M4-1 흡수. |
| **F-D3** | 횡단 / M5 | **정책 commit** | plan_final 본문 (운영자 결정 후) | 박스 외 페르소나(PM/CTO/CEO) 표시 정책 — v0.6.4는 18명만, PM은 별도 영역 또는 v0.6.5+ 이월, CTO/CEO는 표시 안 함. F-X-5 흡수. |
| **F-D4** | 횡단 / M2 / M3 / M4 (인터페이스) | **정책 commit** (Stage 5 영역과 boundary) | plan_final 본문 + planning_index 데이터 흐름 | M2↔M3↔M4 인터페이스 dataclass 일관성 + sync/async 결정. F-D1 후속. |
| F-M1-1 | M1 | 명시 추가 | Sec.3 + Q-M1-2 | 진입점 위치 `scripts/dashboard.py` 단일화. F-D2 흡수. |
| F-M1-2 | M1 | 명시 추가 | AC 표 | "측정: 자동/수동" 컬럼 추가, AC-M1-3 grep 패턴 정정. |
| F-M1-3 | M1 | 명시 추가 | Sec.4.5 + AC-M1-7 + R4 + Q-M1-4 | init_project.sh 통합 = 본 v0.6.4 scope. AC-M1-7 단순화. |
| F-M1-S5-1 | M1 | Stage 5 이월 | plan_final 이월 표 | App ↔ M2 인터페이스 정의 (F-D4와 통합). |
| F-M2-1 | M2 | 명시 추가 | AC 표 | 자동/수동 컬럼 + Sec 번호 오류 2건(AC-M2-7/8) 정정 + 자동화 명령 박음. |
| F-M2-2 | M2 | 명시 추가 | Sec.3.2 | sync vs async 인터페이스 결정(F-D4 흡수). |
| F-M2-3 | M2 | 명시 추가 | Sec.5 | 옵션 A/C 따라 작업명 추론 우선순위 분기 표 추가. |
| F-M2-4 | M2 | 명시 추가 | Sec.7 | 갱신 주기(brainstorm 1~2초)와 idle T 임계가 독립 변수임을 명시. |
| F-M2-5 | M2 | 명시 추가 | Sec.10 R3 | offline = idle 통합 (brainstorm 의제 3 2단계 정책 유지). |
| F-M2-S5a~f | M2 | Stage 5 이월 | F-X-3 통합 표 | drafter Sec.11 6건 그대로. F-M2-S5a는 F-D1로 등급 상승. |
| F-M3-1 | M3 | 명시 추가 | Sec.3.1 | `src/dashboard/...` → `scripts/dashboard/...` (F-D2 흡수). |
| F-M3-2 | M3 | 명시 추가 | AC 표 | 자동/수동 컬럼 + AC-M3-2/5/8 자동화 명령 박음. |
| F-M3-3 | M3 | 명시 추가 | Sec.4.2 | "토큰 형식" subsection을 표시 형식 vs 모델별 참고치로 분리. |
| F-M3-4 | M3 | 명시 추가 | Sec.4.3 | 다중 버전 sub-row 시 prefix(└/▸) 사용. brainstorm 의제 3 호환. |
| F-M3-5 | M3 | 명시 추가 | Sec.6.3 | 디자인팀 dispatch 시점 = Stage 5 완료 + Stage 6 시그널 후. |
| F-M3-S5-1 | M3 | Stage 5 이월 | F-X-3 통합 표 | drafter Sec.10 5건 그대로. F-M3-1 책임자 분리. |
| F-M4-1 | M4 | 명시 추가 | Sec.3 | `dashboard/...` → `scripts/dashboard/...` (F-D2 흡수). |
| F-M4-2 | M4 | 명시 추가 | AC 표 | AC-M4-N4 % 회수, N5/N7/N10 자동화 명령 박음. |
| F-M4-3 | M4 | 명시 추가 | Sec.4.4 + Q-M4-3 | CCNotify 존재 미확인 명시. 운영자 결정 게이트로 분류. |
| F-M4-4 | M4 | 명시 추가 | Sec.4.5 | DataCollector ≠ PersonaDataCollector. F-D1 흡수 후 PendingDataCollector 분리. |
| F-M4-5 | M4 | 명시 추가 | Sec.7 R5 | git pre-commit hook 추가 권장 (F-X-2 흡수). |
| F-M4-S5-1 | M4 | Stage 5 이월 | F-X-3 통합 표 | drafter Sec.9 5건 그대로. F-M4-S5-1(알림 채널)은 운영자 결정 게이트. |
| F-M5-1 | M5 | 명시 추가 | Sec.B2 | 정적 매핑 + 동적 sub-row 공존 명시 (F-M3-4 sync). |
| F-M5-2 | M5 | 명시 추가 | AC-M5-3 | Stage 4 final 시점(skeleton) vs Stage 5 진입 시점(18명 채움) 단계 분리. |
| F-M5-3 | M5 | 명시 추가 | AC 표 | 자동/수동 컬럼 + AC-M5-4/5/6 자동화 명령 박음. |
| F-M5-4 | M5 | 명시 추가 | Sec.B2 + R6 신규 | 박스 높이 45줄 = 화면 초과. 가변 높이 결정 Stage 5. |
| F-M5-5 | M5 | 명시 추가 | Sec.2.1 | "Q1~Q3" → "Sec.9 Q1" 정정 (drafter typo). |
| F-M5-S5-1 | M5 | Stage 5 이월 | F-X-3 통합 표 | drafter Sec.10 5건 그대로. F-M5-Detail-1 blocking 시점 = Stage 8. |
| **F-X-1** | 횡단 | F-D1 흡수 | plan_final 본문 | 데이터 모델 단일 spec. |
| **F-X-2** | 횡단 | F-D2(부분) + 명시 추가 | plan_final 본문 + 5개 doc Sec.2 | read-only 정책 일관성 — 5개 doc 모두 명시 + AC 추가. |
| F-X-3 | 횡단 | 명시 추가 | planning_index 통합 이월 표 | Stage 5 이월 25건 → 중복 제거 후 12~15건. |
| **F-X-4** | 횡단 | F-D4 흡수 + 명시 추가 | planning_index 데이터 흐름 다이어그램 | M2 dataclass → M3 renderer → M4 widget 데이터 경로 명시. |
| **F-X-5** | 횡단 | F-D3 흡수 | plan_final 본문 (운영자 결정) | PM/CTO/CEO 표시 정책. |
| F-X-6 | 횡단 | Stage 5 이월 + 명시 추가 | planning_index | personas_18.md 의존 boundary — Stage 8 진입 = blocking 시점. |
| F-X-7 | 횡단 | 명시 추가 | plan_final 본문 | drafter 자율 영역 미회수 6건 → finalizer 결정. |
| F-X-8 | 횡단 | 명시 추가 | planning_index 신규 작성 | planning_index.md 골격 8항목. |
| F-X-9 | 횡단 | 명시 추가 | planning_index 또는 plan_final | 운영자 결정 게이트 통합 표. Q 약 23건 분류. |
| F-X-10 | 횡단 | 명시 추가 | planning_index 또는 별도 dispatch stub | 디자인팀 첫 등판 절차 4항목. |

**유형 breakdown:**
- **정책 commit: 4건** (F-D1, F-D2, F-D3, F-D4 — F-X-1/2/4/5는 정책 commit으로 흡수)
- **명시 추가: 28건** (F-M1-1~3, F-M2-1~5, F-M3-1~5, F-M4-1~5, F-M5-1~5, F-X-3, F-X-6, F-X-7, F-X-8, F-X-9, F-X-10)
- **Stage 5 이월: 5건** (5개 doc 각 1건 묶음 = drafter 25건이 통합 12~15건으로 수렴)

**총 발견 수: 37건** (정책 commit 4 + 명시 추가 28 + Stage 5 이월 5).

**카운트 by doc:**
| doc | F-MN-N (명시 추가) | F-MN-S5 (이월) | F-D 정책 | F-X 흡수 |
|-----|-------------------|---------------|---------|---------|
| M1 | 3 (F-M1-1/2/3) | 1 (F-M1-S5-1) | F-D2(부분) | F-X-2 |
| M2 | 5 (F-M2-1~5) | 1 (drafter 6건 통합) | F-D1, F-D4 | F-X-1, F-X-2 |
| M3 | 5 (F-M3-1~5) | 1 (drafter 5건 통합) | F-D2(부분) | F-X-1, F-X-2 |
| M4 | 5 (F-M4-1~5) | 1 (drafter 5건 통합) | F-D2(부분) | F-X-1, F-X-2 |
| M5 | 5 (F-M5-1~5) | 1 (drafter 5건 통합) | F-D3 | F-X-2, F-X-6 |
| 횡단 | 8 (F-X-3, F-X-6, F-X-7, F-X-8, F-X-9, F-X-10 + 흡수 2) | — | — | — |

---

## Sec. 9. Q (운영자 결정 필요 사항)

본 리뷰 발견 중 **drafter / finalizer 권한 밖, 운영자 명시 결정이 필요한 항목**:

| Q | 결정 항목 | 본 리뷰 권장 | 결정 시점 |
|---|---------|------------|----------|
| **Q1** | **F-D3 박스 외 페르소나(PM/CTO/CEO) 표시 정책** — M5 Sec.9 Q1 등급 상승. v0.6.4에서 PM은 별도 영역 표시할지, CTO/CEO는 v0.6.5+ 이월할지. | **18명만 표시. PM은 별도 영역(상단 status bar) 또는 v0.6.5+ 이월. CTO/CEO 표시 안 함.** scope 단순성 우선. | **Stage 4.5 운영자 승인** |
| **Q2** | **M2 Q1 토큰량 정책** — 정확(B/hook +8h) vs 빠른 추정(A/regex +2h). 비용 영향 정량화됨. | **정확 B 권장 (Stage 5 hook 인프라 +8h).** 첫 실전 프로젝트 + Strict 모드라 신뢰성 우선. | **Stage 4.5 운영자 승인** |
| **Q3** | **M4 Q-M4-2 Pushover 비용** — $5/mo 또는 $30 일회. jOneFlow 차원에서 부담 가능? | **회피 권장 (osascript 기본 + Stage 5에서 plyer cross-platform 검토).** read-only + 로컬 단독이라 외부 API 비용 회피. | **Stage 4.5 운영자 승인** |
| **Q4** | **M5 Q2 Windows 정식 지원** — v0.6.4에서 P0 상승할지, P1 유지할지. | **P1 유지 (v0.6.4 = macOS 단독 + Windows skeleton). Windows 정식은 v0.6.5+.** brainstorm 비-goal과 sync. | **Stage 4.5 운영자 승인** |
| **Q5** | **M2 R3 / M5 의제 3 정합성 — offline 페르소나 표시** — brainstorm 의제 3 "working/idle 2단계"에 offline 추가 = brainstorm 정정. | **brainstorm 유지 — offline은 idle 통합 표시.** 본 리뷰 권장 대로 finalizer 흡수, 운영자 confirm만. | **Stage 4.5 운영자 confirm** |

**Q1, Q2, Q3, Q4는 운영자 명시 결정 필수. Q5는 finalizer 결정 + 운영자 confirm.**

**비교 — drafter Q 약 23건 vs 본 리뷰 Q 5건:**
- finalizer 흡수 가능: F-X-7 (6건) + 자율 영역 결정 = drafter Q 약 12건
- Stage 5 기술 설계: drafter Q 약 6건
- 운영자 결정 필수: 본 리뷰 Q 5건
- → 운영자 결정 부하 5/23 = **22% 수준**으로 압축. 선례 v0.6.2 Q 7건과 동급.

---

## Sec. 10. 판정

**Plan Draft 5종 구조적으로 건전.** Stage 2 롤백 불요. brainstorm 의제 1~8 결정 위반 0건. 단 횡단 모순(F-X-1 데이터 모델 + F-X-2 read-only)이 정책 commit 등급으로 finalizer가 단일 spec 박음 필수. Stage 4 plan_final + planning_index 단일 통합 진행.

| 항목 | 판정 |
|------|------|
| planning_01_M1_scaffold | PASS_WITH_REVISIONS (명시 3 + 이월 1 + F-D2 흡수) |
| planning_02_M2_data | PASS_WITH_REVISIONS (명시 5 + 이월 1 + F-D1/F-D4 흡수) |
| planning_03_M3_render | PASS_WITH_REVISIONS (명시 5 + 이월 1 + F-D2 흡수) |
| planning_04_M4_pending_notif | PASS_WITH_REVISIONS (명시 5 + 이월 1 + F-D1/F-D2 흡수) — **AC 자동성 최상(9/10)** |
| planning_05_M5_windows_personas | PASS_WITH_REVISIONS (명시 5 + 이월 1 + F-D3 흡수) |
| 횡단 (cross-cutting) | PASS_WITH_REVISIONS (정책 commit 4 + 명시 8) |

**plan_final + planning_index 진행 조건:**
1. **정책 commit 4건(F-D1/F-D2/F-D3/F-D4)이 plan_final 본문 결정 문장으로 흡수.** F-D3는 운영자 결정 답변 후 박음. F-D1/F-D2/F-D4는 finalizer가 본 리뷰 권장 그대로 박음.
2. **운영자 결정 Q 5건(Q1~Q5)** Stage 4.5 승인 게이트에서 답변. **답변 결과 plan_final 본문 verbatim 박음.**
3. **명시 추가 28건**이 5개 plan_draft 해당 위치(AC 표 / Sec.4 / Sec.6 / Sec.7) + planning_index에 한 줄씩 흡수.
4. **Stage 5 이월 5건(통합 25건)이 planning_index.md 단일 통합 표**로 수렴(F-X-3).
5. **planning_index.md 신규 작성**(F-X-8) — 8항목 골격 (의존 그래프 / 데이터 흐름 F-X-4 / 운영자 결정 통합 F-X-9 / 디자인팀 첫 등판 F-X-10 포함).
6. **brainstorm 의제 1~8 → 5개 마일스톤 매핑 표**를 planning_index 첫 섹션에 박음.
7. plan_draft 5종은 Stage 2 스냅샷으로 보존, 변경 이력 한 줄만 추가("Stage 3 review에서 37건 개정 식별, plan_final + planning_index로 forward").

**Stage Transition Score 계산 권장:**
- brainstorm → planning 적용도: 의제 1~8 매핑 8/8 = 100% (단 의제 5/6은 doc 일부에서 누락 → 보정 후 7/8 = 87.5%)
- 임계값 80% 초과 → Stage 4 진입 가능. 단 정책 commit 4건 + 운영자 Q 5건 미해결 시 Stage 4.5 게이트에서 정지.

---

## Sec. 11. 본 리뷰가 다루지 않는 것

- 5개 plan_draft의 코드 수준(Python textual API 정확성, dataclass typing 호환 등) → **Stage 9 코드 리뷰**.
- textual cross-platform 실제 검증(Windows Terminal / WSL Ubuntu 실측) → **Stage 8/11**.
- claude CLI stdout `"usage"` JSON 포맷 byte 단위 정확성 검증 → **Stage 5 기술 설계 + Stage 9**.
- macOS osascript / Pushover / CCNotify 실제 호출 테스트 → **Stage 8**.
- v0.6.3 personas_18.md 도착 일정(병렬 세션 monitoring) — **본 v0.6.4 회의창 영역 외**(brainstorm 의제 7).
- 디자인팀 첫 등판 dispatch 본문 작성 → **Stage 6 진입 시점 회의창 + PL 영역**(본 리뷰는 stub 4항목까지만).
- 글로벌 ~/.claude/CLAUDE.md 영역 — **v0.6.2 finalize에서 v0.6.3 이월 박힘** (F-62-4).

---

## Sec. 12. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | v1 — Stage 3 리뷰 작성 | reviewer 김민교(Opus/high). 5개 plan_draft 일괄 리뷰. 정책 commit 4 + 명시 추가 28 + Stage 5 이월 5 = **37건** + 운영자 결정 Q 5건. plan_final + planning_index로 forward. brainstorm 의제 1~8 매핑 7/8(87.5%) — Stage 4 진입 가능. |

---

## 다음 스테이지 — Stage 4 plan_final + planning_index 진입 지시 (finalizer 안영이 + PL 박지영)

본 리뷰 **Sec.8 개정 제안 종합표 37건**을 흡수한 **단일 plan_final.md + 신규 planning_index.md**로 진행한다.

- **정책 commit 4건(F-D1/F-D2/F-D3/F-D4)**은 plan_final 본문 명시 결정 문장으로 박음. F-D3는 Stage 4.5 운영자 답변 후 박음.
- **운영자 결정 Q 5건(Q1~Q5)**은 Stage 4.5 승인 게이트에서 답변, 답을 plan_final에 verbatim 박음. **승인 없이 Stage 5 진입 금지.**
- **명시 추가 28건**은 5개 plan_draft 해당 위치 매핑한 v2 정리(또는 plan_final 통합).
- **Stage 5 이월 5건(통합 25건)**은 planning_index.md "통합 Stage 5 이월" 단일 표로 수렴.
- **planning_index.md 신규 작성** — 8항목 골격(F-X-8): 마일스톤 한 눈에 / brainstorm 매핑 / 의존 그래프 / 작업 순서 / AC 총괄 / 통합 Stage 5 이월 / **데이터 흐름**(F-X-4) / **운영자 결정 통합 표**(F-X-9) / **디자인팀 첫 등판 절차 stub**(F-X-10).
- plan_draft 5종은 Stage 2 스냅샷으로 보존. 변경 이력 한 줄만 추가("Stage 3 review 37건 개정 식별, plan_final + planning_index로 forward").

Stage 4 완료 후 운영자 승인 게이트(Stage 4.5) — 승인 전까지 Stage 5 진입 금지. **운영자 결정 Q 5건이 모두 답변되어야 승인 가능.** Stage 5 진입 시그널은 운영자가 본 세션에 제공(brainstorm 의제 7 + dispatch Sec.6 #1).
