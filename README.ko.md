# 🤖 jOneFlow

> Claude를 AI 오케스트레이터로 활용하는 앱/소프트웨어 개발 워크플로우 템플릿 — [Jonelab_Platform](https://github.com/aigeenya/Jonelab_Platform)의 일부.
> 계층형 워크플로우(Lite / Standard / Strict) · 문서 중심 운영 · 세션 지속성 · 안전한 시크릿 관리 · 영어/한국어 지원

**English README:** [README.md](./README.md)

---

## 이게 뭔가요?

**jOneFlow**는 [Jonelab_Platform](https://github.com/aigeenya/Jonelab_Platform) 시리즈의 앱/소프트웨어 개발 전용 워크플로우 템플릿입니다. 이후 jDocsFlow, jCutFlow 등 다른 도메인용 Flow도 출시 예정입니다.

이 템플릿은 Claude(와 Codex)와 함께 아이디어 구상부터 배포까지 소프트웨어 개발 전 과정을 진행할 수 있는 프로젝트 구조를 제공합니다.

**개발자가 아니어도 Claude의 안내를 받아 사용할 수 있도록** 설계되었습니다.

### 주요 특징

- **계층형 워크플로우** — 작업 위험도에 맞게 **Lite / Standard / Strict** 중에서 모드 선택
- **Canonical Strict Flow** — 거버넌스의 상한선을 정의하는 13단계 기준 흐름 (강제 기본값이 아니라 참고 기준)
- **역할 분리** — Claude는 사고(기획·설계·검증·QA), Codex는 구현·수정
- **4개의 Claude 에이전트** — 기획가, 설계사, 검증관, QA관이 단계에 맞는 모델과 effort 적용
- **크로스플랫폼 보안 인증** — macOS Keychain / Windows Credential Manager. 코드에 인증정보 평문 저장 금지
- **Git 자동화** — 한 명령으로 커밋 + 개발 히스토리 자동 기록
- **세션 지속성** — `HANDOFF.md`로 며칠이 지나도 Claude 세션이 이어짐
- **이중 언어** — 영어 / 한국어 완전 지원

---

## 빠른 시작

### 필요 환경

- Python 3.10 이상
- Git
- Claude (Cowork, Claude Code, 또는 Claude API)
- macOS 또는 Windows (Linux는 환경변수 방식으로 지원)

### 1. 템플릿 복사

```bash
cp -r jOneFlow/ 내-새-프로젝트/
cd 내-새-프로젝트/
```

### 2. 초기화

```bash
bash scripts/init_project.sh
```

### 3. 보안 설정

```bash
bash scripts/setup_security.sh
```

### 4. Git 초기화

```bash
git init
git add .
git commit -m "chore: 템플릿으로 프로젝트 초기화"
```

### 5. Claude 열고 시작

Claude에게 이렇게 말하세요:
> "새 프로젝트를 시작할 거야. CLAUDE.md 와 HANDOFF.md 를 먼저 읽고, 어떤 언어로 진행할지, 그리고 이번 작업에 Lite / Standard / Strict 중 어떤 모드가 맞을지 물어봐줘."

이후는 Claude가 안내해줍니다. 세션 진입 표준 시퀀스는 [`docs/notes/session_bootstrap.md`](./docs/notes/session_bootstrap.md) 참조.

---

## 프로젝트 구조

```
내-프로젝트/
├── CLAUDE.md               ← Claude 운영 지침 (매 세션 첫 번째로 읽기)
├── WORKFLOW.md             ← 계층형 워크플로우 모델 + Canonical Strict Flow (13단계)
├── HANDOFF.md              ← 세션 상태, 현재 모드, 다음 작업 (두 번째로 읽기)
├── README.md               ← 영어 README
├── README.ko.md            ← 이 파일
│
├── .claude/
│   ├── settings.json       ← 모델 & effort 설정
│   └── language.json       ← 언어 설정
│
├── security/
│   ├── secret_loader.py    ← 크로스플랫폼 인증정보 로더 (이걸 사용하세요)
│   ├── keychain_manager.py ← macOS Keychain 백엔드
│   └── credential_manager.py ← Windows Credential Manager 백엔드
│
├── scripts/
│   ├── init_project.sh     ← 최초 프로젝트 설정
│   ├── git_checkpoint.sh   ← Git 커밋 + 개발 히스토리 자동 기록
│   ├── ai_step.sh          ← 단계 실행기 (각 단계 프롬프트 출력)
│   ├── setup_security.sh   ← 보안 설정 마법사
│   ├── append_history.sh   ← 개발 히스토리 수동 기록
│   └── zsh_aliases.sh      ← 쉘 alias 설정 (선택사항)
│
├── docs/                   ← 모든 단계 산출물이 여기에 저장됨
│   ├── 01_brainstorm/
│   ├── 02_planning/
│   ├── 03_design/
│   ├── 04_implementation/
│   ├── 05_qa_release/
│   └── notes/              ← dev_history.md, decisions.md, final_validation.md,
│                            session_bootstrap.md, workflow_eval_plan.md
│
├── prompts/
│   ├── claude/             ← 각 Claude 단계용 프롬프트 템플릿
│   └── codex/              ← 각 Codex 단계용 프롬프트 템플릿
│
├── .skills/
│   ├── README.md           ← 행동 유도형 스킬 작성 가이드
│   ├── _templates/         ← 새 스킬 시작용 빈 템플릿
│   └── examples/           ← 예시 스킬
│
├── src/                    ← 프로젝트 소스 코드
├── tests/                  ← 테스트 파일
├── .env.example            ← 시크릿 키 이름만 (값 없음 — 실제 시크릿은 OS 키체인)
├── .gitignore
└── LICENSE
```

---

## 워크플로우 모드 — Lite / Standard / Strict

jOneFlow는 모든 작업을 13단계로 강제하지 **않습니다.** 작업 성격에 맞게 모드를 선택하세요.

| 모드 | 사용 상황 | 일반적 소요 시간 |
|------|----------|------------------|
| **Lite** | 핫픽스, 설정 수정, 문구 수정, 문서만 수정 | 분 ~ 2시간 |
| **Standard** | 신기능, 리팩토링, 일반 개발 | 4시간 ~ 2일 |
| **Strict** | 아키텍처, 보안, 데이터 스키마, 결제, 규제 대상 | 2일 ~ 주 |

**Strict Flow**가 13단계 Canonical Reference 입니다:

| 단계 | 이름 | 담당 | 모델 |
|------|------|------|------|
| 1 | 아이디어 구상 | Claude + 사용자 | Opus |
| 2 | 계획 초안 | Claude | Sonnet |
| 3 | 계획 검토 | Claude | Sonnet |
| 4 | 계획 통합 | Claude | Sonnet |
| 4.5 | **사용자 승인** 🔴 | 사용자 | — |
| 5 | 기술 설계 | Claude | Opus |
| 6 | UI/UX 요구사항 *(`has_ui`)* | Claude | Sonnet |
| 7 | UI 플로우 *(`has_ui`)* | Claude | Sonnet |
| 8 | 구현 | Codex | — |
| 9 | 코드 리뷰 | Claude | Sonnet |
| 10 | 수정 | Codex | — |
| 11 | 최종 검증 | Claude | Opus |
| 12 | QA & 릴리스 | Claude | Sonnet |
| 13 | 배포 & 아카이브 | Codex | — |

**Lite**는 구현 → 경량 리뷰 → 아카이브만 유지합니다. **Standard**는 여기에 기획·설계·승인 게이트가 추가됩니다. **Strict**는 더 엄격한 조건과 Stage 11 Opus 레벨 최종 검증이 붙습니다.

전체 모델(stage type, 실행 조건, 완료 기준, 재진입 규칙)은 [WORKFLOW.md](./WORKFLOW.md) 참조.

---

## 인증정보 보안 관리

실제 시크릿(API 키, 비밀번호, 토큰)은 **OS 안전 저장소**에만 저장합니다. 코드나 `.env`에 저장하지 않습니다.

- `.env.example` — Git에 커밋, 프로젝트가 요구하는 **키 이름만** 담음
- `.env` — 선택적 로컬 스크래치 파일, Git 커밋 금지, 운영 시크릿 저장 금지
- OS 키체인 (macOS Keychain / Windows Credential Manager) — 실제 저장소, `secret_loader.py`로 접근

```python
# 코드에서 사용하는 방법
from security.secret_loader import load_secret

api_key = load_secret("MY_API_KEY")   # Keychain / Credential Manager에서 로드
```

```bash
# 커맨드라인에서 관리
python3 security/secret_loader.py --set MY_API_KEY "내-값"
python3 security/secret_loader.py --get MY_API_KEY
python3 security/secret_loader.py --setup   # 대화형 설정 마법사
```

---

## 쉘 alias (선택사항)

```bash
# ~/.zshrc 또는 ~/.bashrc에 추가
source ~/projects/my-project/scripts/zsh_aliases.sh
```

이후 사용:

```bash
aiinit       # 프로젝트 초기화
aib          # Stage 1: 아이디어 구상
aipd         # Stage 2: 계획 초안
aitd         # Stage 5: 기술 설계
aigit "메시지"  # Git 커밋 + 개발 히스토리 기록
```

---

## 로드맵

| 버전 | 기능 |
|------|------|
| v0.1 | 13단계 워크플로우, 고정 모델/effort, 크로스플랫폼 보안, 이중 언어 |
| v0.2 | 계층형 워크플로우 모델(Lite / Standard / Strict), stage type, 실행 조건, 완료 기준, 재진입 규칙, 기획/설계/리뷰/QA 템플릿 강화, `.skills/` 행동 계약 라이브러리 (스타터 템플릿 + 예시), `obra/superpowers` 크레딧 표기 |
| **v0.3** (예정) | 최초 실행 시 언어 선택 마법사 (대화형), `docs/notes/workflow_eval_plan.md`를 돌리는 자동 eval 러너, 세션 부트스트랩 훅 레퍼런스 구현 (Claude Code / Cowork), `.skills/examples/` 확장 (API 클라이언트·리포트 생성·안전 배포), `HANDOFF.md` 자동 작성 스크립트, 모드 선택 의사결정 트리 `.skills` 룰, **Stage 6·7(UI) 프롬프트 v0.2 수준 강화** (Runs-in / 완료 기준 / 재진입), **`ai_step.sh`·`zsh_aliases.sh` 모드 인식 CLI** (`aib --lite`, `aipd --standard` 등), **`CHANGELOG.md`** (v0.1 → v0.2 마이그레이션 노트 + keep-a-changelog 유지 규칙), **`CONTRIBUTING.md` 분리 + Contributor Covenant `CODE_OF_CONDUCT.md`**, **Stage 8 구현 주체 선택 질문** (Codex 추천 / Claude Sonnet / 기타 — 작업 복잡도에 따라 추천 가변), **Stage 6·7 UI 툴 선택 질문** (Google Antigravity 추천 / Claude Design / Figma / 기타) |
| v1.0 | 정책 기반 모드 선택을 포함한 Claude ↔ Codex 완전 자동화, 템플릿 드리프트 회귀 eval, 원-커맨드 릴리스 파이프라인 |

---

## 기여

이슈를 먼저 열어 변경 사항에 대해 논의해주세요.

---

## 감사의 말

jOneFlow는 Jonelab_Platform의 일부로 독립적으로 설계되었지만, 워크플로우 구조, 스킬 시스템, 에이전트 운영 방식의 일부 방향은 Jesse Vincent와 contributors의 [obra/superpowers](https://github.com/obra/superpowers) 프로젝트에서 다뤄진 아이디어를 참고했습니다. jOneFlow가 그 작업에서 영감을 받은 개념을 재해석해 반영한 부분에 대해서는 superpowers를 중요한 참고 프로젝트로 표기합니다. 자세한 내용은 [ATTRIBUTION.md](./ATTRIBUTION.md)를 참고하세요.

---

## 라이선스

Apache License 2.0 © Hyoungjin Lee / JoneLab — [LICENSE](./LICENSE) 참조
