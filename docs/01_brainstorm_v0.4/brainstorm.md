# jOneFlow v0.4 브레인스토밍 — 회고 + 단순화

**세션:** 8 (2026-04-23)  
**릴리스 타입:** 메타 릴리스 (신규 번들 없음, 신규 기능 없음)  
**목적:** v0.3 빌드 경험 회고 → 구체적 마찰점 도출 → 단순화 방향 확정

---

## 1. v0.4 범위 재정의

v0.4 = 회고 + 단순화. 기능 추가 없음.  
작업 가설: v0.3은 "프로젝트를 쉽게 진행하기 위한 템플릿"이라기엔 너무 무거워졌다.  
v0.5가 기존 v0.4 기능 백로그를 승계.

---

## 2. v0.3 빌드 3대 마찰점 & 단순화 방향

### 마찰점 1위 — 4-중 문서 동기 부담

**문제:** 상태 변경 시마다 HANDOFF + CHANGELOG + dev_history.md + dev_history.ko.md 4개를 동시 갱신해야 했음. 실제로는 읽지 않고 넘기는 문서에 에너지를 쏟는 상황.

**확정된 단순화 방향:**
- `dev_history.md` + `dev_history.ko.md` **폐기** → CHANGELOG.md로 통합
- EN + KO 페어: **공개 전까지 KO only** (EN 번역은 공개 시점에)
- HANDOFF.md 목적 재정의: "다음 에이전트 누락 방지" → Status + Next + 주의사항만
- **다음 세션 프롬프트는 채팅에 직접 출력** (HANDOFF 파일 안에 묻지 않음)

---

### 마찰점 2위 — Stage/Gate 수 과다

**문제:** plan_draft → plan_review → plan_final 3단계로 나뉘는 것이 불필요하게 느껴짐. Stage 11 Final Validation이 Stage 10 Revision과 역할 중복.

**확정된 단순화 방향:**
- **plan_draft 단계 제거** → Stage 2에서 바로 plan_final을 운영자에게 승인 요청
- **Stage 11 고위험 한정** → 고위험 작업 시 Claude 판단으로 진행 여부 묻고 동일 세션에서 진행. fresh-session 요구 폐지.
- Stage 11 판단 기준: Claude가 자체 판단, 운영자 승인 요청 후 진행

---

### 마찰점 3위 — Codex 위임 컨텍스트 단절

**문제:** Codex에게 Stage 위임 시 컨텍스트가 단절되고 수동 프롬프트 복붙이 필요했음. 토큰 비용 절약을 위해 Codex를 썼지만 마찰이 컸음.

**확정된 단순화 방향:**
- **하이브리드 모드 기본값**: Stage 1 = Cowork 데스크탑 1:1, Stage 2–13 = Claude Code 에이전트 팀
- `settings.json` schema v0.2로 업데이트 완료 (에이전트 팀 활성화, tmux 모드)
- CLI 실행: `claude --teammate-mode tmux` (Ghostty + tmux 환경)
- 툴 선택 질의 (온리 데스크탑 / 데스크탑+CLI / 온리 CLI) → **v0.5 백로그**

---

## 3. 기본 모드 난이도 (B)

**결정:** 현재 Strict → **Default** 방향으로 단순화  
핵심 원칙: 모델이 좋아질수록 하네스는 단순해져야 함 (Anthropic Harness Design 원칙)

---

## 4. v0.4 진행 모드 (C)

**결정:** 모드 β — Stage 2부터 라이브로 단순화 적용  
(α = 13-stage 완전 유지, γ = 1/2/12/13만 유지는 기각)

---

## 5. Git 정책 변경

**v0.3 기준:** 작업마다 커밋  
**v0.4 신규 정책 (최소화):**
1. 해당 버전 종료 시
2. 운영자가 일과 마무리 시
3. Claude가 중요 작업이라 판단할 때 → 승인 요청

---

## 6. settings.json schema v0.2 업데이트 (완료)

- 에이전트 팀 활성화: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- tmux 모드: `"teammateMode": "tmux"`
- 모델 최신화 (claude-sonnet-4-6, claude-opus-4-7)
- Stage 1 에이전트 팀 범위 외 명시 (Cowork 전용)
- CLI 실행 플래그 주석 추가: `claude --teammate-mode tmux`

---

## 7. v0.5 백로그 추가 항목 (세션 8)

| # | 항목 | 출처 |
|---|------|------|
| 8 | Claude Code Hooks — Stage 자동 트리거 | 세션 8 |
| 9 | 툴 선택 질의 (온리 데스크탑 / 하이브리드 / 온리 CLI) | 세션 8 |
| 10 | gstack 설계 참조 — 역할 기반 분리, 스킬 구조, 완전성 원칙 적용 검토 | 세션 8 |

**gstack 참조 포인트:**
- GitHub: `https://github.com/GaryTen/gstack` (확인 필요)
- 역할 기반 분리 철학이 jOneFlow 에이전트 팀 구조와 일치
- 스킬 = 마크다운 파일 패턴 → SKILL.md 구조와 동일
- "모델이 좋아질수록 하네스 단순화" 원칙 공유
- Hooks 없이 tmux 병렬 방식 → 현재 jOneFlow 방향과 동일

---

## 8. 다음 세션 (세션 9) 작업 목록

1. HANDOFF.md 경량화 실행
2. dev_history.md + dev_history.ko.md 폐기 처리
3. CLAUDE.md / WORKFLOW.md 단순화 방향 반영
4. v0.4 Stage 2 진행 (단순화 실행 계획 수립)
