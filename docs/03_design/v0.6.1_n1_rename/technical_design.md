---
version: v0.6.1
stage: 5 (technical_design)
date: 2026-04-26
mode: Standard
session: Stage 5 (Cowork 위임 → Code 브릿지 → Opus 직접 작성)
upstream:
  - docs/01_brainstorm_v0.6.1/brainstorm.md (Stage 1, 세션 23)
  - docs/02_planning_v0.6.1/plan_draft.md (Stage 2, drafter 준혁)
  - docs/02_planning_v0.6.1/plan_review.md (Stage 3, reviewer 민지)
  - docs/02_planning_v0.6.1/plan_final.md (Stage 4, finalizer 태원, status: approved)
constraints_absorbed:
  - F-N1-a (백업 영구 — 운영자 변경사항 1)
  - F-N1-b (IDE/worktree 종료)
  - F-N1-c (remote 재등록 = GitHub rename 후)
  - F-N1-d (폴더 mv 절대경로 fallback)
  - F-N1-e (case-sensitive 3종)
  - F-N1-f (APFS case-insensitive 단일 mv)
  - F-N1-g (reflog + stale lock — 사후 검증만, 운영자 변경사항 2)
  - F-N1-h (release.sh 하드코딩)
operator_changes:
  - 백업 브랜치 보존 = 영구 (1주 후 삭제 정책 폐기)
  - stale lock 정리 = 운영자 로컬 완료 (사전 의무 → 사후 검증으로 약화)
downstream: Stage 8 구현 (단일 trail D1→D5)
---

***REMOVED*** v0.6.1 N1 — jOneFlow → jOneFlow 명칭 변경 + git history 재작성 (technical_design)

> **상위:** `docs/02_planning_v0.6.1/plan_final.md` (Stage 4, 운영자 승인 완료)
> **하위:** Stage 8 구현. 본 design을 단독 입력으로 Stage 8 실행 스크립트 작성 가능해야 함.
> **범위:** D1 git filter-repo 실행 명세 / D2 검증 스크립트 명세 (AC-N1-1~8) / D3 8단계 실행 순서 / D4 자동·수동 영역 분리 / D5 실패 시나리오 + 복구 / D6 F-N1-* 흡수 cross-reference / D7 Q5-* 미해결 질문.

---

***REMOVED******REMOVED*** Sec. 0. 운영자 변경사항 흡수 (Stage 4 → Stage 5 인계)

운영자 승인 시 Stage 4 plan_final 대비 두 가지 변경 명시:

***REMOVED******REMOVED******REMOVED*** Change-1: 백업 브랜치 보존 = 영구

| 항목 | plan_final 안 | Stage 5 확정 |
|------|--------------|-------------|
| 보존 기간 | 1주일 후 삭제 | **영구** |
| 9단계 | `git branch -D backup-pre-v0.6.1-rename` | **삭제** (단계 자체 제거) |
| 총 단계 수 | 9 (0–9) → **8** (0–8) | 0~8단계로 축소 |

**근거:** force push history는 GitHub 측에서 reflog 일정 후 GC됨. 로컬 백업 브랜치는 디스크 비용 미미하고, 향후 history 비교/감사/사고 복구 가치가 retention 비용보다 높음. 운영자 결정.

***REMOVED******REMOVED******REMOVED*** Change-2: stale lock 사전 정리 = 운영자 완료

| 항목 | plan_final 안 | Stage 5 확정 |
|------|--------------|-------------|
| 0단계 stale lock 처리 | Claude가 `rm .git/*.lock.stale*` 실행 (사전 의무) | **사후 검증만** (`ls .git/*.lock.stale* 2>/dev/null \| wc -l` = 0 확인) |
| 운영자 사전 작업 | (없음) | **완료** (`.git/*.lock.stale*` 0건 — 본 design 작성 시점 확인) |
| R0 위험 등급 | 중 (사전 정리 누락) | 낮 (사후 검증 누락) |

**근거:** filter-repo가 lock 파일 존재 시 거부. 운영자가 직접 정리하면 환경 책임이 명확. Claude는 "정리되었는지" 확인만 수행하여 책임 경계 단순화.

***REMOVED******REMOVED******REMOVED*** Cross-reference

본 두 변경은 Sec.4 (D3 8단계) + Sec.5 (D4) + Sec.6 (D5 실패 시나리오) + Sec.7 (D6 F-N1-a/g 흡수) + Sec.10 (AC 표) 모두에 반영됨.

---

***REMOVED******REMOVED*** Sec. 1. 아키텍처 개요

```
┌──────────────────────────────────────────────────────────────────────┐
│  운영자 수동 영역 3지점 (Sec.5 D4 상세):                              │
│   (1) 사전:    .git/*.lock.stale* 정리 (Change-2 — 완료)             │
│   (2) 6~8단계: GitHub repo rename / git push --force / 폴더 mv         │
│   (3) Q5-* 결정: 의미 손상 정책 / origin URL 형태                     │
└──────────────────────────────────────────────────────────────────────┘
            │                                  ▲
            ▼                                  │
  ┌─────────────────┐                ┌────────────────────┐
  │ Stage 5 design  │  → Stage 8 →   │ scripts/v0.6.1/    │
  │  (본 문서)      │     구현       │   rename_n1.sh     │ ← 오케스트레이터 자동
  │                 │                │   verify_grep.sh   │   (1~5.5단계)
  │ D1 filter-repo  │                │   verify_msg.sh    │
  │ D2 검증 스크립트│                │   verify_tests.sh  │
  │ D3 8단계        │                │   pre_check.sh     │
  │ D4 자동/수동    │                │   post_check.sh    │
  │ D5 복구         │                └────────────────────┘
  │ D6 F-N1-* 흡수  │                          │
  │ D7 Q5-*         │                          ▼
  └─────────────────┘                ┌────────────────────┐
                                     │ git filter-repo    │
                                     │  --replace-text    │
                                     │  expressions.txt   │
                                     └────────────────────┘
```

***REMOVED******REMOVED******REMOVED*** 1.1 핵심 설계 원칙 (3축)

| 축 | 의미 | 본 설계 구현 |
|----|------|-------------|
| **단일 명령 치환** | filter-repo 한 번 실행으로 3종 치환(메시지+파일내용) 동시 처리. 멱등성 확보. | `--replace-text expressions.txt` 사용. expressions.txt에 3 패턴 case-sensitive 매핑. filename-callback 불요(git ls-files에 jOneFlow 경로 0건 확인). |
| **fail-closed** | 잔존 hits 발견 / 테스트 실패 / dry check 실패 시 **즉시 중단** + 운영자 호출. 자동 복구 시도 금지. | D5 실패 시나리오에서 모든 분기가 `exit ≠ 0` + 안내 메시지 + 백업 브랜치로 복구 경로 명시. |
| **자동/수동 인계 시그널** | 오케스트레이터(Claude)와 운영자 사이 인계 지점에 명시적 게이트. | Sec.5 D4 인계 시그널 표 — 각 인계마다 "Claude 종료 신호" + "운영자 시작 트리거" 정의. |

***REMOVED******REMOVED******REMOVED*** 1.2 v0.6.0과 일관성

- POSIX 친화 + `set -eu` + temp file → mv 패턴 (v0.6 M1~M4 동일).
- 한국어 에러 메시지 + 라인 번호/재현 명령 포함.
- shellcheck CLEAN.
- 단, `JONEFLOW_ROOT` env로 격리되는 단위 테스트 패턴은 **본 N1에는 적용 안 함** — 본 작업은 라이브 repo 일회성 마이그레이션이라 격리 fixture 불필요. 전후 grep 비교가 검증 방식.

---

***REMOVED******REMOVED*** Sec. 2. D1 — git filter-repo 실행 명세

***REMOVED******REMOVED******REMOVED*** 2.1 도구 선택 근거

| 후보 | 장점 | 단점 | 선택 |
|------|------|------|------|
| `git filter-repo` | git 공식 권장, 빠름, 안전, 멀티 콜백 | 별도 설치 필요 | **O** |
| `git filter-branch` | git 내장 | 느림, deprecation, 위험 | X |
| `BFG Repo-Cleaner` | 빠름 | 메시지 치환 불완전, JVM 의존 | X |

→ `git filter-repo` 채택 (brainstorm Sec.4 확정).

***REMOVED******REMOVED******REMOVED*** 2.2 설치 (사전 조건)

```sh
***REMOVED*** macOS — Homebrew (권장):
brew install git-filter-repo

***REMOVED*** 또는 Python pip:
python3 -m pip install --user git-filter-repo

***REMOVED*** 검증:
which git-filter-repo  ***REMOVED*** 또는: git filter-repo --version
```

**현재 상태(2026-04-26):** 미설치 확인 (`which git-filter-repo` → not found). Stage 8 진입 전 운영자 또는 Claude가 위 명령으로 설치. brew formula `git-filter-repo` stable 2.47.0 (bottled) 가용 확인.

***REMOVED******REMOVED******REMOVED*** 2.3 expressions.txt 매핑 파일

**위치:** `scripts/v0.6.1/expressions.txt` (Stage 8에서 생성).

**형식:** `pattern==>replacement` per line, case-sensitive (filter-repo 기본 동작):

```
jOneFlow==>jOneFlow
joneflow==>joneflow
JONEFLOW==>JONEFLOW
```

**제약:**
- 한 줄 한 매핑.
- `==>` 구분자.
- 좌변/우변 모두 literal (regex 아님 — `--replace-text`는 기본 literal). regex 필요 시 `regex:` prefix 사용 가능하나 본 작업은 literal로 충분.
- 빈 줄/주석(`***REMOVED***`) 허용.

**대소문자 변형 정책 (F-N1-e 흡수):**
- 3종 한정 (`jOneFlow`, `joneflow`, `JONEFLOW`).
- `JDevFlow` / `jdevFlow` 등 비정상 변형은 **현재 코드베이스에 부재** 확인 (`git grep -E 'JDevFlow|jdevFlow'` = 0). 향후 등장 시 별도 처리.

***REMOVED******REMOVED******REMOVED*** 2.4 단일 명령 (3종 치환 동시)

`--replace-text`는 **파일 내용**과 **커밋 메시지** 모두 치환한다(filter-repo 공식 동작). 파일명/경로 치환은 별도 — 본 작업은 git ls-files에 `jOneFlow` 경로 0건이라 filename-callback 불요.

```sh
cd /Users/geenya/projects/Jonelab_Platform/jOneFlow

git filter-repo \
    --replace-text scripts/v0.6.1/expressions.txt \
    --force
```

**옵션 설명:**

| 옵션 | 의미 | 본 작업 채택 여부 |
|------|------|------------------|
| `--replace-text <file>` | BLOB 내용 + 커밋 메시지 literal 치환 (3 패턴 모두) | ✅ |
| `--force` | non-fresh clone에서도 실행 허용. 본 repo는 단일 clone이므로 필요 | ✅ |
| `--filename-callback` | 파일명/경로 치환 (Python 콜백) | ❌ (불요 — `git ls-files | grep -i joneflow` = 0) |
| `--message-callback` | 커밋 메시지 별도 콜백 | ❌ (불요 — `--replace-text`가 메시지도 처리) |
| `--preserve-commit-encoding` | 커밋 메시지 인코딩 보존 | ✅ (한글 메시지 안전 보장) |
| `--prune-empty` | 치환 후 빈 커밋 제거 | ❌ (본 작업은 빈 커밋 발생 케이스 없음 — 텍스트 치환만이라) |

**최종 명령(Stage 8 인용):**
```sh
git filter-repo \
    --replace-text scripts/v0.6.1/expressions.txt \
    --preserve-commit-encoding \
    --force
```

***REMOVED******REMOVED******REMOVED*** 2.5 멱등성 / 재실행 가능 여부

**filter-repo의 fresh clone 요구:** filter-repo는 기본적으로 한 번만 실행하도록 설계됨. `--force` 없이 재실행 시 "already filtered" 거부. **재실행이 필요하면:**

1. 백업 브랜치(`backup-pre-v0.6.1-rename`)에서 새 clone 또는 reset
2. expressions.txt 수정 후 `--force` 재실행

**부분 실패 복구:** filter-repo가 중간에 실패하면 (디스크 full / 권한 등) repo 상태가 일관되지 않을 수 있음 → **백업 브랜치에서 reset --hard 후 재시도** (Sec.6 D5 R2 참조).

***REMOVED******REMOVED******REMOVED*** 2.6 부수 효과

- `.git/refs/original/` 자동 생성 (filter-repo가 원본 refs 보존). 이후 정리 (post-check 단계).
- `origin` remote 자동 제거 (filter-repo 보안 정책 — 의도하지 않은 push 방지). → 5단계 재등록 필수.
- `git reflog` 신규 항목 추가 (이전 commit SHA 변경됨).
- 모든 commit SHA 변경 (history 재작성이므로 당연).

---

***REMOVED******REMOVED*** Sec. 3. D2 — 검증 스크립트 명세 (AC-N1-1 ~ AC-N1-8)

각 AC는 별도 검증 함수/스크립트로 분리. 단일 진입점 `scripts/v0.6.1/verify_all.sh`가 8개 AC를 순차 실행하며 첫 실패 시 중단(fail-closed).

***REMOVED******REMOVED******REMOVED*** 3.1 AC 측정 명령 (final 합의)

| AC | 측정 시점 | 명령 | 통과 기준 |
|----|----------|------|----------|
| **AC-N1-1** | 3단계 직후 | `grep -rn 'jOneFlow\|joneflow\|JONEFLOW' . --exclude-dir=.git --exclude-dir=node_modules` | 0 hits (whitelist 예외 후) |
| **AC-N1-2** | 4단계 직후 | `sh scripts/run_tests.sh` | exit 0 + 모든 PASS 라인 |
| **AC-N1-3** | 2단계 직후 | `git log --all --pretty=format:'%H %s' \| grep -E 'jOneFlow\|joneflow\|JONEFLOW'` | 0 hits |
| **AC-N1-4** | 5단계 직후 | `git remote -v` | `origin` 표시 + URL에 `jOneFlow` 포함 |
| **AC-N1-5** | 7단계 직후 | `curl -fsSL https://github.com/Hyoungjin-Lee/jOneFlow -o /dev/null` | exit 0 (HTTP 200) |
| **AC-N1-6** | 5.5단계 (5단계 직후) | `git ls-remote origin` | exit 0 + ref 출력 |
| **AC-N1-7** | Stage 5 (본 문서) + 4단계 직후 | `git grep -nE 'jOneFlow' tests/bundle1/run_bundle1.sh tests/v0.6/test_init_project_verbatim.sh` | 각 파일에서 ≥1 hit (치환 확인) |
| **AC-N1-8** | Stage 5 (본 문서) + 8단계 후 | `grep -rnE 'jOneFlow\|joneflow\|JONEFLOW' /Users/geenya/projects/Jonelab_Platform/ --exclude-dir=jOneFlow --exclude-dir=jOneFlow --include='*.md' --include='*.sh' --include='*.json'` | 0 hits 또는 위치 명시 |

***REMOVED******REMOVED******REMOVED*** 3.2 잔존 grep 예외 whitelist (AC-N1-1 정밀 정의)

**원칙:** 0 hits.

**예외 (자동 제외):**
1. `.git/` 디렉토리 — `--exclude-dir=.git`. 내부 객체/refs는 정의상 grep 대상 아님.
2. **백업 브랜치 (`backup-pre-v0.6.1-rename`)** — 체크아웃되지 않은 브랜치는 worktree에 없음 → grep -r은 worktree만 스캔하므로 자동 제외. **명시 주석으로 의도 표기** (Stage 8 verify_grep.sh 주석에).
3. `node_modules/`, `dist/`, `build/` — 본 repo에 부재하지만 보수적으로 제외 옵션 추가.

**의도적 예외 (Q5-1 운영자 결정 후 적용):**
- **기획 산출물 (docs/01_brainstorm_v0.6.1/, docs/02_planning_v0.6.1/, docs/03_design/v0.6.1_n1_rename/)** — 본 N1 작업의 정본 입력 문서들. 본문에 `jOneFlow → jOneFlow` 형태의 인용 437 hits 중 92 hits가 이 문서들 내. **filter-repo가 자동 치환하면 표의 "Before" 컬럼이 의미 손상.**
  - 옵션 A (default 권장): **치환 허용** — 작업 후 archive 성격이라 의미 손상 OK. v0.6 brainstorm verbatim 보존 정책(F-n1/n2)은 init/switch_team 코드의 verbatim에 한정이고 v0.6.1 기획 산출물은 verbatim 대상 아님.
  - 옵션 B: filter-repo `--paths-from-file` 또는 `--invert-paths`로 해당 디렉토리 제외 → 사후 의도 손상 패치.
  - 옵션 C: 사후 수동 복원.
  - **Q5-1 (미해결, Sec.8 D7 참조).** 운영자 결정 전까지 옵션 A 가정.

***REMOVED******REMOVED******REMOVED*** 3.3 검증 스크립트 구조

**`scripts/v0.6.1/verify_all.sh` 골격 (Stage 8 작성):**

```sh
***REMOVED***!/bin/sh
***REMOVED*** verify_all.sh — AC-N1-1~8 순차 검증. 첫 실패 시 중단 (fail-closed).

set -eu

ROOT="${ROOT:-$(pwd)}"
RESULTS="${RESULTS:-$ROOT/scripts/v0.6.1/verify_results.log}"
mkdir -p "$(dirname "$RESULTS")"
: > "$RESULTS"   ***REMOVED*** truncate

_pass() { printf 'PASS  %s\n' "$1" | tee -a "$RESULTS"; }
_fail() { printf 'FAIL  %s\n  → %s\n' "$1" "$2" | tee -a "$RESULTS" >&2; exit 1; }

***REMOVED*** AC-N1-1: 잔존 grep 0 hits
hits=$(grep -rnE 'jOneFlow|joneflow|JONEFLOW' "$ROOT" \
         --exclude-dir=.git --exclude-dir=node_modules \
         2>/dev/null | wc -l | tr -d ' ')
[ "$hits" = "0" ] && _pass "AC-N1-1 (grep 0 hits)" \
                 || _fail "AC-N1-1 (grep $hits hits)" "위치는 grep 출력 참조"

***REMOVED*** AC-N1-3: commit message 잔존 0건 (filter-repo 직후 측정)
msg_hits=$(git log --all --pretty=format:'%H %s' \
           | grep -cE 'jOneFlow|joneflow|JONEFLOW' || true)
[ "$msg_hits" = "0" ] && _pass "AC-N1-3 (commit msg 0 hits)" \
                      || _fail "AC-N1-3 (commit msg $msg_hits hits)" \
                               "git log --all --grep 결과 확인"

***REMOVED*** AC-N1-2: 테스트 PASS
sh "$ROOT/scripts/run_tests.sh" \
   && _pass "AC-N1-2 (run_tests.sh 전체 PASS)" \
   || _fail "AC-N1-2" "run_tests.sh 출력 확인 — 하드코딩 치환 누락 가능성"

***REMOVED*** AC-N1-7: 테스트 하드코딩 치환 확인
for f in tests/bundle1/run_bundle1.sh tests/v0.6/test_init_project_verbatim.sh; do
    if git grep -qE 'jOneFlow' "$f"; then
        _pass "AC-N1-7 ($f → jOneFlow 치환됨)"
    else
        _fail "AC-N1-7 ($f)" "filter-repo가 이 파일을 치환하지 않음"
    fi
done

***REMOVED*** AC-N1-4: remote URL
git remote -v | grep -q 'jOneFlow' \
   && _pass "AC-N1-4 (remote URL = jOneFlow)" \
   || _fail "AC-N1-4" "git remote add origin <새 URL> 실행 필요"

***REMOVED*** AC-N1-6: ls-remote dry check
git ls-remote origin > /dev/null 2>&1 \
   && _pass "AC-N1-6 (ls-remote dry check OK)" \
   || _fail "AC-N1-6" "원격 접근 실패 — GitHub rename 미완료 가능"

***REMOVED*** AC-N1-5: HTTP 접근
curl -fsSL https://github.com/Hyoungjin-Lee/jOneFlow -o /dev/null \
   && _pass "AC-N1-5 (GitHub URL HTTP 200)" \
   || _fail "AC-N1-5" "Hyoungjin-Lee/jOneFlow 접근 불가 — rename 또는 권한 확인"

***REMOVED*** AC-N1-8: 상위 경로 grep
upper_hits=$(grep -rnE 'jOneFlow|joneflow|JONEFLOW' \
              /Users/geenya/projects/Jonelab_Platform/ \
              --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git \
              --include='*.md' --include='*.sh' --include='*.json' \
              2>/dev/null | wc -l | tr -d ' ')
[ "$upper_hits" = "0" ] && _pass "AC-N1-8 (상위 경로 0 hits)" \
                        || _fail "AC-N1-8 ($upper_hits hits)" \
                                 "위치는 grep 출력 참조 — 수동 패치"

printf '\n=== AC verify: 모든 AC PASS ===\n' | tee -a "$RESULTS"
exit 0
```

***REMOVED******REMOVED******REMOVED*** 3.4 사전 점검 스크립트 `scripts/v0.6.1/pre_check.sh`

filter-repo 실행 전 환경 검증.

```sh
***REMOVED***!/bin/sh
set -eu

***REMOVED*** 1. git filter-repo 설치 확인
which git-filter-repo > /dev/null 2>&1 \
   || { echo "FAIL: git-filter-repo 미설치. brew install git-filter-repo" >&2; exit 1; }

***REMOVED*** 2. main 브랜치 + working tree clean 확인
[ "$(git rev-parse --abbrev-ref HEAD)" = "main" ] \
   || { echo "FAIL: 현재 브랜치가 main이 아님" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] \
   || { echo "FAIL: working tree dirty — commit 또는 stash 필요" >&2; exit 1; }

***REMOVED*** 3. 사후 검증: stale lock 0건 (Change-2 — 운영자 정리 완료 확인)
lock_hits=$(ls .git/*.lock.stale* 2>/dev/null | wc -l | tr -d ' ')
[ "$lock_hits" = "0" ] \
   || { echo "FAIL: .git/*.lock.stale* $lock_hits 건 잔존. 운영자 정리 필요" >&2; exit 1; }

***REMOVED*** 4. 백업 브랜치 부재 확인 (이전 시도 흔적 없음)
git branch -a | grep -q 'backup-pre-v0.6.1-rename' \
   && { echo "FAIL: 백업 브랜치 이미 존재 — 이전 시도 흔적. 정리 후 재시도" >&2; exit 1; }
true   ***REMOVED*** 부재이면 OK

***REMOVED*** 5. expressions.txt 존재 확인
[ -f scripts/v0.6.1/expressions.txt ] \
   || { echo "FAIL: scripts/v0.6.1/expressions.txt 부재" >&2; exit 1; }

***REMOVED*** 6. 상위 경로 사전 grep (AC-N1-8 baseline)
upper_baseline=$(grep -rnE 'jOneFlow|joneflow|JONEFLOW' \
                  /Users/geenya/projects/Jonelab_Platform/ \
                  --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git \
                  --include='*.md' --include='*.sh' --include='*.json' \
                  2>/dev/null | wc -l | tr -d ' ')
echo "INFO: 상위 경로 baseline grep hits = $upper_baseline (AC-N1-8 사후 비교)"
echo "$upper_baseline" > /tmp/v061_upper_baseline.txt

***REMOVED*** 7. 하드코딩 위치 사전 식별 (정보 출력만)
echo "INFO: 하드코딩 위치 사전 확인:"
git grep -nE '\bjOneFlow\b|\bjoneflow\b|\bJONEFLOW\b' \
    tests/bundle1/run_bundle1.sh \
    tests/v0.6/test_init_project_verbatim.sh \
    scripts/release.sh \
    scripts/watch_v061_plan.sh \
    scripts/watch_v061_stage5.sh 2>/dev/null \
  | sed 's/^/  /'

echo "PASS: pre_check 완료"
```

***REMOVED******REMOVED******REMOVED*** 3.5 사후 정리 스크립트 `scripts/v0.6.1/post_check.sh`

filter-repo 실행 후 정리 + 검증.

```sh
***REMOVED***!/bin/sh
set -eu

***REMOVED*** 1. reflog + refs/original 정리 (F-N1-g)
git reflog expire --expire=now --all
git gc --prune=now --aggressive

***REMOVED*** 2. refs/original 자동 제거 확인 (filter-repo 부산물)
[ ! -d .git/refs/original ] \
   || { echo "WARN: .git/refs/original 잔존. 수동 rm -rf 권장" >&2; }

***REMOVED*** 3. 백업 브랜치 보존 확인 (Change-1 — 영구)
git branch -a | grep -q 'backup-pre-v0.6.1-rename' \
   && echo "PASS: 백업 브랜치 보존 (영구)" \
   || echo "WARN: 백업 브랜치 부재 — 1단계 누락 또는 삭제됨"

echo "PASS: post_check 완료"
```

---

***REMOVED******REMOVED*** Sec. 4. D3 — 8단계 실행 순서 (확정, 운영자 변경사항 반영)

***REMOVED******REMOVED******REMOVED*** 4.1 단계 표 (0~8단계)

운영자 Change-1 반영: 9단계 삭제. Change-2 반영: 0단계는 사후 검증만.

| 단계 | 액션 | 실행자 | 사전 조건 | 명령/입력 | 산출물/검증 | 실패 복구 |
|------|------|--------|-----------|----------|-------------|----------|
| **0** | 사전 점검 (stale lock 사후 검증, filter-repo 설치 확인 등) | Claude | main + clean tree | `sh scripts/v0.6.1/pre_check.sh` | exit 0 + INFO 메시지 | stale lock 잔존 시 **운영자 호출** (사전 정리 책임) |
| **1** | 백업 브랜치 생성 | Claude | 0단계 PASS | `git branch backup-pre-v0.6.1-rename` | `git branch -a` 에 backup 표시 | 실패 시 즉시 중단, 운영자 호출 |
| **2** | filter-repo 실행 (3종 치환) | Claude | 1단계 완료 + IDE 종료 [F-N1-b] | `git filter-repo --replace-text scripts/v0.6.1/expressions.txt --preserve-commit-encoding --force` | filter-repo 로그 + commit SHA 전체 변경 | **`git reset --hard backup-pre-v0.6.1-rename`** (백업 브랜치에서 복구) → 원인 분석 후 재시도 |
| **3** | grep 검증 (AC-N1-1, AC-N1-7) | Claude | 2단계 완료 | `sh scripts/v0.6.1/verify_grep.sh` (verify_all.sh 일부) | 0 hits + 하드코딩 치환 확인 | 잔존 hits 위치 출력 → 수동 패치 또는 expressions.txt 보강 후 reset+재실행 |
| **3.5** | 커밋 메시지 검증 (AC-N1-3) | Claude | 3단계 완료 | `git log --all --pretty=format:'%s' \| grep -cE 'jOneFlow\|joneflow\|JONEFLOW'` | 0 hits | filter-repo가 메시지 치환 누락 — 옵션 점검 후 reset+재실행 |
| **4** | 테스트 재실행 (AC-N1-2) | Claude | 3.5단계 완료 | `sh scripts/run_tests.sh` | 전체 PASS | 실패 테스트 별 출력 확인 → 하드코딩 누락이면 expressions.txt 보강 후 reset+재실행 |
| **5** | Remote 재등록 [F-N1-c — 6단계 완료 후 위치] | Claude | **6단계 완료 확인 후** | `git remote add origin https://github.com/Hyoungjin-Lee/jOneFlow.git` (또는 SSH — Q5-3) | `git remote -v` 에 origin = jOneFlow URL | URL 오타 시 `git remote remove origin && set-url` 재실행 |
| **5.5** | ls-remote dry check (AC-N1-6, EC-7) | Claude | 5단계 완료 | `git ls-remote origin` | exit 0 + ref 출력 | exit ≠ 0 시 6단계 GitHub rename 미완 가능 — 운영자 재확인 |
| **6** | GitHub repo rename | **운영자** | 4단계 완료 (Claude 자동 영역 종료 시그널) | GitHub Settings → Repository name → `jOneFlow` | `https://github.com/Hyoungjin-Lee/jOneFlow` 접근 가능 | 권한 부족 시 운영자 재인증, 6단계 재시도 |
| **7** | force push (AC-N1-5) | **운영자** | 5.5단계 PASS + 6단계 완료 | `git push --force origin main` (백업 브랜치도 push 권장: `git push origin backup-pre-v0.6.1-rename`) | GitHub main history 재작성 + 백업 브랜치 원격 보존 | force push 거부 시 dry check 재실행, branch protection 확인 |
| **8** | 로컬 폴더 mv [F-N1-d, F-N1-f, EC-9] | **운영자** | 7단계 완료 + 모든 IDE/터미널/tmux 종료 + 폴더 정리 | `cd /Users/geenya/projects/Jonelab_Platform && mv jOneFlow jOneFlow` (단일 명령) | `cd jOneFlow && pwd` 정상 + 모든 절대경로 fallback 자동 무효화/갱신 | 파일 락 발견 시 모든 프로세스 종료 후 재시도. cp+rm 금지 [F-N1-f]. |

***REMOVED******REMOVED******REMOVED*** 4.2 단계 의존성 그래프

```
0 ──→ 1 ──→ 2 ──→ 3 ──→ 3.5 ──→ 4 ──┐
                                    │ (Claude 자동 영역 종료)
                                    ▼ (인계 시그널 — Sec.5 D4)
                                    6 ──→ (운영자 영역)
                                    │
                                    ▼
                                    5 ──→ 5.5 ──→ 7 ──→ 8
```

**핵심 인계:** 4단계 PASS 직후 Claude는 **명시적 인계 메시지**를 출력하고 **6단계 운영자 작업** 대기. 운영자가 6단계 완료 후 Claude에게 "GitHub rename 완료" 신호 전달 → 5/5.5단계 진행.

***REMOVED******REMOVED******REMOVED*** 4.3 변경된 단계 번호 (plan_final 대비)

| plan_final | Stage 5 design | 변경 사유 |
|-----------|---------------|----------|
| 0~9단계 (10단계) | 0~8단계 (9단계) | Change-1: 9단계 삭제 (백업 영구) |
| 0단계 = stale lock rm 실행 | 0단계 = stale lock 사후 검증만 | Change-2: 운영자 사전 정리 완료 |
| 5단계 = remote 재등록 (6단계 후) | 동일 (F-N1-c 유지) | 변경 없음 |

---

***REMOVED******REMOVED*** Sec. 5. D4 — 자동 / 수동 영역 분리 + 인계 시그널

***REMOVED******REMOVED******REMOVED*** 5.1 영역 분리 표

| 영역 | 단계 | 실행자 | 권한 요구 | 자동화 도구 |
|------|------|--------|----------|------------|
| **사전 (운영자)** | (사전) | 운영자 | 로컬 파일시스템 | `rm .git/*.lock.stale*` (이미 완료) |
| **자동 1차 (Claude)** | 0~4 | Claude 오케스트레이터 | git, filter-repo, grep, sh | `pre_check.sh` + `git filter-repo` + `verify_grep.sh` + `verify_msg.sh` + `run_tests.sh` |
| **운영자 1** | 6 | 운영자 | GitHub admin | GitHub Web UI |
| **자동 2차 (Claude)** | 5, 5.5 | Claude 오케스트레이터 | git remote, ls-remote | shell |
| **운영자 2** | 7, 8 | 운영자 | git push --force, OS mv | shell |

***REMOVED******REMOVED******REMOVED*** 5.2 인계 시그널 정의

자동/수동 경계마다 명확한 시그널 — 누락 시 race/단계 누락 위험.

***REMOVED******REMOVED******REMOVED******REMOVED*** 인계 1: Claude(0~4) → 운영자(6)

**Claude 종료 신호:**
```
✅ Stage 8 자동 영역 1차 완료 (단계 0~4 PASS).

다음 = 운영자 작업:
  6단계: GitHub Settings → Repository name → jOneFlow

완료 후 본 세션에 "GitHub rename 완료"라고 알려주시면
Claude가 5단계(remote 재등록) 자동 진행합니다.

백업 브랜치 = backup-pre-v0.6.1-rename (보존됨, 영구)
filter-repo refs/original 정리 완료
모든 grep/test PASS
```

**운영자 시작 트리거:** 운영자가 6단계 완료 후 채팅에 "GitHub rename 완료" 또는 동의어 → Claude가 5단계 자동 진행.

**시그널 파일 (선택):** `scripts/v0.6.1/.handoff_to_operator_1` 마커 파일 생성 (Claude 종료 시) + `scripts/v0.6.1/.handoff_to_claude_2` (운영자 완료 후 `touch`).

***REMOVED******REMOVED******REMOVED******REMOVED*** 인계 2: Claude(5, 5.5) → 운영자(7)

**Claude 종료 신호:**
```
✅ Stage 8 자동 영역 2차 완료 (단계 5, 5.5 PASS).

  remote URL: <표시>
  ls-remote dry check: PASS

다음 = 운영자 작업:
  7단계: git push --force origin main
  7단계 부수: git push origin backup-pre-v0.6.1-rename (백업 원격 보존)
  8단계: 모든 IDE/터미널/tmux 종료 후 mv jOneFlow jOneFlow

완료 후 운영자가 새 폴더에서 `git status` + `git log --oneline -5` 확인.
모든 정상이면 v0.6.1 N1 작업 완료.
```

**운영자 종료 신호:** 본 세션 종료 + 새 폴더(`jOneFlow/`)에서 다음 세션 시작.

***REMOVED******REMOVED******REMOVED*** 5.3 자동/수동 경계 의도 (왜 이렇게 나눴는가)

| 경계 | 자동(Claude) 이유 | 수동(운영자) 이유 |
|------|-----------------|------------------|
| 0~4 → 6 | 멱등 가능, 백업 브랜치로 복구 가능, 측정 객관 | GitHub admin 권한 (Claude 불가능) |
| 5 → 7 | URL 등록은 텍스트 작업, dry check는 자동 검증 | force push는 published history 영구 변경 (CLAUDE.md Sec.3 운영자 승인 필수) |
| 5.5 → 8 | (동) | 폴더 mv는 OS 환경 변경 + 모든 세션 종료 필요 (Claude 자기 세션 닫는 것 불가능) |

---

***REMOVED******REMOVED*** Sec. 6. D5 — 실패 시나리오 + 복구 (EC-1~10 흡수)

***REMOVED******REMOVED******REMOVED*** 6.1 시나리오 표

| ID | 시나리오 | 발생 단계 | 검출 방법 | 복구 절차 | 흡수 EC/F |
|----|---------|---------|----------|----------|----------|
| **R1** | filter-repo 부분 치환 실패 (디스크/권한/시그널) | 2 | filter-repo exit ≠ 0 또는 3단계 grep hits | `git reset --hard backup-pre-v0.6.1-rename` + 환경 점검 + 재시도 | EC-6, F-N1-g |
| **R2** | grep 잔존 hits 발견 | 3 | verify_grep.sh exit 1 | hits 위치 출력 → ① 자동 치환에 누락된 패턴이면 expressions.txt 보강 + reset + 재실행 ② 의도적 잔존(Q5-1)이면 whitelist에 추가 + 재측정 | EC-2, F-N1-e |
| **R3** | 커밋 메시지 잔존 | 3.5 | verify_msg.sh hits ≥ 1 | `--replace-text`가 메시지를 처리하므로 미발생 기대. 발생 시 reset + filter-repo 옵션 재검토 | GAP-N1-3b (review) |
| **R4** | 테스트 실패 (하드코딩 미치환) | 4 | run_tests.sh exit ≠ 0 | 실패 테스트 출력 확인 → expressions.txt에 누락 패턴 추가 (예: 새 변형) → reset + 재실행 | EC-10, AC-N1-7 |
| **R5** | force push 404 (URL 오타 / GitHub rename 미완) | 7 | push 거부 (HTTP 404) | 5.5단계 dry check 재실행 → 6단계 GitHub rename 재확인 → URL 정정 후 재push | EC-4, F-N1-c |
| **R6** | force push branch protection 거부 | 7 | push 거부 (HTTP 403) | GitHub Settings → Branch protection 임시 해제 → push → 재설정 | (신규) |
| **R7** | 폴더 mv 파일 락 (IDE 미종료) | 8 | mv exit 1 ("Operation not permitted" / "Resource busy") | 모든 IDE/tmux/터미널 종료 → `lsof +D /Users/.../jOneFlow` 점검 → 재시도. cp+rm 금지 [F-N1-f] | EC-9, F-N1-d, F-N1-f |
| **R8** | 폴더 mv 후 환경변수 fallback 잔존 | 8 직후 | `JONEFLOW_ROOT` 검색 / shell rc 파일 확인 | shell rc 수동 갱신 (`~/.zshrc`, `~/.bashrc`) — `JONEFLOW_ROOT`로 rename. 또는 사용 안 함 | EC-5, F-N1-d |
| **R9** | 상위 경로 잔존 (`Jonelab_Platform/.claude/settings.local.json:19`) | 8 직후 | AC-N1-8 verify_all.sh post-execution | 운영자 수동 패치 (settings.local.json 19행 jOneFlow → jOneFlow) | EC-3, AC-N1-8 |
| **R10** | filter-repo 미설치 | 0 (사전) | pre_check.sh exit 1 | `brew install git-filter-repo` 또는 `pip install --user git-filter-repo` | (신규) |
| **R11** | 백업 브랜치 이미 존재 (이전 시도 흔적) | 0 (사전) | pre_check.sh exit 1 | 이전 시도 결과 확인 → `git branch -D backup-pre-v0.6.1-rename` 또는 다른 이름 사용 | (신규) |

***REMOVED******REMOVED******REMOVED*** 6.2 백업 브랜치 = 영구 (Change-1) → 복구 표

| 시점 | 복구 명령 | 비고 |
|------|----------|------|
| 2단계 직후 (filter-repo 실패) | `git reset --hard backup-pre-v0.6.1-rename` | local 즉시 복구 |
| 5/5.5단계 (remote 등록 오류) | `git remote remove origin && git remote add origin <올바른 URL>` | history 영향 없음 |
| 7단계 직후 (force push 후 사고) | 매우 위험 — GitHub support 또는 새 repo 시작 | 본 단계 후 복구 비용 ↑↑↑ — 5.5단계 dry check가 핵심 방어 |
| 8단계 직후 (폴더 mv 사고) | `cd /Users/geenya/projects/Jonelab_Platform && mv jOneFlow jOneFlow` (역방향 단일 mv) | OS 차원 복구 |

***REMOVED******REMOVED******REMOVED*** 6.3 fail-closed 원칙 강제

**모든 R1~R11에서 자동 재시도/롤백 금지.** 운영자 호출 또는 명시적 재실행. 근거:
- 자동 재시도 → flaky 상태 은폐, 원인 불명 루프
- 롤백 자동화 → repo 상태와 GitHub 상태 divergence 위험 (특히 R5~R8)
- 운영자 수동 재실행 → 백업 브랜치 + 멱등 가능 단계 조합으로 비용 낮음

---

***REMOVED******REMOVED*** Sec. 7. D6 — F-N1-a~h 흡수 cross-reference

| F | 의미 (review Sec.3 정의) | 본 design 흡수 위치 |
|---|----------------------|-------------------|
| **F-N1-a** | 백업 브랜치 retention 정책 (영구 ← 운영자 Change-1) | Sec.0 Change-1 / Sec.4 단계 표 (9단계 삭제) / Sec.6.2 복구 표 |
| **F-N1-b** | filter-repo 전 IDE/worktree 종료 | Sec.4 단계 2 사전 조건 / Sec.5.1 (운영자 1차 영역 전 시그널) / Sec.6 R7 |
| **F-N1-c** | remote 재등록 = GitHub rename 후 | Sec.4 단계 표 (5단계가 6단계 뒤 위치) / Sec.5.2 인계 1 시그널 / Sec.6 R5 |
| **F-N1-d** | 폴더 mv 절대경로 fallback 갱신 | Sec.4 단계 8 사전 조건 / Sec.6 R8 / verify_all.sh AC-N1-8 |
| **F-N1-e** | case-sensitive 3종 한정 | Sec.2.3 expressions.txt 형식 / Sec.6 R2 (변형 누락 시) |
| **F-N1-f** | APFS case-insensitive 단일 mv | Sec.4 단계 8 명령 (단일 mv 명시) / Sec.6 R7 (cp+rm 금지) |
| **F-N1-g** | reflog + stale lock 정리 (Change-2 — 사후 검증만) | Sec.0 Change-2 / Sec.3.4 pre_check.sh (사후 검증) / Sec.3.5 post_check.sh (reflog gc) |
| **F-N1-h** | release.sh 하드코딩 치환 | Sec.2.3 expressions.txt가 자동 처리 / Sec.3.4 pre_check.sh INFO 출력 |

***REMOVED******REMOVED******REMOVED*** 7.1 흡수 검증 (모든 F가 본 design에 cross-ref 됨을 확인)

```
F-N1-a → Sec.0, Sec.4, Sec.6.2  ✅
F-N1-b → Sec.4, Sec.5.1, Sec.6 R7  ✅
F-N1-c → Sec.4, Sec.5.2, Sec.6 R5  ✅
F-N1-d → Sec.4, Sec.6 R8, AC-N1-8  ✅
F-N1-e → Sec.2.3, Sec.6 R2  ✅
F-N1-f → Sec.4, Sec.6 R7  ✅
F-N1-g → Sec.0, Sec.3.4, Sec.3.5  ✅
F-N1-h → Sec.2.3, Sec.3.4  ✅
```

8/8 흡수 확인.

***REMOVED******REMOVED******REMOVED*** 7.2 EC 흡수 (10/10)

```
EC-1 (백업 retention) → F-N1-a, Sec.0 Change-1
EC-2 (grep .git 제외) → Sec.3.2 whitelist
EC-3 (상위 경로) → AC-N1-8, Sec.6 R9
EC-4 (remote 타이밍) → F-N1-c, Sec.6 R5
EC-5 (폴더 mv 후 env) → F-N1-d, Sec.6 R8
EC-6 (reflog/lock) → F-N1-g, Sec.3.5
EC-7 (dry check) → AC-N1-6, Sec.4 5.5단계
EC-8 (CI) → Sec.7.3 (해당 사항 없음 명시)
EC-9 (APFS) → F-N1-f, Sec.6 R7
EC-10 (테스트 하드코딩) → AC-N1-7, Sec.6 R4
```

10/10 흡수 확인.

***REMOVED******REMOVED******REMOVED*** 7.3 EC-8 (GitHub Actions / CI) 보충

`.github/workflows/ci.yml` 확인 결과 `jOneFlow` 직접 하드코딩 0건 (검증 완료). filter-repo 후 별도 패치 불필요. 단 `JONEFLOW_ROOT` env 추가 여부는 v0.6.2+ 결정 (본 v0.6.1 scope 외).

---

***REMOVED******REMOVED*** Sec. 8. D7 — 미해결 질문 (Q5-* 신규)

본 Stage 5에서 발견된 새 질문 3건. **Stage 8 진입 전 운영자 결정 의무.**

***REMOVED******REMOVED******REMOVED*** Q5-1: 기획 산출물 자체에 jOneFlow 인용 — 치환 시 의미 손상 처리

**문제:** `docs/01_brainstorm_v0.6.1/brainstorm.md` (16 hits), `docs/02_planning_v0.6.1/plan_*.md` (76 hits), `docs/03_design/v0.6.1_n1_rename/technical_design.md` (본 문서, 다수 hits) 모두 `jOneFlow → jOneFlow` 형태의 표/코드블록 인용을 가짐. filter-repo가 자동 치환하면 표의 "Before" 컬럼이 `jOneFlow → jOneFlow`가 되어 의미 손상.

**옵션:**
- **A (권장 default):** 치환 허용. 작업 후 archive 성격 — v0.6.1 작업 완료 시점에는 본 문서들이 역사적 산출물이고, "치환 후 의미 보존"이 강제 아님. v0.6 brainstorm verbatim 보존(F-n1/n2)은 init/switch_team 코드의 verbatim에 한정이며 v0.6.1 기획은 verbatim 대상 아님.
- **B:** filter-repo `--paths-from-file <exclude_paths>` 또는 `--invert-paths`로 본 디렉토리 제외. 사후 의미 손상 부재 보장. 단 검증 grep(AC-N1-1)에서 잔존 hits로 잡힘 → whitelist에 명시 필요.
- **C:** 사후 수동 복원 — 치환 후 git 차원에서 일부 라인 복원 commit. 복잡도 ↑.

**운영자 결정 의무:** A/B/C 중 선택. 미결정 시 **A로 진행 가정**.

**영향:** AC-N1-1 측정 명령에 (B 선택 시) `--exclude-dir=docs/01_brainstorm_v0.6.1 --exclude-dir=docs/02_planning_v0.6.1 --exclude-dir=docs/03_design/v0.6.1_n1_rename` 추가 필요.

***REMOVED******REMOVED******REMOVED*** Q5-2: 상위 경로 `Jonelab_Platform/.claude/settings.local.json:19` 처리

**문제:** 사전 grep 결과 `Jonelab_Platform/.claude/settings.local.json:19`에 `Bash(chmod +x /Users/geenya/projects/Jonelab_Platform/jOneFlow/scripts/setup_tmux_layout.sh)` 한 줄 존재. 본 repo 외부 (상위 디렉토리) 파일이라 filter-repo 대상 아님.

**옵션:**
- **A (권장 default):** 폴더 mv 후 자동 무효화 — 경로 자체가 `jOneFlow → jOneFlow`로 사라지므로 `chmod +x` 권한 자체는 이미 적용된 상태(인덱스 캐시) → 새 경로에서 setup_tmux_layout.sh 첫 실행 시 운영자 권한 prompt가 한 번 더 발생할 수 있음 (Claude Code 권한 시스템 기준).
- **B:** 사전 수동 패치 — 폴더 mv 전 `Jonelab_Platform/.claude/settings.local.json:19`의 `jOneFlow` → `jOneFlow` 수동 변경.

**운영자 결정 의무:** A/B 선택. 미결정 시 **A로 진행 가정** (8단계 후 권한 prompt 1회 수용).

***REMOVED******REMOVED******REMOVED*** Q5-3: 신규 origin URL 형태 (HTTPS vs SSH)

**문제:** 5단계 `git remote add origin <URL>` 시 URL 형태 결정 필요.

**현재 `git remote -v` 결과:** `https://github.com/Hyoungjin-Lee/jOneFlow.git` (HTTPS).

**옵션:**
- **A (권장 default — 현 형태 유지):** `https://github.com/Hyoungjin-Lee/jOneFlow.git` (HTTPS).
- **B:** `git@github.com:Hyoungjin-Lee/jOneFlow.git` (SSH). PAT 미사용/SSH key 등록된 경우 더 단순.

**운영자 결정 의무:** A/B 선택. 미결정 시 **A로 진행 가정** (현행 일관성).

***REMOVED******REMOVED******REMOVED*** Q5 결정 요약

운영자 결정 미완 시 default 가정:
- Q5-1: A (치환 허용)
- Q5-2: A (자동 무효화)
- Q5-3: A (HTTPS)

Stage 8 진입 시 운영자가 명시적으로 confirm 또는 대안 선택.

---

***REMOVED******REMOVED*** Sec. 9. Out of Scope

본 v0.6.1 N1에서 **제외**되는 항목 (운영자 plan_final 승인 동시 확인됨):

- **N2~P2 (조직/브랜드/페르소나):** v0.6.2 이월
- **F1~F4 (기술 빚 청산):** v0.6.3 이월
- **D6/D7 (Hooks PostToolUse + gstack ETHOS):** v0.6.4 이월
- **`settings.json` 키명 변경:** 키는 generic (`workflow_mode` 등) — `jOneFlow` 문자열 부재
- **git tag 재작성:** `v0.4` / `v0.5` / `v0.6` 유지
- **CHANGELOG 신규 [0.6.1] 섹션 작성:** Stage 13에서 (본 design은 그 항목 정의 안 함)
- **GitHub Actions `JONEFLOW_ROOT` 추가:** v0.6.2+ 결정
- **`@openai/codex` CLI 자동화:** v0.6 정책 그대로 [F-n3]
- **자동 마이그레이션 도구:** 일회성 작업이라 미작성

---

***REMOVED******REMOVED*** Sec. 10. Acceptance Criteria 종합 (AC-N1-1~8 finalize)

| AC | brainstorm 정의 / plan_final 추가 | 측정 명령 (Stage 8 인용) | 측정 시점 | 통과 조건 |
|----|-------------------------------|---------------------|----------|----------|
| **AC-N1-1** | 문자열 잔존 0 hits | `grep -rnE 'jOneFlow\|joneflow\|JONEFLOW' . --exclude-dir=.git --exclude-dir=node_modules` | 3단계 직후 + 8단계 직후 | 0 hits (Q5-1 옵션 B 선택 시 추가 exclude) |
| **AC-N1-2** | 테스트 전체 PASS | `sh scripts/run_tests.sh` | 4단계 직후 | exit 0 + 모든 PASS 라인 |
| **AC-N1-3** | 커밋 메시지 잔존 0건 | `git log --all --pretty=format:'%H %s' \| grep -cE 'jOneFlow\|joneflow\|JONEFLOW'` | 3.5단계 (filter-repo 직후) | = 0 |
| **AC-N1-4** | Remote URL 정상 등록 | `git remote -v \| grep -c 'jOneFlow'` | 5단계 직후 | ≥ 1 |
| **AC-N1-5** | GitHub URL 접근 정상 | `curl -fsSL https://github.com/Hyoungjin-Lee/jOneFlow -o /dev/null` | 7단계 직후 | exit 0 |
| **AC-N1-6** (안→확정) | ls-remote dry check | `git ls-remote origin > /dev/null 2>&1` | 5.5단계 (force push 직전) | exit 0 |
| **AC-N1-7** (안→확정) | 테스트 하드코딩 치환 확인 | `git grep -qE 'jOneFlow' tests/bundle1/run_bundle1.sh && git grep -qE 'jOneFlow' tests/v0.6/test_init_project_verbatim.sh` | 4단계 + Stage 5 사전 식별 | 두 파일 모두 ≥ 1 hit (`jOneFlow`로 치환됨) |
| **AC-N1-8** (안→확정) | 상위 경로 잔존 0 hits | `grep -rnE 'jOneFlow\|joneflow\|JONEFLOW' /Users/geenya/projects/Jonelab_Platform/ --exclude-dir=jOneFlow --exclude-dir=jOneFlow --exclude-dir=.git --include='*.md' --include='*.sh' --include='*.json'` | 8단계 직후 | 0 hits (Q5-2 옵션 B 선택 시 사전 패치) 또는 명시적 잔존 위치 1건(`Jonelab_Platform/.claude/settings.local.json:19`) — 운영자 결정 |

**비고:**
- **8 AC 모두 자동화 가능** (AC-N1-5는 curl + 인터넷 접근 조건).
- **첫 실패 시 즉시 중단** (verify_all.sh fail-closed).
- **AC-N1-8 통과 조건은 Q5-2 결정에 의존** — 옵션 A 선택 시 1건 잔존 허용 + 위치 명시, 옵션 B 선택 시 0건 강제.

---

***REMOVED******REMOVED*** Sec. 11. Stage 8 구현 노트

***REMOVED******REMOVED******REMOVED*** 11.1 작성할 파일

- **`scripts/v0.6.1/expressions.txt`** — 3 매핑 (Sec.2.3)
- **`scripts/v0.6.1/pre_check.sh`** — Sec.3.4
- **`scripts/v0.6.1/post_check.sh`** — Sec.3.5
- **`scripts/v0.6.1/verify_all.sh`** — Sec.3.3
- **`scripts/v0.6.1/rename_n1.sh`** — 0~5.5단계 통합 진입점 (pre_check → filter-repo → verify → post_check → remote 재등록 → ls-remote dry check). 운영자 인계 시그널 출력 포함 (Sec.5.2 인계 1).

***REMOVED******REMOVED******REMOVED*** 11.2 수정할 파일

**filter-repo가 자동 처리 (수동 수정 불요):**
- `scripts/release.sh:74,78` (jOneFlow → jOneFlow tag message)
- `scripts/watch_v061_plan.sh:9`, `scripts/watch_v061_stage5.sh:9` (절대경로 fallback)
- `tests/bundle1/run_bundle1.sh:36`, `tests/v0.6/test_init_project_verbatim.sh:40,43,57` (테스트 하드코딩)
- `scripts/lib/settings.sh`, `scripts/init_project.sh`, `scripts/switch_team.sh`, `scripts/ai_step.sh` (`JONEFLOW_ROOT` 환경변수)
- `scripts/setup_tmux_layout.sh:10,31` (tmux 세션명 joneflow → joneflow)
- 모든 `docs/`, `CHANGELOG.md`, `CLAUDE.md`, `HANDOFF.md` 등 텍스트

**운영자 수동 (filter-repo 영역 외):**
- `Jonelab_Platform/.claude/settings.local.json:19` (Q5-2 옵션 B 선택 시 사전 패치, A 선택 시 자동 무효화)
- shell rc 파일 (`~/.zshrc`, `~/.bashrc`) — `JONEFLOW_ROOT` 환경변수 설정이 있는 경우 (`grep JONEFLOW_ROOT ~/.zshrc ~/.bashrc 2>/dev/null` 사전 확인)

***REMOVED******REMOVED******REMOVED*** 11.3 제약

- jq 비사용 (v0.6 정책 일관). 본 작업은 JSON 조작 없음.
- POSIX shell + `set -eu` + temp file → mv (해당 없음 — 본 스크립트는 in-place git 작업).
- shellcheck CLEAN 의무.
- 한국어 메시지.
- backup 브랜치 영구 보존 (Change-1).

***REMOVED******REMOVED******REMOVED*** 11.4 커밋 메시지 스타일 (Stage 13에서)

```
release(v0.6.1): N1 jOneFlow → jOneFlow 명칭 변경 + git history 재작성
```

본 작업은 history 재작성이라 변경 commit 자체는 force push로 사라짐. 새 commit chain의 마지막에 이 메시지로 release tag (v0.6.1) 생성.

***REMOVED******REMOVED******REMOVED*** 11.5 백업 브랜치 push 권장

7단계 force push 시 main 외에 backup 브랜치도 원격 push:

```sh
git push origin backup-pre-v0.6.1-rename
```

→ 원격에 백업 보존 (Change-1 영구 보존 정책 강화). 운영자 자율.

---

***REMOVED******REMOVED*** Sec. 12. Stage 5 답변 요약 (plan_final Sec.7 진입 조건 + Q1~Q3 처리)

| Q (plan_final 또는 review) | 처리 |
|---------------------------|------|
| Q1 (백업 retention) | 운영자 Change-1로 결정: **영구**. Sec.0 + Sec.4 9단계 삭제 |
| Q2 (grep 허용 잔존) | Sec.3.2 whitelist 정의: `.git/`, backup 브랜치(자동), node_modules. Q5-1 (기획 문서) 추가 결정 의무 |
| Q3 (상위 경로) | Sec.3.4 pre_check.sh + AC-N1-8. Q5-2로 옵션 결정 의무 |

| Stage 5 진입 조건 (plan_final Sec.7) | 본 design 충족 위치 |
|---------------------------------|-------------------|
| filter-repo 실행 스크립트 명세 | Sec.2 (D1) |
| 사전 점검 스크립트 명세 | Sec.3.4 |
| 잔존 grep 검증 스크립트 명세 | Sec.3.3, Sec.3.2 whitelist |
| 환경변수 매핑 테이블 | Sec.11.2 (filter-repo 자동 + shell rc 수동) |
| 테스트 재실행 + 환경변수 정합성 | Sec.4 단계 4 + AC-N1-2 + AC-N1-7 |

5/5 충족.

---

***REMOVED******REMOVED*** Sec. 13. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v1 — Stage 5 technical_design | Opus 4.7 직접 작성. plan_final 승인 후 운영자 변경사항 2건(백업 영구 + stale lock 사후 검증) 흡수. 단일 파일 R2 trail. F-N1-a~h (8/8) + EC-1~10 (10/10) + Q1~Q3 처리 + Q5-1~3 신규 미해결 발굴. AC-N1-1~8 측정 명령 finalize. |

---

***REMOVED******REMOVED*** 📌 다음 스테이지

**Stage 8 — 구현.** 본 design 단독 입력으로 Stage 8 진입 가능.

진입 전 클리어 의무:
1. **Q5-1 운영자 결정** (기획 문서 치환 정책 A/B/C)
2. **Q5-2 운영자 결정** (상위 경로 처리 A/B)
3. **Q5-3 운영자 결정** (origin URL HTTPS/SSH)
4. **사전 명령:** `brew install git-filter-repo` (또는 pip)
5. **사전 환경:** 모든 IDE / tmux 외 claude 세션 / 터미널 종료 (filter-repo 단계 직전)

진입 후 Stage 8에서 작성:
- `scripts/v0.6.1/expressions.txt` + `pre_check.sh` + `post_check.sh` + `verify_all.sh` + `rename_n1.sh`
- 단계 0~5.5 실행 후 운영자 인계 시그널 출력
- 운영자가 6~8단계 완료 후 Stage 9 코드 리뷰 + Stage 12/13 release(v0.6.1)
