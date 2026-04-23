# HANDOFF

> R2 읽기 순서 2번째. CLAUDE.md 다음에 읽기.
> 목적: 다음 에이전트가 해야 할 일 누락 방지.
> 구버전: `HANDOFF.archive.v0.3.md` 참조.

---

## Status

**Current version:** v0.5 in progress (started 2026-04-23)
**Last updated:** 2026-04-23
**Current stage:** v0.5 Stage 1 complete — debt-clearance items 1–4 done. Items 5–7 pending.

## 현재 상태

**현재 버전:** v0.5 진행 중 (시작 2026-04-23)
**마지막 업데이트:** 2026-04-23
**현재 단계:** v0.5 Stage 1 완료 — 빚 청산 항목 1–4 완료. 항목 5–7 대기 중.

| 항목 | 내용 |
|------|------|
| 워크플로 모드 | 하이브리드 (Stage 1 = Cowork 1:1, Stage 2–13 = Claude Code 에이전트 팀) |
| v0.4 태그 | `v0.4` → 릴리스 예정 (아래 커밋 후 운영자 로컬 실행) |

---

## Recent Changes

| Date | Description |
|------|-------------|
| 2026-04-23 | Session 10: v0.5 Stage 1 — debt items 1–4 done (§ removal, tool-picker Sec.6 refresh, D4.x2 dev_history note, UI sunset check) |
| 2026-04-23 | Session 9: v0.4 Stage 13 — CHANGELOG [0.4.0] finalized; v0.4 tag/release pending operator |
| 2026-04-23 | Session 9: CLAUDE.md simplified; WORKFLOW.md v2.1; plan_final.md created; dev_history retired |
| 2026-04-23 | Session 8: v0.4 Stage 1 complete; settings.json schema v0.2 |

## 최근 변경 이력

| 날짜 | 설명 |
|------|------|
| 2026-04-23 | 세션 10: v0.5 Stage 1 — 빚 청산 항목 1–4 완료 (§ 제거, tool-picker Sec.6 갱신, D4.x2 dev_history 노트, UI sunset 확인) |
| 2026-04-23 | 세션 9: v0.4 Stage 13 — CHANGELOG [0.4.0] 완성; v0.4 tag/release 운영자 실행 대기 |
| 2026-04-23 | 세션 9: CLAUDE.md 단순화; WORKFLOW.md v2.1; plan_final.md 작성; dev_history 폐기 |
| 2026-04-23 | 세션 8: v0.4 Stage 1 완료; settings.json schema v0.2 |

---

## 다음 할 일

### 🟢 v0.5 완료 항목 (세션 10)

1. ✅ `§` 기호 제거 — `final_review.md`, `code_review.md`
2. ✅ tool-picker Sec. 6 live-triple refresh — v0.5 Stage 1 Standard·medium 반영
3. ✅ `technical_design.md` Sec. 0 + `decisions.md` D4.x2 — dev_history 제거 노트 추가
4. ✅ UI base-only sunset 확인 — 정책 유지 (has_ui=true 없음)

### 🔴 v0.5 미완료 (다음 세션)

5. **`update_handoff.sh` KO 헤더 지원** — Status/Recent Changes EN 헤더 → KO 헤더 인식 추가
6. **shellcheck 설치 (Linux CI)** — CI 설정 수정
7. **Mac CI 자동화** — 테스트 자동화 스크립트 (operator paste 제거)

### 🟡 보류 중 (v0.6 이월)

- Bundle 2 (metadata-refinement) + Bundle 3 (codex-handoff-UX) re-scope
- Claude Code Hooks — Stage 자동 트리거
- 툴 선택 질의 (온리 데스크탑 / 하이브리드 / 온리 CLI)
- gstack 설계 참조

---

## 세션 8–9 주요 결정 + 실행 현황 (v0.4 단순화)

| 마찰점 | 확정 방향 | 세션 9 실행 상태 |
|--------|-----------|----------------|
| 4-중 문서 동기 | dev_history 폐기, KO only (공개 전), HANDOFF 경량화 | git rm 운영자 커밋 대기 중; CLAUDE.md/WORKFLOW.md 참조 제거 완료 |
| Stage/Gate 과다 | plan_draft 제거, Stage 11 고위험 한정 + 동일 세션 진행 | CLAUDE.md + WORKFLOW.md 반영 완료 |
| Codex 컨텍스트 단절 | 하이브리드 모드 기본값, CLI `claude --teammate-mode tmux` | 세션 8 완료 |
| git 정책 | 버전 종료 / 일과 마감 / 중요 작업 3경우만 커밋 | CLAUDE.md 반영 완료 |
| settings.json | schema v0.2 완료 (에이전트 팀 활성화, tmux, 최신 모델) | 세션 8 완료 |
| plan_final | v0.4 Stage 2 실행 계획 | 작성 완료 (`docs/02_planning_v0.4/plan_final.md`) — 운영자 승인 대기 |

---

## v0.5 백로그 (주요 항목)

1. `.skills/tool-picker/SKILL.md` Sec. 6 live-triple refresh
2. `technical_design.md` Sec. 0 verbatim-paste refresh (AC.B1.8)
3. shellcheck 설치 (Linux CI)
4. Mac CI 자동화
5. Bundle 2 + Bundle 3 re-scope
6. canonical 프롬프트 `§` 기호 제거
7. UI base-only sunset 앵커
8. **Claude Code Hooks — Stage 자동 트리거** (세션 8)
9. **툴 선택 질의** (온리 데스크탑 / 하이브리드 / 온리 CLI) (세션 8)
10. **gstack 설계 참조** — 역할 분리, 스킬 구조, 완전성 원칙 검토 (세션 8)
11. **update_handoff.sh KO 헤더 지원** — 현재 EN 헤더 (Status/Recent Changes) 의존; v0.5에서 KO 헤더 인식 추가 예정

---

## 📋 다음 세션 시작 프롬프트

```
HANDOFF.md Status 섹션 + "다음 할 일" 참조해서 이어가죠.
세션 11 = v0.5 빚 청산 항목 5–7 (update_handoff.sh KO 헤더, shellcheck CI, Mac CI 자동화).
전제: 세션 10 커밋 완료.
```
