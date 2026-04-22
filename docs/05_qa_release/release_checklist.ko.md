---
title: 릴리스 체크리스트 — jDevFlow v0.3 (단일 공동 태그)
stage: 12
bundle: 1+4
version: 2
language: ko
paired_with: release_checklist.md
created: 2026-04-22
updated: 2026-04-22
status: in_progress
validation_group: 1
---

# 릴리스 체크리스트 — jDevFlow v0.3 (단일 공동 태그)

**태그:** `v0.3` (plan_final M.6 에 따라 Bundle 1 + Bundle 4 를 함께 덮는 단일 공동 태그)
**릴리스 소유자:** Hyoungjin (Releaser); Claude 보조.
**타깃:** 프로젝트 리포의 GitHub 릴리스.
**단계:** Stage 13 게이트; 이 체크리스트는 Stage 12 에서 작성되며 태그 생성 전에 전부 체크되어야 함.

---

## 0. Pre-flight (이 체크리스트를 열기 전 참이어야 함)

- [x] Stage 11 = APPROVED (M.5 worst-of-two 에 따른 group verdict). `docs/notes/final_validation.md` 참조.
- [x] 두 번들 `verdict: minor` 이월; blocking 발견 없음.
- [x] `final_validation.md` Sec. 3 의 Stage 12 housekeeping 항목은 랜딩됐거나 v0.4 로 명시 deferred.
- [x] `docs/05_qa_release/qa_scenarios.md` (+ `.ko.md`) 작성 완료.
- [x] `CHANGELOG.md` `[0.3.0]` 엔트리 TBD 날짜 플레이스홀더로 작성 완료.

---

## 1. 코드 & 테스트 게이트

- [x] 태그 후보 커밋에서 `bash tests/bundle1/run_bundle1.sh` → 10/10 PASS.
- [x] 태그 후보 커밋에서 `sh tests/run_bundle4.sh` → 4/4 PASS.
- [ ] **mac** 에서 양 하네스 green (Stage 11 Bundle 4 non-blocking #2 의 CI 매트릭스 forward). *운영자 paste 대기 — Sec. 1.1 참조.*
- [x] **Linux** 에서 양 하네스 green (같은 출처의 CI 매트릭스 forward).
- [ ] mac 에서 `shellcheck -S style scripts/update_handoff.sh` exit 0. *운영자 paste 대기 — Sec. 1.1 참조.*
- [x] Linux 에서 `shellcheck -S style scripts/update_handoff.sh` exit 0. *프록시 사용 (`sh -n` + `dash -n` + `bash -n`), 실제 shellcheck 는 v0.4 로 이월 (CHANGELOG `[Unreleased]`/CI 백로그).*

어느 CI 러너에서든 `shellcheck` 사용 불가면, 사용된 프록시를 문서화 (예: Stage 11 final_validation.md Sec. 3 Bundle 4 #1 에 따른 `sh -n` + `dash -n` 구문 검사) AND 실제 shellcheck 실행을 위한 v0.4 이슈 오픈.

### 1.1 결과 레저 (Stage 13 세션 7, 2026-04-22 UTC)

| Row | Runner | Command | 결과 | 비고 |
|-----|--------|---------|------|------|
| 1.a | Linux aarch64 (Ubuntu 22, 샌드박스) | `bash tests/bundle1/run_bundle1.sh` | 10/10 PASS | 후보 커밋 `08a43fd` (Stage 12 close). |
| 1.b | Linux aarch64 (Ubuntu 22, 샌드박스) | `sh tests/run_bundle4.sh` | 4/4 PASS | 동일 후보. |
| 1.c | Linux aarch64 (Ubuntu 22, 샌드박스) | `sh -n scripts/update_handoff.sh` | exit 0 | shellcheck 프록시. |
| 1.d | Linux aarch64 (Ubuntu 22, 샌드박스) | `dash -n scripts/update_handoff.sh` | exit 0 | shellcheck 프록시. |
| 1.e | Linux aarch64 (Ubuntu 22, 샌드박스) | `bash -n scripts/update_handoff.sh` | exit 0 | 보너스 프록시 (non-POSIX 인터프리터 sanity). |
| 1.f | Linux aarch64 (Ubuntu 22, 샌드박스) | `shellcheck -S style scripts/update_handoff.sh` | 사용 불가 | 바이너리 미설치; `apt-get install` 차단 (root 없음). v0.4 백로그 seed. |
| 1.g | **mac** | `bash tests/bundle1/run_bundle1.sh` | **운영자 paste 대기** | 릴리스 작성자가 로컬에서 실행하고 결과를 여기 paste. |
| 1.h | **mac** | `sh tests/run_bundle4.sh` | **운영자 paste 대기** | 동일. |
| 1.i | **mac** | `shellcheck -S style scripts/update_handoff.sh` | **운영자 paste 대기** | 동일. mac 은 일반적으로 Homebrew 로 shellcheck 사용 가능 (`brew install shellcheck`). |

운영자가 mac 결과를 paste 하면, 위 `pending` 3 행이 `PASS`/`FAIL` 로 flip 되고 Sec. 1 의 체크박스 3 개도 그에 맞춰 flip 된 후 태그가 cut.

---

## 2. QA 시나리오 사인오프

`docs/05_qa_release/qa_scenarios.md` 에 따라:

- [x] H1 (Bundle 1 — tool-picker 발견 및 의사결정) PASS. *하네스 10/10 + `.skills/tool-picker/SKILL.md` Sec. 6 이 5줄 advisory 형태 산출.*
- [x] H2 (Bundle 4 — 유효한 HANDOFF.md 에서 `update_handoff.sh` 성공) PASS. *`tests/run_bundle4.sh` 4/4.*
- [x] H3 (공동 — SKILL.md 가 `decisions.md` 를 verbatim 파싱) PASS. *`diff <(sed -n '24,62p' decisions.md) <(sed -n '34,72p' SKILL.md)` 빈 diff; `grep -nE '\]\(' SKILL.md` 0 매치; backlink 행 45/55/72 이 D4.x4 상대경로 형식 사용.*
- [x] H4 (공동 — Stage 종료 시 KO 페어 freshness R4) PASS. *모든 Stage-5+ EN/KO 페어의 `updated:` Δ=0; Stage 1–4 페어는 같은 git-log 날짜 공유.*
- [x] F1–F6 절차가 current 로 확인됨 (태그 커밋에서 실제로 트리를 깨뜨릴 필요 없음). *참조 파일 모두 존재; SKILL.md Sec. 7 + tech_design Sec. 6 + `tests/bundle4/test_02_update_handoff_failures.sh` + `test_04_frontmatter_and_stage1_4.sh` + SKILL.md Sec. 3 전부 존재.*

---

## 3. 문서 게이트

- [x] `CHANGELOG.md` `[0.3.0]` 날짜가 실제 태그 날짜로 채워짐 (`TBD` 교체). *세션 7 에서 `[0.3.0] - 2026-04-22` 확정.*
- [x] `CHANGELOG.md` `[Unreleased]` 섹션을 빈 stub 으로 리셋. *리셋 + 서브섹션 하나 ("CI / infra (v0.4 backlog seed)") populate — shellcheck 설치 + mac CI 자동화.*
- [x] `HANDOFF.md` 가 Recent Changes + status line 에서 Stage 13 릴리스 반영. *EN status 라인 = "Stage 13 🟡 tag target committed; `v0.3` tag to be cut on this commit" + post-release flip 메모. KO 미러 갱신.*
- [x] `docs/notes/dev_history.md` (+ `.ko.md`) 에 Stage 13 종료 엔트리 (Entry 3.14) 기록. *Entry 3.14 EN + KO 작성; 개정 로그 v1.7 로 bump; 세션 요약표 +4 행 (세션 4/5/6/7). Entry 3.15 는 실제 태그 SHA 와 함께 post-release 커밋에서 추가.*
- [x] 모든 Stage-5+ 문서가 D4.x2 frontmatter 보유 (`tests/bundle4/test_04_frontmatter_and_stage1_4.sh` 에 의해 자동 체크). *`08a43fd` 에서 하네스 4/4 PASS.*
- [x] 모든 EN/KO 페어가 R4 만족 (태그 시점 Δ ≤ 1 일). *세션 7 에서 H4 검증; 모든 Stage-5+ 페어에서 Δ=0.*

---

## 4. 리포 위생

- [ ] 태그 커밋에서 working tree clean (`git status` 빈 결과).
- [ ] `.bak.<ts>.<pid>` 파일 미커밋 (`1e4cda9` 의 Bundle 4 `.gitignore` 규칙이 처리해야 함 — 확인).
- [ ] `.gitignore` 로 명시 opt-out 된 것 외에 untracked 파일 없음.
- [ ] 시크릿, 크레덴셜, local 설정 (예: `.claude/` override) 미커밋.

---

## 5. 태그 생성 (Stage 13 mechanics)

위 모든 박스가 체크되면:

1. 태그 후보 커밋으로 `main` fast-forward (작업이 계속 `main` 상에 있었으므로 merge 커밋 불필요).
2. 태그 생성:
   ```
   git tag -a v0.3 -m "jDevFlow v0.3 — Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β); M.6 에 따른 joint release"
   ```
3. 태그 푸시:
   ```
   git push origin main
   git push origin v0.3
   ```
4. 태그에서 GitHub 릴리스 오픈하고 `[0.3.0]` CHANGELOG 섹션을 본문으로 사용.

---

## 6. 릴리스 후

- [ ] `HANDOFF.md` status line 을 "v0.3 released; v0.4 planning open" 으로 업데이트.
- [ ] `docs/notes/dev_history.md` 에 실제 태그 SHA 와 태그 날짜 기록한 post-release 엔트리 추가.
- [ ] v0.4 백로그에 `CHANGELOG.md` `[0.3.0]` "Deferred to v0.4" 서브섹션의 이월 항목 seed:
  - `.skills/tool-picker/SKILL.md` Sec. 6 live tool-picker triple refresh.
  - `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 verbatim refresh.

---

## 7. 사인오프

- [ ] Stage 13 에서 릴리스 작성자 (Hyoungjin) 가 이 파일에 사인오프.
- [ ] 사인오프 날짜를 frontmatter (`updated:` 필드) 와 dev_history 엔트리에 기록.

---

## 8. 개정 이력

- v1 (2026-04-22, 세션 6 연속): `qa_scenarios.md` 와 함께 Stage 12 에서 작성.
