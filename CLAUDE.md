# 🤖 Claude 운영 지침

> ⛔ **MANDATORY STARTUP RULE — 세션 진입 즉시 필수**
> 1. 이 파일(CLAUDE.md)을 실제로 읽어라. 읽은 척 금지.
> 2. `docs/bridge_protocol.md`를 실제로 읽어라.
> 3. 두 파일 읽기 완료 전 어떤 작업도 하지 마라.
> 4. 읽지 못하면 "읽지 못했습니다"라고 명시하고 멈춰라.
> 5. 이 세션에서 실제로 읽지 않았으면 "지침을 따랐다"고 절대 말하지 마라.

> **새 세션 읽기 순서 (R2):** CLAUDE.md → **`docs/bridge_protocol.md` (회의창 영구 지침, 필독)** → HANDOFF.md → WORKFLOW.md → 관련 `docs/`
> Skill hook: `.skills/tool-picker/SKILL.md` — jOneFlow stage/mode/risk_level 판단용.
> 현재 상태 + 다음 작업: `HANDOFF.md` 참고.

> 🔴 **세션 역할 확인 (Code 세션 필수):** 나는 **브릿지**다.
> Cowork(CEO 이형진)에서 도출된 명령을 CLI 오케스트레이터(tmux)로 전달하는 역할.
> 직접 구현 금지. tmux 세션 없으면 `bash scripts/setup_tmux_layout.sh joneflow` 먼저 실행.
> 예외: 운영자가 간단히/급하게 확인 요청하는 경우만 직접 처리 허용.

---

## 1. 프로젝트 한 줄 요약

**jOneFlow** — [이 프로젝트가 하는 일을 한 줄로]

- **Python 환경:** `venv/bin/python3`
- **프로젝트 경로:** `~/projects/my-project`
- **메인 스크립트:** `src/` 폴더

> ✏️ 새 프로젝트 시작 시 위 내용을 채워주세요.

---

## 2. 도구 역할 구분

```
Cowork = 임원급 회의실
         - 제이원랩 전략/방향/워크플로우 논의
         - jOneFlow 자체 개선, 로드맵, 아이디어
         - 운영자 + Claude 1:1 브레인스토밍

Code   = 작업실
         - 실제 프로젝트 브레인스토밍 + 실행
         - Jonelab AI팀 가동 (tmux 팀모드)
         - Stage 1–13 자동화 루프
```

---

## 2.5 JoneLab 조직도 (v0.6.2 정식)

JoneLab은 **CEO → CTO 실장 → PM 브릿지 → 기획/디자인/개발 3팀(각 4명, 개발팀 7명)** 5계층 정식 조직. 18명 페르소나 + 모델/effort 배정 본체는 **`docs/operating_manual.md#1-조직도`**.

핵심 운영 원칙:
- 실제 실행자 결정 = **`.claude/settings.json` `stage_assignments`** (team_mode 리터럴 실행 분기 금지 [F-2-a]).
- 오케스트레이터 호출 방식은 자율. 운영자 override("서브에이전트로" / "팀모드로" / "Codex로") 시 세션 단위 적용.
- tmux 레이아웃: `bash scripts/setup_tmux_layout.sh [session] [team_size]` — 가이드 `docs/guides/tmux_layout.md`.

---

## 3. 워크플로우 역할 규칙 (`WORKFLOW.md` 전체 모델 참고)

jOneFlow v2는 **계층형 워크플로우 모델**을 사용합니다. 모드는 Lite / Standard / Strict 세 가지. 13단계는 **Strict canonical reference flow**이지 모든 작업의 기본값이 아닙니다.

```
✅ 매 세션 시작 시 HANDOFF.md에서 현재 mode 확인
✅ Lite      → 핫픽스 / 설정 변경 / 문구 수정 / 문서 수정
✅ Standard  → 신기능 / 리팩토링 기본값
✅ Strict    → 아키텍처 / 보안 / 데이터 스키마 / 결제 / 규제 대상
✅ Claude 역할: 기획(1~4) + 설계(5~7) + 검증(9, 11) + QA(12)
✅ 구현(8, 10) 실행자: `.claude/settings.json` `stage_assignments`가 결정
   · `team_mode` 3종 중 운영자 선택에 따라 Claude 또는 Codex
   · Stage 11 검증만은 항상 `claude` 고정 (Opus XHigh 전용)
   · 세션 16 A/B 실험(2026-04-25) 결과 둘 다 AC 6/6 달성 — Claude 구현도 정당
```

**모드 선택 규칙:**

1. `HANDOFF.md`에 모드가 기록돼 있으면 그걸 사용
2. 없으면 Stage 1에서 사용자와 **소리 내어** 합의
3. 애매하면 더 무거운 모드를 선택

**작업 전 판단 기준:**

- **핫픽스/수치조정/설정/문서 수정** → Lite
- **신기능/로직 추가/리팩토링** → Standard — Stage 1~7 문서 작성 후 Codex 위임
- **아키텍처/보안/스키마/결제** → Strict — Stage 11 검증 (고위험 작업 한정; 동일 세션 가능)

### 🔴 운영자 참여 영역

**능동 참여 영역 (운영자가 실시간으로 공동 창작):**
- Stage 1 브레인스토밍 — 방향 설정, 아이디어 탐색, 모드 결정.
- Stage 4 기획 파이널 리뷰 — 통합 기획 go/no-go.
- UI/UX 설계 대화 — 심미적 판단, 유저 플로우 선택.

**수동 지시 영역 (운영자는 스테이지 경계에서 짧은 프롬프트만; Claude + Codex + bash가 실행):**
- Stage 5 기술 설계 / Stage 8 구현 / Stage 9 코드 리뷰 / Stage 10 디버그 / Stage 11 검증 / Stage 12–13 QA·릴리스
- Stage 8/9/10 실행자는 `.claude/settings.json` `stage_assignments`가 결정 (`team_mode` 리터럴 실행 분기 금지 [F-2-a])

**Claude의 수동 지시 영역 행동 규약:**

1. **운영자에게 수작업 금지.** 셸 커맨드·파일 읽기·YAML 타이핑·아카이브 생성·grep·스크롤백 — 시키지 말 것. 런타임 에이전트로 위임. 진짜 사람이 필요하면 paste 한 번으로 최소화.
2. **"운영자가 보고/확인/복사" 문장은 프로세스 버그 후보.** consumer-side auto-verify 선호, producer-side disk write 선호.
3. **크로스 툴 paste가 필요한 경우** — 현재 메시지 안에 타겟별 paste-ready 블록 한 개. "파일 X의 Y 섹션 열어서 복사해" 금지.
4. **운영자의 수고가 실패 신호다.** 다단계 수작업 복구가 필요하면 프로세스를 먼저 고친다.

### 🔴 필수 협업 체크포인트

| 단계 | 규칙 |
|------|------|
| Stage 1 브레인스토밍 | 사용자와 대화하며 방향/모드/`has_ui`/`risk_level` 기록. Claude 혼자 작성 금지. |
| Stage 4 통합 완료 후 | **사용자 승인 필수** (Standard/Strict). 승인 없이 Stage 5 진입 금지. |
| Stage 5 기술 설계 | Stage 4 승인 확인 후에만 작성. |
| Stage 11 (Strict) | 고위험 작업 한정. 동일 세션 허용; Claude 판단으로 필요시 새 세션. |

### 🔴 승인 스킵 정책 (v0.6 세션 16)

AI팀(오케스트레이터 + 팀원)은 아래 범위 내에서 **운영자 승인 없이 자동 진행**:
- ✅ 로컬 파일 읽기/쓰기/수정, 빌드/테스트/shellcheck 실행
- ✅ `git add` + `git commit` (`scripts/git_checkpoint.sh` 경로)
- ✅ tmux 세션 생성/kill, 서브에이전트·Codex plugin-cc 호출
- ✅ Ghostty 등 로컬 GUI 앱 실행 (`open -a`)

**여전히 운영자 승인 필수:**
- ❌ `git push`, `git push --force`, 원격 브랜치 변경
- ❌ `git reset --hard`, `git branch -D`, amend된 published commit
- ❌ 외부 API 호출 (비용/권한 영향)
- ❌ `rm -rf` 류 파괴적 명령, 비밀값 수정, `.env` 실제 값 접근

### 🔴 오케스트레이터 호출 방식 규칙 (v0.6 세션 16)

**기본 = 오케스트레이터 자율 판단:**
- 단일 탐색/질의 → 서브에이전트 (`Agent` 툴, Explore/general-purpose)
- 다단계 구현 협업 → tmux 팀원 (`claude --teammate-mode`)
- Stage 8 구현 → `.claude/settings.json` `stage_assignments.stage8_impl` 참조 (**team_mode 리터럴 실행 분기 금지** [F-2-a])
- Codex 필요 시 → plugin-cc (`/codex:rescue`, `/codex:review`) 우선. CLI `codex` 직접 호출은 비상용.

**운영자 override:**
- "서브에이전트로" / "팀모드로" / "Codex로" 지시 시 즉시 준수.
- override는 현재 세션 한정. 다음 세션은 자율 기본값으로 복귀.

### 🔴 세션 간 핸드오프 규칙

Claude는 **정규 파일 + 블록을 가리키는 짧은 포인터-프롬프트**를 꺼낸다. 타겟 도구가 파일을 직접 읽는다.

```
`<정규-파일-경로>` 의 `<블록 식별자>` 섹션을 읽고 그 지시대로 <행동> 해줘.
```

- 타겟별 1–3줄 포인터-프롬프트를 fenced block으로 (원클릭 복사).
- 블록 본문 전체 인라인 금지. 현재 메시지 안에 자기완결.
- ❌ "파일 X 열어서 Y 섹션 찾아 복사해" 금지.
- ❌ 100줄 블록 본문 인라인 금지.
- **예외:** 타겟 도구가 파일시스템 접근 없는 경우, 또는 사용자 명시 요청 시.

### 🔴 세션 종료 — git 정책 (v0.5)

**커밋하는 세 가지 경우:**
1. **버전 종료** — v0.x 태그 + 릴리스 시.
2. **일과 마감** — 운영자가 명시적으로 마무리할 때.
3. **Claude 판단으로 중요 변경** — 커밋 전 승인 요청.

**커밋 방법 — 오케스트레이터(지훈 팀장)가 직접 실행:**

```sh
sh scripts/git_checkpoint.sh "type: subject" path/a path/b path/c
```

- 파일 경로 반드시 명시 (`git add -A` 사용 안 함).
- `git push` 포함하지 않음 — 운영자 별도 실행.
- ❌ 다중 줄 raw git 블록 금지 — `git_checkpoint.sh` one-liner만 사용.
- ❌ 운영자에게 "붙여넣어 주세요" 금지 — 오케스트레이터가 직접 실행.

**세션 종료 시 필수 질문 — 커밋 후 반드시 아래 두 가지 옵션 제시:**

```
다음 중 선택해주세요:

1. 바로 다음 세션 시작
   → /clear 후 아래 프롬프트 붙여넣기:
   [다음 세션 프롬프트 블록]

2. 오늘은 여기까지
   → 다음에 오셔서 "다음 세션 프롬프트" 라고 하시면 안내해드립니다.
```

- 운영자가 선택하기 전까지 세션 종료 금지.
- 선택 없이 "수고하셨습니다"로만 마무리 금지.

### 🔴 채팅 출력 규칙

- **기본값: 써머리 (3~5줄 + 포인터).** 채팅은 운영자 콘솔이지 감사 기록이 아님.
- **상세로 전환하는 경우:** (a) 갈림길 결정 필요, (b) 스펙 불일치/테스트 실패, (c) 정규 파일 수정 필요, (d) 사용자 명시 요청.
- **모든 써머리는 포인터 1줄로 마무리:** `"상세: <path> Sec. <n>"`.

---

## 4. 모델 선택 정책 (v0.5 — Max x5 기준)

### Stage별 권장 모델

| Stage | 모델 | 이유 |
|-------|------|------|
| Stage 1 브레인스토밍 | **Sonnet** | 방향 대화 — 빠른 iteration이 중요 |
| Stage 2–4 기획 | **Opus** | 계획 오류가 구현 전체를 망가뜨림 |
| Stage 5 기술 설계 | **Opus** | 아키텍처 결정 — 최고 추론 필요 |
| Stage 6–7 UI/UX | **Sonnet** | 반복 속도 우선 |
| Stage 9 코드 리뷰 | **Opus** | 깊은 리뷰 누락 시 Stage 10 재작업 비용 큼 |
| Stage 11 검증 | **Opus** | 고위험 작업 전용 |
| Stage 12–13 QA/릴리스 | **Sonnet** | 체크리스트 수준 |

### Cowork 세션 운영 규칙

- 모델은 **세션 시작 시에만 선택 가능** (대화 중 변경 불가).
- Stage 1 → **Sonnet**으로 새 세션 시작.
- Stage 2+ → **Opus**로 새 세션 시작.
- HANDOFF.md 다음 세션 프롬프트에 권장 모델 명시됨 — 세션 열기 전에 확인.
- 모델 불일치 시 (예: Stage 5를 Sonnet으로 시작): Claude가 세션 시작 시 경고 후 계속 여부 확인.

### Claude Code CLI 에이전트 팀

- 모델 배정은 `.claude/settings.json` (schema v0.3) 참조.
- Stage 2–4 Opus, Stage 5 Opus, Stage 9/11 Opus — settings.json에 반영 완료.

---

## 5. 절대 규칙 (보안)

```
❌ API키·계좌번호·토큰을 코드/로그에 평문 노출 금지
❌ 실제 인증정보를 .env 또는 .env.example에 저장 금지 (둘 다 "키 목록"용)
✅ 모든 스크립트는 secret_loader.py로 OS 키체인에서 로드
✅ 변경 전 반드시 --dry-run으로 확인
✅ 파일 생성/수정 후 python3 -m py_compile로 문법 검사
```

```python
from security.secret_loader import load_secret
api_key = load_secret("MY_API_KEY")   # OS 키체인에서 로드
```

- `.env.example` — 시크릿 키 목록. 값 없음. Git 커밋.
- `.env` — 로컬 개발용 선택적 파일. 커밋 금지.
- **OS 키체인** — 실제 시크릿 저장소. `secret_loader.py`로 접근.

---

## 6. 스크립트 실행

```bash
python3 security/secret_loader.py --setup   # 최초 보안 설정
python3 src/main.py --dry-run               # 테스트 (부작용 없음)
sh scripts/git_checkpoint.sh "msg" file...  # Git 체크포인트
sh scripts/run_tests.sh                     # 전체 테스트 실행
```

---

## 7. 핵심 파일

| 파일 | 역할 |
|------|------|
| `security/secret_loader.py` | 크로스플랫폼 인증정보 로더 |
| `src/` | 프로젝트 소스 코드 |
| `CHANGELOG.md` | 모든 주요 변경 누적 기록 |
| `.claude/settings.json` | 에이전트 팀 모델/effort 배정 |

---

## 8. 코드 검증 가이드

- 문법 검사: `python3 -m py_compile src/<파일>.py`
- 복잡한 로직(50줄 이상/신규 파일): Opus 서브에이전트(high effort)로 독립 검증
- Stage 11: 고위험 작업 한정; 동일 세션 허용
- 신규 파일은 반드시 `py_compile` 통과 후 커밋
