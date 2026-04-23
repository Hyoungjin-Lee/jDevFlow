---
version: v0.4
stage: 2 (plan_final)
date: 2026-04-23
mode: Standard (v0.4 자체 단순화 적용 — plan_draft 건너뜀)
status: approved
---

# jOneFlow v0.4 — 단순화 실행 계획 (plan_final)

> **세션 9** · brainstorm.md (세션 8) 기반
> 운영자 승인 필요 → Stage 3 (기술 설계) 진입 전 확인

---

## 1. 목표

v0.3 빌드 경험에서 도출된 **구체적 마찰점 3가지**를 제거하여,
jOneFlow 템플릿을 "신규 프로젝트에 즉시 적용 가능한 기본값"으로 만든다.
기능 추가 없음. 코드 변경 없음. 문서/워크플로우 레이어만 수정.

---

## 2. 범위 (In-scope)

| # | 작업 | 산출물 | 담당 |
|---|------|--------|------|
| S1 | `dev_history.md` + `dev_history.ko.md` 폐기 | `git rm` + CHANGELOG 통합 | 세션 9 |
| S2 | `CLAUDE.md` 단순화 반영 | CLAUDE.md (수정) | 세션 9 ✅ |
| S3 | `WORKFLOW.md` 단순화 반영 | WORKFLOW.md v2.1 (수정) | 세션 9 ✅ |
| S4 | `HANDOFF.md` 경량화 | HANDOFF.md (수정) | 세션 9 |
| S5 | v0.4 plan_final 작성 | 이 파일 | 세션 9 ✅ |
| S6 | CHANGELOG.md `[Unreleased]` → `[0.4.0]` 준비 | CHANGELOG.md | 세션 10 또는 릴리스 시 |
| S7 | v0.4 tag + GitHub release | `git tag -a v0.4` | 운영자 로컬 (세션 10) |

**Out-of-scope:**
- Bundle 2 / Bundle 3 기능 작업 (v0.5 백로그)
- `.skills/tool-picker/SKILL.md` Sec. 6 live-triple refresh (v0.5)
- shellcheck / Mac CI 자동화 (v0.5)
- `settings.json` 추가 변경 (세션 8에서 완료)
- `CLAUDE.md` / `WORKFLOW.md` 의 KO 버전 EN 번역 (공개 전까지 KO only)

---

## 3. 성공 기준 (측정 가능)

| 기준 | 완료 조건 |
|------|----------|
| 4-중 갱신 부담 제거 | `dev_history.md` + `dev_history.ko.md` git rm 완료; CLAUDE.md/WORKFLOW.md 참조 없음 |
| Stage 11 부담 감소 | WORKFLOW.md + CLAUDE.md 에서 "fresh-session required" 표현 사라짐 |
| plan_draft 제거 | WORKFLOW.md Stage coverage 표에서 Standard가 plan_draft 생략으로 기록됨 |
| HANDOFF 경량화 | HANDOFF.md 가 Status + Next + 주의사항만 포함 (다음 세션 프롬프트는 채팅 직출력) |
| 테스트 통과 | `bash tests/bundle1/run_bundle1.sh` 10/10 PASS + `sh tests/run_bundle4.sh` 4/4 PASS |

---

## 4. 리스크 & 대응

| 리스크 | 가능성 | 대응 |
|--------|--------|------|
| WORKFLOW.md 수정 후 bundle4 테스트 실패 (doc-discipline 규칙 충돌) | 중 | 수정 후 run_bundle4.sh 즉시 실행; 실패 시 해당 테스트 케이스 분석 |
| dev_history 폐기 후 감사 추적 단절 | 낮 | CHANGELOG.md가 대체 기록을 포함; git log가 1차 감사 소스 |
| HANDOFF.md 경량화로 컨텍스트 누락 | 낮 | R2 읽기 순서 (CLAUDE.md → HANDOFF.md → WORKFLOW.md) 는 유지; 누락된 컨텍스트는 CHANGELOG로 보완 |

---

## 5. 타임라인

| 세션 | 작업 | 예상 |
|------|------|------|
| 9 (현재) | S1~S5 완료, 테스트 실행 | 2026-04-23 |
| 10 | S6 CHANGELOG 완성, S7 v0.4 tag/release | 미정 |

---

## 6. 운영자 승인 요청

위 계획으로 진행해도 될까요?
- 승인 시: Stage 3 (기술 설계 — 이번 v0.4는 skip 가능, 코드 변경 없으므로) → Stage 8 건너뜀 → Stage 12/13 릴리스 준비로 직행
- 수정 요청 시: 위 표 중 변경할 항목 알려주시면 반영 후 재확인
