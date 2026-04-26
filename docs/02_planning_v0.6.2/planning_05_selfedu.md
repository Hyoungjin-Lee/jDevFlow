---
version: v0.6.2
stage: 4 (plan_final)
date: 2026-04-26
mode: Standard
status: pending_operator_approval
item: 05_selfedu (jOneFlow Self-Contained 교육 구조)
revision: v3 (final)
final_at: 2026-04-26
finalized_by: 안영이 (기획팀 선임연구원)
incorporates_review: planning_review.md
revisions_absorbed: [F-EDU-D1, F-EDU-1, F-EDU-2, F-EDU-3, F-EDU-4, F-EDU-5, F-X-1]
cross_cutting_absorbed: [F-X-1, F-X-2, F-X-5, F-X-7]
---

# planning_05: jOneFlow Self-Contained 교육 구조

> **상태 배너:** ⏳ **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.

---

## Sec. 0. v2 → final 변경 요약

| ID | 위치 | 변경 요지 |
|----|------|---------|
| F-EDU-D1 (정책 commit) | Sec.1, Sec.5 AC-Edu-1 | CLAUDE.md ~80줄 슬림화 + 섹션 매핑 표. 절대 규칙 인라인 유지 (v2에서 흡수 완료) |
| F-EDU-1 | AC-Edu-4 분리 | 자동(4a: 시나리오 문서)/수동(4b: QA) (v2에서 흡수 완료) |
| F-EDU-2/D2 | Sec.8 정책 | 옵션 B: bridge_protocol.md 독립 보존, operating_manual.md는 link만 (v2에서 흡수 완료) |
| F-EDU-3/D3 | Sec.8 정책 | init_project.sh 복사 범위: operating_manual.md + bridge_protocol.md + guides/ 만 (v2에서 흡수 완료) |
| F-EDU-4 | AC-Edu-7 | R2 순서 측정 명령 verbatim 박음 (v2에서 흡수 완료) |
| F-EDU-5 | AC-Edu-2 | 6항목 grep 패턴 verbatim 박음 (v2에서 흡수 완료) |
| F-X-1 (횡단) | Sec.6 | planning_01 F-ORG-D1 통합 정책 (v2에서 흡수 완료) |
| **F-X-2 (횡단)** | Sec.9 이월 표 | bridge_protocol.md에 handoffs/ symlink 정책 추가 Stage 5 이월 |
| **F-X-5 (횡단)** | Sec.8 정책 | F-EDU-2와 동일 결정: bridge_protocol.md 독립 + operating_manual.md link. R2 순서 명시 |
| **F-X-7 (횡단)** | Sec.6 의존성 | 구현 순서 박음: 02 → 01 → **05(본 항목)** → 04 → 03 |
| **AC 자동/수동 분류** | Sec.5 전체 | AC 7개 모두 자동 측정 가능 확인 + 조건 명시 |
| **운영자 결정 게이트** | Sec. 끝 | Q1(글로벌 CLAUDE.md), Q3(bridge_protocol 통합), Q7(매뉴얼 분량) 게이트 박음 |

---

## 1. 목적

새 사용자가 jOneFlow를 가져가서 사용할 때, 백지 Claude도 프레임워크 파일만 읽으면 즉시 올바르게 동작하는 구조를 확립합니다. 메모리는 로컬 누적이며 이식 불가능하므로, **프레임워크 파일 자체가 Claude의 유일한 교육 매체**가 되어야 합니다.

**정책 결정 (F-EDU-D1):** CLAUDE.md는 ~80줄로 슬림화. 조직도/워크플로우/모델 정책 등 상세 콘텐츠는 **`docs/operating_manual.md`로 이동**. CLAUDE.md는 절대 규칙(Sec.5) + 문서 포인터만 유지. 이는 F-ORG-D1(조직도 이동)과 통합 정책.

---

## 2. 범위

### 포함 항목
- 프로젝트 루트 `CLAUDE.md` 슬림화 (~80줄): 절대 규칙 + 포인터만
- `docs/` 운영 매뉴얼 구조 정식화: 완전 자족적 운영 가이드 (이식 가능)
  - 3-tier 모델 (CEO → PM브릿지 → 팀)
  - 브릿지 운영 프로토콜 (send-keys / dispatch / Monitor / 사고 사례)
  - 비크리티컬 자율 진행 정책 + 승인 게이트 기준
  - 팀 페르소나 + 모델/effort 배정
  - 플로우별 세부 프로세스 (Stage 1~13, Lite/Standard/Strict)
  - MANDATORY STARTUP RULE
- `init_project.sh` scaffold 범위 확장: `docs/` 전체 복사 포함

### 제외 항목 (scope 보호)
- **`~/.claude/CLAUDE.md` 글로벌 영역 수정**: v0.6.2 scope 외
  - 운영자 결정 게이트에서 보류 (brainstorm Sec.9 미결 부분)
  - 본 planning에서 명시적으로 제외 기록

---

## 3. 변경 대상 파일

| 파일 | 현재 상태 | 변경 내용 |
|------|---------|---------|
| `CLAUDE.md` | ~250줄 | 슬림화 → ~80줄 (절대 규칙 + docs/ 포인터만) |
| `docs/operating_manual.md` (신규 또는 확장) | 미존재 또는 부분 | 6개 섹션 완성 (3-tier, 브릿지 프로토콜, 정책, 페르소나, Stage 플로우, startup rule) |
| `init_project.sh` | 현재 `docs/` 부분 복사 미포함 | `docs/` 전체 복사 추가 |
| `docs/01_brainstorm_v0.6.2/` | 기존 | planning_01_org 정식 조직도와 표현 통일 (조직도 5계층 반영) |

---

## 4. 단계별 작업 분해

### Phase 1: 분석 (Stage 2 plan_draft)
1. **CLAUDE.md 현황 분석**
   - Sec.1~8 구조 맵핑 (200줄 본문)
   - 슬림 후보 식별: Sec.2.5(조직도), Sec.3(워크플로우), Sec.4(모델), Sec.7(코드검증) 등
   - 절대 규칙(Sec.5) 유지 확인

2. **bridge_protocol.md 패턴 검토**
   - 영구 지침 운영 방식 (사고 사례 + 정답 구조)
   - docs/ 완전 자족 매뉴얼 예시로 활용

3. **docs/ 매뉴얼 구조 설계**
   - bridge_protocol.md와의 분리 기준 (bridge protocol vs operating manual 경계)
   - 6개 섹션 배치 (Sec.2.5 조직도, Sec.3 workflow, Sec.2.5 승인정책, Sec.2.5 페르소나, Sec.3 stage플로우, startup rule)

### Phase 2: 구현 (Stage 5 기술설계 → Stage 8 구현)
4. **CLAUDE.md 슬림**
   - ~80줄 기본틀 작성 (제목, 절대 규칙 Sec.5, docs/ 포인터 5개)
   - 수치 검증: `wc -l CLAUDE.md` ≤ 80

5. **docs/operating_manual.md 작성 또는 기존 파일 확장**
   - 6개 섹션 완성 (각 100~300줄)
   - planning_01_org와 표현 통일 (조직도 5계층)
   - Sec.7 자가 점검 7항목 등 실행 가이드 통합

6. **init_project.sh 검토 + docs/ 복사 확장**
   - scaffold 실행 시 `cp -r docs/ $NEW_PROJECT/docs/` 추가
   - .gitignore 확인 (docs/ 커밋 대상)

### Phase 3: 검증 (Stage 9 코드리뷰 → Stage 11 검증)
7. **파일 구조 정합성**
   - `docs/operating_manual.md` 링크 생존성
   - CLAUDE.md 포인터 유효성
   - init_project.sh 테스트 (신규 프로젝트 scaffold)

8. **백지 Claude 검증 시나리오**
   - 신규 프로젝트 `test_joneflow`에서 `docs/` 만 읽고 dispatch 1회 성공 시뮬레이션
   - MANDATORY STARTUP RULE 자동 준수 확인

---

## 5. Acceptance Criteria

- **AC-Edu-1**: CLAUDE.md ≤ 80줄 (수치 검증: `wc -l CLAUDE.md` ≤ 80)
  - **정책 (F-EDU-D1 매핑 표):** Sec.5 절대 규칙은 인라인 유지, 나머지 Sec.1/2/3/4/6/7/8 docs/operating_manual.md로 이동
  
| CLAUDE.md 섹션 | 라인 수(현) | 처리 |
|---------------|-----------|------|
| Sec.1 한 줄 요약 | ~10 | 유지 |
| Sec.2 도구 역할 | ~15 | 간략화 유지 |
| Sec.2.5 조직도 (F-ORG-D1) | ~73 | docs/operating_manual.md#조직도로 이동 → 5~10줄 포인터 |
| Sec.3 워크플로우 규칙 | ~80 | docs/operating_manual.md#워크플로우로 이동 → 5줄 포인터 |
| Sec.4 모델 선택 | ~30 | docs/operating_manual.md#모델 정책로 이동 |
| **Sec.5 절대 규칙** | **~20** | **유지 (보안 정책, 인라인 필수)** |
| Sec.6 스크립트 실행 | ~10 | docs/operating_manual.md로 이동 |
| Sec.7 핵심 파일 | ~10 | 유지 (간략화) |
| Sec.8 코드 검증 | ~10 | docs/operating_manual.md로 이동 |
| **합계** | **~258** | **유지: ~75줄, 이동: ~183줄 → 최종 ≤ 80줄** |

- **AC-Edu-2 (F-EDU-5 보강)**: docs/operating_manual.md가 brainstorm Sec.9 6개 항목 모두 포함. 측정:
  ```bash
  for kw in "3-tier\|3계층" "브릿지 프로토콜" "자율.*승인 게이트" "페르소나" "Stage 1.*13\|Lite.*Standard" "MANDATORY STARTUP"; do
    grep -q "$kw" docs/operating_manual.md || echo "MISS: $kw"
  done
  ``` exit 0 + 미스 0줄
  
- **AC-Edu-3 (F-EDU-3 명시)**: init_project.sh scaffold이 docs/ 복사. **정책: docs/operating_manual.md + docs/bridge_protocol.md + docs/guides/ 만 복사 (brainstorm/planning 제외)**

- **AC-Edu-4 (F-EDU-1 분리)**:
  - **AC-Edu-4a (자동):** `ls docs/guides/whitebox_verification.md` exit 0
  - **AC-Edu-4b (수동, QA):** 백지 Claude 세션에서 시나리오 실행 → dispatch 1회 PASS
  
- **AC-Edu-5**: `~/.claude/CLAUDE.md` 글로벌 영역 미수정 (scope 보호 명시)

- **AC-Edu-6**: planning_01_org 정식 5계층 + 18명과 조직도 표현 통일

- **AC-Edu-7 (F-EDU-4 보강)**: docs/ 매뉴얼이 R2 순서 명시. 측정:
  ```bash
  grep -c "R2.*순서\|읽기 순서" docs/operating_manual.md && grep -c "operating_manual" CLAUDE.md
  ``` 각 ≥ 1

---

## 6. 의존성 및 선행 작업

### 구현 순서 (F-X-7)

권장 순서: **02(license) → 01(org) → 05(본 항목) → 04(handoffs) → 03(slash)**.
본 항목은 01(조직도) 완료 후 진행. docs/operating_manual.md가 planning_01 정식 조직도를 흡수하므로 순서 필수.

- **강한 결합**: **planning_01_org** (조직도 정식 5계층 + 18명 확정이 필수, F-ORG-D1 정책)
  - 본 항목의 조직도 섹션은 planning_01_org 정식판 그대로 참조 → docs/operating_manual.md에 임베드
  - planning_01 **final 후** 본 항목 구현 필수 (순서 의존)
  
- **약한 결합**: **planning_04_handoffs** (handoffs/ 폴더 구조 이해)
  - init_project.sh에 handoffs/ 초기화 로직 추가 시 참조
  - init_project.sh `cp -r docs/` 범위 정의 (F-EDU-3)

- **정책 통합 (F-X-1 / F-X-5)**: planning_01_org F-ORG-D1 + planning_05 F-EDU-D1 **동일 단일 결정**
  - 조직도는 docs/operating_manual.md에 거주
  - CLAUDE.md Sec.2.5는 포인터로 축약
  - R2 순서: "CLAUDE.md → bridge_protocol.md → docs/operating_manual.md → handoffs/active/HANDOFF_v<X>.md"

- **참고**: **v0.6.1 bridge_protocol.md** (운영 프로토콜 모범 사례)
  - 분리 정책: 옵션 B 확정 — bridge_protocol.md 독립 보존 + operating_manual.md에서 link만 (F-EDU-2/F-X-5)

---

## 7. 리스크 분석

| ID | 리스크 | 영향 | 완화 방안 |
|----|----|------|---------|
| R1 | CLAUDE.md 슬림 시 절대 규칙 누락 | 새 프로젝트에서 보안 정책 위반 | 절대 규칙(Sec.5) 유지 필수, AC-Edu-1 수치 검증만으로 충분한지 재검토 |
| R2 | docs/ 매뉴얼 분산 시 백지 Claude 읽기 순서 혼란 | 운영자와 다른 동작 | R2 읽기 순서 명시 + MANDATORY STARTUP RULE 강화 |
| R3 | init_project.sh scaffold 복사 범위 확장 시 신규 프로젝트 sizeup | 설정 프로세스 느림 | docs/ 선택적 복사 옵션 고려 (--with-docs 플래그) |
| R4 | 글로벌 ~/.claude/CLAUDE.md 운영자 결정 무한 보류 | 제품화 막힘 | v0.6.3 이월로 명시 기록 (HANDOFF.md scope 섹션) |

---

## 8. 자율 영역 (Stage 8 구현자) & 정책 결정

**정책 (F-EDU-2, F-EDU-D2 후보):** bridge_protocol.md ↔ operating_manual.md 분리
- **옵션 A (비권장)**: bridge_protocol.md를 operating_manual.md에 통합 → 사고 학습 컨텍스트 희석
- **옵션 B (권장)**: bridge_protocol.md 독립 보존, operating_manual.md는 link만 → 정체성 유지. R2 순서: "CLAUDE.md → bridge_protocol.md → docs/operating_manual.md → handoffs/"

**정책 (F-EDU-D3):** init_project.sh `cp -r docs/` 범위
- **개선:** docs/ 전체 복사 → `docs/operating_manual.md` + `docs/bridge_protocol.md` + `docs/guides/` 만 복사
- **근거:** 신규 프로젝트는 brainstorm/planning/구현/QA 이력 불필요. self-edu 매뉴얼만 필요.
- **선택:** 또는 `docs/manual/` 폴더 신설해 매뉴얼 전용 보관

**자율 구현 영역:**
- docs/operating_manual.md의 정확한 섹션 분리 경계
- 각 섹션의 상세도 조절 (새 사용자 관점 vs 운영자 관점 균형)
- Stage 1~13 플로우 세부 기술사항 기술 방식 (flowchart vs prose vs table)
- MANDATORY STARTUP RULE의 enforcement 수준 (fail-fast vs warn)

---

## 9. 작업 일정 (예상)

| 단계 | 작업 | 예상 기간 | 담당 |
|------|------|---------|------|
| Phase 1 | 분석 | Stage 2 ~ 3 | 기획팀 |
| Phase 2 | 구현 | Stage 5 ~ 10 | 오케/팀원 |
| Phase 3 | 검증 | Stage 11 | 기획팀 검증자 |

---

## 10. 다음 산출물

- `docs/operating_manual.md` (또는 multi-file split: `docs/operating/`) 완성
  - 포함 섹션: 조직도(planning_01 정식판), 워크플로우, 모델 정책, 페르소나, Stage 1~13, startup rule
  - 링크: bridge_protocol.md (옵션 B)
  - 단일 파일 ≤ 1000줄, 초과 시 docs/manual/ 폴더로 분할 (Stage 5 결정)
- 수정 `CLAUDE.md` (~75~80줄)
  - Sec.5 절대 규칙 유지, 나머지 포인터화
  - R2 순서 명시
- 수정 `init_project.sh` (F-EDU-3)
  - `cp -r docs/operating_manual.md docs/bridge_protocol.md docs/guides/` (brainstorm/planning 제외)
- 검증 시나리오 문서 (docs/guides/whitebox_verification.md, AC-Edu-4a)

---

## 9. Stage 5 이월 표

| 이월 ID | 내용 | 담당 | 시점 |
|--------|------|------|------|
| **F-X-2** | bridge_protocol.md에 "v0.6.2부터 HANDOFF.md는 handoffs/active/를 가리키는 symlink" 한 줄 추가 | Stage 5 기술 설계 | **필수** |
| **Q7 연계** | docs/operating_manual.md 단일 파일 ≤ 1000줄 유지. 초과 시 docs/manual/ 분할 결정 | Stage 5 기술 설계 | 권장 |

---

## 운영자 결정 게이트 (Stage 4.5 필수)

> **Stage 4.5 운영자 승인 게이트 필수.** Q1, Q3 답변 전 Stage 5/8 진입 금지. Q7은 finalizer 결정 후 확인.

| Q | 결정 항목 | 권장 | 답변 |
|---|---------|------|------|
| **Q1** | 글로벌 `~/.claude/CLAUDE.md` scope 처리 — v0.6.2 포함? v0.6.3 이월? | v0.6.3 이월 또는 별건 처리. 본 v0.6.2에서 "v0.6.3 이월" 명시 박음. | **[운영자 결정 필요]** |
| **Q3** | bridge_protocol.md ↔ operating_manual.md 통합 정책 — 옵션 A(통합) vs 옵션 B(독립+link). drafter v2가 옵션 B 결정. | 옵션 B. bridge_protocol.md는 사고 학습 결과물로 정체성 강함. 독립 보존 + link 권장. | **[운영자 컨펌 필요]** |
| **Q7** | docs/operating_manual.md 권장 분량 — 단일 파일 ≤ 1000줄 vs 분할. | 단일 파일로 시작. 초과 시 Stage 5에서 docs/manual/ 분할 결정. | **finalizer 결정: 단일 파일 ≤ 1000줄** |

---

## 변경 이력

### v3 final (2026-04-26, 세션 25, 안영이 finalizer)
- 횡단 F-X-2/F-X-5/F-X-7 흡수: bridge_protocol 독립 보존 R2 순서 명시, 구현 순서 박음
- Sec.0 변경 요약 추가 (v2→final 이력표)
- 의존 그래프 수렴: 구현 순서 01→05 명시 + F-X-7 반영 (Sec.6)
- Stage 5 이월 표 신설 (Sec.9)
- 운영자 결정 게이트 박스 추가: Q1(글로벌 CLAUDE.md), Q3(bridge_protocol 통합 컨펌), Q7(finalizer 결정: 단일 파일)

### v2 (2026-04-26, 세션 25, planning_review.md 흡수)
- F-EDU-D1: CLAUDE.md ~80줄 슬림화 정책 + 섹션 매핑 표 박기 (Sec.5 절대 규칙 유지)
- F-EDU-1: AC-Edu-4 자동(시나리오 문서)/수동(QA) 분리
- F-EDU-2/F-EDU-D2: bridge_protocol.md ↔ operating_manual.md 분리 정책 (옵션 B)
- F-EDU-3/F-EDU-D3: init_project.sh `cp -r docs/` 범위 명시 (operating_manual + bridge_protocol + guides만)
- F-EDU-4: AC-Edu-7 R2 순서 측정 명령 추가
- F-EDU-5: AC-Edu-2 6항목 grep 패턴 verbatim
- F-X-1: planning_01 F-ORG-D1과 통합 정책 명시 (조직도 docs/operating_manual.md 거주)
