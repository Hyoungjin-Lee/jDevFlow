# jDevFlow v0.3 — New-Session Kickoff Prompt

> 복사해서 새 Claude 세션의 첫 메시지로 붙여넣으세요.
> This is the canonical entry prompt for starting v0.3 work in a fresh session.

---

## Copy-paste block (Korean primary)

```
jDevFlow v0.3 작업을 새 세션에서 시작할게.

경로: ~/projects/Jonelab_Platform/jDevFlow/
(또는 네가 작업하는 로컬 경로로 바꿔줘)

먼저 다음 파일을 순서대로 읽어줘:
1. CLAUDE.md          ← 운영 규칙 / 보안 / 역할 분리
2. HANDOFF.md         ← 현재 모드, 최근 변경, 다음 작업
3. WORKFLOW.md        ← 계층형 모델 (Lite/Standard/Strict) + 13단계 Canonical Strict Flow
4. README.md 의 Roadmap 섹션 ← v0.3 범위

## v0.2 상태 (이 세션 시작 전 완료)
- 계층형 워크플로우(Lite / Standard / Strict) 도입 — WORKFLOW.md v2.0
- stage type / 실행 조건 / 완료 기준 / 재진입 규칙 문서화
- prompts/claude/*.md (brainstorm, planning_draft/review/final, technical_design,
  code_review, final_review, qa) 모두 v0.2 모드 인식 버전으로 갱신
- .skills/ 행동 계약 라이브러리 + 스타터 템플릿 + safe-script-run 예시
- docs/notes/session_bootstrap.md, workflow_eval_plan.md 초안
- ATTRIBUTION.md (obra/superpowers 크레딧)
- HANDOFF.md 템플릿에 Workflow mode / has_ui / risk_level 필드 추가

## v0.3 Stage 0 상태 (이 세션 시작 전 완료 — 재작업 금지)
- **확정 결정 D-A ~ D-D** (본 문서 하단 "확정 결정" 섹션 참조)
  → Stage 1 Brainstrom 에서 재논의 대상 아님. 전제로 들어감.
- `.skills/tool-picker/SKILL.md` 생성 완료 (8섹션 + Recommendation Matrix).
  Stage 5·6·8 진입 시 반드시 참조.
- `.claude/tools.json` scaffold 생성 (빈 카탈로그, D-C 저장소 중 영구 측)
- `prompts/claude/brainstorm.md` — Stage 5 tool-picker 포워드 레퍼런스 추가됨
- `README.md` / `README.ko.md` 로드맵 v0.3 항목 = 12개 (이 문서 목표 리스트와 동일)
- 상세 스냅샷: `docs/notes/2026-04-21-v0.3-kickoff-state.md`

## v0.3 목표 (이 세션에서 할 일 후보)
1. 최초 실행 시 언어 선택 마법사
   - scripts/init_project.sh 를 --lang ko|en 플래그 + 대화형 선택으로 확장
   - .claude/language.json 자동 기록, 이후 세션에서 이 값을 읽어 한/영 프롬프트 선택
2. 자동 워크플로우 eval 러너
   - docs/notes/workflow_eval_plan.md 의 E-M-*, E-R-*, E-C-* 시나리오를
     Python/Shell 스크립트로 구조화 (tests/evals/*.yaml 또는 *.md)
   - scripts/run_evals.sh 로 수동 실행 + 결과를 docs/notes/eval_runs/ 에 저장
3. 세션 부트스트랩 훅 레퍼런스 구현
   - Claude Code / Cowork 용 session-start hook 샘플 파일
   - docs/notes/session_bootstrap.md §4 "Hook-ready design" 과 정합
4. .skills/examples/ 확장
   - api-client, report-generator, safe-deploy 각 1개씩
   - 모두 When to Use / Do / Don't / Red Flags / Good-Bad / Checklist / Verification 8섹션
5. HANDOFF.md 자동 작성 스크립트
   - scripts/update_handoff.sh <mode> <stage> <summary> 형태
   - 마지막 섹션의 "Next Session Prompt" 자동 갱신
6. 모드 선택 의사결정 트리 스킬
   - .skills/mode-picker/SKILL.md
   - Lite / Standard / Strict 판정 기준을 Stage 1 시작 시 Claude 가 항상 참조
7. Stage 6·7 (UI) 프롬프트 v0.2 수준으로 강화
   - prompts/claude/ui_requirements.md, ui_flow.md 에
     Runs-in / 완료 기준 체크리스트 / 모드별 깊이 / 재진입 규칙 추가
   - Stage 2~5, 9, 11, 12 와 동일한 섹션 구조로 맞춤
8. ai_step.sh + zsh_aliases.sh 모드 인식 CLI
   - `aib --lite`, `aipd --standard`, `aitd --strict` 등 플래그 파싱
   - 모드별 프롬프트 분기 (예: Lite 면 brainstorm 인라인 노트 템플릿 출력)
   - 플래그가 없으면 HANDOFF.md 의 현재 모드를 자동으로 사용
9. CHANGELOG.md 작성 + 유지 규칙
   - Keep a Changelog v1.1.0 포맷
   - v0.1 → v0.2 마이그레이션 노트 (tiered workflow, .skills/, prompts 전면 개편)
   - CLAUDE.md §3 근처에 "매 릴리스마다 CHANGELOG 갱신" 규칙 추가
10. CONTRIBUTING.md 분리 + CODE_OF_CONDUCT.md
    - README.md 의 "Contributing" 섹션을 CONTRIBUTING.md 로 분리
    - Contributor Covenant v2.1 기준 CoC 채택
    - 공개 Git push 이전에 반드시 존재해야 함
11. Stage 8 (Implementation) 구현 주체 선택 질문
    - Claude 가 Stage 8 진입 시 사용자에게 질문 (AskUserQuestion 또는 프롬프트 내 선택지):
        * Codex (추천 — 복잡/대규모 코딩)
        * Claude (Sonnet, 단순/소규모 변경일 때)
        * 기타 (선택 시 직접 입력)
    - "추천" 로직은 상황 의존:
        - 수정 라인 > 50, 다중 파일, 새 파일 → Codex 추천
        - ≤ 10 줄, 단일 함수, Lite 모드 → Claude 추천
        - 애매 → Codex 추천 (기본값)
    - 선택 결과는 docs/notes/dev_history.md 에 "Stage 8 executor: Codex | Claude | custom:<name>" 로 기록
12. Stage 6·7 UI 툴 선택 질문 (UI 단계 방향성은 이 세션에서 결정해야 함 — 아래 "오픈 질문" 참조)
    - Stage 6 진입 시:
        * Google Antigravity (추천 — 빠른 와이어프레임)
        * Claude Design (마크다운/간단한 JSX)
        * Figma (정식 디자인 자산)
        * 기타 (선택 시 직접 입력)
    - 선택에 따라 ui_requirements.md / ui_flow.md 에 "Tool: X" 필드 + 그 툴에 맞는 입력 사양 섹션 자동 추가
    - 추천 변동 규칙은 `.skills/tool-picker/SKILL.md` 로 외부화 (mode + has_ui + 디자인 복잡도 입력)

## 작업 진행 규칙
- 전체 v0.3 자체를 하나의 **Strict 모드 jDevFlow 프로젝트**로 취급해 줘.
  (즉, 이 템플릿이 자기 자신에게 적용되는 메타 프로젝트)
- 12개 목표를 한 번에 하지 말고, 먼저 Stage 1 (Brainstorm) 으로 들어가서
  mode / has_ui / risk_level / 범위 / 우선순위를 나와 함께 정해줘.
- has_ui 는 false 로 가정해도 됨 (jDevFlow 자체는 CLI/문서 템플릿). 단, **목표 12는
  UI 단계 설계**이므로 "jDevFlow 사용자 프로젝트에서 UI 가 켜졌을 때" 를 전제로 토론.
- 2번(eval 러너), 5번(HANDOFF 자동화), 8번(ai_step 현대화) 은 실제 Python/Shell
  코드가 들어가니까 Stage 8 은 반드시 Codex 로 넘겨줘 (Claude 는 직접 구현하지 않음).
- 11번(구현 주체 선택), 12번(UI 툴 선택) 은 아래 "확정 결정 (D-A~D)" 가
  이미 합의된 상태 — Stage 1 Brainstorm 에서 재논의 대상이 아님.
  Stage 5 (Technical Design) 입력으로 그대로 사용.
- `.skills/tool-picker/SKILL.md` (v0.3 Stage 0 산출물) 이 이미 있으면 Stage 5·6·8
  진입 시 반드시 먼저 읽을 것.

## 확정 결정 (ChatGPT 토론 후 사용자 승인 — 2026-04-21)

v0.3 Stage 1 Brainstorm 에서 오픈 질문이 아니라 **전제** 로 들어간다.
근본적 문제 발견 시에만 Stage 4.5 사용자 승인 게이트에서 재검토.

### D-A. UI 단계에서 Claude 의 역할 — **Model A**
- Claude 가 `ui_requirements.md` / `ui_flow.md` 로 사양 작성
- 사용자 또는 선택된 UI 툴 (Antigravity / Figma / Claude Design) 이 실제 UI 제작
- Claude 가 Stage 9 의 UI 버전으로 리뷰
- 향후 확장: `ui_auto` 모드일 때만 MCP 를 통한 Claude 직접 조작 허용 (v1.0 스코프)

### D-B. 추천 로직 위치 — **`.skills/tool-picker/SKILL.md`**
- 입력: `mode`, `has_ui`, `change_size`, `design_complexity`
- 출력: `executor`, `ui_tool`, `reason` (1줄)
- Stage 5·6·8 진입 시 Claude 가 항상 같은 스킬 참조 → 결정 일관성
- 프롬프트에 if-then 하드코딩 금지 (중복·드리프트 방지)

### D-C. 커스텀 입력 저장 — **B + C 혼합**
- `.claude/tools.json` (프로젝트 스코프 카탈로그): 사용자가 등록한 커스텀 도구,
  선호 executor, 기본값 — **영구**
- `HANDOFF.md` "current tools" 필드: 현재 작업 사이클에서 실제로 고른 값
  (Stage 8 executor, Stage 6 UI tool) — **세션 상태**
- 두 소스는 대체관계가 아닌 보완관계 (카탈로그 ≠ 현재 선택값)
- 글로벌 유저 프로필 (`~/.claude/tools.json`) 은 v1.0 스코프

### D-D. Stage 10 (Revision) 재질문 — **조건부**
- Stage 9 리뷰 verdict = "minor" / "bug fix" → Stage 8 executor 유지
- Stage 9 리뷰 verdict = "design-level" (아키텍처 / 스키마 / UI 흐름 재설계)
  → Stage 10 진입 시 `.skills/tool-picker` 재실행 후 주체 재질문
- 재실행 트리거는 `.skills/tool-picker/SKILL.md` §Recommendation Matrix 에 명시

## 질문으로 시작해줘
위 파일 4개를 읽고 나면, 이렇게 물어봐 줘:
- "v0.3 를 Strict 모드로 진행할까, 각 항목을 Standard 로 쪼갤까?"
- "12개 목표 중 이번 세션에서 커버할 우선순위 3~4개는?
   (특히 UI 단계 설계(12번) 를 포함할지)"
- "확정 결정 D-A~D 를 읽고 이해했는지 — 특히 D-C(B+C 혼합 저장) 와
   D-D(조건부 재질문) 가 HANDOFF.md / `.claude/tools.json` 스키마에 미치는 영향"
- "eval 러너(2번) 를 위해 Python 이 가능한 환경인지 확인해도 될까?"

바로 코드 쓰지 말고, 위 질문부터 해줘.
```

---

## Copy-paste block (English alternative)

```
I'm starting jDevFlow v0.3 work in a fresh session.

Path: ~/projects/Jonelab_Platform/jDevFlow/
(replace with your actual local path)

Please read these files in order first:
1. CLAUDE.md          ← operating rules / security / role separation
2. HANDOFF.md         ← current mode, recent changes, next tasks
3. WORKFLOW.md        ← tiered model (Lite/Standard/Strict) + 13-stage canonical flow
4. Roadmap section of README.md ← v0.3 scope

## v0.2 state (completed before this session)
- Tiered workflow (Lite / Standard / Strict) introduced — WORKFLOW.md v2.0
- stage types / execution conditions / completion criteria / re-entry rules documented
- All prompts/claude/*.md (brainstorm, planning_draft/review/final, technical_design,
  code_review, final_review, qa) upgraded to the v0.2 mode-aware version
- .skills/ behavior-contract library + starter template + safe-script-run example
- docs/notes/session_bootstrap.md, workflow_eval_plan.md initial drafts
- ATTRIBUTION.md (obra/superpowers credit)
- HANDOFF.md template gained Workflow mode / has_ui / risk_level fields

## v0.3 Stage 0 state (completed before this session — do NOT redo)
- **Resolved decisions D-A ~ D-D** (see "Resolved decisions" block further down)
  → NOT open questions anymore. They enter Stage 1 Brainstorm as premises.
- `.skills/tool-picker/SKILL.md` created (8 sections + Recommendation Matrix).
  Must be consulted at Stage 5 / 6 / 8 entry.
- `.claude/tools.json` scaffold created (empty catalog; the persistent half of D-C storage)
- `prompts/claude/brainstorm.md` — Stage 5 tool-picker forward reference added
- `README.md` / `README.ko.md` roadmap v0.3 entry = 12 items (matches the goals list below)
- Full snapshot: `docs/notes/2026-04-21-v0.3-kickoff-state.md`

## v0.3 goals (candidates for this session)
1. First-run language-selection wizard
   - extend scripts/init_project.sh with --lang ko|en + interactive prompt
   - write .claude/language.json, later sessions read it to pick EN/KO prompts
2. Automated workflow-eval runner
   - structure the E-M-*, E-R-*, E-C-* scenarios in workflow_eval_plan.md into
     tests/evals/*.yaml (or *.md) files
   - scripts/run_evals.sh for manual runs, results into docs/notes/eval_runs/
3. Session-bootstrap hook reference implementation
   - sample session-start hook files for Claude Code / Cowork
   - consistent with docs/notes/session_bootstrap.md §4 "Hook-ready design"
4. .skills/examples/ expansion
   - api-client, report-generator, safe-deploy — one each
   - each with all 8 sections (When to Use / Do / Don't / Red Flags / Good-Bad / Checklist / Verification)
5. HANDOFF.md auto-writer script
   - scripts/update_handoff.sh <mode> <stage> <summary>
   - refreshes the "Next Session Prompt" tail section
6. Mode-selection decision-tree skill
   - .skills/mode-picker/SKILL.md
   - the Lite / Standard / Strict decision rubric, auto-read at Stage 1
7. Stage 6 / 7 (UI) prompts upgraded to v0.2 parity
   - add Runs-in / completion checklist / mode-depth / re-entry rules
   - match the section structure of Stages 2–5, 9, 11, 12
8. ai_step.sh + zsh_aliases.sh mode-aware CLI
   - parse `--lite`, `--standard`, `--strict` flags
   - branch prompt by mode (e.g., Lite prints the inline brainstorm note template)
   - fall back to HANDOFF.md current mode if no flag given
9. CHANGELOG.md + discipline
   - Keep a Changelog v1.1.0 format
   - v0.1 → v0.2 migration notes (tiered workflow, .skills/, prompt overhaul)
   - add a "bump on every release" rule near CLAUDE.md §3
10. CONTRIBUTING.md split + CODE_OF_CONDUCT.md
    - move README's "Contributing" section into CONTRIBUTING.md
    - adopt Contributor Covenant v2.1
    - must exist before public Git push
11. Stage 8 implementer picker
    - On Stage 8 entry, ask the user:
        * Codex (recommended — complex / multi-file)
        * Claude (Sonnet, for small single-function changes)
        * Custom (free-form)
    - "Recommendation" depends on context:
        - > 50 changed lines, multi-file, new file → Codex
        - ≤ 10 lines, single function, Lite mode → Claude
        - ambiguous → Codex (default)
    - Record choice in docs/notes/dev_history.md as
      "Stage 8 executor: Codex | Claude | custom:<name>"
12. Stage 6 / 7 UI-tool picker (UI direction must be decided this session — see Open Questions below)
    - On Stage 6 entry, ask:
        * Google Antigravity (recommended — fast wireframes)
        * Claude Design (Markdown / JSX snippets)
        * Figma (formal design assets)
        * Custom (free-form)
    - Based on choice, add "Tool: X" field + tool-specific input spec section to
      ui_requirements.md / ui_flow.md
    - Externalize the variable-recommendation logic into `.skills/tool-picker/SKILL.md`

## Rules for this session
- Treat v0.3 itself as one **Strict-mode jDevFlow project**
  (the template applied to itself — a meta-project).
- Don't attack all 12 at once. Start with Stage 1 (Brainstorm) and let's agree
  on mode / has_ui / risk_level / scope / priority together.
- has_ui = false for jDevFlow itself (it is a CLI/doc template), BUT goal 12
  is UI design for *downstream user projects* — keep that distinction clear.
- Goals 2, 5, 8 contain real Python/Shell code — Stage 8 MUST be handed to
  Codex; Claude does not implement directly.
- Goals 11 and 12 are **already decided** (see "Resolved decisions D-A~D" below).
  Not open questions anymore — they are preconditions for Stage 5.
- `.skills/tool-picker/SKILL.md` (v0.3 Stage 0 output) must be read at
  Stage 5 / 6 / 8 entry if it exists.

## Resolved decisions (agreed with user on 2026-04-21 after ChatGPT cross-review)

These enter v0.3 Stage 1 Brainstorm as **premises**, not open questions.
Revisit only via Stage 4.5 approval gate if a fundamental issue surfaces.

### D-A. Claude's role at the UI stage — **Model A**
- Claude writes the spec (`ui_requirements.md`, `ui_flow.md`)
- User or the chosen tool (Antigravity / Figma / Claude Design) produces the UI
- Claude reviews the output as the Stage 9 UI counterpart
- Future: Model-B-like MCP direct driving is allowed only when `ui_auto` mode is on (v1.0 scope)

### D-B. Recommendation logic lives in — **`.skills/tool-picker/SKILL.md`**
- Inputs: `mode`, `has_ui`, `change_size`, `design_complexity`
- Outputs: `executor`, `ui_tool`, `reason` (one line)
- Claude reads this skill at Stage 5 / 6 / 8 entry → consistent decisions
- No hard-coded if-then inside prompts (prevents duplication and drift)

### D-C. Custom entry storage — **B + C hybrid**
- `.claude/tools.json` (project-scoped catalog): user-registered custom tools,
  preferred executor, defaults — **persistent**
- `HANDOFF.md` "current tools" field: what was actually picked for the current
  work cycle (Stage 8 executor, Stage 6 UI tool) — **session state**
- Not alternatives but complements (catalog ≠ current selection)
- Global user profile (`~/.claude/tools.json`) is v1.0 scope

### D-D. Stage 10 (Revision) re-ask — **conditional**
- Stage 9 verdict = "minor" / "bug fix" → keep Stage 8 executor, skip the skill
- Stage 9 verdict = "design-level" (architecture / schema / UI flow rework)
  → re-run `.skills/tool-picker` at Stage 10 entry, re-ask executor
- The re-run trigger is documented in `.skills/tool-picker/SKILL.md`
  §Recommendation Matrix

## Open with questions
After reading the 4 files above, please ask me:
- "Run v0.3 as one Strict project, or split each goal into its own Standard task?"
- "Which 3–4 of the 12 goals should this session cover (especially whether
   to include goal 12, UI-stage design)?"
- "Confirm you've read Resolved decisions D-A~D — in particular D-C (hybrid
   storage) and D-D (conditional re-ask) affect the HANDOFF.md schema and
   `.claude/tools.json` shape."
- "For goal 2 (eval runner), may I confirm Python is available in your env?"

Do not write code before these questions are answered.
```

---

## Notes for the session operator

- The prompt assumes `CLAUDE.md`, `HANDOFF.md`, `WORKFLOW.md` are already the v0.2 versions in this repo. If you restart from an older copy, the prompt's "v0.2 state" section will be wrong — update it before sending.
- The prompt intentionally forbids code-before-questions. Stage 1 is the mode decision. Do not let Claude skip to Stage 8.
- If Claude starts writing code without asking the three opening questions, stop it and paste back: "Stage 1 first — please run Brainstorm per WORKFLOW.md §3 before any other action."
- If you want to run only ONE of the six goals (e.g., just goal 1), replace the "v0.3 goals" section with just that goal; the rest of the prompt scaffolding still works.
