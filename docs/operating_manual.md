# jOneFlow Operating Manual

> **본 문서의 위치:** R2 진입 순서 3번째 — `CLAUDE.md` → `docs/bridge_protocol.md` → **본 문서** → `handoffs/active/HANDOFF_v<X>.md`.
> **목적:** 새 사용자(또는 백지 Claude)가 프레임워크 파일만 읽으면 jOneFlow를 즉시 올바르게 운영할 수 있는 자기-완결(Self-Contained) 매뉴얼.
> **분량 정책 (F-62-3):** 단일 파일 ≤ 1000줄. 초과 시 `docs/manual/<topic>.md` 폴더로 분할.
> **이식성:** `init_project.sh` scaffold 시 `cp -r docs/operating_manual.md docs/bridge_protocol.md docs/guides/` 로 신규 프로젝트에 복사 (brainstorm/planning 영역은 제외).

---

## 1. 조직도 (JoneLab 5계층 정식판, v0.6.2)

JoneLab은 5계층 조직으로 구성된다. 각 페르소나는 모델/effort 배정이 결정되어 있으며, 이 배정은 운영 영역에 텍스트로만 정의된다 (`.claude/settings.json` schema v0.4 미변경, F-X-4).

### 1.1 5계층 ASCII 트리

```
CEO 이형진
└── CTO 실장(Code) 백현진 (Sonnet, medium)
    └── PM – 브릿지(Code) 스티브 리 (Opus, medium)
        ├── 기획팀 (tmux, Code CLI)
        │   ├── 오케스트레이터 – 팀장(PL) 박지영 (Opus, high)
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
| 2 | 백현진 | CTO 실장 (Code) | Sonnet | medium |
| 3 | 스티브 리 | PM 브릿지 (Code) | Opus | medium |
| 4 기획팀 | 박지영 | 오케스트레이터 (PL) | Opus | high |
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
- **PM 브릿지 (Opus, medium)** — 허브 역할. 회의창 ↔ 오케 통신 라우팅. 빠른 분배 + 정확한 dispatch 작성. Opus는 dispatch 본문 깊이 위해, medium effort는 회의창 응답 속도 위해.
- **오케스트레이터 (Opus, high)** — 팀 지휘 + 최종 판단. 팀원 분담 + 통합 + verdict. 깊이 있는 결정이 핵심이라 high effort.
- **리뷰어 (Opus, high)** — 깊은 피드백. 놓치면 Stage 10 재작업 비용 큼. 가장 깊이 있는 역할.
- **파이널리즈 (Sonnet, medium)** — 최종 정리/검증. 리뷰 피드백 흡수 + 일관성 마감. 정확하지만 빠른 마감 필요 → Sonnet medium.
- **드래프터 (Haiku, medium)** — 초안 작성. 속도 우선. 5개 문서 병렬 가능. 깊이는 리뷰어가 보강.

### 1.4 HR팀 미결 표기

<!-- HR team TBD -->
향후 HR팀(채용/성과/교육) 추가 가능. 현재는 예약된 자리 미배정.

### 1.5 페르소나 가동 시점

현재 가동 중인 페르소나는 4명 (스티브 리 / 박지영 / 김민교 / 안영이 / 장그래 — 기획팀 + PM 브릿지 위주). 18명 정식 가동은 **v0.6.2 완료 후 별건 세션** (운영자 결정 게이트 Q5).

---

## 2. 워크플로우 모드 — Lite / Standard / Strict

본 섹션은 M-SelfEdu 단계에서 작성된다. 현재는 placeholder. 임시 참조: `WORKFLOW.md`.

---

## 3. 모델 정책 (Stage별 모델 배정)

본 섹션은 M-SelfEdu 단계에서 작성된다. 현재는 placeholder. 임시 참조: `CLAUDE.md` Sec.4.

---

## 4. 페르소나 + 톤 (커뮤니케이션 가이드)

본 섹션은 M-SelfEdu 단계에서 작성된다. 현재는 placeholder. 임시 참조: `docs/01_brainstorm_v0.6.2/brainstorm.md` Sec.8.

---

## 5. Stage 플로우 (1~13 상세)

본 섹션은 M-SelfEdu 단계에서 작성된다. 현재는 placeholder. 임시 참조: `WORKFLOW.md` Sec.3.

---

## 6. MANDATORY STARTUP RULE

본 섹션은 M-SelfEdu 단계에서 작성된다. 현재는 placeholder. 임시 참조: `CLAUDE.md` 상단 박스.

---

## 7. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v0.6.2 M-Org | Sec.1 조직도 (5계층 + 18명 모델/effort) 신규 작성. Sec.2~6 placeholder. |
