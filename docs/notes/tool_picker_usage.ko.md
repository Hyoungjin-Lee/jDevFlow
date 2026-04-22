---
title: Tool-picker 사용법
stage: 5-support
bundle: 1
version: 1
language: ko
paired_with: tool_picker_usage.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Tool-picker 사용법

## 1. 무엇인가

`/Users/geenya/projects/Jonelab_Platform/jOneFlow/.skills/tool-picker/SKILL.md`
는 `HANDOFF.md` 의 현재 `(stage, mode, risk_level)` 상태를 기준으로 다음에
볼 프롬프트, 문서, 체크리스트를 고르는 jOneFlow advisory skill 이다.

## 2. 언제 나타나는가

이 스킬은 stage 진입 시점의 읽기와, jOneFlow 대화에서 "what next",
"which tool", "next step" 같은 질문이 나왔을 때 매칭되도록 설계됐다.

## 3. advisory 읽는 법

출력은 짧은 채팅 블록이며 다음을 담는다.

- primary next step 하나
- 선택적 checklist reminder
- 선택적 watch-out

이 출력은 advisory only 이다. 사용자는 무시하거나 "skip" 이라고 하거나
세부 설명을 이어서 요청할 수 있다.

## 4. 무엇을 읽는가

스킬은 `HANDOFF.md` 만 읽고, 그중 `## Status` 안의 `Current stage`,
`Workflow mode`, `risk_level` 줄만 사용한다.

## 5. 하지 않는 일

이 스킬은 진행을 막지 않고, 파일을 수정하지 않고, native API 로
등록되지 않으며, 번들별 리뷰/구현 프롬프트를 대체하지 않는다.
