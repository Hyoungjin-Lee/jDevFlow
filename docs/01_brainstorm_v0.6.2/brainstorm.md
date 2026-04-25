# v0.6.2 브레인스토밍

> Stage 1 산출물. Cowork 세션 23 (2026-04-26, Sonnet).
> 운영자: 지훈 / 모드: Standard

---

## 1. v0.6.2 핵심 방향

v0.6.1(명칭 변경) 완료 후 진입. 조직/브랜드 정비 + 프레임워크 UX 개선.

**jOneFlow Framework** 포지셔닝 확정:
> "AI 팀 운영을 위한 워크플로우 프레임워크"
> 하네스 엔지니어링을 누구나 쓸 수 있게 제품화.

---

## 2. v0.6.2 scope 확정

| # | 과제 | 내용 |
|---|------|------|
| 1 | 조직도 개편 정식 반영 | N2/N3/P1/P2 — CLAUDE.md Sec.2.5 강화 |
| 2 | Apache 2.0 라이선스 | LICENSE 파일 루트 추가 |
| 3 | slash command 래퍼 | `/init-project` / `/switch-team` / `/ai-step` |
| 4 | handoffs/ 폴더 구조 | 심볼릭 링크 + frontmatter status + 자동화 |

---

## 3. 조직도 개편 (N2/N3/P1/P2)

**JoneLab 조직도 v0.1 기본형 (세션 23 티타임 확정):**

```
CEO 이형진
└── CTO 실장(Cowork) 백현진 (Sonnet, medium)
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

**모델/effort 배정 원칙 (티타임 확정):**
- CEO/CTO: 전략 판단 → Sonnet / medium (Cowork 세션)
- PM 브릿지: 허브 역할, 빠른 분배 → Opus / medium
- 오케스트레이터: 팀 지휘 + 최종 판단 → Opus / high
- 리뷰어: 깊은 피드백, 놓치면 재작업 → Opus / high
- 파이널리즈: 최종 정리/검증 → Sonnet / medium
- 드래프터: 초안, 속도 우선 → Haiku / medium

**CLAUDE.md 반영 대상:**
- Sec.2.5 조직도 전체 교체 (현재 3계층 → 5계층 정식)
- 향후 HR팀 추가 가능 구조 (미결)

---

## 4. Apache 2.0 라이선스

- `LICENSE` 파일 루트(`jOneFlow/`) 추가
- 저작권자: Hyoungjin Lee / JoneLab
- 연도: 2026
- 단순 파일 추가 — Lite 모드 처리 가능

---

## 5. slash command 래퍼

**배경:** 사용자가 shell script 경로 몰라도 `/명령어` 하나로 jOneFlow 사용 가능. 비개발자 진입 장벽 제거.

**대상 3개:**

| slash command | 연결 스크립트 | 핵심 기능 |
|--------------|-------------|---------|
| `/init-project` | `scripts/init_project.sh` | 새 프로젝트 시작 — workflow_mode + team_mode 설정 |
| `/switch-team` | `scripts/switch_team.sh` | 런타임 team_mode 전환 |
| `/ai-step` | `scripts/ai_step.sh` | Stage 자동 진행 (`--auto` / `--resume` / `--status`) |

**구현 방식:** `.claude/commands/` 폴더에 markdown 파일 추가.

---

## 6. handoffs/ 폴더 구조

**배경:** 병렬 스프린트 지원. v0.6.1 진행 중에 v0.6.2 브레인스토밍 가능했던 것처럼, HANDOFF 파일도 버전별 분리 필요.

**확정 구조:**

```
jOneFlow/
  handoffs/
    active/
      HANDOFF_v0.6.1.md    ← status: active
      HANDOFF_v0.6.2.md    ← status: preparing
    archive/
      HANDOFF_v0.5.0.md    ← status: archived
      HANDOFF_v0.6.0.md    ← status: archived
  HANDOFF.md               ← 심볼릭 링크 (현재 active 버전 고정)
```

**운영 규칙:**
- `HANDOFF.md` — 항상 현재 진행 중인 버전 심볼릭 링크. R2 진입점 유지.
- frontmatter `status` 필드: `active` / `preparing` / `archived`
- 새 버전 시작: `active/` 신규 파일 생성 + 심볼릭 링크 교체
- 릴리스 완료: `active/` → `archive/` 이동 + 다음 버전으로 링크 교체

**자동화 (ai_step.sh 연동):**
- Stage 13 완료 시 → archive 이동 + 심볼릭 링크 교체 자동
- `init_project.sh` 새 버전 시작 시 → active/ 신규 파일 생성 자동

---

## 7. Cowork/Code 역할 재정의

**확정:**
- **Cowork** — 운영자 + Claude 전략/브레인스토밍 전용. 구현 직접 실행 없음.
- **Code (새 세션)** — 브릿지 컨트롤 창구. bash/파일 직접 접근으로 브릿지 프롬프트 작성 + 파일 확인 + 판단 처리. 운영자가 복붙 없이 Code 세션 하나로 브릿지 컨트롤 가능.
- **브릿지 (스티브)** — CLI 오케스트레이터 컨트롤. 역할 유지.

**효과:** 운영자 창구 단일화. Cowork(전략) or Code(실행) 중 택1.

---

## 8. 페르소나별 커뮤니케이션 톤

- **Cowork(CTO 실장) ↔ 운영자** — 편하고 친근하게. 티타임 가능.
- **브릿지(PM) → 운영자** — 친근하되 존댓말. 보고는 간결하게. 반말 금지.
- **오케스트레이터 → 브릿지** — 업무적, 명확하게.
- **팀원 → 오케스트레이터** — 각 페르소나 성격 유지 (준혁 존댓말/민지 직설/태원 간결).

---

## 9. Non-goal (v0.6.2)

- 주간보고 플로우 — 이월
- HR팀 추가 — 훨씬 나중
- F1~F5 기술 빚 — v0.6.3
- D6~D7 Hooks/ETHOS — v0.6.4

---

## 8. 다음 단계

- Stage 2–4 기획 (Opus + tmux 팀모드)
- 산출물: `docs/02_planning_v0.6.2/`
