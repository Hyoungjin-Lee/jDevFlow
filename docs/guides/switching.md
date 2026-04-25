# 패턴/팀 구성 전환 가이드

> `init_project.sh` 이후 운영 패턴(`workflow_mode`) 또는 팀 구성(`team_mode`)을 바꿀 때 읽는 문서.
> 상위 설계: `docs/03_design/v0.6_cli_automation/technical_design.md` Sec.5.

---

## 1. 전환 전 체크리스트

- 현재 백그라운드 claude/codex 작업 없는가? (`bash scripts/switch_team.sh --status`)
- 현재 stage 경계인가? (stage 중간 전환은 `plan_final` Sec.5 R2 위반 위험)
- 필요한 외부 구독(Claude Max, ChatGPT 유료/OpenAI API)이 준비됐는가?

---

## 2. 시나리오 4종

각 시나리오는 **전제 / 커맨드 / 효과** 3요소로 기술한다.

### 2.1 `desktop-only` → `desktop-cli` (CLI 자동화 도입)

- **대상:** Cowork만 쓰던 분이 Stage 2–13 자동화를 도입하고 싶을 때.
- **전제:** Claude Max 플랜. tmux 설치. `claude --teammate-mode` 동작 확인.
- **커맨드:**
  ```sh
  # workflow_mode만 수정 (team_mode/stage_assignments는 그대로):
  # 현재 switch_team.sh는 team_mode 전환 전용 — workflow_mode 변경은 수동:
  #   .claude/settings.json 의 "workflow_mode": "desktop-only" → "desktop-cli"
  # 또는 init_project.sh --force-reinit 으로 대화 재진입.
  bash scripts/init_project.sh --force-reinit
  ```
- **효과:** Stage 1만 Cowork에서 진행. Stage 2–13은 `ai_step.sh`로 자동 실행. team_mode/stage_assignments 라인은 변동 없음.

### 2.2 `desktop-cli` → `cli-only` (Cowork 졸업)

- **대상:** 터미널 기반 운영으로 완전 전환.
- **전제:** `claude` 대화형 REPL 숙달. Stage 1 브레인스토밍을 REPL에서 진행할 의사.
- **커맨드:**
  ```sh
  # 위 2.1과 동일한 방식 (workflow_mode 라인 수정 또는 --force-reinit).
  bash scripts/init_project.sh --force-reinit
  ```
- **효과:** Stage 1 포함 전 단계가 CLI에서 진행. R2 비용 영향 없음 (모델은 Stage별 settings.json `agents.*` 따름).

### 2.3 `claude-only` → `claude-impl-codex-review` (Codex 리뷰 도입)

- **대상:** 구현은 Claude로 가져가되 Stage 9 리뷰 품질을 Codex 5.5로 끌어올리고 싶을 때.
- **전제:** ChatGPT 유료 구독 또는 OpenAI API 키. `codex-plugin-cc` 설치 (Claude Code plugin-cc 채널).
- **커맨드:**
  ```sh
  bash scripts/switch_team.sh claude-impl-codex-review
  ```
- **효과:** `stage_assignments.stage9_review`: `claude` → `codex` (자동). `stage8_impl` / `stage10_fix` / `stage11_verify`는 `claude` 유지. `ai_step.sh`가 Stage 9 진입 시 `/codex:review`로 디스패치.

### 2.4 `codex-impl-claude-review` → `claude-only` (Codex 의존 제거)

- **대상:** OpenAI 구독 해지 / 단일 도구 운영으로 단순화.
- **전제:** 없음 (외부 의존이 사라지는 방향이라 추가 셋업 불필요).
- **커맨드:**
  ```sh
  bash scripts/switch_team.sh claude-only
  ```
- **효과:** `stage_assignments.stage8_impl` + `stage10_fix`: `codex` → `claude` (자동). 모든 stage가 Claude 단일 디스패치. `ai_step.sh`는 `claude --teammate-mode tmux` 경로만 사용.

---

## 3. 자주 있는 오류

### 3.1 "팀 구성을 변경할 수 없습니다" 메시지 (exit 1)

- **원인:** 백그라운드에 `claude --teammate-mode` 또는 `codex-plugin-cc` 프로세스가 진행 중.
- **해결:**
  1. `bash scripts/switch_team.sh --status` 로 감지된 PID 확인.
  2. `/codex:status` (Codex 세션 내) 또는 해당 tmux 페인에서 작업 종료 대기.
  3. 다시 `bash scripts/switch_team.sh <mode>` 실행.
- **긴급 우회:** `bash scripts/switch_team.sh <mode> --force` (운영자 책임. 진행 중 작업 부작용 감수).

### 3.2 "schema v0.4 필요" 메시지 (exit 3)

- **원인:** 기존 `.claude/settings.json`이 v0.3 schema.
- **해결:** `bash scripts/init_project.sh --force-reinit` (신규 v0.6 필드 삽입, v0.3 필드 100% 보존).

### 3.3 "settings.json 없음" 메시지 (exit 4)

- **원인:** `.claude/settings.json` 파일 자체 부재.
- **해결:** `bash scripts/init_project.sh` 최초 1회 실행.

### 3.4 "알 수 없는 인자" / "알 수 없는 team_mode" 메시지 (exit 2)

- **원인:** 허용 리터럴 외 입력. 허용: `claude-only`, `claude-impl-codex-review`, `codex-impl-claude-review`.
- **해결:** 위 3종 중 하나 사용. 대화 모드(`bash scripts/switch_team.sh`)에서 1/2/3 선택도 가능.

---

## 4. 역할별 권한표

| 도구 | 필요 구독/인증 | 영향 team_mode |
|------|---------------|---------------|
| `claude --teammate-mode` | Claude Max 플랜 이상 | 모든 team_mode (전제) |
| `/codex:review` (plugin-cc) | ChatGPT 유료 또는 OpenAI API | `claude-impl-codex-review` |
| `/codex:rescue` (plugin-cc) | ChatGPT 유료 또는 OpenAI API | `codex-impl-claude-review` |
| (외부 도구 없음) | 기본 운영 가능 | `claude-only` |

`@openai/codex` CLI는 v0.6 본 릴리스에서 호출 경로 없음 (수동 보조 전용, F-n3).

---

## 5. 관련 스크립트

- `bash scripts/init_project.sh` — 최초 1회 또는 `--force-reinit`로 재대화.
- `bash scripts/switch_team.sh` — 대화 모드 (현재 team_mode + brainstorm Sec.4 [2/2] verbatim 재사용).
- `bash scripts/switch_team.sh <mode>` — 직접 지정.
- `bash scripts/switch_team.sh <mode> --force` — 백그라운드 체크 우회.
- `bash scripts/switch_team.sh --status` — 현재 settings 조회 + bg 프로세스 점검.
- `bash scripts/ai_step.sh <stage>` — Stage 실행 (M4에서 도입 예정, 현재는 v0.5 단일 stage 모드).

---

## 6. 본 가이드가 답하지 않는 것

- `stage_assignments` 개별 셀의 직접 수정 — `switch_team.sh`가 `team_mode` 기반으로 4개 셀을 자동 재설정 (Sec.2.5 매핑). 수동 수정은 비권장 (일관성 깨짐, Stage 9 리뷰 차단 사유).
- v0.6.1 Hooks PostToolUse / gstack ETHOS — v0.6 본 릴리스 대상 외, v0.6.1 이월 [F-D1].
- `@openai/codex` CLI 자동화 — 비목표 [F-n3]. 수동 보조 세션에서만 운영자가 별도 사용.
- 자동 마이그레이션 도구 — 비제공. `init_project.sh --force-reinit`로 충분.
