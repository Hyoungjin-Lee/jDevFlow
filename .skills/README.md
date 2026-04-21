# .skills/ — Custom Skill Reference Guide

> This folder holds **skill definition files** that Claude reads to perform specialized tasks within your project.
> Each skill lives in its own subfolder with a `SKILL.md` file.

**한국어 버전:** 이 파일 하단 참조

---

## What is a Skill?

A skill is a markdown file (`SKILL.md`) that gives Claude a focused set of instructions for a specific, repeatable task — such as calling an API, generating a report, or processing data.

Referencing a skill in `CLAUDE.md` tells Claude to read it before attempting that task, which leads to more consistent and accurate output.

---

## Folder Structure

```
.skills/
├── README.md                  ← this file
├── api-client/
│   └── SKILL.md               ← how to call your project's API
├── reporting/
│   └── SKILL.md               ← how to generate reports
└── your-skill-name/
    └── SKILL.md               ← your custom skill
```

---

## How to Add a Skill

### 1. Create a subfolder

```bash
mkdir .skills/my-skill
```

### 2. Create `SKILL.md`

Write a `SKILL.md` file using this structure:

```markdown
# Skill: [Skill Name]

## Purpose
What this skill does and when to use it.

## Prerequisites
- Required environment variables or secrets
- Required libraries or tools

## Steps
1. Step one
2. Step two
3. ...

## Example
[concrete usage example]

## Notes
- Edge cases or cautions
```

### 3. Register the skill in `CLAUDE.md`

In the **Section 7 — Skill References** table of `CLAUDE.md`, add a row:

```markdown
| Your task description | `.skills/my-skill/SKILL.md` |
```

Claude will read the file automatically when that task comes up.

---

## Skill Writing Tips

- **Be concrete.** Use exact file paths, function names, and command examples.
- **Keep it focused.** One skill = one task. Don't combine unrelated instructions.
- **Include an example.** A working example is worth more than three paragraphs of prose.
- **State prerequisites clearly.** List secrets, env vars, or pip packages needed.
- **Add "Notes" for edge cases.** Warn about rate limits, permissions, or known failure modes.

---

## Bundled Skills (add as needed)

| Skill | Suggested Path | Description |
|-------|---------------|-------------|
| API Client | `.skills/api-client/SKILL.md` | How to authenticate and call your project's external API |
| Report Generator | `.skills/reporting/SKILL.md` | How to generate and save output reports |
| Data Processor | `.skills/data-processor/SKILL.md` | How to load, transform, and validate data files |

> These are not included by default. Create them when your project needs them.

---

---

# .skills/ — 커스텀 스킬 추가 가이드 (한국어)

> 이 폴더는 Claude가 특정 작업을 수행할 때 읽는 **스킬 정의 파일**을 담는 곳입니다.
> 각 스킬은 고유한 하위 폴더 안에 `SKILL.md` 파일로 구성됩니다.

---

## 스킬이란?

스킬은 Claude에게 특정 반복 작업(API 호출, 리포트 생성, 데이터 처리 등)에 대한 집중된 지침을 주는 마크다운 파일(`SKILL.md`)입니다.

`CLAUDE.md`에 스킬을 등록해두면, 해당 작업이 필요할 때 Claude가 자동으로 파일을 읽어 더 일관되고 정확한 결과를 만들어냅니다.

---

## 폴더 구조

```
.skills/
├── README.md                  ← 이 파일
├── api-client/
│   └── SKILL.md               ← 프로젝트 API 호출 방법
├── reporting/
│   └── SKILL.md               ← 리포트 생성 방법
└── 내-스킬-이름/
    └── SKILL.md               ← 커스텀 스킬
```

---

## 스킬 추가 방법

### 1. 하위 폴더 생성

```bash
mkdir .skills/my-skill
```

### 2. `SKILL.md` 작성

아래 구조로 `SKILL.md` 파일을 작성합니다:

```markdown
# Skill: [스킬 이름]

## 목적
이 스킬이 무엇을 하는지, 언제 사용하는지.

## 사전 조건
- 필요한 환경변수 또는 시크릿
- 필요한 라이브러리나 도구

## 단계
1. 첫 번째 단계
2. 두 번째 단계
3. ...

## 예시
[구체적인 사용 예시]

## 주의사항
- 엣지 케이스나 주의할 점
```

### 3. `CLAUDE.md`에 등록

`CLAUDE.md` **7번 섹션 — 스킬 참조** 표에 행을 추가합니다:

```markdown
| 작업 설명 | `.skills/my-skill/SKILL.md` |
```

이후 해당 작업이 필요할 때 Claude가 자동으로 파일을 읽습니다.

---

## 스킬 작성 팁

- **구체적으로 쓰세요.** 정확한 파일 경로, 함수명, 명령어 예시를 포함하세요.
- **하나의 스킬 = 하나의 작업.** 관련 없는 지침을 합치지 마세요.
- **예시를 꼭 포함하세요.** 실제 작동하는 예시가 긴 설명보다 효과적입니다.
- **사전 조건을 명확히 하세요.** 필요한 시크릿, 환경변수, pip 패키지를 명시하세요.
- **"주의사항"에 엣지 케이스를 추가하세요.** 속도 제한, 권한, 알려진 오류 등을 기록하세요.

---

## 기본 제공 스킬 (필요 시 추가)

| 스킬 | 권장 경로 | 설명 |
|------|----------|------|
| API 클라이언트 | `.skills/api-client/SKILL.md` | 외부 API 인증 및 호출 방법 |
| 리포트 생성기 | `.skills/reporting/SKILL.md` | 결과 리포트 생성 및 저장 방법 |
| 데이터 처리기 | `.skills/data-processor/SKILL.md` | 데이터 파일 로드, 변환, 검증 방법 |

> 이 스킬들은 기본 포함되지 않습니다. 프로젝트에 필요할 때 직접 만드세요.
