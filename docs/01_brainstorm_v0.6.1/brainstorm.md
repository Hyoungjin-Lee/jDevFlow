***REMOVED*** v0.6.1 브레인스토밍

> Stage 1 산출물. Cowork 세션 23 (2026-04-25, Sonnet).
> 운영자: 지훈 / 모드: Standard

---

***REMOVED******REMOVED*** 1. v0.6.1 핵심 방향

**단일 목표:** jOneFlow → jOneFlow 명칭 변경 + git history 전체 재작성.

v0.6.0 릴리스 직후 타이밍. 현재 혼자 작업 중 → force push 가능한 유일한 시점.
팀 합류 후에는 history 재작성 불가. 지금 처리 필수.

---

***REMOVED******REMOVED*** 2. v0.6.1 scope 확정

| 버전 | 내용 | 근거 |
|------|------|------|
| **v0.6.1** | N1 — 명칭 변경 + git history 재작성 | 세션 23 확정 |
| **v0.6.2** | N2 JoneLab 디자인 통합 | 이월 |
| **v0.6.2** | N3 조직도 개편 정식 반영 | 이월 |
| **v0.6.2** | P1 페르소나 4명 정식 가동 | 이월 |
| **v0.6.2** | P2 디자이너/QA 페르소나 추가 검토 | 이월 |
| **v0.6.3** | F1~F4 기술 빚 청산 | 이월 |
| **v0.6.4** | D6 Hooks PostToolUse + 알림 | 이월 |
| **v0.6.4** | D7 gstack ETHOS | 이월 |

---

***REMOVED******REMOVED*** 3. N1 치환 범위 확정

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

**운영자 직접 실행 필요 (Claude 불가):**
- GitHub repo rename (`Settings → Repository name → jOneFlow`)
- `git remote set-url origin` 새 URL 등록
- `git push --force origin main`

**Claude(오케스트레이터)가 처리:**
- `git filter-repo` 실행 (파일명 + 파일 내용 + 커밋 메시지 전체 치환)
- 모든 파일 내 문자열 일괄 치환 스크립트 작성
- 치환 결과 검증 (grep으로 잔존 hits 확인)

---

***REMOVED******REMOVED*** 4. git history 재작성 방식 확정

**도구:** `git filter-repo` (git 공식 권장)
- `pip install git-filter-repo` 또는 `brew install git-filter-repo`
- `filter-branch` 대비: 속도 빠름, 안전, 공식 권장

**실행 순서:**
1. 백업 브랜치 생성: `git branch backup-pre-v0.6.1-rename`
2. `git filter-repo` — 커밋 메시지 + 파일명 + 파일 내용 3종 치환
3. 치환 결과 검증 (잔존 `jOneFlow` / `joneflow` / `JONEFLOW` hits = 0)
4. 테스트 재실행: `sh scripts/run_tests.sh` (13/13 PASS 확인)
5. `git remote add origin <새 URL>` (filter-repo가 remote 제거하므로 재등록)
6. 운영자: GitHub repo rename
7. 운영자: `git push --force origin main`
8. 로컬 폴더명: `git mv` 또는 운영자 `mv jOneFlow jOneFlow` (부모 디렉토리에서)

**주의사항:**
- filter-repo 실행 시 remote 자동 제거됨 → 실행 후 remote 재등록 필수
- 폴더명 변경(`jOneFlow/` → `jOneFlow/`)은 상위 디렉토리(`Jonelab_Platform/`)에서 실행
- `JONELAB_PLATFORM` 등 상위 경로 문자열은 치환 대상 아님 (jOneFlow 한정)

---

***REMOVED******REMOVED*** 5. 검증 기준 (AC)

| AC | 내용 |
|----|------|
| AC-N1-1 | `grep -rn 'jOneFlow\|joneflow\|JONEFLOW' .` = 0 hits (백업 브랜치 제외) |
| AC-N1-2 | `sh scripts/run_tests.sh` → 전체 PASS (명칭 변경 후 환경변수 경로 정합성 확인) |
| AC-N1-3 | `git log --oneline` 커밋 메시지에 `jOneFlow` 잔존 0건 |
| AC-N1-4 | `git remote -v` → 새 jOneFlow URL 정상 등록 |
| AC-N1-5 | GitHub repo URL `jOneFlow` 접근 정상 |

---

***REMOVED******REMOVED*** 6. Non-goal (v0.6.1)

- N2~P2, F1~F4, D6~D7 — 전량 v0.6.2+ 이월
- `settings.json` 키명 변경 없음 (키명은 generic — `workflow_mode` 등, jOneFlow 문자열 없음)
- git tag 재작성 없음 (`v0.4` / `v0.5` / `v0.6` 태그는 유지 — 버전 식별자는 변경 불필요)

---

***REMOVED******REMOVED*** 7. 다음 단계

- Stage 2–4 기획 (Opus + tmux 팀모드) — plan_draft / plan_review / plan_final
- Stage 5 기술 설계 — filter-repo 실행 스크립트 + 검증 방법 상세화
- Stage 8 구현 — 실제 치환 실행 + 테스트
