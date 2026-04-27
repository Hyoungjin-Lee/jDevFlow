# Stage 12 — QA Checklist (수동 시나리오)

> **발행:** 2026-04-27
> **모드:** Standard (13-stage legacy) — 운영자 + 회의창 수동 진행 영역
> **대상:** v0.6.4 = Jonelab AI팀 운영자 대시보드 (textual TUI, M1~M5 5/5 + personas_18)
> **선행:** Stage 10 압축 (commit `b9aad53`) + Stage 11 verify trail (commit `0af4617`)

---

## 1. 컨텍스트

Stage 12 = 운영자 + 회의창 수동 시나리오 영역 (오케 단독 진행 X). 운영자 결정 (2026-04-27): 작업 지시서 X, 직접 진행 영역. 본 doc = QA 체크리스트 — 각 항목 영역 영역 박음 후 ✅ / ❌ / SKIP 박음. PASS 영역 박힘 후 Stage 13 (릴리스) 진입.

---

## 2. Stage 10 산출물 검증

### 2.1 docs/v0.6.4/stage10_compress.md

| # | 검증 항목 | 박음 |
|---|---------|------|
| 1 | 파일 박힘 (`docs/v0.6.4/stage10_compress.md`) | ☐ |
| 2 | Major R-1 영역 박음 (operating_manual.md Sec.5 16단계 표기 압축) | ☐ |
| 3 | Major R-2 영역 박음 (bridge_protocol.md Sec.0.1 페르소나 매핑 압축) | ☐ |
| 4 | 운영자 판정 = 옵션A 명시 박음 | ☐ |
| 5 | closure 영향 0건 박음 | ☐ |
| 6 | v0.6.5+ 이월 영역 박음 | ☐ |

### 2.2 commit `b9aad53`

| # | 검증 항목 | 박음 |
|---|---------|------|
| 7 | commit 메시지 = `chore(v0.6.4): Stage 10 Major R-1/R-2 compress (옵션A)` | ☐ |
| 8 | 신규 파일만 staged (보호 영역 무손상) | ☐ |
| 9 | git log 박힘 영역 검증 | ☐ |

---

## 3. Stage 11 산출물 검증

### 3.1 docs/v0.6.4/stage11_verify.md

| # | 검증 항목 | 박음 |
|---|---------|------|
| 10 | 파일 박힘 (`docs/v0.6.4/stage11_verify.md`) | ☐ |
| 11 | M1~M5 마일스톤 영역 박음 (commit trail 박힘) | ☐ |
| 12 | Stage 9 R-N 8건 영역 박음 (Critical 0 / Major 2 / Minor 4 / Nit 2) | ☐ |
| 13 | 보호 영역 무손상 박음 (다른 세션 v0.6.6 영역 미접촉) | ☐ |
| 14 | 헌법 영역 박음 (A 패턴 / 추측 진행 금지 / Orc split / push 정공법) | ☐ |
| 15 | verdict = Stage 12 진입 가능 박음 | ☐ |

### 3.2 commit `0af4617`

| # | 검증 항목 | 박음 |
|---|---------|------|
| 16 | commit 메시지 = `chore(v0.6.4): Stage 11 verify.md` | ☐ |
| 17 | 신규 파일만 staged | ☐ |

---

## 4. 보호 영역 무손상 검증 (다른 세션 영역)

| # | 영역 | 박음 |
|---|------|------|
| 18 | uncommitted 파일 (CLAUDE.md / bridge_protocol.md / operating_manual.md / HANDOFF_v0.6.5.md) — 본 세션 미수정 | ☐ |
| 19 | settings.json / scripts/ai_step.sh / scripts/lib/settings.sh — 본 세션 미수정 | ☐ |
| 20 | dispatch/2026-04-27_v0.6.6_infra_standard.md — 본 세션 미접촉 | ☐ |
| 21 | .claude/bridge_status.json — 본 세션 미접촉 | ☐ |
| 22 | handoffs/active/ — 본 세션 미접촉 | ☐ |

---

## 5. 본 세션 commit trail 검증

```
0af4617 chore(v0.6.4): Stage 11 verify.md
b9aad53 chore(v0.6.4): Stage 10 Major R-1/R-2 compress (옵션A)
```

| # | 검증 항목 | 박음 |
|---|---------|------|
| 23 | v0.6.4 commit 정확히 2건 박힘 | ☐ |
| 24 | 다른 세션 commit (v0.6.6 영역) 본 세션 영역 영역 X | ☐ |

---

## 6. Stage 13 진입 영역 (운영자 PASS 후)

| # | 영역 | 박음 |
|---|------|------|
| 25 | CHANGELOG.md v0.6.4 항목 승격 영역 박음 | ☐ |
| 26 | 로컬 tag 박음 (push 보류) | ☐ |
| 27 | HANDOFF_v0.6.4.md status 정정 박음 (paused → archived) | ☐ |

---

## 7. verdict 영역 (운영자 박음)

| 영역 | 결과 |
|------|------|
| Stage 12 QA 결과 | ☐ PASS / ☐ FAIL |
| Stage 13 진입 | ☐ 가능 / ☐ 불가능 |
| 운영자 sign-off | ☐ |

---

## 8. 회의창 메모

- 본 doc = Sec.4 표 (drafter ≤ 800 / reviewer ≤ 600 / finalizer ≤ 500) 압축 doc 영역 (≤ 130줄 박음).
- Stage 12 운영자 결정 (2026-04-27): 작업 지시서 X, 운영자 + 회의창 수동 진행 영역.
- PASS 영역 박힘 후 → Stage 13 진입 시그널 박음 (회의창 → bridge-064 → Orc-064-dev:2.1 또는 회의창 직접 박음 영역).
- FAIL 영역 박힘 후 → 영역 영역 박음 (운영자 결정 박음).
