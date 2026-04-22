# Claude Handoff — superpowers 분석 기반 jOneFlow v0.2 개선

Date: 2026-04-21
Owner: Jonelab_Platform / jOneFlow
Execution owner: Claude
Reference-only source: `superpowers/`

---

## 1. 목적

`superpowers`를 분석한 결과를 바탕으로, `jOneFlow`에 실제로 흡수할 가치가 있는 요소를 선별 반영한다.

이번 작업의 목표는 `superpowers`를 복제하는 것이 아니라, 아래 두 가지를 동시에 만족시키는 것이다.

1. `superpowers`의 강점인 자동화, 스킬 정교함, 실행 규율, 평가 체계를 일부 흡수한다.
2. `jOneFlow`의 강점인 문서 중심 운영, `HANDOFF.md` 기반 세션 지속성, 보안, 비개발자 친화성, EN/KO 지원은 유지한다.

---

## 2. 절대 원칙

- `jOneFlow/superpowers/` 폴더는 참고 자료다. 수정하지 않는다.
- 이번 작업은 `jOneFlow` 템플릿 자체를 개선하는 작업이다.
- `superpowers`의 실행 철학을 그대로 이식하지 말고, `jOneFlow`의 운영 철학 위에 얹는다.
- 비개발자도 계속 사용할 수 있어야 한다.
- 문서 중심 플로우는 유지한다.
- 구현이 불안정한 자동화는 섣불리 넣지 않는다.
- 런타임/플랫폼 종속성이 강한 기능은 "기본값"이 아니라 "선택형" 또는 "hook-ready" 구조로 설계한다.
- EN/KO 문서가 어긋나지 않도록 함께 갱신한다.
- `superpowers`에서 아이디어 이상을 실질적으로 차용한 부분은 출처/attribution을 남긴다.
- `superpowers`는 MIT License이므로, substantial portion으로 볼 여지가 있는 차용에는 보수적으로 attribution과 관련 고지를 남기는 방향으로 정리한다.
- 법률 자문처럼 단정하지 말고, 공개 Git 공유에 안전한 보수적 오픈소스 관행을 따른다.

---

## 3. 이번 작업에서 반영해야 할 핵심 범위

### A. Session bootstrap 구조 강화

현재 `jOneFlow`는 사용자가 매 세션 시작 시 수동으로 `CLAUDE.md`, `HANDOFF.md`를 읽어 달라고 요청해야 한다.

개선 목표:
- `CLAUDE.md -> HANDOFF.md -> WORKFLOW.md -> current docs/` 읽기 흐름을 더 강하게 구조화
- 자동화가 가능하면 hook-ready 구조로 정리
- 실제 환경마다 훅 동작이 다를 수 있으므로, 무리한 강제 구현보다 "도입 가능한 구조 + 명확한 안내"를 우선

필수 산출물:
- 세션 시작 방식에 대한 명확한 설계 문서 또는 템플릿 반영
- README / CLAUDE / WORKFLOW / HANDOFF 간 역할 경계 정리
- 사용자가 세션을 시작할 때 따라야 할 표준 진입점 정리

### B. `.skills` 체계 개선

현재 `.skills/README.md`는 커스텀 스킬 작성 가이드 성격이 강하고, 실제 행동 통제력은 약하다.

개선 목표:
- 단순 참고형이 아니라 행동 유도형 스킬 구조로 강화
- 스킬 템플릿에 아래 요소 반영
  - `When to Use`
  - `Do / Don't`
  - `Red Flags`
  - `Good / Bad`
  - `Checklist`
  - `Verification`
- 최소 1개 이상의 예시 스킬 또는 템플릿 제공

### C. Stage 2~5 planning / design 템플릿 강화

현재 프롬프트 템플릿은 방향은 좋지만 task granularity와 실행 정밀도가 아직 약하다.

개선 목표:
- exact file path
- in scope / out of scope
- acceptance criteria
- test strategy
- implementation constraints
- Codex handoff quality

우선 검토 대상:
- `prompts/claude/planning_draft.md`
- `prompts/claude/planning_review.md`
- `prompts/claude/planning_final.md`
- `prompts/claude/technical_design.md`
- 필요 시 `ui_requirements.md`, `ui_flow.md`

### D. Workflow eval 최소 세트 설계

현재 `jOneFlow`는 문서와 프롬프트는 있지만, "에이전트가 실제로 이 지침을 따르는지"를 검증하는 구조가 없다.

개선 목표:
- 최소한의 workflow eval 설계 추가
- 문서형이어도 좋고, 테스트 scaffold여도 좋다
- 목적은 "이 템플릿이 실제로 행동을 바꾸는지" 검증 가능한 출발점 만들기

권장 방향:
- `docs/notes/` 아래 평가 설계 문서
- 또는 `tests/` 아래 lightweight eval scaffold

### E. 보안 / 온보딩 메시지 정리

현재 README는 실제 시크릿을 `.env`에 저장하지 말라고 말하지만, `scripts/init_project.sh`는 `.env.example`을 `.env`로 복사한다.

이건 기능적으로 큰 문제는 아닐 수 있지만, 초보 사용자에게 메시지가 혼란스러울 수 있다.

개선 목표:
- `.env.example`의 의미를 분명히 설명
- `.env`의 용도를 재정의하거나, 필요 시 흐름을 정리
- `secret_loader.py` 중심 철학과 README / 스크립트가 일관되게 보이도록 수정

### F. EN/KO 일관성 정리

이번에 수정되는 사용자-facing 문서는 가능한 한 영어/한국어 둘 다 맞춘다.

최소 대상:
- `README.md`
- `README.ko.md`
- `CLAUDE.md` 내 양언어 섹션
- 필요 시 새로 추가하는 문서/템플릿

### G. Attribution / 출처 표기 정리

이번 작업은 `superpowers`를 실질적으로 참고해 구조/문구/템플릿/운영 철학 일부를 흡수하는 작업이므로, 공개 Git 공유를 고려하면 attribution 전략을 함께 정리해야 한다.

개선 목표:
- 어떤 부분이 단순 inspiration인지
- 어떤 부분이 adapted structure인지
- 어떤 부분이 실제 문구/구조 차용인지
- 그에 따라 어디에 어떤 수준의 출처 표기를 남길지 정리

최소 권장 산출물:
- `README.md`에 짧은 acknowledgment 또는 inspiration 문구
- 루트 `ATTRIBUTION.md` 또는 `NOTICE` 계열 파일 초안
- 필요 시 `README.ko.md`에도 대응 문구

판단 기준:
- 아이디어만 참고했어도 공개 프로젝트라면 출처 표기는 권장
- 구조/문구/템플릿 차용이 있다면 attribution은 사실상 필수에 가깝게 보수적으로 처리

---

## 4. superpowers 대비 핵심 판단 요약

### superpowers가 더 강한 점

- SessionStart hook 기반 자동 bootstrap
- 스킬의 행동 통제력
- TDD / plan / review 규율의 디테일
- worktree / subagent / review gate 체계
- skill eval / integration test 존재
- 멀티 하네스 배포 성숙도

### jOneFlow가 더 강한 점

- `HANDOFF.md` 기반 세션 지속성
- 문서 중심 single source of truth
- OS secure store 기반 보안 구조
- 비개발자 친화성
- EN/KO 이중 언어

### 전략적 결론

`superpowers`의 "자동 실행성과 규율"을 흡수하되, `jOneFlow`의 "사람 중심 운영 구조"를 깨지 않는 것이 핵심이다.

---

## 5. 변경 우선순위

### P0

- Session bootstrap 구조 정리
- `.skills` 행동 유도형 템플릿 정의
- 보안/온보딩 메시지 정리

### P1

- Stage 2~5 문서 템플릿 강화
- 최소 eval 설계 추가
- README / README.ko / CLAUDE 정합성 정리
- attribution / acknowledgment 초안 정리

### P2

- 선택형 advanced mode 설계
  - worktree mode
  - review gate mode
  - hook-ready mode

### P3

- 장기적으로 plugin/package 방식 배포 검토
- Claude/Codex handoff 자동화 고도화

---

## 6. Claude가 이번 턴에서 해야 할 일

### Step 1. 현 상태 재확인

아래 파일을 먼저 읽고, 실제 반영 범위를 구체화한다.

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

### Step 2. 반영 설계 확정

아래를 먼저 짧게 정리한다.

- 무엇을 필수 반영할지
- 무엇을 선택형으로 둘지
- 무엇은 이번에 보류할지
- 어떤 파일을 수정/추가할지

### Step 3. 실제 수정

반드시 실제 파일 수정까지 수행한다.

기대 작업 유형:
- 기존 템플릿 문서 개선
- 새 템플릿 문서/예시/스킬 샘플 추가
- 필요 시 eval scaffold 또는 설계 문서 추가

### Step 4. 검토

수정 후 아래를 검토한다.

- 문서끼리 메시지가 충돌하지 않는지
- EN/KO가 어긋나지 않는지
- 초보 사용자에게 지나치게 복잡해지지 않았는지
- `superpowers` 영향이 과도하게 드러나지 않는지
- `superpowers/` 폴더를 건드리지 않았는지
- 공개 Git 공유를 고려했을 때 attribution이 충분한지

### Step 5. 결과 정리

최종 응답에는 아래를 포함한다.

- 변경한 파일 목록
- 각 파일의 변경 이유
- 새로 도입된 구조
- attribution이 필요한 부분과 실제로 남긴 표기
- 후속 권장 작업
- 남은 리스크 / 보류 항목

---

## 7. 권장 수정 대상 파일

아래는 권장안이며, Claude가 읽어보고 더 적절한 구성이 있으면 조정 가능하다.

### 수정 권장

- `README.md`
- `README.ko.md`
- `CLAUDE.md`
- `WORKFLOW.md`
- `.skills/README.md`
- `scripts/init_project.sh`
- `prompts/claude/planning_draft.md`
- `prompts/claude/planning_review.md`
- `prompts/claude/planning_final.md`
- `prompts/claude/technical_design.md`
- 필요 시 `prompts/claude/ui_requirements.md`
- 필요 시 `prompts/claude/ui_flow.md`

### 추가 권장

- `.skills/_templates/behavioral-skill-template/SKILL.md`
- `.skills/examples/` 아래 샘플 스킬 1~2개
- `docs/notes/workflow_eval_plan.md`
- 필요 시 session bootstrap 관련 문서
- `ATTRIBUTION.md` 또는 `NOTICE` 계열 파일

---

## 8. 리스크와 판단 기준

### 리스크 1. 과도한 복잡성

`superpowers` 방식은 강력하지만 초보자에게는 과할 수 있다.

판단 기준:
- 기본 플로우는 단순해야 한다.
- 고급 기능은 선택형이어야 한다.

### 리스크 2. 플랫폼 종속 훅 구현

세션 자동화는 매력적이지만 환경 종속성이 강할 수 있다.

판단 기준:
- 불안정한 자동 훅보다, 안정적인 hook-ready 구조 + 문서 안내가 낫다.

### 리스크 3. 문서와 스크립트 간 메시지 충돌

보안/온보딩/세션 시작 관련 안내는 작은 차이도 혼란을 만든다.

판단 기준:
- README, CLAUDE, WORKFLOW, script 출력 메시지가 같은 철학을 말해야 한다.

### 리스크 4. template vs project-state 혼선

`HANDOFF.md`는 템플릿용이다. 이번 분석 인수인계를 위해 기존 템플릿을 오염시키면 안 된다.

판단 기준:
- 분석/개선용 기록은 별도 문서로 둔다.

---

## 9. 완료 정의

아래가 만족되면 이번 작업은 완료로 본다.

- `jOneFlow`가 `superpowers` 분석 결과를 반영한 v0.2 방향으로 더 선명해졌다.
- 세션 시작, 스킬 구조, planning template, eval, 보안 메시지가 모두 이전보다 정교해졌다.
- 문서 중심 운영 철학은 유지됐다.
- 비개발자 친화성은 유지됐다.
- EN/KO 정합성이 무너지지 않았다.
- `superpowers/`는 수정하지 않았다.

---

## 10. Claude에게 넘길 때 한 줄 요약

`superpowers`의 자동화와 규율은 일부 흡수하되, `jOneFlow`의 문서 중심 운영, HANDOFF 세션 지속성, 보안, 비개발자 친화성은 유지하는 방향으로 v0.2 개선을 실제 파일 수정까지 진행해줘.
