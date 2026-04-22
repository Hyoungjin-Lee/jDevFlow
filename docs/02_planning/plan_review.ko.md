# 🔍 Stage 3 — Plan Review (jOneFlow v0.3) (한국어)

> **날짜:** 2026-04-22 (세션 3)
> **언어:** EN 원본 (한국어 번역: `plan_review.md`의 페어 파일)
> **모드:** Strict-hybrid
> **상위:** `docs/02_planning/plan_draft.md` (v1, 세션 2)
> **하위:** `plan_final.md` (Stage 4) → Stage 4.5 사용자 승인 게이트
> **리뷰어:** Claude (같은 세션 내 셀프 리뷰; Stage 11은 별도의 fresh 세션 독립 검증)

---

## 0. 리뷰 방식

`plan_draft.md`의 Sec. "Next Stage" 블록에 기록된 **4개의 포커스 질문**에 대한 Stage 3 셀프 리뷰다.

1. **(a) 커버리지** — Sec. 3 Deliverables가 kickoff goals 5 / 7 / 9 / 10 / 11 / 12을 중복 없이 커버하는가?
2. **(b) Top-3 리스크** — Sec. 5의 top-3 리스크가 진짜 top-3인가 (작성 편의로 고른 게 아닌가)?
3. **(c) 오픈 퀘스천 격리** — Sec. 7의 OQ들을 모두 Stage 5 내부에서 답할 수 있는가, 아니면 Stage 4로 역류하는 게 있는가?
4. **(d) KO 동기화** — Stage 3 시작 시점에 `plan_draft.ko.md`가 `plan_draft.md`와 동기화돼 있는가?

Stage 3 범위 **밖** (Stage 5 / Stage 11로 이월):

- 구체적 모듈 경계, SKILL.md 스키마, 셸 스크립트 플래그 — `technical_design.md`에서 다룸.
- 코드 수준 리뷰 — Stage 9.
- 전체 범위의 독립 검증 — Stage 11 fresh 세션.

---

## 1. 포커스 (a) — Deliverables × kickoff goals 커버리지

### 1-1. 매핑 점검

| Kickoff goal | Bundle | Primary deliverable | 보조 / 지원 | 상태 |
|--------------|--------|---------------------|-------------|------|
| **5** — HANDOFF 자동 작성기 | 4 | D4.a `scripts/update_handoff.sh` | (D4.x1 template을 target form으로 사용) | ✅ 1:1 |
| **7** — tool-picker 스킬 파일 | 1 | D1.a `.skills/tool-picker/SKILL.md` | — | ✅ 1:1 |
| **9** — CHANGELOG | 4 | D4.b `CHANGELOG.md` + 유지 규칙 | 규칙은 `CONTRIBUTING.md` 내 | ✅ 1:1 |
| **10** — 커뮤니티 문서 분리 | 4 | D4.c `CONTRIBUTING.md` + `CODE_OF_CONDUCT.md` | — | ✅ 1:1 |
| **11** — 추천 로직 | 1 | D1.b SKILL.md 내 추천 로직 섹션 | D4.x2–x4 구조 소비 | ✅ 1:1 |
| **12** — 워크드 예시 | 1 | D1.c SKILL.md 내 예시 블록 | — | ✅ 1:1 |

**결과:** 6개 kickoff goal 모두 정확히 하나의 primary deliverable에 매핑. 이중 커버 없음, 고아 goal 없음.

### 1-2. 발견 F-a1 — `CONTRIBUTING.md` 파일 소유권 모호함 (경미)

`CONTRIBUTING.md`는 **두 개의 deliverable에 등장**한다:

- **D4.b** (goal 9) — CHANGELOG 유지 규칙이 위치하는 곳.
- **D4.c** (goal 10) — 커뮤니티 문서 분리의 **독립 산출물**.

이는 **goal 이중 커버가 아니다** (goal 9 ≠ goal 10). 다만 **파일 수준 소유권 모호함**이다. 즉, 이 파일을 "누가 소유하는지" 명확치 않으면 Stage 5 Bundle 4 설계 시 두 설계 드래프트가 헤딩·스타일에서 충돌할 수 있다.

**제안 해결 방안** (plan_final에서 흡수):

> *D4.c가 `CONTRIBUTING.md`라는 파일을 **소유**한다. D4.b는 이 파일에 단일 섹션(예: `## Changelog maintenance`)을 기여한다. Stage 5 Bundle 4 설계는 "CONTRIBUTING.md 섹션 테이블 + 행별 owning deliverable"을 명시한다.*

심각도: **경미**. Stage 4 승인 차단 요인 아님. plan_final Sec. 3에서 한 번 명시해 두면 Stage 5가 재발견할 필요 없음.

### 1-3. Scope-extras 커버리지 (brainstorm Sec. 9-2, 옵션 β)

Kickoff goals와 별도로, Bundle 4 옵션 β는 scope extra 4개(D4.x1–x4)를 추가. 각각 정확히 하나의 OQ 또는 brainstorm-Sec. 9-2 하위 항목에 매핑:

| Scope extra | 출처 | Deliverable | 상태 |
|-------------|------|-------------|------|
| `template_vs_dogfooding_separation` | 오래된 옵션 1 이월 | D4.x1 `templates/HANDOFF.template.md` | ✅ |
| `internal_doc_header_schema` | brainstorm Sec. 9-2 | D4.x2 (decisions.md 항목) | ✅ |
| `bundle_folder_naming` | brainstorm Sec. 9-2 | D4.x3 (decisions.md 항목) | ✅ |
| `doc_link_conventions` | brainstorm Sec. 9-2 | D4.x4 (decisions.md 항목) | ✅ |

4개 scope extra 모두 커버, 중복 없음.

### 포커스 (a) 판정

**PASS. plan_final용 경미 명시 1건.**

---

## 2. 포커스 (b) — Top-3 리스크 감사

### 2-1. R1, R2, R3가 진짜 top 3인가?

(likelihood × impact × "늦게 발견될 때의 비용")으로 가중:

| 점검 항목 | R1 (option-β 스코프 크립) | R2 (tool-picker → discovery UX drift) | R3 (Stage 11 컨텍스트 exhaustion) |
|-----------|----------------------------|----------------------------------------|-----------------------------------|
| Likelihood | medium | medium | medium-high |
| Impact | high (v0.3 범위 폭증) | high (N5 위반) | medium (재실행 요구 가능) |
| 늦게 발견 시 비용 | high — Stage 9 리뷰에서야 발견 | high — 점진적 설계 크립, Stage 9까지 미발견 | medium — Stage 11 진입 시 발견 |
| 공동 승인 연쇄 (M.1) | **yes — Bundle 1도 함께 차단** | no (Bundle 1 국소) | no (구현 이후) |
| 완화 지렛대 | Stage 3 캡 + Stage 5 설계 제약 | Stage 5 설계 선언 + Stage 9 재점검 | Stage 11 진입 시 pre-compact |

세 개 모두 "medium-high" 구간에 납득됨. R4 (KO drift)보다 R1이 위인 이유: R1은 M.1 (공동 승인)을 통해 **양 번들 모두에 영향**. R4는 stage close 시 명시 규칙으로 완화 가능. R8 (DC.5 타이밍)보다 R3가 위인 이유: R8은 hard pre-condition으로 잔여 리스크가 절차 점검 수준까지 떨어짐.

### 2-2. 발견 F-b1 — top-3 내부 순서 nit (현상 유지)

R2 vs R3의 순서가 바뀔 수 있음. R2는 **점진적** (Stage 5–9 사이에서 크림), R3는 **한 게이트에서 급성** (Stage 11). 둘 다 top-3 유지, 내부 순서는 완화 의무에 영향 없음. **변경 없음.**

### 2-3. 발견 F-b2 — 누락 리스크 후보: 공동 승인 커플링 (R9 후보)

plan_draft에 **독립된 라인으로는 없는** 리스크: M.1 하에서 **어느 한 번들의 중대 이슈가 다른 번들의 shipment를 차단**. 현재는 R1의 impact 컬럼("v0.3 범위 폭증")과 GJ.2 안에만 암묵적으로 존재.

그 자체로 top-3급은 **아니다** — 다른 리스크의 **커플링 증폭기**. 독립된 secondary risk로 이름 붙이면 Stage 9·11 감사 용이.

**제안 해결 방안** (plan_final에서 흡수):

> *Sec. 5-2 secondary risks에 **R9 — 공동 승인 커플링 (M.1 증폭기)** 추가. 완화: Stage 9에서 한 번들이 `design_level`, 다른 번들이 `minor`면 공동 규칙에 따라 양쪽 모두 Stage 4.5 재승인 트리거. HANDOFF.md bundles[].verdict 필드에 커플링된 판정 명시 기록.*

심각도: **중간** (감사 위생 개선. 방향에 영향 없음).

### 포커스 (b) 판정

**PASS. plan_final에 secondary risk 1건 추가.**

---

## 3. 포커스 (c) — Open-question 격리 점검

Sec. 7의 모든 OQ가 Stage 5(기술 설계) 내부에서 답 가능한지, Stage 4(계획)로 역류하는 게 있는지 확인.

### 3-1. OQ별 감사

| OQ | 주제 | Stage 5 답변 가능? | 판정 |
|----|------|---------------------|------|
| OQ1.1 | SKILL.md 분할 vs 단일 | 예 — Bundle 1 tech design | ✅ Stage 5 |
| OQ1.2 | 추천 트리거 모드 | 예 — Bundle 1 tech design | ✅ Stage 5 |
| OQ1.3 | native `Skill` 툴 바인딩 | 예 — 이미 Lean: N14에 따라 none | ✅ Stage 5 |
| OQ4.1 | 헤더 메타데이터 스키마 | 예 — Bundle 4 tech design | ✅ Stage 5 |
| OQ4.2 | 번들 폴더 네이밍 | 예 — Bundle 4 tech design | ✅ Stage 5 |
| OQ4.3 | link-check 자동화 | 이미 N12로 해결 (이월) | ✅ 해결 |
| OQ.H1 | bundles[] 위치 | 이미 해결 (`## Bundles` 유지) | ✅ 해결 |
| OQ.H2 | 하위 호환 | 예 — Bundle 4 tech design (CONTRIBUTING migration note) | ✅ Stage 5 |
| **OQ.S11.1** | Stage 11 kickoff 컨텍스트 전달 | 예, 그러나 **프롬프트 작성 작업이지 설계 작업 아님**. pre-Stage-11 housekeeping (DC.5의 Stage 11판) 슬롯에 해당 | ⚠️ F-c1 |
| **OQ.S11.2** | 판정 분기 정책 (공동 검증) | **아니오** — 이것은 **정책 결정**: 번들 판정이 갈릴 때 HANDOFF에 어떤 상태가 들어가는지. `technical_design.md`가 아니라 **Stage 4 Plan Final Sec. policy**에 속함 | 🚨 F-c2 |
| OQ.C1 | Codex 범위 (Bundle 1) | 예 — Bundle 1 tech design Codex appendix | ✅ Stage 5 |
| OQ.C2 | Stage 5 → Codex 프롬프트 매핑 | 예 — Stage 5 design appendices | ✅ Stage 5 |
| OQ.L1 | 번역 타이밍 | 이미 R4로 해결 (stage close) | ✅ 해결 |
| **OQ.L2** | "KO 누락" 체크 위치 | Stage 3 쪽 (plan_review 템플릿) = **이 문서의 책임**; Stage 9 쪽 = Bundle 4 tech design | 🟡 F-c3 |
| OQ.N1 | CHANGELOG 스펙 | 예 — Bundle 4 tech design | ✅ Stage 5 |
| OQ.N2 | update_handoff.sh dry-run 기본 | 예 — Bundle 4 tech design | ✅ Stage 5 |
| OQ.N3 | .github/ 범위 | 이미 해결 (v0.4 이월) | ✅ 해결 |

### 3-2. 발견 F-c1 — OQ.S11.1은 프롬프트 작성 작업이지 Stage 5 설계 작업 아님

OQ.S11.1 ("Stage 11 joint fresh session이 컨텍스트를 어떻게 받는가")의 답은 **Stage 11 kickoff 프롬프트 템플릿 작성** — DC.5의 Stage 5 프롬프트 드래프트의 형제 격이지만 파이프라인에서 더 뒤에 위치.

plan_draft Sec. 9가 이미 암묵적으로 언급 ("Stage 11 kickoff prompt text → **pre-Stage-11 housekeeping** (DC.5의 새 카운터파트)"). 따라서 OQ.S11.1은 Stage 4 / Stage 5로 새지 않음. Stage 11 직전 housekeeping 슬롯에 안착.

**제안 해결 방안** (plan_final): Sec. 9 안의 괄호식 언급을 **명시적 deliverable 라인**으로 승격 (예: `DC.6 — prompts/claude/v03/stage11_joint_validation_prompt.md`).

심각도: **경미** (추적성 / deliverable 목록 완전성).

### 3-3. 발견 F-c2 — OQ.S11.2는 Stage 4로 역류 🚨

OQ.S11.2: **"두 번들의 Stage 11 판정이 갈리면 HANDOFF에 어떤 상태가 들어가는가?"** plan_draft에 이미 Lean (`group verdict = worst-case (CHANGES REQUESTED wins); design_level은 Stage 4.5 재승인 트리거`)이 있지만, 이는 *open-question lean*이지 *commit된 정책*이 아님.

이것은 기술 설계 결정이 아니다 — 모듈이나 데이터 흐름이 없다. **공동 검증 그룹의 의견 불일치 시 거버넌스 정책**이며, Stage 4.5 재승인 semantic(M.4의 명시화)을 결정.

**심각도: 중간 — 모호함 상태로 두면 Stage 11까지 전파.**

**제안 해결 방안** (plan_final이 OQ가 아닌 **commit된 정책**으로 흡수):

> *plan_final Sec. Milestones notable rules (또는 새 Sec. Policy 섹션)에 추가:*
> **M.5 — 판정 분기 정책.** 하나의 validation group 내 번들들이 Stage 11 판정에서 분기하면, 그룹 판정은 **둘 중 나쁜 쪽** (`CHANGES REQUESTED`가 `APPROVED`를 이김). Stage 4.5 재승인은 **번들 중 최소 하나의 판정이 `design_level`일 때만** 트리거. 재승인 시에는 공동 재승인 (M.1 지속 적용).

조치: **plan_final Sec. 4 또는 새 Sec. policy에 commit. OQ.S11.2를 Open Questions에서 삭제하고 새 규칙 참조.**

### 3-4. 발견 F-c3 — OQ.L2는 Stage 3 자체에서 절반 답 가능 🟡

OQ.L2: "KO 누락" 체크가 어디에 위치. 두 파트:

- **Stage 3 쪽** — plan_review 템플릿에 KO 동기화 체크를 명시. **이 문서의 책임** — Sec. 4-3에서 처리.
- **Stage 9 쪽** — code-review checklist에 "KO freshness for stage-closing docs" 추가. Bundle 4 tech design 범위.

**제안 해결 방안** (plan_final): OQ.L2를 "Stage 3 쪽 해결" + "Stage 5 Bundle 4 범위 (Stage 9 쪽)"로 분할.

심각도: **경미** (하우스키핑).

### 3-5. 포커스 (c) 정리

| Leak | 방향 | 조치 |
|------|------|------|
| F-c2 (OQ.S11.2) | → Stage 4 (설계가 아닌 정책) | plan_final에 commit된 규칙 M.5로 승격 |
| F-c1 (OQ.S11.1) | → pre-Stage-11 housekeeping 슬롯 (이미 Sec. 9에 산문으로는 있음) | 명시적 deliverable DC.6으로 승격 |
| F-c3 (OQ.L2) | → 일부 Stage 3 (이 문서), 일부 Stage 5 Bundle 4 | Stage 3 쪽은 여기서 해결; Stage 5 쪽 유지 |

### 포커스 (c) 판정

**PASS with 3 resolutions for plan_final** — 진짜 leak 1건 (F-c2) + 추적성 업그레이드 2건 (F-c1, F-c3). Stage 2로 롤백 필요 없음.

---

## 4. 포커스 (d) — Stage 3 시작 시점 KO 동기화

### 4-1. 구조 점검

`plan_draft.ko.md`의 섹션 헤더(30개 `##` / `###` 항목) → `plan_draft.md` 헤더와 1:1. 동일한 번호 체계, 동일한 범위 분할, 동일한 milestone 매트릭스 축, 동일한 R1–R8 + P 재점검 구조, 동일한 approval checklist AC.1–AC.7.

### 4-2. 내용 수준 스팟 체크

| 지점 | EN | KO | 일치? |
|------|----|----|------|
| North-star 문장 | "start a new backend project with jOneFlow v0.3 on their own within 30 minutes" | "Jonelab 동료가 jOneFlow v0.3으로 30분 안에 새 백엔드 프로젝트를 혼자 시작할 수 있다" | ✅ |
| D1.a (goal 7) | `.skills/tool-picker/SKILL.md` | `.skills/tool-picker/SKILL.md` | ✅ 동일 ID 경로 |
| R1 완화 | "Cap internal decisions to three yes/no-ish choices" | "내부 결정을 세 개의 yes/no 선택으로 제한" | ✅ |
| Approval 항목 수 | 7개 (기본 4 + Strict-hybrid 3) | 동일 (8-1 = 4, 8-2 = 3) | ✅ |

### 4-3. 재사용 가능한 KO 동기화 체크 (OQ.L2 Stage 3 쪽 해결)

앞으로 모든 `plan_review.md` / `plan_final.md`는 Stage 3를 다음 4줄 체크로 시작 (OQ.L2의 KO 쪽):

```
KO 동기화 체크 (Stage 3 시작 및 Stage 4 시작 시 필수):
- [ ] EN-KO 섹션 헤더 개수 일치
- [ ] North-star 문장이 KO에 존재하고 동등
- [ ] Deliverable ID (D1.a/D4.a/…)가 양 파일에서 동일
- [ ] Approval checklist 항목 수 양 파일에서 동일
```

이것이 이제 Stage 3 템플릿이며 plan_final.md에도 복사됨. (Stage 9 code-review 체크리스트 추가는 Bundle 4 tech design으로 이월.)

### 포커스 (d) 판정

**PASS — Stage 3 진입 시점 KO 동기화 현재 상태 OK. OQ.L2 Stage 3 쪽은 Sec. 4-3에서 해결.**

---

## 5. 리뷰 중 추가로 발견한 항목 (non-focal)

plan_draft Sec. 1~Sec. 10을 순서대로 점검하며:

### 5-1. F-o1 — Sec. 6 DEP.1 순서 표현 모호함 (경미)

DEP.1: *"Bundle 4 Stage 5가 Bundle 1 Stage 5보다 먼저 또는 **동시에** 시작하되, Bundle 4의 구조적 결정은 먼저 finalize."* "동시에"가 느슨함 — HANDOFF "Next Session Prompt"는 이를 **"Bundle 4 구조 결정 먼저, DEP.1"**으로 정확히 좁혀 표현.

**제안 해결 방안** (plan_final): DEP.1을 다음으로 교체: *"Bundle 4 Stage 5의 구조적 결정(D4.x2–x4)은 Bundle 1 Stage 5의 추천 로직 섹션(D1.b) 작성 전에 lock. 나머지는 병렬 진행 가능."* 심각도: **경미**.

### 5-2. F-o2 — Sec. 4 milestone 매트릭스 row-13 (Deploy & Archive) "joint tag v0.3" — 수용하되 주석

Stage 13 공동 git tag는 좋은 위생. 변경 불필요. plan_final에 명시적으로 기록해 Stage 13에서 두 번들을 별개 태그로 내보내지 않도록.

### 5-3. F-o3 — Sec. 7-7 OQ.N3 (.github/ 디렉터리) — 이미 해결, 목록 위치 불일치

OQ.N3는 "Lean: v0.4 이월"로 commit 해결 상태 — 진짜 open question이 아님. Sec. 2 non-goals의 N15로 이동 (또는 기존 N7 "CI/CD templates"의 하위 항목으로 병합). **제안**: plan_final Sec. 2의 N7에 서브불릿으로 포함 ("`.github/` PR/issue 템플릿 포함"). 심각도: **경미** (청결).

### 5-4. F-o4 — Sec. 8 Approval checklist 구조에 대해서는 이견 없음

7개 항목 구조 (WORKFLOW 기본 4 + Strict-hybrid 추가 3)는 올바르며 WORKFLOW.md Sec. 6 Stage 4 기준에 부합. AC.1–AC.7 각각이 측정 가능. plan_final이 ✅/❌ + 한 줄 메모로 채움.

---

## 6. 개정 제안 종합 (Stage 4 Plan Final 입력)

위 발견은 모두 **`plan_final.md`에서 흡수**. `plan_draft.md`는 Stage 2 스냅샷으로 보존 (세션 3 지시: plan_draft 직접 수정 허용이지만, Stage 3 발견 중 Stage 2 재작성을 요구하는 것은 없음 — 전부 Stage 4에서 깔끔히 처리). plan_draft에는 revision-log 한 줄만 추가.

| ID | 유형 | 출처 | plan_final에서의 조치 |
|----|------|------|---------------------|
| F-a1 | 파일 소유권 명시 | Sec. 3 | D4.c, D4.b에 주석: CONTRIBUTING.md는 D4.c 소유; D4.b는 단일 섹션만 기여. |
| F-b2 | secondary risk 추가 | Sec. 5-2 | **R9 — 공동 승인 커플링 (M.1 증폭기)** 추가. |
| F-c1 | deliverable로 승격 | Sec. 3-3 | **DC.6 — `prompts/claude/v03/stage11_joint_validation_prompt.md`** 추가. |
| F-c2 | 정책 commit; OQ에서 제거 | Sec. 4 + Sec. 7 | **M.5 — 판정 분기 정책**을 milestone rules에 추가; OQ.S11.2 삭제하고 M.5 참조. |
| F-c3 | Stage 3 쪽 해결; Stage 5 쪽 유지 | Sec. 7-6 | OQ.L2 Stage 3 쪽 해결 표시 (KO 동기화 체크 섹션, 본 문서 Sec. 4-3); Stage 9 쪽은 Bundle 4 tech design으로. |
| F-o1 | 순서 표현 정밀화 | Sec. 6 DEP.1 | "simultaneously"를 "may proceed concurrently; Bundle 4 D4.x2–x4 must lock first"로 교체. |
| F-o2 | 공동 태그 명시 | Sec. 4 M-rules | 주석 추가: Stage 13에서 양 번들을 단일 `v0.3` git tag로 배포. |
| F-o3 | OQ.N3를 N7로 병합 | Sec. 2 + Sec. 7-7 | N7에 ".github/ PR/issue 템플릿" 서브불릿 추가; Open Questions에서 OQ.N3 제거. |

---

## 7. 판정

**Plan Draft 구조적으로 건전.** Stage 2 롤백 없음. Stage 4 Plan Final은 Sec. 6의 8개 개정을 흡수한 상태로 진행. Stage 3 포커스 4개 모두 통과.

| 포커스 | 판정 |
|--------|------|
| (a) Deliverables × goals 커버리지 | PASS + 명시 1건 (F-a1) |
| (b) Top-3 리스크 | PASS + secondary 1건 추가 (F-b2) |
| (c) OQ 격리 | PASS + 해결 3건 (F-c1, F-c2, F-c3) |
| (d) KO 동기화 | PASS; OQ.L2 Stage 3 쪽 Sec. 4-3에서 해결 |

---

## 8. 본 리뷰가 **다루지 않는** 것 (이후 스테이지 인계)

- 기술 설계 결정 (SKILL.md 스키마, 셸 플래그 surface, 헤더 YAML 문법) → **Stage 5 번들별**.
- 전체 계획의 독립 검증 → **Stage 11 fresh 세션** (validation group 1).
- Codex 프롬프트 verbatim → **Stage 5 design appendices**.
- QA 시나리오 → **Stage 12**.

---

## 9. 본 문서 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-22 | v1 — Stage 3 리뷰 작성 | 세션 3. 같은 세션 셀프 리뷰; 4개 포커스 + 4개 부수 발견. plan_final로 8건 개정 포워드. |

---

## 📌 다음 스테이지

**Stage 4 — Plan Final** (`docs/02_planning/plan_final.md`).

Plan Final은:
1. 본 리뷰 Sec. 6의 8개 개정을 흡수.
2. plan_draft Sec. 8의 7개 항목 Approval checklist (AC.1–AC.7)를 ✅/❌ + 한 줄 메모로 채움.
3. 상단에 KO 동기화 체크 블록(Sec. 4-3)을 포함.
4. Stage 4.5 제출 전에 `plan_final.ko.md`와 페어링.

---
