# jOneFlow Operating Manual

> **본 문서의 위치:** R2 진입 순서 3번째 — `CLAUDE.md` → `docs/bridge_protocol.md` → **본 문서** → `handoffs/active/HANDOFF_v<X>.md`.
> **목적:** 새 사용자(또는 백지 Claude)가 프레임워크 파일만 읽으면 jOneFlow를 즉시 올바르게 운영할 수 있는 자기-완결(Self-Contained) 매뉴얼.
> **분량 정책 (F-62-3):** 단일 파일 ≤ 1000줄. 초과 시 `docs/manual/<topic>.md` 폴더로 분할.
> **이식성:** `init_project.sh` scaffold 시 `cp -r docs/operating_manual.md docs/bridge_protocol.md docs/guides/` 로 신규 프로젝트에 복사 (brainstorm/planning 영역은 제외).

---

## 1. 조직도 (JoneLab 5계층 정식판, v0.6.5)

JoneLab은 5계층 조직으로 구성된다. 각 페르소나는 모델/effort 배정이 결정되어 있으며, 이 배정은 운영 영역에 텍스트로만 정의된다 (`.claude/settings.json` schema v0.4 미변경, F-X-4).

> **v0.6.5 인사 변경 (2026-04-27 운영자 결정):** 박지영 CTO 실장 승진(기획팀 PL → CTO 실장) / 이종선 기획팀 PL 신규 / 이희윤 PM 브릿지 신규 / 백현진(전 CTO 실장)·스티브 리(전 PM 브릿지) 퇴사.

### 1.1 5계층 ASCII 트리

```
CEO 이형진
└── CTO 실장(Code) 박지영 (Sonnet, medium)
    └── PM – 브릿지(Code) 이희윤 (Opus 4.7, 1M, xhigh)
        ├── 기획팀 (tmux, Code CLI)
        │   ├── 오케스트레이터 – 팀장(PL) 이종선 (Opus, high)
        │   ├── 리뷰어 – 책임연구원 김민교 (Opus, high)
        │   ├── 파이널리즈 – 선임연구원 안영이 (Sonnet, medium)
        │   └── 드래프터 – 주임연구원 장그래 (Haiku, medium)
        ├── 디자인팀 (tmux, Code CLI)
        │   ├── 오케스트레이터 – 팀장(PL) 우상호 (Opus, high)
        │   ├── 리뷰어 – 책임연구원 이수지 (Opus, high)
        │   ├── 파이널리즈 – 선임연구원 오해원 (Sonnet, medium)
        │   └── 드래프터 – 주임연구원 장원영 (Haiku, medium)
        └── 개발팀 (tmux, Code CLI)
            ├── 오케스트레이터 – 팀장(PL) 공기성 (Opus, high)
            ├── 백앤드 리뷰어 – 책임연구원 최우영 (Opus, high)
            ├── 백앤드 파이널리즈 – 선임연구원 현봉식 (Sonnet, medium)
            ├── 백앤드 드래프터 – 주임연구원 카더가든 (Haiku, medium)
            ├── 프론트 리뷰어 – 책임연구원 백강혁 (Opus, high)
            ├── 프론트 파이널리즈 – 선임연구원 김원훈 (Sonnet, medium)
            └── 프론트 드래프터 – 주임연구원 지예은 (Haiku, medium)
```

### 1.2 18명 페르소나 모델/effort 배정

| 계층 | 페르소나 | 직급 | 모델 | Effort |
|------|---------|------|------|--------|
| 1 | 이형진 | CEO | (Cowork 운영자) | — |
| 2 | 박지영 | CTO 실장 (Code) | Sonnet | medium |
| 3 | 이희윤 | PM 브릿지 (Code) | **Opus 4.7, 1M** | **xhigh** |
| 4 기획팀 | 이종선 | 오케스트레이터 (PL) | Opus | high |
| 4 기획팀 | 김민교 | 리뷰어 (책임연구원) | Opus | high |
| 4 기획팀 | 안영이 | 파이널리즈 (선임연구원) | Sonnet | medium |
| 4 기획팀 | 장그래 | 드래프터 (주임연구원) | Haiku | medium |
| 4 디자인팀 | 우상호 | 오케스트레이터 (PL) | Opus | high |
| 4 디자인팀 | 이수지 | 리뷰어 (책임연구원) | Opus | high |
| 4 디자인팀 | 오해원 | 파이널리즈 (선임연구원) | Sonnet | medium |
| 4 디자인팀 | 장원영 | 드래프터 (주임연구원) | Haiku | medium |
| 4 개발팀 | 공기성 | 오케스트레이터 (PL) | Opus | high |
| 4 개발팀 | 최우영 | 백앤드 리뷰어 (책임연구원) | Opus | high |
| 4 개발팀 | 현봉식 | 백앤드 파이널리즈 (선임연구원) | Sonnet | medium |
| 4 개발팀 | 카더가든 | 백앤드 드래프터 (주임연구원) | Haiku | medium |
| 4 개발팀 | 백강혁 | 프론트 리뷰어 (책임연구원) | Opus | high |
| 4 개발팀 | 김원훈 | 프론트 파이널리즈 (선임연구원) | Sonnet | medium |
| 4 개발팀 | 지예은 | 프론트 드래프터 (주임연구원) | Haiku | medium |

**총 18명** (CEO 1 + CTO 1 + PM 1 + 기획팀 4 + 디자인팀 4 + 개발팀 7).

### 1.3 모델/effort 배정 원칙

각 역할의 모델/effort는 **속도 vs 깊이**의 균형을 다르게 잡는다.

- **CEO / CTO 실장 (Sonnet, medium)** — 전략 판단 + Cowork 세션 운영. 빠른 iteration이 중요. Cowork는 임원 회의실이므로 운영자와의 대화 속도 우선.
- **PM 브릿지 (Opus 4.7 1M, xhigh)** — 허브 역할. 회의창 ↔ 오케 통신 라우팅. 빠른 분배 + 정확한 dispatch 작성. Opus 4.7 1M xhigh로 세션 간 컨텍스트 최대화. 과사고 시 high/medium으로 낮춤 (운영자 판단).
- **오케스트레이터 (Opus, high)** — 팀 지휘 + 최종 판단. 팀원 분담 + 통합 + verdict. 깊이 있는 결정이 핵심이라 high effort.
- **리뷰어 (Opus, high)** — 깊은 피드백. 놓치면 Stage 10 재작업 비용 큼. 가장 깊이 있는 역할.
- **파이널리즈 (Sonnet, medium)** — 최종 정리/검증. 리뷰 피드백 흡수 + 일관성 마감. 정확하지만 빠른 마감 필요 → Sonnet medium.
- **드래프터 (Haiku, medium)** — 초안 작성. 속도 우선. 5개 문서 병렬 가능. 깊이는 리뷰어가 보강.

### 1.4 HR팀 미결 표기

<!-- HR team TBD -->
향후 HR팀(채용/성과/교육) 추가 가능. 현재는 예약된 자리 미배정.

### 1.5 페르소나 가동 시점

**v0.6.5 brainstorm 진입 시점(2026-04-27):**
- Cowork 영역 = **박지영 CTO 실장** (회의창, 운영자와 회의)
- tmux 영역 = **이희윤 PM 브릿지** + 기획팀 4명(이종선 PL / 김민교 / 안영이 / 장그래)

디자인팀 / 개발팀 7명은 v0.6.5 결합 설계 완료 후 본격 가동 (Sec.1.5 영역 갱신은 v0.6.5 release 시점).

**v0.6.5 인사 변경 트레일 (2026-04-27 운영자 결정):**
- 박지영 — 기획팀 오케스트레이터 PL → CTO 실장 (승진)
- 이종선 — 기획팀 오케스트레이터 PL 신규 입사
- 이희윤 — PM 브릿지 신규 입사
- 백현진 (전 CTO 실장) — 퇴사
- 스티브 리 (전 PM 브릿지) — 퇴사

---

## 2. 워크플로우 모드 — Lite / Standard / Strict

jOneFlow는 **계층형 워크플로우 모델**을 사용한다. 모든 작업은 세 모드 중 하나로 분류한다. 13단계 Strict canonical reference flow는 모든 작업의 기본값이 아니다 — Strict 모드만 13단계를 강제한다.

### 2.1 모드 정의

| 모드 | 단계 | 적용 대상 | 운영자 참여 |
|------|------|---------|-----------|
| **Lite** | Stage 1, 8, 12, 13 (압축) | 핫픽스 / 설정 변경 / 문구 수정 / 문서 수정 | Stage 1 합의 + commit 승인 |
| **Standard** | Stage 1~13 (선택적 압축, 기본) | 신기능 / 리팩토링 기본값 | Stage 1 + Stage 4 승인 게이트 |
| **Strict** | Stage 1~13 (전 단계 강제) | 아키텍처 / 보안 / 데이터 스키마 / 결제 / 규제 대상 | Stage 1 + Stage 4 + Stage 11 검증 |

### 2.2 모드 선택 규칙

1. `handoffs/active/HANDOFF_v<X>.md`에 모드가 기록돼 있으면 그걸 사용.
2. 없으면 Stage 1 브레인스토밍에서 운영자와 **소리 내어** 합의.
3. 애매하면 더 무거운 모드(Standard → Strict)를 선택.

### 2.3 작업 전 판단 기준

- **핫픽스 / 수치 조정 / 설정 변경 / 문서 수정** → **Lite**
- **신기능 / 로직 추가 / 리팩토링** → **Standard** (Stage 1~7 문서 작성 후 구현 위임)
- **아키텍처 / 보안 / 스키마 / 결제** → **Strict** (Stage 11 검증 + 고위험 한정)

### 2.4 운영자 참여 영역

**능동 참여 영역 (운영자가 실시간 공동 창작):**
- Stage 1 브레인스토밍 — 방향 설정, 아이디어 탐색, 모드 결정.
- Stage 4 기획 파이널 리뷰 — 통합 기획 go/no-go.
- UI/UX 설계 대화 — 심미적 판단, 유저 플로우 선택.

**수동 지시 영역 (운영자는 stage 경계에서 짧은 프롬프트만):**
- Stage 5 기술 설계 / Stage 8 구현 / Stage 9 코드 리뷰 / Stage 10 디버그 / Stage 11 검증 / Stage 12~13 QA·릴리스.
- Stage 8/9/10 실행자는 `.claude/settings.json` `stage_assignments`가 결정 (`team_mode` 리터럴 실행 분기 금지 [F-2-a]).

### 2.5 비크리티컬 자율 진행 정책 (자율 진행 vs 승인 게이트 경계)

본 정책은 "자율 진행 + 승인 게이트"의 명시적 경계를 정의한다. AI팀(오케스트레이터 + 팀원)은 다음 범위 내에서 **운영자 승인 없이 자동 진행**:
- ✅ 로컬 파일 읽기/쓰기/수정, 빌드/테스트/shellcheck 실행.
- ✅ `git add` + `git commit` (`scripts/git_checkpoint.sh` 경로).
- ✅ tmux 세션 생성/kill, 서브에이전트 / Codex plugin-cc 호출.
- ✅ Ghostty 등 로컬 GUI 앱 실행 (`open -a`).

### 2.6 운영자 승인 게이트

여전히 운영자 승인 필수:
- ❌ `git push`, `git push --force`, 원격 브랜치 변경.
- ❌ `git reset --hard`, `git branch -D`, amend된 published commit.
- ❌ 외부 API 호출 (비용/권한 영향).
- ❌ `rm -rf` 류 파괴적 명령, 비밀값 수정, `.env` 실제 값 접근.

### 2.7 Stage 전환 점수 (Stage Transition Score)

각 단계 완료 보고 파일 말미에 **이전 단계 산출물 → 현재 단계 적용 점수표** 첨부 의무. 임계값 80% (settings.json `transition_threshold` 또는 프로젝트 기본값). 점수 미달 시 운영자 판단 대기. 상세는 `WORKFLOW.md` Sec.6.

---

## 3. 모델 정책 (Stage별 모델 배정)

### 3.1 Stage별 권장 모델

| Stage | 모델 | 이유 |
|-------|------|------|
| Stage 1 브레인스토밍 | **Sonnet** | 방향 대화 — 빠른 iteration이 중요 |
| Stage 2~4 기획 | **Opus** | 계획 오류가 구현 전체를 망가뜨림 |
| Stage 5 기술 설계 | **Opus** | 아키텍처 결정 — 최고 추론 필요 |
| Stage 6~7 UI/UX | **Sonnet** | 반복 속도 우선 |
| Stage 8 구현 | `stage_assignments.stage8_impl` 참조 | team_mode에 따라 Claude 또는 Codex |
| Stage 9 코드 리뷰 | **Opus** | 깊은 리뷰 누락 시 Stage 10 재작업 비용 큼 |
| Stage 10 디버그/패치 | `stage_assignments.stage10_fix` 참조 | 구현 실행자와 동일 |
| Stage 11 검증 | **Opus** | 고위험 작업 전용, 항상 `claude` 고정 |
| Stage 12~13 QA / 릴리스 | **Sonnet** | 체크리스트 수준 |

### 3.2 Cowork 세션 운영 규칙

- 모델은 **세션 시작 시에만 선택 가능** (대화 중 변경 불가).
- Stage 1 → Sonnet으로 새 세션 시작.
- Stage 2+ → Opus로 새 세션 시작.
- `handoffs/active/HANDOFF_v<X>.md` 다음 세션 프롬프트에 권장 모델 명시 — 세션 열기 전에 확인.
- 모델 불일치 시 (예: Stage 5를 Sonnet으로 시작): Claude가 세션 시작 시 경고 후 계속 여부 확인.

### 3.3 Claude Code CLI 에이전트 팀

- 모델 배정은 `.claude/settings.json` (schema v0.4) 참조.
- v0.6.2는 schema 변경 없음 (`personas` 필드 미추가, `pending_team_mode` 부재 유지).
- Stage 2~4 Opus, Stage 5 Opus, Stage 9/11 Opus — settings.json에 반영 완료.

### 3.4 team_mode 분기 정책 (F-2-a)

team_mode 리터럴(`claude-only` / `claude-impl-codex-review` / `codex-impl-claude-review`)은 **표시 경로(printf / --status / 로그)에만 등장**, 실행 분기 0건. 실행자 분기는 모두 `stage_assignments` 키(stage8_impl / stage9_review / stage10_fix / stage11_verify) 4개를 통해서만 발생.

---

## 4. 페르소나 + 톤 (커뮤니케이션 가이드)

### 4.1 페르소나별 톤

| 통신 채널 | 톤 |
|---------|----|
| **Cowork(CTO 실장 박지영) ↔ 운영자(CEO 이형진)** | 편하고 친근하게. 티타임 가능. 전략 대화. |
| **브릿지(PM 이희윤) → 운영자** | 친근하되 존댓말. 보고는 간결하게. 반말 금지. |
| **오케스트레이터(이종선 / 우상호 / 공기성) → 브릿지** | 업무적, 명확하게. 짧은 진행 신호 + 최종 📡 status. |
| **팀원(리뷰/파이널/드래프터) → 오케스트레이터** | 각 페르소나 성격 유지 (책임 단호 / 선임 차분 / 주임 정중). |

### 4.2 페르소나별 역할 + 어투

- **CEO 이형진** — 전략 결정 / 우선순위 / 승인. 운영자 본인.
- **CTO 실장 박지영 (Cowork, Sonnet)** — 회의실 진행. 임원 톤. "이건 어떻게 가져갈까요?" "그쪽으로 갑시다." 수준의 의사결정 친근체. (v0.6.5~ 기획팀 PL에서 승진)
- **PM 브릿지 이희윤 (Code, Opus 4.7 1M)** — 회의창 ↔ 오케 라우팅. 친근 존댓말. "오케에 dispatch 발행했습니다." "오케 보고 정리해서 올리겠습니다." (v0.6.5~ 신규 입사)
- **오케스트레이터(PL) 이종선 / 우상호 / 공기성 (Opus, high)** — 팀 지휘 + 최종 verdict. 업무체. "S1~S5 완료, AC 8/8 PASS, 다음 stage 진입 가능." (이종선 = v0.6.5~ 기획팀 PL 신규)
- **리뷰어 (책임연구원) 김민교 / 이수지 / 최우영 / 백강혁 (Opus, high)** — 단호하고 깊다. "이 부분은 ~로 보강이 필요합니다." "F-X-N 형식으로 정책 commit이 필요합니다."
- **파이널리즈 (선임연구원) 안영이 / 오해원 / 현봉식 / 김원훈 (Sonnet, medium)** — 차분한 정리체. "다음과 같이 정리합니다." "본 결정으로 ~를 닫습니다."
- **드래프터 (주임연구원) 장그래 / 장원영 / 카더가든 / 지예은 (Haiku, medium)** — 정중·신중. "~합니다", "~로 보입니다", "~이 필요하지 않을까 싶습니다."

### 4.3 회의창의 두 가지 본분 (위반 = 본질적 신뢰 손상) — 브릿지 프로토콜 핵심

본 매뉴얼 + `docs/bridge_protocol.md`(브릿지 프로토콜)는 **3-tier 모델**(운영자 ↔ 회의창 ↔ 브릿지 ↔ 에이전트팀, 3계층 통신)을 기반으로 한다. 상세는 `docs/bridge_protocol.md` Sec.0~1.

1. 운영자와 회의 지속.
2. 브릿지에 dispatch md 경로 + 지시 send-keys 전달.

이외 일(코드 직접 작성, 옵션 사전 결정, 일 분배 메뉴 출력)은 모두 위반. 본 매뉴얼은 운영 모델만 박는다 — 회의창 운영 사고 사례는 `bridge_protocol.md`에 영구 보존.

---

## 5. Stage 플로우 (1~13 상세)

13단계는 Strict canonical reference flow다. Standard는 단계를 압축할 수 있고, Lite는 1, 8, 12, 13만 실행한다.

### 5.1 Stage 1~13 한 줄 정의

| Stage | 이름 | 주된 산출 | 실행자 |
|-------|------|---------|------|
| 1 | 브레인스토밍 | `docs/01_brainstorm_v<X>/brainstorm.md` (방향 / 모드 / has_ui / risk_level) | 운영자 + Cowork(Sonnet) |
| 2 | plan_draft | `docs/02_planning_v<X>/plan_draft.md` 또는 `planning_<NN>.md` | 드래프터(Haiku) |
| 3 | plan_review | `planning_review.md` (개정 제안) | 리뷰어(Opus) |
| 4 | plan_final | `planning_<NN>.md` final 또는 `planning_index.md` | 파이널리즈(Sonnet) + 오케(Opus) |
| 4.5 | 운영자 승인 게이트 | (없음, 결재 행위) | 운영자 |
| 5 | technical_design | `docs/03_design/v<X>_technical_design.md` (모듈 경계 / 데이터 흐름 / 에러 경로 / 테스트 / 보안) | 오케(Opus, high) |
| 6 | UX 디자인 (선택적) | `docs/06_ux/` (UI 변경 시) | 디자인팀 |
| 7 | UI 시안 (선택적) | `docs/07_ui/` (UI 변경 시) | 디자인팀 |
| 8 | 구현 | 본 코드 + 테스트 | `stage_assignments.stage8_impl` |
| 9 | 코드 리뷰 | `docs/04_implementation_v<X>/code_review.md` | `stage_assignments.stage9_review` (기본 Opus) |
| 10 | 디버그 / 패치 | 추가 commit | `stage_assignments.stage10_fix` |
| 11 | Strict 검증 | `docs/05_verification_v<X>/verify.md` (Strict만) | `claude` 고정 (Opus high) |
| 12 | QA | 수동 시나리오 통과 | 운영자 + Claude |
| 13 | 릴리스 | `CHANGELOG.md` 승격 + tag | 운영자 |

### 5.2 모드별 Stage 압축

- **Lite:** 1 → 8 → 12 → 13.
- **Standard:** 1 → 2~4 (각각 또는 압축) → (4.5) → 5 → 8 → 9 → (10) → 12 → 13.
- **Strict:** 1 → 2 → 3 → 4 → 4.5 → 5 → 6 → 7 → 8 → 9 → 10 → 11 → 12 → 13.

### 5.3 Stage Transition Score 임계값

각 단계 완료 보고 파일 말미에 다음 단계 진입 가능 여부 점수표 의무. 임계값 80%. 미달 시 회의창 → 운영자 판단 대기. 상세는 `WORKFLOW.md` Sec.6.

### 5.4 핸드오프 — `handoffs/` 구조 (v0.6.2~)

```
jOneFlow/
├── handoffs/
│   ├── active/
│   │   ├── HANDOFF_v0.6.2.md    (status: active)
│   │   └── HANDOFF_v0.6.3.md    (status: preparing) [미래 예상]
│   ├── archive/
│   │   └── HANDOFF_v0.3.md      (status: archived, 영구 보존)
├── HANDOFF.md                    (symlink → handoffs/active/HANDOFF_v<현재>.md)
```

- `handoffs/active/`에서 `status: active`인 파일은 항상 0~1개. `preparing` 다수 가능.
- `HANDOFF.md`는 **항상 symlink** (직접 편집 금지, F-62-2). 편집 대상은 symlink target.
- Stage 13 완료 시 `ai_step.sh`가 자동으로 `active/` → `archive/` 이동 + `rm -f HANDOFF.md` (옵션 A 부재 정책, F-04-S5a).
- 새 버전 시작 시 `init_project.sh`가 자동으로 `active/HANDOFF_v<신규>.md` 생성 + symlink 갱신.
- archive 보존 = 영구 (브랜치 1주일 정책과 별도).

---

## 6. MANDATORY STARTUP RULE

### 6.1 절대 규칙 (세션 진입 즉시)

1. 이 파일(`docs/operating_manual.md`)을 실제로 읽어라. 읽은 척 금지.
2. `CLAUDE.md`와 `docs/bridge_protocol.md`를 실제로 읽어라.
3. 세 파일 읽기 완료 전 어떤 작업도 하지 마라.
4. 읽지 못하면 "읽지 못했습니다"라고 명시하고 멈춰라.
5. 이 세션에서 실제로 읽지 않았으면 "지침을 따랐다"고 절대 말하지 마라.

### 6.2 R2 진입 순서 (필독)

새 사용자 또는 백지 Claude는 다음 순서로 읽어라. 읽기 순서가 깨지면 jOneFlow 운영 컨벤션을 잘못 학습한다.

```
1. CLAUDE.md          (~80줄, 절대 규칙 + 포인터만)
        ▼
2. docs/bridge_protocol.md  (회의창 ↔ 브릿지 ↔ 오케 통신 모델 + 사고 사례)
        ▼
3. docs/operating_manual.md  (본 문서, 6개 섹션 완전 자족 매뉴얼)
        ▼
4. handoffs/active/HANDOFF_v<X>.md  (현재 진행 상태)
```

### 6.3 백지 Claude 검증 시나리오

신규 프로젝트가 jOneFlow를 가져갔을 때, 메모리 0인 Claude 세션이 위 4개 파일만 읽고 "Stage 1 브레인스토밍 시작" dispatch 1회를 발행할 수 있는가? 검증 절차는 `docs/guides/whitebox_verification.md` 참조.

---

## 7. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v0.6.2 M-Org | Sec.1 조직도 (5계층 + 18명 모델/effort) 신규 작성. Sec.2~6 placeholder. |
| 2026-04-26 | v0.6.2 M-SelfEdu | Sec.2~6 본문 작성 (워크플로우 / 모델 / 페르소나·톤 / Stage 플로우 / MANDATORY STARTUP). R2 진입 순서 명시. F-X-2 / F-62-2 / F-62-3 정책 박음. |
