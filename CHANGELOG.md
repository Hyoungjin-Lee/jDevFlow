# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

> v0.6.1 후속 — D6 Hooks PostToolUse + D7 gstack ETHOS + 조직도 개편 정식 반영.
> brainstorm Sec.8 페르소나 4명 정식 가동 가능.

## [0.6.0] - 2026-04-25

> v0.6 본 릴리스 — **CLI 자동화 레이어**. Cowork 데스크탑(Stage 1) → CLI 오케스트레이터(Stage 2–13) 하이브리드 워크플로 자동화. D1 schema v0.4 → D2 init_project.sh → D3 switch_team.sh → D4 switching.md → D5 ai_step.sh 단일 trail. v0.6.1 D6/D7(Hooks PostToolUse + gstack ETHOS) 이월.

### Added — Stage 1–5 (기획·설계)
- **`docs/01_brainstorm_v0.6/brainstorm.md`** — Stage 1 브레인스토밍. CLI 자동화 레이어, 운영 패턴 3종(desktop-only / desktop-cli / cli-only), team_mode 3종(claude-only / claude-impl-codex-review / codex-impl-claude-review), init_project.sh / switch_team.sh 설계 확정.
- **`docs/02_planning_v0.6/`** — Stage 2–4 기획 산출물 3종 (plan_draft / plan_review / plan_final). Jonelab AI팀 tmux 팀모드로 작성. plan_final 6/6 승인 체크리스트 완료. scope 축소: D6/D7 → v0.6.1, jq 비의존, `pending_team_mode` 제거(R2 설계 제약 commit).
- **`docs/03_design/v0.6_cli_automation/technical_design.md`** — Stage 5 기술 설계 (Opus, 단일 trail D1→D5). AC 12건, 설계 제약 8건(F-D1 / F-D2 / F-D3 / F-n1 / F-n2 / F-n3 / F-2-a / F-5-a) 전량 흡수. Q1(fail-closed 복구) / Q2(pgrep -fl) / Q3(unknown executor exit 2) 답변.
- **`docs/04_implementation_v0.6_stage8/code_review.md`** — Stage 9 코드 리뷰 결과. AC-5-1~5-12(12/12 PASS) + 설계 제약(8/8 PASS) + 보안 + 회귀. **Verdict: APPROVED, 차단 항목 0.**

### Added — Stage 8 구현 (D1~D5)
- **`scripts/lib/settings.sh`** (M1) — `.claude/settings.json` schema v0.4 POSIX 파서/라이터. 공개 API 6종(`settings_path` / `settings_require_v04` / `settings_read_key` / `settings_read_stage_assign` / `settings_write_key` / `settings_write_stage_assign_block`). jq 비의존, temp file → mv atomic write, macOS BSD vs GNU sed 호환(in-place 미사용).
- **`.claude/settings.json` schema v0.4** — 신규 필드 `workflow_mode` + `team_mode` + `stage_assignments`(stage8_impl / stage9_review / stage10_fix / stage11_verify) 추가. v0.3 필드 100% 보존. 1줄 1키 + 2-space 들여쓰기 + 파일 내 유일 키명 규약. **`pending_team_mode` 필드 미포함 [F-D3]**.
- **`scripts/init_project.sh`** (M2) — workflow_mode + team_mode 대화 인터페이스 추가. brainstorm Sec.4 verbatim 2블록(★추천★ 마커 포함, F-n1) 보존. 4 케이스(settings 부재 → heredoc skeleton / v0.3 → awk 신규 필드 삽입 + schema bump / v0.4 → skip / `--force-reinit` → in-place 갱신). v0.5 폴더/dev_history/decisions starter 로직 보존.
- **`scripts/switch_team.sh`** (M3) — 런타임 team_mode 전환 스크립트 (신규). 4분기 인터페이스(대화 / `<mode>` 직접 지정 / `<mode> --force` / `--status`). `pgrep -fl 'claude.*--teammate-mode'` + `(codex-plugin-cc|/codex:(rescue|review|status))` 백그라운드 감지 → 차단(brainstorm Sec.5 L118-123 verbatim, F-n2) 또는 즉시 적용(2분기 모델, F-D3). `--force` 우회 시 운영자 책임. team_mode 변경 시 `stage_assignments` 4 라인 동시 atomic 교체(Sec.2.5 매핑표).
- **`docs/guides/switching.md`** (M3 D4) — 패턴/팀 전환 시나리오 4종(workflow_mode 1→2 / 2→3 / team_mode 1→2 / 2/3→1). 각 전제·커맨드·효과 3요소. 자주 있는 오류 4종 + 권한표 + 관련 스크립트 안내.
- **`scripts/ai_step.sh`** (M4) — Stage 2–13 자동 진행 오케스트레이터로 전면 재작성(550 라인). 6 공개 함수(`ai_step_resolve_executor` / `ai_step_check_complete` 3-signal AND / `ai_step_dispatch` Sec.6.9 안내 메시지 / `ai_step_log_transition` dev_history append / `ai_step_run_next` / `ai_step_run_auto`). 외부 인터페이스 5종(`--stage` v0.5 호환 / `--status` / `--next` / `--auto` / `--resume`). **F-2-a 준수: team_mode 리터럴은 표시 경로(printf/--status)에만, 실행 분기 0건. resolve_executor가 `stage_assignments`만 파싱.** fail-closed: unknown executor → exit 2, 키 누락 → exit 3 (Q3 답). `@openai/codex` CLI 호출 경로 0 (F-n3) — plugin-cc(`/codex:rescue`, `/codex:review`) 안내 메시지 출력만.
- **`tests/v0.6/`** — v0.6 테스트 스위트 신규(13 파일). M1 unit 3건 + M2 verbatim/cases 2건 + M3 block/apply/status/bg 4건 + M4 resolve_executor / check_complete (3-signal AND truth table 8가지) / static_gate (AC-5-5) / auto (E2E `--auto` stage1→2→3→4→5 paused + `--resume` 게이트 통과) 4건. `JDEVFLOW_ROOT` env로 격리. `tests/v0.6/run.sh` harness가 13건 순차 실행.

### Added — 인프라
- **`scripts/setup_tmux_layout.sh`** (세션 16) — Cowork → CLI 오케스트레이터 → 팀원 pane 구조 자동 세팅. 인자: `[session_name] [team_size]`. 가이드 `docs/guides/tmux_layout.md`.
- **`scripts/watch_round1.sh` / `scripts/watch_round2.sh`** — A/B 실험 자동 왓처(M1 검증용).

### Changed
- **`CLAUDE.md` Sec.2.5 조직도** — Cowork(CTO 회의실) → Code(브릿지) → CLI tmux(오케스트레이터) 3계층 정식 반영. 호출 방식 자율 + 운영자 override 정책.
- **`CLAUDE.md` Sec.3 승인 스킵 정책** — AI팀 자율 진행 범위 명시(로컬 파일/빌드/테스트/git add+commit 자동; push/reset/외부 API/.env는 운영자 승인 필수). "Claude 구현 금지" 정책 완화 — 실행자 결정은 `.claude/settings.json` `stage_assignments`만 참조 (team_mode 리터럴 실행 분기 금지 [F-2-a]).
- **`CLAUDE.md` 세션 종료 규칙** — 오케스트레이터가 커밋 직접 실행 (운영자 paste 금지). 세션 종료 시 "바로 다음 세션 / 오늘은 여기까지" 두 가지 옵션 필수 제시.
- **`scripts/init_project.sh`** (M3 부수) — module-level arg 파서를 `_init_parse_args` 함수로 캡슐화 후 `_init_main`에서 호출. switch_team.sh가 source 시 부모 args를 init이 소비하던 충돌 해결. 기존 verbatim/cases 테스트 영향 없음.

### Fixed
- **`scripts/ai_step.sh` `_ai_step_current_stage_marker` BSD sed em-dash 매칭** (M4) — `\(stage[0-9]\+\)` 캡처 그룹이 멀티바이트 em-dash(—, U+2014) 다음에 배치될 때 macOS BSD sed가 매칭 실패. `.*(stage[0-9]+).*` 일반 패턴 + `-E` extended regex로 fix. `--auto` end-to-end 시나리오 활성화.
- **`tests/v0.6/test_switch_team_bg.sh` 환경 의존 가드** (commit `d326795`) — 외부 `claude --teammate-mode` 프로세스(예: 오케스트레이터 자기 자신) 존재 시 case 3 false-block 회피. 테스트 시작 시 `pgrep -fl 'claude.*--teammate-mode' | grep -v jdevflow-bg-test` 검사 → 발견 시 SKIP(exit 0) + 경고. TMPROOT 생성 전 위치(임시 dir leak 방지).

### Notes — 검증
- **v0.6 테스트 13/13 PASS** (M1×3 + M2×2 + M3×4 + M4×4). bg 테스트는 외부 claude 발견 시 SKIP(d326795 가드 의도된 동작).
- **shellcheck CLEAN** — `scripts/lib/settings.sh` + `scripts/init_project.sh` + `scripts/switch_team.sh` + `scripts/ai_step.sh` + `tests/v0.6/test_*.sh` 13건 + `run.sh`. ERROR 0, WARNING 0, INFO 2(false-positive: settings.sh:77 SC1003 단일 따옴표 의도 패턴, test_switch_team_bg.sh:43 SC2329 trap-only invoked).
- **Stage 9 코드 리뷰** — AC-5-1~5-12(12/12 PASS) + 설계 제약 F-D1~F-5-a(8/8 PASS) + 보안 + 회귀 점검. **Verdict: APPROVED. 차단 항목 0.** ⚠ **운영자 사후 `/codex:review` 검증 권장** (settings.json `stage9_review=codex` 정책상 — 본 세션 환경 제약으로 Claude Opus 독립 self-review로 대체).
- **v0.3 → v0.4 호환성 (F-5-a)** — 라이브 `.claude/settings.json` 마이그레이션 시 `agents.*` / `env` / `language` / `teammateMode` 0 bytes diff 확인.

### Commits — D1~D5 단일 trail
- `15b663a` — feat(v0.6): M1 Round 2 Claude 구현 — D1 schema v0.4 + scripts/lib/settings.sh
- `630fc3e` — feat(v0.6): D2 init_project.sh 대화 + POSIX 쓰기 (M2)
- `16d0934` — feat(v0.6): D3 switch_team.sh + D4 switching.md (M3) + 4 tests
- `e7153ea` — feat(v0.6): D5 ai_step.sh 오케스트레이터 (stage_assignments 기반) — M4 + tests 4종
- `d326795` — fix(v0.6/tests): switch_team_bg 환경 의존 가드 (외부 claude --teammate-mode 시 SKIP)

### Non-goal (v0.6 본 릴리스에서 제외)
- D6 Hooks PostToolUse / D7 gstack ETHOS — v0.6.1 이월 [F-D1].
- `@openai/codex` CLI 오케스트레이터 자동화 — 수동 보조 전용 [F-n3].
- settings.json 자동 마이그레이션 도구 — `init_project.sh --force-reinit` 수기 경로로 충분.
- Goal 1 언어 선택 마법사 / Goal 4 `.skills/examples/` 확장 — 글로벌 공개 버전 이연.
- 웹/UI 대시보드 — v0.6 이후 첫 실전 프로젝트 주제.

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

> Retrospective + simplification meta-release. No new features or bundles. Self-test of "can jDevFlow release something lightly?"

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
- **Deliverable shape (tentative)**: one brainstorm doc + one simplification proposal doc; minimal code changes; no new bundles. v0.4 acts as the self-test of "can jDevFlow release something lightly?"

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
