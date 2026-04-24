# v0.6 Stage 8 M1 Round 2 — Stage 9 코드 리뷰

- **리뷰어:** Claude Opus 서브에이전트 (fallback: 본 에이전트 세션에서 `/codex:review` slash command invoke 불가, `codex exec review` CLI 직접 호출은 F-n3 회피 대상이므로 독립 Opus general-purpose 에이전트가 fallback 리뷰자로 지정됨. Round 1과 동일 fallback 경로 → 리뷰자 변수 통제, 구현자 차이만 A/B 비교)
- **대상 브랜치:** `v0.6-stage8-m1-round2-claude` (main `9e08f3b`에서 분기)
- **team_mode (이번 Round):** `claude-impl-codex-review`
- **일시:** 2026-04-25
- **verdict:** APPROVED

---

## 0. 리뷰 범위 + 리뷰자 경로 제약

### 0.1 범위 (M1 산출물)
- `scripts/lib/settings.sh` (신규, 254 라인)
- `.claude/settings.json` (v0.3 → v0.4 업그레이드)
- `tests/v0.6/run.sh` (harness) + `tests/v0.6/test_settings_read_key.sh` / `test_settings_write_key.sh` / `test_settings_write_stage_assign_block.sh`
- `scripts/run_tests.sh` (v0.6 호출 추가)

### 0.2 범위 외
- Round 1 (`v0.6-stage8-m1-round1-codex`) 브랜치 비교 — A/B 독립성 유지 위해 미참조.
- D2/D3/D4/D5 (M2~M4 대상). `ai_step.sh` 실행 분기 검증은 M4 대상.
- A/B 의미론적 우열 판단 — 별도 A/B 리포트(오케스트레이터)에 위임.

### 0.3 리뷰자 경로 제약 노트
원래 계획 리뷰자는 `/codex:review` (Codex plugin-cc slash command)였으나 본 에이전트 세션에서 slash command invoke 불가. `codex exec review` CLI 직접 호출은 F-n3(`@openai/codex` CLI 비호출)에 저촉. 따라서 본 Opus 서브에이전트가 fallback 리뷰자로 지정됨. Round 1도 동일 경로였으므로 리뷰자 변수는 통제됨.

---

## 1. 집중 AC 검증 결과

| AC | 요구사항 | 검증 방법 | 결과 | 근거 |
|----|---------|----------|------|------|
| AC-5-1 | schema v0.4 신규 필드 5종 POSIX 규약 (2-space 들여쓰기 + 1줄 1키 + 파일 내 유일) | `grep -c` 5종 + `python3 json.load` + 들여쓰기 grep | **PASS** | §1.1 |
| AC-5-2 | `pending_team_mode` 필드 부재 [F-D3] | `grep -rn 'pending_team_mode' scripts/lib/ tests/v0.6/ .claude/settings.json` | **PASS** | §1.2 |
| AC-5-3 | jq 비의존 — fake jq (exit 127, BLOCKED stderr) PATH 선두에서도 테스트 통과 [F-D2] | fake jq + `PATH=$tmpbin:$PATH bash tests/v0.6/run.sh` | **PASS** | §1.3 |
| AC-5-10 | 기존 v0.3 필드 (`agents.*`, `env`, `language`, `teammateMode`) diff 0 bytes [F-5-a] | `git show HEAD:` vs working file diff | **PASS** | §1.4 |

### 1.1 AC-5-1 — schema POSIX 규약

**커맨드 (실행 결과):**
```sh
$ grep -c '"workflow_mode"' .claude/settings.json     # → 1
$ grep -c '"team_mode"' .claude/settings.json         # → 1
$ grep -c '"stage_assignments"' .claude/settings.json # → 1
$ grep -c '"schema_version"' .claude/settings.json    # → 1
$ for k in stage8_impl stage9_review stage10_fix stage11_verify; do
    echo -n "$k: "; grep -c "\"$k\"" .claude/settings.json; done
# stage8_impl: 1 / stage9_review: 1 / stage10_fix: 1 / stage11_verify: 1
$ python3 -c "import json; json.load(open('.claude/settings.json'))"
# (no error → valid JSON)
$ python3 -c "import json; print(json.load(open('.claude/settings.json'))['team_mode'])"
# → claude-impl-codex-review
```

**들여쓰기/1줄1키 검증:**
```
5:  "schema_version": "0.4",
6:  "workflow_mode": "desktop-cli",
7:  "team_mode": "claude-impl-codex-review",
8:  "stage_assignments": {
9:    "stage8_impl": "claude",
10:    "stage9_review": "codex",
11:    "stage10_fix": "claude",
12:    "stage11_verify": "claude"
```
- 4종 top-level 키: 모두 2-space 들여쓰기 + 1줄 1키 + 단일 hit.
- 4종 stage_assignments 자식 키: 4-space 들여쓰기 + 1줄 1키 + 단일 hit.
- `team_mode` 값: `"claude-impl-codex-review"` — Round 2 고정값 일치.

**결과: PASS**

### 1.2 AC-5-2 — pending_team_mode 부재

**커맨드:**
```sh
$ grep -rn 'pending_team_mode' scripts/lib/ tests/v0.6/ .claude/settings.json
# (no output, exit 1)
```
산출물 전 범위 0 hit. **결과: PASS**

### 1.3 AC-5-3 — jq 비의존

**커맨드 (실측):**
```sh
$ tmpbin=$(mktemp -d)
$ printf '#!/bin/sh\necho BLOCKED >&2\nexit 127\n' > "$tmpbin/jq"
$ chmod +x "$tmpbin/jq"
$ out=$(PATH="$tmpbin:$PATH" bash tests/v0.6/run.sh 2>&1)
$ echo "rc=$?"; echo "$out" | grep -c BLOCKED
# rc=0
# BLOCKED 출현 횟수: 0
# 마지막: === v0.6 results: 3 pass, 0 fail ===
```
PATH 선두에 강제 차단 jq를 배치해도 rc=0, BLOCKED stderr 0회. 라이브러리가 jq에 일절 의존하지 않음을 입증. **결과: PASS**

### 1.4 AC-5-10 — v0.3 하위 호환

**검증:** HEAD = main `9e08f3b`의 `.claude/settings.json` (v0.3)을 워킹트리 v0.4와 비교.
```sh
$ git show HEAD:.claude/settings.json > /tmp/v03.json
$ grep '"schema_version"' /tmp/v03.json   # → "0.3"
$ grep '"schema_version"' .claude/settings.json  # → "0.4"
$ diff <(grep '"language"'    /tmp/v03.json) <(grep '"language"'    .claude/settings.json)  # → empty
$ diff <(grep '"teammateMode"' /tmp/v03.json) <(grep '"teammateMode"' .claude/settings.json) # → empty
$ diff <(sed -n '/"env": {/,/^  }/p'    /tmp/v03.json) <(sed -n '/"env": {/,/^  }/p'    .claude/settings.json)   # → empty
$ diff <(sed -n '/"agents": {/,/^  }$/p' /tmp/v03.json) <(sed -n '/"agents": {/,/^  }$/p' .claude/settings.json)  # → empty
```
- `language`, `teammateMode`, `env`, `agents.*` 4개 v0.3 블록 전원 diff 0 bytes.
- `schema_version`만 `0.3` → `0.4` bump (의도된 변경).
- 신규 v0.4 필드 (`workflow_mode`, `team_mode`, `stage_assignments`)는 `schema_version` 직후에 삽입 — 기존 필드 위치/내용 미간섭.

**결과: PASS**

---

## 2. 추가 확인

### 2.1 shellcheck (CI 정책 = `--severity=warning`)

**커맨드:**
```sh
$ shellcheck --severity=warning \
    scripts/lib/settings.sh tests/v0.6/run.sh \
    tests/v0.6/test_settings_read_key.sh \
    tests/v0.6/test_settings_write_key.sh \
    tests/v0.6/test_settings_write_stage_assign_block.sh \
    scripts/run_tests.sh
# rc=0 (출력 없음)
```
**rc=0 — clean.** 

(참고: severity 미지정 default 실행 시 SC1003/SC2329 info 2건 표시되나 모두 info-level이고 CI 정책 외이므로 통과. 산출물에 `# shellcheck disable=SC1007,SC1090` 주석으로 적정 disable 사용.)

### 2.2 F-D2 — jq 호출 코드 부재

**커맨드:**
```sh
$ grep -rnE '\bjq\b' scripts/lib/ tests/v0.6/
# scripts/lib/settings.sh:13:#   - No jq (F-D2).
```
유일한 hit는 헤더 주석 (정책 명시). 실제 jq 호출 0건. **OK.**

### 2.3 F-D3 — pending_team_mode 부재
§1.2와 동일. 0 hit. **OK.**

### 2.4 F-2-a — team_mode 리터럴 lib 외부 노출 금지

**커맨드:**
```sh
$ grep -nE '"(claude-only|claude-impl-codex-review|codex-impl-claude-review)"' scripts/lib/settings.sh
# (no output)
$ grep -nE 'case .*_swsa_mode|claude-only\)|claude-impl-codex-review\)|codex-impl-claude-review\)' scripts/lib/settings.sh
# 185:    case "$_swsa_mode" in
# 186:        claude-only)
# 188:        claude-impl-codex-review)
# 190:        codex-impl-claude-review)
# 193:            _settings_die 2 "알 수 없는 team_mode: '$_swsa_mode' (허용: ...)
```
- team_mode 리터럴은 `settings_write_stage_assign_block` 내부 `case` 분기 (line 185–195)에서만 등장.
- 이는 **Sec 2.5 매핑표 쓰기 경로** (브리프 §2.4: "settings_write_stage_assign_block 내부의 `case "$_swsa_mode"`는 Sec 2.5 매핑표 쓰기 경로이므로 허용").
- 라이브러리 외부(scripts/lib/ 외 호출자)에서의 실행 분기 오염은 본 PR 범위에서 발생할 여지 없음 (호출자 미존재 — D2/D3/D5는 M2~M4 대상).

**OK** (M4 시점 `ai_step.sh` 도입 시 별도 검증 필요).

### 2.5 POSIX 준수

**커맨드:**
```sh
$ grep -nE '\blocal\b|\[\[' scripts/lib/settings.sh tests/v0.6/*.sh
# scripts/lib/settings.sh:15:#   - POSIX-only: no `local`, no `[[ ]]`, no process substitution.
```
유일한 hit는 헤더 주석. 실제 `local` 키워드 / `[[ ]]` / process substitution 0건.

코드 inspection으로 추가 확인:
- 함수 지역변수는 모두 `_<함수prefix>_<name>` 명명 컨벤션 (예: `_swk_key`, `_swsa_mode`)으로 충돌 회피.
- 전부 `[ ... ]` POSIX test, `case ... in ... esac` 사용.
- 명령 치환 `$(...)`, 변수 치환 `${VAR:-default}` POSIX 표준.

**OK.**

### 2.6 sed -i 부재

**커맨드:**
```sh
$ grep -rnE 'sed -i' scripts/lib/ tests/v0.6/
# scripts/lib/settings.sh:14:#   - No sed -i (macOS BSD vs GNU incompatibility). Always: temp file -> mv.
```
헤더 주석만 존재. 모든 쓰기 경로는 `mktemp` → `sed > $tmp` → `mv $tmp $file` 패턴 (line 156–177, 216–252). **OK.**

### 2.7 sh 인터프리터 통과

**커맨드:**
```sh
$ sh tests/v0.6/run.sh
# === v0.6 results: 3 pass, 0 fail ===
# rc=0

$ bash tests/v0.6/run.sh
# === v0.6 results: 3 pass, 0 fail ===
# rc=0
```
양쪽 인터프리터 모두 rc=0, 45개 sub-assertion 전원 PASS. **OK.**

### 2.8 exit code 일관성 (Sec 9.1 vs 실측)

| 시나리오 | Sec 9.1 기대 | 실측 | 평가 |
|---------|--------------|------|------|
| `settings_write_key` — settings.json 부재 | 4 (absent) | **4** | OK |
| `settings_require_v04` — v0.3 schema | 3 (schema) | **3** | OK |
| `settings_write_stage_assign_block` — invalid team_mode | 2 (bad arg) | **2** | OK |
| `settings_write_key` — 키 누락 (corrupt) | 5 (corrupt) | **5** | OK |
| `settings_require_v04` — settings.json 부재 | 4 (absent) | **3** | MINOR |

마지막 케이스만 모호. 코드(line 91)는 파일 부재 시 `_settings_die 3`을 호출 ("init_project.sh 실행 필요"). Sec 9.1 표는 "absent file = 4". 구현 의도("v0.4 요구 미충족 = schema mismatch"로 통합)는 합리적이나 표와 1라인 불일치. **MINOR** (§3 참조).

### 2.9 입력 검증 견고성 (Round 2 특화 관찰)

`_settings_valid_value` 화이트리스트는 `"`, `\`, `\n` 만 거부. sed metachar 중 `&`, `|`는 허용. 실측:

| 입력 값 | sed 동작 | 최종 상태 | 평가 |
|--------|---------|----------|------|
| `a\b` | 화이트리스트 거부 (exit 5) | 원본 보존 | OK |
| `a&b` | sed `&`가 매치 전체로 치환 → 잘못된 값 → **post-write 검증으로 mismatch detect** → die 5 | 원본 보존 | safe-fail |
| `a\|b` | sed 구분자 `\|`와 충돌 → sed exit error → die 5 | 원본 보존 | safe-fail |

**결론:** 안전성(원본 보존)은 확보. 단, `&`/`|` 시 호출자에게 fail이지만 "왜 fail인지"는 명확하지 않음 (post-write mismatch로 늦게 잡힘). M2 단계에서 `init_project.sh` 등이 사용자 입력 직접 전달 시 `_settings_valid_value`가 sed 구분자(`|`)를 미리 거부하면 진단성 향상. **MINOR** (§3 참조).

### 2.10 라이브 테스트 결과

```
==> test_settings_read_key.sh                     12 sub-tests PASS
==> test_settings_write_key.sh                    12 sub-tests PASS
==> test_settings_write_stage_assign_block.sh     21 sub-tests PASS
=== v0.6 results: 3 pass, 0 fail ===
```
총 45개 sub-assertion 전원 PASS (CRLF, 한글 값, 공백 값, missing key, atomic rollback, schema 손상, 라운드트립, JSON validity 등 엣지케이스 광범위 커버).

---

## 3. 발견 이슈

### BLOCK
없음.

### MAJOR
없음.

### MINOR

**MINOR-1 — `settings_require_v04` 파일 부재 시 exit code Sec 9.1 표와 1라인 불일치**
- 위치: `scripts/lib/settings.sh:91`
- 현상: 파일 부재 시 `_settings_die 3`. Sec 9.1는 "absent file = 4".
- 영향: 호출자가 `case rc in 4) ...; esac`로 분기하면 의도와 다른 동작 가능.
- 권고: 코드를 4로 변경하거나, Sec 9.1 표 주석에 "require_v04 컨텍스트에서 absent도 schema mismatch로 통합 처리"를 명시. (M2~M4에서 호출자 등장 시 일관성 결정)

**MINOR-2 — `_settings_valid_value` 화이트리스트가 sed metachar `&`/`|`를 허용**
- 위치: `scripts/lib/settings.sh:73-82`
- 현상: 두 metachar는 사전 검증을 통과하나 sed 단계에서 잘못된 치환/에러 → post-write 검증으로 die 5. 안전성은 보장되나 진단성이 떨어짐.
- 영향: 현재 Round 2 산출물 범위에서 호출자(자동 사용자 입력 경로)가 없어 실위험 0. M2 `init_project.sh`/`switch_team.sh`가 도입되며 사용자 입력을 직접 전달할 때 진단성 이슈가 표면화될 수 있음.
- 권고: 화이트리스트에 `|` 추가(sed 구분자), `&` 또는 sanitize. 또는 sed 구분자를 `|` 대신 사용 빈도 낮은 문자(예: 제어문자)로 변경. 우선순위는 낮음 — Sec 2.4 허용값 (`desktop-only|cli-only|...`, `claude|codex` 등)에 metachar가 등장하지 않으므로 정책상 영향 없음.

### NIT

**NIT-1 — `tests/v0.6/test_settings_read_key.sh:31` 의 `run_with_settings` 함수 미사용**
- shellcheck SC2329 info-level. 정의만 되어 있고 호출처 없음 (이후 sub-shell 인라인 패턴으로 일관 변경됨).
- 권고: 제거하거나 사용하도록 통합. 영향 없음.

**NIT-2 — `scripts/lib/settings.sh:77` `*'\'*` 패턴이 SC1003 경고**
- shellcheck SC1003 info-level (escape 권장). 의도된 패턴이므로 동작 OK.
- 권고: `# shellcheck disable=SC1003` 라인 위에 추가 또는 그대로 유지 (CI severity=warning 정책 통과).

---

## 4. 강점

1. **AC 4종 (5-1, 5-2, 5-3, 5-10) 전원 PASS** — 객관 측정 기준 모두 통과.
2. **shellcheck `--severity=warning` clean** — CI 통과 보장.
3. **POSIX sh 엄격 준수** — `local`/`[[ ]]`/process substitution 0건. `sh tests/v0.6/run.sh` 단독으로도 통과 (bash 의존 없음).
4. **Atomic write 패턴 일관성** — 모든 쓰기 경로가 `mktemp` → `sed > tmp` → post-write 검증 → `mv`. 검증 실패 시 `rm $tmp`로 원본 보존.
5. **Pre-write key uniqueness 검사** (`settings_write_key` line 148–154, `settings_write_stage_assign_block` line 205–214) — `grep -c`로 hits=1 확인 후에만 진행. 키 중복 또는 부재 시 die 5로 실패.
6. **Post-write 값 일치 검증** — sed 치환 후 read-back 값이 입력과 다르면 mismatch detect → 원본 복원. `&` metachar 같은 sed 부작용도 안전 fail.
7. **테스트 엣지케이스 폭** — CRLF, 한글 값, 공백 값, 빈 값, missing key, atomic rollback (read-only mv 시뮬레이션 포함), schema 손상, 라운드트립, JSON validity 후속 검증 — 45개 sub-assertion.
8. **Sub-shell 격리 패턴** — 각 테스트 케이스를 `( JDEVFLOW_ROOT=...; export JDEVFLOW_ROOT; . "$LIB"; ... )` 서브셸에서 source/실행하여 상태 누수 방지. POSIX 호환 격리 모범사례.
9. **`settings_path` 자동 탐색** — `JDEVFLOW_ROOT` 미지정 시 `.claude/settings.json` 또는 `CLAUDE.md` 앵커를 walk-up으로 탐색. 호출자 부담 감소.
10. **에러 메시지 KO + 진단 정보** — `_settings_die`가 한국어 메시지 + 컨텍스트 (키명, hits 수, 기대값) 포함. v0.5 정책 승계.

---

## 5. 최종 verdict

집중 AC 4종 (AC-5-1 / AC-5-2 / AC-5-3 / AC-5-10) 모두 PASS. shellcheck `--severity=warning` clean. 설계 제약 (F-D2, F-D3, F-2-a, sed -i 부재, POSIX 준수) 전원 충족. 라이브 테스트 45개 sub-assertion 전원 PASS. M1 산출물 품질 양호.

발견된 MINOR 2건 / NIT 2건은 모두 BLOCK이 아니며 후속 마일스톤(M2~M4)에서 호출자 도입 시 자연스럽게 정리 가능. 즉시 진행 가능.

**verdict: APPROVED**
