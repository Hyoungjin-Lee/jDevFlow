# Claude Handoff — superpowers Attribution and Acknowledgment

Date: 2026-04-21
Owner: Jonelab_Platform / jDevFlow
Execution owner: Claude
Related work: `2026-04-21-superpowers-analysis-handoff.md`

---

## 1. 목적

`jDevFlow`는 공개 Git 저장소로 공유될 예정이며, `superpowers`를 참고하거나 일부 구조/문구/템플릿을 차용한 부분이 있다면 이에 대한 attribution을 남길 필요가 있다.

이번 작업의 목적은:

- `superpowers`에서 영향을 받은 부분을 식별하고
- 그 영향 수준을 분류한 뒤
- 공개 배포에 적절한 출처 표기와 acknowledgment를 문서에 반영하는 것이다

중요:
- 이번 작업은 법률 자문이 아니다
- 하지만 공개 오픈소스 공유 관점에서 보수적으로 안전한 attribution을 남기는 것이 목적이다

---

## 2. 기본 판단 기준

`superpowers`는 MIT License로 공개되어 있다.

로컬 참고:
- `/Users/geenya/projects/Jonelab_Platform/jDevFlow/superpowers/LICENSE`

핵심 문구:
- copyright notice and permission notice shall be included in all copies or substantial portions

실무적으로는 아래 기준으로 분류한다.

### A. Inspiration only

예:
- 아이디어 차용
- 문제 인식 차용
- 방향성 참고

권장 대응:
- `README` acknowledgment 정도면 충분한 경우가 많다

### B. Adapted structure

예:
- 스킬 템플릿 구조
- 워크플로우 설계 패턴
- 문서 섹션 구조

권장 대응:
- `README` acknowledgment
- `ATTRIBUTION.md` 또는 `NOTICE`

### C. Includes material / close adaptation

예:
- 문구를 가깝게 변형
- 템플릿 구조를 강하게 차용
- 사실상 substantial portion으로 해석될 여지가 있는 차용

권장 대응:
- `README` acknowledgment
- `ATTRIBUTION.md` 또는 `NOTICE`
- 필요한 경우 MIT 관련 고지 포함 방향으로 보수적으로 정리

---

## 3. 이번 턴에서 Claude가 해야 할 일

### Step 1. 영향 범위 식별

아래를 먼저 확인한다.

- `README.md`
- `README.ko.md`
- `WORKFLOW.md`
- `.skills/README.md`
- 새로 추가되거나 수정된 skill/template 문서
- `docs/notes/2026-04-21-superpowers-analysis-handoff.md`
- `superpowers/README.md`
- `superpowers/skills/test-driven-development/SKILL.md`
- `superpowers/skills/writing-plans/SKILL.md`
- 필요 시 `superpowers/hooks/session-start`

그리고 아래를 정리한다.

- inspiration only
- adapted structure
- close adaptation

### Step 2. 출처 표기 전략 정리

최소한 아래를 결정한다.

- `README.md`에 어떤 acknowledgment를 넣을지
- `README.ko.md`에도 대응 문구를 넣을지
- 루트에 `ATTRIBUTION.md`를 둘지 `NOTICE`를 둘지
- 어떤 부분을 그 파일에 설명할지

기본 추천:
- `ATTRIBUTION.md` 사용
- README에는 짧은 문구
- 자세한 내용은 `ATTRIBUTION.md`로 분리

### Step 3. 실제 파일 수정

최소 산출물:
- 루트 `ATTRIBUTION.md`
- `README.md` acknowledgment 문구

권장 산출물:
- `README.ko.md` 대응 문구
- 필요 시 attribution 관련 section cross-link

### Step 4. 보수적 검토

검토 기준:
- 출처가 너무 약하지 않은가
- 반대로 실제보다 과장해 "포크"처럼 보이지는 않는가
- inspiration / adaptation / included material 구분이 균형 잡혀 있는가
- `superpowers`를 참고했지만 `jDevFlow`의 독자성도 유지되는가

---

## 4. 권장 문구 방향

여러 후보를 비교해 고르기보다, 아래 권장 카피를 기본안으로 사용한다.

상세 문안:
- `/Users/geenya/projects/Jonelab_Platform/jDevFlow/docs/notes/2026-04-21-superpowers-attribution-copy.md`

### README 짧은 문구 예시 방향

- inspired in part by ideas from `obra/superpowers`
- some workflow and skill design directions were informed by `obra/superpowers`

### ATTRIBUTION.md에 들어갈 것

- reference project name and URL
- license reference
- 어떤 부분에 영향을 받았는지
- 무엇은 inspiration이고 무엇은 adapted structure인지
- `jDevFlow`는 독자적인 플랫폼/템플릿 목표를 가진다는 점

중요:
- "copied"처럼 불필요하게 공격적인 표현은 피하되
- 실제로 차용한 부분은 숨기지 않는다

---

## 5. 절대 원칙

- `superpowers`의 독창 기여를 숨기지 않는다
- 실제보다 과장해서 종속 프로젝트처럼 보이게 만들지 않는다
- 법률 판단을 단정하지 않는다
- 공개 저장소에서 읽었을 때 충분히 성실한 attribution이 되도록 한다

---

## 6. 완료 정의

아래가 만족되면 완료다.

- `README.md`에 acknowledgment가 있다
- 루트에 `ATTRIBUTION.md`가 있다
- 실제 영향 범위가 문서화되어 있다
- 공개 Git 공유 시 출처 관련 불안이 줄어든다
