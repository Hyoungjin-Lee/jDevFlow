---
version: v0.6.1
stage: 4 (plan_final)
date: 2026-04-26
mode: Standard
author: finalizer 태원(Haiku)
status: pending_operator_approval
upstream:
  - docs/01_brainstorm_v0.6.1/brainstorm.md (Stage 1)
  - docs/02_planning_v0.6.1/plan_draft.md (Stage 2)
  - docs/02_planning_v0.6.1/plan_review.md (Stage 3)
---

***REMOVED*** jOneFlow → jOneFlow 명칭 변경 및 git history 재작성 (plan_final)

> **상위:** `docs/01_brainstorm_v0.6.1/brainstorm.md` (Stage 1, 세션 23)
> **상위:** `docs/02_planning_v0.6.1/plan_draft.md` (Stage 2, drafter 준혁) · `docs/02_planning_v0.6.1/plan_review.md` (Stage 3, reviewer 민지)
> **하위:** Stage 5 기술 설계 (필수 조건: 모든 운영자 승인 ✅ 완료)
> **상태 배너:** ⏳ **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.

---

***REMOVED******REMOVED*** Sec. 0. 검토 결과 요약 (Review 반영)

**판정: NEEDS_REVISION 완전 반영 완료**

Stage 3 reviewer(민지)가 제시한 **8건 설계 제약(F-N1-a~h)** + **10건 누락 엣지 케이스(EC-1~10)** 전량을 Sec. 1~7에 반영.
추가로 **3건 권장 AC(AC-N1-6~8)**을 "운영자 승인 항목"으로 표기.

| 반영 항목 | 포함 여부 | 변경 위치 |
|----------|----------|---------|
| F-N1-a (백업 retention 정책) | ✅ | Sec.4 작업순서 + 운영자 승인 체크리스트 |
| F-N1-b (IDE/worktree 종료 의무) | ✅ | Sec.4 작업순서 + Sec.5 위험 R0 신규 추가 |
| F-N1-c (remote 재등록 순서 이동) | ✅ | Sec.4 작업순서 순서 번호 재정의 |
| F-N1-d (폴더 mv 절대경로 하드코딩) | ✅ | Sec.4 8단계 사전조건 + 운영자 승인 항목 |
| F-N1-e (3종 case-sensitive 치환) | ✅ | Sec.4 2단계 설명 + Stage 5 진입조건 |
| F-N1-f (APFS case-insensitive mv) | ✅ | Sec.4 8단계 + 운영자 승인 항목 |
| F-N1-g (reflog + stale lock 정리) | ✅ | Sec.4 1단계(사전) + 운영자 승인 항목 |
| F-N1-h (release.sh 하드코딩) | ✅ | 운영자 승인 항목 + Stage 5 진입조건 |
| EC-1~10 (엣지 케이스 10건) | ✅ | 각 항목별 운영자 승인 체크리스트에 통합 |
| AC-N1-6~8 (권장 AC 3건) | ✅ | Sec.6 AC 표에서 "운영자 승인 의제" 표기 |

---

***REMOVED******REMOVED*** Sec. 1. 목표 및 범위 요약

**북극성:** jOneFlow → jOneFlow 단일 명칭 변경. **v0.6.0 직후 유일한 force-push 시점**. 팀 합류 전 지금 처리 필수.

***REMOVED******REMOVED******REMOVED*** 1.1 변경 범위 (brainstorm Sec.3 확정)

| 대상 | Before | After |
|------|--------|-------|
| GitHub repo명 | `jOneFlow` | `jOneFlow` |
| 로컬 폴더명 | `jOneFlow/` | `jOneFlow/` |
| 문서 내 문자열 | `jOneFlow` | `jOneFlow` |
| tmux 세션명 (소문자) | `joneflow` | `joneflow` |
| 환경변수 | `JONEFLOW_ROOT` | `JONEFLOW_ROOT` |
| 스크립트/테스트 내 소문자 | `joneflow` | `joneflow` |
| 스크립트/테스트 내 대문자 | `JONEFLOW` | `JONEFLOW` |
| git 커밋 메시지 (history) | `jOneFlow` / `joneflow` / `JONEFLOW` | `jOneFlow` / `joneflow` / `JONEFLOW` |

***REMOVED******REMOVED******REMOVED*** 1.2 비목표 (Non-goal)

- `settings.json` 키명 변경 없음 (키는 generic)
- git tag 재작성 없음 (`v0.4` / `v0.5` / `v0.6` 유지)
- N2~D7 사항 전량 이월 (v0.6.2 이후)

---

***REMOVED******REMOVED*** Sec. 2. 실행자 영역 분리

***REMOVED******REMOVED******REMOVED*** 2.1 운영자(지훈) 직접 실행 (승인 권한 필수)

- **6단계:** GitHub repo 명칭 변경 (`Settings → Repository name → jOneFlow`)
- **7단계:** `git push --force origin main` (force push 승인)
- **8단계:** 로컬 폴더 `mv jOneFlow jOneFlow` (환경 관리)

***REMOVED******REMOVED******REMOVED*** 2.2 Claude 오케스트레이터 실행 (자동화)

- **1단계:** 백업 브랜치 생성 (선결조건 확인 + 실행)
- **2단계:** `git filter-repo` 실행 (3종 치환: 커밋메시지 + 파일명 + 파일내용)
- **3단계:** grep 검증 (AC-N1-1 측정)
- **4단계:** 테스트 재실행 (AC-N1-2 측정)
- **5단계:** remote 재등록 (GitHub rename 완료 확인 후)

---

***REMOVED******REMOVED*** Sec. 3. 확정된 8단계 작업 순서 (Review F-N1-c 순서 재배치)

| 단계 | 액션 | 실행자 | 사전 조건 | 검증 방식 |
|------|------|--------|----------|---------|
| **0** (사전) | stale lock 파일 정리: `.git/*.lock.stale*` 제거 [F-N1-g, R0] | Claude | main 정상, 모든 IDE 종료 | `ls .git/*.lock.stale* 2>/dev/null` = 파일 없음 |
| **1** | 백업 브랜치 생성: `git branch backup-pre-v0.6.1-rename` | Claude | 0단계 완료 + main 정상 | `git branch -a` 에 backup 브랜치 표시 |
| **2** | `git filter-repo` 실행 (3종 치환) [F-N1-e] | Claude | 1단계 완료 + IDE 종료 확인 [F-N1-b] | `.git/filter-repo/` 생성 + filter-repo 로그 확인 |
| **3** | grep 검증: `jOneFlow\|joneflow\|JONEFLOW` 잔존 hits 확인 (AC-N1-1) | Claude | 2단계 완료 | `grep -rn 'jOneFlow\|joneflow\|JONEFLOW' . --exclude-dir=.git` = 0 hits (backup 브랜치 제외) |
| **4** | 테스트 재실행: `sh scripts/run_tests.sh` (AC-N1-2) | Claude | 3단계 grep 완료 | 테스트 전체 PASS (명칭 변경 후 환경변수 정합성 확인) |
| **5** | Remote 재등록: `git remote add origin <새 URL>` [F-N1-c 이동됨] | Claude | GitHub rename(6단계) 완료 확인 후 | `git remote -v` 에 새 jOneFlow URL 정상 등록 |
| **5.5** | `git ls-remote origin` dry check (EC-7 완화) | Claude | 5단계 완료 | exit 0 확인 (URL 유효성 검증) |
| **6** | GitHub repo 명칭 변경: `Settings → Repository name → jOneFlow` | **운영자** | 5단계 완료 | GitHub repo URL = `https://github.com/.../jOneFlow` |
| **7** | Force push: `git push --force origin main` [EC-7 dry check 후] | **운영자** | 6단계 완료 + 5.5단계 확인 | GitHub main 브랜치 history 재작성 반영 |
| **8** | 로컬 폴더 이동: `mv jOneFlow jOneFlow` (부모 dir `Jonelab_Platform/`에서) | **운영자** | 7단계 완료 + 모든 IDE/세션 종료 + 폴더 정리 [F-N1-d] | `cd jOneFlow` 정상 작동, `pwd` = `...joneFlow` (구 경로 절대경로 fallback 제거됨) |
| **9** | 백업 브랜치 삭제 (Q1 결정: 1주일 후) [F-N1-a, EC-1] | Claude | 7단계 완료 후 1주일 이내 | `git branch -a` 에 backup 제거됨 |

**단계별 게이트:**
- 0~5.5: Claude 자동 진행 (실패 시 재시도/중단 → 운영자 호출)
- 6~8: 운영자 직렬 진행 (각 단계마다 선결조건 재확인)
- 9: Claude 자동 (1주일 후 자동 혹은 운영자 지시)

---

***REMOVED******REMOVED*** Sec. 4. Review 반영 변경 이력 (F-N1-* 상세)

***REMOVED******REMOVED******REMOVED*** F-N1-a: 백업 브랜치 보존 기간 명시

**draft 상태:** Q1로 미결정  
**review 권장:** force push 성공 후 1주일 이내 삭제  
**plan_final 결정:** 9단계 추가 (1주일 후 `git branch -D backup-pre-v0.6.1-rename`)  
**운영자 승인:** 백업 보존 기간 = 1주일 동의 (또는 영구/즉시 삭제 선택)

---

***REMOVED******REMOVED******REMOVED*** F-N1-b: IDE/worktree 종료 의무 (2단계 전)

**draft 상태:** 8단계(폴더 mv)에서만 언급  
**review 발견:** filter-repo가 `.git/index` 재작성 — VSCode git 익스텐션 감시 시 충돌 가능  
**plan_final 반영:** 0단계(사전) 및 2단계 사전조건에 "모든 IDE/tmux 외 claude 세션 종료" 명시  
**R0 신규 위험:** `.git/index.lock.stale*` 8개 파일 현재 존재 (0단계 정리 필수)  
**운영자 승인:** stale lock 정리 의무 동의

---

***REMOVED******REMOVED******REMOVED*** F-N1-c: remote 재등록 순서 이동 (GitHub rename 완료 후)

**draft 상태:** 5단계 (filter-repo 직후, GitHub rename 전)  
**review 지적:** 5~6단계 사이 `git ls-remote` 실행 시 404 발생 위험  
**plan_final 변경:** 6단계(GitHub rename) 완료 후 5단계로 이동. 순서 번호 조정.  
**추가 검증:** 5.5단계 신규 추가 (`git ls-remote origin` dry check, force push 직전)  
**운영자 승인:** 작업 순서(재배치 후) 동의

---

***REMOVED******REMOVED******REMOVED*** F-N1-d: 폴더 mv 후 절대경로 fallback 미갱신

**draft 상태:** Sec.8 의문점에만 언급  
**review 발견:** `scripts/watch_v061_plan.sh:9`의 하드코딩 fallback 경로  
**plan_final 대응:** 8단계 사전조건에 "filter-repo 치환으로 자동 처리 확인" 명시  
**Stage 5 진입조건:** filter-repo의 파일 내용 치환이 이 파일도 포함하는지 명시적 확인  
**운영자 승인:** 폴더 mv 후 환경변수 재설정 의무 동의 (shell rc 파일 확인)

---

***REMOVED******REMOVED******REMOVED*** F-N1-e: 3종 case-sensitive 치환 정책

**draft 상태:** brainstorm 3종만 명시, filter-repo 옵션 미상세  
**review 지적:** `--message-callback` vs `--filename-callback` vs `--blob-callback` 구분 필요  
**plan_final 결정:** 2단계에서 단일 `--replace-text` 매핑 파일 사용 명시  
**Stage 5 진입조건:** expressions.txt 형식 확정 (`jOneFlow==>jOneFlow` 등)  
**운영자 승인:** 대소문자 구분 치환 방식 동의

---

***REMOVED******REMOVED******REMOVED*** F-N1-f: APFS case-insensitive 환경에서 mv 특이사항

**draft 상태:** Sec.8 의문점에만 언급  
**review 지적:** `mv jOneFlow jOneFlow` 직접 rename만 안전 (중간 경로 불가)  
**plan_final 명시:** 8단계에 "중간 임시 경로 거치지 않고 단일 `mv` 명령 사용" 기재  
**운영자 승인:** APFS mv 단일 명령 사용 동의 (cp+rm 방식 금지)

---

***REMOVED******REMOVED******REMOVED*** F-N1-g: reflog + stale lock 파일 정리

**draft 상태:** Sec.5 2단계 위험에서만 언급  
**review 발견:** 현재 repo에 `.git/index.lock.stale*` 8개, `.git/HEAD.lock.stale*` 3개 존재  
**plan_final 대응:** 0단계(사전) 신규 추가 (`rm .git/*.lock.stale*`)  
**추가 단계:** filter-repo 완료 후 `git reflog expire --expire=now --all && git gc --prune=now` 추가  
**운영자 승인:** stale lock 정리 의무 동의

---

***REMOVED******REMOVED******REMOVED*** F-N1-h: release.sh 내 하드코딩 `jOneFlow` 치환 확인

**draft 상태:** 미언급  
**review 발견:** `scripts/release.sh:74,78`의 tag message 템플릿  
**plan_final 명시:** filter-repo `--replace-text`가 자동 처리하나, 기존 태그(v0.4~v0.6)는 재작성 아님 확인  
**Stage 5 진입조건:** release.sh 치환 대상 포함 및 "향후 tag message만 jOneFlow" 정책 명시  
**운영자 승인:** scripts/release.sh 하드코딩 치환 의무 동의

---

***REMOVED******REMOVED*** Sec. 5. 누락 엣지 케이스 처리 (EC-1~10)

***REMOVED******REMOVED******REMOVED*** EC-1: 백업 브랜치 retention 정책 미결 (Q1)

**처리:** F-N1-a로 반영. 9단계 추가 + 운영자 승인 항목.

---

***REMOVED******REMOVED******REMOVED*** EC-2: grep 검증 시 `.git/` 제외 범위 & backup 브랜치 명시

**처리:** Sec.3 3단계 주석에 "backup 브랜치는 의도적으로 구버전 보존 목적" 명시.  
**AC-N1-1 개선:** grep 명령에 `--exclude-dir=.git` 기본 포함 + 체크아웃 안 된 브랜치는 worktree에 없음 설명.

---

***REMOVED******REMOVED******REMOVED*** EC-3: 상위 경로 `Jonelab_Platform/` 내 다른 파일의 `jOneFlow` 참조

**처리:** Stage 5 진입조건으로 격상. Sec.7 "Stage 5 기술 설계 진입 조건" 참조.  
**권장 AC-N1-8:** 상위 경로 grep 검증 추가 (운영자 승인 항목).

---

***REMOVED******REMOVED******REMOVED*** EC-4: remote 재등록 타이밍 (GitHub rename 전 URL 404)

**처리:** F-N1-c로 완전 해결. 5단계를 6단계 이후로 이동.

---

***REMOVED******REMOVED******REMOVED*** EC-5: 로컬 폴더 mv 후 `JONEFLOW_ROOT` 환경변수 미갱신

**처리:** F-N1-d 참조. 8단계 사전조건 + 운영자 승인 항목에 "shell rc 파일 확인" 명시.

---

***REMOVED******REMOVED******REMOVED*** EC-6: filter-repo 실행 후 reflog/stale lock 파일 미정리

**처리:** F-N1-g로 완전 반영. 0단계(사전) + filter-repo 직후 gc 추가.

---

***REMOVED******REMOVED******REMOVED*** EC-7: 신규 origin URL push 전 dry check 없음

**처리:** 5.5단계 신규 추가 (`git ls-remote origin` exit 0 확인).  
**권장 AC-N1-6:** force push 직전 dry check 추가 (운영자 승인 항목).

---

***REMOVED******REMOVED******REMOVED*** EC-8: GitHub Actions / CI 워크플로우 내 `jOneFlow` 잔존

**처리:** 현재 ci.yml에 직접 하드코딩 없음 확인. 추후 v0.6 테스트 CI 추가 여부는 별도 논의.  
**Stage 5 진입조건:** JONEFLOW_ROOT 환경변수를 GitHub Actions 설정 여부 결정.

---

***REMOVED******REMOVED******REMOVED*** EC-9: case-insensitive APFS에서 폴더 mv 특이사항

**처리:** F-N1-f로 반영. 8단계에 "단일 mv 명령, cp+rm 방식 금지" 명시.

---

***REMOVED******REMOVED******REMOVED*** EC-10: tests/bundle1/run_bundle1.sh 하드코딩 `jOneFlow` 테스트 실패 위험

**처리:** 현재 하드코딩 확인 (`tests/bundle1/run_bundle1.sh:36`, `tests/v0.6/test_init_project_verbatim.sh`).  
**plan_final 대응:** AC-N1-2(테스트) 가정 수정. "일부 verbatim 하드코딩 있으나 filter-repo 치환으로 연계 일관성 보장" 명시.  
**Stage 5 진입조건:** filter-repo 파일 내용 치환이 단일 실행으로 테스트 파일 포함 확인 필수.  
**권장 AC-N1-7:** 테스트 하드코딩 파일(bundle1, v0.6/test_init_project_verbatim) 치환 의무 (운영자 승인 항목).

---

***REMOVED******REMOVED*** Sec. 6. 확정된 AC 표 (brainstorm 5건 + review 제안 3건)

| AC | 내용 | 측정 시점 | 측정 방법 |
|----|------|----------|----------|
| **AC-N1-1** | 문자열 잔존 0 hits | 3단계 완료 후 | `grep -rn 'jOneFlow\|joneflow\|JONEFLOW' . --exclude-dir=.git` = 0 hits (backup 브랜치 제외) |
| **AC-N1-2** | 테스트 전체 PASS (hardcoded jOneFlow 포함 파일도 치환됨) | 4단계 완료 후 | `sh scripts/run_tests.sh` → 전체 PASS 로그. bundle1 + bundle4 + v0.6 연계 치환 일관성 |
| **AC-N1-3** | 커밋 메시지 잔존 0건 | 2단계 완료 직후 | `git log --oneline \| grep 'jOneFlow\|joneflow\|JONEFLOW'` = 0 (측정 시점 조정) |
| **AC-N1-4** | Remote URL 정상 등록 | 5단계 완료 후 | `git remote -v` → origin URL = `https://github.com/Hyoungjin-Lee/jOneFlow.git` (or SSH variant) |
| **AC-N1-5** | GitHub repo 접근 정상 | 7단계 완료 후 | `https://github.com/Hyoungjin-Lee/jOneFlow` 접근 + 브랜치/커밋 정상 표시 |
| **AC-N1-6 (안)** | `git ls-remote origin` exit 0 | 5.5단계 완료 후 | `git ls-remote origin` 실행 = exit code 0 (force push 직전 dry check) |
| **AC-N1-7 (안)** | 테스트 하드코딩 파일 치환 의무 | Stage 5 설계 단계 | `tests/bundle1/run_bundle1.sh:36`, `tests/v0.6/test_init_project_verbatim.sh` 위치 사전 식별 + filter-repo 치환 대상 명시 |
| **AC-N1-8 (안)** | 상위 경로 `Jonelab_Platform/` 내 `jOneFlow` 잔존 0 hits | Stage 5 시작 전 | `grep -rn 'jOneFlow\|joneflow\|JONEFLOW' /Users/geenya/projects/Jonelab_Platform/ --exclude-dir=jOneFlow --include="*.md" --include="*.sh"` = 0 hits |

**비고:**
- AC-N1-1~5: brainstorm 원본 AC (본문 변경 금지)
- AC-N1-6~8: review 발견 + plan_final 추가 (운영자 승인 의제)

---

***REMOVED******REMOVED*** Sec. 7. Stage 5 기술 설계 진입 조건

아래 항목들이 Stage 5에서 상세 설계 및 확정될 것:

1. **filter-repo 실행 스크립트**
   - `--replace-text expressions.txt` 매핑 파일 형식 확정
   - 3종 치환(메시지 + 파일명 + 파일내용) 단일 `filter-repo` 명령으로 통합
   - `--preserve-commit-encoding` 등 옵션 정책
   - Author/Committer 정보 보존 확인

2. **사전 점검 스크립트**
   - stale lock 파일 정리: `.git/*.lock.stale*` rm
   - 상위 경로 grep: `Jonelab_Platform/` 내 `jOneFlow` 참조 확인 (EC-3, AC-N1-8)
   - 하드코딩 위치 사전 식별: `release.sh:74,78`, `watch_v061_plan.sh:9`, test 파일들
   - IDE 종료 확인 (F-N1-b)

3. **잔존 grep 검증 스크립트**
   - 예외 whitelist: `.git/`, backup 브랜치(체크아웃 안 된 상태)
   - AC-N1-1 측정 명령 및 주석 작성
   - CHANGELOG 등 역사적 기록도 치환 확인 (Q2 권장 답)

4. **환경변수 매핑 테이블**
   - `JONEFLOW_ROOT` → `JONEFLOW_ROOT` 전체 migration
   - shell rc 파일(~/.zshrc, ~/.bashrc) 확인 단계 (EC-5)
   - GitHub Actions JONEFLOW_ROOT 환경변수 추가 여부 (EC-8)

5. **테스트 재실행 + 환경변수 정합성**
   - AC-N1-2 측정 (연계 치환 일관성 확인)
   - AC-N1-7 (하드코딩 파일 위치 명시)

---

***REMOVED******REMOVED*** Sec. 8. 🔴 운영자 승인 체크리스트 (Stage 4.5)

운영자(지훈)가 다음 항목들을 검토하고 **✅ 체크 후 Stage 5 진입 가능:**

***REMOVED******REMOVED******REMOVED*** 범위 확정

- [ ] v0.6.1 scope = N1 단독 (다른 N2~D7 이월) 동의
- [ ] 변경 대상 8가지 (repo명, 폴더명, 문자열, tmux, 환경변수, 스크립트, 태그) 모두 포함 동의

***REMOVED******REMOVED******REMOVED*** 작업 순서 확정 (재배치 후)

- [ ] 8단계 순차 의존성 명확함 동의
- [ ] remote 재등록 순서를 GitHub rename(6단계) **후로 이동** 동의 (F-N1-c)
- [ ] 5.5단계(dry check) 신규 추가 동의 (EC-7)

***REMOVED******REMOVED******REMOVED*** 백업 정책 (F-N1-a, Q1)

- [ ] 백업 브랜치 보존 기간 = **1주일 후 삭제** 동의 (또는 영구/즉시 삭제 선택 명시)
- [ ] 9단계 추가(`git branch -D backup-pre-v0.6.1-rename`) 동의

***REMOVED******REMOVED******REMOVED*** IDE/세션 종료 의무 (F-N1-b, R0)

- [ ] 2단계(filter-repo) 전 **모든 IDE + tmux 외 claude 세션 종료** 의무 동의
- [ ] 0단계(사전)에서 `.git/*.lock.stale*` 파일 11개 정리 의무 동의

***REMOVED******REMOVED******REMOVED*** 잔존 grep 예외 정책 (EC-2, Q2)

- [ ] 허용 잔존 없음이 원칙. 예외:
  - [ ] `.git/` 디렉토리 내부 (자동 제외)
  - [ ] backup 브랜치 구버전 보존 (체크아웃하지 않으면 worktree 없음)
  - [ ] CHANGELOG 역사적 기록도 filter-repo가 자동 치환
- [ ] "잔존 grep 허용 예외" 명시 동의

***REMOVED******REMOVED******REMOVED*** 상위 경로 grep 의무 (EC-3, Q3, AC-N1-8)

- [ ] Stage 5 시작 **전** 오케스트레이터가 `Jonelab_Platform/` 내 `jOneFlow` 참조 grep 실행
  ```bash
  grep -rn 'jOneFlow\|joneflow\|JONEFLOW' \
    /Users/geenya/projects/Jonelab_Platform/ \
    --exclude-dir=jOneFlow --include="*.md" --include="*.sh"
  ```
- [ ] 발견 시 수동 치환 또는 scope 추가 여부 결정 동의

***REMOVED******REMOVED******REMOVED*** 폴더 mv 환경 정리 (F-N1-d, EC-5)

- [ ] 폴더 mv(8단계) 후 shell rc 파일(`~/.zshrc`, `~/.bashrc`)에서 `JONEFLOW_ROOT` 확인 의무 동의
- [ ] `scripts/watch_v061_plan.sh:9` 절대경로 fallback도 filter-repo 치환으로 자동 처리됨 확인 동의

***REMOVED******REMOVED******REMOVED*** 파일 시스템 특이사항 (F-N1-f, EC-9)

- [ ] 폴더 mv 시 **단일 `mv jOneFlow jOneFlow` 명령** 사용 (중간 경로 불가) 동의
- [ ] `cp+rm` 방식 금지 (APFS 속성/symlink 손실 위험) 동의

***REMOVED******REMOVED******REMOVED*** stale lock 및 gc (F-N1-g, EC-6)

- [ ] 0단계(사전): `.git/*.lock.stale*` 정리 단계 추가 동의
- [ ] filter-repo 완료 후: `git reflog expire --expire=now --all && git gc --prune=now` 실행 동의

***REMOVED******REMOVED******REMOVED*** 테스트 하드코딩 (EC-10, AC-N1-7)

- [ ] `tests/bundle1/run_bundle1.sh:36` 하드코딩 `jOneFlow` 확인
- [ ] `tests/v0.6/test_init_project_verbatim.sh` 하드코딩 확인
- [ ] filter-repo 파일 내용 치환이 이 파일들을 **동시에** 포함하여 연계 일관성 보장 동의

***REMOVED******REMOVED******REMOVED*** release.sh 하드코딩 (F-N1-h)

- [ ] `scripts/release.sh:74,78` tag message 템플릿의 `jOneFlow` 치환 확인
- [ ] 기존 태그(v0.4~v0.6)는 **재작성 아님** (Non-goal 유지) 동의
- [ ] 향후 tag message만 `jOneFlow`로 바뀌어야 함 동의

***REMOVED******REMOVED******REMOVED*** force push 최종 확인 (EC-7)

- [ ] 7단계 force push 직전 `git ls-remote origin` dry check = exit 0 확인 의무 동의
- [ ] AC-N1-6 추가 동의 (운영자 승인 항목)

***REMOVED******REMOVED******REMOVED*** AC 확정

- [ ] AC-N1-1~5 (brainstorm 원본) 동의
- [ ] AC-N1-6 (`git ls-remote` dry check) 추가 동의
- [ ] AC-N1-7 (테스트 하드코딩 위치 명시) 추가 동의
- [ ] AC-N1-8 (상위 경로 grep) 추가 동의

---

***REMOVED******REMOVED*** Sec. 9. 의존성 및 위험 재평가

***REMOVED******REMOVED******REMOVED*** 9.1 위험 등급 (Sec.3 기준)

| 단계 | 주요 위험 | Likelihood | Impact | 완화 | 담당 |
|------|----------|-----------|--------|------|------|
| **0** (사전) | stale lock 정리 실패 | 낮음 | 중 | `ls` 사전 확인 → 없으면 진행 | Claude |
| **1** | 백업 브랜치 생성 실패 | 낮음 | 상 | `git reflog` 확인 → 재생성 또는 중단 | Claude |
| **2** | filter-repo 부분 치환 | 낮음 | 상 | 3종(메시지+파일명+내용) 각각 검증 후 진행 (AC-N1-1, N1-3 게이트) | Claude |
| **3** | grep 잔존 hits 발견 | 중 | 중 | 파일별 수동 패치 → filter-repo 재실행 | Claude |
| **4** | 테스트 실패 (하드코딩 미치환) | 중 | 중 | AC-N1-7로 위치 사전 식별 → Stage 5에서 치환 정책 확정 | Claude / Stage 5 |
| **5-6** | GitHub rename 권한 부족 | 낮음 | 상 | 운영자 권한 재확인 → retry | 운영자 |
| **7** | force push 실패 (URL 오타 등) | 낮음 | 상 | AC-N1-6(dry check) 확인 후 진행 | 운영자 |
| **8** | 폴더 mv 파일 락 | 중 | 중 | IDE/터미널 전부 종료 (F-N1-b) | 운영자 |
| **9** | 백업 브랜치 삭제 실패 | 낮음 | 낮음 | 재시도 또는 보존 | Claude |

***REMOVED******REMOVED******REMOVED*** 9.2 외부 의존성

- Claude Max 플랜 이상 (team_mode 미지원 시 `claude-only` 기본값)
- GitHub 운영자 권한 (repo rename + force push)
- `git filter-repo` 설치 (brew 또는 pip)

---

***REMOVED******REMOVED*** Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v1 — Stage 4 plan_final | finalizer 태원(Haiku). plan_review 8건 F-N1-* + 10건 EC-1~10 전량 반영. 운영자 승인 체크리스트 15항목. Stage 5 진입 조건 5가지. AC-N1-6~8 추가 동의 항목. |

---

***REMOVED******REMOVED*** 🎯 다음 스테이지

**Stage 4.5 — 운영자(지훈) 승인 게이트.**

Sec. 8 체크리스트 **모든 항목 ✅ 동의 후에만** Stage 5 기술 설계 진입 가능.

**승인 시:**
- Stage 5 Technical Design 진입
- Stage 5에서 위 "Stage 5 기술 설계 진입 조건"의 5가지를 상세 설계
- 모델: Opus (권장)

**거절/수정 요청 시:**
- 해당 Sec. 번호 또는 F-xx ID 참조하여 개정
- 재검토 후 운영자 재승인

**예정 일정:**
- Stage 5: 기술 설계 + filter-repo 스크립트 작성 (1~2일)
- Stage 8: 실제 명칭 변경 실행 (1~2일)
- Stage 9: 코드 리뷰 + AC 검증 (당일)
- Stage 12~13: QA + 릴리스 (당일)

