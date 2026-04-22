---
title: QA 시나리오 — jOneFlow v0.3 (Validation Group 1)
stage: 12
bundle: 1+4
version: 1
language: ko
paired_with: qa_scenarios.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# QA 시나리오 — jOneFlow v0.3 (Validation Group 1)

**범위:** Validation Group 1 = { Bundle 1 tool-picker, Bundle 4 doc-discipline (옵션 β) }. plan_final M.6 에 따라 Stage 12 QA 는 두 번들 공동.

**읽기 순서:** 이 파일은 Stage 12 의 주 산출물 (WORKFLOW Sec. 15). 릴리스 사인오프를 위해 `release_checklist.md` 와 페어. 판정은 Stage 11 에서 이미 승인됨 (`docs/notes/final_validation.md`); Stage 12 QA 는 재검증이 아니라 확인 패스.

**실행 표면:**
- Bundle 1 하네스: `bash tests/bundle1/run_bundle1.sh` (10 검사)
- Bundle 4 하네스: `sh tests/run_bundle4.sh` (`tests/bundle4/` 아래 4개 테스트 스크립트)
- 모든 Stage 12 패스와 릴리스 게이트에서 양쪽 모두 green 유지 필수.

---

## 1. Happy-path 시나리오

### H1. Bundle 1 — tool-picker 발견 및 의사결정

**목적:** 새 Claude 세션이 `.skills/tool-picker/SKILL.md` 를 찾아 순서대로 읽고, 구체적 `(stage, mode, risk)` 트리플에 대해 올바른 advisory 출력을 낼 수 있음을 증명.

**사전조건:**
- 리포 `main` HEAD.
- `CLAUDE.md` 에 `.skills/tool-picker/SKILL.md` 를 가리키는 read-order hook 존재.

**절차:**
1. `bash tests/bundle1/run_bundle1.sh` 실행.
2. `CLAUDE read order hook` 검사 PASS 확인 (발견성 검증).
3. `existence`, `section order`, `frontmatter triggers`, `decision table completeness`, `decision table paths` PASS 확인 (AC.B1.1, AC.B1.2, AC.B1.3, AC.B1.4 커버).
4. `.skills/tool-picker/SKILL.md` Sec. 6 점검 — worked example 이 문서화된 5-라인 형태의 advisory 출력 산출 확인 (AC.B1.5 커버).

**기대 결과:** 하네스 10/10 PASS + Sec. 6 출력 형태 육안 확인.

**AC 커버리지:** B1.1, B1.2, B1.3, B1.4, B1.5, B1.9.

---

### H2. Bundle 4 — 유효한 HANDOFF.md 에서 `scripts/update_handoff.sh` 성공

**목적:** POSIX-sh 핸드오프 업데이터가 conformant 입력에 대해 `.bak.<ts>.<pid>` 롤백과 함께 `HANDOFF.md` 를 idempotent 하게 변경함을 증명.

**사전조건:**
- `HANDOFF.md` 가 스크립트가 기대하는 canonical 섹션들을 포함 (`templates/HANDOFF.template.md` 참조).
- `docs/notes/decisions.md` 가 D4.x2/x3/x4 레코드 보유.

**절차:**
1. `sh tests/run_bundle4.sh` 실행.
2. `test_01_update_handoff_success.sh` PASS 확인 — `scripts/update_handoff.sh` 의 green 경로, `.bak.<ts>.<pid>` 방출 및 성공 시 정상 제거 커버.
3. `test_03_docs_structure.sh` PASS 확인 — D4.x3 폴더 명명 (`^bundle(\d+)_(.+)$`), `docs/03_design/`, `docs/04_implementation/`, `docs/05_qa_release/`, `docs/notes/` 클러스터 하의 문서 배치 커버.
4. `test_04_frontmatter_and_stage1_4.sh` PASS 확인 — Stage-5+ 문서에 D4.x2 frontmatter 존재 및 Stage 1–4 prose 에 의도적 부재 커버.

**기대 결과:** `tests/run_bundle4.sh` 4/4 PASS.

**AC 커버리지:** B4.1 (스크립트 존재), B4.2 (frontmatter 스키마), B4.3 (9 개 discriminated error codes — F2 참조), B4.4 (`.bak.<ts>.<pid>` 롤백), B4.5 (폴더 명명), B4.6 (HANDOFF 템플릿), B4.9 (frontmatter 강제).

---

### H3. 공동 — SKILL.md 가 `docs/notes/decisions.md` 를 verbatim 파싱

**목적:** D1.b ↔ D4.x2/x3/x4 파서 계약이 여전히 올바르게 연결되어 있음을 증명: Bundle 1 이 Bundle 4 의 locking decisions 를 원문 그대로 인용하므로, `decisions.md` 의 어떤 drift 도 Bundle 1 의 advisory 표면에 즉시 드러남.

**사전조건:** H1 + H2 에 따라 양 하네스 green.

**절차:**
1. `diff <(sed -n '24,62p' docs/notes/decisions.md) <(sed -n '34,72p' .skills/tool-picker/SKILL.md)` — 기대: 빈 diff (문자 단위 일치).
2. `grep -nE '\]\(' .skills/tool-picker/SKILL.md` — 기대: 0 매치 (D4.x4 가 vacuous-by-construction, 위반할 markdown link 자체 없음).
3. verbatim 블록의 backlink 경로가 `../03_design/bundle4_doc_discipline/technical_design.md Sec. 0` (D4.x4 relative-link 형식) 인지 확인.

**기대 결과:** 세 검사 모두 통과; 어떤 결과에 대해서도 조치 불필요.

**AC 커버리지:** B4.10 (SKILL.md 가 decisions.md 파싱), B4.11 (D4.x4 링크 관례), 그리고 B1.8 (SKILL.md 의 verbatim clause) 재확인.

**마지막 검증:** 2026-04-22 Stage 11 (`docs/notes/final_validation.md` Sec. 4).

---

### H4. 공동 — Stage 종료 시 KO 페어 freshness (R4)

**목적:** R4 가 리포 전역에서 성립함을 증명: Stage-5+ 문서의 `updated:` 필드가 EN 과 1 일 이내; Stage 1–4 문서의 `git log -1` 타임스탬프가 EN 과 1 일 이내.

**사전조건:** H1 + H2 에 따라 양 하네스 green.

**절차:**
1. `docs/notes/final_validation.md` Sec. 5 의 `KO freshness table` 각 행에 대해 `Δ = |EN_updated - KO_updated|` 를 일 단위로 계산 (Stage-5+ 는 `updated:`, Stage 1–4 는 `git log -1 --format='%ai'`).
2. 모든 행 Δ ≤ 1 확인.
3. D4.x2 에 따른 frontmatter 존재/부재 확인을 위해 `tests/bundle4/test_04_frontmatter_and_stage1_4.sh` 재실행.

**기대 결과:** 모든 Δ ≤ 1; 테스트 PASS.

**AC 커버리지:** B4.12 (R4 강제), B4.9 (frontmatter 규칙).

---

## 2. 실패 / 엣지 케이스 시나리오

각 실패 시나리오는 **기대되는 거절** 로 표현 — 테스트 하네스 또는 인간 리뷰가 입력을 *거부* 해야 함. 이 시나리오들은 discriminating error codes (AC.B4.3) 와 read-only 불변식 (AC.B1.7, R2) 를 행사.

### F1. Bundle 1 — R2 read-only 위반 (합성 주입)

**목적:** 향후 편집자가 실수로 shell/CLI 코드를 `.skills/tool-picker/SKILL.md` 에 붙여넣더라도 하네스가 잡아냄을 증명.

**절차 (버릴 브랜치, 커밋하지 않음):**
1. 일회용 브랜치 생성: `git switch -c qa/f1-r2-violation`.
2. `.skills/tool-picker/SKILL.md` Sec. 7 에 합성 위반 주입 (예: ```` ```bash\necho hello\n``` ```` 라인 추가).
3. `bash tests/bundle1/run_bundle1.sh` 실행.
4. `R2 grep` 이 위반 라인을 명시적으로 식별하는 메시지로 FAIL 관찰.
5. 브랜치 폐기: `git switch main && git branch -D qa/f1-r2-violation`.

**기대 결과:** 하네스가 주입된 위반에서 실패; 다른 검사는 false-alarm 하지 않음.

**AC 커버리지:** B1.7 (R2 불변식); grep regex 가 canonical 금지 접두사 커버 확인.

---

### F2. Bundle 4 — `update_handoff.sh` 가 malformed 입력을 discriminated error 로 거절

**목적:** `scripts/update_handoff.sh` 가 malformed 입력에 대해 9 개 discriminated `error=<key>` 코드 중 하나를 방출하며 (AC.B4.3), 각 코드가 `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 6 (Stage 9 에서 10 행으로 확장) 의 실패 모드와 1:1 매핑됨을 증명.

**절차:**
1. `sh tests/bundle4/test_02_update_handoff_failures.sh` 실행.
2. 테스트 파일의 각 케이스가 해당 `error=<key>` stdout discriminator 를 트리거하고 non-zero 로 종료하는지 확인.
3. `technical_design.md` Sec. 6 표를 spot-check 하여 10 행 × `stdout 디스크리미네이터` 열이 스크립트가 방출하는 9 개의 구별되는 `error=<key>` 값으로 해석되는지 확인 (10 번째 행은 success 경로 문서화).

**기대 결과:** 모든 discriminated 실패가 해당 에러 코드 발생; 코드 없이 generic exit-1 없음; 코드 충돌 없음.

**AC 커버리지:** B4.3 (discriminated errors), B4.4 (실패 시 rollback).

---

### F3. Bundle 4 — Stage-5+ 문서에서 D4.x2 frontmatter 누락

**목적:** frontmatter 가드가 Stage-5+ 문서에 필수 YAML 헤더가 없을 때 거절함을 증명.

**절차 (버릴 브랜치):**
1. `git switch -c qa/f3-missing-frontmatter`.
2. 임의의 Stage-5+ 문서에서 YAML frontmatter 제거 (예: `docs/05_qa_release/qa_scenarios.md` — 이 파일).
3. `sh tests/bundle4/test_04_frontmatter_and_stage1_4.sh` 실행.
4. 파일명과 누락 필드를 명시하는 메시지로 테스트 FAIL 관찰.
5. 브랜치 폐기.

**기대 결과:** 테스트 실패; 에러 메시지가 offending 파일 식별.

**AC 커버리지:** B4.2 (frontmatter 스키마), B4.9 (강제).

---

### F4. Bundle 4 — Stage 1–4 문서에 spurious frontmatter

**목적:** 역가드도 성립함을 증명 — Stage 1–4 prose 문서는 frontmatter 를 가져서는 안 됨 (D4.x2 에서 명시적 제외).

**절차 (버릴 브랜치):**
1. `git switch -c qa/f4-spurious-frontmatter`.
2. `docs/01_brainstorm/brainstorm.md` (또는 임의의 Stage 1–4 문서) 맨 앞에 YAML `---`…`---` 블록 prepend.
3. `sh tests/bundle4/test_04_frontmatter_and_stage1_4.sh` 실행.
4. offending Stage 1–4 파일을 명시하며 테스트 FAIL 관찰.
5. 브랜치 폐기.

**기대 결과:** 테스트 실패.

**AC 커버리지:** B4.2 (frontmatter 는 Stage-5+ 에만), B4.9.

---

### F5. 공동 — KO 페어 drift > 1 일 (R4 위반)

**목적:** R4 가 stale KO translation 을 잡아냄을 증명.

**절차 (버릴 브랜치):**
1. `git switch -c qa/f5-ko-drift`.
2. `docs/03_design/bundle1_tool_picker/technical_design.md` (EN) 편집 — `updated:` 를 today +1 로 변경하되 `.ko.md` 는 미수정.
3. H4 의 절차로 Δ 수동 계산.
4. Δ = 1 일이면 임계값 (`≤ 1`) 통과함을 관찰하고, EN `updated:` 를 today +2 로 bump. 이제 Δ = 2.
5. Δ > 1 이 stage-close 리뷰 절차에서 플래그됨을 확인 (R4 규칙).
6. 브랜치 폐기.

**기대 결과:** R4 검사가 페어를 플래그; 규칙 강제.

**AC 커버리지:** B4.12.

**비고:** R4 numeric delta 에 대한 자동 하네스 검사는 현재 존재하지 않음 (plan_final Sec. 5.2 가 이를 수용 — R4 는 stage close 시 인간 리뷰 게이트). 이 시나리오는 릴리스 게이트용 수동 절차 문서화.

---

### F6. Bundle 1 — 합성 tool-picker decision-table 경로 부식

**목적:** 결정 테이블의 깨진 경로 참조를 하네스가 잡아냄을 증명 (AC.B1.4).

**절차 (버릴 브랜치):**
1. `git switch -c qa/f6-path-rot`.
2. `.skills/tool-picker/SKILL.md` Sec. 3 결정 테이블의 한 셀을 존재하지 않는 파일 참조로 변경 (예: `docs/nonexistent/file.md`).
3. `bash tests/bundle1/run_bundle1.sh` 실행.
4. `decision table paths` 가 missing target 명시하며 FAIL 관찰.
5. 브랜치 폐기.

**기대 결과:** 하네스가 경로 해결 에러로 실패.

**AC 커버리지:** B1.4.

---

## 3. Release 체크리스트 연결

Stage 13 릴리스 게이트 (plan_final M.6) 는 다음을 요구:

1. 릴리스 태그 후보 HEAD 에서 H1–H4 시나리오 모두 통과.
2. F1–F6 시나리오가 *문서화된 절차* 로 검증됨 — 릴리스 커밋에서 실행할 필요는 없지만 이 파일의 절차가 current 해야 함.
3. `CHANGELOG.md` `[0.3.0]` 엔트리가 실제 태그 날짜로 finalize (TBD 아님).
4. CI 매트릭스 (mac + Linux) 양 하네스 green — Stage 11 Bundle 4 non-blocking #2 에서 forward.
5. `shellcheck -S style scripts/update_handoff.sh` CI 에서 green — Stage 11 Bundle 4 non-blocking #1 에서 forward.

전체 게이트는 `docs/05_qa_release/release_checklist.md` 참조.

---

## 4. 범위 경계

이 파일은 Stage 11 APPROVED 시점의 Bundle 1 + Bundle 4 **현재 shipped 표면** 을 커버. 범위 외:

- **SKILL.md Sec. 6 live tool-picker triple refresh** — Stage 11 에서 optional forward 로 플래그; Stage 12 housekeeping 중 실행되면 여기 post-hoc H5 시나리오 추가. v0.4 로 연기되면 Stage 13 release_checklist 에 기록.
- **tech_design Sec. 0 verbatim refresh** (AC.B1.8 강화) — Stage 11 에서 optional 로 플래그; SKILL.md 는 이미 verbatim 준수.
- **v0.4 기능** — 이 파일 범위 외.

---

## 5. 개정 이력

- v1 (2026-04-22, 세션 6 연속): Stage 12 초기 저작. EN primary; KO 페어는 R4 에 따라 같은 세션.
