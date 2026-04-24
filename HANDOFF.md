# HANDOFF

> R2 읽기 순서 2번째. CLAUDE.md 다음에 읽기.
> 목적: 다음 에이전트가 해야 할 일 누락 방지.
> 구버전: `HANDOFF.archive.v0.3.md` 참조.

---

## Status

**Current version:** v0.6 진행 중 (시작 2026-04-24)
**Last updated:** 2026-04-25 (세션 16)
**Current stage:** v0.6 Stage 8 M1 완료 (세션 16, A/B 실험). Round 2(Claude 구현) 승자 채택, main FF 머지 (SHA 15b663a). D1 schema v0.4 + `scripts/lib/settings.sh` + `tests/v0.6/` 유닛 3종 + CLAUDE.md Sec.3 정책 개정(Claude 구현 금지 완화). M2 (D2 `init_project.sh`) 진입 대기.

## 현재 상태

**현재 버전:** v0.6 진행 중 (시작 2026-04-24)
**마지막 업데이트:** 2026-04-25 (세션 16)
**현재 단계:** v0.6 Stage 8 M1 완료 (세션 16, A/B 실험 → Round 2 승자). 다음 = M2 (`init_project.sh` 대화 + POSIX 쓰기) 구현 진입.

| 항목 | 내용 |
|------|------|
| 워크플로 모드 | 하이브리드 (Stage 1 = Cowork 1:1, Stage 2–13 = Claude Code 에이전트 팀) |
| v0.4 태그 | `v0.4` → 릴리스 예정 (아래 커밋 후 운영자 로컬 실행) |

---

## Recent Changes

| Date | Description |
|------|-------------|
| 2026-04-25 | Session 16: v0.6 Stage 8 M1 완료 — A/B 실험(Round 1 Codex / Round 2 Claude) 둘 다 AC 6/6. Round 2 승자(SHA 15b663a) main FF 머지. CLAUDE.md Sec.3 "Claude 구현 금지" 정책 완화 — stage_assignments 기반으로 통일. 조직도 + 승인 스킵 + 호출 방식 + tmux 레이아웃 + 자동 왓처 지침 확정 (메모리 5건). 다음 = M2 init_project.sh. |
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
| 2026-04-25 | 세션 16: v0.6 Stage 8 M1 완료 — A/B 실험(Round 1 Codex / Round 2 Claude) 둘 다 AC 6/6 만점. Round 2 승자(SHA 15b663a) main FF 머지. CLAUDE.md Sec.3 "Claude 구현 금지" 정책 완화 — stage_assignments 기반으로 통일. 조직도 + 승인 스킵 + 호출 방식 + tmux 레이아웃 + 자동 왓처 지침 확정 (메모리 5건). 다음 = M2 init_project.sh. |
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

## 📋 다음 세션 시작 프롬프트 (세션 17 — Stage 8 M2 `init_project.sh`)

```
v0.6 Stage 8 M2 구현 — D2 scripts/init_project.sh 대화 + POSIX 쓰기
읽기 순서:
  CLAUDE.md (Sec.2.5 조직도 + Sec.3 승인 스킵/호출 방식 정책 숙지)
  → HANDOFF.md (세션 16 Stage 8 M1 완료 + A/B 실험 결과)
  → docs/03_design/v0.6_cli_automation/technical_design.md Sec.3 (D2 설계)
  → docs/04_implementation_v0.6_stage8/ab_comparison.md (M1 실험 결과, team_mode 선택 참고)
  → scripts/lib/settings.sh (M1 산출물, D2 소비자)

세션 17 = M2 (D2 init_project.sh) 구현 + 검증.

전제 (세션 16 확정):
  - M1 완료: D1 schema v0.4 + scripts/lib/settings.sh + tests/v0.6/ (main SHA 15b663a).
  - CLAUDE.md Sec.3 "Claude 구현 금지" 정책 완화 — stage_assignments 기반으로 실행자 결정.
  - team_mode 기본값 = claude-only (운영자 선호에 따라 변경 가능).
  - 승인 스킵 정책 적용 (로컬+commit 자동, push/외부 API만 수동).
  - tmux 레이아웃 재생성은 scripts/setup_tmux_layout.sh 사용.
  - 자동 왓처 기본값 (장시간 작업). 운영자 먼저 완료 시그널 오면 왓처 kill.
  - ★한국어 응답 필수★

진행 순서:
  1. tmux 세션 기동 (필요 시): scripts/setup_tmux_layout.sh joneflow 2
  2. team_mode 선택 (기본 claude-only, 또는 A/B 결과 기반으로 운영자 선택).
  3. M2 Stage 8 구현 (executor = stage_assignments.stage8_impl):
     - scripts/init_project.sh — 기존 폴더 생성 로직 + 신규 대화 2블록
     - [1/2] workflow_mode 선택 (brainstorm Sec.4 verbatim, 3종)
     - [2/2] team_mode 선택 (brainstorm Sec.4 verbatim, ★추천★ 마커 보존 [F-n1])
     - 입력 결과를 tech_design Sec.2.5 매핑표로 stage_assignments 계산
     - scripts/lib/settings.sh의 settings_write_key / settings_write_stage_assign_block 사용
     - Case A (부재): heredoc 템플릿 전체 생성
     - Case B (v0.3 존재): awk로 신규 필드 삽입 + schema_version bump
     - Case C (v0.4 존재): --force-reinit 플래그 없으면 skip
  4. Golden file 테스트 (tech_design Sec.11.1 5행):
     - [1/2], [2/2] 블록이 brainstorm.md verbatim과 diff 0 bytes
  5. Stage 9 코드 리뷰 (집중 AC):
     - AC-5-4 verbatim 보존 [F-n1]
     - AC-5-11 전제: switching.md 시나리오는 M3에서 생성 예정
     - AC-5-5 team_mode 리터럴 실행 분기 금지 static gate [F-2-a]
  6. 완료 시 main에 FF 머지 + HANDOFF 갱신 + M3 (D3 switch_team.sh) 진입 대기.

Stage 8 구현 제약 (동일):
  - jq 금지 [F-D2], pending_team_mode 금지 [F-D3], team_mode 실행분기 금지 [F-2-a]
  - v0.3 필드 diff 0 bytes [F-5-a], codex CLI scripts 호출 금지 [F-n3]
  - brainstorm verbatim 수정 금지 [F-n1/n2]
```
