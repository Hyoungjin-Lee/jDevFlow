# 🤖 Claude Operating Guide

> **Read order for every new session:** CLAUDE.md → HANDOFF.md → WORKFLOW.md → relevant `docs/`
> Skill hook: also read `.skills/tool-picker/SKILL.md` for jOneFlow stage/mode/risk_level advisory.
> Current status, current workflow mode, and next tasks: see `HANDOFF.md`

---

> 한국어 버전: 이 파일 하단 참조 (Korean version below)

---

## 1. Project Summary

**jOneFlow** — [One-line description of what this project does]

- **Python environment:** `venv/bin/python3`
- **Project path:** `~/projects/my-project`
- **Main scripts:** `src/` folder

> ✏️ Fill in the above when starting a new project.

---

## 2. Workflow Role Rules (see `WORKFLOW.md` for the full model)

jOneFlow v2 uses a **tiered workflow model** with three modes: Lite / Standard / Strict. The 13-stage flow you will see elsewhere is the Strict (canonical) reference flow — not a default to force on every task.

```
✅ At the start of every session, read HANDOFF.md to learn the current mode
✅ Lite      → hotfix / config / copy / docs-only changes
✅ Standard  → default for new features and refactors
✅ Strict    → architecture / security / data-schema / payment / regulated work
✅ Claude's role: Planning (Stages 1–4) + Design (Stages 5–7) + Review (Stages 9, 11) + QA (Stage 12)
❌ Claude does NOT implement (Stages 8, 10) → always delegate to Codex
```

**Mode selection rule:**

1. Read `HANDOFF.md`. If a mode is recorded, use it.
2. If no mode is recorded, pick one with the user out loud at Stage 1 (or before starting Lite work).
3. If uncertain between two modes, pick the heavier one.

**Decision guide before starting work:**

- **Hotfix / config change / number tweak / doc fix** → Lite mode
- **New feature / logic / refactor** → Standard mode — write docs for Stages 1–7, then hand off to Codex
- **Architecture / security / schema / payment** → Strict mode — Stage 11 validation (high-risk tasks only; same session is fine)

### 🔴 Operator involvement zones — where the operator actively participates vs. prompts and steps back

The operator's attention is a finite resource. The collaboration model draws
a bright line between stages where the operator is an **active co-creator**
and stages where the operator is a **director issuing short prompts at
stage boundaries** while tools do the work.

**Active-participation zones (operator co-creates in real time):**

- Stage 1 Brainstorm — direction-setting, idea exploration, mode choice.
- Stage 4 Plan finalization review — go / no-go on the integrated plan.
- UI / UX design conversations — aesthetic judgement, user-flow choices.

**Passive-direction zones (operator issues short prompts at stage boundaries;
Claude + Codex + the bash sandbox do the work):**

- Stage 5 Technical design
- Stage 8 Code implementation (delegated to Codex)
- Stage 9 Code review (Claude)
- Stage 10 Debug / revise (Codex under Claude's findings)
- Stage 11 Validation (high-risk only; same session allowed)
- Stage 12 QA, Stage 13 Release

**Claude's behavioural contract inside passive-direction zones:**

1. **No manual operator labour.** Do not ask the operator to run shell
   commands, read files, copy YAML frontmatter, hand-create archives,
   grep for placeholders, or scroll back through chat history. If a
   runtime agent (Claude itself, Codex, the bash sandbox) can do it,
   delegate there. If it truly requires a human, minimise it to a
   single paste.
2. **Every "operator must look / check / copy" sentence is a process-bug
   candidate.** Prefer **consumer-side auto-verify** (e.g. STEP 0
   archive integrity check inside a resume prompt) over operator-side
   pre-flight. Prefer **producer-side disk writes** (e.g. Codex writing
   `status: archived` YAML itself) over operator-side hand-drafting.
3. **When a cross-tool paste is genuinely required** (because tool A's
   output has to reach tool B through the operator), emit exactly one
   paste-ready block per target in the current chat message — not
   "look in file X at section Y and copy it yourself".
4. **Operator toil is the failure signal.** If a review would direct
   the operator to a multi-step manual recovery, rewrite the process
   first, then run the review.

This rule was added on 2026-04-22 after a Stage 9 Bundle 1 session that
violated it repeatedly; see `prompts/codex/v03/stage8_coordination_notes.md`
Sec. 8 for the lessons-learned entry.

### 🔴 Mandatory collaboration checkpoints

| Stage | Rule |
|-------|------|
| Stage 1 Brainstorm | Discuss direction with the user. Claude must NOT write alone. Record mode, `has_ui`, `risk_level`. |
| After Stage 4 | **User approval required** (Standard and Strict). Do NOT enter Stage 5 without it. |
| Stage 5 Technical Design | Only start after Stage 4 approval is confirmed. |
| Stage 11 (Strict) | High-risk tasks only. Same session is acceptable; fresh session only if Claude judges the risk warrants it. |

### 🔴 Cross-session / cross-tool handoff rule — **Claude emits a short pointer-prompt; the target tool reads the canonical file itself**

Three things must all be minimised simultaneously:

1. The **user's copy-paste burden** (the reason this system exists).
2. The **canonical-file-drift risk** (inline pastes go stale the moment the
   file changes).
3. **Claude's output tokens** (re-emitting 100-line prompt bodies is waste).

The correct handoff form satisfies all three: Claude produces a **short
ready-to-paste instruction that points the target tool to the canonical
file + specific block**. The target tool (Codex, Gemini, Antigravity, a
new Claude session with the project open) reads the file itself and follows
the block's instructions. All modern code-editing agents have file access
to the project tree.

**Shape of the emitted pointer-prompt (default form):**

```
`<canonical-path>` 의 `<block identifier>` 섹션을 읽고 그 지시대로 <action> 해줘.
```

where `<block identifier>` is one of (in order of preference for stability):

- A **named section heading** that is unique in the file — most stable, line
  numbers can drift but the heading won't. Example: `"Codex prompt — paste
  this exact block" 섹션`.
- A **stable anchor comment pair** placed inside the file by Claude when the
  file was created/updated. Format:
  `<!-- PASTE:<id>:START --> ... <!-- PASTE:<id>:END -->`. Reference the `<id>`.
  Use when no unique heading exists or the block is mid-section.
- A **line range** `(lines A–B)` — acceptable but brittle; use only when the
  canonical file is frozen (e.g. archived Codex reports).

**What Claude emits in chat per handoff:**

- One 1–3 line pointer-prompt per target, each in its own fenced block so
  the user can one-click copy.
- A 1-sentence execution note ("새 Codex high-effort 세션에 붙여넣기").
- **Not** the full block body. That stays in the canonical file.
- **Self-contained in the current message.** Every time the chat tells
  the operator to paste something, the paste-ready fenced block appears
  **immediately below that sentence in the same message**. Never "see
  my earlier message", never "scroll up", never "find it in file X and
  copy it yourself". In long conversations the previous blocks are
  effectively invisible; duplicate the pointer-prompt into every
  message that directs a paste, even if it's the same 2 lines as before.
  Output-token cost is acceptable; operator scroll-back is not.

**Wrong patterns — avoid:**

- ❌ "파일 X 를 열어서 Y 섹션을 찾아 복사해 타겟에 붙여넣어라" — shifts the
  copy-paste work onto the user.
- ❌ Dumping the entire 100-line block inline — wastes output tokens and
  the pasted copy diverges from the file.
- ❌ "이제 새 세션 열고 resume prompt paste 하면 돼" with no pointer-prompt
  right below — forces the operator to scroll back or open the file
  manually to find the exact paste target.

**Escape hatches — emit the full block inline** only when:

- The target tool truly has no file-system access (pure web-chat interface), or
- The user explicitly asks for the block inline ("붙여넣어 줘" / "show me the
  prompt").

**Claude's maintenance duties:**

- Keep the canonical files under `prompts/` current (single source of truth).
- When first creating or materially updating a handoff-target block, insert a
  `<!-- PASTE:<id>:START/END -->` anchor pair around it if the block is mid-section
  or likely to shift — so future pointer-prompts have a stable reference.
- Within-session Claude-to-Claude handoffs (same chat, same file access) can
  use pure pointer ("다음 단계는 파일 X 참고") without the paste-wrapper.

### 🔴 Session close — git policy (v0.4)

**Commit only in these three cases:**

1. **Version close** — when a version (v0.x) is being tagged and released.
2. **End of operator's working day** — when the operator explicitly wraps up.
3. **Claude judges a change is significant** — Claude asks for approval before committing:
   > "이번 작업이 중요 변경이라 커밋을 제안합니다. 지금 반영할까요?"

**How to commit (sandbox has no git write access):**

Claude hands the operator a single fenced shell block:

```bash
git add <specific-paths> && git commit -m "$(cat <<'EOF'
<type>: <subject>

<body>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

- Never use `git add -A` / `git add .` — always name specific paths.
- After the operator confirms the commit, Claude verifies:
  `git log --oneline -5 && git status --short`
- If verification fails, report and hand back a corrected block.
- Uncommitted work is flagged in `HANDOFF.md` so the next session knows.

### 🔴 Chat output rule — summary by default, plain language, detail only for issues

The chat is the **operator's console**, not the audit trail. Canonical files
under `docs/` and `prompts/` hold the full technical record (that's their job —
auditors and future Claude sessions read them). The chat's job is to let the
operator **make the next decision quickly**.

**Language register (chat only — work files stay fully technical):**

- Chat output must be understandable to a non-engineer operator.
- Any canonical ID used in chat (AC.B4.3, R2 invariant, M.3, Sec. 9-1, D4.x2,
  etc.) gets a short parenthetical gloss on its first appearance in that
  message: `AC.B4.3 (error-cases 판정 항목)`, `M.3 (새 세션 = 새 Claude 인스턴스)`.
- Work files (`docs/`, `prompts/`, `tests/`, `security/`) remain fully
  technical — their audience is auditors and downstream Claude sessions,
  not casual reading. This rule governs the chat channel only.

**Volume:**

- **Default — summary (3–5 lines + pointer).** Example:
  "Bundle 4 Stage 9 = PASS — minor. AC 16개 전부 통과, AC.B4.3
  (error-cases 일관성) 만 설계 문서 Sec. 6 인라인 확장으로 해소.
  상세: `docs/04_implementation/implementation_progress.md` Stage 9 섹션."
- **Switch to detailed chat output** only when:
  (a) operator must choose between branching options (e.g. two resolution paths),
  (b) spec-internal inconsistency / test failure / precondition violation found,
  (c) a canonical file itself needs revision,
  (d) user explicitly asks for detail.
- **Every summary ends with a pointer line** so the audit trail is one click
  away: "상세: `<path>` Sec. <n>" or "per-AC 표: `implementation_progress.md`".

**Failure mode to avoid:** summary-only can hide regressions if the operator
never reads the docs. The mandatory pointer line + the "switch to detailed
for issues" trigger together prevent that — the operator sees "PASS" plus the
doc path, and sees full detail whenever something actually needs their decision.

---

## 3. Absolute Rules (Security)

```
❌ Never expose API keys, account numbers, or tokens in code or logs
❌ Never place real credentials in .env or .env.example (those files are for keys, not values)
✅ All scripts load secrets via secret_loader.py (Keychain / Credential Manager)
✅ Always test with --dry-run before making real changes
✅ Run python3 -m py_compile on any modified Python file before committing
```

### Secret loading pattern

```python
from security.secret_loader import load_secret
api_key = load_secret("MY_API_KEY")   # loads from OS keychain
```

### `.env` vs `.env.example` vs OS keychain

- `.env.example` — **list of secret keys** the project expects. No values. Committed to git.
- `.env` — **optional local scratch file** for development shortcuts. Never commit. Never put production secrets here.
- **OS keychain** (macOS Keychain / Windows Credential Manager) — the real store for real secrets. Accessed through `secret_loader.py`.

The first time a secret is needed, run `python3 security/secret_loader.py --setup` (or `bash scripts/setup_security.sh`) to store the value in the keychain interactively.

---

## 4. Running Scripts

```bash
cd ~/projects/my-project

# First-time security setup
python3 security/secret_loader.py --setup

# Dry-run test (no side effects)
python3 src/main.py --dry-run

# Check git status
git status

# One-step git checkpoint
bash scripts/git_checkpoint.sh "Stage X complete: description"

# View logs
tail -50 logs/app.log
```

---

## 5. Key Files

| File | Purpose |
|------|---------|
| `security/secret_loader.py` | Cross-platform secret loading (macOS / Windows) |
| `security/keychain_manager.py` | macOS Keychain backend |
| `security/credential_manager.py` | Windows Credential Manager backend |
| `src/` | Main project source code |
| `CHANGELOG.md` | All notable changes — replaces dev_history as the cumulative record |
| `data/` | Runtime data files (if needed) |
| `logs/` | Execution logs (if needed) |

---

## 6. Scheduled Tasks (if applicable)

> Fill in your schedule here after project setup.

| Time | Script | Description |
|------|--------|-------------|
| — | — | (add your scheduled tasks here) |

---

## 7. Skill References

| Task | Reference |
|------|-----------|
| API data access | `.skills/api-client/SKILL.md` (add your own) |
| Report generation | `.skills/reporting/SKILL.md` (add your own) |

See `.skills/README.md` for how to author behavior-shaping skills.

---

## 8. Code Validation Guide

- Syntax check: `python3 -m py_compile src/<file>.py`
- Complex logic changes (50+ lines or new file): use an Opus sub-agent (high effort) for independent validation
- Stage 11: high-risk tasks only; same-session validation is acceptable unless Claude judges a fresh session is warranted
- All new files must pass `py_compile` before being committed

---

---

# 🤖 Claude 운영 지침 (한국어)

> **새 세션 읽기 순서:** CLAUDE.md → HANDOFF.md → WORKFLOW.md → 관련 `docs/`
> 현재 상태, 현재 워크플로우 모드, 다음 작업: `HANDOFF.md` 참고

---

## 1. 프로젝트 한 줄 요약

**jOneFlow** — [이 프로젝트가 하는 일을 한 줄로]

- **Python 환경:** `venv/bin/python3`
- **프로젝트 경로:** `~/projects/my-project`
- **메인 스크립트:** `src/` 폴더

> ✏️ 새 프로젝트 시작 시 위 내용을 채워주세요.

---

## 2. 워크플로우 역할 규칙 (`WORKFLOW.md` 전체 모델 참고)

jOneFlow v2는 **계층형 워크플로우 모델**을 사용합니다. 모드는 Lite / Standard / Strict 세 가지. 13단계는 **Strict canonical reference flow**이지 모든 작업의 기본값이 아닙니다.

```
✅ 매 세션 시작 시 HANDOFF.md에서 현재 mode 확인
✅ Lite      → 핫픽스 / 설정 변경 / 문구 수정 / 문서 수정
✅ Standard  → 신기능 / 리팩토링 기본값
✅ Strict    → 아키텍처 / 보안 / 데이터 스키마 / 결제 / 규제 대상
✅ Claude 역할: 기획(1~4) + 설계(5~7) + 검증(9, 11) + QA(12)
❌ Claude는 구현(8, 10) 직접 금지 → 반드시 Codex에 위임
```

**모드 선택 규칙:**

1. `HANDOFF.md`에 모드가 기록돼 있으면 그걸 사용
2. 없으면 Stage 1에서 사용자와 **소리 내어** 합의
3. 애매하면 더 무거운 모드를 선택

**작업 전 판단 기준:**

- **핫픽스/수치조정/설정/문서 수정** → Lite
- **신기능/로직 추가/리팩토링** → Standard — Stage 1~7 문서 작성 후 Codex 위임
- **아키텍처/보안/스키마/결제** → Strict — Stage 11 검증 (고위험 작업 한정; 동일 세션 가능)

### 🔴 운영자 참여 영역 — 능동 참여 vs. 프롬프트만 주고 물러서기

운영자의 집중력은 유한한 자원이다. 협업 모델은 운영자가 **능동적 공동
창작자** 로 참여하는 단계와, **스테이지 경계에서 짧은 프롬프트만 주고**
도구들이 작업을 처리하도록 물러서는 단계 사이에 명확한 경계선을 긋는다.

**능동 참여 영역 (운영자가 실시간으로 공동 창작):**

- Stage 1 브레인스토밍 — 방향 설정, 아이디어 탐색, 모드 결정.
- Stage 4 기획 파이널 리뷰 — 통합 기획 go/no-go.
- UI/UX 설계 대화 — 심미적 판단, 유저 플로우 선택.

**수동 지시 영역 (운영자는 스테이지 경계에서 짧은 프롬프트만 주고,
Claude + Codex + bash 샌드박스가 실제 작업 수행):**

- Stage 5 기술 설계
- Stage 8 코드 구현 (Codex 위임)
- Stage 9 코드 리뷰 (Claude)
- Stage 10 디버그 / 수정 (Claude findings 기반으로 Codex 가 수정)
- Stage 11 검증 (고위험 한정; 동일 세션 허용)
- Stage 12 QA, Stage 13 릴리스

**Claude 의 수동 지시 영역 내 행동 규약:**

1. **운영자에게 수작업 금지.** 셸 커맨드 실행, 파일 읽기, YAML
   frontmatter 타이핑, 아카이브 손수 생성, placeholder grep, 채팅
   스크롤 백 — 시키지 말 것. 런타임 에이전트 (Claude 본인, Codex,
   bash 샌드박스) 로 할 수 있으면 거기에 위임. 진짜 사람이 필요하면
   paste 한 번으로 끝내도록 최소화.
2. **"운영자가 보고 / 확인 / 복사" 문장은 프로세스 버그 후보.**
   operator-side pre-flight 보다 **consumer-side auto-verify** 선호
   (예: resume prompt 안에 STEP 0 아카이브 무결성 체크). operator-side
   hand-drafting 보다 **producer-side disk write** 선호 (예: Codex 가
   `status: archived` YAML 을 스스로 씀).
3. **크로스 툴 paste 가 정말로 필요한 경우** (툴 A 의 출력이 운영자를
   거쳐 툴 B 에 도달해야 하는 경우), **현재 채팅 메시지 안에** 타겟별
   paste-ready 블록 한 개를 꺼낸다 — "파일 X 의 Y 섹션 열어서 직접
   복사해" 금지.
4. **운영자의 수고가 실패 신호다.** 리뷰가 운영자에게 다단계 수작업
   복구를 지시한다면, 리뷰를 돌리기 전에 프로세스를 먼저 고친다.

이 규칙은 2026-04-22 Stage 9 Bundle 1 세션에서 반복 위반되어 추가됨;
레슨런 기록은 `prompts/codex/v03/stage8_coordination_notes.md` Sec. 8.

### 🔴 필수 협업 체크포인트

| 단계 | 규칙 |
|------|------|
| Stage 1 브레인스토밍 | 사용자와 대화하며 방향/모드/`has_ui`/`risk_level` 기록. Claude 혼자 작성 금지. |
| Stage 4 통합 완료 후 | **사용자 승인 필수** (Standard/Strict). 승인 없이 Stage 5 진입 금지. |
| Stage 5 기술 설계 | Stage 4 승인 확인 후에만 작성. |
| Stage 11 (Strict) | 고위험 작업 한정. 동일 세션 허용; Claude가 위험도 판단 후 필요시 새 세션 사용. |

### 🔴 세션 간 / 도구 간 핸드오프 규칙 — **Claude 는 짧은 포인터-프롬프트를 꺼내고, 타겟 도구가 정규 파일을 직접 읽는다**

세 가지를 동시에 최소화해야 한다:

1. **사용자의 복붙 부담** (이 시스템이 존재하는 이유).
2. **정규 파일-인라인 복사본의 다이버전스 위험** (파일 변경 순간 인라인은
   구식이 된다).
3. **Claude 의 출력 토큰** (100줄짜리 프롬프트 본문 재방출은 낭비).

세 가지를 동시에 만족하는 올바른 형태: Claude 는 **정규 파일 + 특정 블록을
가리키는 짧은 붙여넣기 가능 지시문** 을 꺼낸다. 타겟 도구 (Codex, Gemini,
Antigravity, 프로젝트가 열린 새 Claude 세션) 가 그 파일을 직접 읽고 블록의
지시대로 수행한다. 현대 코딩 에이전트는 모두 프로젝트 트리 파일 접근이
가능하다.

**포인터-프롬프트 기본 형식:**

```
`<정규-파일-경로>` 의 `<블록 식별자>` 섹션을 읽고 그 지시대로 <행동> 해줘.
```

`<블록 식별자>` 는 아래 중 하나 (안정성 순):

- **파일 내 유일한 섹션 헤딩** — 가장 안정적. 행 번호는 밀려도 헤딩은 안
  바뀜. 예: `"Codex prompt — paste this exact block" 섹션`.
- **안정 앵커 주석 쌍** — Claude 가 파일을 생성/갱신할 때 삽입한 앵커.
  형식: `<!-- PASTE:<id>:START --> ... <!-- PASTE:<id>:END -->`. 포인터는
  `<id>` 를 참조. 유일한 헤딩이 없거나 블록이 섹션 중간에 있을 때 사용.
- **행 범위** `(lines A–B)` — 허용하지만 깨지기 쉬움. 파일이 동결된 경우
  (예: 아카이브된 Codex 보고서) 에만 사용.

**핸드오프당 Claude 가 채팅에 꺼내는 것:**

- 타겟별 1–3 줄짜리 포인터-프롬프트를 각자 fenced block 으로 (원클릭 복사).
- 실행 지침 1문장 ("새 Codex high-effort 세션에 붙여넣기").
- **아님:** 블록 본문 전체. 본문은 정규 파일에 그대로 둔다.
- **현재 메시지 안에 자기완결.** 채팅이 운영자에게 "X 를 paste 하라"
  고 말할 때마다, paste-ready fenced 블록이 **같은 메시지 안, 그 문장
  바로 아래에** 나와야 한다. "이전 메시지 참조", "위로 스크롤", "파일
  X 에서 찾아 복사해" 절대 금지. 긴 대화에서는 이전 메시지 블록이
  사실상 보이지 않음. paste 지시가 있는 모든 메시지에 포인터-프롬프트를
  복제할 것, 직전 메시지와 같은 2줄이어도. 출력 토큰 비용은 감수, 운영자
  스크롤백은 감수 불가.

**금지 패턴:**

- ❌ "파일 X 를 열어서 Y 섹션을 찾아 복사해 타겟에 붙여넣어라" — 사용자에게
  복붙을 떠넘김.
- ❌ 100줄짜리 블록 본문을 인라인으로 쏟아붓기 — 출력 토큰 낭비 + 정규
  파일과 다이버지.
- ❌ "이제 새 세션 열고 resume prompt paste 하면 돼" + 바로 아래 포인터-
  프롬프트 없음 — 운영자가 위로 스크롤하거나 파일을 직접 열어 paste
  대상을 찾게 강요.

**예외 — 블록 본문을 인라인으로 꺼내는 경우:**

- 타겟 도구가 정말로 파일시스템 접근이 없는 경우 (순수 웹 채팅 인터페이스), 또는
- 사용자가 명시적으로 인라인 요청 ("붙여넣어 줘" / "show me the prompt").

**Claude 의 유지 의무:**

- `prompts/` 아래 정규 파일을 최신으로 유지 (단일 진실의 원천).
- 핸드오프-타겟 블록을 처음 만들거나 크게 갱신할 때, 블록이 섹션 중간에
  있거나 위치가 변할 가능성이 높으면 `<!-- PASTE:<id>:START/END -->` 앵커
  쌍을 블록 양쪽에 삽입 — 이후 포인터-프롬프트가 안정적으로 참조 가능.
- 동일 세션 내 Claude→Claude 핸드오프 (같은 채팅, 같은 파일 접근) 는
  붙여넣기 wrapper 없이 순수 포인터만으로 충분 ("다음 단계는 파일 X 참고").

### 🔴 채팅 출력 규칙 — 기본값 써머리, 비전공자 친화 언어, 이슈 있을 때만 상세

채팅은 **운영자의 콘솔**이지 감사 기록이 아니다. `docs/` 와 `prompts/`
아래 정규 파일이 전체 기술적 상세를 담는다 (그게 그 파일의 역할이고,
감사와 다음 Claude 세션이 읽음). 채팅의 역할은 운영자가 **다음 결정을
빠르게 내리게** 하는 것.

**언어 레지스터 (채팅에만 해당 — 작업 파일은 기술 밀도 유지):**

- 채팅 출력은 비전공자 운영자가 이해할 수 있어야 함.
- 정규 ID (AC.B4.3, R2 invariant, M.3, Sec. 9-1, D4.x2 등) 를 채팅에 꺼낼
  때는, 해당 메시지 내 첫 등장 시 짧은 괄호 풀이 추가:
  `AC.B4.3 (error-cases 판정 항목)`, `M.3 (새 세션 = 새 Claude 인스턴스)`.
- 작업 파일 (`docs/`, `prompts/`, `tests/`, `security/`) 은 완전한 기술적
  표현 유지 — 대상은 감사와 다운스트림 Claude 세션이지 가벼운 읽기 아님.
  **이 규칙은 채팅 채널만 관할.**

**분량:**

- **기본값: 써머리 (3~5줄 + 포인터)**. 예시:
  "Bundle 4 Stage 9 = PASS — minor. AC 16개 전부 통과, AC.B4.3
  (error-cases 일관성) 만 설계 문서 Sec. 6 인라인 확장으로 해소.
  상세: `docs/04_implementation/implementation_progress.md` Stage 9 섹션."
- **상세 채팅 출력으로 전환하는 경우만:**
  (a) 운영자가 갈림길 결정을 해야 할 때 (예: 두 해결 방안 중 선택),
  (b) 스펙 내부 불일치 / 테스트 실패 / precondition 위반 발견 시,
  (c) 정규 파일 자체 수정이 필요한 발견,
  (d) 사용자가 명시적 상세 요청.
- **모든 써머리는 포인터 1줄로 마무리** — 감사 추적이 클릭 한 번 거리에:
  "상세: `<path>` Sec. <n>" 또는 "per-AC 표: `implementation_progress.md`".

**피해야 할 실패 모드:** 써머리만 내면 운영자가 문서를 안 읽을 때 회귀가
숨겨짐. 필수 포인터 1줄 + "이슈 있을 때 상세로 전환" 트리거가 함께 그걸
방지 — 운영자는 "PASS" 와 문서 경로를 같이 보고, 결정이 실제로 필요할
때만 전체 상세를 봄.

---

## 3. 절대 규칙 (보안)

```
❌ API키·계좌번호·토큰을 코드/로그에 평문 노출 금지
❌ 실제 인증정보를 .env 또는 .env.example에 저장 금지 (둘 다 "키 목록"용)
✅ 모든 스크립트는 secret_loader.py로 OS 키체인에서 로드
✅ 변경 전 반드시 --dry-run으로 확인
✅ 파일 생성/수정 후 python3 -m py_compile로 문법 검사
```

### 인증정보 로드 패턴

```python
from security.secret_loader import load_secret
api_key = load_secret("MY_API_KEY")   # OS 키체인에서 로드
```

### `.env` vs `.env.example` vs OS 키체인

- `.env.example` — **프로젝트가 기대하는 시크릿 키 목록**. 값은 없음. Git에 커밋.
- `.env` — **개발 편의를 위한 선택적 로컬 파일**. 커밋 금지. 운영 시크릿은 절대 저장 금지.
- **OS 키체인** (macOS Keychain / Windows Credential Manager) — **실제 시크릿 저장소**. `secret_loader.py`로 접근.

시크릿이 처음 필요할 때 `python3 security/secret_loader.py --setup`(또는 `bash scripts/setup_security.sh`)로 대화형 설정.

---

## 4. 스크립트 실행

```bash
cd ~/projects/my-project

# 최초 보안 설정
python3 security/secret_loader.py --setup

# 테스트 (부작용 없음)
python3 src/main.py --dry-run

# Git 상태 확인
git status

# Git 체크포인트 (한 번에)
bash scripts/git_checkpoint.sh "Stage X 완료: 설명"

# 로그 확인
tail -50 logs/app.log
```

---

## 5. 핵심 파일

| 파일 | 역할 |
|------|------|
| `security/secret_loader.py` | 크로스플랫폼 인증정보 로더 |
| `security/keychain_manager.py` | macOS Keychain 백엔드 |
| `security/credential_manager.py` | Windows Credential Manager 백엔드 |
| `src/` | 프로젝트 소스 코드 |
| `CHANGELOG.md` | 모든 주요 변경 누적 기록 — dev_history를 대체 |
| `data/` | 런타임 데이터 (필요시) |
| `logs/` | 실행 로그 (필요시) |

---

## 6. 자동 실행 스케줄 (해당시)

> 프로젝트 설정 후 여기에 스케줄을 채워주세요.

| 시각 | 스크립트 | 설명 |
|------|----------|------|
| — | — | (여기에 스케줄 추가) |

---

## 7. 스킬 참조

| 작업 | 참조 |
|------|------|
| API 데이터 조회 | `.skills/api-client/SKILL.md` (직접 추가) |
| 리포트 생성 | `.skills/reporting/SKILL.md` (직접 추가) |

행동 유도형 스킬 작성 방식은 `.skills/README.md` 참고.

---

## 8. 코드 검증 가이드

- 문법 검사: `python3 -m py_compile src/<파일>.py`
- 복잡한 로직(50줄 이상/신규 파일): Opus 서브에이전트(high effort)로 독립 검증
- Stage 11: 고위험 작업 한정; 동일 세션 검증 허용 (Claude 판단으로 새 세션 필요시만 분리)
- 신규 파일은 반드시 `py_compile` 통과 후 커밋
