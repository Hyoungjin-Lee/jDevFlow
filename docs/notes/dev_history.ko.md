# 개발 이력 — jOneFlow v0.3

> **목적.** v0.3 개발 주기 동안 벌어진 일을 단계(stage) 단위로 시간순 기록. 각 항목은 한 번의 stage 실행(또는 housekeeping)을 판정·주요 산출물·후속 stage로 넘긴 결정과 함께 남긴다. Fresh Claude 세션이 "왜 지금 이 모양인지" 재구성할 수 있도록 작성.
>
> **읽는 순서.** 참조 자료. 더 깊은 이력이 필요할 때 CLAUDE.md / HANDOFF.md / WORKFLOW.md 이후에 읽는다. 일차 기획 문서를 대체하지 않음.
>
> **표기.** Stage 실행 1회당 1개 섹션, 시간순. 섹션 참조는 `Sec. N` 사용 (`§` 문자는 v0.3에서 가독성 이슈로 퇴역).
>
> **언어.** EN primary. 이 파일이 `dev_history.md`의 한국어 페어 (R4에 따라 세션 종료 시 작성).
>
> **DC.2 참조.** Plan_final Sec. 3-3 DC.2. Backfill은 세션 3 재개 시점에 실행 (2026-04-22).

---

## 세션 요약표

| 세션 | 날짜 | 실행된 Stage | 판정 | 종료 시점 |
|------|------|--------------|------|-----------|
| 1 | 2026-04-22 | Stage 1 브레인스토밍 | PASS | Stage 2 진입 전 (컨텍스트 보존) |
| 2 | 2026-04-22 | Stage 2 Plan Draft (EN + KO) | PASS | UI 사용량 ~76%, 깨끗한 stage 경계 |
| 3 | 2026-04-22 | Stage 3 Plan Review (EN + KO) | PASS, 4/4 포커스 | UI 사용량 ~95%, Stage 4 진입 전 |
| 3 재개 (토큰 충전 이후) | 2026-04-22 | Stage 4 Plan Final (EN + KO) + Stage 4.5 승인 + DC.5 + DC.6 + 섹션 기호 정책 변경 + 본 backfill + Stage 5 Bundle 4 기술 설계 (EN + KO) + Stage 5 Bundle 1 기술 설계 (EN + KO) | APPROVED (공동); 양 번들 Stage 5 완료 | TBD |
| 4 | 2026-04-22 | Stage 8 Bundle 4 Codex 완료 readback + Stage 9 Bundle 4 Claude 코드 리뷰 | PASS — minor | Stage 9 Bundle 4 종료; Bundle 1 킥오프 차단 해제 |
| 5 | 2026-04-22 | Stage 9 Bundle 1 Claude 코드 리뷰 + Stage 11 prep housekeeping (DC.6 dossier) | PASS — minor; dossier 산출 | Stage 11 직전 (M.3 에 따라 Stage 11 은 새 세션) |
| 6 | 2026-04-22 | Stage 11 joint validation (M.3 에 따른 새 세션) + Stage 11 close 커밋 `d453ea1` + Stage 12 QA & Release 준비 | APPROVED (M.5 worst-of-two); Stage 12 완료 | Stage 13 직전 (Stage 12 커밋은 defer → 세션 7 open 에서 해소) |
| 7 | 2026-04-22 | Stage 12 close 커밋 `08a43fd` + Stage 13 릴리스 준비 (CI 매트릭스 Linux, QA 게이트, 문서 게이트, 태그 대상 커밋) + v0.3 태그 cut + post-release | plan_final M.6 에 따라 v0.3 릴리스 | Post-release (세션-종료 git 정책 적용) |

---

## 세션 1 — 2026-04-22

### Entry 1.1 — Stage 1 Brainstorm

- **Stage:** 1 (Brainstorm)
- **Owner:** Claude (planner), Hyoungjin (참여자)
- **Output:** `docs/01_brainstorm/brainstorm.md` (+ 세션 종료 시 Addendum 추가)
- **판정:** PASS — Stage 2 진입 준비 완료.
- **Stage 2로 넘긴 주요 결정:**
  - 워크플로우 모드: **Strict-hybrid** (상위 Strict + 내부 번들 Standard).
  - 번들 선택: **Bundle 1 (tool-picker) + Bundle 4 (doc-discipline)**. Bundle 2, 3은 v0.4로 이월.
  - Validation group 1 = {Bundle 1, Bundle 4} — 공동 Stage 4.5 승인 게이트 (M.1) + 단일 fresh 세션 Stage 11 (M.3).
  - UI 정책: v0.3에서 `has_ui=false`. v0.5 또는 첫 downstream `has_ui=true` 프로젝트까지 base-only.
  - Bundle 4 **option β**: kickoff goals 5/9/10 + brainstorm Sec. 9-2 내부 문서 구조. 리스크 low-medium → medium. Brainstorm Addendum에 결정 기록.
- **도입된 참조 프레임:** P1–P10 우려사항 (규모 / 동시성 / verdict authority), D-A/B/C/D 규칙 (tool-picker 권고 전용, Codex 타이밍, verdict 전파).
- **이 stage에서 이월된 항목:** `template_vs_dogfooding_separation` (Stage 2에서 Bundle 4 option β D4.x1로 흡수).
- **세션 종료 사유:** Stage 2 진입 전 컨텍스트 보존; brainstorm 산출물 전체를 세션 2로 인계.

### Entry 1.2 — HANDOFF.md 전환 (housekeeping, Option 1)

- **액션:** v0.2 승계 HANDOFF.md 템플릿을 in-place로 v0.3 dogfooding 트래커로 전환 (Option 1). "이 파일은 dogfooding 상태 추적용" 배너 추가.
- **근거:** jOneFlow v0.3는 자기 자신을 dogfooding 중. HANDOFF.md를 두 개로 유지하는 대신 여기서 dogfooding 상태를 추적하고, v0.3 릴리스 시 깨끗한 템플릿(`templates/HANDOFF.template.md`)을 Bundle 4 D4.x1로 분리.
- **이월:** Clean-template 분리는 Bundle 4 책임 (D4.x1).

---

## 세션 2 — 2026-04-22

### Entry 2.1 — Stage 2 Plan Draft (EN + KO 페어)

- **Stage:** 2 (Plan Draft)
- **Owner:** Claude (planner)
- **Output:** `docs/02_planning/plan_draft.md` (EN) + `docs/02_planning/plan_draft.ko.md` (KO, R4에 따라 같은 세션 내 페어 커밋).
- **판정:** PASS — Stage 3 진입 준비 완료.
- **구조:** 10개 섹션 — Goals / Non-goals / Deliverables / Milestones / Risks / Dependencies / Open Questions / Approval Checklist (사전 박음, 비어있음) / Deferrals / Revision log.
- **번들 통합:** 공동 Stage 4.5 + Stage 11을 거치므로 plan_draft도 공동 (번들별 분리 아님).
- **추적성 규율:** kickoff goals와 scope_extras를 Sec. 3에서 별도 리스트로 분리 유지 — `prompts/claude/v03_kickoff.md`와의 연결 보존.
- **Top-3 리스크 사전 기재:** R1 option-β 스코프 크립 · R2 tool-picker N5 영역으로 드리프트 · R3 Stage 11 컨텍스트 폭발. 각각 likelihood/impact/mitigation/owner 기재.
- **승인 체크리스트 사전 박음:** 7개 항목 — AC.1–AC.4 (WORKFLOW.md Sec. 6 기본) + AC.5–AC.7 (Strict-hybrid 추가). Stage 4에서 채우도록 비워둠.
- **이 stage에서 연 Open Questions:** OQ.S11.2 (판정 분기 정책), OQ.L2 (KO freshness 체크 위치), OQ.N3 (`.github/` 템플릿). 셋 다 세션 3에서 해소.
- **세션 종료 사유:** UI 사용량 ~76%에서 stage 경계 조기 종료. `docs/notes/session_token_economics.md`를 동시에 작성하여 continue-vs-transition 판단 프레임워크 캡처.

### Entry 2.2 — `session_token_economics.md` 도입 (living doc)

- **Output:** `docs/notes/session_token_economics.md` (KO 단독; EN 페어는 OSS 공개 시점으로 이월).
- **목적:** "현재 세션 유지 vs 새 세션 전환" 판단 프레임워크 운영 wiki. 세션 2의 실제 76%-사용량 판단 사례에서 유도.
- **상태:** Bundle 1, 4 스코프 외. 운영 위생 artifact.

---

## 세션 3 — 2026-04-22 (토큰 충전 이전)

### Entry 3.1 — Stage 3 Plan Review (EN + KO 페어)

- **Stage:** 3 (Plan Review)
- **Owner:** Claude (reviewer)
- **Input:** 세션 2의 `plan_draft.md`.
- **Output:** `docs/02_planning/plan_review.md` + `plan_review.ko.md`.
- **판정:** plan_draft "Next Stage"의 4개 포커스 전부 **PASS**:
  - (a) kickoff goals 5/7/9/10/11/12 커버리지 — 전부 deliverables에 매핑.
  - (b) Top-3 리스크 타당성 — 확인.
  - (c) Open Questions Stage 5 컨테인먼트 — 진짜 Stage-4 leak 1건 발견 (아래 참조).
  - (d) KO freshness — 통과, Sec. 4-3에 재사용 가능한 4-item KO sync 체크 블록 도입.
- **핵심 발견 (진짜 Stage-4 leak):** **OQ.S11.2 (판정 분기 정책)** 은 거버넌스 정책이지 기술 설계가 아님. plan_final의 **committed 규칙 M.5**로 승격 (F-c2): 그룹 판정 = worst-of-two; 어느 한 번들 `design_level`이면 공동 재승인.
- **다른 개정 사항 (모두 Stage 4에서 흡수):**
  - F-a1 — CONTRIBUTING.md 파일 소유권 D4.c; D4.b는 `## Changelog maintenance` 단일 섹션만 기여.
  - F-b2 — 신규 secondary 리스크 **R9 Joint-approval coupling** (M.1 증폭기)를 Sec. 5-2에 추가.
  - F-c1 — 신규 cross-bundle deliverable **DC.6** (`prompts/claude/v03/stage11_joint_validation_prompt.md`).
  - F-c3 — OQ.L2 Stage-3 절반 Sec. 4-3 KO sync 블록으로 해소. Stage-9 절반은 Bundle 4 tech design으로 유지.
  - F-o1 — DEP.1 정밀화: Bundle 4 D4.x2–x4가 Bundle 1 D1.b보다 먼저 잠겨야 함; 나머지는 병렬 가능.
  - F-o2 — Stage 13는 단일 공동 `v0.3` git tag 배포 (릴리스 위생 노트 → M.6).
  - F-o3 — OQ.N3를 N7 `.github/` PR/이슈 템플릿 서브불릿으로 병합; Sec. 7에서 제거.
- **세션 종료 사유:** UI 사용량 **~95%** 도달. Stage 4 진입 전 깨끗한 Stage-3 경계에서 중단. Stage 4 작업 전부를 `plan_review.md Sec. 6`의 8건 개정 테이블 + HANDOFF.md 다음-세션 프롬프트로 사전 스테이징하여 세션 4가 기계적으로 이어받을 수 있도록 함.

---

## 세션 3 (토큰 충전 후 재개) — 2026-04-22

### Entry 3.2 — Stage 4 Plan Final (EN + KO 페어)

- **Stage:** 4 (Plan Final)
- **Owner:** Claude (planner)
- **Input:** `plan_draft.md` (v1, 세션 2) + `plan_review.md` (v1, 세션 3, 개정 테이블).
- **Output:** `docs/02_planning/plan_final.md` + `plan_final.ko.md`.
- **판정:** 승인 체크리스트 7/7 ✅. Stage 4.5 준비 완료.
- **plan_review 개정 8건 전부 흡수** (F-a1, F-b2, F-c1, F-c2, F-c3, F-o1, F-o2, F-o3) — Sec. 0-2 Summary of changes 테이블이 각 개정이 어디로 착지했는지 교차 참조.
- **OQ.S11.2가 M.5로 committed** (더 이상 open question 아님) — divergent-verdict policy.
- **Open Questions Sec. 7 축소:** OQ.S11.2 제거 (이제 M.5), OQ.L2 Stage-3 절반 resolved 표시, OQ.N3 제거 (N7로 병합).
- **KO sync 체크 블록** Sec. 0에 추가, 4개 항목 모두 페어 `.ko.md`와 대조 후 체크.
- **비차단 주석 (AN.1–AN.3):** DC.5 + DC.6은 pre-Stage-5 / pre-Stage-11 선결조건 (Stage-4 게이트 아님); 잔여 OQ는 Stage 5에서 해소; `dev_history.md` backfill은 본 세션 내.
- **세션 연속 근거:** 토큰 충전 이후 사용자 요청으로 사용량 압박에도 Stage 3 → Stage 4 연속 실행. 판단은 session_token_economics wiki에 기록.

### Entry 3.3 — Stage 4.5 사용자 승인 게이트

- **Stage:** 4.5 (승인 게이트 — validation group 1 공동)
- **제출자:** Claude · **결정자:** Hyoungjin
- **제출 입력:** `plan_final.md` + `plan_final.ko.md`, 7/7 ✅.
- **적용 제약:** M.1 — 부분 승인 불가; Bundle 1 + Bundle 4 공동 결정.
- **판정:** **APPROVED (공동)**. 두 번들 `approval_status` → `approved` in HANDOFF.md YAML.
- **차단 해제:** pre-Stage-5 housekeeping + Stage 5 진입 가능.

### Entry 3.4 — Pre-Stage-5 Housekeeping (DC.5 + DC.6 프롬프트 드래프트)

- **Step:** Cross-bundle housekeeping (공식 stage 아님).
- **Owner:** Claude.
- **Output (`prompts/claude/v03/` 하위 3개 신규 파일):**
  - `stage5_bundle4_design_prompt_draft.md` — DC.5 #1. D4.x2/x3/x4를 Sec. 0 lock-우선 요구로 하드와이어; D4.a–D4.c + D4.x1 커버리지 명시; Bundle 4 tech design에서 닫을 OQ 열거.
  - `stage5_bundle1_design_prompt_draft.md` — DC.5 #2. Bundle 4 Sec. 0 잠금을 하드 게이트로; plan_final Sec. 5-2 R2 (읽기 전용 Markdown 표면)를 수락 기준으로 인용.
  - `stage11_joint_validation_prompt.md` — DC.6 (F-c1에 의해 신규). 번들별 pre-compacted dossier 포맷 (각각 ≤ 1페이지 산문 + ≤ 200줄 diff) 강제로 R3 컨텍스트 폭발 차단. M.3/M.5/M.6을 출력 템플릿에 직접 박음.
- **닫힌 open question:** OQ.S11.1 — Stage 11 컨텍스트 전달 포맷이 이제 구체적으로 "`docs/notes/stage11_dossiers/bundle{id}_dossier.md`의 dossier".
- **이월:** 3개 드래프트 전부 명명된 다음 stage 진입의 선결조건.

### Entry 3.5 — 섹션 기호 정책 변경 (house style)

- **Step:** House style housekeeping.
- **트리거:** 사용자 피드백 — `§` (U+00A7)가 EN/KO 이중언어 기획 문서의 가독성을 해침.
- **변경 범위:** v0.3 작업 문서 8개에서 `§` → `Sec. ` (리터럴 접두어 + 공백) 일괄 치환:
  - `plan_draft.md` + `plan_draft.ko.md`
  - `plan_review.md` + `plan_review.ko.md`
  - `plan_final.md` + `plan_final.ko.md`
  - `HANDOFF.md`
  - `brainstorm.md`
- **의도적으로 미변경:** canonical 프롬프트 템플릿 (`prompts/claude/final_review.md`, `code_review.md`, `v03_kickoff.md`) — v0.2 호환성 보존; `docs/notes/session_token_economics.md` 및 `docs/notes/2026-04-21-v0.3-kickoff-state.md` — 기획 문서 표면 아님.
- **검증:** 8개 파일에서 `§` 잔존 0건; `Sec.  ` (2칸 공백) 아티팩트 0건.
- **이월:** 이후 작성하는 신규 문서는 `Sec. ` 직접 사용; 본 entry가 convention 참조점.

### Entry 3.6 — `dev_history.md` backfill (본 파일)

- **Step:** AN.3 / DC.2 부분 충족 (backfill만; 이후부터는 live 로깅).
- **Output:** `docs/notes/dev_history.md` + 한국어 페어 `docs/notes/dev_history.ko.md` (본 파일, R4에 따라 같은 세션 내 작성).
- **범위:** 세션 1, 2, 3 (토큰 충전 이전/이후). Stage 단위 entry + housekeeping entry.
- **이후 규율:** 세션 4부터는 revision 루프 때만이 아니라 **stage 종료마다** 또는 중대한 housekeeping 때 신규 entry 추가. 상기 entry 템플릿 준수 (Stage / Owner / Input / Output / 판정 / 주요 결정 / 이월).

### Entry 3.7 — Stage 5 Bundle 4 기술 설계 (EN + KO 페어)

- **Stage:** 5 (기술 설계 — Bundle 4, Doc Discipline, 옵션 β).
- **Owner:** Claude (설계자).
- **Input:** `docs/02_planning/plan_final.md` (Stage 4.5 에서 APPROVED) + `prompts/claude/v03/stage5_bundle4_design_prompt_draft.md` (DC.5 #1).
- **Output:** `docs/03_design/bundle4_doc_discipline/technical_design.md` (EN, 14 섹션, 약 640 줄) + `technical_design.ko.md` (KO 페어, R4 에 따라 같은 세션). 양쪽 파일에 D4.x2 규정대로 YAML 프론트매터 부착 및 4 항목 KO 동기화 체크 블록 (모두 체크 완료).
- **판정:** Stage 5 Bundle 4 **완료**. Stage 9 리뷰 대상 수락 기준 AC.B4.1–16 열거.
- **이월된 주요 결정 (Sec. 0 잠금 — DEP.1 게이트):**
  - **D4.x2** — Stage-5 이후 문서에만 YAML 프론트매터; 최소 필드 `title, stage, bundle, version, language, paired_with, created, updated` (+ 선택 `status, supersedes, validation_group`). Stage 1–4 문서는 prose-only 유지.
  - **D4.x3** — 번들 폴더 명명 `bundle{id}_{name}/`, snake_case; 정규식 `^bundle(\d+)_(.+)$` 로 두 필드 추출.
  - **D4.x4** — 링크 규칙은 항상 현재 파일 기준 상대경로 (프로젝트 루트 절대경로 금지); 앵커 슬러그는 GitHub 의 lowercase-hyphenated 규칙 준수.
  - Bundle 1 Sec. 1 이 원문 그대로 인용할 결정 기록 라인.
- **명시된 구성 요소:** `scripts/update_handoff.sh` (D4.a, POSIX sh, dry-run 기본, 6 종료 코드 계약), `CHANGELOG.md` (D4.b, Keep-a-Changelog v1.1.0), `CONTRIBUTING.md` (D4.c, 12 필수 섹션 + F-a1 소유 표 부록), `CODE_OF_CONDUCT.md` (D4.c, Contributor Covenant v2.1), `templates/HANDOFF.template.md` (D4.x1), `docs/notes/decisions.md` (D4.x2/x3/x4 인용 가능 기록).
- **이 step 에서 닫힌 open question:** OQ.N1 (Keep-a-Changelog 포맷 선택), OQ4.1 (Stage-5 이후 전용 프론트매터), OQ4.2 (`bundle{id}_{name}/`), OQ.H2 (수작업 마이그레이션 경로 → `CONTRIBUTING.md` Sec. 9), OQ.L2 Stage-9 절반 (`CONTRIBUTING.md` Sec. 7 에 KO 신선도 체크리스트 bullet).
- **F-a1 보정:** D4.c 소유 `CONTRIBUTING.md` 내부 Sec. 8 `## Changelog maintenance` 가 유일한 예외로 유지; `CONTRIBUTING.md` 부록 Sec. 12 에 섹션 단위 명시적 소유 표 부착.
- **Stage 8 (Codex) 로 이월:** 7 파일 의존성 순서 deliverable 리스트 + 위반 금지 제약 + Codex 킥오프 프롬프트 (tech design Sec. 12-1).
- **Bundle 1 DEP.1 차단 해제:** Sec. 0 결정이 잠금 및 `docs/notes/decisions.md` 로 인용 가능. Bundle 1 Stage 5 진입 가능.

### Entry 3.8 — Stage 5 Bundle 1 기술 설계 (EN + KO 페어)

- **Stage:** 5 (기술 설계 — Bundle 1, Tool Picker).
- **Owner:** Claude (설계자).
- **Input:** `docs/02_planning/plan_final.md` (Stage 4.5 에서 APPROVED) + `prompts/claude/v03/stage5_bundle1_design_prompt_draft.md` (DC.5 #2) + `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 (DEP.1 게이트, 잠금 완료).
- **Output:** `docs/03_design/bundle1_tool_picker/technical_design.md` (EN, 14 섹션) + `technical_design.ko.md` (KO 페어, R4 에 따라 같은 세션). 양쪽 파일에 D4.x2 규정대로 YAML 프론트매터 부착 및 4 항목 KO 동기화 체크 블록 (모두 체크 완료, 헤더 17/17 일치, AC.B1.1–10 × 10 항목).
- **판정:** Stage 5 Bundle 1 **완료**. Stage 9 리뷰 대상 수락 기준 AC.B1.1–10 열거 (헤드라인: AC.B1.7 R2 읽기 전용 불변식).
- **이월된 주요 결정 (Sec. 0 DEP.1 preflight + Sec. 1–4):**
  - **OQ1.1 해결 — 단일 파일:** `D1.a + D1.b + D1.c` 를 하나의 `.skills/tool-picker/SKILL.md` 로 통합 (≤ 300 줄; 예상 180–220; 분할 대신 escalate).
  - **OQ1.2 해결 — 두 트리거, 단일 파이프라인:** stage-entry 자동 호출과 사용자 요청 호출이 같은 결정 파이프라인을 공유; 트리거 출처가 출력을 바꾸지 않음.
  - **OQ1.3 해결 — 네이티브 Skill API 미사용:** 순수 Markdown 스킬을 CLAUDE.md Read 순서 (N14) 로 등록; 네이티브 API 등록 없음.
  - **D1.x 는 `docs/notes/tool_picker_usage.md` 로 분리** (≤ 80 줄) — SKILL.md 의 matcher 친화성을 위해 "inlined 사용 가이드" 에서 의도적으로 범위 축소.
  - **Frontmatter 계약:** Anthropic Skills 포맷에 따라 `name: tool-picker` + 필수 트리거 키워드 ("stage", "mode", "risk_level", "next step", "jOneFlow") 를 포함한 description.
  - **결정 테이블 매트릭스:** stages 2/3/5/8/9/11 × {Standard, Strict, Strict-hybrid} × {medium, medium-high} → 3 슬롯 출력 (primary / checklist / watch-out).
  - **R2 읽기 전용 불변식 테스트 가능:** AC.B1.7 이 grep 패턴 `'\b(bash|sh |python|node|eval|exec |curl|wget)\b'` 규정; 일치는 오직 코드 펜스 내 또는 인용된 예시 출력 안에서만 나타나야 함.
  - **D4.x4 좁은 예외 (Sec. 9-4):** 조언 출력 경로는 프로젝트 루트 기준 상대경로 (런타임 조언 시점에 "현재 파일" 컨텍스트가 없음); 스킬 본체 자체의 교육용 citation 은 여전히 D4.x4 를 따름.
  - **CLAUDE.md 조율 (Sec. 9-5):** 같은 세션이면 공동 커밋 `[bundle1+bundle4]`, 아니면 rebase — 두 번들 모두 CLAUDE.md Read 순서를 편집함.
- **이 step 에서 닫힌 open question:** OQ1.1 (단일 파일), OQ1.2 (두 트리거, 단일 파이프라인), OQ1.3 (네이티브 Skill API 등록 없음).
- **명시된 구성 요소:** `.skills/tool-picker/SKILL.md` (D1.a + D1.b + D1.c, 단일 파일 ≤ 300 줄) + `docs/notes/tool_picker_usage.md` (D1.x, ≤ 80 줄, 교육용 참조 문서).
- **Stage 8 (Codex) 로 이월:** 2 파일 deliverable 리스트 (SKILL.md + 사용 문서) + CLAUDE.md Read 순서 한 줄 편집 (Bundle 4 와 조율) + R2 불변식 테스트 + Codex 킥오프 프롬프트 (tech design Sec. 12-1).
- **DEP.1 충족:** Sec. 0 이 Bundle 4 D4.x2/x3/x4 를 원문 그대로 인용; Bundle 1 은 구조적 규율을 재결정하지 않음.
- **Validation group 1 상태:** 양 번들 Stage 5 모두 완료. Stage 6–7 스킵 (has_ui=false). 다음 stage = **Stage 8 Codex 구현** (번들별 킥오프 프롬프트는 각 tech design 의 Sec. 12-1).

---

### Entry 3.9 — Stage 8 + Stage 9 Bundle 4 (doc discipline, 옵션 β) 마감

- **Stage:** 8 (Codex 구현, Bundle 4) + 9 (Claude 코드 리뷰, Bundle 4).
- **Owner:** Codex (Stage 8, 구현자) → Claude (Stage 9, 리뷰어).
- **Input (Stage 8):** `docs/03_design/bundle4_doc_discipline/technical_design.md` (AC.B4.1–16 루브릭) + `prompts/codex/v03/stage8_bundle4_codex_kickoff.md` (B-option 킥오프 v2) + `docs/02_planning/plan_final.md`. 아카이브된 Codex 완료 보고서: `prompts/codex/v03/stage8_bundle4_codex_report.md`.
- **Output (Stage 8, 14 파일):** `scripts/update_handoff.sh` (486 줄, POSIX sh) + `templates/HANDOFF.template.md` + `CHANGELOG.md` + `CODE_OF_CONDUCT.md` + `CONTRIBUTING.md` (173 줄, 12 섹션 + F-a1 부록) + `docs/notes/decisions.md` (+ `.ko.md`) + `docs/04_implementation/implementation_progress.md` (+ `.ko.md`) + `tests/run_bundle4.sh` + `tests/bundle4/` 하위 테스트 스크립트 4 개. Codex 보고서 기준 shellcheck 전부 깨끗, 4 개 테스트 PASS.
- **Stage 9 판정:** **PASS — minor**. Per-AC 판정 표는 `docs/04_implementation/implementation_progress.md` (+ `.ko.md`). 코드 변경 없음.
- **Stage 9 에서 적용한 인라인 polish:** `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 6 을 8 → 10 행으로 확장하고 `stdout 디스크리미네이터` 열 추가 (+ KO 쌍 미러). 이것이 루브릭의 "nine error cases" 표현 (= 스크립트가 방출하는 9 개 고유 `error=<key>` 디스크리미네이터) 과 Sec. 6 표의 확장 이전 행 수 (= 8) 사이의 내부 불일치를 해소. Sec. 6 이 이제 10 개 실패 행 (두 행이 `usage_error` 공유) 전부를 6 개 종료 코드 (0, 1, 2, 3, 4, 5) 에 권위 있게 매핑. Sec. 7 은 *왜* 만 서술.
- **이번 단계 테스트 재실행:** `sh tests/run_bundle4.sh` — Sec. 6 편집 후에도 4 개 전부 PASS.
- **Validation-group-1 상태:** Bundle 4 Stage 9 ✅ 마감; Bundle 1 은 여전히 Stage 5 완료, Stage 8 Codex 실행 대기 (M.1 + DEP.1 순서에 의해 Bundle 4 선행이 정답). Bundle 1 Stage 8 + Stage 9 착지 전까지 Stage 10/11/12/13 보류.
- **이번 단계에서 건드린 dogfooded artifact:** `scripts/update_handoff.sh --section both --write` 로 `HANDOFF.md` Recent Changes (EN + KO) 에 Stage 9 판정 행 append. Dry-run diff 선검토; write atomic; 샌드박스 권한 문제로 `.bak` 정리가 실패했으나 `*.bak` 은 이미 `.gitignore` 에 들어가 있음 — 무해.
- **Stage 11 로 이월:** `tests/run_bundle4.sh` 교차 플랫폼 CI 매트릭스 (mac + Linux); `shellcheck` 설치 가능한 샌드박스에서 `shellcheck -S style` 재실행 (이번 리뷰 샌드박스에서는 `shellcheck` 설치 불가 — Codex 의 empty-stdout 보고 + 로컬 `sh -n`/`dash -n` 구문 검사를 대체물로 수용).
- **다음 세션:** Stage 8 Bundle 1 Codex 킥오프 (`prompts/codex/v03/stage8_bundle1_codex_kickoff.md`). 그 이후 M.3 불변식에 따라 fresh Claude 세션에서 Stage 9 Bundle 1 코드 리뷰.

---

### Entry 3.10 — Stage 8 + Stage 9 Bundle 1 (tool picker) 마감

- **Stage:** 8 (Codex 구현, Bundle 1) + 9 (Claude 코드 리뷰, Bundle 1).
- **Owner:** Codex (Stage 8, 구현자) → Claude (Stage 9, 리뷰어, fresh 세션 per M.3).
- **Input (Stage 8):** `docs/03_design/bundle1_tool_picker/technical_design.md` (AC.B1.1–10 루브릭) + `prompts/codex/v03/stage8_bundle1_codex_kickoff.md` + `docs/notes/decisions.md` (D4.x2/x3/x4 인용 가능 기록). 아카이브된 Codex 완료 보고서: `prompts/codex/v03/stage8_bundle1_codex_report.md`.
- **Output (Stage 8, 5 파일):** `.skills/tool-picker/SKILL.md` (173 줄, YAML frontmatter + 8 섹션 본문 + D4.x2/x3/x4 원문 인용 + stage×mode×risk 결정 테이블 + 31 줄 worked example) + `docs/notes/tool_picker_usage.md` (46 줄) + `docs/notes/tool_picker_usage.ko.md` (46 줄, R4 per) + `tests/bundle1/run_bundle1.sh` (151 줄, 10 검사) + `CLAUDE.md` Read-order 한 줄 추가. Codex 보고 기준 10 개 검사 전부 PASS, `description_bytes=287` (1024 자 상한 이하), R2 grep 0 매치.
- **Stage 9 판정:** **PASS — minor**. Per-AC 판정 표는 `docs/04_implementation/implementation_progress.md` (+ `.ko.md`). 코드 변경 0 건, 인라인 polish 0 건 (Codex 가 플래그한 4 개 셀 검토 후 Sec. 9-1 "sparingly" 기준 미달로 편집 불가).
- **Codex 판단 처분:** AC.B1.3 (4 → 6 컬럼 확장), AC.B1.4 (Stage 11 경로 `to be created at Stage 11` 주석), AC.B1.7 (0 매치 grep vacuous), AC.B1.10 (헤더 + `updated:` parity) — 네 건 모두 수용.
- **병렬 보완 (Bundle 1 범위 밖):** `docs/notes/dev_history.ko.md` 에 Entry 3.9 backfill. Stage 9 Bundle 4 마감 시 EN 파일은 Entry 3.9 가 들어갔으나 KO 미러가 빠진 R4 누락을 같은 날 복구.
- **이번 단계 테스트 재실행:** `bash tests/bundle1/run_bundle1.sh` — 10 개 검사 전부 PASS; 독립 R2 grep 0 매치.
- **Validation-group-1 상태:** Bundle 1 Stage 9 ✅ 마감. **양 번들 Stage 9 모두 PASS — minor**; Stage 10 (Codex final review) → Stage 11 (joint validation, fresh Claude 세션, M.3) → Stage 12 (릴리스 노트) → Stage 13 (공동 `v0.3` 태그) 로 진행.
- **이번 단계에서 건드린 dogfooded artifact:** `scripts/update_handoff.sh --section both --write` 로 `HANDOFF.md` Recent Changes (EN + KO) + Status (EN + KO) 행 갱신. Dry-run 선검토 후 write. HANDOFF.md YAML bundles 블록의 Bundle 1 항목을 `stage: 1 · verdict: null` → `stage: 9 · verdict: minor` 로 수작업 갱신 (`update_handoff.sh` 는 YAML 블록을 건드리지 않음).
- **Stage 11 로 이월:** worked example 을 live Stage-2 트리플로 갱신 (Stage 11 산출물 생성 후); `tests/bundle1/run_bundle1.sh` 53 행의 `rg` 의존 — otherwise-POSIX 스크립트 안의 minor cross-platform-CI 이슈, Stage 11 mac + Linux 매트릭스로 이월.
- **다음 세션:** Stage 10 Codex final review (`prompts/codex/final_review.md` 기반) 또는 곧바로 Stage 11 joint validation (fresh Claude 세션).

### Entry 3.11 — Stage 11 prep housekeeping + session-close git policy 고정

- **Stage:** 11-prep (Stage 9 마감과 Stage 11 fresh-session 진입 사이의 housekeeping).
- **Owner:** Claude (세션 5 연속, DC.6 기준 QA-orchestrator 역할).
- **Input:** 두 번들의 Stage 9 판정 (각 PASS — minor) + `prompts/claude/v03/stage11_joint_validation_prompt.md` Sec. "Pre-flight for the QA-orchestrator".
- **Output (신규 3 + 수정 1):**
  - `docs/notes/stage11_dossiers/bundle1_dossier.md` (신규, 135 줄) — DC.6 포맷, 7 섹션, ≤ 1 쪽 prose + pinned YAML / 결정 테이블 / grep / hook 블록을 key diff 로 고정.
  - `docs/notes/stage11_dossiers/bundle4_dossier.md` (신규, 173 줄) — DC.6 포맷, 7 섹션, CLI 계약 + decisions 앵커 + CHANGELOG/CONTRIBUTING 스켈레톤 + Sec. 6 before→after 축약 diff 를 key diff 로 고정.
  - `docs/notes/stage11_dossiers/ko_freshness.md` (신규) — KO-pair freshness 스크래치 표; Stage-5+ 과 Stage-1-4 페어 7 건 전부 0 일 델타 (`updated:` frontmatter + `git log -1` 날짜로 확인).
  - `CLAUDE.md` (수정) — cross-tool handoff rule 근처 (라인 ~181) 에 "Session close — git policy" 서브섹션 신설. ask-first / verify-after 커밋 루프를 두 브랜치로 고정: (1) 지금 반영 → Claude 가 커밋 시도 또는 셸 블록 제시 후 `git log` 로 검증; (2) 보류 → HANDOFF.md 에 uncommitted 표면 기록, 다음 세션은 `git status` 먼저 확인.
- **판정:** PASS (Stage 11 prep 완료; dossier 와 스크래치가 크기 예산 내; 테스트 하네스 재실행 green).
- **Stage 10 처분:** **생략.** 두 번들 모두 Stage 9 PASS — minor 로 마감; WORKFLOW Sec. 10 은 Stage 10 진입 조건을 NEEDS REVISION 으로 게이트하므로 어느 번들도 해당되지 않음.
- **신규 git policy 의 dogfooding:** 세션 5 종료 시점에 사용자가 branch 2 (보류) 선택. 정책에 따라 CLAUDE.md 편집은 on-disk uncommitted 로 유지; HANDOFF.md 의 Recent Changes + Status + Next-session 프롬프트에 이 사실을 명시해 Stage 11 세션이 `git status` 를 먼저 실행하도록 안내.
- **Dossier 기록 시점 테스트 재실행:** `bash tests/bundle1/run_bundle1.sh` → 10/10 PASS; `sh tests/run_bundle4.sh` → 4/4 PASS.
- **Stage 11 로 이월:** 두 dossier 의 forward 리스트 (Bundle 1 의 POSIX 스크립트 내 `rg` + worked example 라이브 갱신; Bundle 4 의 `shellcheck -S style` + mac/Linux CI 매트릭스 + Stage 12 시점 CHANGELOG 0.3.0 엔트리).
- **다음 세션:** **fresh Claude 세션** 에서 Stage 11 joint validation (M.3). Paste 블록은 HANDOFF.md Sec. "📋 다음 세션 시작 프롬프트" (표준 사본은 `prompts/claude/v03/stage11_joint_validation_prompt.md`).

### Entry 3.12 — Stage 11 joint validation 마감 (APPROVED)

- **Stage:** 11 (joint final validation, validation_group = 1).
- **Owner:** Claude (세션 6, M.3 에 따른 새 세션 — 선행 채팅 컨텍스트 없음 확인).
- **Input:** `CLAUDE.md`, `HANDOFF.md`, `WORKFLOW.md` (Sec. 14), `docs/02_planning/plan_final.md`, `docs/notes/stage11_dossiers/` 하위 3 개 dossier, `prompts/claude/final_review.md`, `prompts/claude/v03/stage11_joint_validation_prompt.md`.
- **Output:** `docs/notes/final_validation.md` (EN, stage11_joint_validation_prompt Sec. "Output file format" 에 따른 7 섹션) + `final_validation.ko.md` (KO 페어, R4 에 따라 같은 세션). 두 파일 모두 D4.x2 frontmatter 소유 (`stage: 11`, `validation_group: 1`, `status: approved`).
- **판정:** **APPROVED** (그룹, M.5 worst-of-two). Bundle 1 = APPROVED; Bundle 4 = APPROVED.
- **Pre-flight 실행:**
  - `git status` — 세션-5 uncommitted 표면 (`CLAUDE.md`, `HANDOFF.md`, `docs/notes/dev_history.{md,ko.md}`, 미추적 `docs/notes/stage11_dossiers/`) 을 인지된 상태로 포착.
  - `bash tests/bundle1/run_bundle1.sh` → 10/10 PASS.
  - `sh tests/run_bundle4.sh` → 4/4 PASS.
- **이번 단계 cross-bundle 검증:**
  - **AC.B4.10** — `.skills/tool-picker/SKILL.md` 34–72 행은 `docs/notes/decisions.md` 24–62 행과 문자 단위 verbatim (ASCII dash `### D4.x2 - …` 헤더 동일, Decision/Scope/Rule/Rationale/Backlink 구조 동일, backlink 경로 동일). SKILL.md 30 행은 verbatim 인용 규칙도 명시. Cross-bundle 계약 유지.
  - **AC.B4.11** — `grep -nE '\]\(' .skills/tool-picker/SKILL.md` 결과 0 매치; 스킬은 advisory 표면에서 Markdown 링크가 아니라 inline-code 표시 경로만 내보내므로 D4.x4 의 "no project-root-absolute, no file://, relative-to-current-file" 규칙은 구조상 vacuous. Verbatim 블록 내부의 backlink 는 이미 D4.x4 형식 (`../03_design/bundle4_doc_discipline/technical_design.md Sec. 0`).
  - **D1.b ↔ D4.x2/x3/x4 파서 계약** — `tests/bundle4/test_04_frontmatter_and_stage1_4.sh` PASS (`tests/run_bundle4.sh` 4/4 의 일부) 로 Bundle 1 이 파싱하는 Stage-5+ frontmatter 형상이 여전히 안정임을 재확인.
  - **KO freshness** — Stage-5+ 는 EN/KO `updated:` 필드, Stage 1–4 는 `git log -1` 로 7 쌍 독립 재조회; 전부 `2026-04-22` / 0 일 델타. 스크래치 `ko_freshness.md` 와 일치.
- **Non-blocking forwards (Stage 12 housekeeping 대상):**
  - Bundle 1: worked example live-state refresh (SKILL.md Sec. 6 합성 triple); `tests/bundle1/run_bundle1.sh` 53 행의 `rg` 의존성 (POSIX-clean 하게 `grep -E` 로 스왑하거나 CI 노트에 문서화); `docs/04_implementation/implementation_progress.md` Stage 9 Bundle 1 표의 AC.B1.6 vs AC.B1.8 레이블 swap; AC.B1.8 의 tech_design Sec. 0 summary-vs-verbatim 위생 (SKILL.md 쪽은 verbatim, tech_design 쪽은 압축 불릿 — "no paraphrase" 조항 느슨한 준수).
  - Bundle 4: CI 에서 `shellcheck -S style` (sandbox 는 설치 불가); mac + Linux CI 매트릭스 (AC.B4.13); `[0.3.0]` CHANGELOG 엔트리 (AC.B4.14, KaC v1.1.0 관행상 Stage 12 릴리스 시점 작성).
- **HANDOFF.md 업데이트 기록:** `bundles[1].stage 9→11`, `bundles[4].stage 9→11`, 두 verdict `minor` 이월; Recent Changes 그룹 단위 엔트리 (Stage 11 APPROVED, M.5 outcome); Status 라인; Key Document Links 의 `final_validation.md` 행 ✅ 로 전환; Next Session Prompt 블록을 Stage 12 kickoff 로 교체; EN + KO 미러 모두 갱신.
- **Dogfooding 메모:** 이번 세션에는 `scripts/update_handoff.sh` 를 사용하지 않음 — 업데이트가 bundles YAML, Next Session Prompt 재작성, Key Document Links, Recent Changes, Status 등 다수의 구조적 표면을 넘어 스크립트의 2-섹션 계약을 초과했기 때문. 수작업 단일 패스; 테스트 하네스 편집 전후 모두 green.
- **세션-종료 git 정책 (CLAUDE.md):** 세션 6 종료 시 사용자에게 누적 uncommitted 작업 (세션 5 + 세션 6) 을 Stage 11 close 커밋으로 지금 묶을지, 보류할지 질문. 어느 쪽을 선택하든 결정은 세션 7 (Stage 12 kickoff) 로 이월.
- **재진입:** 불필요 (그룹 APPROVED ⇒ Stage 4.5 루프 없음, Stage 10 회귀 없음). Stage 12 로 진행.
- **다음 세션:** Stage 12 QA & Release prep (M.6 공동). Paste 블록은 HANDOFF.md Sec. "📋 다음 세션 시작 프롬프트" (Stage 12 kickoff, 지금 설치됨).

---

### Entry 3.13 — Stage 12 QA & Release 준비 마감

- **Stage:** 12 (QA & Release 준비, M.6 에 따라 공동; validation_group = 1).
- **Owner:** Claude (세션 6 연속 — Stage 11 검증과 같은 대화창에서 진행, 과도한 세션 생성 회피를 위한 사용자 선호에 따름; Stage 12 는 M.3 fresh-session 요구 없음 — M.3 는 Stage 11 에만 적용되므로 여기서 연속 진행이 plan_final 과 정합).
- **Input:** Stage 11 `docs/notes/final_validation.md` Sec. 3 (Stage 12 punch list), WORKFLOW Sec. 15, plan_final M.6, Bundle 1 + Bundle 4 기술 설계, 기존 테스트 하네스.
- **Output (신규):**
  - `docs/05_qa_release/qa_scenarios.md` + `qa_scenarios.ko.md` — H1–H4 happy path + F1–F6 실패/엣지 시나리오; AC 커버리지 시나리오별 매핑; D4.x2 frontmatter 적용 (stage: 12, bundle: 1+4, validation_group: 1, status: draft).
  - `docs/05_qa_release/release_checklist.md` + `release_checklist.ko.md` — Stage 13 태그 게이트 정본; pre-flight, CI 매트릭스, QA 사인오프, 문서 게이트, 리포 위생, 태그 mechanics, 릴리스 후, 사인오프 총 8 섹션. D4.x2 frontmatter 적용.
  - `CHANGELOG.md` `[0.3.0]` 엔트리 — Keep a Changelog v1.1.0 형식; Added/Changed/Fixed 섹션이 Bundle 1 + Bundle 4 shipped 표면 전체 커버; "Deferred to v0.4" 서브섹션이 Stage 12 에서 미실행된 Stage 11 optional forward 열거; TBD 태그 날짜 플레이스홀더.
  - `prompts/claude/v03/stage12_qa_release_prompt.md` — Stage 11 패턴과 매칭되는 canonical Stage 12 kickoff 프롬프트 (EN, 137 줄).
- **트리 랜딩된 Housekeeping (Stage 11 non-blocking forward):**
  - `tests/bundle1/run_bundle1.sh` 53 행: `rg '^## [1-8]\. ' "$SKILL"` → `grep -E '^## [1-8]\. ' "$SKILL"`. ripgrep 의존성 제거; 하네스 전체가 POSIX-clean. 스왑 후 Bundle 1: 10/10 PASS.
  - `docs/04_implementation/implementation_progress.md` (+ `.ko.md`) Stage 9 Bundle 1 판정 표: AC.B1.6 과 AC.B1.8 행의 Notes 교환, 레이블이 `docs/03_design/bundle1_tool_picker/technical_design.md` 정의와 정렬 (AC.B1.6 = D1.x 참조 페어; AC.B1.8 = verbatim clause). AC.B1.8 Notes 를 업데이트하여 SKILL.md verbatim 일치 AND v0.4 로 forward 된 tech_design Sec. 0 paraphrase-vs-verbatim 위생 플래그 기록.
- **v0.4 로 연기 (이번 stage 에 미실행된 optional forward):**
  - `.skills/tool-picker/SKILL.md` Sec. 6 worked example 을 live Stage-12 triple 로 refresh.
  - `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 에 D4.x2/x3/x4 를 verbatim paste refresh (AC.B1.8 강화; SKILL.md 표면은 이미 verbatim 준수이므로 tech_design Sec. 0 refresh 는 doc-hygiene 전용).
- **Pre-flight + 각 편집 후 체크:** `bash tests/bundle1/run_bundle1.sh` → 10/10 PASS; `sh tests/run_bundle4.sh` → 4/4 PASS. 이 세션의 모든 mutation (rg swap, label swap, qa_scenarios 저작, release_checklist 저작, CHANGELOG append) 후 재실행.
- **CI forward (Stage 13 pre-tag 로 이월):**
  - `shellcheck -S style scripts/update_handoff.sh` mac + Linux.
  - 전체 테스트 매트릭스 (`tests/bundle1/run_bundle1.sh`, `tests/run_bundle4.sh`) mac + Linux.
  이 2건이 `[0.3.0]` TBD 날짜 확정 외에 남은 유일한 pre-tag 전제조건.
- **HANDOFF.md 업데이트 기록:** Status 라인을 Stage 12 완료 (Stage 13 게이트 오픈) 로 전환; bundles YAML `stage 11→12` (Stage 11 APPROVED 에 따라 verdict `minor` 이월); Stage 11 close 커밋 (`d453ea1`) + Stage 12 QA & Release 준비를 위한 Recent Changes 상단 신규 엔트리; Key Document Links 에 `qa_scenarios.md`, `release_checklist.md`, `CHANGELOG.md` 행 추가; Next Session Prompt 블록 (EN + KO) 을 Stage 13 태그용으로 재작성. EN + KO 미러 모두 갱신.
- **Stage 11 close 커밋:** 이 Stage 12 작업 직전에 `d453ea1` 가 9 파일 번들 (+804/−199); CLAUDE.md git 안전 정책에 따라 global git config 를 수정하지 않기 위해 inline `git -c user.name/email` 플래그 사용.
- **Dogfooding 메모:** 계속 `scripts/update_handoff.sh` 미사용 — Stage 12 close 가 스크립트의 2-섹션 계약이 지원하는 것보다 훨씬 많은 표면 (Status, In Progress, Next, Blockers, Bundles YAML, Recent Changes, Key Document Links, Next Session Prompt, KO 미러) 을 건드림. 수작업 단일 패스; 테스트 하네스 재실행 green.
- **세션-종료 git 정책 (CLAUDE.md):** 세션 6 의 이 Stage 12 부분 종료 시 사용자에게 지금 커밋할지 보류할지 질문. 후보 커밋 내용: `HANDOFF.md`, `CHANGELOG.md`, `docs/04_implementation/implementation_progress.{md,ko.md}`, `docs/notes/dev_history.{md,ko.md}`, `tests/bundle1/run_bundle1.sh`, `docs/05_qa_release/{qa_scenarios,release_checklist}.{md,ko.md}`, `prompts/claude/v03/stage12_qa_release_prompt.md`. 열거된 것 외 신규 untracked 디렉터리 없음.
- **재진입:** 불필요. Stage 12 는 검증 단계가 아니므로 재진입 유발 verdict 메커니즘 없음. Stage 13 으로 진행.
- **다음 세션:** Stage 13 릴리스 태그. Paste 블록은 HANDOFF.md Sec. "📋 다음 세션 시작 프롬프트" (Stage 13 kickoff, 지금 설치됨).

---

## 세션 7 — 2026-04-22 (UTC)

### Entry 3.14 — Stage 13 릴리스 준비 + 태그 대상

- **Stage:** 13 (릴리스 태그, plan_final M.6 에 따른 공동; validation_group = 1).
- **Owner:** Claude (세션 7 — 세션 6 종료 후 사용자 재론칭으로 새 세션. M.3 는 Stage 11 에만 적용되므로 Stage 13 은 새 세션이 필수는 아니지만 세션 6 이 ~95% 컨텍스트 바운드까지 돌았기에 클린 세션이 바람직).
- **Input:** `docs/05_qa_release/release_checklist.md` (권위 있는 태그 게이트, Stage 12 산출물), `docs/05_qa_release/qa_scenarios.md` (H1–H4 + F1–F6), `CHANGELOG.md` `[0.3.0]` (Stage 12 에서 TBD 날짜 플레이스홀더), Stage 12 close 커밋 `08a43fd` (이 세션의 첫 액션 — 아래 "Pre-flight" 참조).
- **Output (이 엔트리 — pre-tag):**
  - **Pre-flight:** Stage 12 close 커밋 `08a43fd` (부모 `d453ea1`). 12 파일 / +1050 / −93. Stage 12 uncommitted 집합 전체 번들 (`HANDOFF.md`, `CHANGELOG.md`, `docs/04_implementation/implementation_progress.{md,ko.md}`, `docs/notes/dev_history.{md,ko.md}`, `tests/bundle1/run_bundle1.sh`, `docs/05_qa_release/{qa_scenarios,release_checklist}.{md,ko.md}`, `prompts/claude/v03/stage12_qa_release_prompt.md`). 커밋 메시지 "Stage 12 QA & Release prep close — validation_group 1 (session 6 continuation)". CLAUDE.md git 안전 정책에 따라 inline `git -c user.name='Hyoungjin' -c user.email='geenya36@gmail.com'` 플래그 사용. `08a43fd` 에서 양 하네스 재실행 green: `bash tests/bundle1/run_bundle1.sh` → 10/10 PASS; `sh tests/run_bundle4.sh` → 4/4 PASS.
  - **CI 매트릭스 Linux 사이드 (release_checklist.md Sec. 1.1):** 9 행 결과 레저 채움. Linux aarch64 (Ubuntu 22, 샌드박스) 행 1.a–1.e 전부 green: 하네스 PASS + 프록시 셸 (`sh -n` + `dash -n` + `bash -n`) 전부 exit 0. 행 1.f (실제 `shellcheck`) 사용 불가 — 바이너리 미설치, `apt-get install` 차단 (root 없음). `CHANGELOG.md` `[Unreleased]` CI/infra 섹션에 v0.4 백로그 항목 seed: "Linux CI 러너에 `shellcheck` 설치하여 v0.3 프록시를 `shellcheck -S style scripts/update_handoff.sh` 로 교체". 행 1.g–1.i (mac) 은 사용자의 Stage 13 방향 (패턴 1 — "일단 1번으로 하고 나중에 개선점을 찾아보자" → 운영자가 mac 로컬 실행, 자동화는 v0.4) 에 따라 **operator-paste 행으로 캡처**.
  - **QA 게이트 (release_checklist.md Sec. 2):** H1–H4 전부 inline 증거와 함께 tick. H1 PASS (하네스 10/10 + SKILL.md Sec. 6 5줄 advisory shape). H2 PASS (하네스 4/4). H3 PASS (`diff <(sed -n '24,62p' docs/notes/decisions.md) <(sed -n '34,72p' .skills/tool-picker/SKILL.md)` 빈 결과; `grep -nE '\]\(' .skills/tool-picker/SKILL.md` 0 매치; backlink 행 45/55/72 이 D4.x4 상대경로 형식 사용). H4 PASS (모든 Stage-5+ EN/KO 페어 `updated:` Δ=0; Stage 1–4 페어는 같은 git-log 날짜 공유). F1–F6 절차 current 확인 — 참조 파일 전부 트리 상 존재 (SKILL.md Sec. 7 + tech_design Sec. 6 + `tests/bundle4/test_02_update_handoff_failures.sh` + `test_04_frontmatter_and_stage1_4.sh` + SKILL.md Sec. 3). 태그 커밋에서 실제로 트리를 깨뜨릴 필요 없음.
  - **문서 게이트 (release_checklist.md Sec. 3):**
    - `CHANGELOG.md`: `## [0.3.0] - TBD` → `## [0.3.0] - 2026-04-22`; blockquote 추가 "Released 2026-04-22 (UTC) under a single joint `v0.3` git tag per plan_final M.6. Validation Group 1 = Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β)."
    - `CHANGELOG.md` `[Unreleased]`: 빈 stub 유지 (Added / Changed / Deprecated / Removed / Fixed / Security) + 서브섹션 하나 populate — "CI / infra (v0.4 backlog seed, carried forward from v0.3 Stage 13)" 에 CI 2 항목 (shellcheck 설치, mac CI 자동화) 열거.
    - `release_checklist.md` (+ `.ko.md`): frontmatter `version: 1 → 2`, `status: draft → in_progress`; Sec. 1 Linux-side + 프록시 체크박스 tick, mac 행은 unticked (operator paste 대기); Sec. 1.1 "결과 레저" 서브섹션 9 행 삽입; Sec. 2 H1–H4 + F1–F6 체크박스 전부 inline 증거와 함께 tick.
    - `HANDOFF.md` (EN + KO): Status 라인 → "Stage 13 🟡 **tag target committed; `v0.3` tag to be cut on this commit**"; bundles YAML `stage: 12 → 13` (Stage 11 APPROVED 에 따라 verdict `minor` 이월); 완료 엔트리 4 개 신규 (Stage 12 close 커밋 `08a43fd`, Stage 13 CI 매트릭스 Linux 사이드, Stage 13 QA 게이트, Stage 13 문서 게이트); In Progress / Next / Blockers 를 세션-7-중반 상태로 재작성; Recent Changes 상단 2 엔트리 추가 (Stage 13 릴리스 준비 + 태그 대상, Stage 12 close 커밋); Key Document Links 갱신 (release_checklist 행 "Sec. 1.1 + Sec. 2–3 ticked"; CHANGELOG 행 "[0.3.0] - 2026-04-22 finalised"); Next Session Prompt 블록을 v0.4 planning kickoff (6 항목 백로그 + mid-session-7 resume fallback 메모) 로 재작성. KO 미러 lockstep 편집.
- **판정:** Pre-tag 게이트 PASS; release_checklist.md Sec. 0–3 박스 전부 tick (단, 3 개 mac operator-paste 행은 비동기이며 사용자가 선택한 Stage 13 방향 하에서 태그-blocking 이 아님).
- **태그 대상 커밋:** 이 dev_history Entry 3.14 + HANDOFF + release_checklist + CHANGELOG 편집을 담은 커밋. 커밋 메시지 타깃: "[bundle1+bundle4] Stage 13 release prep — v0.3 tag target (validation_group 1)". 부모 `08a43fd`.
- **다음 (세션 7 연속 — Entry 3.15):** 이 엔트리의 태그 대상 커밋에서 `git tag -a v0.3 -m "jOneFlow v0.3 — Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β); joint release per M.6"`; `git push origin main && git push origin v0.3`; `gh release create v0.3 -F <CHANGELOG [0.3.0] 본문>` (fallback: GitHub UI 수동 오픈); HANDOFF 상태 라인을 "v0.3 released; v0.4 planning open" 으로 flip 하고 실제 태그 SHA 와 함께 Entry 3.15 기록하는 post-release 커밋. 세션-종료 git 정책 (CLAUDE.md 서브섹션) 적용 — 사용자에게 태그+post-release 커밋을 지금 푸시할지 defer 할지 질문.
- **Dogfooding 메모:** 이 스테이지에서도 `scripts/update_handoff.sh` 미사용 — Stage 13 HANDOFF 업데이트가 Status 라인 + bundles YAML + 완료 리스트 + In Progress + Next + Blockers + Recent Changes + Key Document Links + Next Session Prompt 에 걸쳐 EN + KO 미러 양쪽에 영향, 스크립트의 2-섹션 계약 범위를 훨씬 초과. 스크립트 커버리지 확장은 v0.4 백로그 후보 (아직 목록화되지 않음 — 추진 시 7번 항목으로 추가 가능).
- **재진입:** 없음. Stage 13 은 릴리스 메커닉; verdict 분기 없음. 태그 생성으로 continue.

---

### Entry 3.15 — Stage 13 post-release (v0.3 태그 cut + 로컬 완료)

- **Stage:** 13 (릴리스 태그, post-tag). plan_final M.6 에 따른 공동 릴리스; validation_group = 1.
- **Owner:** Claude (Entry 3.14 의 세션 7 연속).
- **Input:** Entry 3.14 산출물 (태그 대상 커밋 `ebb1e98`, 모든 Stage 13 문서 게이트 tick), `docs/05_qa_release/release_checklist.md` Sec. 4–7, 사용자의 Stage 13 방향 (옵션 3: "Create + push tag + attempt gh release").
- **Output (이 엔트리 — post-tag):**
  - **태그 대상 커밋:** `ebb1e98` (full SHA `ebb1e985dfeb3e53e75f281cd9588ea204af0b6f`). 6 파일 (+221/−158). 메시지 "[bundle1+bundle4] Stage 13 release prep — v0.3 tag target (validation_group 1)". 부모 `08a43fd`. `main` 커밋 체인: `d453ea1` (Stage 11 close) → `08a43fd` (Stage 12 close) → `ebb1e98` (Stage 13 릴리스 준비 / 태그 대상).
  - **Annotated 태그 (로컬):** `git -c user.name='Hyoungjin' -c user.email='geenya36@gmail.com' tag -a v0.3 -m "jOneFlow v0.3 — Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β); joint release per M.6"` on `ebb1e98`. 태그 오브젝트 SHA `f2069cfb7cbb041c125f885ed552aa06d66bb5b7` (lightweight 태그 아님 — `git cat-file -t v0.3` = `tag`).
  - **리포 위생 (Sec. 4):** `ebb1e98` 에서 working tree clean (post-release 커밋 전); 트리에 `.bak.<ts>.<pid>` 파일 없음 (커밋 `1e4cda9` 의 `.gitignore` 62 행 `*.bak.*` 규칙 활성); untracked 혹은 시크릿 파일 없음.
  - **Push 시도 + Fallback:** 샌드박스에서 `git push origin main` 이 `fatal: could not read Username for 'https://github.com': No such device or address` 반환 — 샌드박스에 git 크레덴셜 없음. 릴리스 메커닉은 release_checklist.md Sec. 5.1 에 따라 운영자 로컬 셸로 fallback. 운영자 실행: (a) `git push origin main` (`d453ea1` → `08a43fd` → `ebb1e98` 푸시); (b) `git push origin v0.3` (annotated 태그 `f2069cf` 푸시); (c) GitHub 릴리스는 `gh release create v0.3 -F <(awk '/^## \[0.3.0\]/,/^## \[Unreleased\]/' CHANGELOG.md | head -n -2)` 혹은 UI → Releases → Draft → 태그 `v0.3` → 본문 = CHANGELOG `[0.3.0]` 섹션.
  - **Post-release 산출물 (Sec. 6):**
    - `HANDOFF.md` (EN + KO): Status 라인 "v0.3 released; v0.4 planning open" 으로 flip; 양 번들 bundles YAML `stage: 13 → stage: released` + 인라인 주석 `# v0.3 released 2026-04-22 (tag f2069cf → commit ebb1e98); Stage 13 complete`; In Progress 섹션 clear ("None — Stage 13 complete locally"); Next 섹션 운영자 push + 다음 세션 킥오프로 재작성; Blockers = None; Recent Changes 상단 신규 엔트리 "v0.3 released (세션 7 종료)" (EN + KO).
    - `docs/notes/dev_history.md` (+ `.ko.md`): 이 Entry 3.15 추가; 개정 로그 v1.7 → v1.8.
    - `release_checklist.md` (+ `.ko.md`): Sec. 4 (리포 위생) 증거와 함께 tick; Sec. 5.1 실행 로그에 태그 생성 + push-pending 캡처; Sec. 6 post-release tick (이 엔트리 참조); Sec. 7 사인오프 tick; frontmatter `version: 2 → 3`, `status: in_progress → signed_off`; 개정 로그 +v3.
  - **v0.4 백로그 seed:** 이 엔트리 이전에 이미 배치 — HANDOFF 다음 세션 시작 프롬프트에 6 항목 (SKILL.md Sec. 6 live-triple, tech_design Sec. 0 verbatim, shellcheck 설치, mac CI 자동화, Bundles 2/3 re-scope, § 섹션기호 제거); CHANGELOG `[Unreleased]` 에 CI/infra 2 항목. Entry 3.15 에서 추가 seed 불필요.
- **판정:** v0.3 는 plan_final M.6 에 따라 로컬 완료 (단일 공동 `v0.3` git 태그가 Bundle 1 + Bundle 4 커버). Push 와 GitHub 릴리스는 태그 SHA 를 바꾸지 않는 운영자 사이드 메커닉; push 후 origin 의 태그 SHA `f2069cf` 는 로컬 SHA 와 바이트 단위로 일치 (git 태그는 content-addressed).
- **Deferred (세션-종료 후 운영자 액션):** push + `gh release create`; mac CI 운영자 paste (release_checklist.md Sec. 1.1 1.g–1.i 행).
- **세션-종료 git 정책 (CLAUDE.md):** 세션 7 종료 시 사용자에게 질문 — (a) 본인 로컬 셸에서 지금 push 하고 GitHub 릴리스를 오픈할지, (b) 세션 8 open 까지 defer 할지. 어느 선택이든 로컬 커밋+태그는 이미 랜딩되어 있으므로 일관; HANDOFF.md Status 라인 + release_checklist.md Sec. 5.1 가 push-pending 상태 문서화.
- **재진입:** 없음. Stage 13 은 planning/validation 관점에서 완료; 릴리스가 로컬 git 태그로 존재. 다음 jOneFlow 사이클은 v0.4 planning (Stage 1 브레인스토밍 — HANDOFF.md 의 다음 세션 시작 프롬프트 블록에 따라 fresh 세션 8).
- **다음 세션:** 세션 8 = v0.4 planning kickoff. HANDOFF.md Sec. "📋 다음 세션 시작 프롬프트" 의 "Start v0.4 planning — jOneFlow. v0.3 released 2026-04-22 under single joint tag per M.6." 블록 사용.

---

### Entry 3.16 — v0.4 를 회고 + 단순화 릴리스로 재정의; v0.5 가 기존 v0.4 백로그 승계

- **Stage:** housekeeping (세션 7 close, 사용자 방향 범위 변경).
- **Owner:** Claude + user.
- **Input:** 세션 7 close 에서 사용자의 문제 제기 — "프로젝트를 쉽게 진행하기 위해 만든 템플릿인데, 사용이 너무 복잡해지고 있다". v0.3 의 7 세션 빌드 (13 stages × 2 bundles × EN+KO 페어 × validation groups × M.1/M.3/M.5/M.6 게이트 × AC cross-bundle 매트릭스 × D4.x 프론트매터 × R4 ≤1일 freshness × R2 읽기 전용 불변식 × 이중 하네스 × release_checklist + dev_history + HANDOFF + CHANGELOG 4중 문서 갱신) 를 dogfooding 증거로 제시 — self-reflexive 역설: jOneFlow 로 jOneFlow 를 만드는 것이 무거웠다.
- **결정 (명시적 사용자 지시):**
  1. v0.3 리모트 push 는 운영자가 로컬 셸에서 실행 (세션 7 close 에 통합 push 명령 전달).
  2. **기존 v0.4 의 6 항목 백로그를 v0.5 로 reindex.** 원래 항목: SKILL.md Sec. 6 live-triple refresh; `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 verbatim-paste refresh; Linux CI shellcheck 설치; mac 사이드 CI 자동화; Bundle 2 + Bundle 3 re-scope; canonical 프롬프트 템플릿에서 `§` 섹션 기호 제거.
  3. **v0.4 는 회고 + 단순화 릴리스로 재정의** — 메타 범위, 신규 번들 없음, 기능 추가 없음. v0.4 의 역할은 (a) v0.3 빌드의 구체적 마찰점 catalogue, (b) 워크플로우 자체의 단순화 제안. 산출물 형태 (잠정): 브레인스토밍 1 건 + 단순화 제안 문서 1 건; 코드 변경 최소; 신규 번들 없음.
- **Output (이 step 에서 랜딩한 artefacts):**
  - `CHANGELOG.md` `[Unreleased]`: CI/infra 섹션을 "Planned for v0.5" 로 리네임 + 6 항목 인계 + 7 번째 항목 (UI base-only sunset 앵커, v0.3 brainstorm Sec. 9) 추가. 상단에 새 "Planned for v0.4 (retrospective + simplification release — meta scope, no feature adds)" 블록 추가. `[0.3.0]` 섹션의 "Deferred to v0.4" 헤더를 "Deferred to v0.5 (originally queued for v0.4; reindexed 2026-04-23 when v0.4 was redefined)" 로 리네임.
  - `HANDOFF.md` (EN + KO): Status 라인을 "v0.3 released; v0.4 = 회고 + 단순화; 기능 백로그는 v0.5 로 reindex" 로 갱신; 마지막 업데이트 2026-04-23; 다음 세션 시작 프롬프트 (양 언어) 를 기능 계획 모드에서 회고 모드로 재작성 — v0.5 백로그 (7 항목), v0.4 범위 선언, 이번 세션 close 에서 deferred 된 A/B/C discovery 질문 포함. Recent Changes 상단 2026-04-23 엔트리 추가 (EN + KO).
  - `docs/notes/dev_history.md` (+ `.ko.md`): 이 Entry 3.16 추가; 개정 로그 → v1.9.
- **v0.4 가 메타가 아닌 기능 릴리스가 되지 않는 근거:** v0.3 dogfooding 이 자체 반증을 만들어냄 — "프로젝트를 쉽게" 하는 템플릿이 7 세션, 13 stages, 4 개 동기화 문서, 이중 언어 페어를 써서 자신을 릴리스한다면 이미 증상이다. 기존 6 항목 백로그로 v0.4 에 바로 진입하면 root cause 진단 없이 scope 만 쌓인다. 따라서 v0.4 는 introspection + 단순화 제안에 투입; v0.5 가 (바라건대) 더 가벼운 베이스 위에서 기능 작업을 재개.
- **비결정 사항 (세션 8 오픈으로 명시 이월):**
  - A. v0.3 의 top 1–3 마찰점 (후보는 HANDOFF 다음 세션 시작 프롬프트에 열거).
  - B. "기본 모드" 목표 난이도 (Light / Default / 현재 Strict).
  - C. v0.4 자체 진행 모드 (α = 13-stage 완전, 변경은 v0.5 에서 반영 / β = Stage 2 부터 라이브 단순화 / γ = 1/2/12/13 유지 + 3–11 압축).
- **판정:** 범위 변경 기록; artefacts 가 CHANGELOG + HANDOFF + dev_history (EN + KO) 에 동기화; v0.3 태그는 `ebb1e98` 에 고정 유지 (태그 SHA `f2069cf`); 이 엔트리는 `main` 의 `032a095` (post-release) 이후 새 커밋에 랜딩. 문서 대규모 편집 후 양 하네스 재실행 green 으로 구조 regression 없음 확인.
- **재진입:** 없음 — 세션 8 은 v0.4 회고로 바로 진입.
- **세션 종료 사유:** 사용자가 오늘 세션을 v0.3 close 경계에서 끝내기를 요청; 회고 discovery (A/B/C 응답) 는 세션 8 오픈에서 개시.

---

## Entry 템플릿 (향후 세션용)

```markdown
### Entry N.M — [stage 또는 step 이름]

- **Stage:** [n 및 이름, 또는 "housekeeping"]
- **Owner:** [Claude / Codex / user]
- **Input:** [참조한 artifacts]
- **Output:** [경로 + 해당 시 KO 페어 메모]
- **판정:** [PASS / NEEDS REVISION (minor|bug_fix|design_level) / APPROVED / BLOCKED]
- **이월된 주요 결정:** [stage 포인터와 함께 bullet]
- **이 step에서 연/닫은 open question:** [OQ 참조]
- **세션 종료 사유 (세션 경계일 때):** [트리거]
```

---

## 본 문서 개정 로그

| 날짜 | 개정 | 메모 |
|------|------|------|
| 2026-04-22 | v1 — 초기 backfill (세션 3 재개) | 세션 1, 2, 3 (토큰 충전 이전/이후)를 stage 단위로 커버. plan_final AN.3 + DC.2 부분 충족. 영문 페어 동일 세션에 작성. |
| 2026-04-22 | v1.1 — Stage 5 Bundle 4 종료 (Entry 3.7) | Stage 5 Bundle 4 기술 설계 (EN + KO 페어) Entry 3.7 추가. 세션 요약표 갱신. |
| 2026-04-22 | v1.2 — Stage 5 Bundle 1 종료 (Entry 3.8) | Stage 5 Bundle 1 기술 설계 (EN + KO 페어) Entry 3.8 추가. 세션 요약표 갱신 (Bundle 1 을 세션 3 재개 행에 추가). 양 번들 Stage 5 완료; 다음 stage = Stage 8 Codex. EN 페어 동시 갱신. |
| 2026-04-22 | v1.3 — Stage 8 + 9 Bundle 4 종료 backfill (Entry 3.9) + Stage 8 + 9 Bundle 1 종료 (Entry 3.10) | Entry 3.9 를 KO 미러로 backfill (EN 파일에는 이미 있었던 R4 누락 복구) + Entry 3.10 추가 (Stage 8 + 9 Bundle 1 마감, PASS — minor). Validation group 1 의 양 번들 Stage 9 모두 마감; 다음 stage = Stage 10/11. EN 페어 동시 갱신. |
| 2026-04-22 | v1.4 — Stage 11 prep 종료 (Entry 3.11) | Entry 3.11 추가 (DC.6 dossier + ko_freshness 스크래치 산출; CLAUDE.md "Session close — git policy" 서브섹션 고정; 두 번들 PASS — minor 이므로 Stage 10 생략). CLAUDE.md 편집은 사용자 defer 선택에 따라 uncommitted 로 유지; HANDOFF.md 가 Stage 11 세션을 위해 해당 상태 플래그. EN 페어 동시 갱신. |
| 2026-04-22 | v1.5 — Stage 11 joint validation 종료 (Entry 3.12) | Entry 3.12 추가 — 그룹 판정 APPROVED (M.5 worst-of-two), Bundle 1 + Bundle 4 모두 APPROVED, `docs/notes/final_validation.md` (EN) + `final_validation.ko.md` (KO) 가 D4.x2 frontmatter (stage: 11, validation_group: 1, status: approved) 와 함께 발행. Cross-bundle 검증: AC.B4.10 verbatim 일치 문자 단위 확인; AC.B4.11 구조상 vacuous; KO freshness 7 페어 / 0 일 델타 독립 재검증. Bundle 1 의 non-blocking 4 건 + Bundle 4 의 3 건 을 Stage 12 housekeeping 으로 forward. HANDOFF.md 갱신 (bundles stage 9→11, verdict minor 이월, Recent Changes 그룹 단위 노트, Next Session Prompt 를 Stage 12 kickoff 로 전환). EN 페어 동시 갱신. |
| 2026-04-22 | v1.6 — Stage 12 QA & Release prep 종료 (Entry 3.13) | Entry 3.13 추가 — Stage 11 과 동일 세션 6 연속. 새 산출물: `docs/05_qa_release/qa_scenarios.md` + `.ko.md` (H1–H4 happy-path + F1–F6 failure/edge), `docs/05_qa_release/release_checklist.md` + `.ko.md` (Stage 13 gate, 0–8 절), `prompts/claude/v03/stage12_qa_release_prompt.md` (Stage 12 kickoff), `CHANGELOG.md` `[0.3.0]` 섹션 (TBD 날짜). On-tree 해소된 housekeeping: `tests/bundle1/run_bundle1.sh` 의 `rg` → `grep -E` 스왑 (POSIX cleanliness), `implementation_progress.md` + `.ko.md` 의 AC.B1.6/B1.8 라벨 스왑. v0.4 로 deferred: SKILL.md Sec. 6 live tool-picker triple, tech_design Sec. 0 verbatim refresh, CI matrix (mac + Linux), Bundle 4 non-blocking #3 (atomicity 문서화). 양 하네스 green (Bundle 1 10/10, Bundle 4 4/4). HANDOFF.md 갱신 (bundles stage 11→12, Next Session Prompt 를 Stage 13 tag kickoff 로 전환). Stage 11 close commit `d453ea1` 가 prerequisite. EN 페어 동시 갱신. |
| 2026-04-22 | v1.7 — Stage 13 릴리스 준비 + 태그 대상 (Entry 3.14) | Entry 3.14 추가 — 세션 7, Stage 13 릴리스-태그 메커닉. Pre-flight: Stage 12 close 커밋 `08a43fd` (12 파일, +1050/−93, 부모 `d453ea1`). CI 매트릭스 Linux 사이드 (release_checklist.md Sec. 1.1): 행 1.a–1.e 전부 green (하네스 + `sh -n` + `dash -n` + `bash -n` 프록시); 행 1.f 실제 `shellcheck` 사용 불가, `CHANGELOG.md` `[Unreleased]` CI/infra 블록에 v0.4 백로그 seed; 행 1.g–1.i mac operator-paste 는 사용자의 Stage 13 패턴-1 방향. QA 게이트: H1–H4 inline 증거와 함께 PASS; F1–F6 current. 문서 게이트: `CHANGELOG.md` `[0.3.0] - TBD` → `[0.3.0] - 2026-04-22` 확정; `[Unreleased]` stub 리셋 + CI/infra v0.4 백로그 seed. `release_checklist.md` (+ `.ko.md`) version 1→2, status draft→in_progress, Sec. 1.1 결과 레저 채움, Sec. 2–3 체크박스 tick. `HANDOFF.md` (EN + KO) Status 라인을 "Stage 13 태그 대상 커밋됨" 으로 flip, bundles YAML `stage 12→13`, 완료 리스트 +4 엔트리, Recent Changes 상단 2 엔트리, Next Session Prompt 를 v0.4 planning kickoff (6 항목 백로그 + fallback) 로 재작성. 세션-요약표 +4 행 (세션 4/5/6/7). |
| 2026-04-23 | v1.9 — v0.4 를 회고 + 단순화 릴리스로 재정의 (Entry 3.16) | Entry 3.16 추가 — 세션 7 close, 사용자 방향 범위 변경. 기존 6 항목 v0.4 기능 백로그를 v0.5 로 reindex (SKILL.md Sec. 6 live-triple refresh, tech_design Sec. 0 verbatim-paste refresh, shellcheck 설치, mac CI 자동화, Bundle 2 + Bundle 3 re-scope, `§` 섹션 기호 제거) + 신규 7 번째 항목 (UI base-only sunset 앵커, v0.3 brainstorm Sec. 9). v0.4 를 메타 릴리스로 재정의: v0.3 dogfooding 마찰점 회고 + 워크플로우 단순화 제안; 신규 번들 없음, 기능 추가 없음. `CHANGELOG.md [Unreleased]` 는 "Planned for v0.4" 와 "Planned for v0.5" 블록 분리; `[0.3.0]` "Deferred to v0.4" → "Deferred to v0.5" 리네임. HANDOFF.md (EN + KO) Status 라인 + 다음 세션 시작 프롬프트 + Recent Changes 갱신; 마지막 업데이트 2026-04-23. 3 개 discovery 질문 (A: 주요 마찰점, B: 기본 모드 목표 난이도, C: v0.4 진행 모드) 은 이번 세션 close 에서 세션 8 오픈으로 이월. EN 페어 동시 갱신. |
| 2026-04-22 | v1.8 — Stage 13 post-release / v0.3 released (Entry 3.15) | Entry 3.15 추가 — 세션 7 연속. 태그 대상 커밋 `ebb1e98` (6 파일, +221/−158, 부모 `08a43fd`). Annotated 태그 `v0.3` 로컬 생성: 태그 오브젝트 SHA `f2069cfb7cbb041c125f885ed552aa06d66bb5b7` → 커밋 `ebb1e985dfeb3e53e75f281cd9588ea204af0b6f`. 리포 위생 tick (클린 트리, `.bak.*` 없음, 시크릿 없음). 샌드박스 push 시도 실패 (크레덴셜 없음) → release_checklist.md Sec. 5.1 에 따라 운영자 로컬 셸로 fallback. Post-release 산출물: HANDOFF.md (EN + KO) Status 라인 → "v0.3 released; v0.4 planning open", 양 번들 bundles YAML `stage: 13 → released`, Recent Changes 상단 신규 엔트리. `release_checklist.md` (+ `.ko.md`) Sec. 4 + Sec. 6 + Sec. 7 tick; Sec. 5.1 실행 로그 채움; frontmatter `version: 2→3`, `status: in_progress → signed_off`. v0.4 백로그는 이전 엔트리에서 이미 seed (추가 seed 없음). 운영자 사이드 잔여: `git push origin main && git push origin v0.3`; `gh release create v0.3` 혹은 GitHub UI. 세션-종료 git 정책 질문은 세션 종료 시 사용자 대화로 이관. |
