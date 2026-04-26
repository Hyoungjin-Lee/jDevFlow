---
version: v0.6.2
stage: 3 (plan_review)
date: 2026-04-26
mode: Standard
status: review
reviewer: 김민교 (기획팀 책임연구원, Opus/high)
upstream: planning_01_org / planning_02_license / planning_03_slash / planning_04_handoffs / planning_05_selfedu
---

# jOneFlow v0.6.2 — Stage 3 Plan Review (planning_review)

> **상위:** `docs/02_planning_v0.6.2/planning_01_org.md` ~ `planning_05_selfedu.md` (Stage 2 drafter 5종)
> **상-상위:** `docs/01_brainstorm_v0.6.2/brainstorm.md` Sec.2/3/4/5/6/9 (Stage 1, 세션 23)
> **하위:** `docs/02_planning_v0.6.2/plan_final.md` (Stage 4 finalizer 안영이) → Stage 4.5 운영자 승인 게이트
> **선례 형식:** `docs/02_planning_v0.6/plan_review.md` (F-D1~F-D3 / F-2-a / F-5-a / F-n1~3) + `docs/02_planning_v0.6.1/plan_review.md` (F-N1-a~h / EC-1~10)
> 모드 근거: 5개 항목 모두 운영 정책·문서 구조 변경. 보안·결제·규제 대상 아님. Standard 유지. 단 일부 항목(F-EDU, F-04 hook 순서)이 Strict 영역 인접.

---

## Sec. 0. 리뷰 방식 및 발견 ID 규칙

5개 plan_draft를 1차 통독, 2차로 brainstorm Sec.2/3/4/5/6/9의 scope 항목에 1:1 매핑한 뒤, 3차로 항목 간 횡단 모순을 점검했다. 본 리뷰는 다음 세 종류 발견을 분리한다.

| 종류 | 의미 | 처리 |
|------|------|------|
| **정책 commit (F-EDU, F-ORG-D1, F-04-D1)** | plan_final 본문에 명시 결정 문장으로 흡수 필요. drafter 권한 밖 정책 결정. | finalizer가 명시 결정으로 박음. |
| **명시 추가 (F-XX-N)** | drafter 의도와 일치하나 문구·범위·측정 방법이 불충분. 한두 줄 보강. | finalizer가 plan_final 해당 위치에 한 줄 추가. |
| **Stage 5 이월 (F-XX-S5)** | Stage 3 단계에서 결정 불가. 기술 설계로 forward. | finalizer가 Sec. "이월" 표에 명시. |

발견 ID는 다음 패턴을 따른다.

- `F-ORG-N` — planning_01_org 항목 N번째 발견
- `F-LIC-N` — planning_02_license
- `F-SLA-N` — planning_03_slash
- `F-04-N` — planning_04_handoffs (선례 v0.6.1 F-N1 패턴 호환)
- `F-EDU-N` — planning_05_selfedu
- `F-X-N` — 횡단(cross-cutting) 발견. 2개 이상 항목에 걸침.
- `F-D<번호>` — 정책 commit 등급(선례 v0.6 F-D1/F-D2/F-D3 패턴). plan_final 본문에 결정 문장 박을 것.

---

## Sec. 1. 종합 평가

**판정: PASS_WITH_REVISIONS.**

5개 초안은 brainstorm Sec.2 scope 4개(조직/라이선스/슬래시/handoffs) + Sec.9 self-edu 1개를 빠짐없이 매핑하고, 각 항목의 변경 대상 파일·AC·리스크가 plan_draft 표준 골격을 충실히 따른다. Stage 2 롤백이 필요한 구조적 결함은 없다. 그러나 **핵심 정책 결정 3건**(F-EDU-D1: CLAUDE.md 슬림화 vs 조직도 인라인 충돌 / F-ORG-D1: 조직도 표 분리 정책 / F-04-D1: hook 순서 + active/preparing 동시성 정의)이 미결 상태로 finalizer에게 떠넘겨져 있고, AC 측정 가능성에서 5개 초안 모두 **자동 grep/wc/test 명령으로 즉시 판정 불가능한 항목**이 1~3개씩 잠복한다(F-ORG-3, F-LIC-2, F-SLA-1, F-04-2, F-EDU-1). 또한 횡단 측면에서 **planning_01과 planning_05가 각자 CLAUDE.md Sec.2.5를 다르게 다룬다**는 정면 충돌이 있다(F-X-1) — 같은 섹션을 한쪽은 50줄 추가, 다른 쪽은 슬림화 후 포인터로 축소. 이 충돌은 plan_final이 결정하지 않으면 Stage 8 구현자가 두 plan을 동시에 만족할 수 없다.

**Stage 4 plan_final 진행 조건:** 본 리뷰 Sec.7 종합표의 정책 commit 3건(F-EDU-D1, F-ORG-D1, F-04-D1)을 plan_final 본문 결정 문장으로 흡수, 명시 추가 N건(F-XX-N) 흡수, Stage 5 이월 N건은 "이월" 표에 명시. plan_draft 5종 자체는 Stage 2 스냅샷으로 보존(변경 이력 한 줄만 추가).

---

## Sec. 2. planning_01_org — 조직도 개편 정식 반영

### 2.1 강점

- **brainstorm Sec.3 5계층 트리를 verbatim 인용**(Sec.10 첨부)하여 Stage 8 구현자가 ASCII 트리를 재타이핑하지 않아도 됨. 들여쓰기·연결자 사고 가능성 차단.
- **모델/effort 배정 원칙을 별도 표(Sec.10)로 분리**해 페르소나 이름 변경과 배정 정책 변경이 독립적으로 관리되는 구조.
- **Sec.8 Q1**에서 planning_05와의 충돌을 drafter가 자체 식별 후 Stage 3 판단으로 위임 — 횡단 인식이 정상 작동.

### 2.2 이슈

#### F-ORG-D1 (정책 commit) — 조직도 본문을 CLAUDE.md 인라인할지, `docs/org_structure.md` 분리할지 결정

drafter Sec.6, Sec.8 Q2에서 명시적으로 미결 상태. planning_05_selfedu Sec.2가 "CLAUDE.md ~80줄 슬림화"를 단언했으므로 인라인 + 슬림화 동시 충족 불가능. 본 리뷰 Sec.6.1 F-X-1과 한 묶음으로 결정.

**제안 (plan_final 본문 정책 commit):** 조직도 5계층 ASCII 트리 + 페르소나 표는 `docs/operating_manual.md`(planning_05가 신설하는 매뉴얼)의 "조직도" 섹션으로 이동. CLAUDE.md Sec.2.5는 5~10줄로 축약하고 `docs/operating_manual.md#조직도`로 포인터. 양립 불가능을 분리로 해소.

**근거:**
1. CLAUDE.md ~80줄 슬림화는 brainstorm Sec.9에서 운영자가 명시 결정한 신규 정책. planning_01보다 상위 결정.
2. 페르소나 13명 표 + 모델/effort 원칙은 ~50줄 차지. 인라인 시 Sec.2.5 단독으로 60줄 이상 → CLAUDE.md ~80줄 한도 80% 잠식.
3. 조직도는 운영 매뉴얼의 일부로 분류해야 self-contained 교육 매체로 기능(brainstorm Sec.9 핵심).

#### F-ORG-1 (명시 추가) — AC-Org-3 측정 범위 명확화

AC-Org-3 "Sec.2.5 외 CLAUDE.md 정규 콘텐츠 변경 0줄"은 측정 범위가 자기-모순. F-ORG-D1을 받아들이면 CLAUDE.md는 Sec.2.5만이 아니라 **여러 섹션이 슬림화로 같이 변경**된다(Sec.3, Sec.4, Sec.7 등 포인터화). AC-Org-3은 planning_05의 슬림화와 충돌하므로 "Sec.2.5만 변경"이 아니라 "조직도 콘텐츠는 Sec.2.5에서 docs/operating_manual.md로 단일 경로 이동, 다른 섹션 변경은 planning_05 scope"로 재정의 필요.

#### F-ORG-2 (명시 추가) — AC-Org-2 "11명" vs 트리 "13명" 숫자 불일치

planning_01 Sec.5 AC-Org-2는 "총 11명 모두 모델과 effort 명시"로 적었으나 Sec.10 첨부 트리는 CEO 1 + CTO 1 + PM 1 + 기획 4 + 디자인 4 + 개발 7 = **18명**. drafter Sec.1의 본문은 "11명(미결 HR팀 제외)"이라 했으나 같은 Sec.1에서 "CEO 1 + CTO 1 + PM 1 + 팀 3 × 4명 = 13명"으로도 적힘 — 본문 자체에 11/13 두 숫자가 공존. 실제 트리는 개발팀이 백엔드 3 + 프론트 3 + 오케 1 = 7명이라 18명이 정답.

**제안:** AC-Org-2 문구 교체 — "**18명 전원**(CEO 1 / CTO 1 / PM 1 / 기획팀 4 / 디자인팀 4 / 개발팀 7) 모델·effort 명시. 누락 0." Sec.1 "13명" 표현도 "18명"으로 수정.

#### F-ORG-3 (명시 추가) — AC 자동 검증 가능성 보강

| AC | 현재 측정 방법 | 자동 판정 가능? | 보강 |
|----|--------------|----------------|------|
| AC-Org-1 | "들여쓰기·연결자 일관성" | 수동 시각 검사 | `python3 -c "import re; ..."` 또는 `awk`로 트리 라인 prefix 검증 |
| AC-Org-2 | "누락 페르소나 없음" | 수동 카운트 | `grep -c "(Opus\|Sonnet\|Haiku)" docs/operating_manual.md` ≥ 18 |
| AC-Org-3 | "Sec.2.5 외 정규 콘텐츠 변경 0줄" | `git diff` 수동 | F-ORG-1 적용 후 재정의 |
| AC-Org-4 | "HR팀 미결 표기 명확" | 시각 검사 | `grep -c 'HR' docs/operating_manual.md` ≥ 1 |
| AC-Org-5 | "배정 원칙 한 문단" | 수동 | grep 불가 → 시각 검사 명시 |
| AC-Org-6 | "settings.json 변환 가능 형식" | 수동 | F-ORG-S5(이월) |
| AC-Org-7 | "Sec.8 톤 규칙과 호환" | 수동 | grep 불가 → 시각 검사 명시 |

**제안:** AC 표 옆에 "측정: 자동/수동" 컬럼 추가, 자동 판정 가능 AC는 명령어 verbatim 박음.

#### F-ORG-S5 (Stage 5 이월) — settings.json 마이그레이션 샘플

AC-Org-6은 설계 문제이므로 Stage 5 기술 설계 범위. plan_final Sec. "이월"에 "AC-Org-6은 Stage 5에서 `stage_assignments` JSON 변환 샘플 1건 작성 후 검증" 명시.

### 2.3 AC 측정 가능성 종합

7개 AC 중 자동 grep/wc 검증 가능: AC-Org-2(보강 후), AC-Org-4(보강 후) — **2/7**. 나머지 5개는 시각 검사. plan_final이 자동/수동 컬럼을 박아 실제 검증 노력을 가시화해야 한다.

---

## Sec. 3. planning_02_license — Apache 2.0 라이선스 도입

### 3.1 강점

- **AC 10개가 모두 명령어 verbatim 또는 파일 라인 번호 명시** (`head -1 /LICENSE`, `sed -n '230,232p' README.md` 등). 본 5종 중 자동 검증성 최상.
- **Tertiary scope(소스 코드 boilerplate 검토)를 명시적으로 포함**해 누락 위험 차단.
- **R1(MIT 배포 이력 충돌)을 명확히 식별**하고 "외부 배포/PR 이력 없음(내부 개발 중)"이라는 사실 확인을 사전에 박음.

### 3.2 이슈

#### F-LIC-1 (명시 추가) — AC-Lic-5 라인 번호 정합성

drafter는 "README.md Line 230~232"를 박았으나 **현재 README.md의 실제 라인 위치는 v0.6.1 commit 이후 가변적**. planning 시점과 Stage 8 구현 시점 사이에 README.md가 다른 PR로 수정될 가능성 존재(예: planning_05의 docs/ 추가 안내, planning_03의 slash 사용법 추가 — AC-Slash-5와 연쇄). 절대 라인 번호 lock-in은 깨지기 쉬움.

**제안:** AC-Lic-5 측정 방법 교체 — `grep -n "Apache License 2.0.*LICENSE" README.md` exit 0. 라인 번호 대신 패턴 매칭으로 robust하게.

#### F-LIC-2 (명시 추가) — AC-Lic-4 "MIT 잔재 0" 측정 범위

`grep -i "MIT License" /LICENSE` → 0이라 했으나 LICENSE 파일은 새로 작성되므로 0이 자명. 진짜 의미는 **"리포 전체에서 MIT License 표현 잔재 0"**. README, README.ko, src/, scripts/ 모두 포함이 자연스러움. AC-Lic-8이 src/scripts에서 MIT 검사하나 README는 별도 측정 없음 → AC-Lic-5/6의 Apache 표기 검증과 별개로, "MIT" 잔재 grep이 README에 빠져 있다.

**제안:** AC-Lic-4 측정 범위 확장 — `grep -irn "MIT License\|MIT ©" . --exclude-dir=.git --exclude-dir=docs/01_brainstorm* --exclude-dir=docs/02_planning*` → 0 hits. 단, `docs/` 내 brainstorm/planning 문서는 역사적 기록이므로 제외(필요 시 plan_final에서 명시).

#### F-LIC-3 (명시 추가) — README.ko.md 존재 여부 확정

drafter Sec.2.1, AC-Lic-7 모두 "README.ko.md 존재 시"로 조건부. **planning 단계에서 사실 확인 가능한 항목을 미결로 두지 않을 것.** 현재 시점에 `ls README.ko.md` exit 1이면 AC-Lic-7 자체를 plan_final에서 삭제, exit 0이면 unconditional로 박음.

**제안:** plan_final에서 운영자가 `ls README.ko.md` 실행 결과를 박은 뒤 AC-Lic-7 confirm/skip 결정.

#### F-LIC-4 (명시 추가) — CHANGELOG.md 기록은 AC가 아니라 Sec.9 "릴리스 시 주의" 영역

drafter Sec.9는 CHANGELOG 기록을 언급하나 AC에 없음. Stage 8 구현자가 CHANGELOG 갱신을 빠뜨릴 위험. v0.6.1 N1 rename은 CHANGELOG에 명시 박혔으므로(commit `c6c0fe5` 이후) 본 라이선스 변경도 동급으로 박을 것.

**제안:** AC-Lic-11 추가 — "CHANGELOG.md에 v0.6.2 항목 + `feat(license): Apache 2.0 도입` 한 줄 기록. `grep -n 'Apache' CHANGELOG.md` ≥ 1."

#### F-LIC-5 (명시 추가) — SPDX header 정책 결정

drafter Sec.3.2는 SPDX Identifier `Apache-2.0`을 metadata에 박았으나 Sec.4 Task 5는 "MIT boilerplate 제거"만 언급. **MIT boilerplate를 Apache로 교체할지, SPDX-License-Identifier 한 줄로 일관할지** 정책 미결. 18명 페르소나가 향후 신규 파일 만들 때 헤더 형식 합의 필요.

**제안:** plan_final 정책 commit — "신규 .py/.sh 파일 헤더는 `# SPDX-License-Identifier: Apache-2.0` 1줄 표준. Apache 전문 boilerplate 미사용." 또는 그 반대 명시. F-D2급은 아니나 향후 일관성 영향 큼.

### 3.3 AC 측정 가능성 종합

10개 AC 중 자동 검증 가능: 1, 2, 3, 4(F-LIC-2 적용 후), 5(F-LIC-1 적용 후), 6, 7(조건부), 8, 10 — **9/10**. AC-Lic-9 "git diff 무관한 변경 없음"만 시각 검사. **5개 plan_draft 중 AC 자동성 최상.**

---

## Sec. 4. planning_03_slash — slash command 래퍼 3종

### 4.1 강점

- **각 셸 스크립트의 인자 시그니처를 verbatim 매핑**(Sec.4.2)해 Stage 8 drafter가 신규 인자 발명할 위험 차단.
- **Sec.7 위험 1**에서 Claude Code slash command spec의 미문서화를 사전에 식별하고, fallback(기존 bash 직접 호출 유지)을 명시.
- **AC-Slash-6 호환성 확인** — 기존 직접 호출 경로가 깨지지 않는다는 회귀 안전망.

### 4.2 이슈

#### F-SLA-1 (명시 추가) — AC-Slash-1~3은 "동작 확인"이지 자동 grep 불가

AC-Slash-1: "`bash scripts/init_project.sh` 호출 확인" — Claude Code 환경 안에서 slash command가 호출하는지 외부에서 grep으로 판정 불가능. 실제 검증 수단은 (a) `.claude/commands/init-project.md` 본문에 `bash scripts/init_project.sh` 문자열 포함 여부 grep, (b) Stage 12 QA에서 운영자 수동 호출 + stdout 확인. 두 가지가 분리되어야 함.

**제안:** AC-Slash-1~3을 둘로 쪼갬.
- **AC-Slash-1a** (자동) — `grep -F "bash scripts/init_project.sh" .claude/commands/init-project.md` exit 0
- **AC-Slash-1b** (수동) — Stage 12 QA: `/init-project` 입력 시 stdout에 `init_project.sh: ...` 출력 확인
- AC-Slash-2/3도 동일 패턴

#### F-SLA-2 (명시 추가) — `--auto` / `--resume` 플래그 vs 운영자 승인 게이트 충돌

`/ai-step --auto`는 "다음 approval gate까지 자동 진행". 그러나 CLAUDE.md Sec.3 "필수 협업 체크포인트"에 의하면 Stage 4 통과는 **운영자 승인 필수**. slash command가 Stage 4에서 자동으로 멈추는 보장이 본 plan_draft에 없음. brainstorm Sec.5의 ai_step.sh `--auto` 명세가 approval gate를 정확히 어디서 인식하는지가 미결.

**제안:** plan_final Sec.6 의존성에 "AC-Slash-3은 ai_step.sh의 approval gate 식별 로직(Stage 4·11)이 v0.6 구현에서 이미 작동함을 전제로 함. 미작동 시 본 항목 정상화 전까지 `/ai-step --auto`는 미공개." 명시.

#### F-SLA-3 (명시 추가) — `.claude/commands/` 폴더 vs `.claude/settings.json` 동거

planning_03이 신설하는 `.claude/commands/` 폴더와 기존 `.claude/settings.json`(stage_assignments)이 한 디렉토리 안에 공존. brainstorm Sec.5에서는 "`.claude/commands/` 폴더에 markdown 파일 추가"만 명시했으나, 본 plan은 settings.json과의 상호작용을 다루지 않음. 예: `/switch-team` 실행 → `bash scripts/switch_team.sh` → settings.json `team_mode` 갱신 → `.claude/commands/`의 다른 명령어가 즉시 영향받는가?

**제안 (Stage 5 이월, F-SLA-S5):** Stage 5 기술 설계에서 ".claude/commands/<cmd>.md frontmatter는 settings.json 필드 직접 참조 불가, bash 호출만 허용" 명시. (frontmatter에 `arguments` 동적 인용을 시도하면 spec 의존성 폭발.)

#### F-SLA-4 (명시 추가) — Sec.7 위험 1 "spec 불확정" mitigation은 사실상 Stage 5에 강요

drafter Sec.7 R1 완화책 ② "frontmatter 필드 모두 명시적 주석화"는 좋은 방향이나, **현 시점에서 Claude Code가 실제 인식하는 frontmatter 필드 목록**을 plan_draft가 답하지 않음. drafter Sec.4.1 "spec 조사" 단계가 Stage 8 구현 직전에야 수행되므로, plan_final에서 "AC-Slash-4 파일 구조 정확성"이 Stage 8 시작 시점까지 정의 불가능. 이는 AC를 plan으로 못 박지 못하는 상태.

**제안 (Stage 5 이월, F-SLA-S5):** Stage 5 기술 설계에서 spec 조사 → frontmatter 필드 확정 → AC-Slash-4 측정 명령(`yaml.safe_load`) 박음. plan_final은 "AC-Slash-4 세부 측정 방법은 Stage 5에서 확정" 명시.

#### F-SLA-5 (명시 추가) — README/문서화 AC 강제력

AC-Slash-5는 "선택사항이지만 권장". **"권장"은 AC가 아니다.** AC 정의상 필수 또는 비-AC. drafter가 강제력 의도를 모호하게 둠.

**제안:** AC-Slash-5 강제 + 1줄 측정 — `grep -c "/init-project\|/switch-team\|/ai-step" README.md` ≥ 3. 또는 AC에서 삭제하고 "Stage 12 문서화 권장사항"으로 강등.

### 4.3 AC 측정 가능성 종합

6개 AC 중 자동 검증 가능: AC-Slash-4(F-SLA-4 적용 후 부분), AC-Slash-5(F-SLA-5 강화 후), AC-Slash-6(grep 가능) — **3/6**. AC-Slash-1/2/3은 본질적으로 Stage 12 QA로 이월. plan_final Sec.4 단계 분해에 "AC-Slash-1~3은 Stage 12 QA 시 동작 확인" 명시 필요.

---

## Sec. 5. planning_04_handoffs — handoffs/ 폴더 구조

### 5.1 강점

- **Appendix A 확정 폴더 구조 + Appendix B frontmatter 필드 정의**가 brainstorm Sec.6 그림과 1:1 일치.
- **Sec.4.5/4.6에서 ai_step.sh / init_project.sh hook 위치를 verbatim 코드 블록으로 박음** — Stage 5/8 drafter가 삽입 위치를 재추론할 필요 없음.
- **Sec.7 R4(BSD vs GNU sed 호환성)** 사전 식별. v0.6.1 N1 N1-g(reflog/stale lock)와 같은 cross-platform 사고 패턴을 학습한 결과로 보임.

### 5.2 이슈

#### F-04-D1 (정책 commit) — `active/` 동시 다중 파일 동작 정의

Sec.5 AC-Hand-8 "병렬 스프린트 시나리오 검증: v0.6.1 진행 중 v0.6.2 `preparing` 상태 유지 가능 (두 파일 동시 존재)"가 박혀 있으나, **HANDOFF.md 심볼릭 링크는 단일 대상만 가리킴**. 두 파일이 active/에 동시 존재하면 R2 진입점은 어느 쪽을 보는가? brainstorm Sec.6도 모호.

선례: 현재 시점(2026-04-26) HANDOFF.md는 v0.6.1 본 릴리스 상태이고 v0.6.2 brainstorm + planning이 동시 진행 중. 즉 **이미 병렬 스프린트가 실행 중**임에도 HANDOFF.md는 v0.6.1만 가리킴. 이 사실 자체가 "active 1 + preparing N" 모델이 정답임을 시사. 그러나 plan_draft Appendix A의 트리 예시는 active/에 v0.6.2(active) + v0.6.3(preparing) 둘을 나열 → 모순.

**제안 (plan_final 정책 commit):** active/에 다음 두 status만 허용:
- `active` — 정확히 1개. HANDOFF.md symlink가 가리킴.
- `preparing` — 0~N개. R2 진입점 영향 없음. brainstorm/planning 진행 중인 차기 버전.
- `archived`는 active/에 미허용. 즉시 archive/로 이동.

frontmatter `status`의 3-state 정의를 plan_final 본문에 박고, `_init_handoff_active` hook이 새 버전 시작 시 **기존 active 파일을 preparing으로 강등할지, 그대로 유지할지** 결정. 후자가 자연스럽다(현 v0.6.1 active 유지 + v0.6.2 preparing 동시 존재 → v0.6.1 archive 시점에서야 v0.6.2를 active로 승격).

#### F-04-1 (명시 추가) — AC-Hand-2는 Stage 8 직후만 의미. Stage 13 후 깨짐

drafter Sec.4.5 hook은 Stage 13 완료 시 `rm -f HANDOFF.md`만 수행하고 다음 active 파일을 가리키지 않음(주석: "다음 버전으로 갱신할 때까지 현재 상태 유지"). 즉 archive 직후~next init 사이 구간에 HANDOFF.md symlink **부재 상태**가 발생. 이 구간에 R2 진입점은 깨진다.

**제안 (Stage 5 이월, F-04-S5a):** archive 시점에 HANDOFF.md를 다음 후보 active(=preparing 중 가장 높은 버전)로 자동 승격할지, 또는 의도적으로 부재 상태로 두고 운영자에게 "다음 버전 init 필요" 신호로 사용할지를 Stage 5에서 명시.

#### F-04-2 (명시 추가) — AC 측정 자동화 보강

| AC | 자동화 가능? | 보강 |
|----|------------|------|
| AC-Hand-1 | yes | `[ -d handoffs/active ] && [ -d handoffs/archive ]` |
| AC-Hand-2 | yes | `readlink HANDOFF.md \| grep -q "handoffs/active/HANDOFF_v"` |
| AC-Hand-3 | yes | `for f in handoffs/{active,archive}/*.md; do grep -q "^status:" "$f" \|\| echo "FAIL: $f"; done` exit 0 |
| AC-Hand-4 | partial | dry-run 실행 후 file 존재/symlink 검증 가능 |
| AC-Hand-5 | partial | 동일 패턴 |
| AC-Hand-6 | yes | `cat HANDOFF.md \| head -1` 출력 비교 |
| AC-Hand-7 | yes | `git log --follow -- handoffs/active/HANDOFF_v0.6.2.md` |
| AC-Hand-8 | F-04-D1 적용 후 측정 가능 |

**제안:** AC 표 옆에 "측정 명령" 컬럼 추가. AC-Hand-4/5는 hook이 dry-run 모드 지원 시 자동, 미지원 시 Stage 12 QA 수동.

#### F-04-3 (명시 추가) — Sec.4.5 hook의 sed 호환성

```bash
sed -i '' 's/status: active/status: archived/' "$active_file"
```

이는 BSD sed 문법(`-i ''`). GNU sed에서는 `-i` 단독. v0.6.1 R4에서 이미 식별. drafter Sec.7 R4에 완화책으로 lib/settings.sh 헬퍼 또는 Python 스크립트 제안되었으나 본 hook 코드 블록은 BSD sed 그대로 박혀 있음. Stage 8 drafter가 이 코드를 그대로 베끼면 Linux CI에서 깨짐.

**제안:** plan_final Sec.4.5/4.6 코드 블록 위에 `# NOTE: Stage 5에서 lib/settings.sh _frontmatter_set_field 헬퍼로 교체 예정` 주석 박음. 또는 코드 블록 자체를 의사 코드(`_frontmatter_set "$active_file" status archived`)로 추상화.

#### F-04-4 (명시 추가) — 기존 HANDOFF.archive.v0.3.md 처리

drafter Sec.4.4는 "기존 `HANDOFF.archive.v0.3.md` 검색"을 박았으나 **실측 결과(2026-04-26 기준):** `ls HANDOFF*.md` → `HANDOFF.archive.v0.3.md` + `HANDOFF.md` 2개만 존재. v0.4/v0.5/v0.6/v0.6.1 archive 파일은 미존재. drafter Appendix A는 v0.5.0/v0.6.0/v0.6.1 archive를 그렸으나 실제로 archive/에 들어갈 파일은 v0.3 1개뿐.

**제안:** plan_final Sec.4.4 측정 명령 박음 — `ls HANDOFF.archive.v*.md 2>/dev/null` 결과를 finalize 시점에 capture, plan_final에 verbatim 인용. Appendix A 트리 예시도 실측 파일명에 맞춰 수정.

#### F-04-5 (명시 추가) — git symlink 호환성 R3 + Windows R1 합집합 위험

R1(Windows symlink), R3(file→symlink 변환 시 git history) 두 위험이 분리되어 있으나, 실제로 **클론하는 사람의 환경**과 **저장하는 git 객체** 두 차원이 합쳐진 문제. git은 symlink를 blob `120000` mode로 저장하므로 Linux/macOS 클로너는 정상, Windows 클로너는 텍스트 파일로 받음(`core.symlinks = false` 기본). v0.6.1 N1과 같은 사고 학습이 부족.

**제안 (Stage 5 이월, F-04-S5b):** Stage 5에서 `.gitattributes`에 `HANDOFF.md symlink` 정의 추가, README.md/CLAUDE.md에 "Windows 환경 git clone 시 `git config --global core.symlinks true`" 가이드 박음. 또는 운영 매뉴얼(planning_05 산출물)에 "Windows 미지원, WSL 사용" 명시.

### 5.3 AC 측정 가능성 종합

8개 AC 중 자동 검증 가능: 1, 2, 3, 6, 7 — **5/8**. AC-Hand-4/5는 hook dry-run 미정의로 partial, AC-Hand-8은 F-04-D1 결정 필요. plan_final이 5/8을 8/8로 끌어올리려면 F-04-D1 + F-04-S5a 두 결정이 선행.

---

## Sec. 6. planning_05_selfedu — Self-Contained 교육 구조

### 6.1 강점

- **brainstorm Sec.9 6개 항목을 AC-Edu-2에 1:1 체크리스트로 박음** — drafter가 항목 검색을 자동화 가능하게 함.
- **AC-Edu-5 "글로벌 ~/.claude/CLAUDE.md 미수정 scope 보호"** 명시. brainstorm Sec.9가 글로벌 파일도 언급했으나 운영자 결정 게이트로 분리한 정책을 plan에서 한 번 더 박은 것은 안전 마진.
- **Sec.7 R1(절대 규칙 누락) / R2(읽기 순서 혼란) / R4(글로벌 무한 보류)** 식별로 self-edu의 본질적 위험(누락이 곧 보안 침해)을 인지.

### 6.2 이슈

#### F-EDU-D1 (정책 commit) — CLAUDE.md ~80줄 슬림화의 정확한 의미

AC-Edu-1 "CLAUDE.md ≤ 80줄"은 측정 가능하나 **정책 결정이 빠져 있다.** 현 시점 CLAUDE.md 300줄(실측 2026-04-26). 220줄 삭제 필요. 어떤 섹션을 통째로 docs/operating_manual.md로 옮길지 plan_final이 박지 않으면 Stage 8 구현자가 임의 판단.

**제안 (plan_final 본문 정책 commit):** CLAUDE.md ≤ 80줄 도달을 위한 **섹션 매핑 표**를 plan_final Sec. "CLAUDE.md 슬림 매핑"으로 박음. 예:

| CLAUDE.md 현 섹션 | 줄 수(현) | 처리 |
|------------------|---------|------|
| Sec.1 한 줄 요약 | ~10 | 유지 |
| Sec.2 도구 역할 | ~15 | 유지 (간략화) |
| Sec.2.5 조직도 (F-ORG-D1) | ~73 | docs/operating_manual.md#조직도로 이동 |
| Sec.3 워크플로우 규칙 | ~80 | docs/operating_manual.md#워크플로우로 이동, 포인터 5줄 |
| Sec.4 모델 선택 | ~30 | docs/operating_manual.md#모델 정책로 이동 |
| Sec.5 절대 규칙(보안) | ~20 | **유지** (절대 규칙은 인라인) |
| Sec.6 스크립트 실행 | ~10 | docs/operating_manual.md로 이동 |
| Sec.7 핵심 파일 | ~10 | 유지 (간략화) |
| Sec.8 코드 검증 | ~10 | docs/operating_manual.md로 이동 |
| **합계** | ~258 | **유지: ~75줄, 이동: ~183줄** |

이 매핑 없이 ≤80 수치만 박으면 Sec.5 "절대 규칙"을 실수로 옮기는 보안 사고 가능(R1).

**근거:**
1. Sec.5 절대 규칙(API키·secret_loader)은 R2 진입점에서 인라인 노출이 보안상 정답 — 운영 매뉴얼로 옮기면 한 단계 추가 read 필요해 누락 위험.
2. Sec.4 모델 선택 / Sec.3 워크플로우는 운영 매뉴얼에서 더 잘 정리됨(self-contained 교육 매체로서 적합).
3. F-ORG-D1과 동일 결정 — 조직도가 이동하는 곳(docs/operating_manual.md)이 워크플로우/모델과 같은 컨테이너.

#### F-EDU-1 (명시 추가) — AC-Edu-4 검증 시나리오 자동화 불가

AC-Edu-4 "백지 Claude로 docs/만 읽고 dispatch 1회 성공 검증 시나리오 정의(시나리오 문서화)" — **시나리오 문서화 자체는 grep 가능**(`ls docs/guides/whitebox_verification.md` exit 0)이나 **백지 Claude로 실제 dispatch 성공**은 새 Claude 세션 + 새 프로젝트 + 운영자 수동 검증을 요함. AC가 두 단계로 분리되어야 한다.

**제안:** AC-Edu-4 둘로 분리.
- **AC-Edu-4a** (자동) — `ls docs/guides/whitebox_verification.md` exit 0
- **AC-Edu-4b** (수동, Stage 12) — 백지 Claude 세션에서 시나리오 실행 후 dispatch 1회 PASS

#### F-EDU-2 (명시 추가) — bridge_protocol.md vs operating_manual.md 분리 경계

drafter Sec.4 Phase 1.2 "bridge_protocol.md 패턴 검토" + Sec.8 "docs/operating_manual.md vs bridge_protocol.md 경계는 자율 영역"으로 두 문서 사이의 경계 결정을 Stage 8 자율로 위임. 그러나 **bridge_protocol.md(219줄, 2026-04-26 세션 25 신설)는 이미 운영 프로토콜의 정수**. 동일 콘텐츠를 operating_manual.md에 중복 작성하면 self-edu 매체가 2개 → 운영자가 어느 쪽을 읽어야 할지 혼란(R2 재발).

**제안 (plan_final 정책 commit, F-EDU-D2 후보):**
- 옵션 A: bridge_protocol.md를 docs/operating_manual.md/bridge_protocol.md로 통합(폴더 구조). operating_manual.md는 인덱스 + 하위 문서 포인터.
- 옵션 B: bridge_protocol.md를 그대로 두고, operating_manual.md는 brainstorm Sec.9 6항목 중 bridge protocol을 제외한 5항목만 다룸. 운영 매뉴얼에서 bridge_protocol.md를 link.

본 리뷰자 권장: **옵션 B**. bridge_protocol.md는 사고 학습 결과물(세션 25 운영자 10번 강조)이라 정체성 강함. operating_manual.md가 흡수하면 사고 학습 컨텍스트 희석.

#### F-EDU-3 (명시 추가) — `init_project.sh` `cp -r docs/`의 부작용

Sec.4 Phase 2.6 "scaffold 실행 시 `cp -r docs/ $NEW_PROJECT/docs/` 추가" — 현 docs/는 약 50MB 추정(brainstorm/planning/구현/QA 모두 포함). 신규 프로젝트마다 이 전부를 복사하는 것은 R3에서 식별되었으나 완화책이 "선택적 복사 옵션 고려(--with-docs 플래그)"로 모호.

또한 더 중요한 문제: **신규 프로젝트는 jOneFlow 자체 brainstorm/planning 이력을 받을 필요가 없다.** 받아야 하는 것은 self-edu 매뉴얼(operating_manual.md, bridge_protocol.md, guides/)뿐. 현재 docs/01_brainstorm_v0.6.2/ 같은 jOneFlow 자체 산출물은 신규 프로젝트와 무관.

**제안 (plan_final 정책 commit, F-EDU-D3 후보):** 복사 대상을 명시 — `docs/operating_manual.md` + `docs/bridge_protocol.md` + `docs/guides/` 만 복사. brainstorm/planning/구현/QA 디렉토리는 제외. 또는 **운영 매뉴얼 전용 폴더 `docs/manual/`** 신설하고 그것만 복사.

#### F-EDU-4 (명시 추가) — AC-Edu-7 "R2 순서 명시"의 측정

AC-Edu-7 "docs/ 매뉴얼이 운영자가 매 세션 진입 시 읽을 수 있도록 R2 순서 명시" — 측정 명령 미정의. CLAUDE.md 1줄에 "R2 순서: ..." 텍스트가 있어야 grep 가능.

**제안:** 측정 명령 — `grep -c "R2.*순서\|읽기 순서" docs/operating_manual.md` ≥ 1 + `grep -c "operating_manual" CLAUDE.md` ≥ 1.

#### F-EDU-5 (명시 추가) — AC-Edu-2 6항목 grep 패턴 정의

AC-Edu-2는 6개 토픽 포함 검증을 박았으나 grep 패턴 미정의. 운영 매뉴얼이 길면 토픽 누락 자동 검출 어려움.

**제안:** AC-Edu-2 측정 명령 verbatim 박음.
```bash
for kw in "3-tier\|3계층" "브릿지 프로토콜" "자율.*승인 게이트" "페르소나" "Stage 1.*13\|Lite.*Standard" "MANDATORY STARTUP"; do
  grep -q "$kw" docs/operating_manual.md || echo "MISS: $kw"
done
```
exit 0 + 미스 0줄.

### 6.3 AC 측정 가능성 종합

7개 AC 중 자동 검증 가능: AC-Edu-1, AC-Edu-2(F-EDU-5 보강 후), AC-Edu-3, AC-Edu-4a(F-EDU-1 분리 후), AC-Edu-5, AC-Edu-6, AC-Edu-7(F-EDU-4 보강 후) — **7/7**. **단 F-EDU-D1 정책 commit이 선행되어야 AC-Edu-1의 의미가 확정된다.**

---

## Sec. 7. 횡단(cross-cutting) 이슈

5개 plan_draft 사이의 모순/중복/순서 의존을 발견.

### 7.1 F-X-1 (정책 commit, 최우선) — CLAUDE.md Sec.2.5의 분기 충돌

| plan | 의도 | 결과 |
|------|------|------|
| planning_01 Sec.5 AC-Org-3 | "Sec.2.5 외 정규 콘텐츠 변경 0" + Sec.2.5에 5계층 트리 + 18명 표 인라인(~50줄 추가) | CLAUDE.md ~258 → ~308줄 |
| planning_05 AC-Edu-1 | "CLAUDE.md ≤ 80줄" + 조직도는 docs/operating_manual.md로 이동 가정 | CLAUDE.md ~258 → ~75줄 |

**두 plan 동시 만족 불가능.** Stage 8 구현자가 어느 쪽을 우선할지 결정 못 함. 본 리뷰는 F-ORG-D1 + F-EDU-D1을 합쳐 단일 결정으로 통합 권고.

**제안 (plan_final 본문 단일 정책 commit):**
- 조직도 5계층 트리 + 18명 페르소나 표는 **`docs/operating_manual.md#조직도` 단독 위치**에 거주.
- CLAUDE.md Sec.2.5는 5~10줄로 축약 + `docs/operating_manual.md#조직도` 포인터.
- AC-Org-3는 "Sec.2.5 인라인 콘텐츠는 organic 매뉴얼 포인터로 교체, 다른 섹션 변경은 planning_05 scope" 재정의.
- AC-Edu-1 "≤ 80줄"은 F-EDU-D1 슬림 매핑 표를 따른 결과로 자연 만족.

### 7.2 F-X-2 (정책 commit) — HANDOFF.md symlink와 R2 진입점

선례(2026-04-26 실측):
- `HANDOFF.md` 존재 — file (symlink 아님)
- `HANDOFF.archive.v0.3.md` 존재 — file
- `handoffs/` 디렉토리 미존재

planning_04는 HANDOFF.md → symlink 전환을 박았다. 그러나 **bridge_protocol.md(2026-04-26 세션 25 신설)와 CLAUDE.md R2 읽기 순서**는 "CLAUDE.md → bridge_protocol.md → HANDOFF.md → ..."로 정의됨. HANDOFF.md를 symlink로 바꾸면 R2 순서 자체는 깨지지 않으나, **bridge_protocol.md가 handoffs/ 폴더 구조를 모르는 채 작성되었다**(2026-04-26 세션 25 시점에서 v0.6.2 planning 미완성).

**제안 (Stage 5 이월, F-X-S5):** Stage 5에서 bridge_protocol.md에 "v0.6.2부터 HANDOFF.md는 handoffs/active/HANDOFF_v<X>.md를 가리키는 symlink. 직접 편집 금지. 편집 대상은 symlink target." 한 줄 추가. planning_04 Sec.5 AC-Hand-6에 bridge_protocol.md 갱신 검증 추가 권장.

### 7.3 F-X-3 (명시 추가) — planning_03 slash command + planning_04 hook 결합

`/ai-step` slash command는 ai_step.sh를 호출. planning_04는 ai_step.sh에 Stage 13 archive hook을 추가. **두 plan이 Stage 8에서 동시 구현되면 hook이 slash command 경로에서도 실행되는지 검증 필요.**

또한 `/init-project`는 init_project.sh를 호출. planning_04는 init_project.sh에 새 active 파일 생성 hook을 추가. `/init-project --no-prompt` 시 hook이 frontmatter `mode` 필드에 무엇을 넣을지 미정.

**제안 (Stage 5 이월, F-X-S5b):**
- Stage 5에서 ai_step.sh 수정 시 hook 추가 후 회귀 테스트 — `/ai-step --auto`로 호출했을 때도 archive hook 정상 동작 확인.
- Stage 5에서 init_project.sh `--no-prompt` 모드의 frontmatter `mode` 기본값을 "Standard"로 박음(brainstorm 기본 정책 따름).

### 7.4 F-X-4 (명시 추가) — 18명 페르소나 가동과 stage_assignments 동기화

planning_01은 5계층 18명 페르소나를 `.claude/settings.json` `stage_assignments` 필드로 변환 가능성을 AC-Org-6에 박음. 그러나 **현 settings.json schema(v0.4)는 Stage 단위 배정**(stage8_impl, stage11_validate 등)이고, **18명 페르소나는 Role 단위**(드래프터/리뷰어/파이널리즈/오케). 매핑이 N:1 또는 1:N — 단순 변환 불가.

또한 brainstorm Sec.3은 v0.6 세션 16 A/B 실험 결과 "팀 모드 3종이 stage_assignments로 환원" 결정을 박았으나, 18명 페르소나는 그 위 추상층. 두 층 사이 어댑터가 plan_final에 명세되지 않았다.

**제안 (Stage 5 이월, F-X-S5c):** Stage 5에서 settings.json schema v0.5 제안 — `personas` 필드 추가, `stage_assignments`는 `persona_id` 참조. 또는 페르소나는 매뉴얼 문서(operating_manual.md)에만 살고 settings.json은 Stage 단위 유지(현 v0.4 schema 보존). 후자가 단순.

### 7.5 F-X-5 (명시 추가) — bridge_protocol.md vs operating_manual.md 통합 정책

F-EDU-2와 같은 결정이나 횡단 측면에서 재진술. bridge_protocol.md는 v0.6.1 세션 25에서 "회의창 영구 지침"으로 신설된 219줄 문서. operating_manual.md(planning_05 신설)와의 관계가 명확하지 않으면 **R2 진입점이 두 매체로 분기**되어 self-edu 단일 매체 원칙(brainstorm Sec.9) 위배.

**제안:** F-EDU-2 옵션 B 채택 — bridge_protocol.md 독립 보존, operating_manual.md는 link만. CLAUDE.md R2 순서는 "CLAUDE.md → bridge_protocol.md → docs/operating_manual.md → handoffs/active/HANDOFF_v<X>.md"로 명시.

### 7.6 F-X-6 (명시 추가) — Apache 2.0 라이선스 헤더 vs 신규 파일 폭증

planning_02는 라이선스 변경 + 소스 boilerplate 검토. planning_03은 `.claude/commands/<3개>.md` 신규. planning_04는 `handoffs/<active,archive>/<N개>.md` 신규. planning_05는 `docs/operating_manual.md` 신규(500줄 이상 예상). **신규 파일 ≥ 5개에 라이선스 헤더 정책 어떻게 적용?**

**제안:** F-LIC-5 결정과 일치 — markdown 파일은 라이선스 헤더 미적용(SPDX 정책 .py/.sh만). plan_final에 명시.

### 7.7 F-X-7 (Stage 5 이월) — 작업 순서 그래프

5개 plan은 "독립 가능"이라 주장하나 실제 의존성:

```
planning_02 (LICENSE) ──┬─→ 독립
                        │
planning_01 (조직도) ───┴─→ planning_05 (selfedu) ─→ CLAUDE.md 슬림 + operating_manual.md
                            │
planning_04 (handoffs) ─────┘─→ ai_step.sh / init_project.sh hook
                            │
planning_03 (slash) ────────┴─→ .claude/commands/ + ai_step.sh / init_project.sh
```

**사이클 없음**(DAG). 그러나 **planning_05는 planning_01의 정식 조직도를 흡수**하므로 planning_01보다 후행. **planning_03은 planning_04의 hook을 회귀 테스트**해야 하므로 후행.

**제안:** plan_final Sec. "구현 순서"에 다음 순서 박음.
1. planning_02 (독립, 가장 먼저 또는 마지막)
2. planning_01 (조직도 → operating_manual.md 거주처 결정)
3. planning_05 (CLAUDE.md 슬림 + operating_manual.md 작성, 조직도 흡수)
4. planning_04 (handoffs/ 구조 + hook)
5. planning_03 (slash command, planning_04 hook 검증 후)

### 7.8 F-X-8 (명시 추가) — brainstorm Sec.2 scope 4개 vs planning 5개

brainstorm Sec.2 표는 4개 항목(조직도/라이선스/슬래시/handoffs). selfedu(brainstorm Sec.9)는 표에 없으나 본 5개 planning 중 하나. **scope 표를 사후 갱신하지 않으면 다음 세션이 brainstorm Sec.2만 보고 selfedu를 누락할 위험.**

**제안:** plan_final 작성 시 brainstorm Sec.2 표를 5개로 확장한 사본을 plan_final 첫 섹션에 박음. brainstorm.md 자체는 Stage 1 스냅샷으로 보존.

---

## Sec. 8. 개정 제안 종합표

본 리뷰 발견은 모두 **plan_final.md에서 흡수**. plan_draft 5종은 Stage 2 스냅샷으로 보존(변경 이력 한 줄만 추가).

| ID | 항목 | 유형 | 위치 | 요지 |
|----|------|------|------|------|
| **F-EDU-D1** | 05_selfedu / 횡단 | **정책 commit** | plan_final 본문 + Sec.6.2 | CLAUDE.md ≤80줄 슬림 매핑 표 박음. Sec.5 절대 규칙 인라인 보존, 나머지 docs/operating_manual.md로 이동. |
| **F-ORG-D1** | 01_org / 횡단 | **정책 commit** | plan_final 본문 + Sec.2 | 조직도 5계층 + 18명 표는 docs/operating_manual.md#조직도 단독 거주. CLAUDE.md Sec.2.5 5~10줄 + 포인터. F-EDU-D1과 합쳐 단일 결정. |
| **F-04-D1** | 04_handoffs | **정책 commit** | plan_final 본문 + Sec.4 | active/ 동시성 규칙 박음 — active 정확히 1개 + preparing N개 + archived 즉시 archive/로 이동. HANDOFF.md symlink는 active 1개만 가리킴. |
| F-ORG-1 | 01_org | 명시 추가 | AC-Org-3 | Sec.2.5만 변경 → "조직도 콘텐츠 단일 경로 이동" 재정의. |
| F-ORG-2 | 01_org | 명시 추가 | AC-Org-2 + Sec.1 | 11명/13명 → 18명 통일. |
| F-ORG-3 | 01_org | 명시 추가 | AC 표 | "측정: 자동/수동" 컬럼 추가, 자동 가능 AC 명령어 verbatim. |
| F-ORG-S5 | 01_org | Stage 5 이월 | plan_final 이월 표 | AC-Org-6 settings.json 변환 샘플은 Stage 5에서. |
| F-LIC-1 | 02_license | 명시 추가 | AC-Lic-5 | 라인 번호 lock-in → 패턴 매칭. |
| F-LIC-2 | 02_license | 명시 추가 | AC-Lic-4 | MIT 잔재 grep 범위 LICENSE 파일 → 리포 전체(brainstorm/planning 제외). |
| F-LIC-3 | 02_license | 명시 추가 | AC-Lic-7 | README.ko.md 존재 여부 finalize 시점 확정 후 confirm/skip. |
| F-LIC-4 | 02_license | 명시 추가 | AC 신규 | AC-Lic-11 — CHANGELOG 갱신 강제. |
| F-LIC-5 | 02_license / 횡단 | 명시 추가 | plan_final 정책 | SPDX header 정책 — .py/.sh만 SPDX 1줄, .md는 미적용. |
| F-SLA-1 | 03_slash | 명시 추가 | AC-Slash-1~3 | 각 AC를 자동(grep)/수동(QA) 두 단계로 분리. |
| F-SLA-2 | 03_slash | 명시 추가 | Sec.6 의존성 | `/ai-step --auto` approval gate 식별 의존성 명시. |
| F-SLA-3 | 03_slash | 명시 추가 | Sec.2 범위 | `.claude/commands/` ↔ settings.json 결합 범위 박음. |
| F-SLA-4 | 03_slash | Stage 5 이월 | plan_final 이월 표 | frontmatter 필드 spec 조사 후 AC-Slash-4 측정 확정. |
| F-SLA-5 | 03_slash | 명시 추가 | AC-Slash-5 | "권장" 모호 → 강제 + grep 측정 또는 비-AC 강등. |
| F-04-1 | 04_handoffs | 명시 추가 | Sec.4.5 hook | archive 후 HANDOFF.md 부재 구간 R2 진입점 깨짐 — preparing 승격 정책 결정. |
| F-04-2 | 04_handoffs | 명시 추가 | AC 표 | "측정 명령" 컬럼 추가, AC-Hand-1/2/3/6/7 자동 명령 박음. |
| F-04-3 | 04_handoffs | 명시 추가 | Sec.4.5/4.6 코드 | BSD sed 코드 → 의사 코드 또는 lib/settings.sh 헬퍼 사용 주석. |
| F-04-4 | 04_handoffs | 명시 추가 | Sec.4.4 + Appendix A | 실측 archive 파일 1개(v0.3)만 — Appendix A 트리 수정. |
| F-04-S5a | 04_handoffs | Stage 5 이월 | plan_final 이월 표 | archive 후 HANDOFF.md 승격/부재 정책 Stage 5 결정. |
| F-04-S5b | 04_handoffs | Stage 5 이월 | plan_final 이월 표 | .gitattributes + Windows symlink 가이드 Stage 5에서. |
| F-EDU-1 | 05_selfedu | 명시 추가 | AC-Edu-4 | 자동(시나리오 문서 존재)/수동(백지 Claude QA) 분리. |
| F-EDU-2 | 05_selfedu / 횡단 | 명시 추가 (또는 정책) | plan_final 정책 | bridge_protocol.md ↔ operating_manual.md 분리 — 옵션 B 권장(독립 보존 + link). |
| F-EDU-3 | 05_selfedu | 명시 추가 (또는 정책) | Sec.4 Phase 2.6 | init_project.sh `cp -r docs/` 대상 명시 — docs/operating_manual.md + bridge_protocol.md + guides/ 만. brainstorm/planning 제외. |
| F-EDU-4 | 05_selfedu | 명시 추가 | AC-Edu-7 | R2 순서 명시 측정 명령 박음. |
| F-EDU-5 | 05_selfedu | 명시 추가 | AC-Edu-2 | 6항목 grep 패턴 verbatim. |
| F-X-1 | 횡단 | **F-EDU-D1+F-ORG-D1 통합** | plan_final 본문 | CLAUDE.md Sec.2.5 분기 충돌 단일 결정. |
| F-X-2 | 횡단 | Stage 5 이월 | plan_final 이월 표 | bridge_protocol.md에 handoffs/ symlink 정책 추가 Stage 5. |
| F-X-3 | 횡단 | Stage 5 이월 | plan_final 이월 표 | slash + hook 결합 회귀 테스트 Stage 5. |
| F-X-4 | 횡단 | Stage 5 이월 | plan_final 이월 표 | 18명 페르소나 ↔ settings.json schema 어댑터 — 단순 보존(현 v0.4 유지) 권장. |
| F-X-5 | 횡단 | F-EDU-2 동일 결정 | plan_final 정책 | bridge_protocol.md 독립 + operating_manual.md link. |
| F-X-6 | 횡단 | F-LIC-5 동일 결정 | plan_final 정책 | .md 파일 라이선스 헤더 미적용. |
| F-X-7 | 횡단 | Stage 5 이월 | plan_final 이월 표 | 작업 순서: 02 → 01 → 05 → 04 → 03. |
| F-X-8 | 횡단 | 명시 추가 | plan_final 첫 섹션 | brainstorm Sec.2 4개 → plan_final이 5개 scope 표 다시 박음(selfedu 포함). |

**유형 breakdown:**
- **정책 commit: 3건** (F-EDU-D1, F-ORG-D1, F-04-D1; F-X-1은 앞 둘의 통합)
- **명시 추가: 21건** (F-ORG-1/2/3, F-LIC-1~5, F-SLA-1/2/3/5, F-04-1/2/3/4, F-EDU-1/2/3/4/5, F-X-8)
- **Stage 5 이월: 7건** (F-ORG-S5, F-SLA-4, F-04-S5a/S5b, F-X-2, F-X-3, F-X-4, F-X-7) → 사실상 8건이나 F-X-3는 가시 분류상 명시 추가 + 이월 둘 모두

**총 발견 수: 31건** (정책 3 + 명시 21 + Stage 5 이월 7).

---

## Sec. 9. Q (운영자 결정 필요 사항)

본 리뷰 발견 중 **drafter/finalizer 권한 밖, 운영자 명시 결정이 필요한 항목**:

| Q | 결정 항목 | 본 리뷰 권장 | 결정 시점 |
|---|---------|------------|----------|
| **Q1** | **글로벌 ~/.claude/CLAUDE.md scope 처리** — brainstorm Sec.9 마지막 단락이 "글로벌 ~/.claude/CLAUDE.md ~30줄(MANDATORY RULE + 브릿지 절대 규칙)"을 언급. planning_05 AC-Edu-5는 이 영역을 명시적으로 scope 외로 박음. | v0.6.3 이월 또는 v0.6.2 + α로 별건 처리. 본 v0.6.2 plan_final에서 명시적으로 "v0.6.3 이월" 박을 것. | **Stage 4 운영자 승인** |
| **Q2** | **README.md / README.ko.md 라이선스 뱃지 변경 범위** — Apache 2.0 도입 시 README 상단 shields.io 라이선스 뱃지 갱신 여부. drafter 미언급. | Q1과 동급으로 plan_final에서 결정. README 뱃지 변경 시 AC-Lic-5 + 신규 AC-Lic-12 추가. | **Stage 4 finalizer + 운영자** |
| **Q3** | **bridge_protocol.md ↔ operating_manual.md 통합 정책** (F-EDU-2 / F-X-5) — 옵션 A(통합) vs 옵션 B(독립 + link). 본 리뷰는 옵션 B 권장. | 옵션 B. bridge_protocol.md는 사고 학습 결과물 정체성 보존. | **Stage 4 운영자 승인** |
| **Q4** | **백업 브랜치 / handoffs/ archive 보존 기간** — v0.6.1 N1에서 백업 브랜치 1주일 보존 정책 박음(F-N1-a). v0.6.2 handoffs/archive/는 영구 vs 보존 기간? | 영구 보존(브랜치와 달리 archive는 history 보존이 본 목적). plan_final Sec. "보존 정책" 명시. | **Stage 4 finalizer** |
| **Q5** | **18명 페르소나 가동 vs 현재 4명 페르소나 가동** — 본 v0.6.2 stage 234가 4명(준혁/민지/태원/지영) 가동 중(HANDOFF.md). 18명 정식 가동 시점은 v0.6.2 완료 후? | v0.6.2 완료 후 v0.6.3 또는 별건 세션에서 18명 가동. 본 v0.6.2 plan_final 본문에 "18명 페르소나는 운영 매뉴얼에 정의, 실제 가동은 후속 버전" 명시. | **Stage 4 운영자 승인** |
| **Q6** | **Apache 2.0 + 기존 v0.6.1 외부 PR/Fork 잔존 확인** — drafter Sec.1.2가 "외부 배포/PR 이력 없음"을 적었으나 미확인. GitHub network graph 확인 필요. | 운영자가 GitHub UI에서 확인 후 plan_final에 결과 박음. fork ≥ 1이면 Apache 도입을 v0.7로 미루거나 dual-license 검토. | **Stage 4 운영자 승인** |
| **Q7** | **CLAUDE.md ~80줄 슬림 후 docs/operating_manual.md 권장 분량** — 단일 파일 ≤ 1000줄 vs 분할. F-EDU-D1 매핑 표가 ~183줄 이동 + 신규 콘텐츠(brainstorm Sec.9 6항목)이 합쳐 500~800줄 예상. | 단일 파일 ≤ 1000줄 유지. 초과 시 docs/manual/ 폴더로 분할(Stage 5 결정). plan_final은 단일 파일로 시작 명시. | **Stage 4 finalizer** |

**Q1, Q3, Q5, Q6은 운영자 명시 결정 필수. Q2, Q4, Q7은 finalizer 결정 가능 후 운영자 confirm.**

---

## Sec. 10. 판정

**Plan Draft 5종 구조적으로 건전.** Stage 2 롤백 불요. Stage 4 plan_final은 본 리뷰 Sec.8 종합표 31건 개정을 흡수한 단일 문서로 진행.

| 항목 | 판정 |
|------|------|
| planning_01_org | PASS_WITH_REVISIONS (F-ORG-D1 정책 commit + 명시 3건 + 이월 1건) |
| planning_02_license | PASS_WITH_REVISIONS (정책 commit 0 + 명시 5건) |
| planning_03_slash | PASS_WITH_REVISIONS (정책 commit 0 + 명시 4건 + 이월 1건) |
| planning_04_handoffs | PASS_WITH_REVISIONS (F-04-D1 정책 commit + 명시 4건 + 이월 2건) |
| planning_05_selfedu | PASS_WITH_REVISIONS (F-EDU-D1 정책 commit + 명시 5건) |
| 횡단(cross-cutting) | PASS_WITH_REVISIONS (F-X-1 정책 commit 통합 + 명시 1건 + 이월 4건) |

**plan_final 진행 조건:**
1. **정책 commit 3건(F-EDU-D1, F-ORG-D1, F-04-D1)이 plan_final 본문 결정 문장으로 흡수.** F-X-1은 F-EDU-D1+F-ORG-D1의 통합 결정으로 단일 정책 문장 가능.
2. **운영자 결정 Q1/Q3/Q5/Q6 4건**이 Stage 4 승인 게이트에서 답변. 답변 결과를 plan_final 본문에 박음.
3. **명시 추가 21건**이 plan_final 해당 위치(AC 표 / Sec.4 단계 분해 / Sec.6 의존성 등)에 한 줄씩 흡수.
4. **Stage 5 이월 7건**이 plan_final Sec. "이월" 표에 명시.
5. **brainstorm Sec.2 scope 표 5개로 확장**한 사본을 plan_final 첫 섹션에 박음(F-X-8).
6. plan_draft 5종은 Stage 2 스냅샷으로 보존, 변경 이력 한 줄만 추가("Stage 3 review에서 31건 개정 식별, plan_final로 forward").

---

## Sec. 11. 본 리뷰가 다루지 않는 것

- 5개 plan_draft의 코드 수준(셸 스크립트 hook 정확성, frontmatter YAML 파싱 등) → **Stage 9 코드 리뷰**.
- Apache 2.0 전문 텍스트 정확성 byte 단위 비교 → **Stage 9**.
- `.claude/commands/<cmd>.md` frontmatter spec 조사 → **Stage 5 기술 설계**.
- ai_step.sh / init_project.sh hook 삽입 정확한 함수 위치 → **Stage 5**.
- 글로벌 ~/.claude/CLAUDE.md 수정 — **본 v0.6.2 scope 외 (Q1)**.
- 18명 페르소나 실제 가동 — **본 v0.6.2 scope 외 (Q5)**.
- 고위험 독립 검증 → 본 작업은 Standard, Stage 11 대상 아님.

---

## Sec. 12. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v1 — Stage 3 리뷰 작성 | reviewer 김민교(Opus/high). 5개 plan_draft 일괄 리뷰. 정책 commit 3 + 명시 추가 21 + Stage 5 이월 7 = **31건** + 운영자 결정 Q 7건. plan_final로 forward. |

---

## 다음 스테이지 — Stage 4 Plan Final 진입 지시 (finalizer 안영이)

본 리뷰 **Sec.8 개정 제안 종합표 31건**을 흡수한 **단일 문서**로 `docs/02_planning_v0.6.2/plan_final.md`를 작성한다.

- **정책 commit 3건(F-EDU-D1, F-ORG-D1, F-04-D1)**은 plan_final 본문 명시 결정 문장으로 박음. F-X-1(=F-EDU-D1+F-ORG-D1)은 단일 통합 결정 문장 권장.
- **운영자 결정 Q1/Q3/Q5/Q6 4건**은 Stage 4 승인 게이트에서 답변, 그 답을 plan_final에 verbatim 박음. **승인 없이 Stage 5 진입 금지.**
- **명시 추가 21건**은 5개 plan_draft 해당 위치 매핑한 단일 plan_final에서 한 줄씩 보강.
- **Stage 5 이월 7건**은 plan_final Sec. "Stage 5 이월" 표에 명시.
- **brainstorm Sec.2 scope 표를 5개로 확장**(selfedu 포함)한 사본을 plan_final 첫 섹션에 박음.
- plan_draft 5종은 Stage 2 스냅샷으로 보존. 변경 이력 한 줄만 추가("Stage 3 review 31건 개정 식별, plan_final로 forward").

Stage 4 완료 후 운영자 승인 게이트(Stage 4.5) — 승인 전까지 Stage 5 진입 금지. **운영자 결정 Q 4건이 모두 답변되어야 승인 가능.**
