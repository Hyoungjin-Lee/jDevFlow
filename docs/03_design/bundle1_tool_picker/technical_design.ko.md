---
title: 기술 설계 — Bundle 1 (Tool-Picker)
stage: 5
bundle: 1
version: 1
language: ko
paired_with: technical_design.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# 기술 설계 — Bundle 1 (Tool-Picker)

**프로젝트:** jDevFlow v0.3
**단계(Stage):** 5 (기술 설계)
**일자:** 2026-04-22 (세션 3 재개)
**모드:** Strict-hybrid (상위 Strict + 번들 내부 Standard)
**입력:** `docs/02_planning/plan_final.md` (Stage 4.5 합동 승인, 2026-04-22) · `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0 (D4.x2/x3/x4 잠금) · `prompts/claude/v03/stage5_bundle1_design_prompt_draft.md` (DC.5 #2)
**페어 KO 출력:** 본 문서 (R4 규율에 따라 같은 세션에 작성)
**리스크 레벨:** medium-high
**has_ui:** false

---

## KO 동기화 체크 (plan_review Sec. 4-3 재사용 블록)

KO 페어 작성 후 점검:

- [x] EN ↔ KO 섹션 헤더 개수 동일
- [x] 북극성 문장(또는 Sec. 1 의 등가 문구)이 KO 에 존재하고 내용이 동일
- [x] 결정 테이블 형태 (stage × mode × risk_level) 가 양쪽 문서에서 동일
- [x] 수락 기준 항목 개수가 양쪽 문서에서 동일 (AC.B1.1–10, 10 항목 / 10 항목)

(단계 종료 시점 2026-04-22 에 체크 완료.)

---

## 0. DEP.1 선행 — Bundle 4 Sec. 0 결정 인용

> **출처.** `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0, 2026-04-22 잠금. 아래 세 결정은 원문 그대로 인용 (Bundle 1 은 재결정하지 않고 결합해야 함). 변경은 Stage 5 Bundle 4 재진입을 요구.

- **D4.x2 — 내부 문서 헤더 스키마.** Stage 5 이후 문서에만 YAML 프론트매터; Stage 1–4 내러티브 / 이중언어 문서는 프로즈만 유지. 최소 필수 필드: `title, stage, bundle, version, language, paired_with, created, updated` (선택: `status, supersedes, validation_group`).
- **D4.x3 — 번들 폴더 명명 규칙.** `bundle{id}_{name}/`, snake_case `{name}`. 정규식 `^bundle(\d+)_(.+)$` 으로 `{id}` 와 `{name}` 을 결정적으로 추출.
- **D4.x4 — 문서 링크 규칙.** 항상 현재 파일 기준 상대경로; 프로젝트 루트 절대경로 금지. 앵커 스타일은 GitHub 규칙: 소문자 + 공백은 하이픈 + 구두점 제거. `file.md#section-header-lowercased-hyphenated`.

Bundle 1 의 추천 로직은 `HANDOFF.md` 와 그것이 인용하는 Stage-5+ 문서를 파싱; Stage 1–4 문서는 절대 파싱하지 않는다 (프론트매터 키 없음). `SKILL.md` 내부의 모든 내부 참조는 D4.x4 링크 스타일 사용.

---

## 1. 아키텍처 개요

Bundle 1 은 **단일 Markdown 파일** (`.skills/tool-picker/SKILL.md`) 로, Claude Code 의 기존 스킬 메커니즘이 소비한다. `HANDOFF.md` 에서 읽어온 현재 `(stage, mode, risk_level)` 트리플에 기반해 **권고성 추천** — 다음 단계의 도구 · 문서 · 체크리스트 순위 목록 — 을 방출한다. 그것이 전부다.

```
┌──────────────────────────────────────────────────────────────────┐
│                    .skills/tool-picker/SKILL.md                  │
├──────────────────────────────────────────────────────────────────┤
│  ── YAML 프론트매터 ──                                             │
│    name: tool-picker                                             │
│    description: >-                                               │
│      Advisory next-step recommender for jDevFlow. Triggers       │
│      when the user enters a new Stage, asks "what next", or      │
│      mentions jDevFlow + stage/mode/risk. Reads HANDOFF.md       │
│      and returns a ranked action list.                           │
│                                                                  │
│  ── 지시 본문 ──                                                   │
│    Sec. 1  목적 & 범위 (권고 전용; R2 불변식)                        │
│    Sec. 2  입력 (HANDOFF.md 트리플 + 선택적 사용자 의도)             │
│    Sec. 3  결정 테이블 (stage × mode × risk_level)                │
│    Sec. 4  출력 포맷 (순위 목록, 채팅 출력, 모달 아님)                │
│    Sec. 5  트리거 (stage 진입 자동 + 사용자 요청 on-demand)           │
│    Sec. 6  Worked example (Strict-hybrid Stage 2 진입)            │
│    Sec. 7  실패 모드 (HANDOFF 부재, 트리플 불량 등)                   │
│    Sec. 8  호출 참조 (CLAUDE.md 가 본 파일을 어떻게 가리키는지)        │
└──────────────────────────────────────────────────────────────────┘
                      │
                      ▼
     CLAUDE.md "Read order" 가 본 경로를 인용해 Claude Code 의
     기본 skill 로더가 발견. 네이티브 API 등록 없음 (N14). 순수
     Markdown 표면 (R2).
```

**본 번들의 북극성 (plan_final Sec. 1-1 파생):** 어느 stage 전이에서든 사용자는 **한 화면짜리 권고** — "이 stage · 이 모드 · 이 리스크 레벨에서는 이런 도구 · 문서 · 체크리스트가 권장된다" — 를 팝업 · 프롬프트 · 셸 명령 · 차단 모달 없이 본다. 사용자는 수용 · 무시 · 후속 질문을 선택할 수 있고, 스킬은 결코 사용자 의도를 다시 쓰거나 진행을 중단시키지 않는다.

**plan_final Sec. 5 에서 이월된 리스크 불변식:**

- **R2 읽기 전용 표면.** 셸 명령 없음, 대화형 CLI 없음, 파일 변형 없음. Stage-9 수락 기준 AC.B1.7 로 검증.
- **R3 Stage-11 호환성.** 스킬 본문 전체가 DC.6 번들별 dossier (≤ 1 페이지 산문 + ≤ 200 줄 diff) 에 들어간다. 설계 선택: 결정 테이블을 Stage 11 dossier 가 인라인으로 재현 가능한 수준으로 컴팩트하게 유지.

---

## 2. 구성 요소

Bundle 1 은 의도적으로 **파일 하나 + 선택적 참조 문서 하나**. 서브 모듈 없음.

### 2-1. 구성 요소 — `.skills/tool-picker/SKILL.md` (D1.a + D1.b + D1.c, 단일 파일)

- **책임.** 자기 완결적인 스킬: 프론트매터, 추천 로직 (결정 테이블), worked example, 실패 모드 노트, 호출 참조.
- **Anthropic Skills 포맷.** YAML 프론트매터 (`name`, `description`) + Markdown 지시 본문. 바이너리 asset 없음, 외부 include 없음.
- **크기 목표.** 총 ≤ 300 줄 (plan_final Sec. 7-1 OQ1.1 분리 임계값). 현 설계는 약 180–220 줄 예상.
- **파일.** `.skills/tool-picker/SKILL.md` (프로젝트 루트 기준).
- **프론트매터 계약.**

  ```yaml
  ---
  name: tool-picker
  description: >-
    jDevFlow advisory tool-picker. Fires on Stage entry, on user
    "what next / which tool" questions, and when the user names a
    jDevFlow stage/mode/risk_level. Reads HANDOFF.md Status fields
    and returns a ranked list of recommended tools, docs, and
    checklists for the current (stage, mode, risk_level) triple.
    Advisory only — never blocks, never rewrites intent, never
    runs shell.
  ---
  ```

  description 문구는 **발견 중요** — 필수 트리거 단어 (`stage`, `mode`, `risk_level`, "next step", "jDevFlow") 가 Claude 의 스킬 매처가 고르도록 원문 그대로 등장해야 한다.

### 2-2. 구성 요소 — `docs/notes/tool_picker_usage.md` (D1.x, 선택 보조)

- **책임.** 짧은 사람 대상 문서: `SKILL.md` 호출 방식, 출력 검사 방법, `CLAUDE.md` read-order 훅.
- **별도 문서로 분리한 근거 (SKILL.md 에 인라인 대신).** `SKILL.md` 를 Claude 매처가 잘 파싱하도록 간결 · 집중 유지; 사람 대상 내러티브 페이지는 자체 장소에. 설계자 선택은 **분리** — SKILL.md ≤ 220 줄 유지, 사람 대상 프로즈는 별도 파일.
- **범위.** ≤ 80 줄. (a) 스킬 위치, (b) Claude Code 로드 방식, (c) 권고 출력 모양, (d) 스킬이 아닌 것 (N5 discovery UX) 커버.
- **파일.** `docs/notes/tool_picker_usage.md` + `tool_picker_usage.ko.md` (R4 KO 페어).
- **D4.x2 규준 프론트매터.** Stage-5+ 문서이므로 전체 프론트매터 부착. `stage: 5-support`, `bundle: 1`.

---

## 3. 데이터 흐름

### 3-1. Stage 진입 트리거 경로 (OQ1.2 — 자동 절반)

```
사용자가 HANDOFF.md 편집 또는 Claude 가 Status 갱신
           │
           ▼
  Claude Code 가 HANDOFF.md Status 변화 감지
  (스킬 매처가 description 트리거 스캔)
           │
           ▼
  매처가 tool-picker 스킬 발화 (description 매치:
    최근 assistant/user 턴에 "stage" 또는 "mode" 또는
    "risk_level" 등장, 또는 "what next", "which tool"
    같은 명시적 사용자 문구)
           │
           ▼
  [1] HANDOFF.md Status 섹션 읽기
           │
           ├── 파일 부재 ──► Sec. 6 "HANDOFF 없음" 폴백
           │                 ("권고 억제; jDevFlow 프로젝트 루트로
           │                 이동을 사용자에게 요청")
           │
           ▼
  [2] 트리플 파싱: (stage, mode, risk_level)
           │
           ├── 필드 누락 / 불량 ──► Sec. 6 "불량" 폴백
           │    ("권고 억제; 다음 필드 파싱 불가: …")
           │
           ▼
  [3] 결정 테이블 조회 (Sec. 3-2)
           │
           ▼
  [4] 순위 목록 렌더 (Sec. 4 출력 포맷)
           │
           ▼
  채팅 메시지 출력 (비모달, 권고 톤).
  사용자는 수용 · 무시 · 후속 질문 가능.
```

### 3-2. 사용자 요청 트리거 경로 (OQ1.2 — 수요 절반)

```
사용자: "지금 어떤 도구를 써야 해?" / "다음은?" /
        "이 stage 의 다음 단계를 추천해"
           │
           ▼
  같은 tool-picker 스킬이 발화
           │
           ▼
  3-1 과 동일한 [1]–[4] 파이프라인.
```

파이프라인은 하나만 존재; 두 트리거가 동일한 결정 로직을 공유. 스킬 본문을 단일 코드 경로로 유지해 R2 불변식 검증을 단순화.

### 3-3. 결정 테이블 (D1.b)

행 = stage. 열 = (mode, risk_level) 쌍. 셀 = 순위 추천 목록.

범위 내 테이블 최소 커버리지 (DC.5 #2 요구): **stages 2, 3, 5, 8, 9, 11** × modes **Standard | Strict | Strict-hybrid** × risk_levels **medium | medium-high**.

각 셀은 **세 종류의 추천** 을 방출:

1. **다음에 열 주 도구 / 문서** (정확히 하나).
2. **눈 앞에 둘 체크리스트** (0개 또는 1개 — 예: Sec. 0 KO sync 블록, 승인 체크리스트).
3. **경계할 경고** (0개 또는 1개 — 예: Stage 5 Bundle 1 의 R2 드리프트).

목록 외 셀은 **폴백 행** 사용 (Sec. 4-1 참조).

| Stage | Strict-hybrid · medium | Strict-hybrid · medium-high | Standard · medium | Strict · medium |
|------:|------------------------|------------------------------|--------------------|-----------------|
| 2  Plan Draft | `prompts/claude/plan_draft.md` + `plan_draft.md` scaffold · AC.1–AC.4 초안 · top-3 리스크 심도 경계 | 동일 + AC.5–AC.7 (Strict-hybrid 추가) · 리스크 심도 ≥ plan_final Sec. 5 | `plan_draft.md` scaffold · AC.1–AC.4 · 추가 없음 | `plan_draft.md` scaffold · AC.1–AC.4 · 스코프 크립 경계 |
| 3  Plan Review | `plan_review.md` (포커스: 커버리지 / top-3 / OQ 컨테인먼트 / KO sync) · plan_review Sec. 4-3 KO 체크 · Stage-4 leak 경계 | 동일 + 공동 승인 명시 (M.1) · KO 체크 · OQ 를 commit 규칙으로 승격 경계 (M.x) | `plan_review.md` · 경량 KO 체크 · 없음 | Strict-hybrid medium 과 동일 (추가 없음) · 없음 |
| 5  Tech Design | `prompts/claude/technical_design.md` · D4.x2/x3/x4 인용 블록 (Bundle 1 한정) · R2 드리프트 (N5) 경계 | 동일 · DEP.1 게이트 가시화 · 스코프 extras (D1.x / D4.x1–x4) 경계 | `technical_design.md` · KO 블록 없음 · 없음 | 동일 · Codex handoff 부록 필수 |
| 8  Implementation | Codex 킥오프 프롬프트 (관련 tech design Sec. 12-1) · 섹션 단위 소유 표 · 제약 위반 경계 | 동일 · 공동 커밋 규율 (R4 KO 페어) | Codex 킥오프 프롬프트 · 소유 표 없음 | 동일 · 전체 제약 리스트 |
| 9  Code Review | `prompts/claude/code_review.md` · 관련 tech design 의 AC.Bn.1–N · KO 신선도 경계 (OQ.L2 Stage-9 절반) | 동일 · 공동 판정 커플링 (R9) · design-level 승격 경계 | code review 프롬프트 · 기본 AC 체크 | 동일 |
| 11 Final Validation | DC.6 킥오프 프롬프트 (`stage11_joint_validation_prompt.md`) · dossier 포맷 (≤ 1 페이지 + ≤ 200 줄) · R3 컨텍스트 폭발 경계 | 동일 · **합동 fresh 세션** (M.3) · 판정 분기 정책 (M.5) · R3 | DC.6 (해당 시) · 기본 | 동일 |

**폴백 행 (목록 외 stage).** 권고: stage 명과 매치되는 `prompts/claude/` 의 canonical 프롬프트 (있을 때); 그 외 "특정 권고 없음 — 사용자 의도 물음". 존재하지 않는 프롬프트 경로를 지어내지 말 것.

---

## 4. 데이터 모델

### 4-1. 추천 출력 형태

스킬은 채팅에 단일 **Markdown 블록** 을 방출. 형태:

```markdown
**jDevFlow tool-picker 권고** — (stage X, mode Y, risk_level Z)

**다음 단계 (주):**
1. [주 추천 — 파일 참조 시 D4.x4 에 따른 상대경로]

**열어둘 체크리스트:**
- [체크리스트 추천, 있을 경우]

**경계할 것:**
- [경고, 있을 경우]

_권고 전용 — 비차단. "skip" 으로 해제 또는 후속 질문 가능._
```

- 마지막의 해제 라인은 항상 존재. R2 읽기 전용 불변식의 가시화.
- "다음 단계 (주)" 는 항상 길이 ≥ 1 의 번호 리스트 — 셀이 한 항목만 권장해도 일관된 형태 유지 (Stage 11 dossier 렌더러 같은 하위 파서 용이성).
- 빈 체크리스트 / 경계 서브블록은 **생략** (`- none` 으로 렌더 금지). 출력을 짧게 유지.

### 4-2. HANDOFF 트리플 파싱 규칙

스킬은 `HANDOFF.md` 를 읽고 `## Status` 섹션의 라인 매치로 `(stage, mode, risk_level)` 추출 — 구체적으로:

- `**Current stage:**` 라인 → `stage`. 숫자 (`Stage 5`), 단어 (`Stage 5 Bundle 4`), 체크포인트 (`Stage 4.5`) 모두 수용. 후속 설명 제거 후 선행 stage 식별자 취득.
- `**Workflow mode:**` 라인 → `mode`. `Strict`, `Standard`, `Strict-hybrid` 대소문자 무시 수용.
- `**risk_level:**` 라인 → `risk_level`. `low`, `low-medium`, `medium`, `medium-high`, `high` 수용.

`## Status` 의 그 외 내용은 무시. v0.3 에선 의도적으로 brittle — HANDOFF 스키마가 아직 버전화되지 않았으므로 스킬 파서가 "트리플" 정의의 단일 출처.

### 4-3. 결정 테이블 내부 표현 (SKILL.md 본문의 저작 형식)

Sec. 3-3 테이블은 `SKILL.md` 내부에 **Markdown 으로 직접 저작**. 별도 YAML/JSON 없음. Claude 는 사람과 같은 방식으로 테이블을 읽는다. 이는 스킬 표면 전체를 검사 가능하게 유지하고 두 번째 파서 경로를 회피한다.

`SKILL.md` 내부 셀 포맷 관습:

```
[primary] · [checklist] · [watch-out]
```

셀 내부 구분자는 `·`. 슬롯이 비면 플레이스홀더 `—` 로 렌더. 출력 렌더러 (Sec. 4-1) 가 이 위치들을 읽어 `—` 이 아닌 항목만 방출.

---

## 5. API 계약

**N/A, 사유: Claude Code 의 스킬 메커니즘이 네이티브로 소비하는 순수 Markdown 스킬. 호출 가능 API 표면 없음.**

스킬의 "계약" 은:

- 프론트매터 `name: tool-picker` (고정).
- 프론트매터 `description` 에 필수 트리거 어휘 (Sec. 2-1) 포함.
- 본문 구조가 Sec. 1 의 8 섹션 레이아웃 일치.

스킬을 참조하려는 하위 소비자 (예: Bundle 4 CONTRIBUTING.md Sec. 10) 는 경로로 참조: `.skills/tool-picker/SKILL.md`. 프로그래밍적 import 없음.

---

## 6. 오류 처리

| 실패 | 탐지 | 조치 |
|------|------|------|
| 프로젝트 루트에 `HANDOFF.md` 없음 | Sec. 3-1 단계 [1] | "tool-picker: 프로젝트 루트에 HANDOFF.md 없음; 권고 억제. jDevFlow 프로젝트라면 프로젝트 루트인지 확인." 출력. 상위 디렉터리로 재귀 금지. |
| HANDOFF.md 에 `## Status` 섹션 없음 | 단계 [1] | "tool-picker: HANDOFF.md 에 `## Status` 섹션 없음; 권고 억제. 수작업 마이그레이션은 `CONTRIBUTING.md` Sec. 9 참조." 출력. |
| 트리플 필드 누락 / 불량 | 단계 [2] | "tool-picker: [필드명] 파싱 불가; 권고 억제. 예상 포맷: `**Current stage:** Stage N`, `**Workflow mode:** Strict-hybrid`, `**risk_level:** medium`." 출력. |
| 결정 테이블 행 매치 없음 | 단계 [3] | Sec. 3-3 의 **폴백 행** 으로 낙하. `prompts/claude/` 매치 출력 또는 "특정 권고 없음". |
| 결정 셀 비어 있음 (저작 버그) | 단계 [3] | "tool-picker: (stage=X, mode=Y, risk=Z) 결정 테이블 셀 비어 있음; 스킬 버그 — 신고 부탁." |
| 사용자 "skip" / "dismiss" | 채팅 후속 | 스킬은 아무 것도 안 함 (권고 해제; 상태 저장 없음). 다음 트리거에서 재실행. |

**재시도 로직 없음.** 모든 실패는 단일 권고-억제 통지를 출력하고 종료. 스킬 실패로 사용자가 차단되는 일 없음.

---

## 7. 보안 고려

- **셸 실행 없음.** 스킬 본문에 실행 코드 **제로**. Grep 체크: `grep -E '\b(bash|sh|python|node|eval|exec)\b' SKILL.md` 가 예제 코드 펜스 또는 인용 출력 안에서만 매치, Claude 에게 실행 지시하는 명령형 문장 0건. AC.B1.7 로 검증.
- **파일 쓰기 없음.** 스킬은 `HANDOFF.md` 만 읽음. Claude 에게 파일 수정 지시 없음. AC.B1.7 로 검증.
- **시크릿 처리 없음.** 스킬은 자격 증명을 읽거나 출력하거나 저장하지 않는다. `HANDOFF.md` 에 시크릿이 있더라도 (Bundle 4 D4.a 시크릿 탐지 규칙으로 방지) 파서는 `**Current stage:**` / `**Workflow mode:**` / `**risk_level:**` 라인만 매치하므로 노출하지 않는다.
- **사용자 제공 경로 없음.** 스킬이 접근하는 경로는 프로젝트 루트의 잘 알려진 `HANDOFF.md` 하나. 후속 채팅의 사용자 제공 경로는 대화로 취급, 파일 참조로 파싱하지 않는다.
- **네트워크 · 인증 · 영속화 N/A — 사유: 읽기 전용 Markdown 지시, 부수 효과 없음.**

---

## 8. 테스트 전략

| 항목 | 유형 | 단언 |
|------|------|------|
| 프론트매터 YAML 유효성 | lint | `name: tool-picker`, `description:` 존재, description 에 모든 필수 트리거 (`stage`, `mode`, `risk_level`, "next step", "jDevFlow") 포함 |
| 결정 테이블 완전성 | lint | 범위 내 테이블 (stages 2/3/5/8/9/11 × 4 mode-risk 열) 의 모든 셀이 비어 있지 않은 `[primary]` 슬롯 소유 |
| 결정 테이블 행 linkout 유효성 | lint | 인용된 모든 `prompts/claude/...` 경로가 실제 파일 (repo 루트 기준) 로 해석; `docs/...` 경로 해석 |
| R2 읽기 전용 불변식 | lint (grep) | 명령형 지시에 `run`, `execute`, `shell`, `bash $`, `sh $`, `python $` 등장 없음 (예제 코드 펜스 허용) |
| Worked example — Stage 2 진입 | snapshot | 렌더된 예제 (SKILL.md Sec. 6) 가 현 `HANDOFF.md` 대비 컴파일 — 트리플 추출 가능, 예제 서두 주장과 일치 |
| HANDOFF 트리플 파서 — 정상 | unit (수작업 walk) | 현 라이브 HANDOFF.md 에서 (stage, mode, risk_level) = ("Stage 5 Bundle 1" 유사, "Strict-hybrid", "medium") 파싱 |
| HANDOFF 트리플 파서 — Status 부재 | unit | `## Status` 제거 후 스킬이 "섹션 부재" 권고-억제 메시지 (Sec. 6) 방출 |
| 폴백 행 동작 | unit | 가짜 stage = "Stage 7" 입력에서 스킬이 폴백 행 (canonical 프롬프트 매치 또는 "권고 없음") 방출 |
| 출력 포맷 안정성 | snapshot | 샘플 셀에 대한 렌더 출력이 Sec. 4-1 템플릿과 정확히 일치 (Stage 11 dossier 파싱 가능) |
| 호출 참조 신선도 | lint | `docs/notes/tool_picker_usage.md` 가 현 `.skills/tool-picker/SKILL.md` 경로 인용; `CLAUDE.md` Read order 에 포인터 라인 포함 |
| **KO 신선도** [크로스 번들 OQ.L2] | 코드 리뷰 체크리스트 | `docs/notes/tool_picker_usage.ko.md` 존재, `updated` 필드가 EN 주문서 `updated` 후 ≤ 1 일 — Bundle 4 와 동일 규칙 |

테스트 하네스: `tests/bundle1/run_bundle1.sh` 의 단일 셸 스크립트로 skill 파일 grep / diff. 테스트 프레임워크 없음. Bundle 4 의 "프레임워크 없음" 규율 미러링.

---

## 9. Codex 용 구현 주석

### 9-1. 생성할 파일

1. `.skills/tool-picker/SKILL.md` — 전체 스킬 (Sec. 1 의 프론트매터 + 8 섹션 본문).
2. `docs/notes/tool_picker_usage.md` — D1.x 사람 대상 참조 문서.
3. `docs/notes/tool_picker_usage.ko.md` — KO 페어 (R4 에 따라 같은 커밋).
4. `tests/bundle1/run_bundle1.sh` — Sec. 8 의 lint + snapshot 체크.

### 9-2. 수정할 파일

- `CLAUDE.md` — "Read order" 아래에 `.skills/tool-picker/SKILL.md` 를 가리키는 한 줄 추가. 기존 항목 **재정렬 금지**. Bundle 4 도 본 파일을 수정 (`CONTRIBUTING.md` 참조 추가) — Sec. 9-5 의 단일 커밋으로 조율.
- 그 외 없음. 특히 Bundle 1 이 `HANDOFF.md` 를 수정할 필요는 없다 — 스킬은 읽기만.

### 9-3. 제약 (위반 금지 목록)

- **셸 명령 없음** 스킬 본문 어디에도. `bash`, `sh`, `python`, `curl`, `wget`, `eval`, `exec` 없음. 출력 포맷을 보여주는 예제 펜스는 지시가 아닌 출력으로 명확히 표시된 경우에만 허용.
- **대화형 CLI 없음.** "이것을 실행하고 결과 붙여넣기" 흐름 없음.
- **네이티브 Skill API 등록 없음** (OQ1.3 lean per N14). 스킬은 CLAUDE.md Read-order 인용 + Claude Code 기존 매처로 발견.
- **v0.3 에서 `rules/*.md` 로 분리 없음.** Codex 구현 중 본문이 300 줄을 넘으면 단독 분리 말고 Stage 9 finding 으로 승격 (OQ1.1 lean).
- **`security/` 변경 금지** (plan_final Sec. 6 DEP.5 — 동결).
- **Bundle 4 파일 건드리지 말 것** (`scripts/update_handoff.sh`, `CONTRIBUTING.md`, `CHANGELOG.md`, `CODE_OF_CONDUCT.md`, `templates/HANDOFF.template.md`, `docs/notes/decisions.md`). Bundle 4 영역.
- **`tool_picker_usage.md` 의 KO 페어는 EN 주문서와 같은 커밋.** `SKILL.md` 자체는 영어 전용 (Anthropic Skills 포맷 관습; 이중언어 스킬 설명은 매처 혼란 유발).

### 9-4. 결정 테이블 경로

Sec. 3-3 테이블의 모든 `prompts/claude/...` 와 `docs/...` 경로는 채팅에 방출된 파일에서 참조될 때 **프로젝트 루트 기준** 상대경로 (권고는 특정 파일 컨텍스트 밖에서 보임). 이는 D4.x4 "항상 현재 파일 기준 상대경로" 규칙의 **의도적 좁은 예외** — 권고는 현재 파일이 없으므로 프로젝트 루트 기준이 자연스러운 idiom.

스킬 본문 자체가 교훈 목적으로 경로를 인용할 때 (예: worked example) 는 D4.x4 현재 파일 기준 상대경로 구문 사용.

### 9-5. 커밋 스타일

단일 deliverable 커밋, 각 제목 앞에 `[bundle1] ` 접두사. 예: `[bundle1] Add .skills/tool-picker/SKILL.md with decision table (D1.a/D1.b/D1.c)`.

`CLAUDE.md` Read-order 편집은 Bundle 4 의 Read-order 편집과 조율: **공동 단일 커밋** `[bundle1+bundle4] Update CLAUDE.md Read order (tool-picker + CONTRIBUTING)` — 같은 세션에 착륙하는 경우; 그 외엔 각 번들이 자체 커밋에 자체 라인 추가 + 다른 번들이 rebase.

---

## 10. 범위 밖 (본 구현)

- **N5** — Discovery UX. 팝업 없음, 메뉴 없음, 설정 표면 없음. 스킬은 Markdown + Claude Code 네이티브 매처.
- **N9** — 스킬 버전 관리 / 스킬 레지스트리. v0.3 는 본 스킬의 단일 버전을 배포; 버전 관리 연기.
- **N14** — 네이티브 Skill API 등록. 사용 안 함; CLAUDE.md Read-order 인용이 전체 발견 메커니즘.
- **Bundle 2/3 기능.** 메타데이터 정제 (Bundle 2) 없음, 이미 초안 작성된 킥오프 프롬프트 이상의 Codex handoff UX (Bundle 3) 없음. v0.4 로 연기.
- **영어 아닌 스킬 본문.** `SKILL.md` 는 영어 전용. D1.x 보조 문서는 이중언어 (R4) 지만 스킬 자체는 아님.
- **HANDOFF 스키마 동적 진화.** 파서 (Sec. 4-2) 는 v0.3 HANDOFF 레이아웃 타겟; v0.4 스키마 변경은 스킬 갱신을 요구.
- **Stage 6/7 (UI) 권고.** `has_ui=false` — 결정 테이블에 Stage 6/7 행 없음, 폴백 행이 "v0.3 UI stage 는 권고 없음 (has_ui=false)" 처리.

---

## 11. 수락 기준 (Stage 9 리뷰용)

- [ ] **AC.B1.1** — `.skills/tool-picker/SKILL.md` 존재, ≤ 300 줄, `name: tool-picker` + 5 개 필수 트리거 단어 (`stage`, `mode`, `risk_level`, "next step", "jDevFlow") 포함 `description` 이 있는 유효한 YAML 프론트매터 소유.
- [ ] **AC.B1.2** — 지시 본문에 Sec. 1 의 8 섹션 모두 순서대로 포함.
- [ ] **AC.B1.3** — 결정 테이블 (Sec. 3-3) 이 stages 2 / 3 / 5 / 8 / 9 / 11 × modes Standard / Strict / Strict-hybrid × risk_levels medium / medium-high 커버, 모든 셀이 비어 있지 않은 주 추천 소유.
- [ ] **AC.B1.4** — 결정 테이블 셀의 모든 인용 경로가 실제 파일로 해석 또는 "(Stage X 에 생성 예정)" 으로 명시.
- [ ] **AC.B1.5** — Worked example (D1.c) ≥ 15 줄, Strict-hybrid 모드의 Stage-2 진입을 end-to-end 로 표시 (트리거 → HANDOFF 읽기 → 결정 조회 → 권고 출력 → 사용자 응답), 현 `HANDOFF.md` 대비 컴파일.
- [ ] **AC.B1.6** — D1.x 참조 (`docs/notes/tool_picker_usage.md`) 존재 및 `.ko.md` 페어, ≤ 80 줄, D4.x2 에 따른 YAML 프론트매터 (`stage: 5-support`, `bundle: 1`).
- [ ] **AC.B1.7** — **R2 읽기 전용 불변식.** `grep -E '\b(bash|sh |python|node|eval|exec |curl|wget)\b' .skills/tool-picker/SKILL.md` 가 코드 펜스 또는 인용 출력 안에서만 매치 — Claude 에게 무언가를 실행하게 하는 명령형 지시 0건. 리뷰어 명시적 서명.
- [ ] **AC.B1.8** — Bundle 4 Sec. 0 결정이 본 파일 Sec. 0 및 `SKILL.md` 의 D4.x2/x3/x4 참조 위치에 원문 그대로 인용; 풀어쓰기 없음.
- [ ] **AC.B1.9** — 프론트매터 description 이 Anthropic 스킬 description 길이 가이던스 (~1024 자) 이하. Stage 9 에서 측정 · 기록.
- [ ] **AC.B1.10** — KO 동기화: `docs/notes/tool_picker_usage.ko.md` 존재, `updated` 가 EN 주문서 `updated` 후 ≤ 1 일, 본 설계 상단의 KO 동기화 체크 블록 완전히 체크.

---

## 12. Codex 핸드오프 부록

### 12-1. Stage 8 (Bundle 1 구현) 용 복붙 킥오프 프롬프트

```
jDevFlow v0.3 Bundle 1 (tool-picker) 를 구현.

순서대로 읽을 것:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md Sec. 10 Stage 8
4. docs/03_design/bundle1_tool_picker/technical_design.md (본 설계)
5. docs/03_design/bundle1_tool_picker/technical_design.ko.md (KO 페어)
6. docs/03_design/bundle4_doc_discipline/technical_design.md Sec. 0 (D4.x2/x3/x4)
7. docs/02_planning/plan_final.md Sec. 3-1, 5-2, 7-1 (컨텍스트)

Deliverables (Sec. 9-1):
1. .skills/tool-picker/SKILL.md — 프론트매터 + 8 섹션 본문
2. docs/notes/tool_picker_usage.md + .ko.md — D1.x 참조
3. tests/bundle1/run_bundle1.sh — lint + snapshot 체크

수정 (Sec. 9-2):
- CLAUDE.md — "Read order" 아래에 .skills/tool-picker/SKILL.md
  를 가리키는 한 줄 추가. 기존 라인 재정렬 금지.

제약 (위반 금지 — Sec. 9-3):
- 셸 명령 없음, 대화형 CLI 없음, 네이티브 Skill API 없음
- security/ 또는 Bundle 4 파일 변경 금지
- SKILL.md ≤ 300 줄 유지 (초과 시 승격)
- R2 읽기 전용 불변식: grep -E '\b(bash|sh |python|node|eval|exec)\b'
  가 코드 펜스 / 인용 출력 안에서만 매치

출력 접근 (plan_final Sec. 7-5 OQ.C1 lean):
- Codex 가 초기 SKILL.md 초안 생성
- Claude 가 다듬기 (description 문구, worked example fit)

완료 시 보고: 생성/수정한 파일 경로, 린터 출력, snapshot 테스트
출력. 이후 Stage 9 코드 리뷰 진입.
```

### 12-2. Codex 가 선택해도 되는 것

- 결정 테이블 셀의 정확한 문구 (테이블 형태는 고정; 셀 텍스트는 Codex 초안, Claude 다듬기).
- 멀티 추천 셀 내부 구분자 선택 — `·` (Sec. 4-3) 가 설계 권장; Codex 가 `·` 에 렌더링 문제가 있으면 `;` 선택 가능.
- Worked example 내러티브 세부 (어떤 구체 stage 2 deliverable 이 언급되는지 등), AC.B1.5 충족 한도 내에서.

### 12-3. Codex 가 단독 결정해선 안 되는 것

- 프론트매터 `name` 값 (정확히 `tool-picker`).
- SKILL.md 를 `rules/*.md` 로 분리 (초안이 300 줄을 넘으면 Stage 9 finding 으로 — 분리 금지).
- description 에서 필수 트리거 단어 제거.
- 셸 명령 / CLI 표면 추가 (R2 위반 — 즉시 Stage 9 차단).
- 네이티브 Skill API 바인딩 (N14 위반).

---

## 13. 전방 노트 / 하우스키핑

- **Stage 9 (코드 리뷰).** AC.B1.1–10 을 리뷰 루브릭으로 사용. AC.B1.7 (R2 불변식) 이 헤드라인. AC.B1.10 (KO 동기화) 은 빠뜨리기 쉬우므로 리뷰어 명시적 체크.
- **Stage 11 합동 검증.** Bundle 1 dossier 는 `docs/notes/stage11_dossiers/bundle1_dossier.md` (DC.6) — AC.B1.1–10 인용 + Sec. 3-3 결정 테이블 인라인 재현. dossier 를 ≤ 1 페이지 + ≤ 200 줄 diff (R3) 로 유지.
- **v0.4 포인터.** Bundle 2, 3 은 본 스킬을 그대로 소비; 설계는 구조 변경 없이 테이블 행 (stage / mode 확장) 추가 여지를 남김.
- **Stage 13.** 단일 합동 `v0.3` 태그 (M.6) — Bundle 1 전용 태그 없음.

---

## 14. 본 문서 개정 로그

| 일자 | 개정 | 비고 |
|-----|------|------|
| 2026-04-22 | v1 — Stage 5 Bundle 1 기술 설계 | 세션 3 재개. D1.a ~ D1.c + D1.x 커버; OQ1.1 (단일 파일 ≤ 300 줄), OQ1.2 (두 트리거, 단일 파이프라인), OQ1.3 (네이티브 API 없음) 해결. Sec. 0 에서 Bundle 4 D4.x2/x3/x4 를 DEP.1 에 따라 원문 그대로 인용. AC.B1.1–10 열거. 작성 시점에 D4.x2 에 따른 YAML 프론트매터 적용. KO 페어 `technical_design.ko.md` R4 에 따라 같은 세션 작성; KO 동기화 체크 블록 체크 완료. |
