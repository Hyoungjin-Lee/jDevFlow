# Claude Handoff — jOneFlow Workflow Architecture Refactor

Date: 2026-04-21
Owner: Jonelab_Platform / jOneFlow
Execution owner: Claude
Primary target: `WORKFLOW.md`
Related files: `README.md`, `README.ko.md`, `CLAUDE.md`, `HANDOFF.md`, `prompts/`

---

## 1. 목적

이번 작업의 목적은 `jOneFlow`의 현재 [WORKFLOW.md](/Users/geenya/projects/Jonelab_Platform/jOneFlow/WORKFLOW.md:1)를 단순한 절차 문서가 아니라, 향후 플랫폼 엔진이나 상태 머신으로 확장 가능한 "워크플로우 아키텍처 기준 문서"로 재정의하는 것이다.

핵심 방향은 아래와 같다.

1. 현재 13단계 워크플로우의 강점은 유지한다.
2. 하지만 이를 모든 프로젝트의 기본값으로 강제하지 않는다.
3. `Lite / Standard / Strict` 계층 구조를 도입할 수 있도록 재구성한다.
4. stage name 중심 설명을 넘어, stage type / 실행 조건 / 완료 기준 / 재진입 규칙을 갖춘 메타 구조로 바꾼다.

이 작업은 `superpowers` 참고 개선 작업보다 더 상위 레벨의 구조 작업이다.
즉, 이번 작업은 "템플릿 개선"이 아니라 "플랫폼 코어 워크플로우 모델 정리"에 가깝다.

---

## 2. 핵심 진단 요약

현재 `WORKFLOW.md`는 다음 강점을 갖고 있다.

- 문서 산출물 중심 구조가 명확하다
- 사용자 승인 지점이 분명하다
- 구현 / 리뷰 / 검증 / QA / 배포가 분리돼 있다
- Claude와 Codex의 역할 분리가 선명하다
- 향후 멀티 에이전트/오케스트레이션 구조로 확장하기 좋다

하지만 현재 한계도 분명하다.

- 13단계가 사실상 기본값처럼 보인다
- 프로젝트 크기/위험도/도메인에 따른 경량화 규칙이 없다
- optional 단계의 실행 조건이 약하다
- validation 비용 계층화가 없다
- Codex 실행 단계가 상대적으로 추상적이다
- 재진입/롤백/루프 규칙이 없다
- 플랫폼 엔진이 이해할 수 있는 메타데이터가 부족하다

정리하면:

- 지금 구조는 "좋은 strict reference flow"
- 아직은 "플랫폼 운영 가능한 workflow model"은 아님

---

## 3. 이번 작업의 목표

Claude는 이번 작업에서 아래 목표를 실제 문서 수정 수준으로 반영해야 한다.

### A. 현재 13단계를 Canonical Strict Flow로 재정의

현재 13단계를 없애거나 약화시키는 것이 아니라, 이것이 모든 상황의 기본값이 아니라는 점을 명확히 해야 한다.

즉:
- 현재 워크플로우 = strict / full governance reference flow
- 이것은 플랫폼 철학의 상한선 역할
- 실제 운영은 여기에 경량 모드를 추가하는 구조

### B. Lite / Standard / Strict 구조 초안 도입

아래 3계층을 최소한 문서상으로는 정의해야 한다.

- Lite Flow
- Standard Flow
- Strict Flow

각 모드는 아래를 포함해야 한다.

- 언제 쓰는지
- 어떤 단계가 포함되는지
- 어떤 단계가 생략되는지
- 사용자 승인 지점이 어디인지
- 어떤 위험도/복잡도에 적합한지

### C. Stage Type 중심으로 메타 구조화

각 단계를 단순히 번호+이름으로만 보지 말고, 유형으로 일반화한다.

예시:
- ideation
- planning
- approval_gate
- design
- implementation
- review
- validation
- qa_release
- archive

중요한 건 exact naming이 아니라, 향후 플랫폼 엔진이 재조합 가능한 형태로 보는 관점을 문서화하는 것이다.

### D. 실행 조건 정의

각 단계는 "항상 수행"이 아니라 조건에 따라 켜지고 꺼져야 한다.

예시:
- UI 단계: `has_ui == true`
- Plan review: `complexity >= medium`
- Final validation: `risk_level >= high`
- User approval: `approval_mode == manual`

지금 턴에서 실제 DSL을 구현할 필요는 없지만, 최소한 문서와 표 수준으로 조건 구조는 보여줘야 한다.

### E. 완료 조건 정의

각 단계는 단순히 문서를 쓰는 것으로 끝나면 안 되고, "완료로 판정할 기준"이 있어야 한다.

예시:
- Plan final completed when scope / risks / success criteria are clear
- Technical design completed when module boundaries / data flow / error handling are specified

이번 턴에서 모든 단계의 아주 상세한 rubric까지는 아니더라도, 최소한 대표 단계들의 completion criteria를 명시해야 한다.

### F. 재진입 / 롤백 규칙 정의

실제 workflow는 직선이 아니다.

최소한 아래와 같은 루프를 문서화해야 한다.

- Review fail -> Revision
- Validation fail -> Implementation or Design rollback
- Approval reject -> Plan Final or earlier planning stage
- QA fail -> Revision

중요:
- 선형 표만 있으면 플랫폼 엔진으로 확장하기 어렵다
- 이번 턴에서 흐름도 또는 표 수준으로 재진입 구조를 문서화해야 한다

### G. Codex 실행 단계 구체화 방향 제시

Stage 8, 10, 13은 플랫폼 관점에서 훨씬 더 세밀해져야 한다.

이번 턴에서 최소한 아래 방향은 반영해야 한다.

- implementation is not only "write code"
- revision is not only "apply feedback"
- deploy & archive is not only "finish"

권장 세분화 관점:
- generate code
- run tests
- fix test failures
- update implementation log
- create commit/checkpoint
- prepare handoff/archive

반드시 세부 stage를 전부 추가할 필요는 없지만, 적어도 문서상에서 "향후 operation-level breakdown 대상"임을 명시하라.

---

## 4. 절대 원칙

- `WORKFLOW.md`를 더 좋은 strict flow로 정리하되, 더 무겁게 만들지 않는다
- `jOneFlow`의 문서 중심 철학은 유지한다
- 초보자 친화성은 유지한다
- 비개발자도 읽고 이해 가능한 설명 구조를 유지한다
- 너무 이론적인 DSL 문서로 만들지 않는다
- 실제 사용자 문서와 플랫폼 확장 관점을 둘 다 만족시키는 균형을 잡는다
- 기존 `HANDOFF.md`, `README`, `CLAUDE.md`와 메시지가 충돌하지 않게 한다

---

## 5. 권장 수정 방향

### 5.1 `WORKFLOW.md`

이 파일은 이번 작업의 핵심이다.

반영 권장 항목:
- 현재 13단계를 `Strict Flow`로 명시
- Lite / Standard / Strict 비교표 추가
- stage type 개념 추가
- 단계별 조건 규칙 추가
- 단계별 완료 기준 섹션 추가
- 재진입 / rollback 규칙 추가
- Codex execution 단계의 future breakdown 방향 명시

### 5.2 `README.md` / `README.ko.md`

반영 권장 항목:
- `jOneFlow`가 하나의 고정 절차가 아니라 계층형 workflow platform임을 설명
- 기본 사용자에게는 Standard 또는 guided path가 더 적절하다는 메시지 검토
- Strict Flow는 canonical reference라는 설명 추가 검토

### 5.3 `CLAUDE.md`

반영 권장 항목:
- 모든 작업에 무조건 13단계를 강제하는 인상을 줄이지 않도록 정리
- feature work / hotfix / lite execution 구분을 더 명확히
- workflow mode selection 기준을 더 명시

### 5.4 필요 시 새 문서 추가

권장 후보:
- `docs/notes/workflow_modes.md`
- 또는 `docs/notes/workflow_architecture_notes.md`

단, 이번 턴에서 새 문서를 추가하는 목적은 `WORKFLOW.md`가 과도하게 비대해지는 것을 막기 위한 보조 수단이어야 한다.

---

## 6. Claude가 이번 턴에서 해야 할 작업

### Step 1. 현재 구조 읽기

아래 파일을 먼저 읽는다.

- `WORKFLOW.md`
- `README.md`
- `README.ko.md`
- `CLAUDE.md`
- `HANDOFF.md`
- `prompts/claude/planning_draft.md`
- `prompts/claude/planning_review.md`
- `prompts/claude/planning_final.md`
- `prompts/claude/technical_design.md`

### Step 2. 구조 판단

짧게 정리할 것:
- what stays canonical
- what becomes conditional
- what should be simplified for Lite/Standard modes
- which documents need updates

이 단계에서 멈추지 말고, 바로 실제 수정으로 이어가라.

### Step 3. 실제 문서 수정

최소 목표:
- `WORKFLOW.md` 실질 개편
- 관련 문서 정합성 수정

권장 목표:
- mode comparison 표 추가
- stage type / trigger / completion criteria / re-entry 규칙 반영
- 필요 시 보조 문서 추가

### Step 4. 검토

검토 기준:
- 지나치게 추상적이지 않은가
- 일반 사용자가 읽고도 따라갈 수 있는가
- 플랫폼 설계 힌트가 충분한가
- 기존 문서와 충돌하지 않는가
- strict flow의 가치가 훼손되지 않았는가

### Step 5. 결과 요약

최종 응답에는 아래를 포함한다.

- 변경한 파일 목록
- Canonical / Lite / Standard / Strict를 어떻게 정의했는지
- stage type / 조건 / 완료 기준 / 재진입 규칙을 어떻게 반영했는지
- 남은 리스크
- 다음으로 이어질 superpowers 개선 작업과의 연결 포인트

---

## 7. 완료 정의

이번 작업은 아래가 만족되면 완료로 본다.

- `WORKFLOW.md`가 단순 절차 문서에서 한 단계 올라가 있다
- 현재 13단계가 `Strict Flow`로 재정의되어 있다
- Lite / Standard / Strict 구조가 최소 초안 수준으로 정리되어 있다
- stage type / 조건 / 완료 기준 / 재진입 규칙이 문서상 드러난다
- 관련 문서들이 이 구조와 충돌하지 않는다
- 다음 단계인 `superpowers` 기반 개선 작업을 붙이기 쉬운 상태가 된다

---

## 8. 이 작업과 superpowers 작업의 관계

순서가 중요하다.

이번 작업은 "workflow architecture 정리"다.
기존 `superpowers` 핸드오프는 "운영/템플릿 개선"이다.

권장 순서:

1. workflow architecture 정리
2. 사용자 승인 또는 최소 확인
3. superpowers 참고 개선 작업 실행

이 순서를 지키는 이유:
- workflow 코어 모델이 먼저 정리돼야
- session bootstrap, skill template, planning template, eval이 더 일관되게 붙는다

즉, 이번 작업은 superpowers 작업의 상위 선행 작업이다.
