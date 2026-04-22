---
title: 구현 진행 로그
stage: 9
bundle: null
version: 2
language: ko
paired_with: implementation_progress.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# 구현 진행 로그

## Implementation Progress — 2026-04-22 (Stage 8)

### Completed
- [x] D4.x2/D4.x3/D4.x4 인용 기록으로 `docs/notes/decisions.md` 를 추가했다.
- [x] 깨끗한 시작용 handoff 형태로 `templates/HANDOFF.template.md` 를 추가했다.
- [x] dry-run 기본값, write 게이트, 종료 코드 계약, KO 미러 갱신을 갖춘 `scripts/update_handoff.sh` 를 구현했다.
- [x] `CHANGELOG.md`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md` 를 추가했다.
- [x] `tests/bundle4/` 와 `tests/run_bundle4.sh` 를 추가했다.
- [x] 새로 만든 Stage-5+ 문서에 대한 KO frontmatter 페어 `docs/notes/decisions.ko.md`, `docs/04_implementation/implementation_progress.ko.md` 를 함께 추가했다.

### In Progress
- [ ] 없음.

### Blockers
- 없음.

### Notes
- D4.x2에 따라 Stage 1-4 문서에는 frontmatter를 추가하지 않았다.
- `security/` 아래 파일은 변경하지 않았다.
- `.skills/tool-picker/` 는 건드리지 않았다.

---

## Stage 9 — Bundle 4 코드 리뷰 판정 — 2026-04-22

**판정: PASS — minor** (코드 변경 불필요, 설계 문서 1건 인라인 보정만 적용).

### AC 별 판정

| AC | 판정 | 비고 |
|----|------|------|
| AC.B4.1 | PASS | `scripts/update_handoff.sh` 는 POSIX `sh` (`#!/bin/sh`, `set -eu`, bashism 없음). Codex 보고상 `shellcheck -S style` 청결. (이번 리뷰 샌드박스에서 `shellcheck` 설치 불가 → Stage 11 CI 로 전가. `sh -n` + `dash -n` 구문 검사는 로컬 통과.) |
| AC.B4.2 | PASS | dry-run 이 기본, 파일 변경은 `--write` 필수. 동일 페이로드로 `--write` 재실행 시 idempotent (`Recent Changes` 행 재삽입 없음). `test_01_update_handoff_success.sh` 의 cksum 비교로 검증됨. |
| AC.B4.3 | PASS | 구현체는 **아홉 개의 구분되는 `error=<key>` stdout 디스크리미네이터**를 **열 개의 실패 행**에 매핑하며, **6 개의 종료 코드**(1, 2, 3, 4, 5 — 최종 계약에서 exit 6 은 미사용; 원래의 "6 exit codes" 표현은 0 + 5 개의 비-제로 코드를 의미) 로 연결된다. **스펙 내부 불일치 인라인 해소:** Sec. 6 표를 8 → 10 행으로 확장하고 `stdout 디스크리미네이터` 열을 추가했다. 이로써 루브릭의 "nine error cases" 표현이 표와 직접 매핑된다. Sec. 7 은 *왜* 만 서술하고, Sec. 6 이 권위 있는 계약이다. |
| AC.B4.4 | PASS | `CHANGELOG.md` 는 Keep a Changelog v1.1.0 형태 준수: H1, KaC URL 참조, `## [Unreleased]`, 6 개 하위 섹션(`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`). `0.3.0` 릴리스 항목은 아직 없음 — 올바른 상태, Stage 12 에 기록. |
| AC.B4.5 | PASS | `CONTRIBUTING.md` 는 12 개 필수 섹션이 순서대로 있으며 Sec. 12 섹션 소유 부록이 F-a1 예외 주석을 명시 (Sec. 8 "Changelog maintenance" 은 **D4.c** 소유 파일 안에서 **D4.b** 가 소유). |
| AC.B4.6 | PASS | `CODE_OF_CONDUCT.md` 는 Contributor Covenant v2.1 의 완전한 역축 사본 (v2.1 고유 키워드 "caste" 및 `{PROJECT_MAINTAINER_EMAIL}` 플레이스홀더 포함). |
| AC.B4.7 | PASS | `docs/notes/decisions.md` 는 D4.x2, D4.x3, D4.x4 를 `../03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 백링크와 함께 기록. KO 쌍이 EN 과 구조적으로 미러링. |
| AC.B4.8 | PASS | `templates/HANDOFF.template.md` 는 `HANDOFF.md` 와 구조적 parity (섹션 순서, YAML 유사 상태 블록, EN/KO 미러, Recent Changes 표 헤더) 를 유지하면서 live 값은 재설정 (`v0.0.0`, `YYYY-MM-DD`, `TBD`, `bundles: []`, `⬜ Not started`). |
| AC.B4.9 | PASS | 새로 만든 모든 Stage-5+ 문서가 필수 YAML frontmatter 키 (`title`, `stage`, `bundle`, `version`, `language`, `paired_with`, `created`, `updated`, `status`, `validation_group`) 를 가짐. `test_04_frontmatter_and_stage1_4.sh` 로 검증. |
| AC.B4.12 | PASS | Bundle 4 설계 Sec. 0 (64 줄) 에 R1 scope 가 고정 — Bundle 4 는 `.skills/tool-picker/` 와 `security/` 를 건드리지 않음. Codex 준수. |
| AC.B4.13 | FORWARD | POSIX 호환성은 로컬 검증 완료 (dash + sh); mac + Linux CI 커버리지는 Stage 11 에서 수행. |
| AC.B4.14 | FORWARD | `CHANGELOG.md` 에는 `Unreleased` 플레이스홀더만 있음 — 요구사항대로. 실제 `0.3.0` 항목은 Stage 12 릴리스 시점에 기록. |
| AC.B4.15 | PASS | 모든 새 Stage-5+ EN 문서가 같은 날 `.ko.md` 쌍을 동반. R4 신선도 준수. |
| AC.B4.16 | PASS | 리뷰어 체크리스트 항목 `Reviewers tick a "KO freshness for stage-closing docs" check during review.` 이 `CONTRIBUTING.md` Sec. 7 에 배치됨 (N7 이 범위 밖이므로 `.github/` 아님). Stage 1-4 문서 (`docs/01_brainstorm/**`, `docs/02_planning/**`, `docs/notes/dev_history.md`, `HANDOFF.md`, `CLAUDE.md`, `WORKFLOW.md`) 는 모두 frontmatter 없음 — 첫 줄 검사로 확인. |

### 이번 단계에서 적용한 인라인 보정

- `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 6 을 8 → 10
  행으로 확장하고 `stdout 디스크리미네이터` 열과 nine-vs-ten 구분 단락 추가.
  KO 쌍도 같은 날 미러링.

### 코드 변경 없음

- `scripts/update_handoff.sh`, 4 개 테스트 스크립트, `CHANGELOG.md`,
  `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `templates/HANDOFF.template.md` 는
  Codex 가 생산한 상태 그대로 유지. Stage 9 처분은 설계 문서 전용.

### 이번 단계 테스트 재실행

- `sh tests/run_bundle4.sh` — Sec. 6 편집 이후에도 4 개 스크립트 모두 PASS.

### Stage 11 로 이월

- `tests/run_bundle4.sh` 에 대한 교차 플랫폼 CI 매트릭스 (mac + Linux).
- `shellcheck` 설치 가능한 샌드박스에서 `shellcheck -S style` 재실행.

### 커밋 준비

- Bundle 4 의 14 개 파일 + 설계 문서 2 건 편집이 Stage 9 종료 커밋 대상으로 준비됨.

---

## Implementation Progress — 2026-04-22 (Stage 8 — Bundle 1)

### Completed
- [x] YAML frontmatter, 8개 섹션 본문, D4.x2/D4.x3/D4.x4 원문 인용 블록, stage/mode/risk 결정 테이블을 담은 `.skills/tool-picker/SKILL.md` 를 추가했다.
- [x] D1.x 참조 문서 쌍 `docs/notes/tool_picker_usage.md`, `docs/notes/tool_picker_usage.ko.md` 를 추가했다.
- [x] 줄 수, 섹션 순서, 경로, worked example, R2, KO 동기화를 검사하는 `tests/bundle1/run_bundle1.sh` 를 추가했다.
- [x] `.skills/tool-picker/SKILL.md` 를 가리키는 `CLAUDE.md` read-order hook 을 추가했다.

### In Progress
- [ ] 없음.

### Blockers
- 없음.

### Notes
- 결정 테이블 문구는 의도적으로 lean 하게 유지했으며, Stage 9 에서 테이블 모양을 바꾸지 않는 범위의 문구 polish 는 가능하다.
- Stage 11 행은 기존 kickoff prompt 를 가리키고, `docs/notes/final_validation.md` 는 Stage 11 생성 예정 산출물로 명시했다.
- `security/` 아래 파일은 변경하지 않았다.

---

## Stage 9 — Bundle 1 코드 리뷰 판정 — 2026-04-22

**판정: PASS — minor** (코드 변경 불필요, 인라인 polish 0건, Bundle 1 범위 밖 KO 미러 보완 1건).

### AC 별 판정

| AC | 판정 | 비고 |
|----|------|------|
| AC.B1.1 | PASS | `.skills/tool-picker/SKILL.md` 에 필수 YAML frontmatter (`name`, `description`, `stage`, `bundle`, `version`, `language`, `paired_with`, `created`, `updated`, `status`, `validation_group`) 와 8개 섹션 본문이 정규 순서로 있다. `tests/bundle1/run_bundle1.sh` 의 `existence` + `section order` 검사로 검증. |
| AC.B1.2 | PASS | `description` 필드는 287 바이트 (Anthropic Skills 1024자 상한 이하) 이고 필수 트리거 문구를 포함. `frontmatter triggers` 검사로 검증. |
| AC.B1.3 | PASS | 결정 테이블이 `Standard | Strict | Strict-hybrid` × `medium | medium-high` 루브릭의 모든 `stage × (mode, risk)` 교차를 커버. Codex 가 설계 예시의 4 컬럼을 6 컬럼으로 확장 — 수용: AC.B1.3 이 설계 예시보다 상위 권위. `decision table completeness` 검사로 검증. |
| AC.B1.4 | PASS | 결정 테이블 셀의 모든 경로가 유효 (`docs/03_design/**`, `docs/notes/**`, `prompts/**`). Stage 11 행은 기존 kickoff prompt + `docs/notes/final_validation.md` 를 `to be created at Stage 11` 로 명시. `decision table paths` 검사로 검증. |
| AC.B1.5 | PASS (minor) | worked example 은 31 줄, 합성된 Stage-2 트리플을 사용하되 live field-name 형태를 보존. Sec. 6 첫 줄이 예시성 명시 → 수용. live-state 업데이트는 Stage 11 로 이월. |
| AC.B1.6 | PASS | D4.x2/D4.x3/D4.x4 원문 인용 블록이 `docs/notes/decisions.md` + Bundle 4 설계 Sec. 0 을 출처로 명시하며 존재. |
| AC.B1.7 | PASS (헤드라인 — 리뷰어 명시 서명) | R2 read-only 불변식 준수. 독립 grep `\b(bash|sh \|python|node|eval|exec \|curl|wget)\b` 를 `.skills/tool-picker/SKILL.md` 에 돌린 결과 0 매치. code-fence, quoted-output, violation 주석 0 건. `R2 grep` 검사로 검증. |
| AC.B1.8 | PASS | `docs/notes/tool_picker_usage.md` + `.ko.md` 가 D1.x 참조 쌍으로 존재, 각 46 줄, 둘 다 완전한 D4.x2 frontmatter (`stage: 5-support`, `bundle: 1`) 보유. |
| AC.B1.9 | PASS | `CLAUDE.md` read-order hook 이 `.skills/tool-picker/SKILL.md` 를 가리킴. `CLAUDE read order hook` 검사로 검증. |
| AC.B1.10 | PASS | KO 쌍 `tool_picker_usage.ko.md` 가 EN 의 5-섹션 레이아웃을 미러; 헤더 수 일치; `updated:` 일치 (`2026-04-22`). `usage docs and KO sync` 검사로 검증. |

### 이번 단계에서 적용한 인라인 polish

- **0건.** Codex 가 플래그한 결정 테이블 4개 셀 (Stage 5 × Strict × medium; Stage 5 × Strict × medium-high; Stage 8 × Strict-hybrid × medium-high; Stage 11 × Strict-hybrid × medium-high) 을 검토. 문구는 lean 하지만 명료하고 anchor 문서를 정확히 인용. Sec. 9-1 의 "sparingly" 기준 미달 → 편집하지 않음.

### Codex 판단 — Stage 9 처분

- **AC.B1.3 (4 → 6 컬럼):** 수용. 설계 예시의 4 컬럼은 illustrative 였고, AC.B1.3 이 literal 커버리지를 요구.
- **AC.B1.4 (Stage 11 경로 주석):** 수용. `docs/notes/final_validation.md` 에 `to be created at Stage 11` 주석을 붙이는 쪽이 오늘 존재하는 다른 경로를 날조하는 것보다 낫다.
- **AC.B1.7 (0 매치 grep 결과):** 수용. 매치가 0 이면 주석 작업은 vacuous.
- **AC.B1.10 (구조적 동기화 테스트):** 수용. 헤더 수 + `updated:` parity 가 이 번들 단계에서 KO 신선도의 올바른 구조적 proxy.

### 병렬 보완 — Bundle 1 범위 밖

- `docs/notes/dev_history.ko.md` 에 Entry 3.9 를 backfill (EN 파일은 Stage 9 Bundle 4 마감 시 Entry 3.9 가 들어갔으나 KO 미러가 빠져 있었음 — 직전 세션의 R4 누락 보완).

### 코드 변경 없음

- `.skills/tool-picker/SKILL.md`, `docs/notes/tool_picker_usage.md`, `docs/notes/tool_picker_usage.ko.md`, `tests/bundle1/run_bundle1.sh`, `CLAUDE.md` read-order hook — 모두 Codex 가 생산한 상태 그대로 유지. Stage 9 Bundle 1 처분은 housekeeping 전용.

### 이번 단계 테스트 재실행

- `bash tests/bundle1/run_bundle1.sh` — 10개 검사 모두 PASS (existence, line counts, frontmatter triggers, section order, decision table completeness, decision table paths, worked example, R2 grep, usage docs and KO sync, CLAUDE read order hook).
- 독립 R2 grep 재실행 결과 0 매치.

### Stage 11 로 이월

- worked example 을 live Stage-2 트리플로 갱신 (Stage 11 산출물이 생긴 뒤).
- `tests/bundle1/run_bundle1.sh` 53 행이 otherwise-POSIX 스크립트 안에서 `rg` (ripgrep) 에 의존 — minor cross-platform-CI 이슈, Stage 11 의 mac + Linux 매트릭스로 이월.

### 커밋 준비

- Bundle 1 의 5 개 파일은 그대로. Stage 9 마감 커밋에는 이 판정 섹션 (EN + KO), dev_history Entry 3.10 append (EN + KO), Entry 3.9 KO backfill, `HANDOFF.md` YAML bundle-1 verdict 업데이트, `scripts/update_handoff.sh` 가 생성하는 Status + Recent Changes 행이 포함된다.
