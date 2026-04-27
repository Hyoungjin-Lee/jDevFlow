# .skills/ — Behavior-Shaping Skill Library

> Skills here exist to **change what Claude actually does** in your project, not just to remind it.
> A good skill is short, has clear triggers, and tells Claude when to stop or ask.

**한국어 버전:** 이 파일 하단 참조 (Korean version below)

---

## What is a skill?

A skill is a markdown file (`SKILL.md`) that Claude reads before performing a specific, repeatable task — calling an API, generating a report, producing a certain class of document, etc.

A skill is not a tutorial. It is a **compact behavior contract**. Claude reads it, adopts the rules, and then performs the task.

Registering a skill in `CLAUDE.md` tells Claude to read it before attempting the matching task, which leads to consistent output across sessions.

---

## Folder structure

```
.skills/
├── README.md                  ← this file
├── _templates/
│   └── behavioral-skill-template/
│       └── SKILL.md           ← copy this to start a new skill
├── examples/
│   └── safe-script-run/
│       └── SKILL.md           ← a worked example of a behavior-shaping skill
└── your-skill-name/
    └── SKILL.md               ← your custom skill
```

The `_templates/` and `examples/` folders are not required at runtime — copy what you need into your own skill folder and then delete the parts you did not use.

---

## Behavior-shaping skill structure

Every `SKILL.md` should have these eight sections. Keep each one short.

### 1. Purpose

One sentence: what this skill makes Claude do.

### 2. When to Use

Trigger phrases, filenames, stages, or conditions. Be explicit. If a user says "generate the weekly report", this section should tell Claude to read this file.

### 3. Do

Concrete allowed actions. Use verbs: "read", "compute", "write", "ask".

### 4. Don't

Concrete forbidden actions. Often more useful than "Do". Examples: "don't hardcode dates", "don't call the live endpoint without `--dry-run`", "don't commit without running tests".

### 5. Red Flags

Signals that Claude should **stop and ask**, not push through. Examples: secret appears in logs, more than N rows returned, file size crosses a threshold, unusual error code.

### 6. Good / Bad examples

Tiny side-by-side pairs. One good example with a one-line reason it is good. One bad example with a one-line reason it is bad. Short beats long here.

### 7. Checklist

Five to eight items Claude must tick off before declaring the task complete. Checklists beat prose for enforcement.

### 8. Verification

How to prove the task is done. Command to run, file to diff, log line to grep. If the output cannot be verified mechanically, describe what "done" looks like in a sentence.

Optional sections (add only if needed): **Prerequisites**, **Inputs / Outputs**, **Rollback**, **Notes**.

---

## How to add a skill

### 1. Copy the template

```bash
cp -r .skills/_templates/behavioral-skill-template .skills/my-skill
```

### 2. Edit `.skills/my-skill/SKILL.md`

Fill in Purpose / When to Use / Do / Don't / Red Flags / Good-Bad / Checklist / Verification. Trim anything you do not need.

### 3. Register in `CLAUDE.md`

Add a row in Section 7 (Skill References):

```markdown
| Your task description | `.skills/my-skill/SKILL.md` |
```

Claude reads the file the next time that task comes up.

---

## Skill writing discipline

- **Short beats long.** One screen is usually enough. Two screens is almost always too much.
- **Trigger clearly.** If Claude can't tell when to read this skill, it will never read it.
- **Forbid explicitly.** "Don't" is often stronger than "Do".
- **Prefer verifiable steps.** Steps that produce a file, a log line, or a test result are easier to enforce.
- **One skill = one task.** If you find yourself writing two `Purpose` sentences, split the file.
- **Write the red flags.** Every real task has failure modes — surface them.

---

## Bundled skill templates and examples

| Path | What it is |
|------|-----------|
| `.skills/_templates/behavioral-skill-template/SKILL.md` | Empty template. Copy to start a new skill. |
| `.skills/examples/safe-script-run/SKILL.md` | Worked example: running a project script safely with `--dry-run` and keychain secrets. |

> These are scaffolding. Delete them or keep them — both are fine. Real project skills live as siblings in `.skills/`.

---
---

# .skills/ — 행동 유도형 스킬 라이브러리 (한국어)

> 여기의 스킬은 Claude에게 "참고 자료"가 아니라 **실제 행동을 바꾸는 계약**입니다.
> 좋은 스킬은 짧고, 트리거가 분명하고, 언제 멈추고 질문해야 하는지 알려줍니다.

---

## 스킬이란?

스킬은 Claude가 특정 반복 작업(API 호출, 리포트 생성, 특정 문서 생성 등)을 수행하기 전에 읽는 마크다운 파일(`SKILL.md`)입니다.

스킬은 튜토리얼이 아닙니다. **행동 계약서**입니다. Claude는 이 파일을 읽고 규칙을 받아들인 뒤 작업을 수행합니다.

`CLAUDE.md`에 등록해두면, 해당 작업이 필요할 때 Claude가 자동으로 이 파일을 읽어 더 일관된 결과를 만듭니다.

---

## 행동 유도형 스킬 구조

모든 `SKILL.md`는 아래 8개 섹션을 갖도록 하세요. 각 섹션은 짧게.

1. **Purpose (목적)** — 이 스킬이 Claude에게 무엇을 시키는지 한 문장.
2. **When to Use (사용 시점)** — 트리거 문구/파일명/단계/조건. 명시적으로.
3. **Do (허용 행동)** — 구체적 동사로.
4. **Don't (금지 행동)** — 보통 Do보다 더 강력함.
5. **Red Flags (위험 신호)** — Claude가 **멈추고 질문해야** 할 신호 (예: 로그에 시크릿, N행 초과, 예외 코드).
6. **Good / Bad 예시** — 짧은 쌍. 각각 왜 좋은지/나쁜지 한 줄.
7. **Checklist (체크리스트)** — 완료 전에 반드시 통과할 5~8개 항목.
8. **Verification (검증)** — 완료를 증명할 방법 (명령어/diff/로그 grep).

선택 섹션: 사전 조건, 입출력, 롤백, 주의사항.

---

## 스킬 작성 원칙

- **짧을수록 좋다.** 한 화면이면 보통 충분. 두 화면이면 대부분 과함.
- **트리거를 분명히.** Claude가 언제 읽어야 할지 모르면 안 읽는다.
- **명시적으로 금지하라.** "하지 마" 가 "해" 보다 더 잘 먹는다.
- **검증 가능한 단계.** 파일/로그/테스트 결과를 만드는 단계가 강제력이 있다.
- **하나의 스킬 = 하나의 작업.** Purpose가 두 문장이 되면 파일을 쪼개라.
- **Red flag를 써라.** 실제 작업은 항상 실패 모드가 있다 — 명시적으로 드러내라.

---

## 스킬 추가 방법

```bash
cp -r .skills/_templates/behavioral-skill-template .skills/my-skill
# .skills/my-skill/SKILL.md 작성
```

이후 `CLAUDE.md`의 Section 7(Skill References)에 한 줄 추가:

```markdown
| 작업 설명 | `.skills/my-skill/SKILL.md` |
```

---

## 기본 제공 템플릿과 예시

| 경로 | 설명 |
|------|------|
| `.skills/_templates/behavioral-skill-template/SKILL.md` | 빈 템플릿. 새 스킬 시작 시 복사. |
| `.skills/examples/safe-script-run/SKILL.md` | 예시: `--dry-run`과 키체인 시크릿으로 프로젝트 스크립트 안전 실행. |

> 이들은 scaffolding입니다. 유지해도 되고 삭제해도 됩니다. 실제 프로젝트 스킬은 `.skills/` 아래 형제 폴더로 둡니다.

---

## 현재 등록된 스킬 (운영자 시각용 인덱스)

> 표준 = `.skills/<skill-name>/SKILL.md` (1단 평면). 운영자가 한눈에 그룹 파악할 수 있도록 본 인덱스에 그룹별 정리. skill 추가 시 본 표 갱신.

### 🔄 Workflow (워크플로우 의사결정)

| 스킬 | 경로 | 한 줄 |
|------|------|------|
| tool-picker | `.skills/tool-picker/SKILL.md` | jOneFlow stage / mode / risk_level 영역 다음 단계 추천 |

### 🤖 Automation (자동화 / 시그널 영역)

| 스킬 | 경로 | 한 줄 |
|------|------|------|
| push-signal-watcher | `.skills/push-signal-watcher/SKILL.md` | bridge / Orc → 회의창 push 시그널 (watcher task + task-notification 패턴, v0.6.4 세션 28 검증) |

### 💻 Terminal (터미널 운영)

| 스킬 | 경로 | 한 줄 |
|------|------|------|
| ghostty-tmux-ops | `.skills/ghostty-tmux-ops/SKILL.md` | Ghostty + tmux 4 panes 영역 + @persona 페르소나 박음 + claude CLI 기동 표준 |

### 📦 Templates / Examples (스킬 작성 영역 보조)

| 경로 | 설명 |
|------|------|
| `.skills/_templates/behavioral-skill-template/SKILL.md` | 새 skill 시작 시 복사용 빈 템플릿 |
| `.skills/examples/safe-script-run/SKILL.md` | 안전한 스크립트 실행 영역 예시 |

---

## 그룹 추가 방법

운영자가 새 그룹 영역 박으려면:
1. 본 README.md `## 현재 등록된 스킬` 섹션에 그룹 헤더 (`### 🆕 새 그룹`) 추가
2. 그 그룹에 속하는 skill 1줄 박음
3. 실제 디렉토리 영역 = `.skills/<skill-name>/SKILL.md` (1단 평면 그대로 — Claude 자동 발견 영역 보장)

= **물리 영역은 평면, 운영자 시각 영역은 그룹별 인덱스**. 표준 + 직관 동시 박음.
