---
version: v0.6
stage: 2 (plan_draft)
date: 2026-04-24
mode: Standard
status: draft
session: 14
---

# jDevFlow v0.6 — CLI 자동화 레이어 실행 계획 (plan_draft)

> **상위:** `docs/01_brainstorm_v0.6/brainstorm.md` (Stage 1, 세션 13)
> **본 문서:** `docs/02_planning_v0.6/plan_draft.md` (Stage 2, 세션 14)
> **다음:** `docs/02_planning_v0.6/plan_review.md` → `plan_final.md`
> 모드 근거: 툴링/자동화 작업. 보안·규제·외부 스키마 아님. settings.json schema v0.4는 내부 구성 파일 → Standard 유지.

---

## Sec. 1. 목표 (Goals)

**North Star:** 운영자의 수동 터미널 개입을 "Stage 1 대화"와 "git 푸시" 두 지점으로 수렴시킨다.

| # | Goal | 측정 가능 조건 |
|---|------|---------------|
| G1 | Stage 2–13 자동 실행 레이어 확립 | `ai_step.sh` 한 번 호출로 Stage 경계까지 무인 진행 (운영자 승인 게이트 제외) |
| G2 | 운영 패턴 3종 + team_mode 3종을 `init_project.sh` 1회 실행으로 세팅 | 신규 프로젝트에서 init → settings.json `workflow_mode` + `team_mode` 기록 완료 |
| G3 | team_mode 런타임 전환 안전 보장 | `switch_team.sh` 실행 시 백그라운드 claude/codex 프로세스 있으면 차단, 없으면 즉시 반영 |
| G4 | 운영자가 패턴/팀 구성을 나중에 바꿀 때 참조할 단일 가이드 제공 | `docs/guides/switching.md` 시나리오 ≥4종 (desktop→desktop-cli, claude-only→codex-review 등) |
| G5 | 오케스트레이터 설계 철학을 CLAUDE.md에 내재화 | gstack ETHOS 요약이 CLAUDE.md에 반영되고, `ai_step.sh`가 그 원칙에 근거해 stage fail 처리 |

---

## Sec. 2. 비목표 (Non-goals)

브레인스토밍에서 드롭·이연된 항목 + 본 draft 작성 중 판단:

| 항목 | 근거 |
|------|------|
| Goal 2 eval 러너 | 브레인스토밍 드롭 — 운영자 필요성 미인지 |
| Goal 6 모드 선택 트리 스킬 | 브레인스토밍 드롭 — `.skills/tool-picker/SKILL.md` 로 커버됨 |
| `/canary` 스킬 | 브레인스토밍 드롭 — 브라우저 데몬 의존, 본 스택에 해당 없음 |
| Goal 1 언어 선택 마법사 | 글로벌 공개 버전으로 이연 (KO only 기조 유지) |
| Goal 4 `.skills/examples/` 확장 | 글로벌 공개 버전으로 이연 |
| `/investigate` 스킬 통합 | 글로벌 공개 버전으로 이연 — 현재는 참조만 |
| 기존 v0.5 문서(CLAUDE.md, WORKFLOW.md) 구조 재작업 | v0.5에서 75%/65% 경량화 완료 — 본 버전은 증분 추가만 |
| CI 인프라 변경 (GitHub Actions) | v0.5 세션 11에서 완료 — 본 버전은 스크립트 레벨 작업 |
| settings.json 스키마 하위 호환성 자동 마이그레이션 도구 | 수기 업그레이드로 충분 (내부 프로젝트 단일 사용) |

---

## Sec. 3. 산출물 (Deliverables)

| # | 경로 | 목적 | 요구사항 |
|---|------|------|---------|
| D1 | `settings.json` schema v0.4 + 문서 | `workflow_mode` / `team_mode` / `stage_assignments` 필드 추가 | `schema_version: "0.4"`; 3종 workflow_mode + 3종 team_mode 열거 가능; `pending_team_mode` null 허용; 기존 v0.3 필드 전원 유지 |
| D2 | `scripts/init_project.sh` | 신규 프로젝트에서 운영방식·team 선택 → settings.json 기록 | 2단계 대화(`1/2`, `2/2`) 브레인스토밍 Sec.4 원문 기반; 기본값 `workflow_mode=1`, `team_mode=3`; 완료 메시지에 `switching.md` 포인터 |
| D3 | `scripts/switch_team.sh` | team_mode 런타임 전환 + 안전 체크 | 백그라운드 `claude` / `codex` 프로세스 탐지 로직; 진행 중이면 차단 메시지 + `/codex:status` 안내; 아니면 settings.json 즉시 갱신 |
| D4 | `docs/guides/switching.md` | 패턴/팀 전환 시나리오 가이드 | 시나리오 ≥4종 + 각 시나리오 실행 커맨드 1–3줄; 역할별 권한(OpenAI 구독 등) 명시 |
| D5 | `scripts/ai_step.sh` 오케스트레이터 | Stage 2–13 자동 진행, team_mode에 따라 실행자 분기 | Stage 경계 구분자 + stage_assignments 참조; 실패 시 재시도/중단 정책; 운영자 승인 게이트(Stage 4 / 고위험 시 Stage 11) 일시정지 |
| D6 | Hooks PostToolUse 규칙 (`.claude/settings.json` hooks 섹션) | 파일 편집 직후 `py_compile` / `shellcheck` 자동 실행 | 대상 경로 패턴: `src/**/*.py`, `scripts/**/*.sh`; 실패 시 에이전트에 결과 반환; CLI 워크플로우 정착 직후 활성화 (D5 이후) |
| D7 | CLAUDE.md Sec. 추가 — gstack ETHOS 요약 | 오케스트레이터 설계 철학(완전성·역할분리·Boil the Lake) 문서화 | 3–5개 원칙; `ai_step.sh` 실패 정책이 이 원칙에 근거함을 명시 |

---

## Sec. 4. Milestones

```
M1. 스키마 확정        — D1 완료                         (소비자 조건 선결)
    │
    ▼
M2. 초기 세팅 경로      — D1 + D2                         (init → settings.json 일관성)
    │
    ▼
M3. 런타임 전환 경로    — D1 + D3 + D4                   (switch + guide 동시 릴리스)
    │
    ▼
M4. 오케스트레이션 본체 — D5 (team_mode 분기, stage_assignments 소비)
    │
    ▼
M5. 자동화 보강        — D6 (Hooks) + D7 (ETHOS)         (D5 안정화 이후)
    │
    ▼
M6. Stage 9 리뷰 → Stage 11 검증 → Stage 12–13 릴리스
```

우선순위 상(D1~D5)이 Stage 5 설계 → Stage 8 구현 → Stage 9 리뷰 → Stage 11 검증 → Stage 12–13 릴리스의 단일 파이프라인에 묶인다. 우선순위 중(D6, D7)은 D5 안정화 이후 합류.

---

## Sec. 5. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 | 담당 |
|---|--------|-----------|--------|------|------|
| R1 | `ai_step.sh` 오케스트레이터 Stage 경계 모호성 — stage 완료/실패 판정 기준이 흐릿하면 다음 stage가 잘못된 전제로 진행 | 중 | 상 | Stage 5에서 각 stage 종료 signal 명세(artifact 존재 + exit code + 키워드 grep)를 테이블로 고정. `ai_step.sh`는 3종 signal 전부 만족 시에만 다음 stage 진입 | Stage 5 (technical_design) |
| R2 | team_mode 분기 로직이 D5 안에서 복잡도 폭증 — 3 mode × 4 stage = 12 경로 | 중 | 중 | `stage_assignments` 파싱으로 분기 단일화(executor=$(jq ...)). team_mode 자체는 settings.json에만 기록, 오케스트레이터는 stage_assignments만 읽음 | Stage 5 / 8 |
| R3 | `switch_team.sh` 백그라운드 감지 false positive — 다른 claude 세션(문서 작성 등)이 실행 중일 때 과차단 | 중 | 중 | 프로세스 탐지 시 PID+커맨드라인을 함께 출력하고 운영자가 `--force`로 오버라이드 가능. 기본은 차단 유지 | Stage 8 (D3) |

나머지 후보(Codex plugin-cc 인증 요구 → 접근성 저하)는 `claude-only` 기본값으로 이미 완화됨. v0.6 스코프에서는 액티브 리스크에서 제외.

---

## Sec. 6. 의존성

**내부:**
- D1(schema v0.4)가 선행. D2/D3/D5 모두 소비자. 스키마 미확정 상태에서 스크립트 작성 금지.
- D5는 `stage_assignments`를 읽으므로 D1 키 이름이 고정된 뒤에만 구현.
- D6(Hooks)는 D5가 만드는 stage 경계 규약을 참조 — 실행 순서는 D5 → D6.

**외부:**
- Claude Max 플랜 이상 (`claude --teammate-mode`): G1/G2 전제.
- `codex-plugin-cc` (`/codex:rescue`, `/codex:review`): ChatGPT 유료 구독 또는 OpenAI API 키 보유 시에만 `claude-impl-codex-review` / `codex-impl-claude-review` 선택 가능. `claude-only`는 외부 의존 없음.
- `jq` (macOS 기본 미포함): init/switch 스크립트가 settings.json 파싱에 사용. `brew install jq` 전제 or 플레인 sed/grep fallback 결정 필요 → Stage 5.

---

## Sec. 7. 열린 질문 (Stage 5에서 답)

| # | 질문 | 판단 책임 |
|---|------|----------|
| Q1 | `pending_team_mode` 필드는 어떤 시나리오에서 사용되는가? switch가 차단됐을 때 "예약 전환"용인지, 아니면 다른 용도인지 | Stage 5 technical_design |
| Q2 | `ai_step.sh`가 stage 중간에 실패할 때 복구 전략 — 자동 재시도? 체크포인트로 롤백? 중단 후 운영자 호출? | Stage 5 |
| Q3 | Hooks PostToolUse 활성화 시점 — D5 완성 직후인가, v0.6.1 패치에서인가? `.claude/settings.json` hooks 키 위치 및 pattern 확정 | Stage 5 |
| Q4 | `switch_team.sh` 백그라운드 감지를 `pgrep` / `ps aux` / `/codex:status` 중 무엇으로 구현할지 — 플랫폼(macOS 단일) 고려 | Stage 5 |
| Q5 | `stage_assignments` 파싱 실패(존재하지 않는 executor명 등) 시 `ai_step.sh`의 기본 동작 — fail-closed(중단) 확정 제안, Stage 5에서 재확인 | Stage 5 |

정책 결정(모드 이름, 기본값, 드롭 항목)은 본 plan에서 commit. 위 5개는 설계 디테일에 한정.

---

## Sec. 8. Approval checklist 초안 (Stage 4)

- [ ] **AC.1** — 목표(Sec.1 G1–G5)가 브레인스토밍 North Star("운영자 수동 개입 최소화")와 정합한가?
- [ ] **AC.2** — 범위(Sec.3 D1–D7)가 v0.6 스코프로 적절한가? (우선순위 하 항목이 누락 없이 이연됐는가?)
- [ ] **AC.3** — 리스크 Top-3(Sec.5)가 현실적이고, 완화책이 설계/구현 단계에서 실행 가능한가?
- [ ] **AC.4** — 열린 질문(Sec.7)이 Stage 5 기술 설계에서 답 가능한 범위로 한정됐는가?
- [ ] **AC.5 (Standard 고유)** — 의존성(Sec.6) 중 외부 구독·도구가 `claude-only` 기본값으로 우회 가능한가? (신규 사용자 진입 장벽 체크)
- [ ] **AC.6 (Standard 고유)** — D1(schema v0.4)이 기존 v0.3 settings.json을 깨뜨리지 않고 추가 필드로만 확장하는가?

---

## Sec. 9. 본 plan이 결정하지 않는 것 (Stage 5 이후로 이월)

- `ai_step.sh` 내부 아키텍처 (함수 분할, state machine 방식).
- stage 완료 signal의 exact 명세 (artifact 경로, grep 키워드).
- Hooks 실행 패턴 (glob, 타임아웃, 실패 시 에이전트 알림 방법).
- `stage_assignments` 기본값 테이블의 정확한 셀 값 (team_mode별 × stage별).
- 백그라운드 프로세스 감지 커맨드 구현.
- switching.md 시나리오 개별 서술.
- gstack ETHOS 원문 선별 → CLAUDE.md에 들어갈 요약 문장.

---

## Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-24 | v1 초안 (세션 14) | brainstorm.md 기반 Standard 모드 plan_draft 작성 |

---

## 다음 스테이지 — Stage 3 plan_review 포커스 질문

1. **Sec.3 D1–D7 중 D6/D7이 v0.6 스코프에 포함되어야 하는가, 아니면 v0.6.1로 분리하는 게 맞는가?** (중 우선순위 2건의 시점 판단)
2. **Sec.5 R2 "team_mode 분기 단일화"**가 `stage_assignments`만으로 충분한지, 아니면 team_mode 자체를 오케스트레이터가 직접 참조해야 하는 경로가 있는지 (예: 에이전트 팀 UI 메시지).
3. **Sec.6 외부 의존성 중 `jq`** — macOS 기본 미포함 상황에서 init 스크립트가 `brew install jq`를 요구할지, plain POSIX 파싱으로 fallback할지.
4. **Sec.7 Q1 `pending_team_mode`** — 필드 자체를 v0.6에 포함할지, 실제 사용 시나리오가 생길 때까지 schema에서 제거할지.
5. **Sec.8 AC.6** — schema 하위 호환성 체크를 Stage 11 (고위험) 검증 대상에 넣을지, Stage 9 코드 리뷰로 충분한지.
