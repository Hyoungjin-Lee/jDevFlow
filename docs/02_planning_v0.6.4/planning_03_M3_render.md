---
version: v0.6.4
stage: 4 (plan_final)
date: 2026-04-27
mode: Strict
status: pending_operator_approval
item: 03_M3_render
revision: v3 (final)
draft_by: 장그래 (기획팀 주임연구원, Haiku) — v1 초안 + v2 review 흡수
finalized_by: 안영이 (기획팀 선임연구원, Sonnet/medium)
final_at: 2026-04-27
upstream:
  - docs/01_brainstorm_v0.6.4/brainstorm.md (의제 8 마일스톤 M3, 의제 4 표시 항목)
  - dispatch/2026-04-27_v0.6.4_stage234_planning.md
  - docs/02_planning_v0.6.4/planning_review.md (김민교 reviewer)
incorporates_review: docs/02_planning_v0.6.4/planning_review.md
incorporates_v2: 장그래 drafter v2 (revised, 세션 27 후속)
revisions_absorbed:
  - F-M3-1 (Sec.3.1 모듈 위치 `scripts/dashboard/...` — F-D2 후보 반영)
  - F-M3-2 (Sec.5 AC 표 자동/수동 컬럼 + 자동화 명령 박음)
  - F-M3-3 (Sec.4.2 토큰 형식 subsection 분리 — 표시 형식 vs 모델별 참고치)
  - F-M3-4 (Sec.4.3 prefix `└/▸` 사용 — brainstorm 의제 3 호환)
  - F-M3-5 (Sec.6.3 디자인팀 dispatch 시점 정정 — Stage 5 완료 + Stage 6 시그널 후)
  - F-X-7-#2 (Q-M3-4 흡수 → F-D2: `scripts/dashboard/...`)
  - F-X-7-#4 (Q-M3-1 → 페르소나명 고정 권장)
  - F-X-7-#6 (Sec.4.4 빈 박스 → A: 팀명 + "대기 중" 권장)
  - F-M3-S5-1 (Stage 5 이월 유지, F-M3-1 책임자 분리)
cross_cutting_absorbed:
  - F-D1 (정책 commit 본문 박음 — TeamRenderer가 PersonaState 직접 소비, M2 dataclass 단일 spec)
  - F-D2 (정책 commit 본문 박음 — M3 위치 = `scripts/dashboard/team_renderer.py` + `scripts/dashboard/models.py`)
  - F-X-1 (F-D1로 흡수 — M3 TeamRenderer 입력 시그니처)
  - F-X-2 (read-only 정책 5개 doc 표준 — AC-M3-9 박힘)
  - F-X-3 (Stage 5 이월 통합 표 → planning_index.md 단일 source of truth, 본 doc Sec.10은 스냅샷 유지)
  - F-X-7-#2 (drafter 자율 영역 미회수 — 모듈 위치 F-D2 흡수)
  - F-X-7-#4 (drafter 자율 영역 미회수 — 페르소나명 고정 정렬)
  - F-X-7-#6 (drafter 자율 영역 미회수 — 빈 박스 옵션 A)
---

# v0.6.4 M3 기획 — 박스 3개 + 행 렌더링 + 다중 버전 동시 표시

> **상위:** `docs/01_brainstorm_v0.6.4/brainstorm.md` Sec.3 의제 8 (마일스톤 M3)
> **본 문서:** Stage 4 plan_final v3 (finalizer 안영이, 운영자 승인 대기 — Stage 4.5 게이트)
> **범위:** M3 = 박스 3개(기획/디자인/개발) + 행 기반 렌더링 + 다중 버전 동시 표시 구조 정의
> **다음:** Stage 4.5 운영자 승인 게이트 → 박지영 PL planning_index.md 통합 → Stage 5 기술 설계 (M3 색상 토큰 정의) → Stage 6 디자인팀 첫 등판

> **v3 갱신 범위 (finalizer 안영이):** v2(장그래 drafter) 위에 정책 commit 본문 결정 문장(F-D1 / F-D2) + 횡단 흡수 추가 분(F-X-2 / F-X-3 / F-X-7-#2/#4/#6)을 박았습니다. F-D 본문 결정은 reviewer 권장(planning_review.md Sec.8) verbatim으로 흡수했으며, finalizer 임의 결정 영역이 아닙니다.

---

## Sec. 0. M3 개요 및 위치 (v3 final 갱신)

### Sec. 0.0 v3 final 변경 요약 (finalizer 흡수)

본 v3는 v2(장그래 drafter, Stage 3 review 흡수 10건) 위에 finalizer 안영이가 정책 commit 본문 결정 + 횡단 흡수를 추가한 final 산출물입니다.

| ID | 유형 | 위치 | 변경 요지 (drafter v2 → finalizer v3) |
|----|------|------|----------------------------------|
| F-M3-1 | 명시 추가 (v2 흡수 유지) | Sec.3.1 | `scripts/dashboard/team_renderer.py` + `models.py`. v3 finalizer가 F-D2 본문 결정으로 승격. |
| F-M3-2 | 명시 추가 (v2 흡수 유지) | Sec.5 AC 표 | 자동/수동 컬럼 + AC-M3-2/5/8 자동화. v3 변경 없음. |
| F-M3-3 | 명시 추가 (v2 흡수 유지) | Sec.4.2 | 토큰 형식 subsection 분리. v3 변경 없음. |
| F-M3-4 | 명시 추가 (v2 흡수 유지) | Sec.4.3 | sub-row prefix `└`. v3 변경 없음. |
| F-M3-5 | 명시 추가 (v2 흡수 유지) | Sec.6.3 | 디자인팀 dispatch 시점 정정. v3 변경 없음. |
| **F-D1** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.6.1 + 첨부 의사 코드** | **TeamRenderer가 M2 `PersonaState`를 직접 소비** — `render()` 입력 = `Dict[str, List[PersonaState]]`. v1의 별도 `TeamMember` dataclass 영구 회수. |
| **F-D2** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.3 머리말 + Sec.3.1** | **M3 위치를 `scripts/dashboard/team_renderer.py` + `scripts/dashboard/models.py`로 본문 박음** (M2 dataclass 재사용 시 `models.py` 자체 회수 가능 영역). |
| F-X-1 | F-D1로 흡수 (v3) | Sec.6.1 본문 결정 | M3 TeamRenderer 입력 시그니처 — F-D1 본문에서 닫힘. |
| F-X-2 | 횡단 흡수 (v2) | Sec.2.3 + AC-M3-9 | read-only 정책 명시 + AC-M3-9 자동 검증. v3 변경 없음. |
| F-X-3 | 횡단 흡수 (v3 finalizer) | Sec.10 머리말 | Stage 5 이월 통합 표 단일 source of truth = planning_index.md (박지영 PL 영역). 본 doc Sec.10은 M3 스냅샷 유지. |
| F-X-7-#2 | 자율 영역 (v2 흡수 유지, F-D2로 닫힘) | Sec.3.1 / Q-M3-4 | 모듈 위치 — F-D2 본문 결정으로 닫힘. |
| F-X-7-#4 | 자율 영역 (v2 흡수 유지) | Sec.4.3 / Q-M3-1 | 페르소나명 고정 정렬. v3 변경 없음. |
| F-X-7-#6 | 자율 영역 (v2 흡수 유지) | Sec.4.4 / Q-M3-3 | 빈 박스 옵션 A. v3 변경 없음. |

> **finalizer 흡수 결과:** 본 v3는 drafter 권한 밖 정책 commit 2건(F-D1 / F-D2)을 본문 결정 문장으로 닫고, 횡단 영역 1건(F-X-3)을 planning_index 포인터로 정리했습니다. 본 stage 잔존 운영자 결정 = 없음 (M3 영역 운영자 결정 게이트는 색상 팔레트 = Stage 6/7 디자인팀 영역). Stage 5 잔존 = Q-M3-2(다중 버전 ≥3개 생략 정책).

### 0.1 마일스톤 체인에서의 M3

| M | 내용 | 의존 | 담당 |
|---|------|------|------|
| M1 | `/dashboard` 슬래시 커맨드 + textual scaffold | — | 개발팀 |
| M2 | 데이터 수집 layer (capture-pane 파싱 / 토큰량 / working·idle 추론) | M1 | 개발팀 |
| **M3** | **박스 3개 + 행 렌더링 + 다중 버전 동시 표시** | **M1, M2** | **개발팀 + 디자인팀 병렬** |
| M4 | Pending Push·Q 박스 + macOS 알림 | M2 | 개발팀 |
| M5 | Windows 호환 검증 + 18명 페르소나 매핑 적용 | M3, M4 | 개발팀 |

### 0.2 M3의 범위

M3는 **시각화 골격(layout skeleton)**에 집중합니다. 색상, CSS-like 스타일 디테일, 진행률 바, 스파크라인 등은 Stage 5(기술 설계) 또는 Stage 6/7(디자인팀 첫 등판)로 이월합니다.

**M3 핵심:**
- Textual 레이아웃: 가로 3등분 박스(기획/디자인/개발 팀)
- 각 박스 내 행 기반 표시: 페르소나 + 상태 + 작업명 + 토큰량
- 다중 버전 동시: 동일 페르소나가 여러 버전을 다루면 행 N개

**M3 외 영역 (Stage 5/6/7):**
- 색상 팔레트(primary/warning/danger 정의)
- 진행률 바(progress=working/idle 시각화)
- 스파크라인(토큰 사용 추세)
- textual CSS-like 스타일링 디테일(margins, padding, borders)
- 6~9행 동시 가독성 visual 검증 시나리오
- 디자인팀(Orc-064-design) UI 결과 반영 절차

---

## Sec. 1. 목적 (Purpose)

운영자 대시보드는 **운영자의 의사결정을 돕는 실시간 정보 가시화**가 목표입니다. M3는 이 중 **팀별 작업 상태 핵심 영역**을 정의합니다.

운영자가 `/dashboard` 호출 시:
1. **즉시 직관적으로** 기획/디자인/개발 3팀의 현재 상태를 파악
2. **각 팀 내 누가 일하고 있는지** (페르소나 + working/idle 상태)
3. **무엇을 하고 있는지** (버전/과제명)
4. **비용(토큰량)이 얼마나 드는지** 한눈에 인지

이를 위해 **3개 박스 × N개 행**의 규칙적 레이아웃이 필요합니다.

---

## Sec. 2. 범위 (Scope)

### 2.1 M3가 정의하는 것

| 항목 | 정의 대상 | 세부 |
|------|---------|------|
| **레이아웃 구조** | 가로 3등분 박스 (기획/디자인/개발) | 박스 경계, 너비, 정렬 방식 (flex, grid 등) |
| **행 형식** | 각 박스 내 행 N개 | 페르소나명 + 상태 기호 + 작업명 + 토큰량 형식 |
| **상태 표시** | working(◉) / idle(○) 2단계 | 기호, 위치, 의미 |
| **다중 버전 표시** | 동일 페르소나 × 다중 버전 시 행 분할 | 행 수 제한, 구분 정책 (들여쓰기 vs prefix) |
| **빈 박스 처리** | 팀에 활성 인원 0일 때 | "팀명만 표시" vs "팀 비활성 표기" |
| **너비/높이 제약** | 6~9행 동시 가독성 목표 | 행당 약 50~70 글자 기준(textual line width) |

### 2.2 M3가 정의하지 않는 것 (이월)

| 항목 | 이월 대상 | 시점 |
|-----|---------|------|
| **색상 팔레트** | CSS color tokens (primary, warning, danger) | Stage 5 기술 설계 또는 Stage 6/7 디자인팀 |
| **스타일 디테일** | margins, padding, border styles, 글꼴 | Stage 6/7 디자인팀 (Orc-064-design) |
| **진행률 바** | working 비율 시각화 (progress bar) | Stage 5/6 |
| **스파크라인** | 토큰 사용 추세 차트 | Stage 5/6 |
| **6~9행 visual 검증** | 실제 화면에서 텍스트 줄바꿈/가독성 테스트 | Stage 5 기술 설계 |

### 2.3 read-only 정책 (brainstorm 의제 5 영구 적용 — v2 F-X-2 흡수)

> **v2:** M3 렌더링 layer는 brainstorm 의제 5의 read-only 정책을 영구 적용합니다. TeamRenderer / 박스 / 행 렌더링 어디서도 git push / git commit / 파일 write 명령이 발생해서는 안 되며, write 영역 진입 신호 발견 시 즉시 Stage 4 review 회귀 대상이 됩니다. 자동 검증은 AC-M3-9 신규 항목(M4 AC-M4-N9 패턴 인용).

---

## Sec. 3. 변경 대상 파일

> **v3 finalizer (F-D2 정책 commit 본문 결정):** 본 M3 산출물 위치는 다음과 같이 단일화합니다.
> 1. **렌더링 모듈:** `scripts/dashboard/team_renderer.py` — M3 `TeamRenderer` 클래스 본체.
> 2. **데이터 모델:** `scripts/dashboard/models.py` — M2 `PersonaState` dataclass 정의 위치(M2 산출과 단일 spec). M2 dataclass를 직접 재사용하는 구조라 본 파일은 M2가 선 정의하면 M3에서 import만 (자체 dataclass 정의 회수).
> 3. **호출 위치:** `scripts/dashboard.py` (M1 진입점)의 `compose()` 메서드에서 `TeamRenderer` 호출.
>
> 본 결정으로 v1의 `src/dashboard/components/...` / `src/dashboard/render/...` 후보 + `dashboard/...` 후보(M4 v1)를 모두 닫고 M1/M3/M4 위치 일관성을 확보합니다. 본 결정은 reviewer 권장(planning_review.md F-D2, F-M3-1) verbatim 흡수입니다.

### 3.1 신규 생성 (v3 F-D2 본문 결정 박음 — `scripts/dashboard/...`)

| 파일 | 역할 | 예상 크기 |
|------|------|---------|
| `scripts/dashboard/team_renderer.py` | M3 렌더링 모듈 (`TeamRenderer` 클래스) | ~150줄 |
| `scripts/dashboard/models.py` (M2와 단일 정의) | **v3 F-D1 흡수:** M2 `PersonaState` dataclass 정의 위치. M3는 import만. v1의 별도 `TeamMember` dataclass 영구 회수. | ~30줄 또는 회수 |

### 3.2 기존 파일 참조/의존

| 파일 | 역할 | 선택 사항 |
|------|------|---------|
| `scripts/dashboard.py` | M3 renderer 호출 위치 (M1 scaffold에서 정의, F-D2 후보) | M1 final에서 확정 |
| `docs/03_design/v0.6.4_M3_layout.md` | 기술 설계 문서(Stage 5) | M3 본 draft 완료 후 Stage 5에서 작성 |

---

## Sec. 4. 단계별 작업 분해

### 4.1 부분 ① — 박스 3개 구조 정의

**목표:** 가로 3등분 박스의 너비, 정렬, 경계선 정의

| 작업 | 세부 | 산출 |
|------|------|------|
| 레이아웃 모드 선택 | Horizontal (3 칼럼) vs Grid (2×2) | textual.containers.Horizontal 사용 선택 |
| 박스 너비 결정 | 1:1:1 등분 (가변) vs 고정 픽셀 | 동일 너비 권장 (각 팀 동등 시각화) |
| 박스 테두리 정의 | ASCII 박스(━ ┃ ┗ ┓ 등) vs textual border | textual.widgets.Static border="solid" 권장 |
| 박스 타이틀 | "기획팀 / 디자인팀 / 개발팀" 고정 위치 | 각 박스 top-left 또는 top-center |

### 4.2 부분 ② — 행 형식 정의

**목표:** 각 박스 내 행의 통일된 포맷 결정

```
╔════ 기획팀 ═════╗
║ 장그래 [◉ working]  │
║   v0.6.4/M3_design │
║   tokens: 45.2k     │
║                     │
║ 김민교 [○ idle]    │
╚═════════════════╝
```

| 행 번호 | 내용 | 규격 | 예시 |
|--------|------|------|------|
| 1 | 페르소나명 + 상태 기호 | `<이름> [◉ working \| ○ idle]` | `장그래 [◉ working]` |
| 2 | 버전/과제명 | 들여쓰기 2칸 + `<버전>/<과제명>` | `  v0.6.4/M3_design` |
| 3 | 토큰량 | 들여쓰기 2칸 + `tokens: <N>k` | `  tokens: 45.2k` |
| N | 공백 | 행 구분용(optional) | (빈 줄) |

**v2 (F-M3-3 흡수) — 두 개념 분리:**

**(1) 표시 형식 (M3 렌더링 책임):**
- 단위: `k` 단위 (kilo)
- 정밀도: `%.1f` 소수점 1자리 — `tokens: 45.2k` 형식
- M2 dataclass 정합성: `PersonaState.tokens_k: float` 그대로 소비

**(2) 모델별 토큰 사용 참고치 (참고 정보, 표시 형식 아님):**
- Haiku (가볍다): 15~35k 범위
- Sonnet (중간): 35~70k 범위
- Opus (무겁다): 70k+ 범위
- 본 정보는 표시 형식과 별개입니다 — 어떤 모델을 쓰든 표시는 `%.1fk` 통일.

### 4.3 부분 ③ — 다중 버전 표시 정책

**경우의 수:**

1. **단일 버전 (일반):** 행 3개
   ```
   장그래 [◉ working]
     v0.6.4/M3_design
     tokens: 45.2k
   ```

2. **다중 버전 (동일 페르소나, 다중 과제) — v2 (F-M3-4 흡수):** sub-row prefix `└` 또는 `▸` 사용. 빈 줄 구분 옵션 회수(brainstorm 의제 3 "박스 안 행으로만 구분, 별도 영역 X" 위반 위험 해소).
   ```
   장그래 [◉ working]
     v0.6.4/M3_design
     tokens: 45.2k
   └ v0.6.4/M2_data
     tokens: 32.1k
   ```

3. **working/idle 혼합:** 상태 기호만 top 행에 (최종 상태 = 최신 working 또는 idle)
   ```
   장그래 [◉ working]
     v0.6.4/M3_design (active)
     tokens: 45.2k
   ```

**v2 (F-X-7-#4 흡수) — 정렬·자율 영역 결정:**
- 다중 버전 시 구분자: **`└` prefix 통일** (F-M3-4)
- 다중 버전 정렬: **페르소나명 고정순** 권장(F-X-7-#4 — working 우선 옵션 회수, 가시화 일관성 우선)
- 최대 행 수 제한: 3개 이상 동시 버전 시 "... 외 N개 버전" 생략 정책 — Q-M3-2로 Stage 5 영역 잔존

### 4.4 부분 ④ — 빈 박스 처리

**상황:** 디자인팀에 현재 활성 인원 0 (M1~M2 단계에서 가능)

```
╔════ 디자인팀 ════╗
║ (팀 대기 중)      │
╚═════════════════╝
```

또는 완전 빈 박스:

```
╔════ 디자인팀 ════╗
║                  │
╚═════════════════╝
```

**v2 (F-X-7-#6 흡수) — 권장: 옵션 A**

| 옵션 | 설명 | v2 채택 |
|------|------|--------|
| **A** | 팀명만 표시 + "대기 중" 텍스트 | **권장 (F-X-7-#6 흡수, brainstorm 단순성 우선)** |
| ~~B~~ | ~~완전 빈 박스 (경계선만)~~ | 회수 (운영자 가시성 저하) |
| ~~C~~ | ~~팀명 + 회색 처리(disabled state)~~ | 회수 (Stage 6/7 디자인팀 영역 침범) |

---

## Sec. 5. AC (Acceptance Criteria)

> **v2 (F-M3-2 + F-X-2 흡수):** "측정: 자동/수동" 컬럼 명시. AC-M3-2/5/8 자동화 명령 박음. AC-M3-9 신규(read-only 정책 자동 검증, M4 AC-M4-N9 패턴 인용).

| AC ID | 기준 | 측정 | 측정 명령/방법 |
|-------|------|------|------------|
| **AC-M3-1** | 박스 3개 구조 존재. 기획/디자인/개발 팀별 박스 분리, 텍스트 경계선(ASCII or textual border) 명확 | 수동 | 대시보드 실행 → 3개 박스 visual 확인 (M1 scaffold 완료 필수) |
| **AC-M3-2** | 행 형식 일관성. 모든 행이 `<페르소나> [◉/○] + <버전>/<과제> + tokens: <N>k` 형식 준수. 들여쓰기 일관성(2칸 고정) | 자동 | `grep -cE "\[◉ working\|○ idle\]" scripts/dashboard/team_renderer.py` ≥ 2 (**v2: regex 박음**) |
| **AC-M3-3** | 다중 버전 표시. 동일 페르소나가 2개 이상 버전을 다룰 때 sub-row prefix(`└`) 분할 표시. 생략/truncation 없음 (Q-M3-2 ≥3개 케이스는 별도) | 수동 | 테스트 시나리오 (v0.6.3/M1 + v0.6.4/M2 동시) → `└` prefix sub-row 확인 |
| **AC-M3-4** | 박스 너비. 전체 화면의 33% ± 5% (3등분 동등 배분). 줄바꿈 없이 약 50~70글자 행이 한 줄에 표시 | 수동 | textual dev 화면(터미널 너비 120~150) 확인 — textual snapshot 비교 또는 수동 |
| **AC-M3-5** | 상태 기호. working(◉) / idle(○) 정확히 사용. 기호 위치 일관성(페르소나명 뒤) | 자동 | `grep -cE "◉\|○" scripts/dashboard/team_renderer.py` ≥ 2 (**v2 자동화**) |
| **AC-M3-6** | 빈 박스 처리. 활성 인원 0일 때 팀 박스 표시 방식 = **옵션 A(팀명 + "대기 중")** 적용 (v2 F-X-7-#6 흡수) | 자동 | `grep -cE "대기 중\|No personas active" scripts/dashboard/team_renderer.py` ≥ 1 |
| **AC-M3-7** | 의존성 명시. M3 TeamRenderer가 M2 PersonaState를 직접 소비 (F-D1 후보 단일 spec). | 자동 | `grep -cE "PersonaState" docs/02_planning_v0.6.4/planning_03_M3_render.md docs/02_planning_v0.6.4/planning_02_M2_data.md` ≥ 2 |
| **AC-M3-8** | 토큰 형식. `tokens: %.1fk` (소수점 1자리, k 단위 통일). | 자동 | `grep -cE "tokens: %\\.1f\|tokens: \\{.*:\\.1f\\}" scripts/dashboard/team_renderer.py` ≥ 1 (**v2: format string 박음**) |
| **AC-M3-9** (v2 신규, F-X-2) | read-only 정책 자동 검증. M3 렌더링 코드 어디에도 write 명령(git push / git commit / open with mode 'w') 0건. | 자동 | `grep -cE "git push\|git commit\|open\(.*['\"]w['\"]" scripts/dashboard/team_renderer.py scripts/dashboard/models.py 2>/dev/null \| awk -F: '{s+=$2} END{print s+0}'` = 0 |

---

## Sec. 6. 의존성

### 6.1 상향(upstream) 의존

> **v3 finalizer (F-D1 정책 commit 본문 결정):** 본 M3 `TeamRenderer.render()`는 M2 `PersonaState` 단일 dataclass를 직접 소비합니다. 입력 시그니처 = `Dict[str, List[PersonaState]]` (key = 팀명 "기획"/"디자인"/"개발"). v1의 별도 `TeamMember` 의사 dataclass는 영구 회수합니다. 동일 페르소나가 다중 버전 작업 중인 경우 `PersonaState` 인스턴스 N개로 들어오며, 렌더링 단계에서 `name` 그룹핑 → 첫 entry는 일반 행, 2번째+는 `└` prefix sub-row(F-M3-4)로 누적합니다. 본 결정은 reviewer 권장(planning_review.md F-D1, F-X-1 흡수) verbatim입니다.

| 대상 | 내용 | 영향 |
|------|------|------|
| **M2 plan_final (planning_02_M2_data.md)** | 데이터 구조: M2 `PersonaState` dataclass + `PersonaDataCollector` 인터페이스 | **v3 (F-D1 본문 결정 흡수):** M3 `TeamRenderer.render(teams_data: Dict[str, List[PersonaState]])` — M2 dataclass 그대로 소비. M2 v3 final로 단일 spec 닫힘. |
| **brainstorm.md 의제 4** | 표시 항목: 페르소나/상태/버전/토큰량 고정 | 본 M3는 의제 4 그대로 반영. 추가 항목 없음 |

### 6.2 하향(downstream) 의존

| 대상 | 내용 | 영향 |
|------|------|------|
| **M4 (Pending Push·Q)** | M3 박스 3개 아래 추가 박스 2개 (Pending/Q) | M3 박스 3개 높이 + margin 결정 후 M4가 레이아웃 조율 |
| **Stage 5 기술 설계** | M3 레이아웃 골격 → 색상/스타일 추가 | 본 M3는 단순 구조만. Stage 5에서 CSS-like 스타일 추가 |
| **Stage 6/7 디자인팀 (Orc-064-design)** | M3 본체 레이아웃 → UI 시안(색상/톤/인터랙션) | **v2 (F-M3-5 흡수):** dispatch 발행 시점 = **Stage 5 기술 설계 완료 + 운영자 Stage 6 진입 시그널 후** (brainstorm Sec.4-3 호환). v1의 "M3 draft 완료 후 즉시" 표현 회수. |

### 6.3 병렬 진행 (Stage 6/7 디자인팀)

**핵심:** M3는 기획팀이 "무엇을 만들지(What)" 정의하고, 디자인팀이 "어떻게 아름답게 만들지(How)" 담당.

| 영역 | 담당 팀 | 시점 |
|------|--------|------|
| M3 골격(박스 구조 + 행 형식) | 기획팀 (본 문서) | Stage 2 |
| M3 레이아웃 상세(너비/높이 픽셀, border style) | 디자인팀 (Stage 6/7) 또는 Stage 5 기술 설계 | Stage 5 또는 Stage 6 |
| M3 색상/스파크라인/진행률 바 | 디자인팀 (Stage 6/7) | Stage 6/7 |
| M3 가독성 시나리오(6~9행 동시) | 기획팀 + 디자인팀 협업 | Stage 5 기술 설계 검증 |

**절차 (v2 F-M3-5 흡수):** Stage 2 plan_draft → Stage 3 review → Stage 4 final → Stage 5 기술 설계(M3 레이아웃 정밀화) → **운영자 Stage 6 진입 시그널** → **Stage 6/7 디자인팀 첫 등판(Orc-064-design UI 결과)** 순서. 회의창이 임의로 디자인팀 dispatch 선발행 금지.

---

## Sec. 7. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 |
|----|--------|-----------|--------|------|
| R1 | M2 data 인터페이스 변경 → M3 renderer 호환성 깨짐 | 중 | 중 | Stage 3 plan_review에서 M2 최종 인터페이스 명시. M3 renderer는 M2 spec locked 후 구현 |
| R2 | 다중 버전 표시 정책 (행 분할 vs 생략) 미정 → Stage 5 구현 시 confusion | 중 | 낮음 | 본 Sec.4.3 "자율 영역"으로 표시. Stage 3 plan_review에서 후보 정리 + 운영자 결정 필요 여부 판단 |
| R3 | 터미널 너비(120vs 150vs 80) 변수 → 행 줄바꿈 가독성 저하 | 중 | 중 | AC-M3-4 "stage 5 시나리오 검증" 추가. 반응형 너비(flex) 구현 고려 |
| R4 | 빈 박스 처리 정책 미정(A/B/C) → 사용자 경험 분기 | 낮음 | 중 | 본 Sec.4.4 선택지 제시. Stage 3 plan_review → 운영자 결정 또는 Stage 5 자율 |
| R5 | 디자인팀 첫 등판(Stage 6/7)과 M3 레이아웃 미정렬 → 최종 산출물 톤 불일치 | 중 | 중 | 본 Sec.6.3 "병렬 진행 절차" 명시. dispatch 발행 시 M3 plan final 첨부 + 디자인팀 가이드 |

---

## Sec. 8. 열린 질문 (Stage 3 plan_review 후보 → v2 흡수 후 잔존)

> **v2 갱신:** Q-M3-1/Q-M3-3/Q-M3-4는 v2에서 흡수되어 회수됩니다. Q-M3-2만 잔존 — Stage 5 기술 설계 영역.

| # | 질문 | 판단 책임 | 비고 |
|----|------|---------|------|
| ~~Q-M3-1~~ (v2 흡수) | ~~다중 버전 행 정렬~~ → **페르소나명 고정순** (F-X-7-#4 흡수, 가시화 일관성 우선) | — | — |
| **Q-M3-2** | 동일 페르소나 다중 버전 표시 한계. 3개 이상 버전 동시 시 가독성 → "... 외 N개" 생략 정책 필요 vs 모두 표시 | Stage 5 기술 설계 | 최악 시나리오: v0.6.2/M1 + v0.6.3/planning + v0.6.4/M3 동시 작업 → 3행 이상 |
| ~~Q-M3-3~~ (v2 흡수) | ~~빈 박스 표시 방식~~ → **옵션 A** (F-X-7-#6 흡수, 팀명 + "대기 중") | — | — |
| ~~Q-M3-4~~ (v2 흡수) | ~~M3 모듈 위치~~ → **`scripts/dashboard/...`** (F-X-7-#2 / F-D2 후보 흡수) | — | — |

---

## Sec. 9. 자율 영역 (Stage 3/4 또는 Stage 5에서 정밀화)

> **v2 갱신:** v1 자율 영역 6건 중 #3/#4/#5는 v2 흡수로 결정됨. #1/#2/#6만 잔존 (Stage 5 기술 설계 영역).

1. **textual widget 선택:** `Horizontal` vs `Grid` vs 커스텀 `Static` 계층 구조 (Stage 5)
2. **박스 높이 유동:** 행 수에 따라 자동 증가 vs 고정 높이 + scroll (Stage 5, F-M5-4 박스 높이 우려와 sync)
3. ~~행 정렬순서~~ → **페르소나명 고정순** (F-X-7-#4 흡수)
4. ~~구분자 형태~~ → **`└` prefix** (F-M3-4 흡수)
5. ~~토큰 단위~~ → **`%.1fk`** (F-M3-3 흡수)
6. **진행 상황 표시 (Stage 5 이월):** 별도 진행률 바 vs 상태 기호만

---

## Sec. 10. Stage 5/6/7 이월 표

> **v3 (F-X-3 통합 표 finalizer 흡수):** 본 doc Sec.10은 M3 스냅샷으로 보존하며, 5개 doc 합산 통합 Stage 5 이월 표는 **`planning_index.md` 단일 source of truth**(박지영 PL 영역)로 수렴합니다. **이월 ID 표기 정정:** 본 표 `F-M3-S5-1~5`는 v1 drafter 자체 이월 표(=v1 F-M3-1~5)를 의미하며, reviewer 발견 ID(planning_review.md `F-M3-1~5` 명시 추가)와는 다른 의미입니다. 통합 표(planning_index)에서 reviewer ID와 명확히 구분 표시 예정.

| 이월 ID (drafter v1) | 내용 | 담당 | 시점 | 우선순위 |
|--------|------|------|------|---------|
| **F-M3-S5-1** (=v1 F-M3-1) | 색상 팔레트 정의 (primary/warning/idle/working 색상 tokens) — **v2:** 책임자 분리 — Stage 5 기술 설계가 토큰명 정의(`--color-working` / `--color-idle` 등), Stage 6 디자인팀이 색값 채택 (reviewer 권장) | Stage 5 (토큰명) + Stage 6 (색값) | Stage 5 또는 Stage 6 | 필수 |
| **F-M3-S5-2** (=v1 F-M3-2) | CSS-like 스타일 정의 (margins, padding, border, font) | 디자인팀 | Stage 6/7 | 필수 |
| **F-M3-S5-3** (=v1 F-M3-3) | 6~9행 동시 가독성 visual 검증 시나리오 | 기획팀 + 디자인팀 | Stage 5 | 필수 |
| **F-M3-S5-4** (=v1 F-M3-4) | 스파크라인(토큰 추세) / 진행률 바 상세 설계 | 디자인팀 | Stage 6/7 | 권장 |
| **F-M3-S5-5** (=v1 F-M3-5) | Windows Terminal / WSL 호환성 검증(M5 범위 포함) | 개발팀 | Stage 8 구현 후 M5 | 권장 |

---

## Sec. 11. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | v1 draft | Stage 2 plan_draft 초안 (장그래) |
| 2026-04-27 | v2 revised (장그래 drafter, 세션 27 후속) | Stage 3 plan_review 흡수 10건 (F-M3-1~5 + F-X-1/F-X-2 + F-X-7-#2/#4/#6). AC 8 → 9건(AC-M3-9 read-only 신규). Q-M3 4건 → 1건(Q-M3-1/3/4 흡수). 위치 `scripts/dashboard/...` 단일화. PersonaState 단일 spec 후보 흡수. 토큰 형식·다중 버전 prefix·디자인팀 dispatch 시점 정정. |
| 2026-04-27 | **v3 final** (안영이 finalizer, 기획팀 선임연구원 Sonnet/medium) | v2 위에 정책 commit 본문 결정 박음 — **F-D1** Sec.6.1 + 첨부 의사 코드(`TeamRenderer.render(teams_data: Dict[str, List[PersonaState]])` — M2 dataclass 직접 소비, `TeamMember` 영구 회수), **F-D2** Sec.3 머리말 + Sec.3.1(`scripts/dashboard/team_renderer.py` + `models.py` 본문 박음, M2 dataclass 재사용 시 `models.py` 자체 회수 가능 영역). 횡단 흡수: F-X-3 Sec.10 머리말(planning_index 통합 포인터, 이월 ID vs reviewer 발견 ID 구분 명시). 잔존 운영자 결정 = 없음 (M3 영역). status: pending_operator_approval. plan_draft 5종은 Stage 2 스냅샷 보존. |

---

## 첨부: 참고 자료

### brainstorm.md 의제 4 인용 (표시 항목)

```
╔══ 기획팀 ════════════╦══ 디자인팀 ══════╦══ 개발팀 ════════════╗
║ <페르소나> [상태]     ║                  ║                      ║
║   <버전>/<과제>       ║                  ║                      ║
║   tokens: <N>k        ║                  ║                      ║
╚══════════════════════╩══════════════════╩══════════════════════╝
```

### M3 렌더링 의사 코드 (참고용, 실제 구현은 Stage 5/8)

> **v3 finalizer (F-D1 본문 결정 흡수):** v1의 별도 `TeamMember` dataclass를 영구 회수하고 M2 `PersonaState`를 그대로 소비합니다. 동일 페르소나 다중 버전 시 sub-row prefix `└` 사용(F-M3-4). 빈 박스는 옵션 A "팀명 + 대기 중"(F-X-7-#6).

```python
from typing import Dict, List
# from scripts.dashboard.models import PersonaState  # M2 dataclass 그대로 소비


class TeamRenderer:
    """M3: 박스 3개 + 행 렌더링 — v2: PersonaState 단일 spec 소비 (F-D1 후보)"""

    def render(self, teams_data: Dict[str, List["PersonaState"]]) -> str:
        # teams_data = {
        #   "planning": [
        #     PersonaState(name="장그래", team="기획", status="working",
        #                  task="v0.6.4/M3_design", tokens_k=45.2,
        #                  last_update=...),
        #     # 동일 페르소나 다중 버전 시 별도 PersonaState 인스턴스 N개
        #     # → 렌더링 단계에서 name 그룹핑 → sub-row `└` prefix
        #   ],
        #   "design": [...],
        #   "dev": [...],
        # }

        # Step 1: 3개 박스 생성 (가로 3등분, 너비 33% ± 5%)
        # Step 2: 각 박스에 행 렌더링
        #         format: "<name> [◉ working|○ idle]" + "  <task>" + "  tokens: %.1fk"
        #         동일 name 다중 entry → 첫 entry는 일반 행, 2번째+는 `└` prefix sub-row
        # Step 3: 빈 박스 처리 (활성 0명 시) → "팀명 + 대기 중" (옵션 A, F-X-7-#6)
        # return 렌더링 결과 (textual widgets 또는 문자열)
```

