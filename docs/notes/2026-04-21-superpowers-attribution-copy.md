# Recommended Attribution Copy — superpowers Reference

Date: 2026-04-21
Purpose: Claude가 그대로 또는 거의 그대로 사용할 수 있는 권장 attribution 문구 모음

---

## 1. 권장 방침

이번 프로젝트에서는 여러 후보 중 하나를 고르기보다, 아래 문구를 기본 권장안으로 사용한다.

선정 기준:
- 과장되지 않음
- 출처를 숨기지 않음
- `jOneFlow`의 독자성을 유지함
- 공개 Git 저장소에서 자연스럽게 읽힘
- `README`에는 짧게, `ATTRIBUTION.md`에는 구체적으로 정리 가능함

---

## 2. README.md 권장 문구

권장 위치:
- `Acknowledgments`
- 또는 `Credits`
- 또는 `References`

권장 문구:

```markdown
## Acknowledgments

jOneFlow was developed independently as part of Jonelab_Platform. Some workflow, skill-system, and agent-operating design directions were informed by ideas explored in [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent and contributors. Where jOneFlow adapts concepts inspired by that work, we acknowledge superpowers as an important reference. See [ATTRIBUTION.md](./ATTRIBUTION.md) for details.
```

문체 의도:
- "developed independently"로 독자성 유지
- "informed by ideas"로 아이디어/구조 영향 인정
- "adapts concepts inspired by that work"로 구조적 차용 가능성도 숨기지 않음
- 상세 내용은 `ATTRIBUTION.md`로 분리

---

## 3. README.ko.md 권장 문구

권장 위치:
- `감사의 말`
- 또는 `참고 및 출처`

권장 문구:

```markdown
## 감사의 말

jOneFlow는 Jonelab_Platform의 일부로 독립적으로 설계되었지만, 워크플로우 구조, 스킬 시스템, 에이전트 운영 방식의 일부 방향은 Jesse Vincent와 contributors의 [obra/superpowers](https://github.com/obra/superpowers) 프로젝트에서 다뤄진 아이디어를 참고했습니다. jOneFlow가 그 작업에서 영감을 받은 개념을 재해석해 반영한 부분에 대해서는 superpowers를 중요한 참고 프로젝트로 표기합니다. 자세한 내용은 [ATTRIBUTION.md](./ATTRIBUTION.md)를 참고하세요.
```

문체 의도:
- "독립적으로 설계"로 자율성 유지
- "참고했습니다"로 영향 인정
- "재해석해 반영"으로 그대로 복제했다는 인상은 피함

---

## 4. ATTRIBUTION.md 권장 문안

아래 문안을 기본 초안으로 사용한다.

```markdown
# Attribution

jOneFlow is part of Jonelab_Platform and was developed as an independent workflow template and platform direction for AI-assisted software development.

## Reference Project

This project was informed in part by ideas explored in [obra/superpowers](https://github.com/obra/superpowers), created by Jesse Vincent and contributors.

- Repository: https://github.com/obra/superpowers
- License: MIT

## Nature of Influence

The superpowers project influenced parts of jOneFlow primarily at the level of workflow thinking, skill design direction, and agent-operating discipline.

Areas that may reflect that influence include:

- workflow and stage-structure refinement
- skill-template and instruction-shaping patterns
- session bootstrap and operating-guide ideas
- evaluation-oriented workflow improvement practices

In jOneFlow, these ideas were adapted and reinterpreted to support a different goal: a document-centric, bilingual, handoff-friendly workflow platform with stronger project-state continuity and built-in secure-secret guidance.

## Attribution Intent

This file exists to acknowledge that jOneFlow did not emerge in isolation. Where this project adopts or adapts concepts inspired by superpowers, we want to credit that influence clearly and respectfully.

This attribution is provided as a good-faith, conservative open-source practice for public sharing. It should not be read as claiming that jOneFlow is a fork of superpowers or that all design elements originate there.
```

---

## 5. 더 보수적인 버전이 필요할 때 추가 가능한 문장

Claude가 실제 차용 수준을 더 높게 판단하면, `ATTRIBUTION.md`에 아래 문장을 추가할 수 있다.

```markdown
Some structural patterns and template conventions in this repository were adapted after reviewing superpowers materials. Where such adaptations are close enough to merit explicit acknowledgment, this file serves as that notice.
```

이 문장은:
- substantial portion 여부가 애매할 때
- 구조 차용을 더 명확히 인정하고 싶을 때
- 그러나 여전히 포크처럼 보이게 만들고 싶지 않을 때
유용하다.

---

## 6. Claude 작업 원칙

Claude는 attribution 작업 시 여러 후보를 제시하기보다, 위 권장안을 기본으로 사용하라.

단, 실제 반영 범위를 보고 아래는 조정 가능하다.
- influenced -> informed in part by
- adapted -> reinterpreted
- Areas that may reflect that influence 목록

하지만 기본 톤은 유지한다:
- 성실함
- 절제
- 독자성 유지
