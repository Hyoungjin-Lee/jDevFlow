# jOneFlow Workflow Architecture Rebuild Prompt

아래 지시에 따라 `jOneFlow`의 workflow architecture 정리 작업을 실제 파일 수정까지 진행해줘.

중요:
- 이번 작업의 핵심은 `WORKFLOW.md`를 플랫폼 친화적인 workflow model 관점으로 재구성하는 것이다.
- 지금의 13단계를 삭제하는 것이 아니라, 이것을 `Canonical Strict Flow`로 재정의해야 한다.
- 모든 프로젝트에 같은 무게를 강제하는 구조가 아니라, `Lite / Standard / Strict` 계층 구조를 도입하는 방향으로 정리해야 한다.
- 이 작업은 `superpowers` 참고 개선 작업보다 선행되는 구조 작업이다.
- `superpowers/` 폴더는 참고만 하고 수정하지 마라.

먼저 읽을 파일:
- `docs/notes/2026-04-21-workflow-architecture-handoff.md`
- `WORKFLOW.md`
- `README.md`
- `README.ko.md`
- `CLAUDE.md`
- `HANDOFF.md`
- `prompts/claude/planning_draft.md`
- `prompts/claude/planning_review.md`
- `prompts/claude/planning_final.md`
- `prompts/claude/technical_design.md`

이번 작업 목표:
1. 현재 13단계를 Canonical Strict Flow로 재정의
2. Lite / Standard / Strict 구조 초안 반영
3. stage type 개념 도입
4. 단계별 실행 조건 개념 반영
5. 단계별 완료 기준 개념 반영
6. 재진입 / rollback 규칙 반영
7. Codex 실행 단계의 future breakdown 방향 명시
8. 관련 문서 정합성 정리

반드시 지켜야 할 원칙:
- 문서 중심 철학 유지
- 비개발자 친화성 유지
- 일반 사용자도 읽을 수 있는 설명 유지
- 과도하게 추상적인 DSL 문서로 만들지 말 것
- strict flow는 약화시키지 말고 위치를 재정의할 것
- Lite / Standard / Strict는 실제 사용 판단 기준이 있어야 함

실행 순서:

## 1. 현재 구조 판단

먼저 아래를 짧게 정리해라.
- 현재 `WORKFLOW.md`에서 유지할 것
- conditional로 바꿔야 할 것
- Lite / Standard / Strict로 분리할 때 핵심 차이
- 어떤 파일을 함께 수정해야 하는지

정리 후 바로 수정으로 들어가라. 여기서 멈추지 마라.

## 2. `WORKFLOW.md` 재구성

반드시 반영할 요소:
- 현재 13단계 = Canonical Strict Flow
- Lite / Standard / Strict 비교표
- 각 mode의 사용 상황
- stage type 관점 설명
- 단계별 trigger/조건 예시
- 단계별 completion criteria 개념
- re-entry / rollback 루프

적절하면 아래 개념을 도입해라.
- ideation
- planning
- approval_gate
- design
- implementation
- review
- validation
- qa_release
- archive

중요:
- 이름이 꼭 이대로일 필요는 없지만, 플랫폼 엔진이 재조합 가능한 관점이 드러나야 한다
- 문서는 사용자 안내와 플랫폼 모델 힌트를 모두 제공해야 한다

## 3. mode 구조 반영

최소한 아래 3개 모드를 문서상 정의해라.

### Lite
- 작은 작업
- 낮은 위험도
- 빠른 실행 중심

### Standard
- 일반적인 기능 개발
- 기본 승인/검토 포함
- 대부분의 실무 기본값 후보

### Strict
- 고위험 / 고복잡도 / 아키텍처 영향 큰 작업
- 현재 13단계 전체 또는 거의 전체 포함
- canonical reference flow

각 mode에는 아래가 있어야 한다.
- 언제 사용하는지
- 포함 단계
- 생략 가능 단계
- 승인 지점
- 검토/검증 강도

## 4. completion criteria / re-entry 구조

반드시 문서화해라.

예시 방향:
- Plan Final 완료 기준
- Technical Design 완료 기준
- Review fail 시 어디로 돌아가는지
- Validation fail 시 어디로 롤백하는지
- Approval reject 시 어느 planning 단계로 복귀하는지

중요:
- workflow는 직선이 아니라는 점이 드러나야 한다
- 최소한 표나 규칙 목록으로 표현해야 한다

## 5. 관련 문서 정합성 정리

`WORKFLOW.md`만 바꾸고 끝내지 마라.

아래 파일과 충돌이 생기지 않도록 정리해라.
- `README.md`
- `README.ko.md`
- `CLAUDE.md`
- 필요 시 planning/design prompt들

특히 아래를 점검해라.
- jOneFlow가 고정 13단계만 강제하는 것처럼 읽히는지
- hotfix / feature / architecture-level work 구분이 충분한지
- 사용자 입장에서 어떤 mode를 언제 써야 할지 감이 오는지

## 6. 추가 문서 여부 판단

필요하면 아래 유형의 보조 문서를 추가해라.
- workflow modes 설명 문서
- workflow architecture notes

단, 새 문서는 보조 역할이어야 하며 핵심 설명은 `WORKFLOW.md`에 남겨라.

## 7. superpowers 작업과의 연결 고려

이번 작업은 선행 구조 작업이므로, 최종 상태가 다음 작업에 자연스럽게 이어져야 한다.

다음 superpowers 기반 개선 작업에서 붙을 영역:
- session bootstrap
- `.skills` behavioral template
- planning/design template 강화
- eval 구조

즉, 이번 작업에서 mode / stage type / 조건 / completion criteria를 정리해두면 다음 작업이 더 일관되게 진행될 수 있어야 한다.

## 8. 완료 후 응답 형식

최종 응답에는 반드시 아래를 포함해라.

1. 변경한 파일 목록
2. `WORKFLOW.md`를 어떻게 재구성했는지
3. Lite / Standard / Strict를 어떻게 정의했는지
4. stage type / 조건 / completion criteria / re-entry 규칙을 어떻게 반영했는지
5. 어떤 부분은 이번 턴에서 의도적으로 단순화했는지
6. 다음 superpowers 개선 작업으로 어떻게 이어지는지

작업을 멈추지 말고, 실제 파일 수정과 정리까지 끝내라.
