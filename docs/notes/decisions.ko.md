---
title: Bundle 4 구조적 결정
stage: 5-support
bundle: 4
version: 1
language: ko
paired_with: decisions.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Bundle 4 구조적 결정

이 파일은 D4.x2, D4.x3, D4.x4의 인용 가능한 기록이다.

기준 출처: `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.

## 결정 기록 라인

> **D4.x2/x3/x4 locked on 2026-04-22 -- see `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.** Bundle 1 Stage 5 is unblocked.

### D4.x2 - 내부 문서 헤더 스키마

**결정.** plan_final Sec. 7-2 OQ4.1의 기울기를 확정: **Stage-5 이후 문서에만 YAML frontmatter를 부여**. Stage 1-4의 narrative / bilingual 문서는 prose-only로 유지한다.

**범위.**

- frontmatter를 가지는 문서: `docs/03_design/**/technical_design.md`, `docs/04_implementation/implementation_progress.md`, `docs/notes/final_validation.md`, `docs/05_qa_release/qa_scenarios.md`, `docs/05_qa_release/release_checklist.md`, 그리고 해당 `.ko.md` 페어 전부.
- frontmatter를 가지지 않는 문서: `docs/01_brainstorm/**`, `docs/02_planning/**`, `docs/notes/dev_history.md`, `HANDOFF.md`, `CLAUDE.md`, `WORKFLOW.md`, 모든 `README.md`.

**근거.** Stage-5+ 문서는 Bundle 1 tool-picker (D1.b)와 Stage 11 dossier generation이 기계 파싱한다. 안정적인 frontmatter가 있으면 파싱이 단순해진다. 이전 단계 문서는 narrative, bilingual, human-first 성격이라 frontmatter가 소비자 없는 잡음이 된다.

**역링크.** `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 참조.

### D4.x3 - 번들 폴더 명명 규칙

**결정.** plan_final Sec. 7-2 OQ4.2의 기울기를 확정: **`bundle{id}_{name}/`**, `{name}`은 snake_case. 이미 `docs/03_design/bundle4_doc_discipline/` 와 `docs/03_design/bundle1_tool_picker/` 에 사용 중이다.

**규칙.** 폴더 이름 형식: `bundle<HANDOFF.md bundles[].id의 정수>_<HANDOFF.md bundles[].name의 snake_case>/`. id 앞에 0을 붙이지 않는다.

**근거.** `bundle` 접두사 + 숫자 id가 `HANDOFF.md bundles[].id` / `HANDOFF.md bundles[].name` YAML 블록과 1:1로 대응되므로, `^bundle(\d+)_(.+)$` 같은 정규식으로 두 필드를 결정적으로 추출할 수 있다. `{name}/` 은 id lookup을 잃고, `{nn}_{name}/` 은 새로운 numbering space를 만들며, bare numeric prefix는 stage 번호와 혼동된다.

**역링크.** `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 참조.

### D4.x4 - 문서 링크 규칙

**결정.** **항상 현재 파일 기준 상대경로를 사용한다.** project-root absolute link는 금지한다. anchor 스타일은 GitHub 규칙을 따른다: lowercase, spaces-to-hyphens, punctuation dropped.

**규칙.**

- 같은 폴더 안에서는 `./sibling.md` (`./` 는 선택이지만 명확성을 위해 권장).
- 형제 폴더로 갈 때는 `../other_folder/target.md`.
- 프로젝트 루트로 갈 때는 `../` hop 수를 명시적으로 센다. `/absolute` 문법은 쓰지 않는다.
- anchor는 `file.md#section-header-lowercased-hyphenated`. "Sec. 3-2" 는 `#3-2-bundle-4-doc-discipline` 스타일로 변환하되 실제 rendered slug와 맞춘다.
- `file://` 또는 absolute path를 넣지 않는다.
- 외부 링크는 full HTTPS URL을 사용한다.

**근거.** 현재 파일 기준 상대경로는 GitHub web UI, VS Code preview, Claude Code Read output, 그리고 일반 Markdown viewer에서 일관되게 렌더된다. project-root absolute path는 절반의 렌더러에서 깨진다. lowercase-hyphenated anchor 규칙은 GitHub auto-slug와 맞아서 rename-safe 하다.

**역링크.** `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 참조.
