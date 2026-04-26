---
version: v0.6.2
stage: 4 (plan_final, index)
date: 2026-04-26
mode: Standard
status: pending_operator_approval
session: 25
authored_by: 박지영 (기획팀 PL, 오케스트레이터)
upstream:
  - docs/01_brainstorm_v0.6.2/brainstorm.md
  - docs/02_planning_v0.6.2/planning_review.md
  - docs/02_planning_v0.6.2/planning_01_org.md
  - docs/02_planning_v0.6.2/planning_02_license.md
  - docs/02_planning_v0.6.2/planning_03_slash.md
  - docs/02_planning_v0.6.2/planning_04_handoffs.md
  - docs/02_planning_v0.6.2/planning_05_selfedu.md
---

# jOneFlow v0.6.2 — Planning Index

> **상위:** `docs/01_brainstorm_v0.6.2/brainstorm.md` (Stage 1, 세션 23)
> **본 문서:** `docs/02_planning_v0.6.2/planning_index.md` (Stage 4 종합 인덱스, 세션 25)
> **하위:** Stage 4.5 **운영자 승인 게이트** (Q1/Q2/Q3/Q5/Q6 5건 답변 + 5개 final 승인) → Stage 5 기술 설계
> **상태 배너:** ⏳ **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.

본 인덱스는 v0.6.2 Stage 2~4(Standard 모드)의 5개 항목별 plan_final + 통합 review를 한 눈에 정리한다. 5개 plan_final이 본체이며, 본 인덱스는 의존 그래프 / 작업 순서 / AC 총괄 / 운영자 결정 게이트만 수렴한다.

---

## Sec. 1. 산출물 6종

| # | 파일 | 역할 | 라인 수 | 상태 |
|---|------|------|--------|------|
| 1 | `planning_01_org.md` | 조직도 5계층/18명 정식 반영 (CLAUDE.md Sec.2.5 → 5~10줄 포인터, 본체는 `docs/operating_manual.md#조직도`) | 247 | final, pending_operator_approval |
| 2 | `planning_02_license.md` | Apache 2.0 라이선스 교체 (현 MIT → Apache 2.0, 저작권자 `Hyoungjin Lee / JoneLab`, 연도 2026) | 299 | final, pending_operator_approval |
| 3 | `planning_03_slash.md` | slash command 래퍼 3종 (`.claude/commands/{init-project,switch-team,ai-step}.md` 신규) | 421 | final, pending_operator_approval |
| 4 | `planning_04_handoffs.md` | `handoffs/{active,archive}/` 폴더 구조 + symlink + frontmatter status + ai_step.sh/init_project.sh hook 자동화 | 378 | final, pending_operator_approval |
| 5 | `planning_05_selfedu.md` | jOneFlow Self-Contained 교육 구조 (CLAUDE.md ~80줄 슬림, `docs/operating_manual.md` 신규, init_project.sh scaffold 확장) | 281 | final, pending_operator_approval |
| 6 | `planning_index.md` (본 문서) | 5개 합본 + 의존 그래프 + 작업 순서 + AC 총괄 + 운영자 결정 게이트 | — | final |

부속: `planning_review.md` (576줄) — 김민교 책임연구원 통합 리뷰. 31건 개정 + Q1~Q7. v3 final 흡수 흔적은 각 doc Sec.0 변경 요약 참조.

---

## Sec. 2. brainstorm Sec.2 scope ↔ 5개 planning 매핑 (F-X-8 박음)

| brainstorm scope (Sec.2 + Sec.9) | planning doc |
|---|---|
| 조직도 개편 정식 반영 (N2/N3/P1/P2) | planning_01_org |
| Apache 2.0 라이선스 | planning_02_license |
| slash command 래퍼 3종 | planning_03_slash |
| handoffs/ 폴더 구조 | planning_04_handoffs |
| jOneFlow Self-Contained 교육 구조 (Sec.9) | planning_05_selfedu |

brainstorm Sec.2 표는 v0.6.2 scope 4개로 그려져 있으나, Sec.9가 신규 추가 항목이므로 plan_final 기준 5개로 확장 (F-X-8). Stage 8 구현 진입 시 brainstorm Sec.2 표를 5개 행으로 갱신할 것.

---

## Sec. 3. 의존 그래프 + 권장 구현 순서 (F-X-7 박음)

```
                  ┌──────────────────────────┐
                  │ planning_02_license      │  독립 (cold start)
                  │ — LICENSE 교체           │
                  └────────────┬─────────────┘
                               │ (선행)
                  ┌────────────▼─────────────┐
                  │ planning_01_org          │  CLAUDE.md Sec.2.5 포인터 + operating_manual 조직도 거주
                  │ — 5계층/18명 정식        │
                  └────────────┬─────────────┘
                               │ (강한 결합)
                  ┌────────────▼─────────────┐
                  │ planning_05_selfedu      │  CLAUDE.md ~80줄 슬림 + docs/operating_manual.md 신규
                  │ — Self-Contained 교육    │
                  └────────────┬─────────────┘
                               │ (약한 결합)
                  ┌────────────▼─────────────┐
                  │ planning_04_handoffs     │  ai_step.sh/init_project.sh hook
                  │ — handoffs/ 구조         │
                  └────────────┬─────────────┘
                               │ (참고 권장)
                  ┌────────────▼─────────────┐
                  │ planning_03_slash        │  .claude/commands/ 3종
                  │ — slash 래퍼             │
                  └──────────────────────────┘
```

**권장 구현 순서:** `02 → 01 → 05 → 04 → 03`

근거:
- **02 먼저**: 독립 작업, cold start로 안전한 워밍업. LICENSE 단일 파일 교체.
- **01 → 05**: 조직도 정식판이 Self-Contained 교육 구조의 docs/operating_manual.md에 거주하므로 정식판 확정 후 매뉴얼 작성.
- **05 → 04**: Self-Contained 매뉴얼이 handoffs/ 구조를 설명하므로 매뉴얼 골격 후 handoffs/ 도입.
- **04 → 03**: slash `/ai-step`이 handoffs/ 자동화 hook과 결합하므로 hook 구현 후 래퍼 추가.

---

## Sec. 4. 횡단 F-X-N 분배 (review Sec.3 + finalizer 흡수)

| ID | 유형 | 흡수 doc | 처리 결론 |
|----|------|---------|----------|
| F-X-1 | 정책 commit (F-EDU-D1 + F-ORG-D1 통합) | 01, 05 | 조직도 5계층/18명 표는 `docs/operating_manual.md#조직도`에 단독 거주, `CLAUDE.md` Sec.2.5는 5~10줄 + 포인터. AC-Org-3와 AC-Edu-1 정합성 동시 만족. |
| F-X-2 | Stage 5 이월 | 04, 05 | bridge_protocol.md 위치 변경 시 symlink 정책 (파일 ↔ symlink 변환 호환성) Stage 5 기술 설계에서 결정. |
| F-X-3 | Stage 5 이월 | 03, 04 | slash 명령어 ↔ handoffs/ hook 결합 회귀 테스트 시나리오 Stage 5에서 명세. |
| F-X-4 | Stage 5 이월 | 01 | 18명 페르소나 ↔ `.claude/settings.json` schema v0.4 보존 / 확장 정책 Stage 5에서 결정. |
| F-X-5 | 명시 추가 | 05 | R2 진입 순서 명시: `CLAUDE.md` → `bridge_protocol.md` → `operating_manual.md` → `handoffs/`. |
| F-X-6 | 명시 추가 | 02, 03 | `.md` 파일 SPDX 헤더 미적용 정책 (Apache 2.0 SPDX는 `.py`/`.sh`만, slash command `.md`도 미적용). |
| F-X-7 | 구현 순서 박음 | 01, 02, 03, 04, 05 전부 | Sec.3 의존 그래프(02→01→05→04→03)를 각 doc Sec.6 의존성에 동일 표현으로 박음. |
| F-X-8 | scope 표 5개로 확장 | 01 | Sec.0에 brainstorm Sec.2 + Sec.9 통합 5개 scope 표 박음 (Sec.2 본 인덱스에서 재진술). |

drafter v2 ID(F-ORG-1~3 / F-LIC-1~5 / F-SLA-1~5 / F-04-1~4,S5a,S5b / F-EDU-1~5)는 각 doc Sec.0 v2 → final 변경 요약 표 참조.

---

## Sec. 5. AC 총괄

5개 doc의 Acceptance Criteria 총합. 자동 검증(grep / wc / test / readlink 등 명령 1줄로 판정 가능) / 수동 검증(QA 절차 필요) / Stage 5 이월(spec 미확정으로 검증 정의 보류) 분리.

| doc | AC 자동 | AC 수동 | Stage 5 이월 | AC 총합 |
|-----|--------|--------|-------------|--------|
| planning_01_org | 3 | 3 | 1 | 7 |
| planning_02_license | 9 | 1 | 0 | 10 |
| planning_03_slash | 4 | 3 | 1 | 8 |
| planning_04_handoffs | 5 | 0 | 3 (partial 2 + F-04-D1 후 1) | 8 |
| planning_05_selfedu | 7 | 0 | 0 | 7 |
| **합계** | **28** | **7** | **5** | **40** |

**자동 검증 비율 = 70.0%** (28/40). Stage 9 코드 리뷰 단계에서 자동 항목은 `bash` 스크립트로 일괄 검증, 수동 항목은 QA 체크리스트로 운영자 검수.

상세 AC는 각 doc Sec.5 참조.

---

## Sec. 6. 운영자 결정 게이트 (Q1~Q7)

Stage 4.5 운영자 승인 게이트에서 답변 필수 5건 + finalizer 결정 후 운영자 컨펌 권장 2건.

| Q | 거주 doc | 성격 | 요지 |
|---|---------|------|------|
| **Q1** | planning_05 | **운영자 결정 필수** | 글로벌 `~/.claude/CLAUDE.md` 영역 수정 v0.6.2 scope 포함 여부. 현 plan_final은 **scope 외 (보류)**로 작성. |
| **Q2** | planning_02 | **운영자 결정 필수** | README 라이선스 뱃지 변경 범위 (영문 README + 한국어 README + 양쪽). |
| **Q3** | planning_05 | **운영자 컨펌 필요** | `docs/bridge_protocol.md` ↔ `docs/operating_manual.md` 통합 정책. finalizer 권장 = 옵션 B(독립 + link). |
| Q4 | planning_04 | finalizer 결정 → 운영자 확인 권장 | `handoffs/archive/` 보존 기간. finalizer 결정 = 영구 보존. |
| **Q5** | planning_01 | **운영자 결정 필수** | 18명 페르소나 가동 시점 (v0.6.2 본 릴리스 vs 후속 버전). |
| **Q6** | planning_02 | **운영자 결정 필수** | GitHub 외부 fork/PR에 MIT 라이선스 기반 활동 잔존 여부 확인 (Apache 2.0 전환 영향). |
| Q7 | planning_05 | finalizer 결정 → 운영자 확인 권장 | `docs/operating_manual.md` 분량. finalizer 결정 = 단일 파일 ≤ 1000줄. |

**Stage 4.5 게이트 진입 조건:** Q1, Q2, Q3, Q5, Q6 — **5건 전부 답변 + 5개 plan_final 승인.** 미답변 시 Stage 5 진입 금지.

---

## Sec. 7. 다음 단계 (Stage 4.5 → Stage 5 → Stage 8)

```
[현재 위치] Stage 4 plan_final (5/5 + index) ✅
                          │
                          ▼
              ┌────────────────────────────┐
              │ Stage 4.5 운영자 승인 게이트 │
              │  - Q1/Q2/Q3/Q5/Q6 답변     │
              │  - 5개 plan_final 승인      │
              └────────────┬───────────────┘
                           │ (운영자 답변 + 승인)
                           ▼
              ┌────────────────────────────┐
              │ Stage 5 technical_design   │
              │  - F-X-2/3/4/AC 이월 5건 정의│
              │  - 5개 항목 통합 설계 1 trail│
              │  - hook dry-run 명세        │
              │  - sed BSD/GNU 헬퍼 결정    │
              └────────────┬───────────────┘
                           │
                           ▼
              ┌────────────────────────────┐
              │ Stage 8 구현 (02→01→05→04→03) │
              │  - 5개 항목 순차 implement   │
              │  - 각 항목 commit 분리      │
              └────────────────────────────┘
```

---

## Sec. 8. 작성 책임

| 단계 | 담당 (페르소나) | 모델 / effort | 산출 |
|------|----------------|--------------|------|
| Stage 2 plan_draft (5개) | 장그래 (주임연구원) | Haiku / medium | planning_01~05 v1 (1,256줄) |
| Stage 3 plan_review (통합) | 김민교 (책임연구원) | Opus / high | planning_review.md (576줄, 31건 + Q1~Q7) |
| Stage 3 → revised (5개) | 장그래 (주임연구원) | Haiku / medium | planning_01~05 v2 (revisions_absorbed) |
| Stage 4 plan_final (5개) | 안영이 (선임연구원) | Sonnet / medium | planning_01~05 v3 final (1,626줄, cross_cutting_absorbed) |
| Stage 4 planning_index.md | 박지영 (PL, 오케스트레이터) | Opus / high | 본 문서 |

조직도 v0.1 정식판은 `docs/01_brainstorm_v0.6.2/brainstorm.md` Sec.3 참조 (planning_01_org final에서 `docs/operating_manual.md#조직도` 거주처 결정).

---
