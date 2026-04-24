# HANDOFF

> R2 읽기 순서 2번째. CLAUDE.md 다음에 읽기.
> 목적: 다음 에이전트가 해야 할 일 누락 방지.
> 구버전: `HANDOFF.archive.v0.3.md` 참조.

---

## Status

**Current version:** v0.6 진행 중 (시작 2026-04-24)
**Last updated:** 2026-04-25 (세션 15)
**Current stage:** v0.6 Stage 5 Technical Design 완료 (세션 15, Opus) — technical_design.md 단일 trail D1→D5, AC 12건, Q1~Q3 답변, 설계 제약 8건(F-D1/D2/D3, F-n1/n2/n3, F-2-a, F-5-a) 흡수. Stage 8 구현 진입 대기 (tmux 팀모드 + codex 연계).

## 현재 상태

**현재 버전:** v0.6 진행 중 (시작 2026-04-24)
**마지막 업데이트:** 2026-04-25 (세션 15)
**현재 단계:** v0.6 Stage 5 Technical Design 완료 (세션 15, Opus) — technical_design.md 단일 trail D1→D5, AC 12건, Q1~Q3 답변, 설계 제약 8건 흡수. Stage 8 구현 진입 대기 (tmux 팀모드 + codex 연계).

| 항목 | 내용 |
|------|------|
| 워크플로 모드 | 하이브리드 (Stage 1 = Cowork 1:1, Stage 2–13 = Claude Code 에이전트 팀) |
| v0.4 태그 | `v0.4` → 릴리스 예정 (아래 커밋 후 운영자 로컬 실행) |

---

## Recent Changes

| Date | Description |
|------|-------------|
| 2026-04-25 | Session 15: v0.6 Stage 5 Technical Design 완료 (Opus). docs/03_design/v0.6_cli_automation/technical_design.md 단일 trail D1→D5. AC 12건 commit. Q1(fail-closed 복구) / Q2(pgrep -fl) / Q3(unknown executor exit 2) 답변. 설계 제약 8건 전량 흡수. |
| 2026-04-24 | Session 14: v0.6 Stage 2–4 기획 완료 (Opus + tmux 팀모드 3 서브에이전트 drafter/reviewer/finalizer). plan_draft/review/final 3종 작성 (docs/02_planning_v0.6/). 운영자 승인 완료. scope 축소(D6/D7 → v0.6.1), jq 비의존, pending_team_mode 제거, R2 설계 제약 commit. |
| 2026-04-24 | Session 13: v0.6 Stage 1 브레인스토밍 완료. CLI 자동화 레이어 + team_mode 3종 + init_project.sh / switch_team.sh 설계 확정. brainstorm.md 작성. |
| 2026-04-24 | Session 13: bundle1 check 10 수정 (KO only 전환 후 EN exact-match → substring). ALL PASS. CHANGELOG [0.5.0] 확정. |
| 2026-04-24 | Session 12: CLAUDE.md + WORKFLOW.md KO only 전환 (75%/65% 감소). Bundle 2/3 re-scope 완료. Hooks + gstack 검토 완료. |
| 2026-04-24 | Session 12: Model selection policy 확정 — Stage별 Sonnet/Opus 배정. CLAUDE.md Sec.3 + WORKFLOW.md Sec.9–10 + settings.json schema v0.3 반영. |
| 2026-04-23 | Session 11: v0.5 Stage 1 — debt items 5–7 done (update_handoff.sh KO verified, shellcheck CI + macOS CI, run_tests.sh, bundle1 test refresh) |
| 2026-04-23 | Session 10: v0.5 Stage 1 — debt items 1–4 done (§ removal, tool-picker Sec.6 refresh, D4.x2 dev_history note, UI sunset check) |
| 2026-04-23 | Session 9: v0.4 Stage 13 — CHANGELOG [0.4.0] finalized; v0.4 tag/release pending operator |
| 2026-04-23 | Session 9: CLAUDE.md simplified; WORKFLOW.md v2.1; plan_final.md created; dev_history retired |
| 2026-04-23 | Session 8: v0.4 Stage 1 complete; settings.json schema v0.2 |

## 최근 변경 이력

| 날짜 | 설명 |
|------|------|
| 2026-04-25 | 세션 15: v0.6 Stage 5 Technical Design 완료 (Opus). docs/03_design/v0.6_cli_automation/technical_design.md 단일 trail D1→D5. AC 12건 commit. Q1(fail-closed 복구) / Q2(pgrep -fl) / Q3(unknown executor exit 2) 답변. 설계 제약 8건 전량 흡수. |
| 2026-04-24 | 세션 14: v0.6 Stage 2–4 기획 완료 (Opus + tmux 팀모드 3 서브에이전트 drafter/reviewer/finalizer). plan_draft/review/final 3종 작성 (docs/02_planning_v0.6/). 운영자 승인 완료. scope 축소(D6/D7 → v0.6.1), jq 비의존, pending_team_mode 제거, R2 설계 제약 commit. |
| 2026-04-24 | 세션 13: v0.6 Stage 1 브레인스토밍 완료. CLI 자동화 레이어 + team_mode 3종 + init_project.sh / switch_team.sh 설계 확정. brainstorm.md 작성. |
| 2026-04-24 | 세션 13: bundle1 check 10 수정 (KO only 전환 후 EN exact-match → substring). ALL PASS. CHANGELOG [0.5.0] 확정. |
| 2026-04-24 | 세션 12: CLAUDE.md + WORKFLOW.md KO only 전환 (75%/65% 감소). Bundle 2/3 re-scope 완료. Hooks + gstack 검토 완료. |
| 2026-04-24 | 세션 12: 모델 선택 정책 확정 — Stage별 Sonnet/Opus 배정. CLAUDE.md Sec.3 + WORKFLOW.md Sec.9–10 + settings.json schema v0.3 반영. |
| 2026-04-23 | 세션 11: v0.5 Stage 1 — 빚 청산 항목 5–7 완료 (update_handoff.sh KO 확인, shellcheck CI + macOS CI, run_tests.sh, bundle1 테스트 갱신) |
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

### 🟢 v0.5 완료 항목 (세션 11)

5. ✅ `update_handoff.sh` KO 헤더 지원 — 이미 구현되어 있음 확인 (EN/KO 모두 정상 인식)
6. ✅ shellcheck CI (Linux) — `.github/workflows/ci.yml` 생성; bundle1 worked example 테스트도 v0.5 기준으로 갱신
7. ✅ Mac CI 자동화 — ci.yml에 `macos-latest` job 추가; `scripts/run_tests.sh` 로컬 one-command 실행 스크립트 추가

### 🟢 v0.5 완료 항목 (세션 12)

8. ✅ 모델 선택 정책 — Stage별 Sonnet/Opus 배정. CLAUDE.md + WORKFLOW.md + settings.json v0.3 반영
9. ✅ CLAUDE.md + WORKFLOW.md KO only 전환 — 75%/65% 감소, R2 비용 57% 절감
10. ✅ Bundle 2/3 re-scope 완료 — Goal별 처리 방향 확정 (아래 참조)
11. ✅ Claude Code Hooks 검토 — PostToolUse(py_compile/shellcheck 자동화) 유효, Stop 훅은 불필요
12. ✅ gstack 검토 — ETHOS(Boil the Lake 등) + autoplan 패턴 + /investigate 참조 대상 확정

### 🟢 v0.6 완료 항목 (세션 15)

13. ✅ Stage 5 Technical Design — `docs/03_design/v0.6_cli_automation/technical_design.md` 단일 trail D1→D5. AC 12건, Q1~Q3 답변, 설계 제약 8건(F-D1/D2/D3, F-n1/n2/n3, F-2-a, F-5-a) 전량 흡수.

### 🟡 v0.6 과업 (Stage 5 완료 — 세션 15)

**Stage 8 구현 (다음 세션 진입 대상) — M1 → M4 순차:**

| Milestone | 대상 | Stage 8 구현자 (team_mode별) |
|-----------|------|----------------------------|
| M1 | D1 schema v0.4 + `scripts/lib/settings.sh` + 유닛 테스트 | `stage_assignments.stage8_impl` 참조 |
| M2 | D2 `scripts/init_project.sh` (대화 + POSIX 쓰기 + golden file 테스트) | 동 |
| M3 | D3 `scripts/switch_team.sh` + D4 `docs/guides/switching.md` | 동 |
| M4 | D5 `scripts/ai_step.sh` 오케스트레이터 + static gate + integration 테스트 | 동 |

각 Milestone: **Stage 8 구현 → Stage 9 코드 리뷰 (AC-5-1~5-12 검증) → 필요 시 Stage 10 수정** 순환. Stage 11은 Strict 모드 고위험 작업 한정 (본 4개 Milestone은 Standard로 판정).

**v0.6 본 릴리스 — D1~D5 (설계 기준, Stage 8 구현 대상):**

| ID | 과업 | 요구사항 요점 (plan_final 반영) |
|----|------|-----------------------------|
| D1 | `settings.json` schema v0.4 | workflow_mode, team_mode, stage_assignments 필드. **`pending_team_mode` 필드 미포함** [F-D3]. 1줄 1키 POSIX 파싱 가능 구조. |
| D2 | `scripts/init_project.sh` | 운영방식(3종) + team_mode(3종) 대화. **★추천★ 마커 brainstorm verbatim** [F-n1]. `jq` 비의존 [F-D2]. |
| D3 | `scripts/switch_team.sh` | 백그라운드 프로세스 체크. **2분기만**(차단/즉시). 차단 메시지 **brainstorm Sec.5 한글 verbatim** [F-n2]. `jq` 비의존 [F-D2]. |
| D4 | `docs/guides/switching.md` | 패턴 전환 시나리오 가이드. |
| D5 | `ai_step.sh` 오케스트레이터 | Stage 2–13 자동화. **실행 결정 시 `team_mode` 리터럴 비참조, `stage_assignments`만 파싱** (표시 경로 예외) [F-2-a]. |

**v0.6.1 패치 이월 [F-D1]:** Hooks PostToolUse, gstack ETHOS → CLAUDE.md. v0.6 본 릴리스 관측(최소 1일) 후 kickoff.

**Non-goal (v0.6 본 릴리스):**
- `@openai/codex` CLI 오케스트레이터 자동화 호출 [F-n3] — 수동 보조 전용.
- settings.json 자동 마이그레이션 도구 / CI 인프라 변경 / v0.5 문서 재작업.

**우선순위 하 (글로벌 공개 버전 시):**

| 과업 | 조건 |
|------|------|
| Goal 1 언어 선택 마법사 | 글로벌 공개 버전 시 |
| Goal 4 `.skills/examples/` 확장 | 글로벌 공개 버전 시 |
| `/investigate` 스킬 참조 | 글로벌 공개 버전 시 |

| 드롭 항목 | 이유 |
|-----------|------|
| Goal 2 eval 러너 | 운영자가 필요성 인지 못함 — 드롭 |
| Goal 6 모드 선택 트리 스킬 | tool-picker로 커버됨 — 드롭 |
| `/canary` | 브라우저 데몬 의존 — 해당 없음 |

> 상세: `docs/02_planning_v0.6/plan_final.md` (상위 근거: `docs/01_brainstorm_v0.6/brainstorm.md`).
> 개정 발견 추적: `docs/02_planning_v0.6/plan_review.md` F-D1~F-D3, F-2-a, F-5-a, F-n1~F-n3.

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

## 📋 다음 세션 시작 프롬프트 (세션 16 — Stage 8 M1 구현)

```
v0.6 Stage 8 구현 시작 — M1 (D1 schema v0.4 + scripts/lib/settings.sh)
읽기 순서: CLAUDE.md → HANDOFF.md → docs/03_design/v0.6_cli_automation/technical_design.md
세션 16 = v0.6 Stage 8 M1 — tmux 팀모드로 Codex 연계 구현 + 검증.
⚠️ 모델: 오케스트레이터 Sonnet (구현 작업은 Opus 불필요, team_mode 분기로 실제 executor 결정).

전제:
  - 세션 15 technical_design.md 완성 (AC 12건, fail-closed, POSIX 파싱).
  - .claude/settings.json 현행 schema v0.3 → M1 완료 시 v0.4 업그레이드.
  - ★한국어 응답 필수★ (진행 메시지 + 최종 요약 전부 한국어. 코드/경로/커맨드만 원문).

진행 순서:
  1. tmux 세션 기동: claude --teammate-mode tmux (CLAUDE.md Sec.3 "수동 지시 영역" 규약 준수)
  2. team_mode 결정:
     - 추천: claude-impl-codex-review (brainstorm ★추천★, Codex 5.5 리뷰 품질 활용)
     - 대안: codex-impl-claude-review (Codex가 구현, Claude가 리뷰)
     - 운영자 선택 후 stage_assignments 테이블(tech_design Sec.2.5) 확정
  3. M1 Stage 8 구현 (executor = stage_assignments.stage8_impl 참조):
     - scripts/lib/settings.sh 신규 (tech_design Sec.8.1 공개 함수)
     - .claude/settings.json schema v0.3 → v0.4 (신규 필드 5종, Sec.2.2)
     - tests/v0.6/ 유닛 테스트 (Sec.11.1 첫 3행)
  4. Stage 9 코드 리뷰 (executor = stage_assignments.stage9_review):
     - codex-impl-claude-review인 경우: Claude Opus 서브에이전트
     - claude-impl-codex-review인 경우: /codex:review (plugin-cc)
     - AC-5-1(POSIX) / AC-5-2(pending 부재) / AC-5-3(jq 비의존) / AC-5-10(v0.3 호환) 집중 검증
  5. 검증 결과 운영자에게 복귀 보고. 실패 AC 있으면 Stage 10 (executor = stage10_fix) 순환.

Stage 8 구현 제약 (tech_design Sec.12.3):
  - jq 사용 금지 (F-D2). 테스트도 jq 비의존 증명 포함.
  - team_mode 리터럴 실행 분기 금지 (F-2-a). 표시 경로 예외만.
  - pending_team_mode 필드 추가 금지 (F-D3).
  - @openai/codex CLI 호출 경로 추가 금지 (F-n3). plugin-cc만 허용.
  - 기존 v0.3 agents.* / env / language / teammateMode 필드 diff 0 bytes (F-5-a).

AC 전량 통과 시 M1 커밋 → M2(D2) 진입. 부분 통과 시 현재 세션에서 Stage 10 순환.
```
