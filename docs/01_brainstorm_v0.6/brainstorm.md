# v0.6 브레인스토밍

> Stage 1 산출물 | 세션 13 | 2026-04-24
> 작성: 운영자 + Claude (Sonnet) 공동

---

## 1. v0.6 핵심 방향

**"CLI 자동화 레이어"** — 운영자가 터미널에 수동으로 개입하는 빈도를 최소화.

v0.5까지는 운영자가 중간중간 터미널 명령어를 수동으로 붙여넣어야 했음.
v0.6은 Stage 2–13을 오케스트레이터가 자동으로 처리하는 구조로 전환.

---

## 2. 운영 패턴 3종 확정

| 패턴 | Stage 1 소통 | Stage 2–13 실행 | 터미널 개입 |
|------|-------------|----------------|------------|
| 데스크탑 only | Cowork | Cowork + 수동 터미널 paste | 높음 |
| 데스크탑 + CLI | Cowork | CLI 오케스트레이터 자동 처리 | 낮음 |
| CLI only | `claude` 대화형 REPL | CLI 오케스트레이터 자동 처리 | 최저 |

**결론:** Stage 1 소통은 세 패턴 모두 해결됨 (`claude` REPL = Cowork 동일 경험). v0.6 실질 작업은 Stage 2–13 자동화 레이어 하나에 집중.

---

## 3. 에이전트 팀 구성 (team_mode) 확정

### 선택 옵션 3종

| team_mode | 구현 (Stage 8) | 리뷰 (Stage 9) | 수정보완 (Stage 10) | 검증 (Stage 11) |
|-----------|---------------|---------------|-------------------|----------------|
| `claude-impl-codex-review` ★추천★ | claude --teammate-mode | /codex:review | claude | Claude Opus |
| `codex-impl-claude-review` | /codex:rescue | Claude Opus | /codex:rescue | Claude Opus |
| `claude-only` (기본값) | claude --teammate-mode | Claude Opus | claude | Claude Opus |

### 배경 결정

- **`codex-plugin-cc`** (`/codex:rescue`, `/codex:review`) — Claude Code 플러그인. Codex가 팀원/서브에이전트처럼 동작. 오케스트레이터와 세션 연결됨. **오케스트레이터 자동화에 사용.**
- **`@openai/codex` CLI** — 로컬 독립 실행 터미널 도구. 오케스트레이터와 세션 분리됨. **수동 보조 도구로만 사용.**
- Codex 5.5 코드 리뷰 능력 우수 → `claude-impl-codex-review` 추천 이유.
- OpenAI 미사용자 → `claude-only` 기본값.

### 인증 요구사항

| 도구 | 요구사항 |
|------|---------|
| `/codex:rescue`, `/codex:review` | ChatGPT 유료 구독 또는 OpenAI API 키 |
| `claude --teammate-mode` | Claude Max 플랜 이상 |

---

## 4. init_project.sh 대화 흐름 확정

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

---

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
     → 추천: 구현 속도 우선, 리뷰는 Claude 깊이를 원하는 분

  3) Claude 전담  (기본값)
     - 구현/리뷰/검증 모두 Claude
     - OpenAI 구독 불필요
     → 추천: OpenAI 미사용자 / 단일 도구로 심플하게

선택 (1/2/3, 기본값 3):
```

→ 답변 기반으로 `settings.json` `workflow_mode` + `team_mode` 자동 세팅.
→ 완료 메시지에서 `docs/guides/switching.md` 경로 안내.

---

## 5. switch_team.sh 동작 확정

### 정상 전환 (백그라운드 작업 없음)
```
settings.json team_mode 즉시 변경 → 완료 메시지 출력
```

### 차단 (백그라운드 작업 진행 중)
```
⚠️  팀 구성을 변경할 수 없습니다.

현재 구현 또는 검증 작업이 백그라운드에서 진행 중입니다.
작업이 완료된 후 다음 구현 시작 전에 변경해 주세요.

진행 상태 확인: /codex:status
```

**판단 방식:** `/codex:status` 또는 claude 프로세스 실행 여부 체크. Stage 추적 로직 없음 — 단순하고 신뢰성 높음.

---

## 6. settings.json schema v0.4 변경 예정

```json
{
  "schema_version": "0.4",
  "workflow_mode": "desktop-only | desktop-cli | cli-only",
  "team_mode": "claude-impl-codex-review | codex-impl-claude-review | claude-only",
  "pending_team_mode": null,
  "stage_assignments": {
    "stage8_impl":   "claude | codex",
    "stage9_review": "codex | claude",
    "stage10_fix":   "claude | codex",
    "stage11_verify": "claude"
  }
}
```

---

## 7. v0.6 과업 목록 (확정)

| # | 과업 | 우선순위 | 비고 |
|---|------|---------|------|
| 1 | `scripts/init_project.sh` | 상 | 운영방식 + team_mode 선택 → settings.json 자동 세팅 |
| 2 | `settings.json` schema v0.4 | 상 | workflow_mode, team_mode, stage_assignments 필드 추가 |
| 3 | `scripts/switch_team.sh` | 상 | 백그라운드 체크 + team_mode 즉시 변경 |
| 4 | `docs/guides/switching.md` | 상 | 패턴 전환 시나리오 가이드 |
| 5 | `ai_step.sh` 오케스트레이터 | 상 | Stage 2–13 자동화. team_mode 분기 처리 |
| 6 | Hooks PostToolUse | 중 | py_compile / shellcheck 자동화. CLI 워크플로우 정착 후 |
| 7 | gstack ETHOS → CLAUDE.md | 중 | 오케스트레이터 설계 철학 반영 |

### 우선순위 하 (글로벌 공개 버전 시)
- Goal 1 언어 선택 마법사
- Goal 4 `.skills/examples/` 확장
- `/investigate` 스킬 참조

---

## 8. 팀 페르소나 (v0.6 추가 항목)

에이전트 팀원에게 이름 + MBTI + 성격을 부여하여 재미 요소 + 일관된 커뮤니케이션 스타일 확보.

| 에이전트 | 이름 | 모델 | 직급 | MBTI | 성격/스타일 |
|---------|------|------|------|------|------------|
| @main (오케스트레이터) | 지훈 팀장 | 👑 Opus | 팀장/임원 | ESTJ | 운영자한테만 존댓말. 팀원에게 단호하게 지시. 전략 판단. |
| @reviewer | 민지 | 🔵 Sonnet | 대리/과장 | ENTP | 직설적 시니어. 반말. 날카로운 피드백. 아이디어 많음. |
| @drafter | 준혁 | 🟢 Haiku | 신입/인턴 | ISTJ | 꼼꼼한 신입. 규칙 철저. 항상 존댓말. 초안 담당. 열정 넘침. |
| @finalizer | 태원 | 🟢 Haiku | 신입/인턴 | INTJ | 말없는 신입. 간결하게 핵심만. 감정 없음. 최종 정리 담당. |

**모델-직급 체계:**
- 👑 Opus — 부장/임원. 전략 판단, 고위험 검증 전담.
- 🔵 Sonnet — 대리/과장. 핵심 실무 담당.
- 🟢 Haiku — 신입/인턴. 반복 작업, 탐색, 초안 담당. 열정만 넘침.

`init_project.sh` [3/3] 단계에서 선택:
```
1) 기본 (이름/성격 없음)
2) Jonelab 기본 팀 (지훈/준혁/민지/태원)
3) 직접 설정
```

---

## 9. v0.6 이후 첫 실전 프로젝트 메모

**Jonelab AI팀 운영자 대시보드 (ANSI CLI)**

v0.6 릴리즈 후 첫 번째 실전 프로젝트. jDevFlow 템플릿으로 자기 자신의 대시보드를 만드는 것.

```
Jonelab AI팀 대시보드

┌─────────────────────────────────────┐
│  🟢 지훈 팀장  @main   ESTJ         │
│  Stage 3 → @reviewer 대기 중        │
├─────────────────────────────────────┤
│  ✅ 준혁 @drafter  ISTJ             │
│  plan_draft.md 완료 (167줄)         │
├─────────────────────────────────────┤
│  🔄 민지 @reviewer  ENTP            │
│  plan_draft 검토 중... (2m 15s)     │
├─────────────────────────────────────┤
│  💤 태원 @finalizer  INTJ           │
│  대기 중                            │
└─────────────────────────────────────┘
```

- **형태:** ANSI 터미널 대시보드 (UI 기반 제외 — has_ui=false)
- **데이터 소스:** tmux 상태 + Claude Code 팀 API
- **표시 정보:** 팀원별 상태(대기/작업중/완료), 현재 작업 내용, 소요 시간
- **이유:** UI 기반 프로젝트는 아직 미적용. CLI 워크플로우에 자연스럽게 통합.

**참고 레퍼런스:** QJC-OS (운영자 발견) — 에이전트 오피스 UI. 픽셀아트 캐릭터로 팀원 시각화, 직급/모델/상태/도구 개수/파이프라인 표시, 부서별 구분. 우리 아이디어와 동일한 방향. UI 버전 구현 시 참고할 것.

---

## 10. 프로젝트 유형 추상화 (v0.7+ 로드맵)

**배경:** jDevFlow는 현재 소프트웨어 개발 기준으로 설계됨. 제이원랩(UIUX 에이전시) 실전 적용 시 Stage 8 "구현" 담당자 역할이 다름. 이를 추상화하여 다양한 프로젝트 유형 지원.

**핵심 아이디어:** Stage 구조는 그대로 유지. `init_project.sh`에서 프로젝트 유형 선택 시 각 Stage의 담당자 역할 정의만 교체.

```json
"project_type": "software-dev | uiux-agency | custom",
"stage_assignments": {
  "stage8_impl": "publishing | publishing+dev | design+publishing | dev"
}
```

**프로젝트 유형별 Stage 8 매핑:**

| 프로젝트 유형 | Stage 8 구현 | 대상 |
|-------------|-------------|------|
| `software-dev` | 개발 (Codex/Claude) | 개발팀 있는 회사 |
| `uiux-agency` | 퍼블리싱 (HTML/CSS) | 제이원랩 등 에이전시 |
| `uiux-agency-full` | 디자인 + 퍼블리싱 묶음 | 디자인 내재화 에이전시 |
| `custom` | 직접 정의 | 기타 |

**제이원랩 전체 워크플로우 매핑:**

```
Stage 1–4   기획 (브레인스토밍 → PPT 기획서)    ← 고객과 공동 작업
Stage 5–7   디자인 (Figma 디자인시스템 기반)     ← 디자인팀 리뷰
Stage 8     퍼블리싱 (HTML/CSS)                  ← 퍼블리싱팀 착수
Stage 9–11  리뷰/검증
Stage 12–13 QA → 개발팀 인계
```

**로드맵:**

| 버전 | 핵심 |
|------|------|
| v0.6 | CLI 자동화 레이어 + team_mode |
| v0.7 | 프로젝트 유형 추상화 (software-dev / uiux-agency / custom) |
| v0.8 | 제이원랩 실전 적용 — PPT 기획서 자동화 + Figma MCP 연동 |

---

## 11. 제이원랩 컨텍스트 (v0.7–v0.8 설계 참고)

**회사:** 제이원랩 (대표: 이형진)
**업종:** UIUX 에이전시 — 금융권(모바일뱅킹, 인터넷뱅킹, ODS 태블릿) 전문
**규모:** 정규직 2명(대표 포함 기획자), 비정규직 2명(디자이너, 퍼블리셔)
**주요 실적:** 피그마 디자인시스템 기반 모바일뱅킹 고도화 (프리랜서 포함 11명 투입)

**디자인 툴 현황 (고정 금지 — 유연하게 추상화):**

| 툴 | 상황 |
|----|------|
| Figma | 주력. 자체 디자인시스템 보유. MCP 연동 가능. |
| Claude 디자인 | 신규 출시. 검토 필요. |
| Stitch (Figma) | 검토 필요. |
| Sketch | 일부 금융권 사용. |
| Photoshop | 일부 보수적 금융권 아직 사용. |

→ v0.8 설계 시 디자인 툴을 `settings.json`의 `design_tool` 필드로 추상화. Figma 고정 금지.

**기존 자산:**
- 피그마 디자인시스템 — 모바일뱅킹용. v0.8에서 활용 방안 검토.
- PPT 기획서 양식 — 금융권 표준. 자동화 1순위.

**미해결 과제:**
- 회사 홈페이지 없음 — 7년째 없이 운영 중. 금융권은 레퍼런스/신뢰 관계로 수주하므로 홈페이지 우선순위 낮음.
- 회사 소개서 업데이트 필요 (현재 2년 전 버전).

**실전 프로젝트 우선순위 확정:**

| 순서 | 프로젝트 | 이유 |
|------|---------|------|
| 1 | PPT 기획서 자동화 | 즉시 ROI. 매 프로젝트마다 반복 사용. 금융권 양식 정형화로 자동화 효과 극대화. |
| 2 | 홈페이지 | jDevFlow UIUX 모드 완성 후 직접 제작 → 레퍼런스 케이스 겸용. |

---

## 12. 주요 결정 로그

| 결정 | 내용 | 이유 |
|------|------|------|
| Codex executor | plugin-cc (`/codex:rescue`) | 팀원/서브에이전트 모델. 오케스트레이터와 세션 연결 |
| `@openai/codex` CLI | 수동 보조 도구 전용 | 오케스트레이터와 세션 분리 — 자동화 부적합 |
| switch_team 차단 방식 | 백그라운드 프로세스 체크 | Stage 추적 로직 불필요. 단순하고 신뢰성 높음 |
| 기본 team_mode | `claude-only` | OpenAI 미사용자 포함 최대 호환성 |
| 추천 team_mode | `claude-impl-codex-review` | Codex 5.5 리뷰 능력 활용 |
