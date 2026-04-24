---
version: v0.6
stage: 3 (plan_review)
date: 2026-04-24
mode: Standard
status: review
session: 14
reviewer: Claude 셀프 리뷰 (동일 세션)
---

# jDevFlow v0.6 — Stage 3 Plan Review (plan_review)

> **상위:** `docs/02_planning_v0.6/plan_draft.md` (Stage 2, 세션 14)
> **상-상위:** `docs/01_brainstorm_v0.6/brainstorm.md` (Stage 1, 세션 13)
> **하위:** `docs/02_planning_v0.6/plan_final.md` (Stage 4) → Stage 4.5 운영자 승인 게이트

---

## Sec. 0. 리뷰 방식

`plan_draft.md` 末미의 **Stage 3 포커스 질문 5개**를 본 리뷰 포커스로 삼는다. 그중 **3건**은 drafter가 plan_final 정책 commit이 필요하다고 플래그한 체크 포인트로, 별도 **"명시 포커스"**로 분리해 독립 발견(F-D1 / F-D2 / F-D3)으로 처리.

| # | 포커스 | 종류 |
|---|--------|------|
| F1 | D6(Hooks)/D7(ETHOS) v0.6 본 릴리스 vs v0.6.1 패치 | **명시 포커스 → F-D1** |
| F2 | R2 team_mode 분기 단일화 — `stage_assignments`만으로 충분? | 추론 포커스 |
| F3 | `jq` 의존성 — `brew install jq` vs POSIX fallback | **명시 포커스 → F-D2** |
| F4 | `pending_team_mode` 필드 v0.6 스키마 포함 vs 제거 | **명시 포커스 → F-D3** |
| F5 | AC.6 schema 하위 호환 — Stage 9 vs Stage 11 귀속 | 추론 포커스 |

Stage 3 범위 **밖**: 셸 플래그·오케스트레이터 상태 머신·Hooks 문법(→ Stage 5), 코드 수준 리뷰(→ Stage 9), 고위험 독립 검증(→ 해당 없음, Standard 유지). 발견 ID: `F-D1~F-D3` 명시 포커스, `F-<focus>-<a,b>` 일반, `F-n<번호>` non-focal.

---

## Sec. 1. 포커스 F1 — D6/D7 포함 시점 (명시 포커스)

plan_draft Sec.3은 D6/D7을 "중 우선순위", Sec.4 M5는 "D5 안정화 이후"로 둠. 그러나 **v0.6 본 vs v0.6.1** 중 어디에 속하는지 명시 없음. M5가 M4(오케스트레이터) 안정화 **전** 합류하면 PostToolUse 훅이 stage 경계 signal과 충돌 → 회귀. D7 단독 선행은 "원칙만 있고 적용은 다음 버전" 모호 상태.

**F-D1 — D6/D7은 v0.6.1 패치로 분리 권고.** 근거: (1) plan_draft M5가 이미 D5 이후 조건. (2) M4 관측 기간(최소 1일) 확보 후 D6 투입이 회귀 차단 유리. (3) D7을 D6과 묶어 일관성 유지.

**제안** (plan_final 정책 commit): *Sec.3에서 D6/D7을 "v0.6.1 로드맵"으로 라벨 분리. Sec.4 M5를 v0.6 본 릴리스에서 제거하고 "v0.6 + 1d 관측 후 v0.6.1 kickoff" 조건화. Sec.9에 "D6 패턴 및 D7 ETHOS 선별 문장은 v0.6.1 Stage 5 확정" 명시.*

**판정:** PASS with 명시 (F-D1 정책 commit 필수). Stage 2 롤백 불요.

---

## Sec. 2. 포커스 F2 — R2 team_mode 분기 범위

plan_draft Sec.5 R2는 `stage_assignments` 파싱으로 분기를 단일화하고 team_mode는 settings.json에만 기록한다고 선언. 그러나 team_mode 리터럴이 필요한 경로 존재: (a) `init_project.sh` 완료 메시지, (b) `switch_team.sh` 차단·변경 메시지, (c) `ai_step.sh` 로그. 즉 **실행 분기**는 `stage_assignments` 단일화로 충분하나 **UI/로그/표시**는 team_mode 리터럴 직접 소비.

**F-2-a — R2 완화 문구 범위 좁힘.** 현재 문구대로면 위 3경로가 규칙 위반으로 읽힘.

**제안** (plan_final 명시): *Sec.5 R2 완화 교체 — "`stage_assignments` 파싱으로 **실행자 분기** 단일화. team_mode 리터럴은 UI 메시지·로그·switch 상태 표시 등 **표시 경로**에서만 참조 허용. 오케스트레이터 Stage 진입 결정은 team_mode 비참조 (Stage 5 설계 제약)."*

**판정:** PASS with 명시 1건 (F-2-a). 방향 옳음, 문구 정밀화만.

---

## Sec. 3. 포커스 F3 — `jq` 의존성 (명시 포커스)

plan_draft Sec.6은 이를 Stage 5로 이월했지만 **비용 큰 결정**: `brew install jq` 전제 → init 첫 실행 시 brew 요구 → 신규 도입 장벽. POSIX fallback(`grep`/`sed`/`awk`) → 파싱 취약(escape, 줄바꿈). 한 번 고르면 D1 스키마 포맷·D2/D3 파싱·Stage 5 설계 전체가 달라지므로 **plan 차원 정책**.

**F-D2 — POSIX 단일, `jq` 비의존 commit 권고.** 근거: (1) init 첫 실행 경로는 POSIX만 가정해야 "CLI 자동화 레이어" North Star와 정합. (2) settings.json은 내부·단일 사용, 필드 소수 → POSIX 취약성이 현실 문제로 번질 확률 낮음. (3) `command -v jq` dual-path는 Stage 5 구현 비용 과다 → 단일 경로로 고정.

**제안** (plan_final 정책 commit): *Sec.6 `jq` 항목 교체 — "v0.6 스크립트는 POSIX(`grep`/`sed`/`awk`)로만 settings.json을 읽고 쓴다. `jq` 비의존. Stage 5는 파일 포맷을 POSIX 파싱 가능 범위로 제약(1줄 1키 원칙, 중첩 최소)." Sec.7 jq 관련 문항 제거.*

**판정:** PASS with 명시 (F-D2 정책 commit 필수).

---

## Sec. 4. 포커스 F4 — `pending_team_mode` 필드 (명시 포커스)

brainstorm Sec.6 샘플 JSON에 `pending_team_mode: null` 포함. 그러나 brainstorm Sec.5 switch 동작이 **"차단 or 즉시 반영" 2분기** 모델 — 예약 전환 시나리오 없음. plan_draft Q1이 Stage 5로 넘겼으나 **시나리오 부재는 설계 디테일이 아니라 스키마 자체에 들어갈지의 정책**. 필드 존재 자체가 D1 확정·D3 동작 명세를 양쪽 고려로 만듦 → **D1 블로커**.

**F-D3 — `pending_team_mode` 필드 v0.6 스키마에서 제거 권고.** 근거: (1) switch 2분기 모델이 확정 → 예약 전환 사용 시나리오 없음. (2) 필드 존재가 "언젠가 쓸 기능" 혼란을 Stage 5 이후 지속 유발. (3) 필요 시 v0.5 관례(추가 필드로만 확장)에 따라 추후 minor bump에서 도입 가능 — 제거 비용 낮음.

**제안** (plan_final 정책 commit): *Sec.3 D1 요구사항에서 "`pending_team_mode` null 허용" 제거. brainstorm Sec.6 샘플 JSON에서 해당 줄이 빠진 형태를 Stage 5 스키마 문서의 기준으로 지정. Sec.7 Q1 삭제 (commit).*

**판정:** PASS with 명시 (F-D3 정책 commit 필수).

---

## Sec. 5. 포커스 F5 — AC.6 schema 하위 호환 귀속

plan_draft Sec.8 AC.6은 체크만 있고 **판단 책임 Stage** 미기재. 작업 성격은 내부 구성 파일 schema 증분 확장(보안·규제·결제 아님), risk tier Standard, v0.5까지 schema bump가 Stage 9 리뷰로 처리됨. Stage 11은 고위험 한정(CLAUDE.md Sec.2) — AC.6 기준 미달.

**F-5-a — AC.6 판단 책임은 Stage 9 코드 리뷰.** Stage 11 이월 불요.

**제안** (plan_final 명시): *AC.6 문구 교체 — "D1(schema v0.4)이 기존 v0.3 settings.json을 깨뜨리지 않고 추가 필드로만 확장하는가? **판단 책임: Stage 9 코드 리뷰 (기존 v0.3 샘플 파일 파싱 호환성 테스트).**"*

**판정:** PASS with 명시 1건 (F-5-a).

---

## Sec. 6. 추가 non-focal 발견

### 6-1. plan_draft Sec.7 Q1~Q5 Stage 5 답변 가능성

| Q | Stage 5 답변 가능? | 판정 |
|---|---------------------|------|
| Q1 `pending_team_mode` 시나리오 | **아니오** (정책 결정) | 🚨 F-D3로 흡수 |
| Q2 `ai_step.sh` 실패 복구 전략 | 예 — state machine 설계 범위 | ✅ |
| Q3 Hooks 활성화 시점 + 패턴 | 시점은 F-D1 흡수, 패턴은 v0.6.1 Stage 5 | ✅ F-D1로 흡수 |
| Q4 백그라운드 감지 수단 | 예 — macOS 단일 플랫폼 설계 | ✅ |
| Q5 `stage_assignments` 파싱 실패 기본 동작 | 예 — lean(fail-closed) 존재 | ✅ |

Leak은 Q1(전량)·Q3(시점 부분) 2건으로 F-D 체크 포인트가 모두 흡수 → 신규 발견 없음.

### 6-2. brainstorm commit 사항 반영

| brainstorm 항목 | plan_draft 반영 | 상태 |
|-----------------|------------------|------|
| Sec.2 패턴 3종 명칭 / Sec.3 team_mode 3종 명칭 / Sec.3 인증 요구 / Sec.4 기본값 (`1`,`3`) | D1·D2·Sec.6 | ✅ |
| Sec.4 init 추천 "★추천★" 마커 | D2에 **미기재** | **F-n1** |
| Sec.5 switch 차단 메시지 한글 verbatim | D3가 "차단 메시지 + /codex:status" 요약 | **F-n2** |
| Sec.6 샘플 JSON verbatim | D1이 "기존 v0.3 필드 전원 유지"로 요약 | ✅ (Stage 5가 brainstorm 참조) |

**F-n1** — plan_final D2에 "`claude-impl-codex-review` 추천 마커 보존 (brainstorm Sec.3/4 verbatim)" 한 줄 추가.
**F-n2** — plan_final D3에 "차단 메시지는 brainstorm Sec.5 한글 원문을 Stage 5에서 그대로 사용" 한 줄 추가.

### 6-3. 결정 로그(brainstorm Sec.8) 반영

| 결정 | plan_draft 반영 | 상태 |
|------|------------------|------|
| Codex executor = plugin-cc / switch 차단 = 백그라운드 체크 / 기본 team_mode = `claude-only` | Sec.6·D3·D2 | ✅ |
| `@openai/codex` CLI 수동 보조 전용 | plan_draft **언급 없음** | **F-n3** |
| 추천 team_mode = `claude-impl-codex-review` | D2 직접 명시 없음 | F-n1로 흡수 |

**F-n3** — plan_final Sec.2 Non-goals에 "`@openai/codex` CLI를 오케스트레이터 자동화 경로에서 호출하지 않음 (수동 보조 도구 전용, brainstorm Sec.8)" 한 줄 추가 — Stage 5 혼동 방지.

---

## Sec. 7. 개정 제안 종합 (Stage 4 Plan Final 입력)

본 리뷰 발견은 모두 **plan_final.md에서 흡수**. plan_draft.md는 Stage 2 스냅샷으로 보존, 변경 이력만 한 줄 추가.

| ID | 유형 | 위치 | plan_final 조치 |
|----|------|------|----------------|
| **F-D1** | 정책 commit | Sec.3 D6/D7, Sec.4 M5, Sec.9 | D6/D7 → v0.6.1 패치 분리. M5 v0.6 본에서 제거, "v0.6+1d 관측 후 kickoff" 조건화. |
| **F-D2** | 정책 commit | Sec.6, Sec.7 | `jq` 비의존, POSIX 단일 파싱. Stage 5 설계 제약("1줄 1키, 중첩 최소") 이월. |
| **F-D3** | 정책 commit | Sec.3 D1, Sec.7 Q1 | `pending_team_mode` 필드 제거. Q1 삭제. |
| F-2-a | 명시 추가 | Sec.5 R2 | R2 범위를 "실행자 분기 단일화"로 축소, "표시 경로" 예외 명시. |
| F-5-a | 명시 추가 | Sec.8 AC.6 | AC.6 판단 책임을 Stage 9 코드 리뷰로 귀속. |
| F-n1 | 명시 추가 | Sec.3 D2 | init "★추천★" 마커 보존 (brainstorm verbatim). |
| F-n2 | 명시 추가 | Sec.3 D3 | switch 차단 메시지 brainstorm 한글 verbatim 사용. |
| F-n3 | 명시 추가 | Sec.2 Non-goals | `@openai/codex` CLI 오케스트레이터 경로 비호출. |

유형 breakdown: **정책 commit 3 (F-D1, F-D2, F-D3) / 명시 추가 5 (F-2-a, F-5-a, F-n1, F-n2, F-n3) / Stage 5 이월 0** (Q2/Q4/Q5는 원래 Stage 5 설계 범위 적정).

---

## Sec. 8. 판정

**Plan Draft 구조적으로 건전.** Stage 2 롤백 불요. Stage 4 Plan Final은 Sec.7 8건 개정을 흡수한 단일 문서로 진행. 포커스 5개 전원 PASS(명시 조건부).

| 포커스 | 판정 |
|--------|------|
| F1 — D6/D7 시점 | PASS with 명시 (F-D1 정책 commit) |
| F2 — team_mode 분기 범위 | PASS with 명시 1건 (F-2-a) |
| F3 — `jq` 의존성 | PASS with 명시 (F-D2 정책 commit) |
| F4 — `pending_team_mode` | PASS with 명시 (F-D3 정책 commit) |
| F5 — AC.6 귀속 | PASS with 명시 1건 (F-5-a) |

**plan_final 진행 조건:**
1. 정책 commit 3건(F-D1, F-D2, F-D3)이 plan_final 본문에 명시 결정 문장으로 흡수.
2. Approval checklist AC.1–AC.6을 ✅/❌ + 한 줄 메모로 채움. AC.6은 F-5-a 반영 문구.
3. plan_draft Sec.7 Q1 제거, Q3는 F-D1로 대체, Q2/Q4/Q5 유지.

---

## Sec. 9. 본 리뷰가 다루지 않는 것

- `ai_step.sh` 내부 상태 머신·함수 분할·stage 경계 signal exact 명세 → **Stage 5**.
- Hooks PostToolUse 키 위치/패턴/타임아웃 → **v0.6.1 Stage 5** (F-D1 전제).
- settings.json POSIX 파싱 구체 문법, `jq` 없는 JSON write 전략 → **Stage 5**.
- 백그라운드 프로세스 감지 커맨드 선택 → **Stage 5**.
- `stage_assignments` 기본값 테이블 셀 값 → **Stage 5**.
- 코드 수준 리뷰 → **Stage 9**.
- 고위험 독립 검증 → 본 작업은 Standard, Stage 11 대상 아님.

---

## Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-24 | v1 — Stage 3 리뷰 작성 | 세션 14. 동일 세션 셀프 리뷰. 5개 포커스 + 정책 commit 3건 + 명시 추가 5건. plan_final로 8건 포워드. |

---

## 📌 다음 스테이지 — Stage 4 Plan Final 진입 지시

본 리뷰 **Sec.7 개정 제안 종합**을 흡수한 **단일 문서**로 `docs/02_planning_v0.6/plan_final.md`를 작성한다.

- 정책 commit 3건(F-D1, F-D2, F-D3)은 plan_final 본문의 명시 결정 문장(Deliverables·Milestones·Non-goals 각 해당 위치)으로 녹여 넣는다.
- plan_draft Sec.8 Approval checklist AC.1–AC.6을 ✅/❌ + 한 줄 메모로 채운다. AC.6은 F-5-a 수정 문구 기준.
- plan_draft Sec.7 Open Questions는 Q1 제거, Q3는 F-D1 참조로 대체, Q2/Q4/Q5 유지.
- Stage 4 완료 후 운영자 승인 게이트(Stage 4.5) — 승인 전까지 Stage 5 진입 금지.
