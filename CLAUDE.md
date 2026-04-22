# 🤖 Claude Operating Guide

> **Read order for every new session:** CLAUDE.md → HANDOFF.md → WORKFLOW.md → relevant `docs/`
> Current status, current workflow mode, and next tasks: see `HANDOFF.md`

---

> 한국어 버전: 이 파일 하단 참조 (Korean version below)

---

## 1. Project Summary

**jDevFlow** — [One-line description of what this project does]

- **Python environment:** `venv/bin/python3`
- **Project path:** `~/projects/my-project`
- **Main scripts:** `src/` folder

> ✏️ Fill in the above when starting a new project.

---

## 2. Workflow Role Rules (see `WORKFLOW.md` for the full model)

jDevFlow v2 uses a **tiered workflow model** with three modes: Lite / Standard / Strict. The 13-stage flow you will see elsewhere is the Strict (canonical) reference flow — not a default to force on every task.

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
- **Architecture / security / schema / payment** → Strict mode — independent validation at Stage 11

### 🔴 Mandatory collaboration checkpoints

| Stage | Rule |
|-------|------|
| Stage 1 Brainstorm | Discuss direction with the user. Claude must NOT write alone. Record mode, `has_ui`, `risk_level`. |
| After Stage 4 | **User approval required** (Standard and Strict). Do NOT enter Stage 5 without it. |
| Stage 5 Technical Design | Only start after Stage 4 approval is confirmed. |
| Stage 11 (Strict) | Use an independent Claude session (no prior context) for validation. |

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
| `docs/notes/dev_history.md` | Cumulative log of all stages, modes, and decisions |
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
- Strict-mode Stage 11: always use an independent Claude session
- All new files must pass `py_compile` before being committed

---

---

# 🤖 Claude 운영 지침 (한국어)

> **새 세션 읽기 순서:** CLAUDE.md → HANDOFF.md → WORKFLOW.md → 관련 `docs/`
> 현재 상태, 현재 워크플로우 모드, 다음 작업: `HANDOFF.md` 참고

---

## 1. 프로젝트 한 줄 요약

**jDevFlow** — [이 프로젝트가 하는 일을 한 줄로]

- **Python 환경:** `venv/bin/python3`
- **프로젝트 경로:** `~/projects/my-project`
- **메인 스크립트:** `src/` 폴더

> ✏️ 새 프로젝트 시작 시 위 내용을 채워주세요.

---

## 2. 워크플로우 역할 규칙 (`WORKFLOW.md` 전체 모델 참고)

jDevFlow v2는 **계층형 워크플로우 모델**을 사용합니다. 모드는 Lite / Standard / Strict 세 가지. 13단계는 **Strict canonical reference flow**이지 모든 작업의 기본값이 아닙니다.

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
- **아키텍처/보안/스키마/결제** → Strict — Stage 11 독립 검증 필수

### 🔴 필수 협업 체크포인트

| 단계 | 규칙 |
|------|------|
| Stage 1 브레인스토밍 | 사용자와 대화하며 방향/모드/`has_ui`/`risk_level` 기록. Claude 혼자 작성 금지. |
| Stage 4 통합 완료 후 | **사용자 승인 필수** (Standard/Strict). 승인 없이 Stage 5 진입 금지. |
| Stage 5 기술 설계 | Stage 4 승인 확인 후에만 작성. |
| Stage 11 (Strict) | 이전 컨텍스트 없는 독립 Claude 세션에서 검증. |

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
| `docs/notes/dev_history.md` | 전체 단계/모드/결정 누적 로그 |
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
- Strict 모드 Stage 11: 반드시 독립 Claude 세션 사용
- 신규 파일은 반드시 `py_compile` 통과 후 커밋
