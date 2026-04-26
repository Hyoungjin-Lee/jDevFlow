---
id: BR-002
title: v0.6.3 Stage 9 Codex 자동 리뷰 호출 실패 — 인터페이스 보류 + 외부 API 자율 권한 외
status: open (v0.6.4 plugin-cc 고도화 이월 권고)
severity: 🟡 중간 (self-review fallback 정상 동작, 본 release 비차단)
date: 2026-04-27
authored_by: 공기성 (개발팀 PL, Opus/high, Orc-063-dev:1.1)
session: 27
related_commits:
  - 5ac2e16 (Stage 8 M1+M4 critical path)
  - 868de75 (Stage 8 M2+M3+M5 final)
  - ea2fd16 (Stage 8 잔존 + Stage 9~13 dispatch)
related_dispatches:
  - dispatch/2026-04-27_v0.6.3_stage9_review.md
related_decisions:
  - 운영자 결정 #15 (Q5): v0.6.3 = conditional 인터페이스(분기 로직)만 / plugin-cc 자동 호출 고도화 = v0.6.4 후속
  - F-62-8: 리뷰어 conditional 환경 분기 메커니즘
---

# BR-002 — v0.6.3 Stage 9 Codex 자동 리뷰 호출 실패

## 1. 증상

`stage_assignments.stage9_review = "codex"` 설정에도 불구하고 v0.6.3 Stage 9에서 Codex 1차 자동 호출 미실시. self-review fallback 경로로 우회 진행.

## 2. 호출 실패 사유 (구체)

### 2.1 정책상 보류 (1차 사유)

운영자 결정 #15 (Q5): "v0.6.3 = conditional 인터페이스(분기 로직)만 + plugin-cc 자동 호출 고도화 = v0.6.4 후속" 흡수.

→ Stage 5 design_final.md Sec.2 F-62-8 본문에 "Stage 8 구현자는 로직만 구현" 명시 + Sec.7 M5 리스크 "v0.6.4 이월 → v0.6.3 incomplete" 인지.

### 2.2 외부 API 자율 권한 영역 (2차 사유)

CLAUDE.md Sec.3 보안 영역 / `docs/operating_manual.md` Sec.2.6 운영자 승인 게이트:
- ❌ 외부 API 호출 (비용 / 권한 영향) → 운영자 승인 필요

Codex CLI 호출 = 외부 API 호출 영역 (cloud 또는 local 인프라 의존, 비용 발생 가능). 자율 모드 권한으로 회의창(공기성 1.1) 자체 판단 불가.

### 2.3 plugin-cc 미구현 (3차 사유 — 후속 영역)

`scripts/ai_step.sh` Stage 9 분기 로직에 `plugin-cc` 자동 호출 본체 미구현. 분기 인터페이스 sketch만 존재(`if "$stage9_reviewer" = "codex"; then echo "Codex review 경로 활성화"`).

→ 실제 plugin-cc / Codex CLI / 우회 패턴 호출 본체 = v0.6.4 plugin-cc 고도화 영역 (운영자 결정 #15).

## 3. 시도 명령 / 에러 로그

### 3.1 환경 감지 (PASS)

```bash
$ command -v codex
/opt/homebrew/bin/codex
```

→ Codex CLI 설치 확인. 환경 자체는 모드 A trigger 매칭.

### 3.2 분기 인터페이스 trigger (PASS)

```bash
$ grep -n "stage9_reviewer\|stage9_review" scripts/ai_step.sh
# (분기 로직 존재 확인 — Stage 8 M5 산출물)
```

→ AC #19/#20 PASS. 인터페이스 측면 정합.

### 3.3 자동 호출 본체 (미실행)

본 stage = 자동 호출 미실행. 시도 명령 없음. 에러 로그 없음. (정책상 보류 + 외부 API 자율 권한 외)

## 4. fallback 적용 결과

### 4.1 self-review fallback 활성화

- 1.3 최우영-be-reviewer 직접 review 작성 (페르소나 = 원래 코드 리뷰어, design_final Sec.6 모드 B)
- sketch 20건(MR1-1~MR1-12, MR4-1~MR4-8) 활용
- 본 BR 링크 = `docs/04_implementation_v0.6.3/code_review.md` frontmatter 흡수 명시

### 4.2 영향 영역

| 영역 | fallback 동작 | 정합 |
|------|------------|------|
| code_review.md 작성 | 1.3 self-review (Opus high) | ✅ 정상 |
| 보강 영역 식별 | sketch + 실 commit cross-check | ✅ 정상 |
| AC 회귀 검증 | bash tests/v0.6.3/run_ac_v063.sh 직접 실행 | ✅ 정상 |
| Stage 10 fix loop trigger | 회귀 발생 시 1.4 자동 진입 | ✅ 정상 |
| Stage 12 진입 게이트 | Score ≥ 80% + AC 회귀 0건 → APPROVED | ✅ 정상 |

→ self-review fallback 경로 전체 정상 동작. **본 release 비차단.**

## 5. 후속 영역 이월 제안

### 5.1 v0.6.4 plugin-cc 고도화 (1차 권고 — 운영자 결정 #15 정합)

- `scripts/ai_step.sh` Stage 9 분기에 plugin-cc 자동 호출 본체 구현
- Codex 결과 회수 → docs/04_implementation_v<X>/codex_response.md 자동 작성
- 1.3 리뷰어 페르소나 = (c) 통합 검증자로 전환 (design_final Sec.6 모드 A)
- 외부 API 자율 권한 영역 = 운영자 사전 승인 게이트 별도 박음

### 5.2 v0.6.6 외부 통합 (2차 권고 — 효율 관리 방향)

`brainstorm.md` Sec.3 Non-goal에 v0.6.6 = "외부 통합" 명시. plugin-cc / Codex CLI / 외부 LLM 호출 패턴 정형화.

### 5.3 본 BR 종결 조건

- v0.6.4 또는 v0.6.6 release 시 plugin-cc 본체 구현 완료 + 자동 호출 1회 PASS 입증
- 그 시점에 BR-002 status = closed + commit SHA 링크

## 6. Stage 13 운영자 보고 영역

본 BR은 자율 모드 비차단(self-review fallback 정상 동작)이지만 Stage 13 최종 보고 시 운영자 노출 영역 (백실장 정정 박힘):

```
📡 Stage 13 release v0.6.3 — commit chain + Score + AC + BR 목록
  - BR-002 (Codex review 호출 실패, self-review fallback, v0.6.4 이월) 🟡
```

## 7. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | 작성 (세션 27) | 공기성 dev PL — 백실장 정정 흡수 (Stage 9 Codex 실패 시 BR 패턴 박힘). self-review fallback 결과 trace 시작. |
