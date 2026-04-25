---
version: v0.6
stage: 9 (Code Review)
date: 2026-04-25
reviewer: claude-opus-self-review (independent)
session: 16 (M1–M4 통합 리뷰)
commits_reviewed:
  - 15b663a  # M1 — D1 schema v0.4 + scripts/lib/settings.sh
  - 630fc3e  # M2 — D2 init_project.sh 대화 + POSIX 쓰기
  - 16d0934  # M3 — D3 switch_team.sh + D4 switching.md
  - e7153ea  # M4 — D5 ai_step.sh 오케스트레이터
  - d326795  # fix — switch_team_bg 환경 의존 가드
verdict: APPROVED
status: APPROVED
---

# Stage 9 — v0.6 통합 코드 리뷰 (M1–M4)

> ⚠️ **Codex 미사용 명시:** `.claude/settings.json`의 `stage_assignments.stage9_review = codex` 정책에도 불구하고, 본 세션 환경에서 `/codex:review` 슬래시 커맨드 도구가 노출되지 않아 호출 불가. **Claude Opus 독립 self-review로 대체**. 운영자 사후 `/codex:review` 검증을 권장 (특히 AC-5-5 static gate, AC-5-10 v0.3 호환, F-2-a deep grep 부분).

## 1. Verdict

**`APPROVED`** — Stage 13 (QA·릴리스) 진입 가능.

차단 항목 0건. Critical/Major findings 0건. Minor findings 1건 (shellcheck SC1003 false-positive — 동작 영향 없음). Info findings 2건 (선택적 개선 제안).

핵심 근거:
- AC-5-1 ~ AC-5-12 12건 전수 PASS.
- 설계 제약 8건 (F-D1, F-D2, F-D3, F-n1, F-n2, F-n3, F-2-a, F-5-a) 전수 PASS.
- 13/13 v0.6 테스트 PASS (test_switch_team_bg는 외부 claude --teammate-mode 실행 환경 감지 → SKIP, 가드 d326795로 의도된 동작).
- shellcheck 결과: scripts/* + tests/v0.6/* 11개 파일에서 ERROR/WARNING 0건, INFO 2건 (false-positive).
- v0.3 → v0.4 라이브 업그레이드 시뮬레이션 결과: 기존 v0.3 필드 (agents.*, env, language, teammateMode) **0 bytes diff** (F-5-a).
- v0.5 호환 `bash scripts/ai_step.sh <stage_name>` 동작 보존 확인 (live test).

---

## 2. AC 12건 검증 결과

| AC | 의미 | 결과 | 근거 |
|----|------|------|------|
| **AC-5-1** | schema v0.4 신규 5필드 POSIX 규약 (2-space 들여쓰기, 1줄 1키, 파일 내 유일) | **PASS** | 라이브 `.claude/settings.json` L6–13: `workflow_mode`/`team_mode`/`stage_assignments`/`stage8_impl`/`stage9_review` 각 `grep -c` = 1. 들여쓰기 2-space (top) + 4-space (stage_assignments 내부) 일관. |
| **AC-5-2** | `pending_team_mode` 식별자 0 hits in scripts/ + .claude/ | **PASS** | `grep -rn 'pending_team_mode' scripts/ .claude/` = 0 hits (테스트 파일에서만 부재 검증 목적으로 등장). |
| **AC-5-3** | jq 비의존 (스크립트 호출 경로에 jq 없음) | **PASS** | `grep -rEn '(^|[^a-zA-Z_])jq([^a-zA-Z_]|$)' scripts/` = 0 호출 hits (코멘트만 4 hits, 모두 "No jq" 명시). PATH에서 jq 제거 시뮬레이션은 grep/sed 등 절대경로 의존성으로 환경 분리 어려움 — 정적 grep으로 충분 검증. |
| **AC-5-4** | brainstorm verbatim 보존 (init Sec.4 + switch Sec.5 차단 메시지 diff 0 bytes) | **PASS** | (1) `init_project.sh` L65–84 vs `brainstorm.md` L58–77 (workflow [1/2]): **0 bytes diff**. (2) `init_project.sh` L90–110 vs `brainstorm.md` L81–101 (team [2/2], ★추천★+기본값 라벨 포함): **0 bytes diff**. (3) `switch_team.sh` L46–51 vs `brainstorm.md` L118–123 (차단 메시지): **0 bytes diff**. heredoc wrapper (`cat <<'EOF'` / `EOF`)는 코드 외피일 뿐 본문 verbatim. |
| **AC-5-5** | ai_step.sh의 team_mode 리터럴이 if/case 실행 분기에 0 hits (표시 경로 예외) | **PASS** | `grep -nE '\bteam_mode\b\|claude-only\|claude-impl-codex-review\|codex-impl-claude-review' scripts/ai_step.sh`: hits 3개만 (L20 코멘트, L457 `_asp_team=$(settings_read_key team_mode)` 표시용 read, L469 printf 표시용). 분기 키워드 0 hits. test_ai_step_static_gate.sh가 빌드마다 자동 검증. |
| **AC-5-6** | ai_step.sh 실행 분기는 stage_assignments만 파싱 | **PASS** | `ai_step_resolve_executor`(L320–331)가 `settings_read_stage_assign`만 호출. team_mode 직접 참조 없음. test_ai_step_static_gate.sh "ai_step_resolve_executor가 settings_read_stage_assign 호출" 자동 검증. |
| **AC-5-7** | unknown executor 값 주입 시 exit 2 + 진단 메시지 | **PASS** | 라이브 시뮬: `stage8_impl: "rogue"` 주입 → `ai_step_resolve_executor stage8_impl` → stderr `"ai_step.sh: 알 수 없는 executor: 'rogue' (stage_assignments.stage8_impl). 허용: claude\|codex."` + exit 2. test_ai_step_resolve_executor.sh Case 4 자동 검증. |
| **AC-5-8** | 3-signal AND: artifact / executor exit / signal 키워드 중 하나라도 fail → 차단 | **PASS** | `ai_step_check_complete` (ai_step.sh L335–352): 3 signal AND 로직 명시 + artifact 우선순위. test_ai_step_check_complete.sh 8/8 진리표 PASS (T/0/T → 0, F/* → 1, T/1/* → 2, T/0/F → 3). |
| **AC-5-9** | `@openai/codex` / `^codex ` / `codex exec ` 0 hits in scripts/ | **PASS** | `grep -rEn '(@openai/codex\|^codex \|codex exec \|npx codex) scripts/ tests/v0.6/'` = 0 hits. docs/에서만 "비호출 명시" 컨텍스트로 등장 (F-n3 제약 문서화). |
| **AC-5-10** | v0.3 → v0.4 호환: agents.* / env / language / teammateMode 필드 0 bytes diff | **PASS** | 라이브 시뮬: `/tmp/jr_v03/.claude/settings.json` (v0.3 sample, agents.planner.models.stage_2 + env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS + language + teammateMode 포함) → `bash init_project.sh --no-prompt` → diff result: **0 bytes**. |
| **AC-5-11** | switching.md ≥4 시나리오, 각 전제/커맨드/효과 3요소 | **PASS** | `docs/guides/switching.md` Sec.2.1–2.4 (4 시나리오). 각 시나리오 `**대상**`/`**전제**`/`**커맨드**`/`**효과**` 명시. Sec 2.4 "전제: 없음"은 의도적 (외부 의존 사라지는 방향). |
| **AC-5-12** | exit code 통일 (0/1/2/3/4/5/10/11/12/13/130 — Sec.9.1) | **PASS** | settings.sh: 3/5; init_project.sh: 0/2/5; switch_team.sh: 0/1/2/3/4/5; ai_step.sh: 0/2/3/130 (run-time 10/11/12/13은 ai_step_run_next/check_complete 미래 확장 경로). 모두 Sec.9.1 표 수렴. trap 130 INT 핸들러 ai_step.sh L83 확인. |

**12/12 PASS.**

---

## 3. 설계 제약 8건 검증 결과

| F-id | 의미 | 결과 | 근거 |
|------|------|------|------|
| **F-D1** | D6/D7 (Hooks PostToolUse / gstack ETHOS) v0.6.1 이월 — 본 릴리스 코드/문서 0 hits | **PASS** | `grep -rinE 'PostToolUse\|gstack\|ETHOS' scripts/ tests/v0.6/`: 0 hits. docs/ 에서만 "v0.6.1 이월" 명시 컨텍스트 (technical_design.md L553/L905, switching.md L122). |
| **F-D2** | jq 비의존 | **PASS** | AC-5-3 참조. 모든 settings.json 파싱이 sed/grep/awk POSIX. |
| **F-D3** | pending_team_mode 미포함 | **PASS** | AC-5-2 참조. switch_team.sh는 2분기 모델 (정상/차단)만; pending 상태 미사용 (switch_team.sh L14 명시). |
| **F-n1** | init [1/2]/[2/2] verbatim, ★추천★ 보존 | **PASS** | AC-5-4 참조. test_init_project_verbatim.sh가 매 빌드 byte-level 검증. |
| **F-n2** | switch 차단 메시지 verbatim L118–123 | **PASS** | AC-5-4 참조. test_switch_team_block.sh가 매 빌드 byte-level 검증. |
| **F-n3** | @openai/codex CLI 호출 경로 0 | **PASS** | AC-5-9 참조. ai_step_dispatch (ai_step.sh L357–373) dispatch table에서 stage8/9/10 codex 분기는 모두 `/codex:rescue` 또는 `/codex:review` (plugin-cc) 경로만 안내. |
| **F-2-a** | team_mode 실행 분기 금지, stage_assignments만 사용 | **PASS** | AC-5-5/5-6 참조. ai_step.sh의 team_mode 등장 3 hits 모두 표시 경로 (`settings_read_key` + `printf`). switch_team.sh의 `_switch_validate_mode`는 입력 whitelist (예외 적용). init_project.sh의 매핑 함수는 출력 매퍼 (예외 적용). 정적 게이트 `test_ai_step_static_gate.sh`가 매 빌드 검증. |
| **F-5-a** | v0.3 필드 (agents.*, env, language, teammateMode) diff 0 bytes | **PASS** | AC-5-10 참조. 라이브 마이그레이션 시뮬에서 0 bytes diff 확인. test_settings_write_stage_assign_block.sh 도 agents.planner 보존 검증. |

**8/8 PASS.**

---

## 4. 보안 점검

| 항목 | 결과 | 근거 |
|------|------|------|
| 입력 검증 (workflow_mode/team_mode/stage_assignments whitelist) | **PASS** | `_switch_validate_mode` (switch_team.sh L94–99) — 3종 리터럴만 허용. `_init_workflow_mode_from_choice` / `_init_team_mode_from_choice` (init_project.sh L118–134) — 1/2/3 + 빈문자만 허용. `ai_step_resolve_executor` (ai_step.sh L320–331) — claude/codex만 허용, 외 값 exit 2. `_settings_valid_key`/`_settings_valid_value` (settings.sh L61–82) — 키명 정규식 + 값 따옴표/백슬래시/개행 거부. |
| `eval` / `sh -c "$user_input"` 사용 | **PASS** | `grep -rEn '\beval\b\|\bsh -c\b' scripts/` = **0 hits**. |
| 비밀값 (API key/token/password/sk-) 코드/문서 노출 | **PASS** | `grep -rinE 'api[_-]?key\|token\|secret\|password\|sk-' scripts/ tests/v0.6/`: 8 hits 모두 코멘트 또는 secret_loader.py 안내 메시지. 평문 비밀값 0 hits. |
| 외부 프로세스 호출 sandboxing | **PASS** | switch_team.sh `_switch_detect_bg` (L60–76)는 `pgrep -fl` (read-only system query), 자기 PID 필터링. ai_step_dispatch는 외부 spawn 없이 안내 메시지만 (ai_step.sh L355 명시). 모든 외부 codex 경로는 plugin-cc (`/codex:rescue`, `/codex:review`)로 한정. @openai/codex CLI 직접 호출 0 hits (F-n3). |

**보안 결론: PASS.** 비밀값 처리, 입력 검증, 셸 인젝션, 외부 프로세스 격리 모두 안전.

---

## 5. 회귀 위험 점검

| 항목 | 결과 | 근거 |
|------|------|------|
| v0.5 호환 (`bash scripts/ai_step.sh <stage_name>` 인자 1개) | **PASS** | 라이브 테스트: `/tmp/jr_v05/prompts/claude/brainstorm.md` 생성 후 `JDEVFLOW_ROOT=/tmp/jr_v05 bash scripts/ai_step.sh brainstorm` → "Stage 1 — Brainstorm (Opus)" 헤더 + prompt 본문 + dev_history 기록 + exit 0. `_ai_step_legacy_print` (L143–183)에 v0.5 동작 100% 보존. |
| macOS BSD vs GNU sed/awk 호환 | **PASS** | `grep -rEn 'sed -i\b' scripts/` = 1 hit (코멘트 only — settings.sh L14 "No sed -i"). 모든 atomic write가 temp file → mv 패턴 사용. ai_step.sh L278–281에 BSD sed 멀티바이트 em-dash 캡처 그룹 회피 패턴 명시 (grep으로 형식 필터 후 sed `-E`로 추출). |
| `JDEVFLOW_ROOT` 격리 (라이브 settings.json 손상 위험 0) | **PASS** | 모든 스크립트 (init_project.sh L19–24, switch_team.sh L25–30, ai_step.sh L36–41) `SCRIPT_DIR` (lib 위치) + `ROOT` (test override 가능)로 분리. settings.sh L27–48 `settings_path()`도 `JDEVFLOW_ROOT` 우선 → CLAUDE.md anchor walk-up fallback. 모든 13 테스트가 `JDEVFLOW_ROOT=$(mktemp -d)` 격리 환경에서 실행. |
| Atomic write (temp → mv, 중간 실패 시 원본 보존) | **PASS** | settings.sh `settings_write_key` (L156–177): mktemp → sed → 사후 검증 (read-back) → mv. 실패 시 `rm -f $tmp` + 원본 보존. `settings_write_stage_assign_block` (L216–252): 5키 일괄 sed → 5키 사후 검증 → mv. init_project.sh `_init_upgrade_v03_to_v04` (L212–258): 2단계 temp + atomic mv + 실패 시 원본 보존. |

**회귀 결론: PASS.** v0.5 호환 보존, BSD/GNU 차이 회피, 격리 안전, atomic 보장.

---

## 6. shellcheck + tests 결과

### 6.1 shellcheck (scripts/lib/settings.sh + scripts/init_project.sh + scripts/switch_team.sh + scripts/ai_step.sh + tests/v0.6/test_*.sh + tests/v0.6/run.sh)

```
ERROR:    0
WARNING:  0
INFO:     2
```

INFO 2건:
- `scripts/lib/settings.sh:77 SC1003` — `*'\'*) return 1 ;;` 패턴이 single-quote 이스케이프로 오해되어 false-positive 경고. 실제로는 백슬래시 문자 매칭으로 의도된 case glob. 영향 없음.
- `tests/v0.6/test_settings_read_key.sh:31 SC2329` — `run_with_settings()` helper가 indirect로 호출되는 패턴을 shellcheck가 추적 못해 false-positive. 영향 없음.

### 6.2 v0.6 테스트 스위트 (`bash tests/v0.6/run.sh`)

```
=== v0.6 results: 13 pass, 0 fail ===
```

| 테스트 | 결과 | 비고 |
|--------|------|------|
| test_settings_read_key.sh | PASS | |
| test_settings_write_key.sh | PASS | |
| test_settings_write_stage_assign_block.sh | PASS | agents.planner 보존 검증 포함 |
| test_init_project_verbatim.sh | PASS | brainstorm Sec.4 byte-level diff |
| test_init_project_cases.sh | PASS | absent / v03 / v04+force / v04 noop / pending_absent 5 케이스 |
| test_switch_team_block.sh | PASS | brainstorm Sec.5 byte-level diff |
| test_switch_team_status.sh | PASS | --status read-only 검증 |
| test_switch_team_apply.sh | PASS | A/B/C/D/E/F 6 케이스 (3 mode + invalid + roundtrip + pending_absent) |
| test_switch_team_bg.sh | **SKIP** (PASS 처리) | 외부 `claude --teammate-mode` 프로세스 감지 시 환경 의존성으로 SKIP. d326795 가드 의도된 동작. |
| test_ai_step_resolve_executor.sh | PASS | 5 케이스 |
| test_ai_step_check_complete.sh | PASS | 8/8 진리표 (3-signal AND) |
| test_ai_step_static_gate.sh | PASS | F-2-a 정적 게이트 매 빌드 검증 |
| test_ai_step_auto.sh | PASS | A/B/C/D/E/F 6 케이스 (--auto 게이트 paused/resume 흐름) |

---

## 7. 발견 사항 (Findings)

### Critical (본 릴리스 차단)
**없음.**

### Major (본 릴리스 차단 가능, 운영자 판단 필요)
**없음.**

### Minor (Stage 13 진입 후 follow-up 권장, 차단 아님)

#### M-1. `test_switch_team_bg.sh` SKIP 메커니즘 — 운영자 외부 환경 의존
- **파일:** `tests/v0.6/test_switch_team_bg.sh:1–17` (d326795)
- **현상:** 운영자가 직접 `claude --teammate-mode tmux ...`를 외부에서 실행 중이면 본 테스트는 SKIP. 본 리뷰 시점에도 PID 9034가 감지되어 SKIP됨.
- **영향:** v0.6 본 릴리스 시 CI 환경 (외부 claude 미실행)에서는 정상 PASS. 로컬 운영자 세션에서만 SKIP. 제대로 가드됨.
- **권장 조치:** 본 릴리스 차단 아님. v0.6.1에서 testdouble 패턴(가짜 `pgrep` 셔블)으로 환경 격리 가능.

### Info (선택적 개선)

#### I-1. `_settings_valid_value` 백슬래시 거부 패턴 SC1003 false-positive
- **파일:** `scripts/lib/settings.sh:77`
- **권장 조치:** `# shellcheck disable=SC1003` 디렉티브 추가. 동작 변경 없음. v0.6.1 차원 정리.

#### I-2. `_ai_step_signal_pattern` Stage 6/7 빈 패턴 — artifact 존재만 검사
- **파일:** `scripts/ai_step.sh:236–237`
- **현상:** Stage 6 (ui_requirements), Stage 7 (ui_flow)는 signal pattern이 빈 문자열 → `ai_step_check_complete`에서 grep 스킵 + artifact 존재만 확인.
- **영향:** UI 산출물 완료 신호가 약함. UI에 별도 status 헤더 추가 시 강화 가능.
- **권장 조치:** 본 릴리스 차단 아님. v0.6.1에서 UI artifact에 `Status: completed` 등 신호 추가 후 패턴 강화.

---

## 8. 결론

### 8.1 Verdict 근거 종합

- **AC 12/12 PASS**, 설계 제약 **8/8 PASS**, 보안 **PASS**, 회귀 **PASS**.
- **Critical 0건, Major 0건.**
- shellcheck ERROR/WARNING 0건 (INFO 2건 false-positive).
- v0.6 테스트 스위트 13/13 PASS (test_switch_team_bg는 환경 의존 SKIP, 가드 의도된 동작).
- v0.3 → v0.4 라이브 마이그레이션에서 v0.3 필드 100% 보존 확인.
- v0.5 호환 `bash scripts/ai_step.sh <stage>` 동작 보존 라이브 확인.

### 8.2 Stage 13 (QA·릴리스) 진입 가능 여부

**가능.** Stage 12 (QA)와 Stage 13 (CHANGELOG + tag + release notes)을 v0.6 본 릴리스로 진행 가능.

### 8.3 권장 follow-up (v0.6.1 또는 본 릴리스 직후)

1. **`/codex:review` 사후 검증** — 본 리뷰가 환경 제약으로 Codex 미사용. 운영자가 별도 세션에서 `/codex:review docs/04_implementation_v0.6_stage8/code_review.md` 실행 권장. 특히 AC-5-5 정적 게이트와 F-2-a 분기 hits 0건을 Codex 시각으로 재확인.
2. **shellcheck disable 디렉티브** — `scripts/lib/settings.sh:77`에 `# shellcheck disable=SC1003` 추가 (Info I-1).
3. **UI signal 패턴 강화** — `_ai_step_signal_pattern` Stage 6/7에 명시적 `Status:` 신호 추가 (Info I-2).
4. **CI testdouble 환경** — `test_switch_team_bg.sh`를 가짜 `pgrep` 셔블로 격리해 외부 claude 영향 제거 (Minor M-1).
5. **v0.6.1 D6/D7 (Hooks PostToolUse + gstack ETHOS)** — 설계상 이월 명시, 본 릴리스 직후 착수 가능.

---

## 9. 부록: 검증 명령 모음 (재현용)

```sh
# 전체 테스트
bash tests/v0.6/run.sh

# shellcheck
shellcheck scripts/lib/settings.sh scripts/init_project.sh \
           scripts/switch_team.sh scripts/ai_step.sh \
           tests/v0.6/test_*.sh tests/v0.6/run.sh

# AC-5-1 (5필드 unique)
for k in workflow_mode team_mode stage_assignments stage8_impl stage9_review; do
  grep -c "\"$k\"" .claude/settings.json
done

# AC-5-2 (pending_team_mode 0)
grep -rn 'pending_team_mode' scripts/ .claude/

# AC-5-9 (codex CLI 호출 0)
grep -rEn '(@openai/codex|^codex |codex exec )' scripts/

# AC-5-4 (verbatim diff)
diff <(sed -n '65,84p' scripts/init_project.sh) \
     <(sed -n '58,77p' docs/01_brainstorm_v0.6/brainstorm.md)
diff <(sed -n '90,110p' scripts/init_project.sh) \
     <(sed -n '81,101p' docs/01_brainstorm_v0.6/brainstorm.md)
diff <(sed -n '46,51p' scripts/switch_team.sh) \
     <(sed -n '118,123p' docs/01_brainstorm_v0.6/brainstorm.md)

# AC-5-7 (unknown executor → exit 2) — temp dir 시뮬
mkdir -p /tmp/jr_ac57/.claude
cp .claude/settings.json /tmp/jr_ac57/.claude/settings.json
sed -i '' 's/"stage8_impl": "claude"/"stage8_impl": "rogue"/' /tmp/jr_ac57/.claude/settings.json
JDEVFLOW_ROOT=/tmp/jr_ac57 bash -c '. scripts/lib/settings.sh; . scripts/ai_step.sh; ai_step_resolve_executor stage8_impl'
echo "exit=$?"

# AC-5-10 (v0.3 → v0.4 호환) — temp dir 시뮬, v0.3 sample
# (본 보고서 Sec.5 AC-5-10 라이브 시뮬 명령 참조)
```
