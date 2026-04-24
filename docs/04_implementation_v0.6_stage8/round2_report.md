# v0.6 Stage 8 M1 Round 2 — 완료 보고서 (Claude-impl × A/B 비교)

- **브랜치:** `v0.6-stage8-m1-round2-claude` (main `9e08f3b`에서 분기, Round 1 커밋 미참조)
- **일시:** 2026-04-25
- **team_mode (이번 Round 기록값):** `claude-impl-codex-review`
- **Round verdict:** APPROVED (Stage 9 리뷰 완료)
- **점수:** **6 / 6** (자가 채점)
- **A/B 비교 상대:** `v0.6-stage8-m1-round1-codex` 커밋 `c11272e`

---

## 1. 산출물

| 경로 | 상태 | 비고 |
|------|------|------|
| `scripts/lib/settings.sh` | 신규 | tech_design Sec 8.1 공개 함수 6종 |
| `.claude/settings.json` | v0.3 → v0.4 | `team_mode=claude-impl-codex-review`, `stage_assignments.stage9_review=codex` |
| `tests/v0.6/run.sh` | 신규 (harness) | 3 test dispatcher |
| `tests/v0.6/test_settings_read_key.sh` | 신규 | 12 assertion |
| `tests/v0.6/test_settings_write_key.sh` | 신규 | 12 assertion |
| `tests/v0.6/test_settings_write_stage_assign_block.sh` | 신규 | 30 assertion |
| `scripts/run_tests.sh` | 수정 | v0.6 호출 블록 추가 |
| `docs/04_implementation_v0.6_stage8/round2_brief.md` | 이미 존재 | 본 Round 지시서 |
| `docs/04_implementation_v0.6_stage8/round2_code_review.md` | 신규 | Stage 9 리뷰 보고서 |
| `docs/04_implementation_v0.6_stage8/round2_report.md` | 본 파일 | 점수 + A/B 비교 |

---

## 2. AC 자가진단 (브리프 §4 점수 메트릭)

| 항목 | 만점 | 자가 채점 | 근거 |
|------|------|----------|------|
| AC-5-1 POSIX 스키마 준수 | 1 | **1** | `grep -c '"workflow_mode"'`=1, `'"team_mode"'`=1, `'"stage_assignments"'`=1, JSON 유효, 2-space/4-space 들여쓰기 |
| AC-5-2 `pending_team_mode` 부재 | 1 | **1** | `grep -r 'pending_team_mode' scripts/ .claude/` 0 hit |
| AC-5-3 jq 비의존 | 1 | **1** | fake jq(exit 127) PATH 선두 차단 상태에서 `bash tests/v0.6/run.sh` rc=0, "BLOCKED" 0 hit |
| AC-5-10 v0.3 하위 호환 | 1 | **1** | `git show HEAD:.claude/settings.json`(main v0.3) 대비 language/teammateMode/env/agents 블록 diff 0 bytes |
| shellcheck clean | 1 | **1** | `shellcheck --severity=warning scripts/lib/settings.sh tests/v0.6/run.sh tests/v0.6/test_*.sh scripts/run_tests.sh` rc=0 |
| 유닛 테스트 통과율 | 1 | **1** | 3/3 test PASS, 총 54 assertion PASS (bash + sh POSIX 양쪽) |
| **합계** | **6** | **6** | |

추가 설계 제약:

| 제약 | 결과 | 근거 |
|------|------|------|
| F-D2 (jq 비의존) | 준수 | 실제 jq 호출 0건, 차단 환경 증명 |
| F-D3 (`pending_team_mode` 부재) | 준수 | AC-5-2와 동일 |
| F-2-a (team_mode 리터럴 실행 분기 금지) | 준수 | `settings_write_stage_assign_block` 내부 `case`는 Sec 2.5 매핑표 쓰기 경로 |
| F-5-a (v0.3 필드 diff 0 bytes) | 준수 | AC-5-10과 동일 |
| F-n3 (@openai/codex CLI 호출 경로 추가 금지) | 준수 | 산출물 3종 모두 codex CLI 호출 없음 |
| POSIX sh 준수 | 준수 | `local`/`[[ ]]`/process substitution 0건. `sh tests/v0.6/run.sh` rc=0 |
| sed -i 부재 | 준수 | 소스 전반 0 hit (주석 언급 제외) |

---

## 3. 구현 이탈 기록

### 3.1 Codex 리뷰 경로 (Round 1과 동일 이탈)

브리프 §2는 Round 2 리뷰자를 **`/codex:review`** (Codex plugin-cc slash command)로 명시했으나 이 에이전트 세션에서 다음 제약으로 명시 경로 실행 불가:

- 오케스트레이터 세션에서 `/codex:review` slash command를 프로그램적으로 invoke할 수단 없음.
- `codex exec review` CLI 직접 호출은 F-n3(`@openai/codex CLI 호출 경로 추가 금지`) 해석 상 회피 대상.

**대응:** Round 1과 동일하게 독립 Opus 서브에이전트(`Agent` 툴 `general-purpose`)가 리뷰. 이로써 Round 1과 Round 2의 리뷰자 변수가 통제되어, A/B 비교의 유일한 변수가 **구현자**로 한정됨(비교 공정성 확보 부수 효과).

### 3.2 구현자 경로 (Round 1과 반대)

이번 Round 2는 브리프 §2 "실행자: Claude (오케스트레이터 직접 또는 Agent 툴 서브에이전트)"에 따라 **독립 Opus general-purpose 서브에이전트**에게 구현 위임. Round 1 컨텍스트 없이 tech_design 원문만 읽고 처음부터 설계. 이를 통해 A/B 비교의 독립성 확보.

### 3.3 향후 과제

M2 이후 실제 `stage_assignments.stage9_review: codex` 값이 runtime에서 작동하려면 plugin-cc `/codex:review` 호출 브릿지가 필요. 현재 아키텍처로는 운영자 수동 trigger밖에 없음. 이번 Round 2에서 실제 Codex 리뷰 경로를 뚫지 못한 것은 기술적 한계이며, Stage 1 브레인스토밍 아젠다 후보(Round 1 보고서 §3.3와 동일).

---

## 4. Round 1 대비 A/B 비교

> 이 섹션은 오케스트레이터 관찰. Round 2 리뷰자는 Round 1 브랜치를 참조하지 않았음. 비교 데이터는 오케스트레이터가 양쪽 브랜치 산출물을 비교해 작성.

### 4.1 점수·verdict 동등

| 지표 | Round 1 | Round 2 |
|------|---------|---------|
| AC 점수 | 6/6 | 6/6 |
| Stage 9 verdict | APPROVED | APPROVED |
| BLOCK/MAJOR 이슈 | 0 | 0 |
| MINOR 이슈 | 1 (주석-코드 CDPATH 스타일 불일치) | 2 (`settings_require_v04` 파일부재 시 exit 3 vs Sec 9.1 표 4, `_settings_valid_value`가 `&|` 허용) |
| NIT 이슈 | 2 (shellcheck SC2329 info, pre-existing bundle4 test_03) | 2 (SC2329 미사용 함수, settings.sh L77 SC1003 info) |
| 3/3 유닛 테스트 | PASS | PASS |
| jq 차단 환경 | PASS | PASS |
| shellcheck --severity=warning | clean | clean (초기 실패 후 서브에이전트 self-fix 1 round) |

### 4.2 설계·구조적 차이

| 항목 | Round 1 | Round 2 |
|------|---------|---------|
| 테스트 파일 구조 | `tests/v0.6/run.sh` 단일 파일 내 subshell 함수 3개 | `tests/v0.6/run.sh` dispatcher + `test_*.sh` 3개 파일 |
| 입력 검증 레이어 | 값 escape만 (sed metachar `\|&\\`) | 사전 whitelist: `_settings_valid_key` (`[A-Za-z_][A-Za-z0-9_]*`) + `_settings_valid_value` (no `"`, no `\`, no newline) |
| sed 치환 패턴 | `".*` trailing 부분 자연 매치 (comma 유무 모두) | trailing comma 유무 두 패턴 명시 (`,$` / `$`) |
| 경로 discovery | `$ROOT` 명시 설정 또는 `JDEVFLOW_SETTINGS` 직접 경로 | `$JDEVFLOW_ROOT` 또는 upward walk fallback (`.claude/settings.json` 또는 `CLAUDE.md` 앵커 탐색) |
| Post-write verify | grep -c 매핑값 역검증 | sed re-read 후 기대값 비교 |
| `settings_write_stage_assign_block` 범위 | stage_assignments 4라인만 | `team_mode` + stage 4라인 (5라인 한 번에) |
| Missing file 시 read 동작 | die 4 (fail-closed) | 빈 문자열 반환 (read는 관대, write는 die 4) |
| `_settings_die` 시그니처 | `MSG CODE` | `CODE MSG` |
| 주석 언어 | 한국어 주석 + 한국어 에러 | 영어 주석 + 한국어 에러 (mixed) |
| 유닛 테스트 assertion 수 | 약 48 | 약 54 |
| 엣지 케이스 특화 | byte-identity rollback, stray temp 탐지, sed metachar 이스케이프 | invalid value whitelist rejection, missing-file exit 코드 검증, v0.3→exit 3 검증 |

### 4.3 관찰: 서로 다른 스타일의 "좋은 구현"

- **Round 1의 강점 — 부작용 통제**: 파일시스템 차원의 atomic rollback을 `cmp -s` byte-identity로 검증, stray temp 파일 탐지까지 포함. "mv 실패 시 원본 보존"의 관찰 가능한 증거를 제공.
- **Round 2의 강점 — 입력 경계 엄격**: 값에 `"`/`\`/newline을 **사전 거부**하여 쉘 인젝션 원천 차단. 사용자 입력이 lib에 도달하기 전에 fail-fast.
- **공통점**: temp → mv atomic pattern, jq 미사용, sed in-place 미사용, POSIX 준수, 5 exit code 구조(Sec 9.1).
- **차이의 성격**: 어느 쪽이 "더 낫다" 판정 대신, 둘 다 tech_design AC/제약을 만족한 **스타일 분기**. Round 1은 defensive file-system 접근, Round 2는 defensive input-validation 접근.

### 4.4 소요시간 (오케스트레이터 wall-time 기준)

| 단계 | Round 1 (codex→claude, 실제 claude-impl × claude-review) | Round 2 (claude→codex, 실제 claude-impl × claude-review) |
|------|---------|---------|
| 구현 | 오케스트레이터 직접 (누적 ~40분 추정, shellcheck fix 1 cycle 포함) | 서브에이전트 337초 + shellcheck fix 47초 = 약 6.4분 |
| 리뷰 | Opus 서브에이전트 194초 | Opus 서브에이전트 250초 |
| 리포트+커밋 | 수분 | 수분 |

Round 2가 구현 위임(서브에이전트)으로 오케스트레이터 시간 절약. 단, 서브에이전트는 초기 shellcheck directive 누락(37건)을 1 round fix 필요 — 컨텍스트 미보유 환경에서 shellcheck CI 정책(severity=warning)을 처음부터 맞추지 못한 것은 향후 위임 프롬프트 개선 포인트.

### 4.5 Round 2 구현에서 발견된 개선 아이디어 (Round 1에 역적용 가능)

- `_settings_valid_key` / `_settings_valid_value` 사전 whitelist를 Round 1 lib에도 도입 시 쉘 인젝션 방어 레이어 강화. 현재 Round 1은 claude/codex 등 고정 whitelist 값만 통과하므로 실위험 0이지만, `settings_write_key` generic 사용 시 안전망 부재.
- 업로드 walk fallback(`JDEVFLOW_ROOT` auto-discovery)은 호출자 보일러플레이트 감소 효과.

### 4.6 Round 1 설계에서 유지 가치

- 파일시스템 부작용 테스트(stray temp 파일 탐지, cmp -s byte-identity)는 Round 2에 없음. 통합 후 병합 시 Round 1의 테스트 패턴도 `tests/v0.6/` 하위로 끌어들일 가치.

---

## 5. 다음 단계 (운영자 결정 필요)

### 5.1 Round 1 vs Round 2 병합 전략

두 Round 모두 독립 브랜치로 main에 미병합. 선택지:

1. **단일 선택**: Round 1 또는 Round 2 중 하나를 main에 병합, 다른 쪽 폐기.
2. **하이브리드 병합**: 두 구현의 강점을 합친 3차 통합 브랜치 생성 (Round 3).
   - Round 2의 입력 검증 + Round 1의 부작용 테스트 + Round 2의 테스트 파일 구조 등.
3. **현상 유지**: 두 브랜치 모두 실험 기록으로 보존, Round 3(하이브리드) 또는 재구현으로 진행.

### 5.2 M2 진입 전 고려

- `team_mode` 실제 실행자 경로 문제(plugin-cc slash command invocation 브릿지)는 여전히 미해결. Round 1 보고서 §3.3과 동일 이슈.
- M2 대상: `scripts/init_project.sh` + 대화 스크립트 + golden file verbatim 테스트(F-n1). 이 단계에서 운영자 상호작용(brainstorm L58–101 verbatim)이 들어가므로 입력 경계가 더 중요해짐 — Round 2 스타일(`_settings_valid_*`)이 M2에서 자연 적용 가능.

---

## 6. 커밋 계획

브리프 §3 #7 원문 준수:

```sh
sh scripts/git_checkpoint.sh "feat(v0.6): M1 Round 2 Claude 구현 — D1 schema v0.4 + scripts/lib/settings.sh" \
  scripts/lib/settings.sh .claude/settings.json tests/v0.6/run.sh scripts/run_tests.sh \
  docs/04_implementation_v0.6_stage8/round2_brief.md \
  docs/04_implementation_v0.6_stage8/round2_code_review.md \
  docs/04_implementation_v0.6_stage8/round2_report.md
```

브리프 커밋 목록에는 `tests/v0.6/run.sh`만 있지만 실제 산출물은 dispatcher + test_*.sh 3개. `git add tests/v0.6/` 경로로 확장 필요(git_checkpoint.sh는 명시 파일만 처리하므로 추가 경로 포함).
