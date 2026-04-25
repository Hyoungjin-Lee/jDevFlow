---
version: v0.6.1
stage: 9 (code_review)
date: 2026-04-26
mode: Standard
session: 24 (jOneFlow → jOneFlow rename, post-incident recovery)
reviewer: claude-opus-self-review (env_constraint — codex plugin-cc unavailable)
prior_incident_recovery: true
target:
  - scripts/v0.6.1/expressions.txt
  - scripts/v0.6.1/pre_check.sh
  - scripts/v0.6.1/post_check.sh
  - scripts/v0.6.1/verify_all.sh
  - scripts/v0.6.1/rename_n1.sh
upstream:
  - docs/03_design/v0.6.1_n1_rename/technical_design.md (Stage 5 정본)
  - docs/02_planning_v0.6.1/plan_review.md (Stage 3, F-N1-a~h + EC-1~10 정의)
  - docs/02_planning_v0.6.1/plan_final.md (Stage 4 운영자 승인)
commit: pending (본 review 작성 후 git_checkpoint.sh 예정)
verdict: APPROVED_WITH_MINOR
findings:
  critical: 0
  major: 0
  minor: 2
  info: 3
---

# v0.6.1 N1 jOneFlow → jOneFlow rename + history 재작성 — Stage 9 Code Review

> **상위:** `docs/03_design/v0.6.1_n1_rename/technical_design.md` (Stage 5)
> **하위:** Stage 11/12 (filter-repo 실 실행 — 운영자 승인 + 사후 검증) — 본 review가 진입 게이트.
> **범위:** scripts/v0.6.1/ 5건 (expressions.txt + 4 sh) 독립 검토. F-N1-a~h(8) + EC-1~10(10) + AC-N1-1~8(8) 흡수 매트릭스 + S1~S5 안전 제약 cross-ref + 사고 회고.

---

## Sec. 0. 경고 — Codex 미사용 (환경 제약)

본 리뷰는 정책상 `/codex:review`로 진행되어야 하나(`.claude/settings.json` `stage_assignments.stage9_review = codex`), 본 세션 환경에서 codex plugin-cc 도구가 노출되지 않아 호출 불가. v0.6 본 릴리스 + 직전 v0.6.1 review 동일 패턴에 따라 **Claude Opus 4.7 독립 self-review**로 대체했다.

**운영자 follow-up 권장:** Stage 11/12 진입 전 또는 직후에 `/codex:review docs/04_implementation_v0.6.1_n1_rename/code_review.md scripts/v0.6.1/` 명시적 검증. 본 리뷰는 객관 명령(shellcheck / bash -n / grep / od / dry-run 직접 호출) 결과를 모두 인용해 재현 가능성을 확보했으나, 독립 reviewer perspective의 누락 가능성은 남아 있다.

---

## Sec. 0.5. 사고 회고 (운영자 brief 명시 — 필수)

### 0.5.1 사고 발생 원인

이전 세션에서 filter-repo 실 실행 시 `expressions.txt`에 `#` 주석 라인이 포함되어 있었다. filter-repo는 **단독 `#` 라인을 "literal pattern + default replacement = `***REMOVED***` 마스킹"** 명령으로 해석한다(filter-repo `--replace-text` 파일 grammar). 결과:

- 모든 shebang(`#!/bin/sh`, `#!/usr/bin/env bash`)이 `***REMOVED***!/bin/sh` 형태로 손상
- 모든 주석 라인이 `***REMOVED***` 마스킹
- 모든 markdown heading(`#`, `##`, `###`)이 `***REMOVED***`로 치환
- 영향 범위: history 전체 + worktree 전체

**2차 사고:** 동일 세션의 `post_check.sh`가 `git reflog expire --expire=now --all` + `git gc --prune=now --aggressive`를 실행. 이로 인해 `backup-pre-v0.6.1-rename` 브랜치가 unreachable 객체로 분류되어 **영구 삭제**. 로컬 복구 수단 완전 상실. GitHub origin fresh clone(`1543fd6`)이 유일한 안전망이었다.

### 0.5.2 영향 범위 정리

| 손상 항목 | 범위 | 결과 |
|----------|------|------|
| `#` 문자 마스킹 | shebang + 모든 주석 + 모든 markdown heading | 코드/문서 전부 `***REMOVED***` 토큰 오염 |
| 백업 브랜치 영구 삭제 | reflog gc + aggressive prune | 로컬 복구 수단 완전 상실 |
| GitHub origin | 재작성 force push 전이라 안전 | fresh clone으로 1543fd6 복구 가능 |
| md 산출물 6종 | history 손상 + worktree 손상 | 운영자 수동 이식으로 복원 |

### 0.5.3 본 재작성에서 흡수한 안전 제약 (S1–S5)

| ID | 제약 | 본 구현 흡수 |
|----|------|-------------|
| **S1** | expressions.txt = 정확히 3 매핑만, `#` 주석/빈줄/BOM 일체 금지 | `expressions.txt` 3 라인만 (`grep -c '^#'` = 0 검증), pre_check.sh L83–95에서 매핑 3 / 주석 0 / 총 3 라인 사전 검증 |
| **S2** | post_check.sh 정리 명령 일체 제거 (reflog gc / refs/original 정리 / update-ref -d 금지) | post_check.sh L10–15 의도 명시 + L23 책임 축소 + 위험 키워드 grep 0건 (실행 라인) |
| **S3** | 모든 sh 파일 secret-redaction 안전 (REMOVED 0건, shebang 첫 바이트 0x23 보존) | 4 sh 파일 head -c 1 = `#` 4건 + scripts/v0.6.1 전체 `REMOVED` 토큰 0 hits |
| **S4** | filter-repo 실 실행 = 본 dispatch 범위 외 | 본 review의 모든 dry-run 호출에서 mutation 0건 + 본 commit 차단 항목 0건 |
| **S5** | rename_n1.sh 안전 가드 강화 (--dry-run 기본 + --apply 별도 + TTY confirm) | rename_n1.sh L33–47 변수 default APPLY=0/YES=0, L73–95 `_confirm_apply`, L97–111 `_print_recovery_info`, 비-TTY + --apply + --yes 부재 시 exit 2 |

---

## Sec. 1. 종합 판정 (Verdict)

**APPROVED_WITH_MINOR** — Stage 11/12 (filter-repo 실 실행) 진입 가능.

| 분류 | 개수 | 차단 여부 |
|------|------|----------|
| Critical | 0 | — |
| Major | 0 | — |
| Minor | 2 | 비차단 (운영자 인지 후 진입 가능) |
| Info | 3 | 비차단 |

**근거:** R1~R9 모두 PASS 또는 PASS_WITH_NOTE. shellcheck / bash -n / sh -n 0 error. dry-run 모드 default 동작 확인 (mutation 0). S1~S5 안전 제약 5/5 흡수 확인. F-N1-a~h 8/8 + EC-1~10 10/10 + AC-N1-1~8 8/8 cross-ref 확인. 사고 회고 핵심 원인(expressions.txt # 주석, post_check reflog gc)이 코드 차원에서 차단됨.

**본 commit 차단 항목:** 없음.

**Stage 11/12 진입 가능 여부:** **가능.** 단 Sec.10 minor / info 항목 운영자 인지 후. 특히 운영자는 **filter-repo 실 실행 직전 working tree clean** 상태를 확보해야 한다(Sec.10 Minor-1).

---

## Sec. 2. R1~R9 평가

### R1. AC-N1-1~8 검증 가능성 — **PASS**

verify_all.sh의 `_ac_n1_1` ~ `_ac_n1_8` 함수 8건 분리 확인. 각 AC가 객관 측정 명령 1개에 매핑됨. phase 분배도 design Sec.4 단계 표와 일치:

- phase1 (filter-repo 직후): _ac_n1_1, _ac_n1_3, _ac_n1_7, _ac_n1_2 (verify_all.sh L186–192)
- phase2 (remote 재등록 직후): _ac_n1_4, _ac_n1_6 (L194–198)
- phase3 (force push + 폴더 mv 후): _ac_n1_5, _ac_n1_8 (L200–204)

**측정 명령 정확성:**
- AC-N1-1 (worktree grep): `grep -rnE 'jOneFlow|joneflow|JONEFLOW' . --exclude-dir=.git --exclude-dir=node_modules` (L65–67) — design Sec.3.1과 일치
- AC-N1-3 (commit msg): `git log --all --pretty=format:'%H %s' | grep -cE '...' || true` (L93–94) — `--all` 명시 (review GAP-N1-3a 흡수)
- AC-N1-5 (HTTP 200): `curl -fsSL https://github.com/Hyoungjin-Lee/jOneFlow -o /dev/null` (L120) — design Sec.3.1 일치
- AC-N1-8 (상위 경로): Q5-2 default A 자동 무효화 분기 포함 (L168–180), settings.local.json 1건 허용 로직 명시

**측정 시점/phase 분배 정합성:** design Sec.4 단계 표와 verify_all.sh `_run_phase*` 매핑 검증 — 불일치 0건.

### R2. F-N1-a~h 8/8 흡수 — **PASS**

| F | 의미 | 본 구현 흡수 위치 |
|---|------|------------------|
| F-N1-a | 백업 영구 (Change-1) | pre_check.sh L75–79 (백업 부재 확인 → 신규 생성), L134–144 (백업 생성, 삭제 단계 없음). post_check.sh L68–73 (보존 확인). rename_n1.sh L86–87 (`_confirm_apply`에서 백업 정보 출력) + L101–106 (`_print_recovery_info`) |
| F-N1-b | IDE/worktree 종료 | pre_check.sh L128–132 (수동 확인 안내) + rename_n1.sh L177–178 (인계 시그널) |
| F-N1-c | remote 재등록 = GitHub rename 후 | rename_n1.sh L114–180 (phase1) + L183–245 (phase2) 분리 + 인계 시그널로 운영자 GitHub rename 대기 강제 |
| F-N1-d | 폴더 mv 절대경로 fallback | rename_n1.sh L242–244 인계 시그널에서 shell rc + settings.local.json 명시 |
| F-N1-e | case-sensitive 3종 한정 | expressions.txt 3 라인 정확히 (`jOneFlow`/`joneflow`/`JONEFLOW`) + pre_check.sh L83–95 매핑 수 검증 |
| F-N1-f | APFS 단일 mv | rename_n1.sh L232–233 인계 시그널에서 "단일 mv 명령, cp+rm 금지" 명시 |
| F-N1-g | reflog + stale lock 사후 검증 | pre_check.sh L60–72 (stale lock 사후 검증 — Change-2). post_check.sh는 S2 정책상 정리 행위 자체 부재 |
| F-N1-h | release.sh 하드코딩 | pre_check.sh L117–126 INFO 출력 (release.sh 사전 식별) |

8/8 흡수 확인.

### R3. EC-1~10 흡수 — **PASS**

| EC | 흡수 위치 |
|----|----------|
| EC-1 (백업 retention) | F-N1-a와 동일 |
| EC-2 (.git/ 제외) | verify_all.sh L66, L72 / post_check.sh L41, L48 — `--exclude-dir=.git --exclude-dir=node_modules` |
| EC-3 (상위 경로) | pre_check.sh L97–113 (baseline grep) + verify_all.sh L153–182 (AC-N1-8 자동 무효화 분기) |
| EC-4 (remote 타이밍) | rename_n1.sh phase1/phase2 분리 + 인계 시그널 1 (L154–179) |
| EC-5 (폴더 mv 후 env) | rename_n1.sh L242 (shell rc 안내) |
| EC-6 (reflog/lock) | pre_check.sh L60–72 (stale lock 사후 검증). reflog gc는 S2 정책으로 의도적 미실행 |
| EC-7 (dry check) | rename_n1.sh L201–210 (5.5단계) + verify_all.sh L128–135 (_ac_n1_6) |
| EC-8 (CI/Actions) | design Sec.7.3 — `.github/workflows/ci.yml` 직접 하드코딩 0건 확인 (별도 패치 불요). 본 구현 코드 차원 추가 작업 없음 (정합) |
| EC-9 (APFS 단일 mv) | F-N1-f와 동일 |
| EC-10 (테스트 하드코딩) | verify_all.sh L137–151 (_ac_n1_7) — bundle1 + verbatim 2 파일 jOneFlow 치환 확인 |

10/10 흡수 확인.

### R4. 보안 — **PASS** (사고 회고 강조 모두 통과)

| 항목 | 결과 | 근거 |
|------|------|------|
| 비밀값 노출 | 0 hits | `grep -nE 'API_KEY\|TOKEN\|PASSWORD\|SECRET' scripts/v0.6.1/*.sh` = 0 (수동 확인). 키 사용 코드 자체 없음 |
| `eval` / `sh -c "$input"` | 0 hits | `grep -nE 'eval\|sh -c "\$' scripts/v0.6.1/*.sh` = 0 |
| chmod/chown/rm -rf 변경 | 0 hits (실행) | `grep -nE 'chmod\|chown\|rm -rf' scripts/v0.6.1/*.sh` = 1 hit, post_check.sh L11 주석 라인 (정책 명시 텍스트만) |
| ★ S1 expressions.txt 형식 | PASS | `wc -l` = 3, `grep -c '^#'` = 0, 매핑 정규식 3 매치, BOM/빈줄 0 |
| ★ S2 post_check 정리 명령 | PASS (실행 라인 0) | `grep -nE '^[[:space:]]*(git reflog expire\|git gc --prune\|rm -rf [^[:space:]]*refs/original\|git update-ref -d)'` = 0 hits. L10–15, L75–79는 모두 주석/안내 텍스트 |
| ★ S3 shebang 첫 바이트 0x23 | PASS | `head -c 1 scripts/v0.6.1/*.sh \| od -An -c` 출력에서 4 파일 모두 `#` 확인. `grep -rln 'REMOVED' scripts/v0.6.1/` = 0 hits |

**추가 안전 관찰:**
- `set -eu` 4 sh 파일 모두 적용 (pre_check.sh L28, post_check.sh L24, verify_all.sh L24, rename_n1.sh L33)
- 변수 quoting 일관 (shellcheck CLEAN으로 자동 검증됨)
- `_die` / `_fail` 헬퍼가 stderr 출력 + 명시적 exit code (1/2/3)
- TTY 환경 검사 (rename_n1.sh L81–83) — 비대화형 자동화 안전망

### R5. 회귀 — **PASS** (의도된 회귀)

- v0.6 기능에 대한 직접 영향 없음 (본 5건은 `scripts/v0.6.1/` 신규 디렉토리 한정, 기존 파일 수정 0건)
- v0.6 테스트 13/13 PASS는 현 시점에서는 jOneFlow 문자열 의존이지만 filter-repo 후 자동 jOneFlow 치환 → 정합 (verify_all.sh _ac_n1_2 + _ac_n1_7로 사후 검증)
- v0.6.0 commit chain (1543fd6 이전) 변경 없음
- 본 리뷰 시점 worktree에 `scripts/v0.6.1/` (untracked) + `docs/01_brainstorm_v0.6.2/brainstorm.md` (modified) + `scripts/watch_v061_rebuild.sh` (untracked) 존재 — 본 리뷰 범위 외, filter-repo 실 실행 직전 정리 필요 (Sec.10 Minor-1)

### R6. fail-closed 원칙 — **PASS**

- exit code 일관:
  - `0` — 모든 PASS
  - `1` — 검증/단계 실패 (pre_check.sh L39, post_check.sh L33, verify_all.sh L36, rename_n1.sh L50 default)
  - `2` — 환경 오류 / 잘못된 인자 (pre_check.sh L41, verify_all.sh L50/55, rename_n1.sh `_die_env`/`_die`)
  - `3` — 운영자 confirm 거부 (rename_n1.sh L93)
- 첫 실패 즉시 중단: `set -eu` + 모든 `_fail`이 `exit 1` 직접 호출 (continue 분기 없음)
- 백업 보존: post_check.sh L68–73이 보존 확인 + 부재 시 `_warn` (exit 0 유지 — Change-1 영구 정책 + S2 정책상 직접 삭제 행위 0건)
- post_check.sh가 백업을 삭제하지 않음 직접 확인: post_check.sh 전체 라인에서 `git branch -D` / `git update-ref -d` / `git reflog expire` 0 hits (실행 라인)

### R7. 한국어 메시지 정합성 — **PASS**

- 모든 사용자 노출 메시지 한국어 (PASS/FAIL/INFO/WARN 라벨은 영문 prefix + 한국어 본문)
- 에러 메시지에 라인/위치 + 재현 명령 포함 일관 (예: pre_check.sh L77 "이전 결과 확인 후 git branch -D ...")
- 한글 인코딩 안전: `--preserve-commit-encoding` 옵션 (rename_n1.sh L130) — 사고 영향 없는 잘 알려진 안전 옵션

### R8. shellcheck CLEAN 재검증 — **PASS**

```
$ shellcheck scripts/v0.6.1/*.sh
$ echo $?
0
```

ERROR/WARNING/INFO 0 hits. `# shellcheck disable=...` 주석 3건 확인:
- pre_check.sh L30 (`SC1007 — CDPATH= idiom`) — 정당
- pre_check.sh L67 (`SC2012 — ls 메시지용`) — 정당 (find 대비 가독성)
- post_check.sh L26, verify_all.sh L26, rename_n1.sh L35 — 동일 SC1007 idiom

`bash -n` / `sh -n`:
```
bash -n scripts/v0.6.1/rename_n1.sh         # OK
sh -n scripts/v0.6.1/pre_check.sh           # OK
sh -n scripts/v0.6.1/post_check.sh          # OK
sh -n scripts/v0.6.1/verify_all.sh          # OK
```

0 syntax error.

### R9. dry-run 모드 정합성 (S5 핵심) — **PASS_WITH_NOTE**

직접 호출 검증:

| 호출 | 기대 동작 | 실제 결과 | 판정 |
|------|----------|----------|------|
| `bash rename_n1.sh phase1` | APPLY=0 default + pre_check DRY_RUN=1 | ✅ APPLY=0 출력 + DRY_RUN=1 (단, working tree dirty 즉시 fail-closed로 종료) | PASS |
| `bash rename_n1.sh phase1 --apply </dev/null` (비-TTY) | exit 2 + S5 메시지 | ✅ "비-TTY 환경에서 --apply 사용 시 --yes 명시 필요 (S5 안전 가드)" + exit 2 | PASS |
| `bash rename_n1.sh phase2 </dev/null` (default) | APPLY=0 dry-run 완주 | ✅ phase2 전 단계 `[DRY] ...` 출력 + 인계 시그널까지 정상 출력 (mutation 0) | PASS |
| `bash rename_n1.sh phase2 --apply </dev/null` (비-TTY) | exit 2 | ✅ 동일 S5 메시지 + exit 2 | PASS |
| `bash rename_n1.sh` (인자 없음) | usage + exit 2 | ✅ usage 출력 + exit 2 | PASS |
| `bash rename_n1.sh badphase` | exit 2 | ✅ "알 수 없는 인자: badphase" + exit 2 | PASS |
| `sh verify_all.sh` (인자 없음) | usage + exit 2 | ✅ usage + exit 2 | PASS |
| `sh verify_all.sh badphase` | exit 2 | ✅ "잘못된 phase: badphase" + exit 2 | PASS |

**pre_check.sh DRY_RUN=1 동작 (L135–138):** 백업 브랜치 생성 echo만 + `git branch` 미실행 — 정확.

**post_check.sh dry-run 분기 부재:** 정리 명령 자체가 0건이라 dry/wet 분기 불요. 본 버전에서 의도적 미설계 — 정합 (S2 정책 일관).

**Note (PASS_WITH_NOTE 사유):** phase1 default dry-run 호출이 본 리뷰 시점 working tree dirty(scripts/v0.6.1/ + docs/01_brainstorm_v0.6.2/brainstorm.md + scripts/watch_v061_rebuild.sh)로 pre_check.sh L55–58에서 fail-closed exit 1. 이는 정상 동작이며 dry-run 모드라도 사전 점검은 실 환경 검증을 수행해야 하므로 의도된 설계. 운영자가 실 실행 직전 worktree clean 상태에서 phase1 default 호출 시 정상 완주 기대 (Sec.10 Minor-1 안내).

---

## Sec. 3. AC-N1-1~8 매트릭스

| AC | verify_all.sh 함수 | phase | 측정 명령 (요약) | 판정 | 비고 |
|----|--------------------|-------|------------------|------|------|
| AC-N1-1 | `_ac_n1_1` (L64–77) | phase1 | `grep -rnE '...' . --exclude-dir=.git --exclude-dir=node_modules` | PASS | design Sec.3.1 일치 |
| AC-N1-2 | `_ac_n1_2` (L79–90) | phase1 | `sh scripts/run_tests.sh` | PASS | 실패 시 마지막 20행 출력 |
| AC-N1-3 | `_ac_n1_3` (L92–105) | phase1 | `git log --all --pretty=format:'%H %s' \| grep -cE '...'` | PASS | review GAP-N1-3a 흡수 (`--all`) |
| AC-N1-4 | `_ac_n1_4` (L107–117) | phase2 | `git remote -v \| grep -q 'jOneFlow'` | PASS | URL 형태 grep 매칭 |
| AC-N1-5 | `_ac_n1_5` (L119–126) | phase3 | `curl -fsSL https://github.com/.../jOneFlow -o /dev/null` | PASS | exit 0 = HTTP 2xx |
| AC-N1-6 | `_ac_n1_6` (L128–135) | phase2 | `git ls-remote origin > /dev/null 2>&1` | PASS | EC-7 흡수 |
| AC-N1-7 | `_ac_n1_7` (L137–151) | phase1 | `grep -qE 'jOneFlow' tests/bundle1/run_bundle1.sh + tests/v0.6/test_init_project_verbatim.sh` | PASS | 두 파일 모두 ≥1 hit |
| AC-N1-8 | `_ac_n1_8` (L153–182) | phase3 | `grep -rnE '...' /Users/.../Jonelab_Platform/ --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git ...` + Q5-2 자동 무효화 분기 | PASS | settings.local.json 1건 허용 로직 명시 |

8/8 PASS.

---

## Sec. 4. F-N1-a~h 매트릭스 (8/8)

| F | 의미 | 본 구현 흡수 (파일:라인) | 판정 |
|---|------|--------------------------|------|
| F-N1-a | 백업 영구 (Change-1) | pre_check.sh:75–79 (부재 확인) + 134–144 (생성), post_check.sh:68–73 (보존), rename_n1.sh:86–87 + 101–106 | PASS |
| F-N1-b | IDE/worktree 종료 | pre_check.sh:128–132 (수동 안내), rename_n1.sh:177–178 | PASS |
| F-N1-c | remote 재등록 = GitHub rename 후 | rename_n1.sh:114–180 (phase1) + 183–245 (phase2) 분리 + 인계 시그널 | PASS |
| F-N1-d | 폴더 mv 절대경로 fallback | rename_n1.sh:242–244 (shell rc + settings.local.json 안내) | PASS |
| F-N1-e | case-sensitive 3종 한정 | expressions.txt 3 라인 + pre_check.sh:83–95 매핑 수 검증 | PASS |
| F-N1-f | APFS 단일 mv | rename_n1.sh:232–233 ("단일 mv 명령, cp+rm 금지, F-N1-f") | PASS |
| F-N1-g | reflog + stale lock 사후 검증 (Change-2) | pre_check.sh:60–72 (stale lock), post_check.sh 정리 행위 0 (S2) | PASS |
| F-N1-h | release.sh 하드코딩 치환 | pre_check.sh:117–126 (사전 식별 INFO) — filter-repo 자동 처리 | PASS |

8/8 흡수 확인.

---

## Sec. 5. EC-1~10 매트릭스 (10/10)

| EC | 의미 | 본 구현 흡수 (파일:라인) | 판정 |
|----|------|--------------------------|------|
| EC-1 | 백업 retention | F-N1-a 동일 | PASS |
| EC-2 | grep .git/ 제외 | verify_all.sh:66, 72 + post_check.sh:41, 48 (`--exclude-dir=.git --exclude-dir=node_modules`) | PASS |
| EC-3 | 상위 경로 잔존 | pre_check.sh:97–113 (baseline) + verify_all.sh:153–182 (AC-N1-8 + 자동 무효화) | PASS |
| EC-4 | remote 타이밍 (GitHub rename 전 404) | rename_n1.sh phase 분리 + 인계 시그널 1 (L154–179) | PASS |
| EC-5 | 폴더 mv 후 env (JONEFLOW_ROOT → JONEFLOW_ROOT) | rename_n1.sh:242 (shell rc 안내) | PASS |
| EC-6 | reflog/stale lock | pre_check.sh:60–72 (stale lock 사후 검증). reflog gc는 S2로 의도적 미실행 | PASS |
| EC-7 | force push 직전 dry check | rename_n1.sh:201–210 (5.5단계) + verify_all.sh:128–135 (_ac_n1_6) | PASS |
| EC-8 | CI/Actions | design Sec.7.3에서 `.github/workflows/ci.yml` 하드코딩 0건 확인. 본 구현 추가 작업 없음 (정합) | PASS |
| EC-9 | APFS 단일 mv | F-N1-f 동일 | PASS |
| EC-10 | 테스트 하드코딩 | verify_all.sh:137–151 (_ac_n1_7) — bundle1 + verbatim 2 파일 사후 검증 | PASS |

10/10 흡수 확인.

---

## Sec. 6. S1~S5 안전 제약 흡수 cross-ref

| S | 제약 | 흡수 위치 (파일:라인) | 객관 검증 명령 + 결과 |
|---|------|----------------------|----------------------|
| **S1** | expressions.txt = 3 매핑, # 주석/빈줄/BOM 금지 | expressions.txt 전체 (3 라인), pre_check.sh:81–95 (사전 검증 3중: 매핑 / 주석 / 총 라인) | `wc -l` = 3, `grep -c '^#'` = 0, `grep -cE '^[A-Za-z]+==>[A-Za-z]+$'` = 3 |
| **S2** | post_check.sh 정리 명령 일체 제거 | post_check.sh:10–15 (의도 명시), 23 (책임 축소), 75–79 (refs/original 안내만) | `grep -nE '^[[:space:]]*(git reflog expire\|git gc --prune\|rm -rf [^[:space:]]*refs/original\|git update-ref -d)' post_check.sh` = 0 hits (실행 라인) |
| **S3** | sh 파일 secret-redaction 안전 (REMOVED 0, shebang 0x23) | 전체 4 sh 파일 | `head -c 1 scripts/v0.6.1/*.sh \| od -An -c` → `#` 4건. `grep -rln 'REMOVED' scripts/v0.6.1/` = 0 hits |
| **S4** | filter-repo 실 실행 = dispatch 범위 외 | 본 review 명령 호출 모두 dry-run 또는 read | dry-run 호출 6건 모두 mutation 0 + 본 commit 차단 항목 0 |
| **S5** | rename_n1.sh 안전 가드 (--dry-run default + --apply + TTY confirm) | rename_n1.sh:33–47 (변수 default), 73–95 (`_confirm_apply`), 97–111 (`_print_recovery_info`) | `bash rename_n1.sh phase1 --apply </dev/null` → exit 2 + S5 메시지 확인 |

5/5 흡수 확인.

---

## Sec. 7. 객관 검증 명령 결과 (전체)

```
$ wc -l scripts/v0.6.1/expressions.txt
       3 scripts/v0.6.1/expressions.txt

$ grep -c '^#' scripts/v0.6.1/expressions.txt
0

$ grep -cE '^[A-Za-z]+==>[A-Za-z]+$' scripts/v0.6.1/expressions.txt
3

$ for f in scripts/v0.6.1/*.sh; do head -c 1 "$f" | od -An -c; done
   #
   #
   #
   #

$ grep -rln 'REMOVED' scripts/v0.6.1/
(no output, exit 1)

$ shellcheck scripts/v0.6.1/*.sh
(no output, exit 0)

$ bash -n scripts/v0.6.1/rename_n1.sh   # OK
$ sh -n scripts/v0.6.1/pre_check.sh     # OK
$ sh -n scripts/v0.6.1/post_check.sh    # OK
$ sh -n scripts/v0.6.1/verify_all.sh    # OK

$ grep -nE '^[[:space:]]*(git reflog expire|git gc --prune|rm -rf [^[:space:]]*refs/original|git update-ref -d)' scripts/v0.6.1/post_check.sh
(no output)

$ grep -nE 'eval|sh -c "\$' scripts/v0.6.1/*.sh
(no output)

$ grep -nE 'chmod|chown|rm -rf' scripts/v0.6.1/*.sh
scripts/v0.6.1/post_check.sh:11:#   - git reflog expire / git gc --prune / rm -rf .git/refs/original / git update-ref -d 류 금지
(주석 라인 1건만, 실행 라인 0)

$ bash scripts/v0.6.1/rename_n1.sh phase1 --apply </dev/null; echo "exit=$?"
==========================================================
  Phase 1 시작 - 0~3.5단계 + verify phase1 (APPLY=1)
==========================================================
rename_n1.sh: 비-TTY 환경에서 --apply 사용 시 --yes 명시 필요 (S5 안전 가드)
exit=2

$ bash scripts/v0.6.1/rename_n1.sh phase2 --apply </dev/null; echo "exit=$?"
==========================================================
  Phase 2 시작 - 5~5.5단계 + verify phase2 (APPLY=1)
==========================================================
rename_n1.sh: 비-TTY 환경에서 --apply 사용 시 --yes 명시 필요 (S5 안전 가드)
exit=2
```

---

## Sec. 8. Findings

### Sec. 8.1 Critical (0)

없음.

### Sec. 8.2 Major (0)

없음.

### Sec. 8.3 Minor (2)

#### Minor-1 — phase1 default dry-run이 working tree dirty 시 fail-closed 종료

**위치:** rename_n1.sh:121 → pre_check.sh:55–58
**관찰:** 본 리뷰 시점 worktree에 untracked/modified 파일 3종(scripts/v0.6.1/ + docs/01_brainstorm_v0.6.2/brainstorm.md + scripts/watch_v061_rebuild.sh)이 있어 phase1 default dry-run 호출이 pre_check.sh L55–58에서 즉시 fail-closed exit 1.
**평가:** 의도된 설계 (실 환경 검증 수행). 차단 사항 아님. **단, 운영자가 phase1 default dry-run으로 사전 검증을 시도할 때 working tree clean 상태가 필요하다는 점 인지 필요.**
**권장:** Stage 11/12 진입 직전 `git status` clean 확보. 본 리뷰 commit 직후 본 리뷰 산출물 + scripts/v0.6.1/ 5건을 commit하면 dirty 항목이 줄어든다 (untracked → committed).

#### Minor-2 — `_run` wrapper의 multi-line backslash 호출 가독성

**위치:** rename_n1.sh:52–60 + 128–131
**관찰:** `_run` wrapper가 dry-run 모드에서 `printf '  [DRY] %s\n' "$*"`로 echo만 한다. L128 `_run git filter-repo \` 처럼 multi-line backslash로 호출되면 `"$*"`이 단일 라인 합치기로 출력되므로 읽기 불편. 그러나 인자 전개는 정확 (검증됨).
**평가:** 동작 정확. 가독성 개선은 선택. 차단 사항 아님.
**권장:** 사후 cleanup에서 `printf '  [DRY] git filter-repo --replace-text %s --preserve-commit-encoding --force\n' "$EXPR_FILE"`로 명시 가능. 본 dispatch에서는 손대지 않는다 (운영자 지시 외 본체 sh 미수정).

### Sec. 8.4 Info (3)

#### Info-1 — phase3 호출은 운영자 작업 후 별도 호출

**위치:** rename_n1.sh phase3 분기 부재 + verify_all.sh phase3 / `all` 분기 보유 (L209–210)
**관찰:** rename_n1.sh는 phase1/phase2만 진입점. phase3는 폴더 mv 후 새 폴더(`jOneFlow`)에서 운영자가 `sh scripts/v0.6.1/verify_all.sh phase3` 별도 호출 — design Sec.4 8단계 후 inline 명령이 rename_n1.sh phase2 인계 시그널 L237–239에 명시됨.
**평가:** 정합. design Sec.5.2 인계 2 정책 일치.

#### Info-2 — Q5-2 자동 무효화 로직의 견고성

**위치:** verify_all.sh:168–180
**관찰:** AC-N1-8에서 `Jonelab_Platform/.claude/settings.local.json` 1건만 허용하는 자동 무효화 분기. `grep -cvF "$_expected_only"` 사용 — settings.local.json 외 추가 hits 발생 시 정확히 fail.
**평가:** 견고. design Sec.10 AC-N1-8 통과 조건 ("0 hits 또는 명시적 잔존 위치 1건") 일치.

#### Info-3 — 운영자 인계 시그널 메시지의 명료함

**위치:** rename_n1.sh:156–179, 222–244
**관찰:** Phase 1 / Phase 2 종료 후 운영자가 다음에 무엇을 해야 하는지 단계 번호 + 명령 + 주의사항 모두 한 화면에 명시. Phase 1은 GitHub rename + phase2 호출, Phase 2는 force push + 폴더 mv + phase3 verify까지 안내.
**평가:** 운영자 mental load 최소화. CLAUDE.md "수동 지시 영역 행동 규약" 1번(운영자 수작업 최소화) 부합.

---

## Sec. 9. 사고 회고 cross-ref (재확인)

| 사고 직접 원인 | 본 구현 차단 메커니즘 | 검증 명령 결과 |
|--------------|---------------------|---------------|
| expressions.txt 단독 `#` 라인 → `***REMOVED***` 마스킹 | S1: expressions.txt 3 라인만 + pre_check.sh L83–95 사전 3중 검증 | `wc -l` = 3, `grep -c '^#'` = 0, 매핑 정규식 매치 3 |
| post_check.sh reflog gc → 백업 영구 삭제 | S2: post_check.sh 정리 명령 일체 부재 + 의도 명시 주석 | `grep -nE '...' post_check.sh` 실행 라인 0 hits |
| 사고 후 모든 `#` 손상 → 코드 전체 오염 | S3: 모든 sh 파일 첫 바이트 `#` + REMOVED 토큰 0 | `head -c 1` → `#` 4건, `grep -rln 'REMOVED'` = 0 |
| 단일 명령 실행 시 의도치 않은 mutation | S5: --dry-run default + --apply + TTY confirm + --yes 의무 | dry-run 호출 6건 모두 mutation 0 + 비-TTY --apply → exit 2 |

사고 직접 원인 4건 모두 코드 차원 차단 확인.

---

## Sec. 10. 결론 + Stage 11/12 진입 가능성

### 10.1 Verdict 근거

- R1~R9 모두 PASS 또는 PASS_WITH_NOTE (R9의 note는 의도된 설계 동작)
- F-N1-a~h 8/8 흡수
- EC-1~10 10/10 흡수
- AC-N1-1~8 8/8 측정 가능 + verify_all.sh phase 분배 정합
- S1~S5 안전 제약 5/5 흡수 + 사고 직접 원인 4건 코드 차원 차단
- shellcheck 0 error / bash -n / sh -n 0 syntax error
- 보안: eval 0, shell injection 0, secret 노출 0, REMOVED 토큰 0, 백업 보존 정책 일관
- dry-run mutation 0 (객관 검증)

### 10.2 Stage 11/12 (filter-repo 실 실행) 진입 가능 여부

**가능.** 단 진입 직전 운영자 체크리스트:

1. **Working tree clean 확보** (Minor-1) — `git status --porcelain` = empty. 본 리뷰 commit + scripts/v0.6.1/ 5건 commit 후 추가 untracked 정리.
2. **GitHub Settings 사전 확인** — Repository name 입력 권한 + branch protection 정책 확인 (rename_n1.sh phase2 후 force push 전).
3. **모든 IDE / 추가 tmux claude 세션 종료** (F-N1-b) — pre_check.sh L128–132 안내 따름.
4. **filter-repo 설치 확인** — 본 환경 `/opt/homebrew/bin/git-filter-repo` 존재 검증됨 (pre_check.sh dry-run 출력에서 확인).
5. **Q5-1 / Q5-2 / Q5-3 default A 수용 확인** — design Sec.8 / Sec.10 AC-N1-8 통과 조건.

### 10.3 권장 follow-up

| 우선순위 | 항목 | 트리거 |
|---------|------|--------|
| **HIGH** | 운영자 `/codex:review` 사후 검증 (본 self-review 보완) | Stage 11/12 진입 전 또는 직후 |
| MED | 본 리뷰 commit + scripts/v0.6.1/ 5건 commit | 본 리뷰 작성 직후 (`scripts/git_checkpoint.sh` one-liner) |
| MED | filter-repo 실 실행 시 운영자가 별도 터미널에서 phase1 default dry-run으로 사전 검증 | Stage 11 전 |
| LOW | rename_n1.sh `_run` wrapper 가독성 cleanup (Minor-2) | v0.6.1 release 후 cleanup PR |
| LOW | post_check.sh의 `cleanup_after_v061.sh` 분리본 작성 (S2 정책상 별도 트리거) | v0.6.1 release 완료 + 운영자 판단 시 |

---

## Sec. 11. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v1 — Stage 9 code_review (Claude Opus self-review) | scripts/v0.6.1/ 5건 + 보조 산출물 4건 검토. R1~R9 평가 + AC/F/EC/S 매트릭스 + 사고 회고 cross-ref + Findings (Critical 0 / Major 0 / Minor 2 / Info 3). Verdict APPROVED_WITH_MINOR. Stage 11/12 진입 가능. |
