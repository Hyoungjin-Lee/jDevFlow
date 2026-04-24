---
version: v0.6
stage: 4 (plan_final)
date: 2026-04-24
mode: Standard
status: pending_operator_approval
session: 14
upstream:
  - docs/02_planning_v0.6/plan_draft.md (v1)
  - docs/02_planning_v0.6/plan_review.md (v1)
---

# jDevFlow v0.6 — CLI 자동화 레이어 실행 계획 (plan_final)

> **상위:** `docs/01_brainstorm_v0.6/brainstorm.md` (Stage 1, 세션 13)
> **상위:** `docs/02_planning_v0.6/plan_draft.md` (Stage 2, 세션 14) · `docs/02_planning_v0.6/plan_review.md` (Stage 3, 세션 14)
> **하위:** Stage 4.5 **운영자 승인 게이트** → Stage 5 technical_design
> **상태 배너:** ⏳ **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.

---

## Sec. 0. plan_draft → plan_final 변경 요약

plan_review.md Sec.7 개정 제안 8건 전량 흡수. plan_draft는 Stage 2 스냅샷으로 보존.

| ID | 유형 | plan_final 반영 위치 | 변경 요지 |
|----|------|----------------------|-----------|
| **F-D1** | 정책 commit | Sec. 2 · Sec. 3 (D6/D7 이월) · Sec. 4 (M5 제거) · Sec. 7 (Q3 삭제) · Sec. 9 | D6(Hooks)/D7(ETHOS)를 **v0.6.1 패치**로 분리. v0.6 본 릴리스 스코프에서 제외. |
| **F-D2** | 정책 commit | Sec. 3 D2/D3 요구사항 · Sec. 6 · Sec. 9 | `jq` 비의존. v0.6 스크립트는 POSIX(`grep`/`sed`/`awk`)로만 settings.json 읽기/쓰기. "1줄 1키, 중첩 최소" 스키마 제약을 Stage 5로 이월. |
| **F-D3** | 정책 commit | Sec. 3 D1 요구사항 · Sec. 7 (Q1 삭제) | `pending_team_mode` 필드 **v0.6 스키마에서 제거**. switch 2분기 모델만 유지. |
| F-2-a | 명시 추가 | Sec. 5 R2 완화 문구 | R2를 "실행자 분기 단일화"로 좁힘. team_mode 리터럴은 UI/로그/switch 상태 표시 등 **표시 경로**에서만 참조 허용. |
| F-5-a | 명시 추가 | Sec. 8 AC.6 | AC.6 schema 하위 호환성 **판단 책임 = Stage 9 코드 리뷰**. Stage 11 이월 아님. |
| F-n1 | 명시 추가 | Sec. 3 D2 | init 2/2 대화에서 `claude-impl-codex-review` ★추천★ 마커 **brainstorm Sec.3/4 verbatim 보존**. |
| F-n2 | 명시 추가 | Sec. 3 D3 | switch 차단 메시지 **brainstorm Sec.5 한글 원문 verbatim** 사용. |
| F-n3 | 명시 추가 | Sec. 2 Non-goals | `@openai/codex` CLI는 오케스트레이터 자동화 경로 **비호출** (수동 보조 전용). |

유형 breakdown: 정책 commit 3 / 명시 추가 5 / Stage 5 이월 0.

---

## Sec. 1. 목표 (Goals)

**North Star:** 운영자의 수동 터미널 개입을 "Stage 1 대화"와 "git 푸시" 두 지점으로 수렴시킨다.

| # | Goal | 측정 가능 조건 |
|---|------|---------------|
| G1 | Stage 2–13 자동 실행 레이어 확립 | `ai_step.sh` 한 번 호출로 Stage 경계까지 무인 진행 (운영자 승인 게이트 제외) |
| G2 | 운영 패턴 3종 + team_mode 3종을 `init_project.sh` 1회 실행으로 세팅 | 신규 프로젝트에서 init → settings.json `workflow_mode` + `team_mode` 기록 완료 |
| G3 | team_mode 런타임 전환 안전 보장 | `switch_team.sh` 실행 시 백그라운드 claude/codex 프로세스 있으면 차단, 없으면 즉시 반영 |
| G4 | 운영자가 패턴/팀 구성을 나중에 바꿀 때 참조할 단일 가이드 제공 | `docs/guides/switching.md` 시나리오 ≥4종 |
| G5 | 자동화 레이어 안전 기본값 확립 | v0.6 스크립트는 POSIX 파싱·claude-only 기본값·fail-closed 세 축으로 동작 [F-D2] |

> G5는 plan_draft의 "gstack ETHOS 내재화" 목표를 **v0.6.1로 이월** [F-D1]하고, v0.6 범위 안의 안전 기본값 합성 목표로 재정의.

---

## Sec. 2. 비목표 (Non-goals)

plan_draft Sec.2 계승 + **F-D1 / F-n3 신규 항목**:

| 항목 | 근거 |
|------|------|
| Goal 2 eval 러너 / Goal 6 모드 선택 트리 / `/canary` | brainstorm 드롭 |
| Goal 1 언어 선택 마법사 / Goal 4 `.skills/examples/` 확장 / `/investigate` 통합 | 글로벌 공개 버전으로 이연 (KO only 기조) |
| v0.5 CLAUDE.md/WORKFLOW.md 구조 재작업 | v0.5 세션 12에서 75%/65% 경량화 완료 |
| CI 인프라 변경 | v0.5 세션 11 완료 |
| settings.json 자동 마이그레이션 도구 | 수기 업그레이드로 충분 |
| **Hooks PostToolUse / gstack ETHOS — v0.6.1 이월 [F-D1]** | D6/D7은 v0.6 본 릴리스 관측 기간(최소 1일) 후 v0.6.1 kickoff에서 처리. M4 안정화 전 투입 시 stage 경계 signal과 회귀 위험. |
| **`@openai/codex` CLI 오케스트레이터 자동화 경로 비호출 [F-n3]** | brainstorm Sec.8 결정. plugin-cc(`/codex:rescue`, `/codex:review`)만 자동화 executor. `@openai/codex`는 수동 보조 도구 전용 — 오케스트레이터와 세션 분리. |

---

## Sec. 3. 산출물 (Deliverables)

v0.6 본 릴리스는 **상 우선순위 D1~D5**만 포함. D6/D7은 Sec.3-1로 분리.

| # | 경로 | 목적 | 요구사항 |
|---|------|------|---------|
| D1 | `settings.json` schema v0.4 | `workflow_mode` / `team_mode` / `stage_assignments` 필드 추가 | `schema_version: "0.4"`; 3종 workflow_mode (`desktop-only`/`desktop-cli`/`cli-only`) + 3종 team_mode (`claude-impl-codex-review`/`codex-impl-claude-review`/`claude-only`); 기존 v0.3 필드 전원 유지; **`pending_team_mode` 필드 미포함 [F-D3]**; POSIX 파싱 가능 포맷 (1줄 1키, 중첩 최소) [F-D2] |
| D2 | `scripts/init_project.sh` | 신규 프로젝트에서 운영방식·team 선택 → settings.json 기록 | 2단계 대화(`1/2`, `2/2`) brainstorm Sec.4 **verbatim**; `claude-impl-codex-review` **★추천★ 마커 보존 [F-n1]**; 기본값 `workflow_mode=1`, `team_mode=3`; 완료 메시지에 `switching.md` 포인터; **`jq` 비의존 POSIX 파싱으로만 settings.json 기록 [F-D2]** |
| D3 | `scripts/switch_team.sh` | team_mode 런타임 전환 + 안전 체크 | 백그라운드 `claude` / `codex` 프로세스 탐지 로직; 진행 중이면 **brainstorm Sec.5 한글 차단 메시지 verbatim [F-n2]** + `/codex:status` 안내; 아니면 settings.json 즉시 갱신; **POSIX 파싱으로만 settings.json 읽기/쓰기 [F-D2]** |
| D4 | `docs/guides/switching.md` | 패턴/팀 전환 시나리오 가이드 | 시나리오 ≥4종 (desktop→desktop-cli, claude-only→codex-review 등) + 각 시나리오 실행 커맨드 1–3줄; 역할별 권한(OpenAI 구독 등) 명시 |
| D5 | `scripts/ai_step.sh` 오케스트레이터 | Stage 2–13 자동 진행, team_mode 분기 처리 | Stage 경계 구분자 + `stage_assignments` 참조; 실패 시 재시도/중단 정책; 운영자 승인 게이트(Stage 4 / 고위험 시 Stage 11) 일시정지; **team_mode 리터럴 실행 분기 금지 — `stage_assignments`만 파싱 [F-2-a]** |

### Sec. 3-1. v0.6.1 이월 산출물 [F-D1]

| # | 경로 | 이월 이유 |
|---|------|----------|
| D6 | Hooks PostToolUse 규칙 (`.claude/settings.json` hooks 섹션) | D5 M4 관측 기간 확보 후 투입 — stage 경계 signal과 회귀 위험 차단. Hooks 키 위치·패턴·타임아웃은 v0.6.1 Stage 5에서 확정. |
| D7 | CLAUDE.md Sec. 추가 — gstack ETHOS 요약 | D6과 한 묶음으로 v0.6.1에서 처리. 원칙만 있고 적용 없는 모호 상태 방지. |

---

## Sec. 4. Milestones

```
M1. 스키마 확정         — D1 완료                       (소비자 조건 선결)
    │
    ▼
M2. 초기 세팅 경로       — D1 + D2                      (init → settings.json 일관성)
    │
    ▼
M3. 런타임 전환 경로     — D1 + D3 + D4                 (switch + guide 동시 릴리스)
    │
    ▼
M4. 오케스트레이션 본체  — D5 (stage_assignments 소비)
    │
    ▼
v0.6 본 릴리스 → 관측 기간(최소 1일) → v0.6.1 kickoff (D6/D7) [F-D1]
```

plan_draft M5 제거 [F-D1]. 우선순위 상(D1~D5)이 Stage 5 설계 → Stage 8 구현 → Stage 9 리뷰 → Stage 12–13 릴리스의 단일 파이프라인을 구성.

---

## Sec. 5. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 | 담당 |
|---|--------|-----------|--------|------|------|
| R1 | `ai_step.sh` Stage 경계 모호성 — stage 완료/실패 판정 기준 흐릿 시 다음 stage가 잘못된 전제로 진행 | 중 | 상 | Stage 5에서 각 stage 종료 signal 명세(artifact 존재 + exit code + 키워드 grep)를 테이블로 고정. `ai_step.sh`는 3종 signal 전부 만족 시에만 다음 stage 진입 | Stage 5 (D5) |
| R2 | team_mode 분기 로직 복잡도 폭증 — 3 mode × 4 stage = 12 경로 | 중 | 중 | **[F-2-a]** `stage_assignments` 파싱으로 **실행자 분기** 단일화 (오케스트레이터 Stage 진입 결정은 team_mode 비참조 — **Stage 5 설계 제약**). team_mode 리터럴은 **UI 메시지·로그·switch 상태 표시 등 표시 경로에서만** 참조 허용. | Stage 5 / 8 (D5) |
| R3 | `switch_team.sh` 백그라운드 감지 false positive — 무관한 claude 세션 실행 중 과차단 | 중 | 중 | 프로세스 탐지 시 PID + 커맨드라인 함께 출력, 운영자 `--force` 오버라이드 허용. 기본은 차단 유지 | Stage 8 (D3) |

plan_draft 나머지 후보(Codex plugin-cc 인증 요구)는 `claude-only` 기본값으로 이미 완화됨 — 액티브 리스크 제외.

---

## Sec. 6. 의존성

**내부:**
- D1(schema v0.4)이 선행. D2/D3/D5 모두 소비자. 스키마 미확정 상태에서 스크립트 작성 금지.
- D5는 `stage_assignments`를 읽으므로 D1 키 이름이 고정된 뒤에만 구현.
- D6/D7은 v0.6.1 이월 — 본 plan 의존성 그래프 외부 [F-D1].

**외부:**
- **Claude Max 플랜 이상** (`claude --teammate-mode`): G1/G2 전제. 3 team_mode 모두 필요.
- **`codex-plugin-cc`** (`/codex:rescue`, `/codex:review`): ChatGPT 유료 구독 또는 OpenAI API 키 보유 시에만 `claude-impl-codex-review` / `codex-impl-claude-review` 선택 가능. `claude-only`는 외부 의존 없음 — **신규 도입자 기본 경로**.
- **`jq` 제거 [F-D2]** — v0.6 스크립트는 POSIX `grep`/`sed`/`awk`로만 settings.json 파싱. `brew install jq` 전제 폐기. Stage 5는 파일 포맷을 "1줄 1키, 중첩 최소" 범위로 제약.

---

## Sec. 7. 열린 질문 (Stage 5에서 답)

plan_draft Q1 삭제 [F-D3]. plan_draft Q3는 F-D1으로 흡수 — v0.6.1 Stage 5에서 처리.

| # | 질문 | Stage 5 답변 책임 |
|---|------|-------------------|
| Q1 (← 구 Q2) | `ai_step.sh`가 stage 중간에 실패할 때 복구 전략 — 자동 재시도? 체크포인트 롤백? 중단 후 운영자 호출? | Stage 5 D5 설계에서 답 |
| Q2 (← 구 Q4) | `switch_team.sh` 백그라운드 감지 — `pgrep` / `ps aux` / `/codex:status` 중 구현 선택 (macOS 단일 플랫폼) | Stage 5 D3 설계에서 답 |
| Q3 (← 구 Q5) | `stage_assignments` 파싱 실패(존재하지 않는 executor명 등) 시 `ai_step.sh` 기본 동작 — fail-closed(중단) 확정 제안 | Stage 5 D5 설계에서 답 |

정책 결정(모드 이름, 기본값, 드롭 항목, jq 제거, pending 필드 제거)은 본 plan에서 commit.

---

## Sec. 8. Approval checklist (Stage 4 → Stage 4.5)

| # | 체크 | 판정 | 메모 |
|---|------|------|------|
| AC.1 | 목표(Sec.1 G1–G5)가 brainstorm North Star("운영자 수동 개입 최소화")와 정합한가? | ✅ | *Sec.1에 명시* — G1/G2가 "Stage 1 대화 + git 푸시 2지점" 수렴 목표로 귀결. G5는 F-D1으로 ETHOS 이월 후 안전 기본값 목표로 재정의. |
| AC.2 | 범위(Sec.3 D1–D5)가 v0.6 스코프로 적절한가? | ✅ | *Sec.3 + Sec.3-1에 명시* — D6/D7은 F-D1으로 v0.6.1 이월. D1–D5는 brainstorm Sec.7 상 우선순위 5건 전량 포함. |
| AC.3 | 리스크 Top-3(Sec.5)가 현실적이고, 완화책이 설계/구현 단계에서 실행 가능한가? | ✅ | *Sec.5에 명시* — R2 완화를 F-2-a로 "실행자 분기 단일화 + 표시 경로 예외"로 정밀화. Stage 5 설계 제약으로 commit. |
| AC.4 | 열린 질문(Sec.7)이 Stage 5 기술 설계에서 답 가능한 범위로 한정됐는가? | ✅ | *Sec.7에 명시* — 정책 Q(Q1-old pending_team_mode)는 F-D3으로 본 plan commit. 잔여 Q1–Q3은 D3/D5 설계 디테일 한정. |
| AC.5 (Standard) | 의존성(Sec.6) 중 외부 구독·도구가 `claude-only` 기본값으로 우회 가능한가? | ✅ | *Sec.6에 명시* — init 2/2 기본값 `team_mode=3 (claude-only)`. `jq` 제거 [F-D2]로 brew 전제 폐기. Claude Max 플랜만 전제. |
| AC.6 (Standard) | D1(schema v0.4)이 기존 v0.3 settings.json을 깨뜨리지 않고 추가 필드로만 확장하는가? | ✅ | *Sec.3 D1 + Sec.9에 명시* — 추가 필드만 확장, v0.3 필드 전원 유지. **판단 책임: Stage 9 코드 리뷰 (기존 v0.3 샘플 파일 파싱 호환성 테스트) [F-5-a]**. Stage 11 이월 아님. |

**체크리스트 판정: 6/6 ✅. 운영자 승인 대기.**

---

## Sec. 9. 본 plan이 결정하지 않는 것 (Stage 5 이후로 이월)

- `ai_step.sh` 내부 아키텍처 (함수 분할, state machine 방식).
- Stage 완료 signal의 exact 명세 (artifact 경로, grep 키워드).
- `stage_assignments` 기본값 테이블 셀 값 (team_mode별 × stage별).
- 백그라운드 프로세스 감지 커맨드 선택 (pgrep / ps aux / /codex:status).
- `switching.md` 시나리오 개별 서술.
- **POSIX 파싱 가능 settings.json 스키마 상세 — "1줄 1키, 중첩 최소" 제약 하 구조 [F-D2]**.
- **`jq` 없는 JSON write 전략 (temp file → mv 패턴 등) [F-D2]**.
- CLI 메시지 문구 (brainstorm verbatim 외 부분).
- **D6 Hooks 패턴/타임아웃 · D7 gstack ETHOS 선별 문장 — v0.6.1 Stage 5 [F-D1]**.

---

## Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-24 | v1 — Stage 4 plan_final | 세션 14. plan_review 8건 개정 흡수 (정책 commit 3 / 명시 추가 5). Approval checklist 6/6 ✅. 운영자 승인 대기. |

---

## 📌 다음 스테이지

**Stage 4.5 — 운영자 승인 게이트.**

- **승인 시:** Stage 5 Technical Design 진입. Bundle 없음 — D1→D2→D3→D4→D5 단일 trail. 모델 Opus 권장(Stage 5).
- **거절 시:** Stage 2(plan_draft) 복귀, 재작성 후 Stage 3/4 재진행.
- **부분 수정 요청 시:** 해당 섹션(F-xx ID 참조)만 개정 후 운영자 재확인.
