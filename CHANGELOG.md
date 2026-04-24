# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **`docs/01_brainstorm_v0.6/brainstorm.md`** — v0.6 Stage 1 브레인스토밍 산출물. CLI 자동화 레이어, 운영 패턴 3종, team_mode 3종, init_project.sh / switch_team.sh 설계 확정.

## [0.5.0] - 2026-04-24

> Meta-release: KO only 전환 + 모델 선택 정책 + CI 자동화 + Bundle 2/3 re-scope. 기능 번들 없음.

### Added
- **Model selection policy (v0.5 — Max x5 기준)** — Stage별 Sonnet/Opus 배정 기준 확정. Stage 1=Sonnet, Stage 2–4/5/9/11=Opus, Stage 6–7/12–13=Sonnet. CLAUDE.md Sec.3, WORKFLOW.md Sec.9–10, `.claude/settings.json` schema v0.3에 반영.
- **Bundle 2/3 re-scope 완료** — Goal별 처리 방향 확정. Goal 2/6 드롭, Goal 1/4/8 글로벌 공개 버전 이월, Goal 3/Hooks v0.6 이월. gstack ETHOS + autoplan + /investigate 참조 대상 확정.
- **`.github/workflows/ci.yml`** — GitHub Actions CI: shellcheck (Linux), test harness (Linux + macOS). shellcheck auto-detects shell from shebang; severity=warning. macOS job runs `brew install shellcheck` + both harnesses.
- **`scripts/run_tests.sh`** — local one-command test runner: runs bundle1 + bundle4 and exits non-zero on any failure. Removes operator paste burden for local test runs.

### Changed
- **`CLAUDE.md`** — EN+KO 병기 → KO only 전환. 741줄 → 188줄 (75% 감소). Anthropic 권장 500줄 이하 달성.
- **`WORKFLOW.md`** — EN+KO 병기 → KO only 전환. 790줄 → 279줄 (65% 감소). R2 읽기 비용 57% 절감.
- **`.claude/settings.json` schema v0.3** — planner Stage 2–4 Sonnet→Opus, reviewer Stage 9 Sonnet→Opus. schema_version 0.2→0.3.
- **`WORKFLOW.md` Sec.3/9/10** — Stage 표 모델 업데이트. Model selection guide 전체 재작성. Cowork 세션 운영 규칙 추가.
- **`CLAUDE.md` Sec.3** — 모델 선택 정책 섹션 신규 추가.
- **`CLAUDE.md` git policy** — v0.5 업그레이드: `sh scripts/git_checkpoint.sh "msg" file...` one-liner 방식. raw multi-line git 블록 금지 패턴 문서화.
- **`scripts/git_checkpoint.sh`** — removed `git add -A` fallback (was policy violation); removed automatic `git push`; added explicit file-required guard and post-commit log output.
- **`.skills/tool-picker/SKILL.md` Sec. 6** — worked example updated to v0.5 Stage 1 live triple (Standard · medium); was v0.3 Stage 2 Strict-hybrid values.
- **`docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 (D4.x2)** — added note that `docs/notes/dev_history.md` was removed in v0.4 (replaced by `CHANGELOG.md`).
- **`docs/notes/decisions.md` D4.x2** — same dev_history removal note added.
- **`prompts/claude/final_review.md`** — removed `§14` section reference.
- **`prompts/claude/code_review.md`** — replaced `§Security` with `"Security" section`.

### Fixed
- **`tests/bundle1/run_bundle1.sh` check 7** — updated assertions from v0.3 (`Stage 2 Plan Draft`, `Strict-hybrid`) to v0.5 (`Stage 1 Brainstorm`, `mode Standard`, `risk_level medium`).
- **`tests/bundle1/run_bundle1.sh` check 10** — CLAUDE read-order hook assertion을 KO only 전환 후 문구에 맞게 substring match로 완화 (EN exact-match → `.skills/tool-picker/SKILL.md` substring).

### Notes
- **`update_handoff.sh` KO header support** — verified already implemented since v0.3. No code change needed.
- **UI base-only policy** — no downstream `has_ui=true` found; policy remains in effect.

## [0.4.0] - 2026-04-23

> Retrospective + simplification meta-release. No new features or bundles. Self-test of "can jOneFlow release something lightly?"

### Added
- **docs/02_planning_v0.4/plan_final.md** — v0.4 단순화 실행 계획 (Stage 2 산출물).
- **docs/01_brainstorm_v0.4/brainstorm.md** — v0.4 회고 + 단순화 방향 브레인스토밍 (Stage 1 산출물).
- **HANDOFF.archive.v0.3.md** — v0.3 HANDOFF 아카이브.

### Changed
- **WORKFLOW.md v2.1** — plan_draft/plan_review 단계 Standard 기본값에서 제거 (plan_final 직행); Stage 11 고위험 작업 한정 + 동일 세션 허용; 세션 쓰기 순서에서 dev_history 제거; 롤백 로깅을 HANDOFF.md + CHANGELOG로 전환; 독립 검증 프로토콜 섹션 재작성 (fresh-session 요구 폐지).
- **CLAUDE.md** — Stage 11 fresh-session 요구 폐지 (고위험 한정 + 동일 세션 허용); git 정책을 3-경우 최소화로 교체 (버전 종료 / 일과 마감 / Claude 판단); 핵심 파일 테이블에서 dev_history → CHANGELOG로 교체.
- **.claude/settings.json schema v0.2** — 에이전트 팀 활성화 (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), tmux 모드, 최신 모델 (claude-sonnet-4-6, claude-opus-4-7).
- **HANDOFF.md** 경량화 — Status + Next + 주의사항 중심으로 재구성; `update_handoff.sh` 호환성 유지.

### Removed
- `docs/notes/dev_history.md` + `docs/notes/dev_history.ko.md` — CHANGELOG.md가 누적 변경 기록 대체.

### Planned for v0.4 (retrospective + simplification release — meta scope, no feature adds)
- **Retrospective** on v0.3 dogfooding experience: catalogue concrete friction points from the 7-session v0.3 build (13 stages × 2 bundles × EN+KO × validation groups × M.1/M.3/M.5/M.6 gates × AC matrices × D4.x frontmatter × R4 freshness × R2 read-only invariant × dual harness).
- **Simplification pass** on the workflow itself — with the working hypothesis that the "default" mode should be materially lighter than v0.3's Strict-hybrid. Candidates for demotion / merger / removal: validation-group joint gates, R4 EN+KO sync rule, D4.x frontmatter, M.3 fresh-session requirement, per-AC cross-bundle matrices, dual EN/KO dev_history.
- **Deliverable shape (tentative)**: one brainstorm doc + one simplification proposal doc; minimal code changes; no new bundles. v0.4 acts as the self-test of "can jOneFlow release something lightly?"

### Planned for v0.5 (inherited backlog from original v0.3 Stage 13 deferrals — feature work resumes)
- Live tool-picker triple refresh in `.skills/tool-picker/SKILL.md` Sec. 6 (AC.B1.5 hygiene; pick the current HANDOFF triple at v0.5 Stage 1).
- `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 verbatim-paste refresh of D4.x2/x3/x4 (AC.B1.8 tightening).
- Install `shellcheck` in the Linux CI runner so `shellcheck -S style scripts/update_handoff.sh` replaces the v0.3 proxy (`sh -n` + `dash -n` + `bash -n`). See `docs/05_qa_release/release_checklist.md` Sec. 1.1 row 1.f.
- Automate mac-side CI (`bash tests/bundle1/run_bundle1.sh`, `sh tests/run_bundle4.sh`, `shellcheck -S style scripts/update_handoff.sh`) so Stage 13 no longer requires an operator paste (v0.3 used release_checklist.md Sec. 1.1 rows 1.g–1.i manual paste).
- Bundle 2 (metadata-refinement, goals 1/2/3) and Bundle 3 (codex-handoff-UX, goals 4/6/8) — re-scope based on v0.3 real-world use (deferred from v0.3; now carried further to sit behind v0.4 simplification decisions).
- Move the v0.2-compatibility `§` section-sign off canonical prompt templates (kept verbatim for v0.2 cross-version use during v0.3).
- **UI base-only policy sunset** — per v0.3 brainstorm Sec. 9 / plan_final: UI base-only stays in effect through v0.5 or first downstream `has_ui=true`, whichever comes first. v0.5 is the nominal sunset anchor.

## [0.3.0] - 2026-04-22

> Released 2026-04-22 (UTC) under a single joint `v0.3` git tag per plan_final M.6. Validation Group 1 = Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β).

### Added

- **Bundle 1 — tool-picker skill** (single-file Anthropic Skill at `.skills/tool-picker/SKILL.md`, 173 lines) with an 8-section body and a decision table covering every `stage × (mode, risk)` intersection across `Standard | Strict | Strict-hybrid` × `medium | medium-high`.
- **Bundle 1 — D1.x reference** `docs/notes/tool_picker_usage.md` + `.ko.md` (46 lines each), the usage companion to the skill.
- **Bundle 4 — POSIX-sh handoff updater** `scripts/update_handoff.sh` (486 lines, shellcheck-clean) with nine discriminated `error=<key>` stdout codes and `.bak.<ts>.<pid>` rollback on failure.
- **Bundle 4 — HANDOFF template** `templates/HANDOFF.template.md`.
- **Bundle 4 — contributor onboarding** `CODE_OF_CONDUCT.md` (Contributor Covenant v2.1), `CONTRIBUTING.md` (12 sections + F-a1 appendix).
- **Bundle 4 — D4.x2/x3/x4 decision ledger** `docs/notes/decisions.md` + `.ko.md` (quotable, verbatim-referenced from Bundle 1 SKILL.md).
- **Bundle 4 — documentation discipline** YAML frontmatter on every Stage-5+ doc (D4.x2), `^bundle(\d+)_(.+)$` folder convention (D4.x3), relative-link + GitHub-anchor rules (D4.x4).
- **Workflow artefacts** `docs/01_brainstorm/`, `docs/02_planning/` (plan_draft/plan_review/plan_final, EN + KO), `docs/03_design/bundle1_tool_picker/technical_design.md` + `bundle4_doc_discipline/technical_design.md` (EN + KO each), `docs/04_implementation/implementation_progress.md` + `.ko.md`, `docs/notes/stage11_dossiers/{bundle1,bundle4,ko_freshness}.md`, `docs/notes/final_validation.md` + `.ko.md`, `docs/05_qa_release/qa_scenarios.md` + `.ko.md`, `docs/05_qa_release/release_checklist.md` + `.ko.md`.
- **Test harnesses** `tests/bundle1/run_bundle1.sh` (10 checks) and `tests/run_bundle4.sh` + `tests/bundle4/test_0{1..4}_*.sh` (4 tests).
- **Kickoff prompts** `prompts/claude/v03/stage5_*_draft.md`, `prompts/claude/v03/stage11_joint_validation_prompt.md`, `prompts/claude/v03/stage12_qa_release_prompt.md`, `prompts/codex/v03/stage8_{bundle1,bundle4,coordination_notes,*_report}.md`.
- **Changelog & SemVer policy** This file, following Keep a Changelog v1.1.0 + SemVer v2.0.0.

### Changed

- **Workflow stages 11/13 semantics** — plan_final M.3 requires a fresh Claude session for Stage 11; M.5 group verdict = worst-of-two; M.6 releases Validation Group 1 under a single joint tag.
- **CLAUDE.md read order** now routes to `.skills/tool-picker/SKILL.md` as the decision surface.

### Fixed

- **AC.B1.6/B1.8 row label swap** in `docs/04_implementation/implementation_progress.md` Stage 9 Bundle 1 verdict table (Stage 12 housekeeping).
- **`rg` → `grep -E`** swap in `tests/bundle1/run_bundle1.sh` line 53 — removes the ripgrep dependency so the harness is POSIX-clean end-to-end (Stage 12 housekeeping).

### Deferred to v0.5 (originally queued for v0.4; reindexed 2026-04-23 when v0.4 was redefined as a retrospective/simplification release)

- Live tool-picker triple refresh in `.skills/tool-picker/SKILL.md` Sec. 6 (Stage 11 non-blocking forward).
- `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 verbatim-paste refresh of D4.x2/x3/x4 (AC.B1.8 tightening, Stage 11 non-blocking forward).

### CI / release prerequisites (run before final tag)

- `shellcheck -S style scripts/update_handoff.sh` on mac + Linux.
- Full test matrix on mac + Linux for both harnesses.
