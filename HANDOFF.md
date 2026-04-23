# HANDOFF

> R2 읽기 순서 2번째. CLAUDE.md 다음에 읽기.
> 목적: 다음 에이전트가 해야 할 일 누락 방지.
> 구버전: `HANDOFF.archive.v0.3.md` 참조.

---

## Status

**Current version:** v0.4 (in progress — retrospective + simplification)
**Last updated:** 2026-04-23
**Current stage:** v0.4 Stage 2 complete — plan_final written; CLAUDE.md + WORKFLOW.md simplified (session 9). Awaiting operator commit + plan_final approval.

## 현재 상태

**현재 버전:** v0.4 진행 중 (회고 + 단순화 메타 릴리스)
**마지막 업데이트:** 2026-04-23
**현재 단계:** v0.4 Stage 2 완료 — plan_final 작성; CLAUDE.md + WORKFLOW.md 단순화 반영 (세션 9). 운영자 커밋 + plan_final 승인 대기 중.

| 항목 | 내용 |
|------|------|
| 워크플로 모드 | 하이브리드 (Stage 1 = Cowork 1:1, Stage 2–13 = Claude Code 에이전트 팀) |
| v0.3 태그 | `v0.3` → commit `ebb1e98` (push + GitHub release: 운영자 로컬 쉘에서 실행 필요) |

---

## Recent Changes

| Date | Description |
|------|-------------|
| 2026-04-23 | Session 9: CLAUDE.md simplified (Stage 11 fresh-session removed, git 3-case policy, dev_history→CHANGELOG); WORKFLOW.md v2.1 (plan_draft removed from Standard default, Stage 11 high-risk only); docs/02_planning_v0.4/plan_final.md created |
| 2026-04-23 | Session 8: v0.4 Stage 1 complete (retrospective + simplification direction decided); settings.json schema v0.2; dev_history retirement decided |
| 2026-04-22 | Session 7: v0.3 released (tag v0.3, commit 62e32a1) |

## 최근 변경 이력

| 날짜 | 설명 |
|------|------|
| 2026-04-23 | 세션 9: CLAUDE.md 단순화 (Stage 11 fresh-session 폐지, git 3-경우 정책, dev_history→CHANGELOG); WORKFLOW.md v2.1 (plan_draft Standard 기본값 제거, Stage 11 고위험 한정); docs/02_planning_v0.4/plan_final.md 작성 |
| 2026-04-23 | 세션 8: v0.4 Stage 1 완료 (회고 + 단순화 방향 확정); settings.json schema v0.2; dev_history 폐기 결정 |
| 2026-04-22 | 세션 7: v0.3 릴리스 (tag v0.3, commit 62e32a1) |

---

## 다음 할 일

### 🔴 미완료 (세션 9 완료 후 운영자 실행 필요)

1. **dev_history 파일 git rm** — 운영자 로컬 쉘:
   ```bash
   cd ~/projects/Jonelab_Platform/jOneFlow
   git rm docs/notes/dev_history.md docs/notes/dev_history.ko.md
   ```
2. **세션 9 변경사항 일괄 커밋** — 운영자 로컬 쉘 (세션 종료 시 커밋 블록 제공)
3. **v0.3 push + GitHub release** — 운영자 로컬 쉘:
   ```bash
   git push origin main && git push origin v0.3
   gh release create v0.3 -F <(awk '/^## \[0.3.0\]/,/^## \[0\.2/' CHANGELOG.md | head -n -1)
   ```

### 🟡 세션 10 예정

- v0.4 Stage 12/13 — CHANGELOG `[Unreleased]` → `[0.4.0]` 완성 + v0.4 tag/release
- plan_final.md 운영자 승인 확인 (`docs/02_planning_v0.4/plan_final.md`)

### 🟡 보류 중

- Mac CI 페이스트 (release_checklist.md Sec. 1.1 행 1.g/1.h/1.i) — 비동기, 운영자 직접

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
세션 10 = v0.4 Stage 12/13 (CHANGELOG [0.4.0] 완성 + v0.4 tag/release).
전제: 운영자가 세션 9 커밋 블록 + dev_history git rm + v0.3 push 를 로컬에서 실행 완료.
plan_final.md 운영자 승인 여부 확인 후 진행.
```
