# HANDOFF

> R2 읽기 순서 2번째. CLAUDE.md 다음에 읽기.
> 목적: 다음 에이전트가 해야 할 일 누락 방지.
> 구버전: `HANDOFF.archive.v0.3.md` 참조.

---

## Status

**Current version:** v0.6 진행 중 (시작 2026-04-24)
**Last updated:** 2026-04-25 (세션 18)
**Current stage:** v0.6 Stage 8 M3 완료 (세션 18). D3 `scripts/switch_team.sh` (대화/직접/--force/--status 4분기) + D4 `docs/guides/switching.md` (시나리오 4종) + 테스트 4건 (block verbatim, apply 매핑, status 출력, bg 게이트). v0.6 테스트 9/9 PASS, shellcheck CLEAN, AC-5-2/-4/-9/-12 게이트 통과. 부수: `scripts/init_project.sh`의 module-level arg 파서를 `_init_main` 안으로 이동 (switch_team.sh가 source 시 args 충돌 회피, verbatim/cases 테스트 그대로 PASS). M4 (D5 `ai_step.sh` 오케스트레이터) 진입 대기.

## 현재 상태

**현재 버전:** v0.6 진행 중 (시작 2026-04-24)
**마지막 업데이트:** 2026-04-25 (세션 18)
**현재 단계:** v0.6 Stage 8 M3 완료 (세션 18). 다음 = M4 (D5 `scripts/ai_step.sh` 오케스트레이터 — `stage_assignments` 기반 디스패치 + 3-signal stage completion + fail-closed + AC-5-5 static gate + integration 테스트) 구현 진입.

| 항목 | 내용 |
|------|------|
| 워크플로 모드 | 하이브리드 (Stage 1 = Cowork 1:1, Stage 2–13 = Claude Code 에이전트 팀) |
| v0.4 태그 | `v0.4` → 릴리스 예정 (아래 커밋 후 운영자 로컬 실행) |

---

## Recent Changes

| Date | Description |
|------|-------------|
| 2026-04-25 | Session 18: v0.6 Stage 8 M3 완료 — D3 `scripts/switch_team.sh` (대화/직접/--force/--status 4분기, brainstorm Sec.5 L118-123 verbatim 차단 메시지, pgrep -fl 백그라운드 감지) + D4 `docs/guides/switching.md` (시나리오 4종, 각 전제/커맨드/효과 3요소). 신규 테스트 4건: block verbatim(diff 0 bytes vs brainstorm L118-123), apply 매핑(3 team_mode + invalid + 라운드트립), status 필드 전체 출력, bg 통합(exec -a로 더미 spawn → 차단 + --force 우회 + 더미 종료 후 정상). v0.6 테스트 9/9 PASS, shellcheck CLEAN. AC-5-2(-4/-9/-12 게이트 통과. 부수: init_project.sh module-level arg 파서를 _init_main 안으로 이동(source 충돌 회피). 다음 = M4 D5 ai_step.sh. |
| 2026-04-25 | Session 17: v0.6 Stage 8 M2 완료 — D2 `scripts/init_project.sh` 작성. brainstorm Sec.4 verbatim 2블록(★추천★ 보존), Case A(부재→heredoc skeleton) / B(v0.3→awk 신규 필드 삽입+schema bump, v0.3 필드 100% 보존) / C(v0.4 skip) / --force-reinit(in-place lib API 갱신, agents.* 보존). 신규 테스트 2건: golden file(diff 0 bytes vs brainstorm.md L58–77/L81–101) + 통합(4 케이스 + AC-5-1/2/9). v0.6 테스트 5/5 PASS, shellcheck CLEAN. 다음 = M3 D3 switch_team.sh + D4 switching.md. |
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
| 2026-04-25 | 세션 18: v0.6 Stage 8 M3 완료 — D3 `scripts/switch_team.sh` 신규 (대화 모드는 init_project.sh의 [2/2] verbatim/매퍼/3회 재시도 루프 재사용, 직접 지정/--force/--status 4분기) + brainstorm Sec.5 L118-123 차단 메시지 verbatim + pgrep -fl 'claude.*--teammate-mode' / '(codex-plugin-cc\|/codex:(rescue\|review\|status))' 패턴 매칭 (자기자신 필터). D4 `docs/guides/switching.md` 시나리오 4종 (workflow_mode 1→2 / 2→3 / team_mode 1→2 / 2/3→1). 테스트 4건: block(byte-cmp + cmp -s), apply(3 team_mode + invalid mode + 라운드트립 유일성), status(필드 9개 + read-only + 부재 시 exit 4 + 인자 충돌 exit 2), bg(exec -a로 argv[0] 위장 더미 → 차단 verbatim + --force 우회 + 더미 종료 후 정상). 부수: init_project.sh의 `for _arg in "$@"` module-level 파서를 `_init_parse_args` 함수로 캡슐화 후 `_init_main`에서 호출 (switch_team.sh가 source 시 부모 args를 init이 소비하던 문제 해결, 기존 verbatim/cases 테스트 영향 없음). v0.6 테스트 9/9 PASS, shellcheck CLEAN, AC-5-2/-4/-9/-12 통과. 다음 = M4 D5 ai_step.sh 오케스트레이터. |
| 2026-04-25 | 세션 17: v0.6 Stage 8 M2 완료 — D2 `scripts/init_project.sh` 작성. brainstorm Sec.4 verbatim 2블록(★추천★ 보존), Case A(부재→heredoc skeleton) / B(v0.3→awk 신규 필드 삽입+schema bump, v0.3 필드 100% 보존) / C(v0.4 skip) / --force-reinit(in-place lib API 갱신, agents.* 보존). 신규 테스트 2건: golden file(diff 0 bytes vs brainstorm.md L58–77/L81–101) + 통합(4 케이스 + AC-5-1/2/9). v0.6 테스트 5/5 PASS, shellcheck CLEAN. 다음 = M3 D3 switch_team.sh + D4 switching.md. |
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

**⚠️ 세션 16 확인 사항 — tmux 없이 진행됨 (M2까지 그대로 허용, M3부터 정상화 필수)**
- M2까지: tmux 없이 Claude Code 에이전트 내부 직접 실행 (예외 허용)
- **M3부터**: 반드시 tmux joneflow 세션 띄우고 오케스트레이터 구조 복원
  - `bash scripts/setup_tmux_layout.sh joneflow` 실행 후 진입
  - 구현(Stage 8) → Codex 또는 서브에이전트 위임 (Cowork 세션 직접 구현 금지)
  - CLAUDE.md Sec. 2.5 조직도 준수

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

**v0.6.1 패치 이월 [F-D1]:** Hooks PostToolUse, gstack ETHOS → CLAUDE.md. **세션 17 결정 변경: "1일 관측" buffer 폐기 → v0.6 완료 후 즉시 v0.6.1 진입.** 첫 실전 테스트 프로젝트(brainstorm Sec.9 "Jonelab AI팀 운영자 대시보드 ANSI CLI")는 **v0.6.1 완료 후** 진입.

**v0.6.1 추가 과업 (세션 16 결정):**
- **조직도 확정** — Cowork(CTO 회의실) → Code(브릿지) → CLI tmux(오케스트레이터) 3계층 구조 러프 확정 후 CLAUDE.md Sec. 2.5 정식 반영.
- **오케스트레이터 스킬 2.0** — 브릿지 역할 체크 자동화. Code 세션이 직접 구현 감지 시 경고. (`prompts/claude/bridge_dispatch.md` 템플릿 기반)
- 참고: 1+2번 단기 조치는 세션 16에서 완료 (CLAUDE.md R2 역할 확인 추가 + `prompts/claude/bridge_dispatch.md` 표준 템플릿 생성).

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

## 📋 다음 세션 시작 프롬프트 (세션 19 — Stage 8 M4 `ai_step.sh` 오케스트레이터)

```
v0.6 Stage 8 M4 구현 — D5 scripts/ai_step.sh 오케스트레이터 + static gate + integration 테스트
읽기 순서:
  CLAUDE.md (Sec.2.5 조직도 + Sec.3 승인 스킵/호출 방식 정책 숙지)
  → HANDOFF.md (세션 18 Stage 8 M3 완료 결과)
  → docs/03_design/v0.6_cli_automation/technical_design.md Sec.6 (D5 설계) + Sec.0 F-2-a + Sec.14 AC
  → scripts/lib/settings.sh (M1 산출물 — settings_read_stage_assign 사용)
  → scripts/switch_team.sh (M3 산출물 — bg 감지/표시 경로 패턴 참고)
  → scripts/ai_step.sh (v0.5 단일 stage 모드 — 하위 호환 유지)

세션 19 = M4 (D5 ai_step.sh) 구현 + 검증. v0.6 본 릴리스 마지막 마일스톤.

전제 (세션 18 확정):
  - M3 완료: scripts/switch_team.sh + docs/guides/switching.md + 테스트 4건.
  - v0.6 테스트 9/9 PASS, shellcheck CLEAN, AC-5-2/-4/-9/-12 통과.
  - settings.sh API: settings_path / settings_require_v04 / settings_read_key / settings_read_stage_assign / settings_write_key / settings_write_stage_assign_block.
  - JONEFLOW_ROOT env로 테스트 격리 가능 (M2/M3 패턴 그대로 재사용).
  - init_project.sh의 arg 파서는 _init_main 내부 호출 (source 안전).
  - ★한국어 응답 필수★

진행 순서:
  1. tmux 세션 기동 (필요 시): scripts/setup_tmux_layout.sh joneflow 2
  2. team_mode 확인 (현재 settings.json: claude-impl-codex-review → stage8_impl=claude).
  3. M4 Stage 8 구현 (executor = stage_assignments.stage8_impl):
     - scripts/ai_step.sh — 전면 재작성 (v0.5 인자 1개 호출은 --stage <name> 호환 경로로 유지).
       · 인터페이스 (Sec 6.2): <stage> | --auto | --next | --status | --resume
       · resolve_executor (Sec 6.4): stage_assignments.* sed 추출 → claude/codex/빈값(exit 3)/오타(exit 2)
       · check_stage_complete (Sec 6.5): 3-signal AND (artifact 존재 + executor exit 0 + grep 키워드)
       · 승인 게이트 (Sec 6.6): Stage 4.5 무조건 일시정지, Stage 11 Strict/risk_level=high만
       · 실패 복구 (Sec 6.7): fail-closed. 자동 재시도/롤백 없음. dev_history에 failed/interrupted 기록.
       · 디스패치 테이블 (Sec 6.9): claude → `claude --teammate-mode tmux <prompt>`, codex → `/codex:rescue` 또는 `/codex:review` (plugin-cc 경로만)
       · 표시 경로 team_mode 리터럴은 로그 헤더/--status에서만 (Sec 6.8 예외) — 실행 분기 금지 [F-2-a]
       · 로깅 (Sec 6.10): dev_history.md `### TIMESTAMP — STAGE_NAME (executor=X) started/completed/failed`
  4. 신규 테스트 추가 (tests/v0.6/):
     - test_ai_step_resolve_executor.sh: claude/codex/빈값(exit 3)/오타(exit 2) 4 케이스
     - test_ai_step_check_complete.sh: 3 signal AND truth table (8조합)
     - test_ai_step_static_gate.sh [AC-5-5]: ai_step.sh + switch_team.sh + init_project.sh에서 team_mode 리터럴 if/case 실행 분기 0 hit. 표시 경로(echo/printf 내부) 예외 whitelist
     - test_ai_step_auto.sh: Stage 2→3→4→(4.5 pause) 시퀀스 + paused 상태 검증
     - tests/v0.6/run.sh에 등록.
  5. shellcheck + AC 게이트 전량 (AC-5-1~5-12):
     - AC-5-3 (jq 비의존 PATH 차단 테스트)
     - AC-5-5 (static gate)
     - AC-5-6 (stage_assignments만 파싱)
     - AC-5-7 (fail-closed exit 2)
     - AC-5-8 (3-signal AND)
     - AC-5-10 (v0.3 → v0.4 호환 regression)
     - AC-5-11 (switching.md 시나리오 ≥4종 — M3에서 이미 통과)
     - AC-5-12 (exit code 0/1/2/3/4/5/10/11/12/13/130)
  6. 완료 시 main에 FF 커밋 + HANDOFF 갱신 + Stage 9 코드 리뷰 진입.
  7. v0.6 본 릴리스 후 최소 1일 관측 → v0.6.1 D6/D7 (Hooks/ETHOS) kickoff.

Stage 8 구현 제약 (동일):
  - jq 금지 [F-D2], pending_team_mode 금지 [F-D3], team_mode 실행분기 금지 [F-2-a]
  - v0.3 필드 diff 0 bytes [F-5-a], codex CLI scripts 호출 금지 [F-n3]
  - brainstorm verbatim 수정 금지 [F-n1/n2]
```
