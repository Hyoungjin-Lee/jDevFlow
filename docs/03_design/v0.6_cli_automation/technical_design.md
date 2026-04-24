---
version: v0.6
stage: 5 (technical_design)
date: 2026-04-25
mode: Standard
session: 15
upstream:
  - docs/01_brainstorm_v0.6/brainstorm.md (Stage 1, 세션 13)
  - docs/02_planning_v0.6/plan_final.md (Stage 4, 세션 14, 운영자 승인 완료)
constraints_absorbed:
  - F-D3 (pending_team_mode 필드 미포함)
  - F-D2 (jq 비의존, 1줄 1키 POSIX 파싱)
  - F-n1 (init 2/2 ★추천★ verbatim)
  - F-n2 (switch 차단 메시지 verbatim)
  - F-2-a (team_mode 실행 분기 금지, stage_assignments만 파싱)
  - F-5-a (v0.3 하위 호환 판단 책임 = Stage 9)
  - F-D1 (D6/D7 v0.6.1 이월)
  - F-n3 (@openai/codex CLI 오케스트레이터 비호출)
downstream: Stage 8 구현 (D1→D2→D3→D4→D5 단일 trail)
---

# jDevFlow v0.6 — CLI 자동화 레이어 기술 설계 (technical_design)

> **상위:** `docs/02_planning_v0.6/plan_final.md` (운영자 승인 완료)
> **하위:** Stage 8 구현. Codex/Claude 서브에이전트가 본 문서만 읽고 구현 가능해야 함.
> **범위:** D1 settings.json schema v0.4 / D2 init_project.sh / D3 switch_team.sh / D4 switching.md / D5 ai_step.sh 오케스트레이터. **D6/D7은 v0.6.1 이월 [F-D1]**.

---

## Sec. 0. 설계 원칙 (v0.6 3축)

plan_final G5 안전 기본값 3축을 전 컴포넌트에 일관 적용:

| 축 | 의미 | 본 설계에서의 구현 |
|----|------|-------------------|
| POSIX 파싱 | `jq` 미설치 환경에서도 동작. `grep`/`sed`/`awk`로만 settings.json 읽기/쓰기 | D1 스키마의 신규 필드는 "2-space 들여쓰기 + 1줄 1키 + 파일 내 유일 키명" 제약을 지킨다. 쓰기는 temp file → atomic `mv`. |
| claude-only 기본값 | OpenAI 구독 없는 신규 도입자가 첫 실행에서 차단되지 않음 | D2 `[2/2]` 기본값 `team_mode=3 (claude-only)`. D5 기본 `stage_assignments` 테이블이 claude-only 기준으로 fully populated. |
| fail-closed | 알 수 없는 executor / 파싱 실패 / 백그라운드 충돌 시 침묵 진행 금지. 정지 후 운영자 호출 | D3 백그라운드 발견 시 exit 1 (운영자가 `--force` 명시해야 우회). D5 unknown executor → exit 2 + 진단 메시지. |

**리스크 핵심 제약 (R2 mitigation, F-2-a commit):** `ai_step.sh`의 **실행 결정 분기는 `stage_assignments`만 읽는다.** `team_mode` 리터럴은 **표시 경로(로그 헤더 · switch 상태 출력 · 에러 메시지)에서만** 참조. 리터럴로 `if` 분기 금지. 이는 Stage 5 설계 제약이며 Stage 9 리뷰의 판정 기준이다.

---

## Sec. 1. 아키텍처 오버뷰

```
┌──────────────────────────────────────────────────────────────────┐
│  운영자 수동 개입 2지점: (a) Stage 1 대화 · (b) git 푸시         │
└──────────────────────────────────────────────────────────────────┘
          │                                            │
          ▼                                            ▼
  ┌──────────────┐   [1회성]             ┌────────────────────────┐
  │ init_project │──────────────┐        │ git_checkpoint.sh (기존)│
  │     .sh (D2) │              │        └────────────────────────┘
  └──────────────┘              │
          │                     ▼
          │           ┌───────────────────┐
          │           │ settings.json v0.4 │◀─ POSIX read/write (jq X)
          │           │      (D1)          │
          │           └───────────────────┘
          │                     ▲
          ▼                     │
  ┌──────────────┐   [런타임]   │        ┌─────────────────────────┐
  │ switch_team  │──────────────┤        │ docs/guides/switching.md│
  │     .sh (D3) │              │        │          (D4)           │
  └──────────────┘              │        └─────────────────────────┘
                                │                  ▲
                                │                  │
                                ▼                  │ 포인터
                       ┌────────────────┐          │
                       │  ai_step.sh    │──────────┘
                       │ 오케스트레이터│
                       │     (D5)       │
                       └────────────────┘
                                │
           ┌────────────────────┼─────────────────────┐
           ▼                    ▼                     ▼
    claude --teammate   /codex:rescue         /codex:review
     -mode tmux         (plugin-cc)           (plugin-cc)
     [Stage 8 impl]     [Stage 8 impl]        [Stage 9 review]
                        (※ @openai/codex CLI 비호출 [F-n3])
```

**컴포넌트 관계:**
- D1은 **소비자 조건 선결 산출물**. D2/D3/D5 모두 D1 스키마를 읽는다.
- D2는 D1 초기 기록자. D3은 D1 런타임 수정자. 둘 다 쓰기(writer).
- D5는 D1 read-only 소비자. `workflow_mode`는 무시(표시용 아님), `team_mode`는 표시 경로에서만 사용, **`stage_assignments`만 실행 분기**.
- D4는 D2/D3 사용 시점의 참조 문서. 실행 코드 없음.

---

## Sec. 2. D1 — settings.json schema v0.4

### 2.1 설계 목표
1. 기존 v0.3 필드 100% 보존 (`schema_version`만 0.3 → 0.4 bump).
2. 신규 필드(`workflow_mode`, `team_mode`, `stage_assignments`)를 POSIX 파싱 가능한 레이아웃으로 배치.
3. `pending_team_mode` 필드 **미포함** [F-D3]. switch 2분기 모델만 유지.

### 2.2 최종 스키마

```json
{
  "_comment": "AI Workflow settings — schema v0.4 (v0.6 CLI automation layer).",
  "_comment_v04_fields": "workflow_mode + team_mode + stage_assignments는 POSIX grep/sed/awk로만 파싱된다. 각 키는 2-space 들여쓰기, 파일 내 유일, 1줄 1키. 수정 시 이 규약 깨지 말 것.",
  "_comment_model_policy": "Max x5 요금제 기준. Stage 1=Sonnet, Stage 2–4=Opus, Stage 5=Opus, Stage 9/11=Opus, 나머지=Sonnet.",
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-only",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "claude",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko",
  "teammateMode": "tmux",
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "agents": {
    "planner":      { "stages": [2, 3, 4],  "models": { "stage_2": "claude-opus-4-7", "stage_3": "claude-opus-4-7", "stage_4": "claude-opus-4-7" }, "effort": { "stage_2": "medium", "stage_3": "high", "stage_4": "medium" } },
    "designer":     { "stages": [5, 6, 7],  "models": { "stage_5": "claude-opus-4-7", "stage_6": "claude-sonnet-4-6", "stage_7": "claude-sonnet-4-6" }, "effort": { "stage_5": "high", "stage_6": "medium", "stage_7": "medium" } },
    "reviewer":     { "stages": [9, 11],    "models": { "stage_9": "claude-opus-4-7", "stage_11": "claude-opus-4-7" }, "effort": { "stage_9": "high", "stage_11": "xhigh" } },
    "qa_engineer":  { "stages": [12, 13],   "models": { "stage_12": "claude-sonnet-4-6", "stage_13": "claude-sonnet-4-6" }, "effort": { "stage_12": "medium", "stage_13": "medium" } }
  }
}
```

### 2.3 POSIX 파싱 규약 (Stage 8 준수 의무)

**쓰기 포맷 규칙 (scripts가 settings.json을 emit 할 때):**
1. 신규 v0.4 필드(`workflow_mode`, `team_mode`, `stage_assignments` 및 그 자식 4개 키)는 **2-space 들여쓰기로 top-level 또는 1-level nested 위치**에 배치.
2. 한 줄에 **하나의 키:값 쌍**만. 예: `  "workflow_mode": "desktop-cli",`
3. 값은 **따옴표로 둘러싸인 plain 문자열** (escape 문자, 개행, 따옴표 포함 금지).
4. 키 이름은 **파일 전체에서 유일** — `grep '"workflow_mode"'`가 정확히 1개 hit 반환해야 함.
5. `stage_assignments`의 자식 키는 `stage8_impl` / `stage9_review` / `stage10_fix` / `stage11_verify` 4개 고정. 순서 고정(변경 금지).
6. 기존 `agents` 섹션은 단일 라인 per agent 형태로 유지(현행) — v0.6 스크립트는 이 섹션을 **읽지도 쓰지도 않음**. 건드리지 않는다.

**읽기 규약 (scripts가 값 추출할 때):**
```sh
# workflow_mode 읽기
workflow_mode=$(sed -n 's/^  "workflow_mode": *"\([^"]*\)".*/\1/p' "$SETTINGS")

# team_mode 읽기
team_mode=$(sed -n 's/^  "team_mode": *"\([^"]*\)".*/\1/p' "$SETTINGS")

# stage_assignments.stage8_impl 읽기 (4-space 들여쓰기)
stage8_impl=$(sed -n 's/^    "stage8_impl": *"\([^"]*\)".*/\1/p' "$SETTINGS")
```

**쓰기 규약 (atomic replace):**
```sh
TMP="$(mktemp)"
sed 's|^  "team_mode": *"[^"]*",|  "team_mode": "'"$NEW_MODE"'",|' "$SETTINGS" > "$TMP"
mv "$TMP" "$SETTINGS"
```
- temp file → `mv`로 atomic 교체. 실패 시 원본 보존.
- `sed` in-place (`-i`) **금지** (macOS/BSD 문법 상이 회피).

### 2.4 허용/비허용 값

| 필드 | 허용 값 | 기본값 (init) |
|------|--------|--------------|
| `workflow_mode` | `desktop-only` \| `desktop-cli` \| `cli-only` | `desktop-only` |
| `team_mode` | `claude-only` \| `claude-impl-codex-review` \| `codex-impl-claude-review` | `claude-only` |
| `stage_assignments.stage8_impl` | `claude` \| `codex` | `claude` |
| `stage_assignments.stage9_review` | `claude` \| `codex` | `claude` |
| `stage_assignments.stage10_fix` | `claude` \| `codex` | `claude` |
| `stage_assignments.stage11_verify` | `claude` | `claude` |

> Stage 11 검증은 plan_final·brainstorm Sec.3 모두 Claude Opus 고정 — 유일 허용 값 `claude`.

### 2.5 team_mode ↔ stage_assignments 매핑표 (D2/D3가 기록할 값)

```
team_mode = claude-only:
  stage8_impl  = claude
  stage9_review = claude
  stage10_fix  = claude
  stage11_verify = claude

team_mode = claude-impl-codex-review:
  stage8_impl  = claude
  stage9_review = codex
  stage10_fix  = claude
  stage11_verify = claude

team_mode = codex-impl-claude-review:
  stage8_impl  = codex
  stage9_review = claude
  stage10_fix  = codex
  stage11_verify = claude
```

D2/D3가 team_mode를 쓸 때 **반드시** 위 테이블 기준으로 `stage_assignments`도 함께 갱신. 불일치 상태 생성 금지.

### 2.6 하위 호환성 (F-5-a)

- v0.3 필드는 `schema_version: "0.3"` → `"0.4"` bump 외 건드리지 않음.
- 기존 v0.3 settings.json을 v0.4 스크립트가 읽으면: 신규 필드 누락 탐지 → D2 init 재실행 안내 메시지 + exit 3.
- 자동 마이그레이션 도구 **만들지 않음** (plan_final Sec.2 Non-goal).
- **호환성 판정 책임: Stage 9 코드 리뷰** — v0.3 샘플 파일이 신규 스크립트에서 정상 처리되는지 테스트.

---

## Sec. 3. D2 — scripts/init_project.sh

### 3.1 책임
- 기존(v0.5): 프로젝트 폴더 뼈대 생성 + starter docs 초기화 → **유지**.
- 신규(v0.6): 기존 로직 종료 이후, 운영방식/team_mode 대화 실행 → `.claude/settings.json`에 `workflow_mode` + `team_mode` + `stage_assignments` 기록.

### 3.2 호출 인터페이스
```
bash scripts/init_project.sh            # 기본. 기존 폴더 생성 + 신규 대화.
bash scripts/init_project.sh --with-env # v0.5 유지.
bash scripts/init_project.sh --no-prompt # 비대화 모드. 기본값만 기록. CI/자동화용.
```

### 3.3 데이터 플로우
```
1. 기존 로직 (폴더 생성 + dev_history.md / decisions.md starter) — 변경 없음.
2. 신규: .claude/settings.json 존재 여부 확인.
   - 없음: 스켈레톤 emit (heredoc 템플릿, 기본값으로).
   - 있음 v0.3: "v0.3 감지, v0.4로 업그레이드합니다" + v0.4 재emit (기존 v0.3 필드 보존).
   - 있음 v0.4: "이미 v0.4로 초기화됨. --force-reinit 없으면 대화 생략."
3. 대화 [1/2] workflow_mode (brainstorm Sec.4 verbatim).
4. 대화 [2/2] team_mode (brainstorm Sec.4 verbatim, ★추천★ 마커 보존 [F-n1]).
5. team_mode → stage_assignments 매핑 (Sec 2.5 테이블).
6. POSIX atomic write (temp file → mv).
7. 완료 메시지: "settings.json 업데이트 완료. 패턴 전환 안내: docs/guides/switching.md"
```

### 3.4 대화 스크립트 (brainstorm Sec.4 verbatim, F-n1)

**`[1/2]` 블록 — brainstorm.md L58–77 원문:**
```
=== jDevFlow 프로젝트 초기화 ===

[1/2] 운영 방식을 선택하세요:

  1) 데스크탑 only
     - Cowork 앱에서 Claude와 대화하며 전 단계 진행
     - 터미널 명령어를 중간중간 수동으로 실행
     → 추천: 터미널이 낯선 분 / 처음 jDevFlow를 쓰는 분

  2) 데스크탑 + CLI
     - Stage 1 소통은 Cowork, Stage 2–13은 CLI 오케스트레이터 자동 처리
     - 터미널 개입 최소화
     → 추천: Cowork 익숙 + CLI도 병행하고 싶은 분

  3) CLI only
     - 전 단계를 터미널에서 진행 (claude 대화형 REPL 포함)
     - 가장 높은 자동화 수준
     → 추천: 터미널 주 사용자 / Cowork 없이 운영하고 싶은 분

선택 (1/2/3, 기본값 1):
```

**`[2/2]` 블록 — brainstorm.md L81–101 원문 (★추천★ 마커 **반드시** 보존):**
```

[2/2] 에이전트 팀 구성을 선택하세요:

  1) Claude 구현 + Codex 리뷰  ★추천★
     - 구현: claude --teammate-mode
     - 리뷰: /codex:review (Codex 5.5 리뷰 능력 활용)
     - 검증: Claude Opus
     → 추천: Codex 리뷰 품질을 원하지만 구현은 Claude가 익숙한 분

  2) Codex 구현 + Claude 리뷰
     - 구현: /codex:rescue
     - 리뷰: Claude Opus 서브에이전트
     - 수정보완: /codex:rescue
     - 검증: Claude Opus

  3) Claude 전담  (기본값)
     - 구현/리뷰/검증 모두 Claude
     - OpenAI 구독 불필요
     → 추천: OpenAI 미사용자 / 단일 도구로 심플하게

선택 (1/2/3, 기본값 3):
```

**입력 검증:**
- 빈 입력 → 기본값 (1/2는 기본 1, 2/2는 기본 3).
- `1|2|3` 외 → "잘못된 선택입니다. 1, 2, 3 중 선택." + 재질의 (최대 3회 후 abort).
- `read -r` 사용. `$PS3` 셀렉트 구문 미사용 (포맷 보존 목적).

### 3.5 settings.json 쓰기 전략 (jq 비의존)

**Case A: settings.json 부재 — heredoc 템플릿으로 전체 생성**
```sh
cat > "$SETTINGS" <<EOF
{
  "_comment": "AI Workflow settings — schema v0.4 (v0.6 CLI automation layer).",
  "_comment_v04_fields": "workflow_mode + team_mode + stage_assignments는 POSIX로 파싱된다. 2-space 들여쓰기 / 1줄 1키 / 파일 내 유일 키명 규약을 깨지 말 것.",
  "_comment_model_policy": "Max x5 요금제 기준.",
  "schema_version": "0.4",
  "workflow_mode": "${WORKFLOW_MODE}",
  "team_mode": "${TEAM_MODE}",
  "stage_assignments": {
    "stage8_impl": "${STAGE8}",
    "stage9_review": "${STAGE9}",
    "stage10_fix": "${STAGE10}",
    "stage11_verify": "claude"
  },
  "language": "ko",
  "teammateMode": "tmux",
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "agents": {}
}
EOF
```
> `agents: {}`는 의도적 빈 객체 — 에이전트 팀 모델 배정은 운영자가 v0.5 settings.json 샘플에서 복사하거나 별도 프로비저닝. init은 **v0.6 신규 필드만** 책임.

**Case B: settings.json 이미 v0.3 — 업그레이드 (신규 필드 삽입)**
```sh
# schema_version 라인 교체
sed 's|"schema_version": *"0.3"|"schema_version": "0.4"|' "$SETTINGS" > "$TMP"
# 신규 필드를 schema_version 바로 아래에 삽입 (awk)
awk -v wm="$WORKFLOW_MODE" -v tm="$TEAM_MODE" \
    -v s8="$STAGE8" -v s9="$STAGE9" -v s10="$STAGE10" '
  /"schema_version": "0.4",/ {
    print
    print "  \"workflow_mode\": \"" wm "\","
    print "  \"team_mode\": \"" tm "\","
    print "  \"stage_assignments\": {"
    print "    \"stage8_impl\": \"" s8 "\","
    print "    \"stage9_review\": \"" s9 "\","
    print "    \"stage10_fix\": \"" s10 "\","
    print "    \"stage11_verify\": \"claude\""
    print "  },"
    next
  }
  { print }
' "$TMP" > "$TMP2"
mv "$TMP2" "$SETTINGS"
rm -f "$TMP"
```

**Case C: settings.json 이미 v0.4 — `--force-reinit` 없으면 대화 skip + 현재 값 출력.**

### 3.6 완료 메시지 (verbatim)
```
✅ settings.json 업데이트 완료.

  workflow_mode: <선택값>
  team_mode:    <선택값>

패턴/팀 구성을 나중에 바꾸려면:
  bash scripts/switch_team.sh
  → docs/guides/switching.md 참조
```

---

## Sec. 4. D3 — scripts/switch_team.sh

### 4.1 책임
런타임에 `team_mode`를 변경. 백그라운드 claude/codex 프로세스 활성 시 **차단**. 아니면 즉시 반영 + `stage_assignments` 동기 갱신.

### 4.2 호출 인터페이스
```
bash scripts/switch_team.sh                      # 대화 모드 (brainstorm Sec.4 [2/2] verbatim 재사용)
bash scripts/switch_team.sh <mode>               # 직접 지정. mode ∈ {claude-only, claude-impl-codex-review, codex-impl-claude-review}
bash scripts/switch_team.sh <mode> --force       # 백그라운드 체크 우회 (운영자 책임)
bash scripts/switch_team.sh --status             # 현재 team_mode + stage_assignments + bg 프로세스 현황만 출력
```

### 4.3 2분기 모델 (F-D3)

```
     백그라운드 claude/codex 프로세스 존재?
                  │
       ┌──────────┴──────────┐
       │ 예                   │ 아니오
       ▼                      ▼
  exit 1 (차단 메시지)    settings.json 즉시 갱신
  verbatim Sec.5          (team_mode + 4개 stage_assignments)
  [--force 시 우회]       완료 메시지
```

**`pending_team_mode` 관련 상태/전이 **전부 제거** [F-D3].** 차단 시 운영자가 작업 완료 기다린 뒤 switch_team.sh 재실행.

### 4.4 백그라운드 감지 (Q2 답)

**선택: `pgrep -fl` (macOS 기본 탑재, 플랫폼 단일).**

| 후보 | 장점 | 단점 | 선택 |
|------|------|------|------|
| `pgrep -fl` | macOS 기본, 커맨드라인 매칭, PID+cmd 출력 | 무관 claude 세션도 hit | **O** |
| `ps aux \| grep` | 범용 | `grep` 자기자신 필터 필요, 포맷 노이즈 | X |
| `/codex:status` | Codex 권위 있음 | claude 프로세스 미감지, 플러그인 세션 의존 | X |

**탐지 패턴 (GNU grep -E 호환):**
```sh
CLAUDE_PIDS=$(pgrep -fl 'claude.*--teammate-mode' | grep -v "$$" || true)
CODEX_PIDS=$(pgrep -fl '(codex-plugin-cc|/codex:(rescue|review|status))' | grep -v "$$" || true)
```
- 자기 자신(`$$`) 필터링.
- `claude --teammate-mode` 패턴은 v0.3 WORKFLOW.md에서 확정된 launcher 인자.
- Codex는 plugin-cc 경로만 (`@openai/codex` CLI는 대상 외 [F-n3]).

**False positive 대응 (R3 완화):** 발견 시 PID+cmd 출력 → 운영자가 무관 세션임을 확신하면 `--force`.

### 4.5 차단 메시지 (brainstorm Sec.5 verbatim, F-n2)

**brainstorm.md L116–125 원문 그대로 출력 (개행/공백 1:1 보존):**
```
⚠️  팀 구성을 변경할 수 없습니다.

현재 구현 또는 검증 작업이 백그라운드에서 진행 중입니다.
작업이 완료된 후 다음 구현 시작 전에 변경해 주세요.

진행 상태 확인: /codex:status
```
+ 보조 한 줄 (verbatim 아래에):
```
감지된 프로세스:
  PID  <pid>  <command>
  ...
우회: --force (운영자 책임. 진행 중 작업 부작용 감수)
```
exit code **1**.

### 4.6 데이터 플로우 (정상 전환)
```
1. 인자 파싱 → 목표 team_mode 결정 (대화 or 직접).
2. 유효성 검증: 3종 리터럴 중 하나인가?
3. 백그라운드 감지 (4.4). --force 아니면 발견 시 차단 메시지 + exit 1.
4. Sec 2.5 매핑표로 stage_assignments 4개 값 계산.
5. settings.json 읽기 → team_mode + stage_assignments.* 5개 라인 교체.
6. atomic write (temp → mv).
7. 완료 메시지: 이전 team_mode → 신규 team_mode + stage_assignments 변경 요약.
```

**교체 전략 (sed 5회 호출 시퀀셜):**
```sh
TMP="$(mktemp)"
cp "$SETTINGS" "$TMP"
sed -i.bak 's|^  "team_mode": *"[^"]*",|  "team_mode": "'"$NEW_MODE"'",|' "$TMP" 2>/dev/null \
  || sed "s|^  \"team_mode\": *\"[^\"]*\",|  \"team_mode\": \"$NEW_MODE\",|" "$TMP" > "$TMP.next" && mv "$TMP.next" "$TMP"
# stage 4개 동일 패턴 반복
...
mv "$TMP" "$SETTINGS"
```
> macOS BSD sed는 `-i ''`, GNU sed는 `-i` — 호환성 이슈 회피 위해 **temp file → mv 패턴 통일** (sed in-place 미사용).

### 4.7 오류 처리

| 상황 | 동작 | exit code |
|------|------|-----------|
| settings.json 부재 | "init_project.sh 먼저 실행" + abort | 4 |
| schema_version ≠ 0.4 | "schema v0.4 필요. init --force-reinit 권장" + abort | 3 |
| team_mode 파싱 실패 | "settings.json 포맷 손상" + 라인 번호 | 5 |
| 잘못된 인자 | usage 출력 | 2 |
| 백그라운드 발견 + --force 없음 | verbatim 차단 메시지 | 1 |
| 정상 | 완료 메시지 | 0 |

### 4.8 `--status` 모드 (표시 경로에서만 team_mode 리터럴 사용, F-2-a 예외)
```
현재 운영 상태:
  workflow_mode: desktop-cli
  team_mode:    claude-only            ← ★표시 경로 예외★
  stage_assignments:
    stage8_impl:   claude
    stage9_review: claude
    stage10_fix:   claude
    stage11_verify: claude
  백그라운드 claude/codex: 없음
```

---

## Sec. 5. D4 — docs/guides/switching.md

### 5.1 책임
운영자가 프로젝트 도중에 `workflow_mode` 또는 `team_mode`를 바꿀 때 참조하는 단일 가이드. 코드 아님 — **문서 산출물**.

### 5.2 문서 구조 (Stage 8 구현자 작성 시 이 섹션 골격 그대로 사용)

```
# 패턴/팀 구성 전환 가이드

> init_project.sh 이후 운영 패턴(workflow_mode) 또는 팀 구성(team_mode)을 바꿀 때 읽는 문서.

## 1. 전환 전 체크리스트
  - 현재 백그라운드 claude/codex 작업 없는가? (bash scripts/switch_team.sh --status)
  - 현재 stage 경계인가? (stage 중간 전환 → plan_final Sec.5 R2 위반 위험)
  - 필요한 외부 구독(Claude Max, ChatGPT 유료/OpenAI API)이 준비됐는가?

## 2. 시나리오 4종

### 2.1 desktop-only → desktop-cli (CLI 자동화 도입)
  대상: Cowork만 쓰던 분이 Stage 2–13 자동화 원할 때.
  전제: Claude Max 플랜.
  커맨드:
    # workflow_mode만 수정 (team_mode는 그대로):
    # (수동 편집: .claude/settings.json "workflow_mode": "desktop-cli")
  주의: Stage 1은 여전히 Cowork로 진행. ai_step.sh는 Stage 2부터 사용.

### 2.2 desktop-cli → cli-only (Cowork 졸업)
  대상: 터미널 기반 운영으로 완전 전환.
  전제: `claude` 대화형 REPL 숙달.
  커맨드:
    # workflow_mode 수정 (team_mode 그대로):
  주의: Stage 1 브레인스토밍을 claude REPL에서 진행하게 됨. R2 비용 영향 없음.

### 2.3 claude-only → claude-impl-codex-review (Codex 리뷰 도입)
  대상: Codex 5.5 리뷰 능력 활용.
  전제: ChatGPT 유료 구독 or OpenAI API 키, codex-plugin-cc 설치.
  커맨드:
    bash scripts/switch_team.sh claude-impl-codex-review
  효과: stage_assignments.stage9_review: claude → codex (자동).

### 2.4 codex-impl-claude-review → claude-only (Codex 의존 제거)
  대상: OpenAI 구독 해지 / 단일 도구 운영.
  전제: 없음.
  커맨드:
    bash scripts/switch_team.sh claude-only
  효과: stage_assignments.stage8_impl/stage10_fix: codex → claude (자동).

## 3. 자주 있는 오류

### 3.1 "팀 구성을 변경할 수 없습니다" 메시지
  원인: 백그라운드 claude/codex 작업 진행 중.
  해결: /codex:status 또는 해당 세션 종료 대기.
  긴급 우회: bash scripts/switch_team.sh <mode> --force (운영자 책임).

### 3.2 "schema v0.4 필요" 메시지
  원인: 기존 v0.3 settings.json.
  해결: bash scripts/init_project.sh --force-reinit (신규 필드 추가, v0.3 보존).

## 4. 역할별 권한표

| 도구 | 필요 구독/인증 | 영향 team_mode |
|------|---------------|---------------|
| claude --teammate-mode | Claude Max 플랜 이상 | 모든 team_mode (전제) |
| /codex:review (plugin-cc) | ChatGPT 유료 or OpenAI API | claude-impl-codex-review |
| /codex:rescue (plugin-cc) | ChatGPT 유료 or OpenAI API | codex-impl-claude-review |
| (없음) | 기본 운영 가능 | claude-only |

## 5. 관련 스크립트
  - bash scripts/init_project.sh            (최초 1회 or --force-reinit)
  - bash scripts/switch_team.sh              (대화 모드)
  - bash scripts/switch_team.sh --status     (현재 설정 조회)
  - bash scripts/ai_step.sh <stage>          (Stage 실행)

## 6. 본 가이드가 답하지 않는 것
  - stage_assignments 개별 셀 직접 수정 → switch_team.sh가 team_mode 기반 자동 재설정. 수동 수정 비권장 (Sec.2.5 일관성 깨짐).
  - v0.6.1 Hooks/ETHOS → 본 릴리스 대상 외.
```

### 5.3 시나리오 선정 근거

plan_final Goal G4 "시나리오 ≥4종" 충족. 4종은 brainstorm 드롭 항목 제외 후 실전 빈발 케이스 순:
1. workflow_mode 확장 (1 → 2).
2. workflow_mode 완성 (2 → 3).
3. team_mode 확장 (1 → 2).
4. team_mode 축소 (2/3 → 1).

---

## Sec. 6. D5 — scripts/ai_step.sh 오케스트레이터

### 6.1 책임
v0.5까지는 "Stage 프롬프트 출력기"였음. v0.6에서 **Stage 2–13 자동 진행 오케스트레이터**로 전면 재작성.

### 6.2 호출 인터페이스 (기존 유지 + 확장)
```
bash scripts/ai_step.sh <stage>          # 단일 stage 실행 (기존 유지)
bash scripts/ai_step.sh --auto           # 현재 stage부터 다음 승인 게이트까지 자동 진행
bash scripts/ai_step.sh --next           # 다음 stage 1개만 실행
bash scripts/ai_step.sh --status         # 현재 stage + 다음 executor 예정 출력
```

### 6.3 핵심 설계 제약 (F-2-a commit)

> **실행 결정 분기는 `stage_assignments`만 읽는다. `team_mode` 리터럴 비참조.**
> `team_mode` 리터럴은 **로그 헤더 / status 출력 / 에러 메시지 본문**에서만 참조 허용 (표시 경로).
> `if [ "$team_mode" = "claude-only" ]; then ... fi` 와 같은 **실행 분기 코드 금지.**
> 위반 시 Stage 9 리뷰 차단 사유.

### 6.4 Stage → executor 결정 로직

```sh
resolve_executor() {
  local stage="$1"  # 'stage8_impl', 'stage9_review', ...
  local executor
  executor=$(sed -n "s/^    \"${stage}\": *\"\\([^\"]*\\)\".*/\\1/p" "$SETTINGS")
  case "$executor" in
    claude|codex) echo "$executor" ;;
    '')  die 3 "stage_assignments.${stage} 키 누락. init_project.sh --force-reinit 실행." ;;
    *)   die 2 "알 수 없는 executor: '${executor}' (stage_assignments.${stage}). 허용: claude|codex." ;;
  esac
}
```
- fail-closed (Q3 답). 미정 값 또는 오타 → exit 2, 진단 메시지 + 설정 경로 안내.

### 6.5 Stage 완료 signal 명세 (R1 완화)

**3종 signal AND 전체 충족 시에만 다음 stage 진입.**

| Stage | Signal 1: Artifact 존재 | Signal 2: Executor exit | Signal 3: Grep 키워드 (artifact 내) |
|-------|------------------------|------------------------|-------------------------------------|
| 1 브레인스토밍 | `docs/01_brainstorm*/brainstorm.md` | 0 | (skip — 운영자 참여, ai_step 대상 외) |
| 2 plan_draft | `docs/02_planning*/plan_draft.md` | 0 | `^# .+(plan_draft\|Plan Draft)` |
| 3 plan_review | `docs/02_planning*/plan_review.md` | 0 | `^# .+(plan_review\|Plan Review)` |
| 4 plan_final | `docs/02_planning*/plan_final.md` | 0 | `status: (pending_operator_approval\|approved)` |
| 4.5 승인 게이트 | (운영자 수동) | 0 | plan_final `status: approved` |
| 5 technical_design | `docs/03_design*/technical_design.md` | 0 | `^## Sec\. 1\. 아키텍처` or `## Architecture` |
| 6 ui_requirements | `docs/03_design*/ui_requirements.md` | 0 | (has_ui=true일 때만) |
| 7 ui_flow | `docs/03_design*/ui_flow.md` | 0 | (has_ui=true일 때만) |
| 8 implementation | `docs/04_implementation*/implementation.md` or src 변경 | 0 | `Status:.*(completed\|done\|green)` |
| 9 code_review | `docs/04_implementation*/code_review.md` | 0 | `(APPROVED\|BLOCK\|NEEDS_REVISION)` 중 APPROVED |
| 10 revise | git diff non-empty or `revise.md` | 0 | `Status:.*completed` |
| 11 final_review | `docs/05_qa_release*/final_review.md` | 0 | `Verdict:.*PASS` |
| 12 qa | `docs/05_qa_release*/qa.md` | 0 | `QA:.*PASS` |
| 13 release | `CHANGELOG.md` 신규 [x.y.z] 엔트리 | 0 | `^## \[\d+\.\d+\.\d+\]` |

**AND 규칙 구현:**
```sh
check_stage_complete() {
  local stage_key="$1"  # 'stage2', 'stage4', ...
  [ -f "${ARTIFACT_PATH}" ] || return 1
  [ "${LAST_EXIT}" = "0" ] || return 2
  grep -qE "${KEYWORD_PATTERN}" "${ARTIFACT_PATH}" || return 3
  return 0
}
```

**unknown state 처리 (R1):** 3종 중 하나라도 fail → ai_step 중단, 다음 stage 진입 금지, 운영자에게 diagnostic 출력.

### 6.6 승인 게이트 (운영자 참여 영역)

```
Stage 4.5 (plan_final 후): 무조건 일시정지
  → "plan_final.md status: approved 로 수동 변경 후 ai_step --resume 실행."

Stage 11 (final_review): 고위험 작업(Strict 모드 or decisions.md에 risk_level=high) 한정 일시정지
  → 나머지 Standard/Lite는 자동 통과.
```

- 승인 대기 상태는 `docs/notes/dev_history.md`에 `### Stage X — 승인 대기 (paused)` 라인으로 표시.
- `--resume`은 해당 라인이 있는 경우에만 동작. 재실행 멱등성 보장.

### 6.7 실패 복구 전략 (Q1 답)

**정책 확정: fail-closed. 자동 재시도 없음. 체크포인트 롤백 없음. 운영자 수동 재실행.**

| 시나리오 | 동작 |
|---------|------|
| Executor exit ≠ 0 | 중단 + 에러 로그 경로 출력 + dev_history에 `failed` 기록 + exit 10 |
| Artifact 미생성 | 중단 + "executor 출력 경로 확인" 메시지 + exit 11 |
| Grep 키워드 미매치 | 중단 + "artifact에 완료 signal 없음" 메시지 + exit 12 |
| 타임아웃 (기본 30분/stage) | 중단 + executor PID 출력 (운영자 수동 kill) + exit 13 |
| 운영자 Ctrl-C | trap → dev_history에 `interrupted` 기록 + exit 130 |

**근거:**
- 자동 재시도 → flaky 상태 은폐. 운영자가 원인 불명 루프 경험.
- 체크포인트 롤백 → stage별 부분 산출물 삭제 복잡도 높음. git 상태와 artifact 상태 divergence 유발.
- 운영자 수동 재실행 → ai_step은 멱등 (artifact 존재하면 skip 옵션 제공). 재실행 비용 낮음.

### 6.8 표시 경로 team_mode 참조 (F-2-a 예외)

허용:
```sh
# 로그 헤더에서 team_mode 리터럴 출력 (표시)
echo "══════════════════════════════════════"
echo "  $DISPLAY   [team_mode: $(read_team_mode)]"
echo "══════════════════════════════════════"
```

금지:
```sh
# 실행 분기에서 리터럴 사용 — F-2-a 위반
if [ "$(read_team_mode)" = "codex-impl-claude-review" ]; then
  run_codex_rescue
else
  run_claude
fi
```

올바른 실행 분기:
```sh
# stage_assignments 기반 분기만 허용
executor=$(resolve_executor "stage8_impl")
case "$executor" in
  claude) run_claude_impl ;;
  codex)  run_codex_rescue ;;  # plugin-cc 경로만. @openai/codex CLI 비호출 [F-n3]
esac
```

### 6.9 Executor 디스패치 테이블 (Stage 8 구현 참조)

| stage_assignments 값 | stage | 호출 커맨드 |
|----------------------|-------|-------------|
| `stage8_impl: claude` | 8 | `claude --teammate-mode tmux <implementation prompt>` |
| `stage8_impl: codex`  | 8 | `/codex:rescue <implementation prompt>` (plugin-cc 세션 내) |
| `stage9_review: claude` | 9 | `claude` Opus 서브에이전트 (기존 code_review.md 프롬프트) |
| `stage9_review: codex`  | 9 | `/codex:review <code_review prompt>` |
| `stage10_fix: claude` | 10 | `claude --teammate-mode tmux <revise prompt>` |
| `stage10_fix: codex`  | 10 | `/codex:rescue <revise prompt>` |
| `stage11_verify: claude` | 11 | `claude` Opus XHigh (final_review.md, Strict 모드 한정) |

`@openai/codex` CLI 경로 **디스패치 테이블에 포함하지 않음** [F-n3]. 수동 보조용이므로 운영자가 별도 세션에서만 사용.

### 6.10 오케스트레이터 로깅

- 기존: `dev_history.md`에 `### TIMESTAMP — STAGE_NAME started` 한 줄. → 유지.
- 추가: stage 종료 시 `### TIMESTAMP — STAGE_NAME (executor=X) completed` / `... failed (exit=N)`.
- 실패 시 executor 표준출력/에러를 `logs/ai_step_<stage>_<timestamp>.log`에 보존.

---

## Sec. 7. 데이터 모델

### 7.1 settings.json 파싱 결과 (shell 지역변수 기준)
```
SCHEMA_VERSION   "0.4"
WORKFLOW_MODE    "desktop-only"|"desktop-cli"|"cli-only"
TEAM_MODE        "claude-only"|"claude-impl-codex-review"|"codex-impl-claude-review"
STAGE8_IMPL      "claude"|"codex"
STAGE9_REVIEW    "claude"|"codex"
STAGE10_FIX      "claude"|"codex"
STAGE11_VERIFY   "claude"   (유일 값)
```

### 7.2 dev_history.md 엔트리 포맷 (ai_step 추가 필드)
```
### 2026-04-25 14:32 — Stage 8 (executor=claude) started
### 2026-04-25 14:45 — Stage 8 (executor=claude) completed
### 2026-04-25 14:45 — Stage 9 (executor=codex) started
```

---

## Sec. 8. API / 함수 시그니처 (Stage 8 구현자 준수)

### 8.1 공통 lib (신규 파일 권장: `scripts/lib/settings.sh`)

```sh
# settings.sh — 공용 POSIX 파서/라이터. scripts/*.sh가 source로 포함.

settings_path()           # echo 경로 ($ROOT/.claude/settings.json)
settings_require_v04()    # schema_version 확인, 0.4 아니면 die 3
settings_read_key KEY     # sed로 TOP-LEVEL 키 값 추출. 없으면 빈 문자열.
settings_read_stage_assign STAGE_KEY   # sed로 stage_assignments.* 값 추출.
settings_write_key KEY VALUE           # atomic sed 교체. 부재 키면 die 5.
settings_write_stage_assign_block TEAM_MODE  # Sec 2.5 테이블 기반 4개 라인 교체.
```

### 8.2 ai_step.sh 공개 함수
```sh
ai_step_resolve_executor STAGE_KEY    # Sec 6.4
ai_step_check_complete STAGE_KEY      # Sec 6.5
ai_step_dispatch STAGE_KEY EXECUTOR   # Sec 6.9 디스패치
ai_step_log_transition STAGE STATE    # Sec 6.10
ai_step_run_next                      # --next 진입점
ai_step_run_auto                      # --auto 진입점
```

### 8.3 switch_team.sh 공개 함수
```sh
switch_check_bg                       # Sec 4.4. 0=clean, 1=busy.
switch_print_block_msg                # Sec 4.5 verbatim 출력.
switch_apply_team_mode NEW_MODE       # Sec 4.6 atomic 5라인 교체.
switch_status                         # Sec 4.8.
```

---

## Sec. 9. 에러 처리

### 9.1 exit code 통일 (3 스크립트 공통)

| code | 의미 |
|------|------|
| 0 | 정상 |
| 1 | 백그라운드 프로세스 차단 (switch_team) |
| 2 | 잘못된 인자 / unknown executor |
| 3 | 스키마 불일치 / 업그레이드 필요 |
| 4 | settings.json 부재 |
| 5 | settings.json 포맷 손상 (키 누락 등) |
| 10 | ai_step: executor 실패 |
| 11 | ai_step: artifact 미생성 |
| 12 | ai_step: signal 키워드 미매치 |
| 13 | ai_step: 타임아웃 |
| 130 | 운영자 Ctrl-C (trap) |

### 9.2 에러 메시지 KO only (v0.5 정책 승계)
- 진단 메시지는 한국어.
- 파일경로/코드는 원문 유지.
- 에러 발생 라인 번호 + 재현 명령 항상 포함.

### 9.3 예상 에러 → 표면화 방식

| 예상 에러 | 표면화 |
|----------|--------|
| `jq: command not found` | **발생 불가** (jq 비의존). 발생 시 코드 버그 → Stage 9 차단. |
| macOS BSD sed vs GNU sed 차이 | temp file → mv 패턴 (Sec 2.3)으로 우회. in-place 금지. |
| `read` 타임아웃/EOF | 기본값 fallback. `--no-prompt` 모드에서는 즉시 기본값. |
| settings.json 동시 쓰기 race | atomic `mv`로 원자성 보장. 락 파일 미사용 (단일 운영자 전제). |

---

## Sec. 10. 보안 고려

- **비밀값 없음.** settings.json은 workflow_mode / team_mode / stage_assignments 리터럴만 담는다. 토큰·API 키 미포함 — `security/secret_loader.py` 대상 아님.
- **입력 검증:** workflow_mode/team_mode는 허용 리터럴 3종 whitelist, stage_assignments 값은 whitelist (claude|codex). 외 값 reject.
- **쉘 인젝션 방지:** 사용자 입력은 `read -r` + 리터럴 비교만 사용. `eval` / `sh -c "$input"` 금지.
- **외부 프로세스 호출:** plugin-cc 경로(`/codex:rescue`, `/codex:review`, `/codex:status`)는 이미 Claude Code 세션 내부 sandboxed. `@openai/codex` CLI는 본 설계에서 호출 경로 없음 [F-n3].
- **로깅 금지 대상:** 없음 (설정 파일에 비밀값 부재). 단 `dev_history.md`에 PID/commandline 기록될 수 있으므로 `--force` 우회 시 commandline의 shell history와 겹치지 않도록 주의.

---

## Sec. 11. 테스트 전략

### 11.1 유닛 테스트 (`tests/v0.6/`)

| 컴포넌트 | 테스트 타입 | 엣지 케이스 |
|---------|-----------|------------|
| `settings.sh settings_read_key` | unit | 키 중복, 값에 공백/한글, 값 비어 있음, 파일 개행 차이 (CRLF vs LF) |
| `settings.sh settings_write_key` | unit | 원본 손상 시 rollback, atomic mv 실패 시 원본 보존 |
| `settings.sh settings_write_stage_assign_block` | unit | team_mode 3종 각각 → 정확한 4라인 출력, Sec 2.5 매핑 역검증 |
| `init_project.sh` | integration | (a) settings.json 부재 → 전체 생성, (b) v0.3 기존 → 업그레이드, (c) v0.4 기존 → skip, (d) `--no-prompt` → 기본값 기록 |
| `init_project.sh` 대화 verbatim | golden file | [1/2], [2/2] 블록이 brainstorm.md verbatim (★추천★ 포함)과 1:1 일치 (diff 0 bytes) |
| `switch_team.sh --status` | unit | 필드 전체 출력 + bg 탐지 결과 정상 |
| `switch_team.sh` 차단 | integration | 더미 `sleep 99999 & --teammate-mode` 프로세스 스폰 → 차단 메시지 verbatim 일치 + exit 1, `--force` 시 우회 |
| `switch_team.sh` 정상 전환 | integration | 3종 team_mode 간 전환 각각 → stage_assignments 4라인 Sec 2.5 매핑 검증 |
| `ai_step.sh resolve_executor` | unit | claude, codex, 빈값(die 3), 오타(die 2) |
| `ai_step.sh check_stage_complete` | unit | 3 signal 조합 (AND) 8가지 truth table |
| `ai_step.sh` 실행 분기 검사 | static | `grep -E '"(claude-only|claude-impl-codex-review|codex-impl-claude-review)"' scripts/ai_step.sh` — 표시 경로 외 실행 분기에서 리터럴 등장하면 FAIL (F-2-a gate) |
| `ai_step.sh --auto` | integration | Stage 2→3→4→(4.5 pause) 시퀀스, 4.5 paused 상태 검증 |
| v0.3 → v0.4 호환성 | regression | 기존 v0.3 샘플 파일을 `init_project.sh --force-reinit`로 업그레이드 후 v0.3 필드 전원 diff 0 (F-5-a, Stage 9 책임) |

### 11.2 POSIX 파싱 gate 테스트
```sh
# jq 비의존 증명: PATH에서 jq 제거한 상태로 전체 테스트 통과
PATH="$(echo "$PATH" | tr ':' '\n' | grep -v -E '(brew|jq)' | tr '\n' ':')" \
  bash scripts/run_tests.sh
```

### 11.3 shellcheck 통과 의무
- 3 스크립트 + `scripts/lib/settings.sh` shellcheck clean (기존 CI `.github/workflows/ci.yml` 확장).

---

## Sec. 12. Stage 8 구현 노트 (Codex/Claude 공통)

### 12.1 생성할 파일
- `scripts/lib/settings.sh` (신규, Sec 8.1)
- `docs/guides/switching.md` (신규, Sec 5.2 골격)
- `tests/v0.6/` 디렉터리 + 테스트 스크립트 (Sec 11)

### 12.2 수정할 파일
- `scripts/init_project.sh` — Sec 3 기능 추가. 기존 폴더 생성 로직 보존.
- `scripts/switch_team.sh` — **신규 생성**. (v0.5에 없음.)
- `scripts/ai_step.sh` — Sec 6에 따라 전면 재작성. 기존 단일 stage 실행 경로는 `--stage <name>` (또는 인자 1개)로 유지 (하위 호환).
- `.claude/settings.json` — schema v0.3 → v0.4 수동 업그레이드 (또는 init --force-reinit 실행).
- `CHANGELOG.md` — `[0.6.0]` 섹션 추가 (Stage 13 릴리스 전 세션).

### 12.3 제약
- **jq 사용 금지** (F-D2). 테스트도 jq 비의존 증명 포함.
- **team_mode 리터럴 실행 분기 금지** (F-2-a). 표시 경로 예외만.
- **`pending_team_mode` 필드 추가 금지** (F-D3).
- **verbatim 블록 수정 금지** — brainstorm Sec.4 L58–101 / Sec.5 L116–124 원문 보존 (F-n1/n2).
- **`@openai/codex` CLI 호출 경로 추가 금지** (F-n3).

### 12.4 기존 v0.3 API 보존
- `agents.*` 섹션 구조 변경 없음. 기존 `.claude/settings.json`의 v0.3 값 전원 유지.
- `ai_step.sh <stage_name>` (인자 1개) 호출 방식은 v0.5 사용자 호환성 위해 유지.

### 12.5 커밋 메시지 스타일
```
feat(v0.6): D1 schema v0.4 (workflow_mode + team_mode + stage_assignments)
feat(v0.6): D2 init_project.sh 대화 + POSIX 쓰기
feat(v0.6): D3 switch_team.sh 백그라운드 체크 + 즉시 전환
docs(v0.6): D4 switching.md 시나리오 4종
feat(v0.6): D5 ai_step.sh 오케스트레이터 (stage_assignments 기반)
```
D1 → D2 → D3 → D4 → D5 순차 커밋 (Sec 12.6 의존성).

### 12.6 구현 순서 (Milestones M1~M4)
```
M1. D1 schema + lib/settings.sh + 유닛 테스트
   ↓
M2. D2 init_project.sh + golden file verbatim 테스트
   ↓
M3. D3 switch_team.sh + D4 switching.md (동시 릴리스)
   ↓
M4. D5 ai_step.sh + static gate + integration 테스트
   ↓
v0.6 본 릴리스 → 최소 1일 관측 → v0.6.1 D6/D7 kickoff
```

---

## Sec. 13. Out of Scope (이번 구현 대상 외)

plan_final Sec.2 Non-goals + Sec.9 미결정 항목을 명시:

- **D6 Hooks PostToolUse / D7 gstack ETHOS** — v0.6.1 이월 [F-D1].
- **Goal 1 언어 선택 마법사 / Goal 4 `.skills/examples/` 확장 / `/investigate` 통합** — 글로벌 공개 버전 이연.
- **settings.json 자동 마이그레이션 도구** — `init_project.sh --force-reinit` 수기 경로로 충분.
- **`@openai/codex` CLI 오케스트레이터 자동화 호출** — 수동 보조 전용 [F-n3].
- **tmux 세션 관리 고도화** — 현행 `claude --teammate-mode tmux` 기능 의존, 재구현 없음.
- **CI 인프라 변경** — v0.5 shellcheck/macOS 2-job 매트릭스 유지 (확장만 허용: v0.6 테스트 케이스 추가).
- **웹/UI 대시보드** (brainstorm Sec.9) — v0.6 이후 첫 실전 프로젝트 주제, 본 릴리스 대상 외.

---

## Sec. 14. Acceptance Criteria (Stage 9 리뷰 통과 기준)

plan_final Sec.8 AC.1–AC.6 + 본 Stage 5 설계 제약 파생:

- [ ] **AC-5-1 (schema POSIX)** — settings.json schema v0.4 신규 필드 5종이 2-space 들여쓰기 + 1줄 1키 + 파일 내 유일 키명 규약을 지킨다. `grep -c '"workflow_mode"'` = 1, `'"team_mode"'` = 1.
- [ ] **AC-5-2 (pending_team_mode 부재)** — `grep 'pending_team_mode' scripts/ .claude/` 결과 0 hit [F-D3].
- [ ] **AC-5-3 (jq 비의존)** — `which jq` 차단 환경에서 `run_tests.sh` 전체 통과 [F-D2].
- [ ] **AC-5-4 (verbatim 보존)** — `diff` init_project.sh [1/2]/[2/2] 블록 vs brainstorm.md 추출 L58–101 = 0 bytes [F-n1]. `diff` switch_team.sh 차단 메시지 vs brainstorm.md L116–124 = 0 bytes [F-n2].
- [ ] **AC-5-5 (team_mode 실행 분기 금지)** — `tests/v0.6/static_gate.sh`가 ai_step.sh/switch_team.sh/init_project.sh에서 team_mode 리터럴 `if`/`case` 실행 분기 탐지 시 FAIL [F-2-a]. 표시 경로 (echo/printf 내부) 예외 whitelist.
- [ ] **AC-5-6 (stage_assignments만 파싱)** — ai_step.sh가 stage 진입 결정 시 `resolve_executor` 경로만 사용. grep -E `\$TEAM_MODE` in conditional 0 hit [F-2-a].
- [ ] **AC-5-7 (fail-closed)** — unknown executor 값 주입 시 exit 2, 진단 메시지 포함 [Q3].
- [ ] **AC-5-8 (completion 3-signal)** — 3 signal 중 하나라도 fail 시 다음 stage 진입 차단 [R1].
- [ ] **AC-5-9 (Codex CLI 비호출)** — `grep -E '(@openai/codex|^codex |codex exec )' scripts/` 0 hit [F-n3]. plugin-cc 경로(`/codex:rescue`, `/codex:review`)만 허용.
- [ ] **AC-5-10 (v0.3 하위 호환)** — 기존 v0.3 샘플 settings.json을 `init_project.sh --force-reinit`으로 업그레이드 시 v0.3 필드(agents.*, env, language, teammateMode) 전원 diff 0 bytes [F-5-a, Stage 9 책임].
- [ ] **AC-5-11 (switching.md 시나리오)** — `docs/guides/switching.md` Sec.2에 시나리오 ≥4종 존재, 각각 전제/커맨드/효과 3요소 명시 [G4].
- [ ] **AC-5-12 (exit code 통일)** — 3 스크립트 공통 exit code 테이블(Sec 9.1) 준수.

---

## Sec. 15. Stage 5 답변 요약 (plan_final Sec.7 열린 질문)

| # | 질문 | 답변 |
|---|------|------|
| Q1 | `ai_step.sh` stage 중간 실패 복구 전략 | **fail-closed (자동 재시도/롤백 없음). 운영자 수동 재실행. 멱등 보장 (artifact skip).** 근거: Sec 6.7. |
| Q2 | switch_team 백그라운드 감지 커맨드 | **`pgrep -fl` (macOS 단일 플랫폼, claude+codex-plugin-cc 패턴 매칭).** 근거: Sec 4.4. `ps aux` / `/codex:status` 비채택 근거 명시. |
| Q3 | `stage_assignments` 파싱 실패 시 기본 동작 | **fail-closed 확정. 빈 값 → exit 3, 오타 → exit 2, 진단 메시지.** 근거: Sec 6.4 `resolve_executor`. |

---

## Sec. 16. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-25 | v1 — Stage 5 technical_design | 세션 15. Opus. D1→D5 단일 trail. plan_final 승인 후 설계 제약(F-D1, F-D2, F-D3, F-n1, F-n2, F-n3, F-2-a, F-5-a) 전량 흡수. AC 12건 commit. |

---

## 📌 다음 스테이지

**Stage 8 — 구현.** Bundle 없음, D1→D2→D3→D4→D5 단일 trail (Sec 12.6).

- team_mode 기본: `claude-only` (F-n3 + claude-impl-codex-review 추천은 init 대화에서 별도 선택).
- 실행자: settings.json `stage_assignments.stage8_impl` 참조 (claude 또는 codex).
- 커밋: Sec 12.5 스타일 5개 순차.
- Stage 9 리뷰: Sec 14 AC-5-1~5-12 전량 검증 (특히 AC-5-5 static gate, AC-5-10 v0.3 호환성 책임).
