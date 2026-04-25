---
version: v0.6.1
stage: 3 (plan_review)
date: 2026-04-26
mode: Standard
status: review
author: reviewer 민지(Sonnet)
---

***REMOVED*** jOneFlow → jOneFlow 명칭 변경 — Stage 3 Plan Review (plan_review)

> **상위:** `docs/02_planning_v0.6.1/plan_draft.md` (Stage 2, drafter 준혁)
> **상-상위:** `docs/01_brainstorm_v0.6.1/brainstorm.md` (Stage 1, 세션 23)
> **하위:** `docs/02_planning_v0.6.1/plan_final.md` (Stage 4, finalizer 태원)

---

***REMOVED******REMOVED*** Sec. 1. 요약 판정

**판정: NEEDS_REVISION**

드래프트는 8단계 실행 골격이 건전하고 실행자 분리가 명확하나,
AC 5건 중 2건(AC-N1-1, AC-N1-3)이 측정 범위 불완전하며,
테스트 코드 내 하드코딩 문자열 문제(AC-N1-2 가정 4 오류),
백업 브랜치 retention 미결정(Q1), remote 재등록 타이밍 순서 불일치(F-N1-c),
그리고 설계 제약 F-N1-a ~ F-N1-h 8건이 미명시 상태다.
Stage 4 finalizer(태원)가 아래 결정 사항을 흡수한 후 Stage 5 진입 가능.

---

***REMOVED******REMOVED*** Sec. 2. AC 5건 vs draft 갭 분석

***REMOVED******REMOVED******REMOVED*** AC-N1-1 — 문자열 잔존 0 hits

**brainstorm 정의 (Sec.5):**
```
grep -rn 'jOneFlow\|joneflow\|JONEFLOW' . = 0 hits (백업 브랜치 제외)
```

**draft 반영 위치:** Sec.6 AC-N1-1, Sec.2 3단계, Sec.3 3단계 박스 (라인 42, 134)

**draft 측정 방법 (라인 134):**
```bash
grep -rn 'jOneFlow\|joneflow\|JONEFLOW' . --exclude-dir=.git
```

**갭 분석:**

**GAP-N1-1a — `.git/` 제외는 있으나 `backup-pre-v0.6.1-rename` 브랜치 명시 제외 로직 없음.**
`--exclude-dir=.git`은 working tree의 `.git/` 폴더를 제외하지만,
`git filter-repo` 실행 후 `.git/refs/original/` 또는 `git reflog` 안에
구버전 커밋 객체가 남아 grep 대상이 아니더라도 오해 소지 있음.
더 중요하게, brainstorm은 "백업 브랜치 제외"를 명시했으나
draft의 grep 명령은 worktree 파일 검색이므로 체크아웃되지 않은
backup 브랜치 내용은 자동으로 제외됨 — 이는 올바르나 **명시 없이 통과**.
측정 범위가 암묵적임. Stage 5에서 grep 명령에 주석으로 이유 명시 필요.

**GAP-N1-1b — `tests/bundle1/run_bundle1.sh:36`에 하드코딩 잔존 위험.**
현재 `tests/bundle1/run_bundle1.sh` 라인 36:
```bash
printf '%s\n' "$desc_block" | grep -q 'jOneFlow' || fail "description missing jOneFlow"
```
이 줄은 `jOneFlow` 문자열을 **기대값으로** 하드코딩하고 있음.
filter-repo가 이 파일을 치환해 `jOneFlow`로 바꾸면 해당 테스트가 깨짐.
반대로 치환을 의도적으로 이 테스트 파일에서 제외하면 AC-N1-1 grep 결과에서 hit 발생.
**이는 가정 4("테스트 스크립트 13건 모두 환경변수+경로 기반, 하드코딩 없음")가 실제로 거짓임을 의미.**

**GAP-N1-1c — 대소문자 변형 누락.** brainstorm Sec.5 grep 패턴은
`jOneFlow|joneflow|JONEFLOW` 3종만 포함. 실제 코드베이스에
`JDevFlow`, `jdevFlow` 등 비정상 변형이 있을 경우 미탐지.
(실제 검증 결과: 현재 코드베이스에 해당 변형은 없으나 정책 명시 필요.)

---

***REMOVED******REMOVED******REMOVED*** AC-N1-2 — 테스트 13/13 PASS

**brainstorm 정의:** `sh scripts/run_tests.sh` → 전체 PASS (명칭 변경 후 환경변수 경로 정합성 확인)

**draft 반영 위치:** Sec.6 AC-N1-2, Sec.2 4단계 (라인 43, 135)

**draft 측정 방법 (라인 135):**
`sh scripts/run_tests.sh` → 전체 PASS 로그 확인

**갭 분석:**

**GAP-N1-2a — 테스트 "13건"이 현재 구성과 불일치.**
`scripts/run_tests.sh` 실제 내용 (라인 15~36):
- bundle1: 10 checks
- bundle4: 4 tests
- v0.6: 3 unit tests (추가 14개 파일 포함)

합산 "17+"개이며 `run_tests.sh` 자체가 v0.6 테스트를 3개로 요약하나
`tests/v0.6/` 디렉토리에는 14개 파일이 있음. "13/13"은 오래된 숫자.
AC 표현을 "전체 PASS" 또는 실제 숫자로 교정 필요.

**GAP-N1-2b — GAP-N1-1b 연계: verbatim 테스트 파일 처리 전략 미결.**
`tests/v0.6/test_init_project_verbatim.sh` (라인 40, 43, 57)는
`"=== jOneFlow 프로젝트 초기화 ==="` 문자열을 golden output으로 하드코딩.
filter-repo 치환 후 이 파일도 `jOneFlow`로 바뀌면
`scripts/init_project.sh`의 출력과 일치해야 정상 — 연계 치환이므로 OK.
그러나 타이밍이 맞지 않을 경우 false-fail 발생 가능.
Stage 5 스크립트가 파일 치환과 filter-repo를 정확한 순서로 수행하는지 명시 필요.

---

***REMOVED******REMOVED******REMOVED*** AC-N1-3 — 커밋 메시지 잔존 0건

**brainstorm 정의:** `git log --oneline` 커밋 메시지에 `jOneFlow` 잔존 0건

**draft 반영 위치:** Sec.6 AC-N1-3 (라인 136)

**draft 측정 방법 (라인 136):**
```bash
git log --oneline | grep 'jOneFlow\|joneflow\|JONEFLOW'  → 결과 = 0
```

**갭 분석:**

**GAP-N1-3a — `git log --oneline`은 기본적으로 현재 브랜치만.**
`--all` 플래그 없으면 backup 브랜치, other refs는 검증 범위 밖.
backup 브랜치 커밋에 잔존해도 "0건"으로 통과.
brainstorm 의도("git history 전체 재작성")에 부합하려면
측정 범위를 `git log --all --oneline`으로 확장하거나,
backup 브랜치는 의도적으로 구버전 보관 목적임을 AC에 명시해야 함.

**GAP-N1-3b — 커밋 메시지 측정 시점이 5단계 완료 후로 지정됨.**
그런데 5단계는 remote 재등록. 커밋 메시지 재작성(filter-repo)은 2단계에서 완료됨.
AC-N1-3 측정은 2단계 직후(또는 3단계)가 논리적으로 올바름.
draft에서 5단계 후 측정으로 정의해 게이트 타이밍이 늦어짐.

---

***REMOVED******REMOVED******REMOVED*** AC-N1-4 — Remote URL 정상 등록

**brainstorm 정의:** `git remote -v` → 새 jOneFlow URL 정상 등록

**draft 반영 위치:** Sec.6 AC-N1-4 (라인 137)

**draft 측정 방법:** `git remote -v` → origin URL이 새로운 jOneFlow URL 정확히 표시

**갭 분석:**

**GAP-N1-4a — URL 포맷 미명시.** "새로운 jOneFlow URL"이 어떤 형태인지 draft에서 정의 없음.
`https://github.com/Hyoungjin-Lee/jOneFlow.git` 또는
`git@github.com:Hyoungjin-Lee/jOneFlow.git` — SSH vs HTTPS 선택이 Stage 5에서 확정 필요.

**GAP-N1-4b — `git remote add` 시점 문제 (F-N1-c 참조).**
draft 5단계에서 remote를 재등록하지만 GitHub repo rename(6단계)이 먼저 없으면
해당 URL은 404. remote를 등록 후 push 전 `git ls-remote` dry check가 없으면
7단계 force push 실패 위험. 상세는 F-N1-c 참조.

**갭 수준: 낮음.** URL 포맷 명시는 Stage 5에서 처리 가능.

---

***REMOVED******REMOVED******REMOVED*** AC-N1-5 — GitHub repo 접근 정상

**brainstorm 정의:** GitHub repo URL `jOneFlow` 접근 정상

**draft 반영 위치:** Sec.6 AC-N1-5 (라인 138)

**draft 측정 방법:** `https://github.com/.../jOneFlow` 접근 + 브랜치/커밋 정상 표시 확인

**갭 분석:**

**GAP-N1-5a — URL 플레이스홀더 `...` 미완성.** 실제 URL을 brainstorm에서도 명시하지 않았으나
Stage 5에서는 `https://github.com/Hyoungjin-Lee/jOneFlow` 확정 필요.

**GAP-N1-5b — 자동 검증 수단 없음.** 7단계 완료 후 운영자가 브라우저로 수동 확인하는 방식.
`curl -s -o /dev/null -w "%{http_code}" https://github.com/Hyoungjin-Lee/jOneFlow` 등
CLI 검증 추가 가능 — Stage 5 권장.

**갭 수준: 낮음.** Stage 5에서 처리 가능.

---

***REMOVED******REMOVED*** Sec. 3. 설계 제약 (F-N1-*) 발견

***REMOVED******REMOVED******REMOVED*** F-N1-a — 백업 브랜치 보존 기간은 "작업 기간 + α" 한정 (영구 아님)

**발견 근거:** draft Sec.7 Q1, Sec.2 1단계 산출물 설명.
백업 브랜치를 영구 보존할 경우 `git gc` 비용 증가 없음이나
"정책 없음"이 더 큰 문제 — 다음 세션에서 삭제 여부가 불명확해지면
팀 합류 후 혼란. 삭제 시점을 명시해 단일 정책으로 고정해야 함.

**권장:** `git push --force` (7단계) 성공 확인 후 1주일 이내 삭제.
Stage 4 finalizer가 정책 결정, Stage 8에서 삭제 단계 추가.

---

***REMOVED******REMOVED******REMOVED*** F-N1-b — filter-repo 실행 시 모든 worktree/IDE 닫혀 있어야 함

**발견 근거:** draft Sec.5 8단계 위험(라인 126)은 폴더 `mv` 단계에서만 언급.
그러나 `git filter-repo`는 `.git/index`를 재작성하므로
VSCode가 git 익스텐션으로 파일을 감시 중이면 충돌 가능.
lock 파일 실물 확인: `.git/index.lock.stale*` 파일 8개 존재 (현재 repo).

**권장:** 2단계 filter-repo 실행 전 "IDE 종료 + tmux 외 claude 세션 없음" 체크 추가.
Stage 5 스크립트에서 `lsof | grep .git/index` pre-flight check 권장.

---

***REMOVED******REMOVED******REMOVED*** F-N1-c — remote 재등록은 GitHub rename 완료 후, force push 직전에 수행

**발견 근거:** draft Sec.2 5단계에서 remote를 재등록하지만
GitHub repo rename(6단계)이 아직 안 된 시점. 즉:
- 5단계: `git remote add origin https://github.com/.../jOneFlow.git` 등록
- 6단계: GitHub에서 repo를 jOneFlow로 rename
- 7단계: `git push --force origin main`

5~6단계 사이에 `git ls-remote`를 실행하면 404 발생.
또한 실수로 `git push`가 6단계 전에 실행되면 잘못된 URL로 push 시도.

**권장:** 실행 순서를 다음으로 변경:
1. (5단계 유지) remote 등록은 placeholder 또는 구 URL 유지
2. (6단계) 운영자 GitHub rename
3. (5단계 이동) rename 확인 후 remote 재등록
4. (새 5.5단계) `git ls-remote origin` dry check — exit 0 확인
5. (7단계) force push

draft 표의 순서 번호 변경이 필요하므로 **Stage 4 plan_final에서 순서 재정의 필수**.

---

***REMOVED******REMOVED******REMOVED*** F-N1-d — 로컬 폴더 mv는 force push 완료 후 수행 (git이 .git 경로 의존)

**발견 근거:** draft Sec.2 8단계 사전 조건이 "7단계 완료, 모든 IDE/터미널 세션 종료"로 올바름.
그러나 8단계 이후 `.claude/` 경로, `JONEFLOW_ROOT` 환경변수, 셸 `cd` alias 등이
구 경로 `/Jonelab_Platform/jOneFlow`를 하드코딩한 경우 즉시 깨짐.

실물 확인:
- `scripts/watch_v061_plan.sh` 라인 9: `ROOT="${JONEFLOW_ROOT:-/Users/geenya/projects/Jonelab_Platform/jOneFlow}"`
  — 절대 경로 하드코딩. 폴더 mv 후 fallback이 구 경로 가리킴.
- `scripts/lib/settings.sh` 라인 28: `_sp_root="${JONEFLOW_ROOT:-}"` — 환경변수 의존이므로 OK이나
  환경변수 미설정 시 walk-up 로직으로 fallback — 폴더 mv 후에도 동작 가능.

**권장:** 폴더 mv 전 `grep -rn 'jOneFlow'` 절대경로 하드코딩 파일 목록 별도 추출.
`watch_v061_plan.sh`의 하드코딩 fallback은 filter-repo 치환으로 자동 처리되므로
치환 대상에 포함 확인 필요. Stage 5 스크립트에서 명시.

---

***REMOVED******REMOVED******REMOVED*** F-N1-e — 문자열 치환은 case-sensitive 3종 한정, 대소문자 변형 별도 확인 필요

**발견 근거:** brainstorm Sec.3 및 Sec.4 치환 대상 = `jOneFlow` / `joneflow` / `JONEFLOW` 3종.
실제 코드베이스 검증 결과 `JDevFlow`, `jdevFlow` 등은 현재 없음. 그러나
정책 문서(CLAUDE.md, HANDOFF.md)에 "jOneFlow"가 229곳 존재.
이 중 filter-repo 커밋 메시지 치환과 파일 내용 치환이 **동일 실행**인지
별도 실행인지 draft에서 불명확.

또한 `git filter-repo --message-callback` vs `--filename-callback` vs
`--blob-callback`은 서로 다른 실행 옵션 — Stage 5에서 3종을 각각 다루는
단일 `filter-repo` 명령 설계 필수.

**권장:** Stage 5에서 3종 치환을 단일 `--replace-text` 매핑 파일로 처리.
`expressions.txt` 형식:
```
jOneFlow==>jOneFlow
joneflow==>joneflow
JONEFLOW==>JONEFLOW
```

---

***REMOVED******REMOVED******REMOVED*** F-N1-f — macOS APFS는 case-insensitive 기본: 폴더 mv에서 대소문자만 다른 경우 실패

**발견 근거:** 현재 환경 filesystem = APFS (`diskutil info /` 결과 확인).
macOS APFS는 기본 case-insensitive (case-preserving). 따라서
`mv jOneFlow jOneFlow`는 두 이름이 다른 문자(`j**D**evFlow` vs `j**O**neFlow`)이므로
직접 rename 가능. 그러나 만약 중간 경로에 대소문자만 다른 파일이 생긴다면
APFS에서 무시됨.

실제 위험: `jOneFlow` → `joneflow` → `jOneFlow` 중간 스텝이 필요할 경우 APFS에서
`jOneFlow == joneflow`로 인식해 첫 rename이 no-op 될 수 있음.
직접 `mv jOneFlow jOneFlow` 단일 명령이면 문제없음.

**권장:** 폴더 mv 시 중간 임시 경로(`jOneFlow_tmp`)를 거치지 않고
단일 `mv` 명령 사용을 Stage 5에서 명시.

---

***REMOVED******REMOVED******REMOVED*** F-N1-g — filter-repo 실행 후 reflog + refs/original 정리 필요

**발견 근거:** `git filter-repo`는 기본적으로 `refs/original/`을 생성하지 않음
(이는 `git filter-branch`와 다름). 그러나 reflog에 구버전 커밋 SHA가 남음.
`git reflog expire --expire=now --all && git gc --prune=now` 없이는
구버전 커밋 객체가 `.git/objects/`에 잔존 → push 후 GitHub에서도 접근 가능.
force push만으로는 클라이언트 clone 캐시에서 구버전 접근 차단 안 됨.

현재 repo에 `.git/HEAD.lock.stale*` 파일 3개, `.git/index.lock.stale*` 파일 8개 존재.
이는 filter-repo 실행 전에 정리가 필요한 dirty 상태.

**권장:** 2단계(filter-repo) 실행 전 `git reflog expire --expire=now --all` 실행
및 stale lock 파일 정리. filter-repo 완료 후 `git gc --prune=now` 추가 단계 삽입.
Stage 5에서 명시.

---

***REMOVED******REMOVED******REMOVED*** F-N1-h — `scripts/release.sh` 내 `jOneFlow` 하드코딩은 치환 대상에 포함

**발견 근거:** `scripts/release.sh` 라인 74, 78:
```bash
tag -a "$VERSION" -m "jOneFlow $VERSION" -f
tag -a "$VERSION" -m "jOneFlow $VERSION"
```
이 파일은 filter-repo 파일 내용 치환 시 자동으로 `jOneFlow`로 바뀜.
그러나 filter-repo가 **파일 내용** 치환에 `--replace-text` 옵션을 사용할 경우
`.git` 디렉토리 밖 모든 파일에 적용됨 — `release.sh` 포함 확인 필요.

현재 태그(`v0.4`, `v0.5`, `v0.6`)의 message는 변경되지 않아야 함(Non-goal).
하지만 `release.sh`의 향후 실행 결과 tag message는 `jOneFlow`로 바뀌어야 함.
이 두 목표는 충돌하지 않으나 draft에서 명시 없음.

**권장:** Stage 5에서 `release.sh` 치환 대상 포함 확인 및 "기존 태그 message는 재작성 없음" 재확인.

---

***REMOVED******REMOVED*** Sec. 4. 누락 엣지 케이스

***REMOVED******REMOVED******REMOVED*** EC-1. 백업 브랜치 retention 정책 미결 (Q1)

**위치:** draft Sec.7 Q1, Sec.2 1단계
**재현 시나리오:** 8단계 완료 1개월 후, 팀원 합류. backup 브랜치 발견.
`git branch -a`에서 `backup-pre-v0.6.1-rename` 노출 → 팀원이 "이게 뭐야?"
또는 삭제 시점이 불명확해 영구 잔존.
**권장 조치:** Stage 4 finalizer가 정책 결정 (권장: force push 성공 + 1주일 후 `git branch -D`).
운영자가 승인 후 오케스트레이터가 실행.

---

***REMOVED******REMOVED******REMOVED*** EC-2. grep 검증 시 `.git/` 제외 범위 — 체크아웃 안 된 브랜치 객체

**위치:** draft Sec.6 AC-N1-1, Sec.2 3단계
**재현 시나리오:** filter-repo 실행 후 `grep -rn ... --exclude-dir=.git` 실행.
backup 브랜치는 worktree에 없으므로 grep 대상 아님 → 0 hits 통과.
그러나 운영자가 나중에 `git checkout backup-pre-v0.6.1-rename`을 실행하면
구버전 파일이 worktree에 나타나 잔존 hits 발생.
**권장 조치:** AC-N1-1 주석에 "backup 브랜치는 의도적으로 구버전 보존 목적" 명시.
검증 시 `git stash` 또는 검증 순서를 backup 브랜치 체크아웃 전으로 고정.

---

***REMOVED******REMOVED******REMOVED*** EC-3. 상위 경로 `Jonelab_Platform/` 내 다른 파일의 `jOneFlow` 참조

**위치:** draft Sec.8 의문점 1, Q3
**재현 시나리오:** `jOneFlow_design_system_spec.md` (`/Users/geenya/projects/Jonelab_Platform/`에 실존)가
`jOneFlow` 경로를 참조하는 경우. 실물 확인: Jonelab_Platform 디렉토리에 2개 파일 존재.
filter-repo는 `jOneFlow/` 안만 처리 — 상위 파일은 범위 밖.
**권장 조치:** Stage 5 전에 `grep -rn 'jOneFlow' /Users/geenya/projects/Jonelab_Platform/ --exclude-dir=jOneFlow` 실행.
존재할 경우 수동 치환 또는 N1 scope에 추가.

---

***REMOVED******REMOVED******REMOVED*** EC-4. remote 재등록 타이밍 — GitHub rename 전 URL 404

**위치:** draft Sec.2 5단계 (라인 44)
**재현 시나리오:** 오케스트레이터가 5단계 완료 후 `git remote -v` 체크 → OK.
그런데 운영자가 6단계(GitHub rename) 전에 `git ls-remote origin` 실행 →
새 URL이 아직 없으므로 404. 또는 실수로 `git push origin main` 실행 시 에러.
**권장 조치:** F-N1-c에서 상술. remote 재등록 순서를 GitHub rename 후로 이동.

---

***REMOVED******REMOVED******REMOVED*** EC-5. 로컬 폴더 mv 후 `JONEFLOW_ROOT` 환경변수 미갱신

**위치:** draft Sec.2 8단계, Sec.8 가정
**재현 시나리오:** 8단계 폴더 mv 완료. 운영자가 새 터미널 열고 `cd jOneFlow`.
`scripts/run_tests.sh` 실행 → `JONEFLOW_ROOT` 환경변수가 셸 rc 파일에
`export JONEFLOW_ROOT=.../jOneFlow`로 남아 있으면 구 경로 참조 에러.
또한 `scripts/watch_v061_plan.sh` fallback 경로가 구 주소 하드코딩 (라인 9 확인).
**권장 조치:** Stage 5에서 `JONEFLOW_ROOT` → `JONEFLOW_ROOT` 치환 목록에
shell rc 파일 확인 단계 추가 (`~/.zshrc`, `~/.bashrc` grep).
filter-repo는 repo 파일만 처리 — rc 파일은 운영자 수동 확인 필요.

---

***REMOVED******REMOVED******REMOVED*** EC-6. filter-repo 실행 후 reflog/stale lock 파일 미정리

**위치:** draft Sec.2 2단계, Sec.5 2단계 위험
**재현 시나리오:** filter-repo 완료. `git log --oneline` 확인 → 새 SHA로 바뀜.
그런데 `.git/reflog`에 구버전 SHA 잔존. GitHub force push 후에도
`git reflog`로 구버전 커밋 내용 접근 가능.
추가로 현재 repo에 `.git/index.lock.stale*` 파일 8개 잔존 — filter-repo 실행 방해 가능.
**권장 조치:** 2단계 전 stale lock 정리 단계 추가 (F-N1-g 상세 참조).

---

***REMOVED******REMOVED******REMOVED*** EC-7. 신규 origin URL push 전 dry check 없음

**위치:** draft Sec.2 7단계 (라인 46), Sec.5 7단계 위험
**재현 시나리오:** 운영자가 7단계 force push 실행. 그런데 GitHub rename이
완전히 propagate되지 않은 경우(CDN 지연), `git push --force`가 404로 실패.
또는 URL 오타로 다른 repo에 push 시도 (권한 없으면 에러로 끝나지만 위험).
**권장 조치:** force push 직전 `git ls-remote origin` 실행 → exit 0 확인 후 push.
이를 7단계 사전 조건으로 명시.

---

***REMOVED******REMOVED******REMOVED*** EC-8. GitHub Actions / CI 워크플로우 내 jOneFlow 잔존

**위치:** `.github/workflows/ci.yml`
**재현 시나리오:** force push 후 GitHub Actions가 `ci.yml` 기반으로 CI 실행.
현재 `ci.yml` 내용 확인 결과 `jOneFlow` 문자열 없음 — 직접 하드코딩 없음.
그러나 CI가 `scripts/run_tests.sh`를 실행하고, v0.6 테스트가 JONEFLOW_ROOT를 사용하면
GitHub Actions 환경에서 환경변수 미설정으로 fallback 경로 오류 가능.
`ci.yml`의 `test-linux`/`test-mac` job이 `v0.6` 테스트를 실행하지 않는다는 점
(현재 ci.yml은 bundle1, bundle4만 실행) — v0.6 테스트가 CI에서 제외됨.
**권장 조치:** 명칭 변경 후 CI에서 v0.6 테스트 추가 여부 확인. JONEFLOW_ROOT 환경변수를
GitHub Actions secret 또는 workflow env로 설정 여부 결정 (Stage 5).

---

***REMOVED******REMOVED******REMOVED*** EC-9. case-insensitive APFS에서 폴더 mv 특이사항

**위치:** draft Sec.2 8단계
**재현 시나리오:** 운영자가 `mv jOneFlow jOneFlow` 실행.
현재 환경 APFS는 case-insensitive이나 두 이름의 차이가 단순 대소문자 변경만이 아니므로
(jD→jO) 직접 rename 가능. 문제없음.
그러나 `cp -a jOneFlow jOneFlow && rm -rf jOneFlow` 방식을 사용하면
APFS에서 symbolic link나 extended attribute 손실 가능.
**권장 조치:** `mv jOneFlow jOneFlow` 단일 명령 사용 명시. `cp+rm` 방식 금지.
단, `.git/`이 폴더 내에 있으므로 mv 전 git 작업이 모두 완료(7단계 후)임을 재확인.

---

***REMOVED******REMOVED******REMOVED*** EC-10. `tests/bundle1/run_bundle1.sh` 하드코딩 `jOneFlow` 테스트 실패 위험

**위치:** `tests/bundle1/run_bundle1.sh:36`
**재현 시나리오:** filter-repo가 `run_bundle1.sh` 내 `jOneFlow` → `jOneFlow` 치환.
그 후 `sh scripts/run_tests.sh` 실행 → bundle1 내 해당 테스트가
`scripts/init_project.sh` 출력에서 `jOneFlow` 검색 → `init_project.sh`도 치환됐다면 PASS.
**그러나** 치환 후 `init_project.sh`가 `"=== jOneFlow 프로젝트 초기화 ==="` 출력하면
`test_init_project_verbatim.sh` golden 파일도 같이 치환되어야 함. 연계 치환 동시성 확인 필수.
**권장 조치:** Stage 5에서 filter-repo의 파일 내용 치환과 테스트 golden 파일 일관성
단일 실행으로 보장하도록 명시. 치환 순서 분리 금지.

---

***REMOVED******REMOVED*** Sec. 5. draft Q1/Q2/Q3에 대한 권장 답

***REMOVED******REMOVED******REMOVED*** Q1 — 백업 브랜치 보존 기간

**draft 질문:** 8단계 모두 완료 후 언제 삭제할지? 영구 보존 vs 1주 후 삭제?

**reviewer 권장 답:**
**7단계(force push) 성공 확인 후 1주일 이내 삭제.**
근거:
1. force push 성공 = GitHub 원격에 새 history 반영 완료. rollback 필요성 소멸.
2. 1주일 유예는 "push 직후 미처 발견 못한 문제" 발견을 위한 안전망.
3. 팀 합류 예정이라면 합류 전 삭제가 혼란 방지.
4. 장기 보존 필요 시 `git bundle backup-pre-v0.6.1-rename.bundle backup-pre-v0.6.1-rename`으로
   오프라인 아카이브 후 삭제.

**삭제 명령 (오케스트레이터 실행, 운영자 승인 후):**
```bash
git branch -D backup-pre-v0.6.1-rename
```
**최종 결정자: Stage 4 finalizer(태원) → 운영자 승인.**

---

***REMOVED******REMOVED******REMOVED*** Q2 — grep 검증에서 "허용 가능한 잔존" 범위

**draft 질문:** 파일이 발견되는 경우 어느 파일이 "허용 가능한 잔존"으로 분류될지?

**reviewer 권장 답:**
**허용 잔존 없음이 원칙. 단 다음 3가지는 예외 라벨 부여:**

| 예외 | 이유 | 처리 |
|------|------|------|
| `.git/` 디렉토리 내부 | `--exclude-dir=.git`로 자동 제외 | grep 명령에 기본 포함 |
| backup 브랜치 체크아웃 내용 | 의도적으로 구버전 보존 목적 | 체크아웃하지 않으면 worktree에 없음 |
| CHANGELOG.md 내 "v0.1 init jOneFlow" 등 역사적 기록 | 검토 필요 | filter-repo가 파일 내용도 치환하므로 자동 처리됨. 단, 역사적 기록 보존이 필요하면 Non-goal에 명시 |

**실질적 허용 잔존은 없어야 함.** filter-repo `--replace-text`가 CHANGELOG 포함 전체 처리.
단, `.github/`, HANDOFF/CLAUDE 등도 포함 확인 필요 (현재 229건).

**최종 결정자: Stage 5 기술 설계.**

---

***REMOVED******REMOVED******REMOVED*** Q3 — 상위 경로 `Jonelab_Platform/` 내 참조 여부

**draft 질문:** 상위 폴더 내 다른 파일들이 상대 경로로 `jOneFlow` 참조하는 경우 있는지?

**reviewer 권장 답 (실측 기반):**
현재 `/Users/geenya/projects/Jonelab_Platform/` 내 파일 목록:
- `jOneFlow_design_system_spec.md`
- `jOneFlow_design_system_v0.1.pptx`
- `assets/` 디렉토리

파일명에 `jOneFlow` 없음. 단, 파일 **내용** 검사는 미실행 (grep 결과 없음 — binary 제외).
`jOneFlow_design_system_spec.md` 내부에 `jOneFlow` 경로 참조 가능성 있음.

**권장 처리:**
Stage 5 시작 전 오케스트레이터가 실행:
```bash
grep -rn 'jOneFlow\|joneflow\|JONEFLOW' \
  /Users/geenya/projects/Jonelab_Platform/ \
  --exclude-dir=jOneFlow \
  --include="*.md" --include="*.sh" --include="*.txt"
```
결과에 따라 수동 치환 또는 "scope 밖" 명시.
**최종 결정자: Stage 5 기술 설계 + Stage 8 구현 검수.**

---

***REMOVED******REMOVED*** Sec. 6. 추가 권장 AC (운영자 승인 후 추가)

다음 AC는 본 리뷰에서 발견된 갭을 기반으로 추가 제안.
**모두 "운영자 승인 후 추가" — drafter 권한 밖이므로 plan_final 또는 Stage 5에서 확정.**

| ***REMOVED*** | 제안 AC | 근거 |
|---|---------|------|
| **AC-N1-6 (안)** | `git ls-remote origin` exit 0 확인 (force push 직전) | GAP-N1-4b, EC-7 |
| **AC-N1-7 (안)** | `git reflog` 구버전 SHA 접근 차단 (`git gc --prune=now` 완료) | F-N1-g, EC-6 |
| **AC-N1-8 (안)** | 상위 경로 `Jonelab_Platform/` 내 `jOneFlow` 잔존 0 hits | EC-3, Q3 |

---

***REMOVED******REMOVED*** Sec. 7. 위험 재평가

draft Sec.5 위험·완화책에서 누락되거나 과소평가된 항목:

***REMOVED******REMOVED******REMOVED*** 위험 재평가 — 2단계 (filter-repo)

**draft 평가:** Likelihood 낮음, Impact 상.
**reviewer 재평가:** Impact 매우 높음 (History 재작성은 되돌리기 가장 어려움).

**추가 미명시 위험:**
- filter-repo 3종(커밋메시지 + 파일명 + 파일내용) 중 **일부만 성공** 케이스.
  예: 파일 내용은 치환됐으나 커밋 메시지만 실패 → AC-N1-3 실패.
  완화: 치환 후 즉시 3종 각각 검증 명시.
- `.git/index.lock.stale*` 8개 파일 존재 — filter-repo 실행 시 lock 충돌 가능.
  완화: 실행 전 `rm .git/*.lock.stale*` 추가 (F-N1-g 참조).

***REMOVED******REMOVED******REMOVED*** 위험 재평가 — 4단계 (테스트)

**draft 평가:** Likelihood 중, Impact 중.
**reviewer 재평가:** 가정 4 오류로 인해 **Likelihood 높음**으로 상향.

이유: `tests/bundle1/run_bundle1.sh:36`와 `tests/v0.6/test_init_project_verbatim.sh`에
하드코딩 `jOneFlow` 문자열 확인. 치환 일관성이 보장되면 PASS이나, 치환 누락 시 FAIL.
**draft 가정 4는 수정 필요.**

***REMOVED******REMOVED******REMOVED*** 위험 재평가 — 5단계 (remote 재등록)

**draft 평가:** Likelihood 낮음, Impact 중.
**reviewer 재평가:** F-N1-c로 인해 **순서 변경 필요** — 5단계를 6단계 이후로 이동하면
Likelihood 낮음 유지 가능. 현재 순서 유지 시 Likelihood 중.

***REMOVED******REMOVED******REMOVED*** 추가 위험 — 0단계 (사전)

**신규 위험 R0:** stale lock 파일로 인한 filter-repo 실패.
현재 `.git/index.lock.stale*` 8개, `.git/HEAD.lock.stale*` 3개 존재.
filter-repo가 이를 lock으로 인식해 실행 거부할 수 있음.
**완화:** 1단계 전 `ls .git/*.lock.stale* 2>/dev/null && rm .git/*.lock.stale*` 실행.

---

***REMOVED******REMOVED*** Sec. 8. Stage 4 (finalizer 태원)에 인계할 결정 사항

| 항목 | draft 입장 | review 권장 | 최종 결정자 |
|------|-----------|-------------|------------|
| **백업 브랜치 보존 기간** (Q1) | 미결 — Stage 3에 위임 | force push 성공 후 1주일 이내 삭제 | **운영자 (지훈)** |
| **remote 재등록 순서** (F-N1-c) | 5단계(filter-repo 후), GitHub rename 전 | GitHub rename(6단계) 후, force push(7단계) 전으로 이동 | **Stage 4 finalizer (태원)** |
| **grep 허용 잔존 범위** (Q2) | Stage 5로 이월 | 허용 잔존 없음이 원칙. 예외 3종 라벨 지정 | **Stage 5 기술 설계** |
| **상위 경로 참조 사전 검사** (Q3) | Stage 5 + Stage 8 | Stage 5 전 오케스트레이터 grep 실행 | **Stage 5 시작 전 오케스트레이터** |
| **가정 4 수정** (GAP-N1-2a) | 테스트 13건 모두 하드코딩 없음 (거짓) | 가정 4 삭제 또는 "일부 verbatim 하드코딩 있음, filter-repo 치환으로 처리" 수정 | **Stage 4 finalizer (태원)** |
| **AC-N1-3 측정 시점** (GAP-N1-3b) | 5단계 완료 후 | 2단계 완료 직후 (filter-repo 후 즉시) | **Stage 4 finalizer (태원)** |
| **stale lock 파일 정리** (F-N1-g) | 미언급 | 1단계 전 `.git/*.lock.stale*` 정리 단계 추가 | **Stage 5 기술 설계** |
| **테스트 건수 "13/13"** (GAP-N1-2a) | 13/13 PASS | "전체 PASS" 또는 실제 건수 (bundle1:10 + bundle4:4 + v0.6:3+ = 17+) | **Stage 4 finalizer (태원)** |
| **AC-N1-6~8 추가 여부** (Sec.6) | 해당 없음 (신규 제안) | 3건 추가 권장 | **운영자 (지훈) 승인** |
| **filter-repo Author 정보 보존** (의문점 2) | Stage 5 검토 | `--preserve-commit-encoding` + author 유지 확인 Stage 5 | **Stage 5 기술 설계** |

---

***REMOVED******REMOVED*** Sec. 9. 본 리뷰가 다루지 않는 것

- `git filter-repo` 실행 스크립트 상세 옵션 (`--replace-text` 형식, callback 등) → **Stage 5**.
- `JONEFLOW_ROOT` → `JONEFLOW_ROOT` 전체 migration 스크립트 작성 → **Stage 5 + Stage 8**.
- GitHub Actions workflow에 JONEFLOW_ROOT 환경변수 추가 여부 → **Stage 5**.
- 코드 수준 리뷰 (filter-repo 결과물) → **Stage 9**.
- 고위험 독립 검증 → 본 작업은 Standard, Stage 11 대상 아님.

---

***REMOVED******REMOVED*** Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v1 — Stage 3 리뷰 작성 | reviewer 민지(Sonnet). AC 5건 갭 분석, F-N1-a~h 8건, EC 10건, Q1/Q2/Q3 권장 답, Stage 4 인계표. |
