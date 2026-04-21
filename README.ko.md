# 🤖 jDevFlow

> Claude를 AI 오케스트레이터로 활용하는 앱/소프트웨어 개발 워크플로우 템플릿 — [Jonelab_Platform](https://github.com/aigeenya/Jonelab_Platform)의 일부.
> 13단계 체계적 워크플로우 · 안전한 인증정보 관리 · Git 자동화 · 영어/한국어 지원

**English README:** [README.md](./README.md)

---

## 이게 뭔가요?

**jDevFlow**는 [Jonelab_Platform](https://github.com/aigeenya/Jonelab_Platform) 시리즈의 앱/소프트웨어 개발 전용 워크플로우 템플릿입니다. 이후 jDocsFlow, jCutFlow 등 다른 도메인용 Flow도 출시 예정입니다.

이 템플릿은 Claude(와 Codex)와 함께 아이디어 구상부터 배포까지 소프트웨어 개발 전 과정을 진행할 수 있는 프로젝트 구조를 제공합니다.

**개발자가 아니어도 Claude의 안내를 받아 사용할 수 있도록** 설계되었습니다.

### 주요 특징

- **13단계 AI 워크플로우** — Claude(기획·설계·검증·QA)와 Codex(구현·수정)의 역할이 명확하게 분리됨
- **4개의 AI 에이전트** — 기획가, 설계사, 검증관, QA관. 각 단계에 맞는 모델과 effort 레벨 적용
- **크로스플랫폼 보안 인증** — macOS Keychain / Windows Credential Manager. 코드에 인증정보 절대 저장 금지
- **Git 자동화** — 한 명령으로 커밋 + 개발 히스토리 자동 기록
- **세션 지속성** — HANDOFF.md로 며칠이 지나도 Claude 세션이 이어짐
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
cp -r jDevFlow/ 내-새-프로젝트/
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
> "새 프로젝트를 시작할 거야. CLAUDE.md 와 HANDOFF.md 를 먼저 읽고, 어떤 언어로 진행할지 물어봐줘."

이후는 Claude가 안내해줍니다.

---

## 프로젝트 구조

```
내-프로젝트/
├── CLAUDE.md               ← Claude 운영 지침 (매 세션 첫 번째로 읽기)
├── WORKFLOW.md             ← 13단계 개발 워크플로우
├── HANDOFF.md              ← 세션 상태 & 다음 작업 (두 번째로 읽기)
├── README.md               ← 영어 README
├── README.ko.md            ← 이 파일
│
├── .claude/
│   ├── settings.json       ← 모델 & effort 설정 (v0.1은 고정값)
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
│   └── notes/              ← dev_history.md, decisions.md, final_validation.md
│
├── prompts/
│   ├── claude/             ← 각 Claude 단계용 프롬프트 템플릿
│   └── codex/              ← 각 Codex 단계용 프롬프트 템플릿
│
├── src/                    ← 프로젝트 소스 코드
├── tests/                  ← 테스트 파일
├── .env.example            ← 인증정보 키 목록 (실제 값 없음)
├── .gitignore
└── LICENSE
```

---

## 13단계 워크플로우

| 단계 | 이름 | 담당 | 모델 |
|------|------|------|------|
| 1 | 아이디어 구상 | Claude + 사용자 | Opus |
| 2 | 계획 초안 | Claude | Sonnet |
| 3 | 계획 검토 | Claude | Sonnet |
| 4 | 계획 통합 | Claude | Sonnet |
| 4.5 | **사용자 승인** 🔴 | 사용자 | — |
| 5 | 기술 설계 | Claude | Opus |
| 6 | UI/UX 요구사항 *(선택)* | Claude | Sonnet |
| 7 | UI 플로우 *(선택)* | Claude | Sonnet |
| 8 | 구현 | Codex | — |
| 9 | 코드 리뷰 | Claude | Sonnet |
| 10 | 수정 | Codex | — |
| 11 | 최종 검증 | Claude | Opus |
| 12 | QA & 릴리스 | Claude | Sonnet |
| 13 | 배포 & 아카이브 | Codex | — |

전체 내용은 [WORKFLOW.md](./WORKFLOW.md) 참조.

---

## 인증정보 보안 관리

API 키, 비밀번호, 토큰은 **코드나 `.env` 파일에 절대 저장하지 않습니다**.
OS의 안전한 저장소(Keychain / Credential Manager)에 보관합니다.

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
| **v0.1** (현재) | 13단계 워크플로우, 고정 모델/effort, 크로스플랫폼 보안, 이중 언어 |
| v0.2 | 단계별 모델·effort 사용자 설정 |
| v0.3 | 최초 실행 시 언어 선택 마법사 |
| v1.0 | Claude ↔ Codex 완전 자동화 (수동 핸드오프 불필요) |

---

## 기여

이슈를 먼저 열어 변경 사항에 대해 논의해주세요.

---

## 라이선스

MIT © 형진 (Hyungjin) — [LICENSE](./LICENSE) 참조
