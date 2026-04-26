---
version: v0.6.2
stage: 4 (plan_final)
date: 2026-04-26
mode: Standard
status: pending_operator_approval
item: 02_license
author: 장그래 (기획팀 주임연구원)
revision: v3 (final)
final_at: 2026-04-26
finalized_by: 안영이 (기획팀 선임연구원)
incorporates_review: planning_review.md
revisions_absorbed: [F-LIC-1, F-LIC-2, F-LIC-3, F-LIC-4, F-LIC-5]
cross_cutting_absorbed: [F-X-6]
---

# v0.6.2 기획 파이널: Apache 2.0 라이선스 도입

> **상위 의존:** Brainstorm v0.6.2 Sec.4 (Apache 2.0 결정)
> **상태 배너:** ⏳ **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.
> **다음 단계:** Stage 4.5 운영자 승인 게이트 → Stage 8 구현

---

## Sec. 0. v2 → final 변경 요약

| ID | 위치 | 변경 요지 |
|----|------|---------|
| F-LIC-1 | AC-Lic-5 | 라인 번호 lock-in → 패턴 매칭으로 robust화 (v2에서 흡수 완료) |
| F-LIC-2 | AC-Lic-4 | MIT 잔재 grep 범위 확대: 리포 전체 (brainstorm/planning 제외) (v2에서 흡수 완료) |
| F-LIC-3 | AC-Lic-7 | README.ko.md 존재 확정 — `ls README.ko.md` exit 0 확인됨. AC-Lic-7 unconditional로 박음 |
| F-LIC-4 | AC-Lic-11 | CHANGELOG.md 갱신 강제 AC 추가 (v2에서 흡수 완료) |
| F-LIC-5 | Task 5 / 정책 | SPDX header — .py/.sh만 1줄, .md 미적용 (v2에서 흡수 완료) |
| F-X-6 (횡단) | Sec. 0 정책 | 신규 파일(.md 계열) 라이선스 헤더 미적용 정책 명시. planning_03/.04/.05 신규 .md 파일 전부 해당 |
| **AC 자동/수동 컬럼** | AC 표 전체 | 자동/수동 구분 + 측정 명령 verbatim 보강 |
| **의존 그래프** | Sec. 6 | 구현 순서 박음: 02(본 항목) → 01 → 05 → 04 → 03 |
| **운영자 결정 게이트** | Sec. 끝 | Q2(뱃지 변경), Q6(외부 fork 확인) 게이트 박음 |

---

---

## 1. 목적 및 배경

### 1.1 Apache 2.0 채택 이유

현재 jOneFlow는 MIT 라이선스로 배포되고 있습니다. v0.6.2에서 Apache License 2.0으로 전환하는 이유는 다음과 같습니다.

- **특허 방어:** Apache 2.0은 명시적인 특허 그랜트 조항을 포함하여, 기여자/사용자가 프로젝트 코드와 관련된 특허로부터 법적 보호를 받습니다. jOneFlow가 오픈소스로 공개될 때 이는 중요한 안전장치입니다.
- **오픈소스 생태 호환성:** Apache 2.0은 GPL 계열 라이선스와도 양립 가능하며, 엔터프라이즈 환경과 개인 프로젝트 양쪽에서 광범위하게 채택되어 있습니다.
- **기여자 안전:** 명확한 기여자 라이선스 협약(CLA) 구조를 뒷받침하며, 향후 다중 작성자 시나리오에서 법적 명확성을 제공합니다.
- **Jonelab 브랜드 정립:** JoneLab의 공식 오픈소스 프레임워크로서 라이선스를 정식화합니다.

### 1.2 현재 상태

| 항목 | 현황 |
|------|------|
| **루트 LICENSE 파일** | MIT 라이선스 (저자: "형진 (Hyungjin)") |
| **README.md 라이선스 섹션** | "MIT © 형진 (Hyungjin)" 표기 |
| **외부 배포/PR 이력** | 없음 (내부 개발 중) |
| **v0.6.1 이하 릴리스** | MIT 하에 배포되지 않음 확인 필요 |

---

## 2. 변경 범위

### 2.1 변경 대상 파일

#### Primary (반드시 변경)
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/LICENSE`
  - 현재 내용: MIT License 전문 (저자: "형진 (Hyungjin)", 연도: 2026)
  - 변경 후: Apache License 2.0 표준 전문 (저작권자: "Hyoungjin Lee / JoneLab", 연도: 2026)

#### Secondary (라이선스 표기 동기화)
- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/README.md`
  - 현재 Line 232: "MIT © 형진 (Hyungjin) — see [LICENSE](./LICENSE)"
  - 변경 필요 여부: YES (Apache 2.0 표기로 수정)
  - 구체 형식: "Apache License 2.0 © Hyoungjin Lee / JoneLab — see [LICENSE](./LICENSE)"

- `/Users/geenya/projects/Jonelab_Platform/jOneFlow/README.ko.md`
  - 존재 여부 확인 필요. 있는 경우 동일한 라이선스 갱신 필요.

#### Tertiary (코드 주석 검토)
- 소스 코드 파일(`src/`, `scripts/` 등)에 라이선스 명시 주석 있는지 검토
- MIT 라이선스 하단 고지(boilerplate) 제거 필요시 처리

### 2.2 변경 범위 외 (Not In Scope)

- ATTRIBUTION.md (현재 참고 형식 유지)
- LICENSE.examples/ 같은 부가 라이선스 문서는 v0.6.2 scope 외
- 기여자 라이선스 협약(CLA) 정식화는 v0.6.3 이후 검토

---

## 3. Apache 2.0 표준 전문 메타 정보

### 3.1 라이선스 전문 구조 (표준)

```
Apache License
Version 2.0, January 2004

...

Copyright [연도] [저작권자]

Licensed under the Apache License, Version 2.0 (the "License");
...
```

### 3.2 본 프로젝트에 적용할 값

| 필드 | 값 |
|------|-----|
| **License Header** | `Apache License, Version 2.0` |
| **Copyright Year** | `2026` |
| **Copyright Owner** | `Hyoungjin Lee / JoneLab` |
| **SPDX Identifier** | `Apache-2.0` |

### 3.3 Apache 2.0 전문 획득 방법 (Stage 8 구현 시)

Stage 8 구현자는 다음 중 하나를 사용합니다:
- Apache Software Foundation 공식 전문: https://www.apache.org/licenses/LICENSE-2.0.txt
- 또는 표준 SPDX 래퍼: `SPDX-License-Identifier: Apache-2.0`

---

## 4. 단계별 작업 분해

### 4.1 Stage 8 구현 작업 목록

#### Task 1: Apache 2.0 전문 준비
- [ ] Apache License 2.0 표준 전문 다운로드
- [ ] 저작권 라인 수정: `Copyright 2026 Hyoungjin Lee / JoneLab`
- [ ] 임시 파일로 검증 (라인 바꿈, 인코딩)

#### Task 2: LICENSE 파일 교체
- [ ] 기존 `/LICENSE` 백업 (선택사항, git으로 복구 가능)
- [ ] 신규 Apache 2.0 전문 파일로 교체
- [ ] 파일 인코딩 UTF-8 확인
- [ ] git diff 검토 (MIT → Apache 2.0 변경점 명확 확인)

#### Task 3: README.md 라이선스 섹션 갱신
- [ ] Line 230–232 섹션 찾기
- [ ] `MIT © 형진 (Hyungjin)` → `Apache License 2.0 © Hyoungjin Lee / JoneLab` 변경
- [ ] 링크 유지: `[LICENSE](./LICENSE)`

#### Task 4: README.ko.md 검토 및 갱신
- [ ] 파일 존재 여부 확인
- [ ] 있는 경우 동일한 라이선스 섹션 갱신 (한국어 표기)
- [ ] 표기 예시: `Apache License 2.0 © 이형진 / JoneLab`

#### Task 5: 소스 코드 주석 검토 (F-LIC-5: SPDX 정책 결정)
- [ ] 파일 헤더 라이선스 주석 검토 (예: `# License: MIT`)
- [ ] MIT 명시 boilerplate 있는 경우 Apache 2.0 제거
- [ ] **정책 (F-LIC-5): 신규 .py/.sh 파일 헤더는 `# SPDX-License-Identifier: Apache-2.0` 1줄만 (boilerplate 미사용)**
- [ ] 검색 대상: `src/`, `scripts/`, `security/`, `prompts/`

#### Task 6: Git 커밋
- [ ] Stage 2–7 통과 후 모든 변경사항 커밋
- [ ] 커밋 메시지: `feat(v0.6.2): Apache License 2.0 도입`
- [ ] 파일 명시: `LICENSE`, `README.md`, `README.ko.md` (필요 시)

---

## 5. Acceptance Criteria (AC)

| AC ID | 기준 | 측정: 자동/수동 | 측정 명령/방법 |
|-------|------|----------------|--------------|
| **AC-Lic-1** | LICENSE 첫 줄이 "Apache License" 또는 "Apache License, Version 2.0" | 자동 | `head -1 LICENSE \| grep -q "Apache License"` exit 0 |
| **AC-Lic-2** | 저작권자가 "Hyoungjin Lee / JoneLab" 명시 | 자동 | `grep -q "Copyright.*Hyoungjin Lee" LICENSE` exit 0 |
| **AC-Lic-3** | 저작권 연도가 2026 | 자동 | `grep -q "Copyright 2026" LICENSE` exit 0 |
| **AC-Lic-4** | MIT 라이선스 텍스트 잔재 0건 (리포 전체, brainstorm/planning 제외) | 자동 | `grep -irn "MIT License\|MIT ©" . --exclude-dir=.git --exclude-dir=docs/01_brainstorm* --exclude-dir=docs/02_planning*` → 0 matches |
| **AC-Lic-5** | README.md에 "Apache License 2.0" + "[LICENSE]" 링크 표기 (F-LIC-1: 패턴 매칭) | 자동 | `grep -q "Apache License 2.0.*LICENSE" README.md` exit 0 |
| **AC-Lic-6** | README.md 라이선스 섹션 링크 유지 | 자동 | `grep -q "\[LICENSE\]" README.md` exit 0 |
| **AC-Lic-7** | README.ko.md 동일 표기 (확정: 파일 존재함 — 2026-04-26 `ls README.ko.md` exit 0 확인) | 자동 | `grep -q "Apache License 2.0" README.ko.md` exit 0 |
| **AC-Lic-8** | 소스 코드에 MIT boilerplate 잔재 0건 | 자동 | `find src/ scripts/ security/ prompts/ -type f -exec grep -l "MIT License" {} \;` → 0 matches (경로 없으면 skip) |
| **AC-Lic-9** | git diff가 정확히 라이선스 관련만 포함 | 수동 | Stage 8 구현자 검증: `git diff --name-only` 에서 라이선스 무관 파일 없음 확인 |
| **AC-Lic-10** | git log에 커밋 메시지 기록 | 자동 | `git log --oneline \| grep -q "Apache\|license"` exit 0 |
| **AC-Lic-11** | CHANGELOG.md에 v0.6.2 Apache 도입 기록 (F-LIC-4) | 자동 | `grep -q "Apache" CHANGELOG.md` exit 0 |

**AC 자동/수동 분류:** 자동 9건 (AC-Lic-1~8, 10, 11) / 수동 1건 (AC-Lic-9).
AC-Lic-9는 구현자가 Stage 8 완료 직후 `git diff --name-only` 결과를 직접 검토하는 수동 단계.

---

## 6. 의존성 및 선행 조건

### 6.1 Stage 내 선행 작업
- **Stage 1** (완료): Brainstorm에서 Apache 2.0 결정 (세션 23)
- **Stage 4** (완료): 본 파이널 문서
- **Stage 4.5**: 운영자 승인 게이트 (Q2, Q6 답변 필요)
- **Stage 8**: 구현

### 6.2 외부 의존성
- **Apache Software Foundation** 공식 라이선스 텍스트
- **SPDX License List** 참고 (optional, 표준화 확인용)

### 6.3 구현 순서 (F-X-7)

본 항목은 5개 planning 중 **가장 먼저 또는 마지막** 독립 구현 가능.
권장 순서: **02(본 항목, 독립) → 01(조직도) → 05(selfedu) → 04(handoffs) → 03(slash)**.
이 순서는 의존 그래프 기준이며, 병렬 구현 시 AC-Lic 검증은 독립적으로 수행 가능.

### 6.4 횡단 정책 (F-X-6)

신규 .md 파일(`.claude/commands/<3개>.md`, `handoffs/<N개>.md`, `docs/operating_manual.md`)에는 라이선스 헤더 미적용.
SPDX 정책 (`# SPDX-License-Identifier: Apache-2.0`) 은 `.py`/`.sh` 파일에만 적용.

---

## 7. 리스크 및 완화 전략

| 리스크 | 심각도 | 설명 | 완화 전략 |
|--------|--------|------|---------|
| **R1: 기존 MIT 배포 이력 충돌** | 중 | v0.6.1 이하가 MIT로 배포된 경우 법적 모순 가능 | 배포 이력 사전 확인; 없으면 안전 |
| **R2: 외부 기여자 PR** | 저 | Apache 2.0 도입 후 외부 PR은 기여자 라이선스 동의 필요 | v0.6.2 scope 외; v0.6.3 CLA 규칙 수립 시 처리 |
| **R3: README 라이선스 섹션 누락** | 저 | README에서 라이선스 표기 누락 시 사용자 혼란 | Stage 5 기획 검증에서 체크리스트 포함 |
| **R4: 소스 파일 boilerplate 잔존** | 저 | MIT 주석이 여전히 코드에 남아있는 경우 | grep 자동 검사 포함; 부분 수정 가능 |
| **R5: 멀티라인 라이선스 텍스트 깨짐** | 저 | 파일 인코딩/라인 엔딩 문제로 가독성 손상 | UTF-8, LF 정규화 확인 |

---

## 8. 검증 전략

### 8.1 Stage 3–4 기획 검토 (Opus 리뷰어)
- AC 1–5 스펙 명확성 확인
- README 구체적 변경 라인번호 확보
- 소스 파일 검색 범위 확정

### 8.2 Stage 9 코드 리뷰 (Opus)
- Apache 2.0 전문의 표준성 확인 (Apache.org 텍스트 비교)
- 저작권자/연도 정확성
- 모든 AC 만족 여부 일괄 검증

### 8.3 Stage 11 최종 검증 (Opus, 고위험 아님 — 선택적)
- 라이선스는 정책 문제로 기술 검증 불필요
- Stage 9 리뷰 통과 시 자동 진행 가능

---

## 9. 릴리스 시 주의사항 (F-LIC-3, F-LIC-4 흡수)

- **README.ko.md 확정 (F-LIC-3):** plan_final 단계에서 운영자 확인 후 AC-Lic-7 confirm/skip 결정
- **v0.6.2 릴리스 시**: LICENSE 파일이 Apache 2.0임을 릴리스 노트에 명시
- **기존 MIT 사용자**: "v0.6.2부터 Apache 2.0으로 변경됨" 공지
- **CHANGELOG.md (AC-Lic-11, F-LIC-4)**: 라이선스 변경을 주요 변경사항으로 기록. AC-Lic-11 측정: `grep -n 'Apache' CHANGELOG.md` ≥ 1

---

## 10. 다음 단계

1. **Stage 3 (plan_review)**: 리뷰어가 상세 피드백
2. **Stage 4 (plan_final)**: 파이널 검토 + 운영자 승인
3. **Stage 5 (technical_design)**: 필요시 추가 설계 문서 (skip 가능 — 단순 작업)
4. **Stage 8 (implementation)**: 위 작업 목록 4.1 수행
5. **Stage 9 (code_review)**: Opus 전문 리뷰
6. **Stage 12–13 (QA & Release)**: 최종 검증 + 릴리스

---

## Appendix: 참고 링크

- [Apache License 2.0 공식](https://www.apache.org/licenses/LICENSE-2.0)
- [SPDX License List](https://spdx.org/licenses/Apache-2.0)
- [Brainstorm v0.6.2 Sec.4](./docs/01_brainstorm_v0.6.2/brainstorm.md)
- [현재 LICENSE 파일](./LICENSE)
- [현재 README.md](./README.md)

---

---

## 운영자 결정 게이트 (Stage 4.5 필수)

> **Stage 4.5 운영자 승인 게이트 필수.** 아래 Q2, Q6 답변 전 Stage 5/8 진입 금지.

| Q | 결정 항목 | 권장 | 답변 |
|---|---------|------|------|
| **Q2** | README.md / README.ko.md 상단 shields.io 라이선스 뱃지 변경 여부. Apache 2.0 도입 시 뱃지도 갱신? | 갱신 권장 (AC-Lic-5 포함). 뱃지 변경 시 `![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)` | **[운영자 결정 필요]** |
| **Q6** | GitHub 리포 external fork/PR 잔존 확인. fork ≥ 1이면 dual-license 또는 v0.7 이월 검토. | `ls README.ko.md` exit 0 확인 완료. GitHub network graph 확인 필요. | **[운영자 결정 필요]** |

---

## 변경 이력

### v3 final (2026-04-26, 세션 25, 안영이 finalizer)
- 횡단 F-X-6 흡수: 신규 .md 파일 라이선스 헤더 미적용 정책 명시 (Sec. 0, Sec. 6.4)
- AC 측정 가능성 마감: 자동 9건 / 수동 1건 구분 + 명령어 verbatim 추가 (Sec. 5)
- AC-Lic-7 unconditional 확정: README.ko.md 존재 확인 완료 (2026-04-26)
- 의존 그래프 수렴: 구현 순서 박음 (Sec. 6.3, F-X-7)
- 운영자 결정 게이트 박스 추가: Q2(뱃지), Q6(외부 fork)

### v2 (2026-04-26, 세션 25, planning_review.md 흡수)
- F-LIC-1: AC-Lic-5 라인 번호 lock-in → 패턴 매칭으로 robust화
- F-LIC-2: AC-Lic-4 MIT 잔재 grep 범위 확대 (리포 전체, brainstorm/planning 제외)
- F-LIC-3: AC-Lic-7 README.ko.md 존재 여부 plan_final 단계 확정
- F-LIC-4: AC-Lic-11 신규 추가 (CHANGELOG.md 갱신 강제)
- F-LIC-5: 정책 결정 — .py/.sh SPDX 1줄, markdown 미적용
