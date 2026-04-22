# 🧠 Stage 1 — Brainstorm (jOneFlow v0.3)

> 작성일: 2026-04-22
> 세션 언어: 한국어 (본 문서는 세션 작업 언어 기준 작성. EN primary + KO translation 정책은 `docs/02_planning/plan_draft.md`부터 적용)
> 모드: **Strict-hybrid** (상위 Strict 메타 + 하위 Standard 번들)
> 작업자: Claude (기획) + Hyoungjin (의사결정)

---

## 1. 문제 정의 (Problem Statement)

### 1-1. 현재 상태

jOneFlow v0.2까지는 **"워크플로우 문서 세트"** 수준이었다. 즉 Claude 세션이 시작될 때 CLAUDE.md → HANDOFF.md → WORKFLOW.md를 읽고 13단계 흐름을 따르는 정적인 스캐폴딩이다.

문제는 두 가지다.

1. **문서는 있는데 "살아있지 않다".** 스킬(`.skills/`), 메타데이터(`has_ui`, `risk_level`), 번들 단위 관리 같은 개념이 명시적으로 작동하지 않고 프롬프트 안에 녹아만 있다. Claude가 매 세션 해석에 의존한다.
2. **실제 사용자(Jonelab 팀원)에게 배포할 수 있는 형태가 아니다.** 현재 v0.1로 진행 중인 프로젝트가 하나 있지만, 이 템플릿을 받아서 새 프로젝트를 "혼자 30분 안에" 시작할 수 있는 팀원은 아직 없다.

### 1-2. v0.3가 해결할 것

**"살아있는 시스템으로의 전환"** — 문서를 읽어서 해석하는 방식에서, **스킬과 메타데이터가 워크플로우를 능동적으로 유도하는** 방식으로 전환한다.

구체적으로:
- 스킬(`tool-picker`)이 현재 stage/mode/risk_level에 맞는 도구·문서·체크리스트를 *추천*한다.
- HANDOFF.md가 번들 단위(`bundles[]`) 진행 상태를 구조화해서 기록한다.
- 하위 번들이 Standard 모드로 돌더라도 상위에서 Strict-hybrid로 감싸 drift를 조기에 감지한다.

### 1-3. 컨텍스트

- **Jonelab 팀원 공유용 템플릿/플랫폼**. OSS 공개 가능성도 열어둔다 (따라서 EN primary 원칙).
- **v0.5까지는 백엔드 전용 프로젝트를 기본 가정**. UI 관련 베이스는 만들어두되 본격 지원은 나중.
- **v0.1 프로젝트가 실제 돌고 있음** (dogfooding 1건). v0.3에서 추가된 개념들이 거기서 역수입되는 건 허용하지만, v0.1 프로젝트를 자동 마이그레이션해주지는 않는다.

### 1-4. 북극성 (North Star)

> **Jonelab 팀원이 jOneFlow v0.3로 새 백엔드 프로젝트를 혼자 30분 이내에 시작할 수 있는가.**

"시작"의 정의:
- 템플릿 clone → CLAUDE.md / HANDOFF.md 편집 → security 셋업 → 첫 커밋 → Stage 1 Brainstorm 진입까지.

이 한 줄이 v0.3의 모든 범위/비범위 판단 기준이다.

---

## 2. 비목표 (Non-goals)

아래는 **v0.3에서 하지 않는 것**이다. 문서에 박아두어야 Stage 2~5에서 scope creep을 방지한다.

| # | 비목표 | 이유 |
|---|--------|------|
| N1 | UI 전용 워크플로우 완성 | 백엔드가 주 사용처, UI는 베이스만 |
| N2 | v0.1 프로젝트 자동 마이그레이션 | 수작업 가이드로 충분 |
| N3 | 13단계 전체 재설계 | 작동하는 틀은 유지 |
| N4 | Codex 이외의 구현 에이전트 지원 | v0.4+ 과제 |
| N5 | 스킬 디스커버리 자동화 (`/skills list` UX 등) | 수동 참조로 출발 |
| N6 | 다국어 전체 지원 | EN + KO 만 |
| N7 | CI/CD 템플릿 (GitHub Actions 등) | 별도 번들로 분리, v0.4+ |
| N8 | Python 이외 런타임 지원 | 필요해지면 그때 |
| N9 | 스킬 버전 관리 시스템 | 스킬 파일 자체가 짧아 파일 히스토리로 충분 |
| N10 | 전체 문서 EN 역번역 (v0.3 소급) | 신규 문서에만 적용, 기존 KO 문서는 점진적 |
| N11 | validation group 복잡화 (Group 2+ 자동 감지) | Group 1 단일 선언만으로 충분 |

### 언어 정책 (N6, N10 관련)

- **신규 문서 (plan_draft 이후)**: EN 본문 + KO 번역 병기 혹은 하단 섹션 분리
- **브레인스토밍 산출물 (본 문서 포함)**: 세션 언어(KO) 기준으로 작성, EN 번역은 선택적
- **기존 문서 (CLAUDE.md, HANDOFF.md, WORKFLOW.md 등)**: 현재 이중 언어 구조 유지
- **이유**: OSS 관례 + 향후 외부 공유 가능성 + Claude가 EN에서 더 안정적

---

## 3. 메타데이터 (이번 세션 고정값)

| 항목 | 값 | 비고 |
|------|-----|------|
| `mode` | **strict-hybrid** | 상위 Strict + 하위 번들 Standard |
| `has_ui` | **false** | jOneFlow 자체는 문서+스킬 시스템. UI 없음 |
| `risk_level` | **medium** | 번들별: Bundle 1 = medium-high, Bundle 4 = low-medium |
| `approval_mode` | **per-bundle gate** | 번들 완료마다 사용자 승인 |

### 3-1. HANDOFF.md `bundles[]` 스키마 (미리보기)

Stage 5에서 확정되겠지만 Stage 1 단계 합의 내용:

```yaml
bundles:
  - id: 1
    name: tool-picker
    goals: [7, 11, 12]        # v03_kickoff.md의 12 goals 기준
    risk_level: medium-high
    stage: 5                   # 현재 진입한 stage
    verdict: null              # minor | bug_fix | design_level | null
    validation_group: 1        # 같은 그룹은 함께 Stage 11 검증
    approval_status: pending   # pending | approved | rejected
  - id: 4
    name: doc-discipline
    goals: [5, 9, 10]
    risk_level: low-medium
    stage: 1
    verdict: null
    validation_group: 1
    approval_status: pending
```

`verdict` enum:
- `minor` — 문구/포맷 수정 수준
- `bug_fix` — 기능 고장 수정
- `design_level` — 설계 변경 동반 (Stage 5 재진입 필요)

---

## 4. 범위 선택 근거 (Why Bundle 1 + Bundle 4)

### 4-1. 후보군과 선택

v03_kickoff.md의 12 goals를 네 개 번들로 묶었을 때:

| 번들 | 이름 | 포함 goals | 선택 여부 |
|------|------|-----------|----------|
| Bundle 1 | Tool-picker system | 7, 11, 12 | ✅ 채택 |
| Bundle 2 | Metadata refinement | 1, 2, 3 | ❌ 이월 (v0.4) |
| Bundle 3 | Codex handoff UX | 4, 6, 8 | ❌ 이월 (v0.4) |
| Bundle 4 | Doc discipline | 5, 9, 10 | ✅ 채택 |

### 4-2. 선택 이유

**Bundle 1 (Tool-picker)**
- "살아있는 시스템 전환"의 핵심. 스킬이 실제로 Claude 행동을 바꿔야 한다.
- 북극성("30분 온보딩")에 직접 기여. 팀원은 Claude가 알아서 다음 단계 도구를 제안해주길 기대한다.
- 나머지 번들(특히 Bundle 2, 3)의 **전제 조건**. Tool-picker 없이 메타데이터만 다듬어도 활성화가 안 된다.

**Bundle 4 (Doc discipline)**
- Bundle 1을 실제로 동작시키려면 문서 구조가 일관돼야 한다. (파일명 규칙, 메타데이터 헤더, 링크 규칙 등)
- 저위험·저비용. Standard 모드로 빠르게 끝낼 수 있다.
- Jonelab 팀원 공유 시 가장 먼저 눈에 띄는 부분 (문서 품질 = 첫인상).

### 4-3. Bundle 2, 3 이월 이유

- v0.3에 다 넣으면 개별 번들이 얕게 끝난다.
- Bundle 1이 실사용되면서 발견될 메타데이터 요구사항을 역으로 반영하는 게 더 낫다.
- v0.4 범위 문서화는 Stage 2 plan_draft에서 명시.

---

## 5. 하이브리드 운영 규칙 (Strict-hybrid operating rules)

v0.3에서 처음 도입하는 운영 모델. Stage 5 기술 설계에서 세부 명세가 확정되지만, Stage 1에서 **골격은 합의**한다.

### Rule 1 — 상위 계층은 Strict

- Stage 1 (Brainstorm), Stage 4 (Plan Final + 승인), Stage 11 (독립 검증 for validation group)은 **Strict 규칙 그대로 적용**.
- 즉 본 문서(brainstorm.md)는 Strict 산출물이다.

### Rule 2 — 하위 번들은 Standard

- 각 번들(1, 4)의 내부 Stage 5~10은 **Standard 모드로 운영**.
- Claude는 Stage 5~7 문서를 쓰고 Codex에 Stage 8, 10을 위임.

### Rule 3 — 번들 간 상호작용은 명시적

- 번들끼리 의존성 있으면 `technical_design.md`의 "의존 번들" 섹션에 기록.
- 런타임 의존성 없음이 이상적. Bundle 1과 Bundle 4의 경우 Bundle 4 산출물(문서 규칙)을 Bundle 1 스킬이 참조.

### Rule 4 — Validation group = Stage 11 공동 검증 단위

- 같은 `validation_group` 번들들은 **함께 Stage 11 독립 검증을 받는다**.
- 이번 세션: **Group 1 = {Bundle 1, Bundle 4}** 하나만 선언. 둘 다 구현 완료 시 하나의 독립 세션에서 함께 검증.
- v0.3 용법은 단순하게: Group 1만 존재. Group 2+ 자동 감지/분할 로직은 넣지 않음 (N11 비목표).

### Rule 5 — verdict 기반 재진입

- 번들 리뷰(Stage 9)에서 verdict 결정:
  - `minor` → 즉시 수정, Stage 재진입 없음
  - `bug_fix` → Stage 8 재실행 (Codex)
  - `design_level` → Stage 5 재진입 (Claude가 설계 갱신)
- 승인(Stage 4.5 재승인)이 필요한지는 `design_level`일 때만 강제.

---

## 6. UI Base-only 정책

### 6-1. 기간 정의 (Period hybrid)

> **v0.5 릴리스** 또는 **downstream 프로젝트 중 `has_ui=true`가 등장하는 시점**, 둘 중 **먼저 도래하는 쪽**까지 "base-only" 단계를 유지.

### 6-2. Base-only 기준선 (Cutline)

다음 요건만 충족하면 base-only 완료로 본다:
1. **파일 존재** — UI 관련 플레이스홀더 파일이 `src/ui/` 등 예상 위치에 생성됨
2. **구조 완성** — 디렉터리/모듈 경계가 미래 확장을 막지 않도록 선언됨
3. **내용은 스켈레톤** — 실제 구현 대신 `# TODO(v0.5): UI support` 주석 수준
4. **has_ui=true 시 경고** — 사용자가 `HANDOFF.md`에 `has_ui: true`를 선언하면 Claude는 세션 시작 시 다음을 출력:

```
⚠️  has_ui=true detected but jOneFlow v0.3 is base-only for UI.
    Expect limited guidance for UI stages. Consider waiting for v0.5+
    or contributing UI-specific stages via PR.
```

### 6-3. 왜 이 수준만 하는가

- v0.1 프로젝트가 백엔드 전용이어서 실사용 피드백이 없다.
- UI 워크플로우는 프론트엔드 생태계(React/Svelte/Vanilla 등) 분화가 커서 잘못 만든 베이스가 오히려 족쇄.
- 경고 메시지로 **조기 drift 감지**만 보장 (사용자가 잘못된 도구라 착각하는 비용을 낮춤).

---

## 7. D-A ~ D-D 전제 재확인

v03_kickoff.md의 사전 결정 4개를 Stage 1 관점에서 재확인.

| ID | 내용 | 재확인 결과 |
|----|------|-----------|
| D-A | Model A UI 접근 (설정 중심, 컴포넌트 라이브러리 아님) | ✅ 유지 |
| D-B | 스킬 기반 추천 (tool-picker가 추천만, 강제 X) | ✅ 유지 |
| D-C | B+C 하이브리드 저장 (요약은 HANDOFF, 상세는 번들 폴더) | ✅ 유지 |
| D-D | 조건부 재질문 (verdict=design_level 일 때만 Stage 4.5 재승인) | ✅ 유지 |

### 7-1. P1–P10 잠재 충돌 체크 (Stage 1 시점 판단)

> ⚠️ **Caveat**: 이 표는 Stage 1 시점의 Claude 판단이다. Stage 5 기술 설계에서 구체 API/스키마가 나올 때 반드시 재검증할 것.

| # | 충돌 가능 포인트 | D-A~D 중 | 현재 판단 |
|---|----------------|---------|----------|
| P1 | 스킬이 Model A UI를 "강제"해버림 | D-A vs D-B | D-B (추천)로 해석하여 회피 |
| P2 | HANDOFF bundles[] 크기 폭발 | D-C | 번들 3개 이상 시 alert, v0.3는 2개라 무관 |
| P3 | 번들 폴더 경로 규칙 미합의 | D-C | Bundle 4 (doc discipline)가 해결 |
| P4 | verdict 판정 주체 불명확 | D-D | 기본 Claude 판정, 사용자 override 가능 |
| P5 | Validation group 1 → N 확장 시 스키마 파괴 | D-C | `validation_group` 필드 처음부터 Int로 |
| P6 | UI base-only 경고와 D-A 충돌 | D-A | has_ui=true일 때만 경고, 기본은 조용 |
| P7 | 스킬 추천과 Codex 위임 타이밍 | D-B | 스킬은 Stage 내부, Codex 호출은 Stage 8 고정 |
| P8 | Stage 11 독립 세션 컨텍스트 전달 방법 | D-D | 기존 Strict 규칙 그대로 (문서 기반) |
| P9 | 번들 간 문서 링크 깨짐 | D-C | Bundle 4 문서 규칙으로 해결 |
| P10 | EN/KO 이중 언어 문서 → 스킬 파싱 오류 | - | 스킬은 메타데이터(헤더) 기반, 본문 언어 무관 |

**판단:** Stage 1에서 감지된 충돌은 모두 Stage 5 설계로 흡수 가능. **blocker 없음.**

---

## 8. 대안 기록 (Rejected alternatives)

브레인스토밍에서 검토했으나 채택하지 않은 방안들.

### A1. Bundle 전체(1+2+3+4)를 한 번에
- **반대 이유**: 각 번들이 얕아져 북극성("30분 온보딩") 달성 불가. 범위 과다.

### A2. Bundle 1 단독 (Bundle 4 제외)
- **반대 이유**: 문서 규칙 없이 tool-picker를 만들면 스킬이 참조할 기준이 없다. Bundle 4가 Bundle 1의 전제.

### A3. 13단계 재설계 (예: 9단계로 압축)
- **반대 이유**: 비목표 N3. 현 13단계 중 실제로 돌아가는 건 절반 남짓이라는 의심은 있지만, v0.1 dogfooding에서 아직 근거 부족.

### A4. Strict 전면 적용 (하이브리드 아님)
- **반대 이유**: v0.3 비용 과다. Jonelab 팀원이 새 프로젝트를 시작할 때 Strict 전 단계를 밟는 건 비현실적.

### A5. Standard 전면 적용 (상위 Strict 없음)
- **반대 이유**: 번들 간 drift 감지 메커니즘이 사라진다. Stage 11 공동 검증 개념이 필요.

### A6. v0.3에서 UI 워크플로우 본격 지원
- **반대 이유**: 프론트엔드 생태계 분화 + 실사용 피드백 없음. 잘못 설계하면 역으로 족쇄.

### A7. Validation group 다층 자동 감지 (의존성 그래프 분석)
- **반대 이유**: 구현 복잡, v0.3 범위 초과. Group 1 단일 선언으로 충분.

---

## 9. Stage 2~4 오픈 포인트

Plan Draft 단계에서 결정할 항목들. 본 Brainstorm에서는 **질문만 박아두고** 답은 다음 Stage로 넘긴다.

### 9-1. Bundle 1 (Tool-picker) 세부
- 스킬 파일 위치: `.skills/tool-picker/SKILL.md` 하나로 충분한지, 하위 `rules/` 분리할지
- 추천 트리거: Stage 진입 시? 사용자 요청 시? 둘 다?
- Claude Code의 `Skill` tool과 어떻게 연결할지 (네이티브 skill 등록 vs 문서 참조만)

### 9-2. Bundle 4 (Doc discipline) 세부
- 문서 헤더 메타데이터 스키마 (YAML frontmatter 도입?)
- 번들 폴더 명명: `bundle1_tool_picker/` vs `tool-picker/` vs `01_tool_picker/`
- 링크 체크 자동화 여부 (v0.3 범위 내 vs v0.4 이월)

### 9-3. HANDOFF.md 스키마 업그레이드
- `bundles[]` 어느 섹션에 넣을지 (기존 "Status" 아래? 별도 "Bundles" 섹션?)
- 기존 v0.1/v0.2 HANDOFF.md 템플릿 하위호환성 유지 방법

### 9-4. Stage 11 독립 검증 절차
- Validation group 1 (Bundle 1 + 4)을 어떻게 독립 Claude 세션에 전달할지
- 검증 프롬프트 템플릿 (Stage 11 전용 kickoff prompt 추가?)

### 9-5. Codex 위임 프롬프트
- Bundle 1은 스킬 파일 생성이 주. Codex에 어느 수준까지 위임?
- Stage 5 기술 설계 → Codex 프롬프트 변환 규칙

### 9-6. 언어 정책 실행
- plan_draft.md부터 EN primary. 번역 타이밍(작성과 동시 vs 승인 후)
- KO 번역 누락을 방지하는 체크리스트 위치

---

## ✅ Stage 1 완료 기준 체크

| 체크 | 상태 |
|------|------|
| 문제 정의가 북극성 한 줄로 축약됐는가 | ✅ "30분 온보딩" |
| 비목표가 명시됐는가 | ✅ N1~N11 |
| 메타데이터(mode/has_ui/risk_level) 확정됐는가 | ✅ strict-hybrid / false / medium |
| 번들 선택 근거가 있는가 | ✅ Bundle 1 + 4, 근거 섹션 4 |
| 하이브리드 운영 규칙 골격이 있는가 | ✅ Rules 1-5 |
| 대안 기록이 있는가 | ✅ A1-A7 |
| Stage 2 오픈 포인트가 정리됐는가 | ✅ 섹션 9 |
| 사용자와 대화하며 작성됐는가 (Claude 혼자 작성 X) | ✅ 전 항목 사용자 합의 |

---

## 📌 Next Stage

**Stage 2 — Plan Draft**  
산출물: `docs/02_planning/plan_draft.md`  
언어: EN primary + KO translation (언어 정책 첫 적용)

---

## 🔖 Addendum (2026-04-22, session 1 close)

### Bundle 4 범위 명확화 — 옵션 β 채택

본 브레인스토밍 Sec. 4-2와 Sec. 9-2는 Bundle 4를 "내부 문서 구조 규칙 (파일명, 메타데이터 헤더, 링크 규칙 등)"으로 묘사했다. 그러나 `prompts/claude/v03_kickoff.md`의 goal 번호 매핑에서 **Bundle 4 = goals 5/9/10** 은 다음과 같이 정의된다:

- **Goal 5** — `HANDOFF.md` auto-writer 스크립트 (`scripts/update_handoff.sh`)
- **Goal 9** — `CHANGELOG.md` 도입 + 유지 규칙
- **Goal 10** — `CONTRIBUTING.md` 분리 + `CODE_OF_CONDUCT.md`

즉 kickoff의 goals는 **외부 문서 생명주기 / 공개용 메타 문서**에 가까운 반면, 본문 Sec. 4-2는 **내부 문서 구조 규칙**을 말하고 있었다.

**결정 (2026-04-22)**: **옵션 β 채택.** Bundle 4는 goals 5/9/10 **과** Sec. 9-2의 내부 구조 규칙을 **모두** 포함한다.

**이유**:
1. 외부 문서(CHANGELOG 등)의 내용은 내부 구조(어느 문서에 뭐가 기록되는지)에 의존한다. 분리가 인위적이다.
2. Bundle 1의 tool-picker 스킬은 문서 구조를 파싱해야 작동한다. 구조 정의를 Bundle 1에 넣으면 Bundle 1이 과부하(risk → high).
3. 저위험 Bundle 4를 조금 키워서 risk 분산시키는 게 전체에 유리.
4. 북극성 "30분 온보딩"은 외부 + 내부 양쪽 문서 품질 모두에 의존.

**범위 확장에 따른 변경**:
- `Bundle 4 risk_level`: `low-medium` → **`medium`** (`HANDOFF.md` bundles[] 스키마에도 반영 완료)
- Bundle 4 산출물에 다음이 추가됨 (기존 goals 5/9/10에 더하여):
  - `internal_doc_header_schema` — (YAML frontmatter 여부 포함)
  - `bundle_folder_naming` — (`bundle1_tool_picker/` vs `tool-picker/` 등)
  - `doc_link_conventions` — (내부 상대경로 규칙, link-check 자동화는 별도 결정)
  - `template_vs_dogfooding_separation` — (이 브레인스토밍 Sec. 9-3 + HANDOFF.md 상단 경고 관련 원본 deferral을 Bundle 4에 흡수)

**기각한 대안**:
- **옵션 α** (goals만, 내부 구조는 Bundle 1에 이관) — Bundle 1 risk 상향, 책임 분산 약화로 기각.
- **옵션 γ** (Bundle 4a + 4b 분할) — 3번들로 증가, 관리 복잡도 상승으로 기각.

### 이 Addendum의 읽기 순서

- 본문 Sec. 4-2·Sec. 9-2의 Bundle 4 묘사가 내부 구조에만 국한된 것처럼 읽히면, **이 Addendum이 우선**한다.
- `HANDOFF.md`의 `bundles[]` YAML의 `scope_option: beta` 필드가 이 결정의 기계 판독 가능한 표식이다.

---

### 세션 종료 노트

- **세션 1 종료 시점**: 2026-04-22, Stage 1 완료 + Bundle 4 범위 명확화 직후.
- **다음 세션 진입점**: Stage 2 — Plan Draft 작성.
- **이월 오픈 포인트**: Sec. 9-1 ~ Sec. 9-6 모두 Stage 2에서 처리. 옵션 β 관련 추가 구체화(Sec. 9-2)는 범위 확장에 맞춰 재평가 필요.

