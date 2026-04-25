---
version: v0.6.1
stage: 2 (plan_draft)
date: 2026-04-26
mode: Standard
status: draft
author: drafter 준혁(Haiku)
---

***REMOVED*** jOneFlow → jOneFlow 명칭 변경 및 git history 재작성 계획

> **상위:** `docs/01_brainstorm_v0.6.1/brainstorm.md` (Stage 1, 세션 23)
> **본 문서:** `docs/02_planning_v0.6.1/plan_draft.md` (Stage 2, 드래프터 준혁)
> **다음:** `docs/02_planning_v0.6.1/plan_review.md` → `plan_final.md`
> 모드 근거: 명칭·히스토리 재작성. 구현은 filter-repo 일괄 처리 + 스크립트 자동화. 아키텍처·보안·데이터 스키마 변경 없음 → Standard.

---

***REMOVED******REMOVED*** Sec. 1. 목표 및 범위 요약

**북극성:** jOneFlow → jOneFlow 단일 명칭 변경. v0.6.0 직후 **유일한 force-push 시점**. 팀 합류 전 지금 처리 필수.

**범위 (Sec.3 N1):**
- GitHub repo명: `jOneFlow` → `jOneFlow`
- 로컬 폴더명: `jOneFlow/` → `jOneFlow/`
- 파일·커밋 메시지·환경변수·스크립트 내 모든 문자열 치환 (대소문자 구분)
- git history 전체 재작성 (`git filter-repo`)
- 테스트 13/13 PASS 확인

**비목표:**
- settings.json 키명 변경 없음 (키는 제네릭)
- git tag 재작성 없음 (버전 식별자 유지)

---

***REMOVED******REMOVED*** Sec. 2. 8단계 작업 순서 및 실행자

| 단계 | 액션 | 실행자 | 사전 조건 | 산출물/검증 |
|------|------|--------|----------|-----------|
| **1** | 백업 브랜치 생성 `git branch backup-pre-v0.6.1-rename` | **오케스트레이터** (Claude) | main 브랜치 정상 상태 | `git branch -a` 에 backup 브랜치 생성됨 |
| **2** | `git filter-repo` 실행 (커밋 메시지 + 파일명 + 파일 내용 3종 치환) | **오케스트레이터** (Claude) | 1단계 완료, backup 브랜치 확인됨 | filter-repo 실행 완료 로그 + .git/filter-repo/ 생성됨 |
| **3** | 치환 검증: `grep -rn 'jOneFlow\|joneflow\|JONEFLOW'` 잔존 hits 확인 | **오케스트레이터** (Claude) | 2단계 완료 | `grep` 결과 = 0 hits (backup 브랜치 제외) |
| **4** | 테스트 재실행: `sh scripts/run_tests.sh` (13/13 PASS) | **오케스트레이터** (Claude) | 3단계 검증 완료 | 테스트 로그 전체 PASS |
| **5** | Remote 재등록: `git remote add origin <새 URL>` | **오케스트레이터** (Claude) | 4단계 PASS | `git remote -v` 에 새 jOneFlow URL 등록됨 |
| **6** | GitHub repo 명칭 변경 `Settings → Repository name → jOneFlow` | **운영자** (지훈) | 5단계 완료 | GitHub repo URL 변경 확인 (https://github.com/.../jOneFlow) |
| **7** | Force push: `git push --force origin main` | **운영자** (지훈) | 6단계 완료 | main 브랜치 history 재작성 반영 (github 확인) |
| **8** | 로컬 폴더 이동: `mv jOneFlow jOneFlow` (부모 dir `Jonelab_Platform/`에서) | **운영자** (지훈) | 7단계 완료, 모든 IDE/터미널 세션 종료 | 폴더명 변경 완료 + `cd jOneFlow` 정상 작동 |

---

***REMOVED******REMOVED*** Sec. 3. 의존성 그래프

```
┌─────────────────────────────────────────────────┐
│ 1단계: 백업 브랜치 생성                        │
│ (선결 조건: main 정상)                         │
└──────────────┬──────────────────────────────────┘
               ▼
┌─────────────────────────────────────────────────┐
│ 2단계: filter-repo 실행                         │
│ (파일명 + 내용 + 커밋 메시지 3종 치환)        │
└──────────────┬──────────────────────────────────┘
               ▼
┌─────────────────────────────────────────────────┐
│ 3단계: grep 검증 (잔존 hits 확인)              │
│ (AC-N1-1 측정 포인트)                          │
└──────────────┬──────────────────────────────────┘
               ▼
┌─────────────────────────────────────────────────┐
│ 4단계: 테스트 재실행 (13/13 PASS)              │
│ (AC-N1-2 측정 포인트)                          │
└──────────────┬──────────────────────────────────┘
               ▼
┌─────────────────────────────────────────────────┐
│ 5단계: remote 재등록                            │
│ (filter-repo가 remote 제거하므로 필수)        │
└──────────────┬──────────────────────────────────┘
               ▼
┌─────────────────────────────────────────────────┐
│ 6단계: GitHub repo 이름 변경 [운영자]          │
│ (운영자만 권한 있음)                           │
└──────────────┬──────────────────────────────────┘
               ▼
┌─────────────────────────────────────────────────┐
│ 7단계: git push --force [운영자]               │
│ (remote URL 확인 후 진행)                       │
└──────────────┬──────────────────────────────────┘
               ▼
┌─────────────────────────────────────────────────┐
│ 8단계: 로컬 폴더 이동 [운영자]                 │
│ (모든 세션 종료 필수)                          │
└─────────────────────────────────────────────────┘

병렬 불가: 모든 단계가 순차 의존성 (8단계 직렬).
```

---

***REMOVED******REMOVED*** Sec. 4. 운영자/오케스트레이터 영역 분리표

| 작업 항목 | 실행자 | 실행 시점 | 검증 방법 |
|----------|--------|----------|----------|
| 백업 브랜치 생성 + filter-repo + 검증 | **Claude (오케스트레이터)** | 세션 8 구현 개시 | 3단계 grep 결과 0 hits |
| 테스트 재실행 + remote 재등록 | **Claude (오케스트레이터)** | 4~5단계 연속 실행 | `git remote -v` 확인 |
| **GitHub repo 이름 변경** | **운영자** (지훈, 권한 필수) | 5단계 완료 후 | GitHub Settings 직접 확인 |
| **git push --force** | **운영자** (지훈, force 승인) | 6단계 완료 후 | 깃허브 메인 브랜치 히스토리 확인 |
| **로컬 폴더 `mv` 명령** | **운영자** (지훈, 로컬 환경 관리) | 7단계 후, 모든 IDE/터미널 종료 후 | 새 경로 `~/...Jonelab_Platform/jOneFlow` 접근 가능 |

**요약:**
- **Claude 영역 (1~5단계):** filter-repo 자동화 + 검증 + 테스트. 오케스트레이터 전담.
- **운영자 영역 (6~8단계):** GitHub 권한 + force push 승인 + 로컬 환경 관리. 운영자 직접 실행만 가능.

---

***REMOVED******REMOVED*** Sec. 5. 단계별 위험 및 완화책

| 단계 | 위험 시나리오 | Likelihood | Impact | 완화 및 롤백 |
|------|--------------|-----------|--------|------------|
| **1** | 백업 브랜치 생성 실패 (refspec 오류) | 낮음 | 상 | `git status` + `git reflog` 확인. 기존 backup 있으면 `git branch -D backup-...` 후 재생성. 실패 시 작업 중단. |
| **2** | `git filter-repo` 데이터 손실 또는 부분 치환 | 낮음 | 상 | 백업 브랜치 존재 → `git checkout backup-pre-v0.6.1-rename` 로 완전 복구. 새 커밋 없음 → safe. |
| **3** | Grep 검증: 잔존 hits 발견 (예: 주석, 변수명, 문서 일부) | 중 | 중 | 잔존 hits 목록 생성 → 파일별로 수동 패치 → 재시도. filter-repo 재실행은 backup 브랜치에서 재시작. |
| **4** | 테스트 실패 (예: import path, 환경변수 미정합) | 중 | 중 | 오류 로그 분석 → 경로 정합성 점검. `JONEFLOW_ROOT` 등 신규 환경변수 누락 여부 확인. 필요시 3단계로 롤백. |
| **5** | `git remote add origin` 실패 (기존 origin 남음) | 낮음 | 중 | `git remote -v` 확인 → 기존 origin 있으면 `git remote remove origin` 후 재실행. |
| **6** | GitHub repo 이름 변경 권한 부족 또는 URL 오류 | 낮음 | 상 | 운영자 권한 재확인. repo 설정 페이지 직접 접근(Settings). 오류 시 같은 URL로 재시도. |
| **7** | Force push 시 브랜치 손상 또는 로컬/원격 불일치 | 낮음 | 상 | 실행 전 `git log --oneline | head` + `git remote -v` 최종 확인. 실수 시 GitHub 웹UI 또는 backup 브랜치에서 복구. |
| **8** | 로컬 폴더 `mv` 중 IDE/터미널이 폴더 점유 (파일 락) | 중 | 중 | 모든 IDE(VS Code, 터미널, 에디터) 종료 필수. `lsof \| grep jOneFlow` 로 점유 확인. 점유 있으면 대기 후 재시도. |

---

***REMOVED******REMOVED*** Sec. 6. 검증 시점 및 AC 측정

| AC | 내용 | 측정 시점 | 측정 방법 |
|----|------|----------|----------|
| **AC-N1-1** | 문자열 잔존 0 hits | 3단계 완료 후 | `grep -rn 'jOneFlow\|joneflow\|JONEFLOW' . --exclude-dir=.git` (backup 브랜치 제외) → 결과 = 0 |
| **AC-N1-2** | 테스트 13/13 PASS | 4단계 완료 후 | `sh scripts/run_tests.sh` → 전체 PASS 로그 확인 |
| **AC-N1-3** | 커밋 메시지 잔존 0건 | 5단계 완료 후 | `git log --oneline \| grep 'jOneFlow\|joneflow\|JONEFLOW'` → 결과 = 0 |
| **AC-N1-4** | Remote URL 정상 등록 | 5단계 완료 후 | `git remote -v` → origin URL이 새로운 jOneFlow URL 정확히 표시 |
| **AC-N1-5** | GitHub repo 접근 정상 | 7단계 완료 후 | https://github.com/.../jOneFlow 접근 + 브랜치/커밋 정상 표시 확인 |

---

***REMOVED******REMOVED*** Sec. 7. 미해결 질문 (Stage 3 리뷰어용)

| ***REMOVED*** | 질문 | 판단 책임 |
|---|------|----------|
| **Q1** | 백업 브랜치 보존 기간 — 8단계 모두 완료 후 언제 삭제할지? (영구 보존 vs. 1주 후 삭제) | Stage 3 reviewer (민지) |
| **Q2** | 3단계 grep 검증에서 문자열이 발견되는 경우, 어느 파일들이 "허용 가능한 잔존"으로 분류될지? (예: `.git` 디렉토리 내용, backup 브랜치 커밋, 주석 내 링크) | Stage 5 기술 설계 (filter-repo 스크립트 정확성) |
| **Q3** | 8단계 로컬 폴더 `mv` 이후, 상위 경로 `Jonelab_Platform`에서 `.gitmodule`, 빌드 스크립트 등이 상대 경로로 jOneFlow 참조하는 경우가 있는지 여부 및 수정 필요성 | Stage 5 기술 설계 + Stage 8 구현 검수 |

---

***REMOVED******REMOVED*** Sec. 8. 가정 및 의문점

**가정:**
1. v0.6.0 태그 이후 현재까지 새로운 팀원 합류 없음 → force-push 안전성 확보.
2. `git filter-repo`가 이미 설치되어 있거나 `brew install git-filter-repo` 가능.
3. GitHub 운영자(지훈)는 repo Settings 접근 권한 보유.
4. 테스트 스크립트 13건이 모두 환경변수 + 경로 기반 (하드코딩 된 `jOneFlow` 참조 없음).

**의문점:**
1. 상위 폴더(`Jonelab_Platform/`) 내 다른 파일들(`README.md`, `setup.sh` 등)이 상대 경로로 `jOneFlow`를 참조하는 경우 있는지? → Stage 5에서 사전 검사.
2. `filter-repo` 커밋 메시지 치환 시 원본 커밋자 정보(Author)는 유지되는지, 아니면 현재 사용자로 변경되는지? → Sec.5 risk R3 추가 검토 대상.

---

***REMOVED******REMOVED*** Sec. 9. 8단계 우선순위 및 시간 추정

| 단계 | 담당 | 예상 시간 | 우선순위 |
|------|------|---------|----------|
| 1 | Claude | ~2 min | 1순위 (선결조건) |
| 2 | Claude | ~5 min (filter-repo 실행시간) | 1순위 (핵심 작업) |
| 3 | Claude | ~3 min (grep) | 1순위 (게이트 검증) |
| 4 | Claude | ~10 min (테스트 실행) | 1순위 (게이트 검증) |
| 5 | Claude | ~1 min (remote 재등록) | 1순위 (선결조건) |
| 6 | 운영자 | ~5 min (웹UI) | 2순위 (대기) |
| 7 | 운영자 | ~1 min (force push) | 2순위 (대기) |
| 8 | 운영자 | ~2 min (폴더 mv) | 2순위 (대기) |

**전체 예상:** 오케스트레이터 ~21분 (병렬 불가) + 운영자 대기 시간 ~8분. 순차 실행 총 ~30분.

---

***REMOVED******REMOVED*** Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v1 초안 | brainstorm.md 기반 Standard 모드 plan_draft 작성 |

---

***REMOVED******REMOVED*** 다음 스테이지 — Stage 3 plan_review 포커스

1. **Q1 백업 브랜치 보존 정책** — 운영자 선호도 확인 후 일관성 있게 설정.
2. **Q2 grep 검증의 "허용 잔존" 범위** — filter-repo 매개변수에 제외 패턴 추가 여부 결정.
3. **Q3 상위 경로 참조 여부** — Jonelab_Platform/ 내 다른 파일 사전 점검 및 수정 필요성 판단.
4. **Sec.5 R3 추가:** `git filter-repo`의 author/committer 정보 보존 확인.
5. **Stage 5 진행 시** filter-repo 실행 스크립트 작성 + 환경변수 매핑 테이블 상세화.

