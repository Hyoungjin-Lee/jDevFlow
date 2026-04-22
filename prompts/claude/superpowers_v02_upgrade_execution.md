# jDevFlow v0.2 Upgrade Execution Prompt

아래 지시에 따라 `jDevFlow` 템플릿 개선 작업을 실제로 진행해줘.

중요:
- `superpowers/` 폴더는 참고 자료다. 수정하지 마라.
- 이번 작업은 분석이 아니라 실제 파일 수정 작업이다.
- 단, `superpowers`를 복제하지 말고 `jDevFlow` 철학 위에 필요한 요소만 흡수해라.
- `jDevFlow`의 강점인 문서 중심 운영, `HANDOFF.md` 기반 세션 지속성, 보안, 비개발자 친화성, EN/KO 지원은 유지해야 한다.

먼저 읽을 파일:
- `docs/notes/2026-04-21-superpowers-analysis-handoff.md`
- `README.md`
- `README.ko.md`
- `CLAUDE.md`
- `HANDOFF.md`
- `WORKFLOW.md`
- `.skills/README.md`
- `scripts/init_project.sh`
- `security/secret_loader.py`
- `prompts/claude/planning_draft.md`
- `prompts/claude/planning_review.md`
- `prompts/claude/planning_final.md`
- `prompts/claude/technical_design.md`
- 필요 시 `prompts/claude/ui_requirements.md`
- 필요 시 `prompts/claude/ui_flow.md`
- 참고용: `superpowers/README.md`
- 참고용: `superpowers/skills/test-driven-development/SKILL.md`
- 참고용: `superpowers/skills/writing-plans/SKILL.md`
- 참고용: `superpowers/hooks/hooks.json`
- 참고용: `superpowers/hooks/session-start`

작업 목표:
1. Session bootstrap 구조 강화
2. `.skills` 체계를 행동 유도형으로 개선
3. Stage 2~5 planning/design 템플릿 강화
4. workflow eval 최소 세트 설계 또는 scaffold 추가
5. 보안/온보딩 메시지 정리
6. EN/KO 일관성 정리
7. `superpowers` 참고/차용에 대한 attribution 정리

반드시 지켜야 할 원칙:
- 기본 사용자 경험은 단순하게 유지할 것
- 고급 기능은 선택형 또는 hook-ready 구조로 둘 것
- 문서 간 메시지 충돌을 없앨 것
- 비개발자도 이해 가능한 문서 톤을 유지할 것
- `superpowers`식 강한 규율은 필요한 범위만 도입할 것
- 구현이 불안정한 자동화는 억지로 넣지 말 것
- 공개 Git 공유를 고려해 attribution을 보수적으로 정리할 것

실행 순서:

## 1. 현재 상태 점검

먼저 현재 구조를 읽고 아래를 짧게 정리해라.
- 필수 반영 항목
- 선택형 반영 항목
- 이번 턴 보류 항목
- 수정 대상 파일 목록

그 다음 바로 수정으로 들어가라. 이 단계에서 멈추지 마라.

## 2. Session bootstrap 개선

아래 목표를 반영해라.
- 세션 시작 시 읽어야 하는 표준 흐름을 더 명확히 만든다
- `CLAUDE.md -> HANDOFF.md -> WORKFLOW.md -> relevant docs/` 읽기 흐름을 구조적으로 강화한다
- 가능하면 hook-ready 구조나 문서화된 bootstrap 진입점을 제공한다
- 환경 종속성이 큰 자동 훅은 무리하게 강제하지 말고, 선택형 설계로 둔다

기대 결과:
- README / CLAUDE / WORKFLOW / HANDOFF에서 세션 진입 흐름이 일관됨
- 사용자 입장에서 "어떻게 시작해야 하는지"가 더 명확해짐

## 3. `.skills` 체계 개선

`.skills/README.md`를 단순 가이드에서 행동 유도형 구조로 강화해라.

반드시 반영할 요소:
- When to Use
- Do / Don't
- Red Flags
- Good / Bad
- Checklist
- Verification

추가 작업:
- 새 스킬 작성용 템플릿 파일을 추가해라
- 가능하면 샘플 스킬 1~2개도 추가해라
- 템플릿은 비개발자도 따라 쓸 수 있게 해야 한다

## 4. Stage 2~5 템플릿 강화

다음 프롬프트들을 강화해라.
- `prompts/claude/planning_draft.md`
- `prompts/claude/planning_review.md`
- `prompts/claude/planning_final.md`
- `prompts/claude/technical_design.md`
- 필요 시 `ui_requirements.md`
- 필요 시 `ui_flow.md`

강화 포인트:
- exact file paths
- in scope / out of scope
- acceptance criteria
- test strategy
- implementation constraints
- Codex handoff 품질
- 필요한 경우 review checklist

목표:
- Claude가 작성한 planning/design 문서만으로도 Codex handoff 품질이 높아져야 한다
- 문서가 너무 무거워지지 않도록 균형을 유지해야 한다

## 5. workflow eval 추가

`jDevFlow`가 실제로 에이전트 행동을 바꾸는지 검증할 최소 구조를 추가해라.

가능한 방향:
- `docs/notes/workflow_eval_plan.md`
- 또는 `tests/` 아래 lightweight eval scaffold

포함해야 할 내용:
- 무엇을 검증할지
- 어떤 입력으로 검증할지
- 기대 행동은 무엇인지
- 어떤 실패 패턴을 잡고 싶은지

중요:
- 완성된 자동화 테스트 스위트가 아니어도 된다
- 하지만 실제 운영에서 이어서 확장 가능한 출발점이어야 한다

## 6. 보안 / 온보딩 메시지 정리

현재 README와 `scripts/init_project.sh` 사이의 `.env` 관련 메시지 차이를 정리해라.

중점:
- `.env.example`는 무엇인지
- `.env`는 어떤 용도로 남겨둘 것인지
- 실제 시크릿은 어디에 저장해야 하는지
- `secret_loader.py` 철학과 사용자 안내를 어떻게 맞출지

필요하면:
- README 문구 수정
- 한국어 README 동기화
- 스크립트 출력 메시지 정리

## 7. EN/KO 정합성 정리

이번에 수정된 사용자-facing 문서는 가능하면 영어/한국어가 어긋나지 않게 맞춰라.

우선순위:
- `README.md`
- `README.ko.md`
- `CLAUDE.md`
- 새로 추가한 주요 문서

## 8. Attribution 정리

이번 작업은 `superpowers`를 참고해 실제 구조와 템플릿을 개선하는 작업이므로, 공개 저장소 공유를 고려한 attribution을 정리해라.

반드시 할 일:
- 어떤 부분이 inspiration인지
- 어떤 부분이 adapted structure인지
- 어떤 부분이 문구/템플릿/구조 차용인지
- 어디에 어떤 수준의 출처를 남길지 정리

최소 산출물:
- `README.md`의 acknowledgment 또는 inspiration 문구
- 루트 `ATTRIBUTION.md` 또는 `NOTICE` 계열 파일 초안
- 필요 시 `README.ko.md` 대응 문구

실무 기준:
- 아이디어만 참고했어도 공개 프로젝트라면 출처를 남기는 쪽이 좋다
- 구조/문구/템플릿 차용이 있다면 더 명확한 attribution을 남겨라
- `superpowers`는 MIT License이므로, substantial portion에 해당할 수 있는 차용이 있다면 저작권/라이선스 고지 유지에 유리한 방향으로 정리해라
- 법률 해석을 단정하지 말고, 보수적인 공개 오픈소스 관행에 맞춰라

## 9. 작업 범위 관리

이번 턴에서 하지 말 것:
- `superpowers/` 폴더 수정
- marketplace/plugin 배포 작업
- 과도한 자동 orchestration 구현
- 불안정한 플랫폼 종속 훅 강제 도입

이번 턴에서 해도 좋은 것:
- 선택형 hook-ready 구조
- 문서 템플릿 강화
- 예시 스킬 추가
- 평가 문서/scaffold 추가
- 온보딩 흐름 정리
- attribution 파일 초안 추가

## 10. 완료 후 응답 형식

최종 응답에는 반드시 아래를 포함해라.

1. 변경한 파일 목록
2. 각 파일에서 무엇을 바꿨는지
3. 어떤 설계 판단을 했는지
4. 기본값과 선택형 기능을 어떻게 나눴는지
5. attribution이 필요한 부분과 실제 반영 방식
6. 남은 리스크 / 후속 권장 작업

작업을 멈추지 말고, 가능한 범위까지 실제 파일 수정과 정리까지 끝내라.
