# Fresh Claude Account Briefing — jOneFlow Upgrade Work

Date: 2026-04-21
Purpose: 이전 대화 맥락이 전혀 없는 새 Claude 계정이 바로 작업을 시작할 수 있도록 제공하는 self-contained briefing

---

## 1. 현재 상황

이 작업은 `jOneFlow`라는 AI-assisted development workflow template / platform 방향의 프로젝트를 개선하는 일이다.

작업 대상 경로:
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow`

중요한 점:
- 이 Claude 계정은 이전 대화 문맥이 없다
- 따라서 반드시 문서 파일을 먼저 읽고 현재 의도를 복원해야 한다
- 이전 채팅 내용을 가정하면 안 된다

---

## 2. 프로젝트 핵심 요약

`jOneFlow`는:
- 문서 중심 개발 워크플로우
- `CLAUDE.md`, `HANDOFF.md`, `WORKFLOW.md`, `docs/`를 중심으로 상태를 이어가는 구조
- Claude와 Codex의 역할 분리를 전제로 한 템플릿
- 비개발자 친화성과 EN/KO 지원을 중시
- 보안 관점에서 secure secret loading 가이드를 포함

최근 작업 방향은 크게 세 축이다.

1. `WORKFLOW.md`를 플랫폼 친화적인 workflow architecture로 재구성
2. `superpowers`를 참고해 session bootstrap / skills / planning template / eval을 개선
3. 공개 Git 공유를 고려해 `superpowers` 참고/차용에 대한 attribution 정리

---

## 3. 반드시 알아야 할 참고 자료

### 코어 문서

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/README.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/README.ko.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/CLAUDE.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/HANDOFF.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/WORKFLOW.md`

### 실행 순서 문서

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-claude-execution-sequence.md`

### Phase 1 문서

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-workflow-architecture-handoff.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/workflow_architecture_rebuild_execution.md`

### Phase 2 문서

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-superpowers-analysis-handoff.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/superpowers_v02_upgrade_execution.md`

### Phase 2B 문서

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-superpowers-attribution-handoff.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/superpowers_attribution_execution.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-superpowers-attribution-copy.md`

---

## 4. 작업 순서

새 Claude 계정은 아래 순서를 따른다.

### Phase 1

먼저 workflow architecture 정리 작업을 수행한다.

목표:
- 현재 13단계를 `Canonical Strict Flow`로 재정의
- `Lite / Standard / Strict` 구조 도입
- stage type / 조건 / completion criteria / re-entry 규칙 정리

### Phase 2

그 다음 superpowers 참고 개선 작업을 수행한다.

목표:
- session bootstrap 개선
- `.skills` 행동 유도형 구조 강화
- planning/design template 강화
- workflow eval 기초 구조 추가
- 보안/온보딩 메시지 정리
- EN/KO 정합성 정리

### Phase 2B

그 다음 attribution 정리 작업을 수행한다.

목표:
- `README.md` acknowledgment
- `README.ko.md` 대응 문구 검토
- 루트 `ATTRIBUTION.md` 작성
- `superpowers` 영향 범위에 대한 성실한 출처 표기

### Phase 3

마지막으로 전체 정합성을 점검한다.

---

## 5. superpowers 관련 주의사항

- 참고 폴더: `/Users/geenya/projects/Jonelab_Platform/jOneFlow/superpowers`
- 이 폴더는 레퍼런스다
- 수정하면 안 된다

참고 이유:
- 자동 bootstrap
- skill design discipline
- planning template rigor
- workflow eval and review patterns

하지만 `jOneFlow`는:
- 문서 중심
- handoff 중심
- bilingual
- 비개발자 친화적
- secure-secret guidance 포함

따라서 복제가 아니라 재해석과 통합이 목적이다.

---

## 6. 새 Claude 계정이 특히 주의할 점

- 이전 채팅에서 합의된 내용을 안다고 가정하지 말 것
- 파일 경로를 직접 읽어서 컨텍스트를 복원할 것
- 각 phase를 순차적으로 수행할 것
- 가능하면 Phase 1 결과를 정리한 뒤 Phase 2로 넘어갈 것
- attribution은 실제 반영 범위를 본 뒤에 확정할 것

---

## 7. 바로 시작할 때의 핵심 지시

새 Claude 계정은:

1. `2026-04-21-claude-execution-sequence.md`를 먼저 읽고
2. 현재 진행할 phase를 확인한 뒤
3. 해당 phase의 handoff + execution prompt를 읽고
4. 실제 파일 수정 작업을 진행하면 된다

이 briefing은 "문맥 복구용 시작 문서"다.
