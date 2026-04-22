# Claude Execution Sequence — jOneFlow v0.2

Date: 2026-04-21
Purpose: Claude에게 어떤 순서로 작업을 맡길지 정리한 실행 순서 문서

---

## 권장 실행 순서

### Phase 0. Fresh Account Context Restore

이 단계는 새 Claude 계정 또는 이전 대화 맥락이 없는 세션에서만 수행한다.

먼저 아래 두 파일을 사용한다.

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-fresh-claude-account-briefing.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/fresh_claude_account_master_kickoff.md`

이 단계의 목적:
- 이전 대화 맥락 없이도 현재 작업 의도와 실행 순서를 복원
- 새 계정이 어디서부터 시작해야 하는지 명확히 정리
- 기본 시작점을 Phase 1로 고정

### Phase 1. Workflow Architecture 정리

먼저 아래 두 파일을 사용한다.

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-workflow-architecture-handoff.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/workflow_architecture_rebuild_execution.md`

이 단계의 목적:
- `WORKFLOW.md`를 Canonical Strict Flow + Lite / Standard / Strict 구조로 재정의
- stage type / 조건 / 완료 기준 / 재진입 규칙 정리
- 플랫폼 코어 workflow model을 먼저 안정화

이 단계가 먼저인 이유:
- 이후의 session bootstrap, skill system, planning template 개선이
  workflow 코어 모델과 충돌하지 않게 하기 위해서

### Phase 2. superpowers 참고 개선 작업

Phase 1이 끝난 뒤 아래 두 파일을 사용한다.

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-superpowers-analysis-handoff.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/superpowers_v02_upgrade_execution.md`

이 단계의 목적:
- session bootstrap 구조 강화
- `.skills` 행동 유도형 구조 개선
- planning/design template 강화
- workflow eval 기초 구조 추가
- 보안/온보딩 메시지 정리
- EN/KO 정합성 정리

Phase 1 이후에 하는 이유:
- workflow mode / 조건 / completion criteria가 먼저 정리돼야
  superpowers식 개선 요소를 더 정확하게 얹을 수 있기 때문

### Phase 2B. superpowers attribution 정리

Phase 2의 실제 반영 범위가 나온 뒤 아래 두 파일을 사용한다.

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-superpowers-attribution-handoff.md`
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/superpowers_attribution_execution.md`

이 단계의 목적:
- `superpowers`에서 영향을 받은 부분을 정리
- 공개 Git 저장소 공유를 위한 acknowledgment / attribution 정리
- `README.md`와 `ATTRIBUTION.md` 수준의 보수적 출처 표기 반영

Phase 2 이후에 하는 이유:
- 실제로 무엇이 반영되었는지 확인한 뒤 attribution을 확정하는 것이 가장 정확하기 때문

### Phase 3. 통합 점검

권장 후속 작업:
- README / README.ko / CLAUDE / WORKFLOW / prompts / skills 간 메시지 일관성 재점검
- Lite / Standard / Strict 각각의 온보딩 설명 점검
- 향후 eval 확장 포인트 정리

---

## 우선순위 판단

### 가장 높은 우선순위

1. Workflow architecture 정리

이유:
- 코어 모델이 먼저 정리돼야 나머지 개선이 덜 흔들린다
- 현재 가장 상위 레벨의 구조 문제를 먼저 해결해야 한다

### 두 번째 우선순위

2. superpowers 기반 운영 개선

이유:
- 실행 품질, 자동화, 스킬 정교함을 강화하는 작업이지만
- 코어 workflow 모델이 먼저 정리돼야 더 깔끔하게 들어간다

### 세 번째 우선순위

3. superpowers attribution 정리

이유:
- 실제 반영된 범위를 기준으로 출처를 정리해야 정확하다
- 공개 Git 공유 전에 투명한 acknowledgment를 남기는 것이 좋다

### 네 번째 우선순위

4. 통합 정합성 점검

이유:
- 앞의 두 작업이 문서와 구조를 넓게 건드리므로
- 마지막에 전체 UX와 메시지를 한번 다시 맞춰야 한다

---

## Claude에게 바로 전달할 때 사용할 문장

### 새 계정 시작 요청

```text
/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-fresh-claude-account-briefing.md 를 먼저 읽고,
/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/fresh_claude_account_master_kickoff.md 의 지시에 따라
이전 대화 맥락이 없는 새 Claude 계정 기준으로 jOneFlow 개선 작업을 시작해줘.
특별한 추가 지시가 없으면 Phase 1부터 시작해줘.
```

### 1단계 실행 요청

```text
/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-workflow-architecture-handoff.md 를 먼저 읽고,
/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/workflow_architecture_rebuild_execution.md 의 지시에 따라
jOneFlow의 workflow architecture 정리 작업을 실제 파일 수정까지 진행해줘.
이번 작업은 superpowers 참고 개선보다 선행되는 코어 구조 작업이야.
```

### 2단계 실행 요청

```text
/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-superpowers-analysis-handoff.md 를 먼저 읽고,
/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/superpowers_v02_upgrade_execution.md 의 지시에 따라
jOneFlow의 superpowers 참고 개선 작업을 실제 파일 수정까지 진행해줘.
superpowers 폴더는 참고만 하고 수정하지 마.
이번 작업은 이미 정리된 workflow architecture를 기준으로 이어서 진행해줘.
```

### 2B단계 실행 요청

```text
/Users/geenya/projects/Jonelab_Platform/jOneFlow/docs/notes/2026-04-21-superpowers-attribution-handoff.md 를 먼저 읽고,
/Users/geenya/projects/Jonelab_Platform/jOneFlow/prompts/claude/superpowers_attribution_execution.md 의 지시에 따라
jOneFlow의 superpowers attribution 정리 작업을 실제 파일 수정까지 진행해줘.
공개 Git 저장소 공유를 고려해 README acknowledgment와 ATTRIBUTION.md를 보수적으로 정리해줘.
superpowers 폴더는 참고만 하고 수정하지 마.
```

---

## 운영 팁

- 가능하면 Phase 1 결과를 한 번 확인한 뒤 Phase 2로 넘어가는 것이 좋다
- Phase 2가 끝난 뒤 실제 반영 범위를 보고 Phase 2B를 실행하는 것이 attribution 품질이 가장 좋다
- 한 번에 여러 작업을 동시에 던지기보다 순차 실행이 안전하다
- 이유는 이 작업들이 모두 `README`, `CLAUDE`, `WORKFLOW`, `prompts`, attribution 문서에 영향을 줄 가능성이 높기 때문이다
- 새 Claude 계정이라면 Phase 0을 먼저 거치면 가장 안전하다
