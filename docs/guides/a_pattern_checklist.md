---
version: v0.6.6
date: 2026-04-27
authored_by: 카더가든 (개발팀 백엔드 drafter, v0.6.6 의제 #6)
status: draft (drafter Round A)
---

# A 패턴 체크리스트 — drafter / reviewer / finalizer 분리 commit 헌법

> **목적:** A 패턴(drafter → reviewer 직접 수정 → finalizer 마감)에서 **3 commit 분리**를 강제하기 위한 운영 헌법 + 자체 점검 목록.
> **배경:** v0.6.5 R2에서 reviewer가 drafter 권고를 단일 commit에 묶어 처리하는 변형이 발생 → 이력 추적 곤란 + reviewer 수정 영역과 drafter 초안 영역의 경계 소실. 본 문서로 재발 방지 헌법화.
> **적용 범위:** Standard / Strict 모드 + Lite 모드 중 multi-actor 산출이 필요한 의제.

---

## 1. A 패턴 정의 (요약)

| 단계 | 담당 | 산출 | commit |
|------|------|------|--------|
| draft | drafter (예: 카더가든) | 권고 plan / 초안 코드 | 1건 |
| review | reviewer (예: 최우영) | drafter 산출 직접 수정 + 추가 분석 | 1건 |
| finalize | finalizer (예: 현봉식) | 마감 doc + handoff/CHANGELOG 갱신 | 1건 |

**핵심 원칙:** 각 단계 = **별도 commit**. 단일 commit에 두 단계 산출 묶지 않는다.

> Lite 모드에서 단순 의제(파일 1~2건)는 finalizer 단독 commit 허용 — 단, dispatch에 명시 필요.

---

## 2. Commit 분리 헌법 (필수)

### 2.1 헌법 조항

1. **drafter는 자기 영역만 commit** — reviewer/finalizer가 후속 수정할 영역을 미리 건드리지 않는다.
2. **reviewer는 drafter commit 위에 commit** — drafter SHA를 base로 시작해서 분리 commit으로 수정 사항 기록.
3. **finalizer는 reviewer commit 위에 commit** — drafter+reviewer 양 기록을 base로 마감 doc + handoff 갱신.
4. **단일 commit 묶음 금지** — "drafter+reviewer 합본" / "review 진행하면서 finalize까지" 등 변형 금지.
5. **commit 간 dependency 명시** — 각 commit body에 직전 단계 SHA 또는 의제 번호 기록.

### 2.2 위반 시 조치

- 단일 commit 발견 → reviewer/finalizer가 git revert + 분리 재작업.
- 회의창 보고 시 위반 사례 기록 (R2 변형 등).
- 반복 위반 → 다음 라운드 dispatch에 strict mode 강제 + 자체 점검 의무화.

---

## 3. Commit message 포맷 (강제)

### 3.1 표준 포맷

```
<role>(v<X.Y.Z> #<N>): <한 줄 요약>

<본문 — 상세 변경 사항 / 사전 승인 표시 / 의존 SHA>

Co-Authored-By: <model name> <noreply@anthropic.com>
```

- `<role>` ∈ {`drafter`, `reviewer`, `finalizer`}
- `<X.Y.Z>` = 현재 진행 버전 (예: `v0.6.6`)
- `<N>` = dispatch 의제 번호 (예: `#1`, `#2`, `#6`)

### 3.2 예시

```
drafter(v0.6.6 #1): R3 디렉터리 정합 — handoffs+dispatch active/archive 트리

- handoffs/active/HANDOFF_v0.6.4.md → archive/ 이동
- dispatch/archive/v0.6.X/ 신규 분리
- ...
```

```
reviewer(v0.6.6 #1): drafter 권고 검증 + dispatch/README.md 추가

- drafter SHA <hash>의 디렉토리 구조 점검 → 정합 OK
- README.md로 검색 가이드 보강
- ...
```

```
finalizer(v0.6.6 #1): R3 마감 — handoff 갱신 + CHANGELOG entry

- HANDOFF_v0.6.6.md "R3 archive 정합" 섹션 추가
- CHANGELOG.md v0.6.6 항목 갱신
- 의존: drafter <hash>, reviewer <hash>
```

---

## 4. 역할별 책임 (drafter 영역 = drafter만 / 침범 금지)

### 4.1 drafter

- **영역:** 권고 plan doc / 초안 코드 / git mv·신규 파일 등 사전 승인된 골격 작업.
- **금지:** reviewer 수정 영역(drafter 산출물 수정·재정렬) 선제 진행. finalizer 마감 doc(handoff/CHANGELOG) 작성.
- **commit body 권고:** 사전 승인 표시(예: "사전승인 반영") + 미해결/연기 항목 명시.
- **자체 점검 위치:** 본 문서 §6.1.

### 4.2 reviewer

- **영역:** drafter 산출 직접 수정 + 부족분 보강. 별도 분석 doc 추가 가능.
- **금지:** drafter commit 강제 변경(rebase로 squash 등). finalizer 마감 commit 묶음.
- **commit body 권고:** drafter SHA 명시 + 수정 사유 + 재검증 결과.
- **자체 점검 위치:** 본 문서 §6.2.

### 4.3 finalizer

- **영역:** 마감 doc(handoff/CHANGELOG/release note) + status COMPLETE 시그널.
- **금지:** drafter/reviewer 산출 재수정(이미 분리 commit으로 마감). 새로운 의제 도입.
- **commit body 권고:** 의존 commit 2개 SHA + 마감 시그널 형식 + 다음 의제 trigger 조건.
- **자체 점검 위치:** 본 문서 §6.3.

---

## 5. dispatch 템플릿 권고

### 5.1 dispatch에 포함해야 할 강제 문구

dispatch 본문 의제 섹션 하단에 다음 문구 1줄 명시 권고:

```
**Commit 분리 강제:** drafter / reviewer / finalizer 별도 commit. 단일 commit 묶음 = R2 변형 재발 = 위반.
```

### 5.2 의제별 commit 수 명시

dispatch에 의제별 예상 commit 수를 명시:

```
의제 #N (Standard A 패턴): drafter 1 + reviewer 1 + finalizer 1 = 3 commit.
의제 #M (Lite finalizer 단독): finalizer 1 commit (drafter/reviewer 생략 사유 명시).
```

### 5.3 brief 분리 권고

복잡한 의제(파일 5건 초과 / 파일 종류 3종 초과)는 dispatch 외에 brief 분리:

```
dispatch/active/v<X>/round<N>_<topic>_brief_drafter.md
dispatch/active/v<X>/round<N>_<topic>_brief_reviewer.md
dispatch/active/v<X>/round<N>_<topic>_brief_finalizer.md
```

(v0.6.3 사례 참조: `dispatch/archive/v0.6.3/2026-04-27_v0.6.3_stage8_brief_*.md`)

---

## 6. 자체 점검 체크리스트

### 6.1 drafter — 작업 시작 전

- [ ] dispatch에서 본 의제 번호 #N 와 사전승인 표시 확인했는가?
- [ ] reviewer/finalizer 영역 침범 없음을 확인했는가?
- [ ] commit message 포맷(drafter(v<X.Y.Z> #<N>): ...)을 메모했는가?
- [ ] 산출 파일 목록을 dispatch "변경 대상"에 한정했는가?
- [ ] 분량 임계(≤ 800줄 등 dispatch 명시)를 초과하지 않는가?

### 6.2 reviewer — drafter commit 받은 직후

- [ ] drafter SHA 확인 + commit message에 SHA 인용 준비됐는가?
- [ ] drafter 산출의 어느 파일을 어떻게 수정할지 정리했는가?
- [ ] drafter commit을 squash/amend하지 않고 새 commit으로 추가하는가?
- [ ] 신규 파일은 reviewer 책임 영역 한정인가? (마감 doc 침범 X)
- [ ] reviewer commit body에 재검증 결과(스모크 테스트 등) 포함했는가?

### 6.3 finalizer — reviewer commit 받은 직후

- [ ] drafter SHA + reviewer SHA 양쪽 확인했는가?
- [ ] handoff/CHANGELOG/release note 갱신 범위 정의했는가?
- [ ] 마감 시그널(📡 status COMPLETE) 송출 준비했는가?
- [ ] commit body에 의존 SHA 2건 명시했는가?
- [ ] 다음 의제 trigger 조건(병렬/순차) 명확한가?

### 6.4 PL — Round 종료 시

- [ ] 의제별 commit 수가 dispatch 예상치와 일치하는가?
- [ ] 단일 commit 묶음 변형 없는가? (`git log --oneline | grep -E "^[a-f0-9]+ (drafter|reviewer|finalizer)"` 검증)
- [ ] 위반 발견 시 즉시 회의창 보고했는가?
- [ ] CHANGELOG에 의제별 SHA 트레일 기록됐는가?

---

## 7. 참조

| 문서 | 관련 |
|------|------|
| `docs/guides/ethos_checklist.md` | Stage 시작/종료 자체 점검 (보편 윤리) |
| `docs/operating_manual.md` Sec.5 | 16-stage 플로우 + 모드별 압축 |
| `docs/bridge_protocol.md` Sec.0.1 | 16-stage 페르소나 매핑 |
| `dispatch/2026-04-27_v0.6.6_infra_standard.md` | 본 헌법 도입 dispatch (의제 #6) |

---

**드래프트 완료. reviewer는 본 문서 직접 수정으로 보강 + dispatch 템플릿 sample 추가 권고.**
