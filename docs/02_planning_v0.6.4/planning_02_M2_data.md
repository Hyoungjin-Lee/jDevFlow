---
version: v0.6.4
stage: 4 (plan_final)
date: 2026-04-27
mode: Strict
status: pending_operator_approval
item: 02_M2_data
revision: v3 (final)
draft_by: 장그래 (기획팀 주임연구원, Haiku) — v1 초안 + v2 review 흡수
finalized_by: 안영이 (기획팀 선임연구원, Sonnet/medium)
final_at: 2026-04-27
upstream:
  - docs/01_brainstorm_v0.6.4/brainstorm.md (의제 8 마일스톤 M2)
  - dispatch/2026-04-27_v0.6.4_stage234_planning.md
  - docs/02_planning_v0.6.4/planning_review.md (김민교 reviewer)
incorporates_review: docs/02_planning_v0.6.4/planning_review.md
incorporates_v2: 장그래 drafter v2 (revised, 세션 27 후속)
revisions_absorbed:
  - F-M2-1 (Sec.8 AC 표 자동/수동 컬럼 + Sec 번호 정정 2건 + 자동화 명령 박음)
  - F-M2-2 (Sec.3.2 sync 인터페이스 박음 — async wrapper Stage 5)
  - F-M2-3 (Sec.5 옵션 A/C 분기 표 + F-X-7-#5 권장 우선순위 흡수)
  - F-M2-4 (Sec.7 갱신 주기 vs idle T 독립 변수 명시)
  - F-M2-5 (Sec.10 R3 offline = idle 통합)
  - F-X-7-#5 — A-1 > A-3 > A-2 권장(F-M2-3 통합)
  - F-M2-S5a~f — Stage 5 이월 유지, F-M2-S5a는 F-D1 등급 상승
cross_cutting_absorbed:
  - F-D1 (정책 commit 본문 박음 — PersonaState 단일 dataclass + PersonaDataCollector + PendingDataCollector SRP 분리)
  - F-D4 (정책 commit 본문 박음 — 인터페이스 dataclass 일관성 + sync 시작 / async = Stage 5)
  - F-X-1 (F-D1로 흡수 — M2/M3/M4 데이터 모델 단일 spec)
  - F-X-2 (read-only 정책 5개 doc 표준 — AC-M2-9 박힘)
  - F-X-3 (Stage 5 이월 통합 표 → planning_index.md 단일 source of truth, 본 doc Sec.11은 스냅샷 유지)
  - F-X-7-#5 (drafter 자율 영역 미회수 — A-1 > A-3 > A-2 권장)
---

# jOneFlow v0.6.4 — M2 데이터 수집 layer (planning_02_M2_data)

> **상위:** `docs/01_brainstorm_v0.6.4/brainstorm.md` Sec.2 (Stage 1, 의제 8)
> **본 문서:** `docs/02_planning_v0.6.4/planning_02_M2_data.md` (Stage 4 plan_final v3, finalizer 안영이)
> **상태:** 🟡 plan_final v3 (Stage 4 finalizer 안영이, 운영자 승인 대기 — Stage 4.5 게이트)
> **다음:** Stage 4.5 운영자 승인 게이트 (Q1 토큰량 정책 + Q5 offline confirm) → 박지영 PL planning_index.md 통합 → Stage 5 기술 설계
> **의존:** M1 (`/dashboard` 슬래시 커맨드 + textual scaffold) 완료 후 데이터 수집 인터페이스 정의

> **v3 갱신 범위 (finalizer 안영이):** v2(장그래 drafter) 위에 정책 commit 본문 결정 문장(F-D1 / F-D4) + 횡단 흡수 추가 분(F-X-2 / F-X-3 / F-X-7-#5)을 박았습니다. F-D 본문 결정은 reviewer 권장(planning_review.md Sec.8) verbatim으로 흡수했으며, finalizer 임의 결정 영역이 아닙니다. 운영자 결정 Q1(토큰량 +8h vs +2h)은 Stage 4.5에서 답변 후 본문 verbatim 박힘 예정.

---

## Sec. 0. 요약 (v3 final 갱신)

### Sec. 0.1 v3 final 변경 요약 (finalizer 흡수)

본 v3는 v2(장그래 drafter, Stage 3 review 흡수 9건) 위에 finalizer 안영이가 정책 commit 본문 결정 + 횡단 흡수를 추가한 final 산출물입니다. 본 stage에서는 운영자 결정 게이트(Q1 / Q5)는 표시만 박고 답변은 Stage 4.5에서 회수합니다.

| ID | 유형 | 위치 | 변경 요지 (drafter v2 → finalizer v3) |
|----|------|------|----------------------------------|
| F-M2-1 | 명시 추가 (v2 흡수 유지) | Sec.8 AC 표 | 자동/수동 컬럼 + Sec 번호 정정. v3 변경 없음. |
| F-M2-2 | 명시 추가 (v2 흡수 유지) | Sec.3.2 | sync 인터페이스 박음. v3 finalizer가 F-D4 본문 결정으로 승격. |
| F-M2-3 | 명시 추가 (v2 흡수 유지) | Sec.5 분기 표 | 옵션 A/C 분기 표. v3 변경 없음. |
| F-M2-4 | 명시 추가 (v2 흡수 유지) | Sec.7 | 갱신 주기 vs idle T 독립 변수 명시. v3 변경 없음. |
| F-M2-5 | 명시 추가 (v2 흡수 유지) | Sec.10 R3 / Q5 | offline = idle 통합. Q5 운영자 confirm 전환. v3 변경 없음. |
| **F-D1** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.3 머리말 + Sec.3.1 + Sec.3.2** | **본 v0.6.4 데이터 모델을 단일 spec으로 수렴** — `PersonaState` 단일 dataclass + `PersonaDataCollector` (M2) + `PendingDataCollector` (M4) SRP 분리. M3 `TeamRenderer.render()` 입력 = `Dict[str, List[PersonaState]]`. M2 v1 `TeamMember` / M4 v1 `DataCollector` 충돌 닫음. |
| **F-D4** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.3.2 + Sec.11 F-M2-S5e** | **인터페이스 dataclass 일관성 + sync 시작 / async = Stage 5** 결정 박음. M1 `on_mount()` 동기 훅과 정합성 확보. M2 v1의 `persona_by_name`만 동기였던 일관성 깨짐 닫음. |
| F-X-1 | F-D1로 흡수 (v3) | Sec.3 본문 결정 | M2/M3/M4 데이터 모델 단일 spec — F-D1 본문에서 닫힘. |
| F-X-2 | 횡단 흡수 (v2) | Sec.2 + AC-M2-9 | read-only 정책 명시 + AC-M2-9 자동 검증. v3 변경 없음. |
| F-X-3 | 횡단 흡수 (v3 finalizer) | Sec.11 머리말 | Stage 5 이월 통합 표 단일 source of truth = planning_index.md (박지영 PL 영역). 본 doc Sec.11은 M2 스냅샷 유지. |
| F-X-7-#5 | 자율 영역 (v2 흡수 유지) | Sec.5 분기 표 | A-1 > A-3 > A-2 권장. v3 변경 없음. |
| F-M2-S5a → F-D1 | 등급 상승 (v3 흡수) | Sec.11 → Sec.3 본문 | 데이터 수집 방식 채택 = M2/M3/M4 묶는 정책 commit. F-D1 본문에서 닫힘 (Stage 5 결정 책임자 = Orc-064-plan 박지영). |

> **finalizer 흡수 결과:** 본 v3는 drafter 권한 밖 정책 commit 2건(F-D1 / F-D4)을 본문 결정 문장으로 닫고, 횡단 영역 1건(F-X-3)을 planning_index 포인터로 정리했습니다. 본 stage 잔존 운영자 결정 = **Q1 토큰량 정책 (Stage 4.5 게이트, reviewer 권장: 정확 B)** + **Q5 offline=idle 운영자 confirm**. Stage 5 영역 = Q2(데이터 수집 방식 채택, F-D1 본문 결정 책임자 박힘) + Q3(thinking 상태).

### Sec. 0.2 v1 요약

M2는 **운영자 대시보드가 표시할 페르소나 상태 데이터를 수집하는 layer**입니다. tmux 세션 목록(bridge-*, Orc-*)에서 페르소나별 작업 상태(working/idle), 작업명(버전/과제), 토큰량을 실시간 추출합니다. 본 draft는 데이터 수집 방식 3가지(capture-pane 파싱 / claude CLI 메타 / 페르소나 자가 보고) 후보를 비교하고, 인터페이스 spec을 정의합니다. 채택 및 갱신 주기 설정은 Stage 5 기술 설계 영역으로 이월합니다.

---

## Sec. 1. 목적 (Purpose)

v0.6.4 운영자 대시보드는 기획/디자인/개발 3팀의 **페르소나별 실시간 작업 상태**를 가시화합니다. 이를 위해 M2는 다음을 제공해야 합니다:

1. **tmux 세션 모니터링** — bridge-* (브릿지) / Orc-*-plan / Orc-*-design / Orc-*-dev (오케스트레이터 + 팀원) 세션 목록 감지
2. **페르소나 상태 추론** — 세션 내 페르소나 식별(이름) + 작업 상태(working/idle) 판단
3. **작업 메타데이터 수집** — 현재 작업명(버전/과제), 토큰량 추출
4. **인터페이스 제공** — M3(렌더링 layer)이 호출 가능한 Python dataclass 또는 JSON API

---

## Sec. 2. 범위 (Scope)

### 수집 대상 데이터

| 데이터 | 설명 | 수집 시점 |
|--------|------|---------|
| **페르소나 이름** | 박지영 / 김민교 / ... / 지예은 (18명 정식, 현재 4~6명 가동) | 세션 초기화 / 10초마다 갱신 |
| **팀 분류** | 기획/디자인/개발 | 페르소나 이름 매핑으로 고정 |
| **작업 상태** | working (진행 중) / idle (대기) | 1~2초 주기 갱신 |
| **작업명** | "v0.6.4/M2 정밀화" / "Stage 2 review" 등 (working일 때만) | working 상태 시 추출 |
| **토큰량** | 누적 사용 토큰(k 단위) | 매번 갱신 |
| **마지막 갱신 시각** | ISO 8601 timestamp | 데이터 신선도 표시용 |

### 범위 밖 (Stage 5 이월)

- 실제 데이터 수집 구현 (후보 선택 및 코드)
- 갱신 주기 확정 (1~2초 중 선택) — **v2 (F-M2-4):** idle 임계 T와 독립 변수
- 토큰량 정확도 vs 추정 정책 (운영자 결정 영역)
- 페르소나 자가 보고 채택 시 파일/소켓 형식 설계
- 18명 페르소나 ↔ tmux 세션 매핑 알고리즘

### read-only 정책 (brainstorm 의제 5 영구 적용 — v2 F-X-2 흡수)

> **v2:** M2 데이터 수집 layer는 brainstorm 의제 5의 read-only 정책을 영구 적용합니다. PersonaDataCollector / 토큰량 수집 / 작업명 추론 어디서도 git push / git commit / 파일 write 명령이 발생해서는 안 되며, write 영역 진입 신호 발견 시 즉시 Stage 4 review 회귀 대상이 됩니다. 자동 검증은 AC-M2-9 신규 항목(M4 AC-M4-N9 패턴 인용).

---

## Sec. 3. 데이터 모델 (Stage 8 구현 대상)

> **v3 finalizer (F-D1 정책 commit 본문 결정):** 본 v0.6.4 대시보드는 다음과 같이 데이터 모델 단일 spec으로 수렴합니다.
> 1. **`PersonaState`** — 단일 dataclass (6필드: name / team / status / task / tokens_k / last_update), M2 정의 그대로. M2/M3/M4 횡단 표준.
> 2. **`PersonaDataCollector`** (M2) — 페르소나 상태 수집 책임. `fetch_all_personas()` / `fetch_team()` / `persona_by_name()`.
> 3. **`PendingDataCollector`** (M4) — Pending Push/Q 수집 책임, M2와 SRP 분리. `get_pending_pushes()` / `get_pending_questions()`.
> 4. **M3 `TeamRenderer.render()`** 입력 = `Dict[str, List[PersonaState]]` — M2 dataclass 그대로 소비. M3 v1의 별도 `TeamMember` dataclass 회수.
>
> 본 결정으로 M2/M3/M4 doc 간 dataclass 명칭 충돌(`TeamMember` / `DataCollector` / `PersonaDataCollector`) 3중 어댑터 구조 우려를 닫습니다. **데이터 수집 방식 채택(옵션 A/B/C)은 Stage 5 기술 설계 영역 — 결정 책임자 = Orc-064-plan(박지영 PL).** 본 결정은 reviewer 권장(planning_review.md F-D1, F-X-1 흡수) verbatim 흡수입니다.

### 3.1 Core dataclass (v3 F-D1 본문 결정 박음)

```python
@dataclass
class PersonaState:
    """페르소나 실시간 상태 — v3 final: M2/M3/M4 횡단 단일 spec (F-D1 본문 결정)"""
    name: str              # 박지영 (정규 페르소나명)
    team: str              # "기획" / "디자인" / "개발"
    status: Literal["working", "idle"]
    task: Optional[str]    # "v0.6.4/M2 정밀화" (working일 때만 채워짐)
    tokens_k: float        # 누적 토큰 (k 단위)
    last_update: datetime  # ISO 8601
```

**v3 단일 spec 효과 (F-D1 본문 결정 후):**
- M3 `TeamRenderer.render()`는 `Dict[str, List[PersonaState]]`를 입력으로 소비 (M3 v1의 `TeamMember` 의사 dataclass 회수).
- M4 `PendingDataCollector`는 별개 클래스로 분리(SRP) — M4 v1의 `DataCollector` ≠ `PersonaDataCollector` 충돌 해소.

### 3.2 Collection interface (M2 → M3 제공) — v3 F-D4 본문 결정 박음

> **v3 finalizer (F-D4 정책 commit 본문 결정):** 본 v0.6.4 데이터 수집 인터페이스 dataclass 일관성은 다음과 같이 정리합니다.
> 1. `PersonaDataCollector` / `PendingDataCollector` 두 클래스의 메서드 시그니처는 dataclass(`PersonaState` / `PendingPush` / `PendingQuestion`) 입출력으로 통일 — primitive 타입(str/int/dict) 직접 노출은 회수합니다.
> 2. **sync vs async 결정은 Stage 5 기술 설계 영역**입니다 — 본 stage는 sync(`def`) 인터페이스로 시작합니다. async wrapper 채택 여부는 textual `App.run_worker(thread=True)` 패턴과 함께 Stage 5에서 결정합니다.
>
> 본 결정으로 M1 `on_mount()` 동기 훅과 정합성을 확보하고, M2 v1의 `persona_by_name`만 동기였던 일관성 깨짐을 닫습니다. 본 결정은 reviewer 권장(planning_review.md F-D4, F-X-4 흡수) verbatim 흡수입니다.

```python
class PersonaDataCollector:
    """tmux 기반 데이터 수집 — v3 final: sync 인터페이스 시작 (F-D4 본문 결정)"""

    def fetch_all_personas(self) -> List[PersonaState]:
        """모든 가동 중인 페르소나 상태 반환"""
        ...

    def fetch_team(self, team: str) -> List[PersonaState]:
        """특정 팀의 페르소나 목록"""
        ...

    def persona_by_name(self, name: str) -> Optional[PersonaState]:
        """이름으로 페르소나 조회"""
        ...
```

**v3 분리 클래스 (F-D1 본문 결정 박음):** Pending Push/Q 수집은 별개 클래스로 분리합니다. M4 `PendingDataCollector`가 `get_pending_pushes()` / `get_pending_questions()`를 제공하며, 본 `PersonaDataCollector`와 SRP 분리됩니다. M2/M4 독립 진행 가능 영역.

### 3.3 Metadata source (tmux session)

각 tmux 세션은 다음 구조 가정:

```
tmux session: bridge-064
  window 0:0 — Claude session (PM 스티브 리)
    pane 0.0 — claude CLI running
      stdout: 📡 status: ... / S1 ✅ / ...

tmux session: Orc-064-plan
  window 0:0 — Orc (박지영) 세션
  window 0:1 — drafter (장그래) 세션
  window 0:2 — reviewer (김민교) 세션
  window 0:3 — finalizer (안영이) 세션
```

각 pane의 stdout(capture-pane -p)에서 메타 정보 추출:
- 페르소나 이름 (초기 prompt / 종료 메시지 / 자가 보고)
- 작업명 (prompt / thinking... 표시 / 로그 라인)
- 토큰량 (claude CLI 메타 라인 / 페르소나 자가 보고)

---

## Sec. 4. 데이터 수집 방식 비교 (자율 영역, Stage 5 채택)

본 섹션은 3가지 후보를 나열합니다. 최종 채택은 Stage 5 기술 설계에서 결정합니다.

### 옵션 A: tmux capture-pane 파싱 (기술 기본값)

**방식:** `tmux capture-pane -t <session> -p -S -<N>` 출력을 regex로 파싱

**장점:**
- 외부 의존 0 (tmux만 필요)
- 모든 정보 추출 가능 (stdout 전체 수집)
- 페르소나 협조 불필요
- 실시간 (1~2초 주기 가능)

**단점:**
- 파싱 fragility — claude CLI 출력 포맷 변경 시 regex 깨짐
- 페르소나가 작업명/토큰량 표시 안 하면 추론 실패
- M5(Windows 호환) — WSL capture-pane 호환성 확인 필요

**토큰량 추정:**
- claude CLI stdout 메타 라인: `"usage": {"input_tokens": 1234, "output_tokens": 567}`
- 정규식: `"usage".*"input_tokens": (\d+).*"output_tokens": (\d+)`
- 정확도: ~95% (메타 라인 포함 시)

**구현 난이도:** 중 (3~5시간, 테스트 포함)

### 옵션 B: claude CLI 메타 hook (경량 정확)

**방식:** claude CLI 내부 hook (`.claude/settings.json` 또는 전역 `~/.claude/hooks/`)에서 세션 시작/종료 시 페르소나 메타 파일 생성

**장점:**
- 정확성 최고 (claude CLI 자체에서 토큰량 계산)
- 파싱 fragility 0
- Windows 호환성 높음

**단점:**
- hook 인프라 추가 필요 (claude CLI 수정 vs 외부 hook 스크립트)
- 18명 페르소나 모두에게 hook 적용 필요
- 페르소나 협조 불가피 (hook 운영 매뉴얼 제공)

**구현 난이도:** 높음 (8~12시간, hook 설계 + 테스트)

### 옵션 C: 페르소나 자가 보고 (협력 기반)

**방식:** 각 페르소나가 작업 시작/종료 시 파일(`.claude/persona_state.json`) 또는 socat 소켓에 상태 기록

**장점:**
- 설계 단순 (M2는 단순히 읽기만)
- 모든 정보 완벽 제어 가능 (페르소나가 원하는 정보만 기록)
- 모든 플랫폼 호환 (파일 쓰기는 universal)

**단점:**
- 페르소나 협조 필수 (18명 모두 매뉴얼 숙지 필요)
- 자가 보고 누락/지연 가능성 (신뢰성 낮음)
- M1~M4 진행 중 페르소나 기존 프로세스 수정 필요 (disruption)

**구현 난이도:** 낮음 (2~3시간, 파일 읽기) 단, 페르소나 교육 + 신뢰도 관리 필요

### 선택 기준표

| 기준 | 옵션 A (capture-pane) | 옵션 B (CLI hook) | 옵션 C (자가 보고) |
|------|-----|-----|-----|
| 정확도 | 중 (추론 필요) | 높음 | 높음 (신뢰도 차) |
| 구현 난이도 | 중 | 높음 | 낮음 |
| 외부 의존 | 없음 | claude CLI hook | 페르소나 협조 |
| Windows 호환 | 낮음 | 높음 | 높음 |
| 토큰량 신뢰도 | 중 (~95%) | 최고 | 높음(페르소나 기록 신실성) |
| 추천도 | ★★★★ (기술 기본값) | ★★★ | ★★ (협력 비용 높음) |

---

## Sec. 5. 작업명(task) 추론 알고리즘 (초안)

working 상태 페르소나로부터 현재 작업명을 추출하는 방식:

### A-1. prompt 행에서 추출
```
capture-pane 마지막 N줄 중 ">" 프롬프트 이후 텍스트
예: "> 당신은 v0.6.4/M2 정밀화를 작업 중입니다. ..."
    → task = "v0.6.4/M2 정밀화"
```

### A-2. "thinking..." 표시
```
"Claude is thinking..." / "[Running...]" 등 표시
→ task = (직전 작업 계속, 또는 알 수 없음)
```

### A-3. 로그 라인에서 추출
```
"S2 plan_draft 진행 중" / "Stage 2 review 대기" 등 로그
→ task = (로그 파싱)
```

### A-4. 페르소나 자가 보고
```
파일: ~/.claude/persona_state.json (옵션 C 시)
  {"task": "v0.6.4/M2 정밀화", "since": "2026-04-27T10:30:00Z"}
```

**v2 (F-M2-3 + F-X-7-#5 흡수) 우선순위 분기 표:**

| 채택 옵션 (Sec.4) | 우선순위 권장 | 근거 |
|----|----|----|
| 옵션 A (capture-pane) | **A-1 > A-3 > A-2** (prompt > 로그 > thinking) | F-X-7-#5 reviewer 권장. A-4(자가보고)는 옵션 A에서 데이터 없음. thinking은 직전 작업 계속이라 정보가치 낮음. |
| 옵션 B (CLI hook) | A-1 > A-3 > A-2 | hook이 직접 task 메타 제공 시 본 우선순위는 fallback 영역만 적용. |
| 옵션 C (자가보고) | **A-4 > A-1 > A-3 > A-2** | 자가보고가 가장 신뢰도 높음. 누락 시 A-1로 fallback. |

Stage 5에서 데이터 수집 옵션 채택 후 본 분기 표를 따라 우선순위 fix.

---

## Sec. 6. 토큰량 수집 (정책 영역, Q)

### 토큰량 정의

- **누적 토큰 (tokens_k):** 세션 시작 이후 소비한 모든 토큰 합 (input + output), k 단위

### 수집 방식 후보

| 방식 | 추출처 | 정확도 | 리스크 |
|------|-------|--------|--------|
| **A. claude CLI stdout 메타** | `"usage": {...}` JSON 파싱 | ~95% | 출력 포맷 변경 시 깨짐 |
| **B. claude CLI hook** | 각 세션 종료 시 hook 저장 파일 | 100% | hook 인프라 필요 |
| **C. 페르소나 자가 보고** | 정기적 파일 기록 | 페르소나 신실성에 따름 | 누락/지연 가능 |
| **D. 추정값 (단순)** | "thinking..." 표시 시간 / pane 행 수 기반 heuristic | 낮음 | 신뢰도 낮음 |

**현재 제안:** A (capture-pane 메타 파싱) 기본. 정확도 요구 시 B.

### Q1: 토큰량 추정 정책
**질문:** 정확한 토큰량(B/C) vs 빠른 추정(A/D) 중 운영자 선호는?

**영향:**
- 정확 → Stage 5 hook 인프라 투입 (+8시간)
- 추정 → Stage 5 regex 파싱만 (+2시간)

운영자 결정 대기.

---

## Sec. 7. working/idle 판단 임계값 (Stage 5 이월)

> **v2 (F-M2-4 흡수):** **갱신 주기(brainstorm 의제 3 = 1~2초)와 idle 판정 무변화 임계 T는 독립 변수입니다.** 두 값을 같은 변수로 묶지 마시기 바랍니다 — 갱신 주기는 polling 간격, T는 "마지막 변화 이후 몇 초간 무변화 시 idle로 판정할지"의 윈도우 크기입니다.

### 초안: 마지막 N초 무변화 = idle

```python
if (now - last_pane_change) > T:
    status = "idle"
else:
    status = "working"
```

**T 후보 (idle 판정 임계, 갱신 주기와 별도):**
- T = 3초 — 적극 (초 단위 변화 감지, CPU 부하 높음)
- T = 10초 — 균형 (Stage 5 권장)
- T = 30초 — 소극 (오래 대기해도 working 표시)

**Stage 5 결정 대상:**
- T 값 확정
- "thinking..." 표시 중 working 판정 유지 여부
- 입력 프롬프트 hover(cursor 이동) = idle 신호 여부

---

## Sec. 8. AC (Acceptance Criteria)

> **v2 (F-M2-1 + F-X-2 흡수):** "측정: 자동/수동" 컬럼 명시. AC-M2-1/5 자동화 명령 박음. AC-M2-7(Sec.6 → Sec.9) / AC-M2-8(Sec.8 → Sec.12) Sec 번호 오류 정정. AC-M2-9 신규(read-only 정책 자동 검증, M4 AC-M4-N9 패턴 인용).

| AC ID | 기준 | 측정 | 측정 명령/방법 |
|-------|------|------|------------|
| **AC-M2-1** | 데이터 모델 정의. PersonaState dataclass + Collection interface 명시. | 자동 | `grep -c "PersonaState\|PersonaDataCollector" docs/02_planning_v0.6.4/planning_02_M2_data.md` ≥ 2 (**v2 자동화**) |
| **AC-M2-2** | 3가지 수집 방식 비교표 완성. 정확도/난이도/의존성 3열 이상. | 자동 | `grep -c "옵션" docs/02_planning_v0.6.4/planning_02_M2_data.md` ≥ 3 |
| **AC-M2-3** | 작업명 추론 알고리즘 4가지 방식 제시. prompt/thinking/로그/자가보고. | 자동 | `grep -c "A-[1-4]" docs/02_planning_v0.6.4/planning_02_M2_data.md` ≥ 4 |
| **AC-M2-4** | 토큰량 정책 3가지 후보 + Q1 제시. 정확도 vs 추정 trade-off 명확화. | 자동 | `grep -c "Q1" docs/02_planning_v0.6.4/planning_02_M2_data.md` ≥ 1 |
| **AC-M2-5** | M1(scaffold) 입력 데이터 명시. textual app이 호출할 fetch_all_personas() 등 인터페이스. | 자동 | `grep -cE "fetch_all_personas\|fetch_team\|persona_by_name" docs/02_planning_v0.6.4/planning_02_M2_data.md` ≥ 3 (**v2 자동화**) |
| **AC-M2-6** | M3(렌더링) 출력 포맷 정의. PersonaState → 박스 행 매핑 (이름/상태/작업/토큰). | 수동 | Sec.3.1 dataclass 필드 ↔ M3 final 표시 매핑 (F-D1 결정 후 `grep -c "PersonaState" docs/02_planning_v0.6.4/planning_03_M3_render.md` ≥ 1로 자동화 가능) |
| **AC-M2-7** | 의존성 명확화. M1 완료 후 M2 시작 (인터페이스 정의 필요). | 수동 | **v2 정정:** Sec.9 의존 그래프 검토 (v1 Sec.6 표기 오류) |
| **AC-M2-8** | 중단 조건 & Q 목록. 토큰량 정책(Q1) + working/idle 임계(Stage 5 이월) 명시. | 자동 | **v2 정정:** `grep -c "^### Q[0-9]\|^| \*\*Q[0-9]" docs/02_planning_v0.6.4/planning_02_M2_data.md` ≥ 1 (v1 Sec.8 표기 오류 — Q는 Sec.12 위치) |
| **AC-M2-9** (v2 신규, F-X-2) | read-only 정책 자동 검증. M2 layer 코드 어디에도 write 명령(git push / git commit / open with mode 'w') 0건. | 자동 | `grep -cE "git push\|git commit\|open\(.*['\"]w['\"]" scripts/dashboard/data*.py 2>/dev/null \| awk -F: '{s+=$2} END{print s+0}'` = 0 |

---

## Sec. 9. 의존성

### 내부 의존성
- **M1(scaffold) 완료 필수** — 슬래시 커맨드 + textual app 기본 구조 제공 필요. M2는 M1에 "PersonaDataCollector" 모듈 추가.
- **페르소나 명단** — 18명 정식은 v0.6.3 personas_18.md 대기. 현재는 4~6명 가동 기준으로 테스트.

### 외부 의존성
- **tmux 버전** — 2.6+ (capture-pane -S 지원). 운영 환경 확인 필수.
- **claude CLI 메타 포맷** — 버전에 따라 `"usage"` JSON 포맷 변경 가능. hook 구현 시 호환성 정책 필요 (Stage 5).

### 다른 M과의 관계

```
M1 (scaffold) ─→ M2 (data) ─┬─→ M3 (render)
                             └─→ M4 (pending+notif)
```

- **M2 → M3 필수:** PersonaState 리스트 제공
- **M2 → M4 선택:** Pending Q 도착 시 토큰량 변화 감지(optional)
- **M1 → M2 필수:** textual app 프레임워크 / 세션 핸들 제공

---

## Sec. 10. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 |
|----|--------|-----------|--------|------|
| R1 | capture-pane 출력 포맷 변경(claude CLI 버전 업) → 파싱 regex 깨짐 | 중 | 중 | Stage 5: 출력 포맷 스냅샷 저장 + regex 유효성 테스트 케이스 3건 이상 |
| R2 | 페르소나 이름 중복 또는 tmux session 네이밍 불일치 → 잘못된 매핑 | 중 | 중 | Stage 5: 페르소나 이름 ↔ tmux session 매핑 테이블 hardcode + 검증 step |
| R3 | 18명 페르소나 중 일부 세션 미실행(오프) → "idle" 표시 안 됨 | 낮음 | 낮음 | **v2 (F-M2-5 흡수):** brainstorm 의제 3 "working/idle 2단계" 정책 유지 → **offline은 idle로 통합 표시** (3번째 상태 추가는 brainstorm 정정 = drafter 권한 밖). 운영자 confirm 영역(Sec.12 Q5 후보). |
| R4 | 토큰량 추정값 오차 누적 (옵션 A) → 실제 사용 비용과 대시보드 표시 불일치 | 중 | 낮음 | 토큰량은 참고용 표시. 정확한 사용료는 Claude 콘솔 확인(read-only 원칙 유지) |
| R5 | Windows(WSL) capture-pane 호환성 → M5 진행 지연 | 중 | 중 | Stage 5: 옵션 B(hook) 준비 + Windows 테스트 환경 구성 (M5 병렬 가능) |

---

## Sec. 11. Stage 5 이월 표

> **v3 (F-X-3 통합 표 finalizer 흡수):** 본 doc Sec.11은 M2 스냅샷으로 보존하며, 5개 doc 합산 통합 Stage 5 이월 표는 **`planning_index.md` 단일 source of truth**(박지영 PL 영역)로 수렴합니다. F-M2-S5a는 v3 F-D1 본문 결정으로 닫혔으며, 결정 책임자 = Orc-064-plan(박지영 PL)이 본문에 박혔습니다.

| 이월 ID | 내용 | 담당 | 우선순위 |
|--------|------|------|---------|
| **F-M2-S5a** (→ **F-D1**) | 데이터 수집 방식 채택 (옵션 A/B/C 중 선택 + 이유 기록). **v3 (F-D1 본문 결정 흡수):** Sec.3 머리말에 결정 책임자 = Orc-064-plan 박지영 PL 박힘. Stage 5에서 옵션 채택 잔존. | Stage 5 (박지영 PL) | 필수 |
| **F-M2-S5b** | 갱신 주기 확정 (1초 / 2초 / 10초 중 선택). **v2:** F-M2-4 idle 임계 T와 독립 변수. | Stage 5 | 필수 |
| **F-M2-S5c** | working/idle 임계값 확정 (T = 3/10/30초 중 선택) | Stage 5 | 필수 |
| **F-M2-S5d** | 토큰량 정책 확정 (정확 B vs 추정 A) + Q1 운영자 결정 반영. **v2:** Q1 = 운영자 결정 게이트(Stage 4.5), reviewer 권장은 정확 B. | Stage 5 | 필수 |
| **F-M2-S5e** | PersonaDataCollector 구현 (선택 수집 방식 기준). **v3 (F-D4 본문 결정 흡수):** sync 시작 박힘, async wrapper 채택만 Stage 5 잔존. | Stage 5 + Stage 8 | Stage 8 |
| **F-M2-S5f** | 18명 페르소나 매핑 알고리즘 (v0.6.3 personas_18.md 도착 후). **v2:** F-X-6 boundary — Stage 8 진입 = blocking 시점. | Stage 5 | M5 |

---

## Sec. 12. 열린 질문 (Q, 운영자 / Stage 3/5 판단)

> **v2 reviewer 분류:** Q1 = 운영자 결정 게이트(Stage 4.5), Q2 = Stage 5 기술 설계, Q3 = Stage 5, Q4 = v2에서 F-M2-5로 흡수(offline = idle 통합) → Q5(운영자 confirm)로 등급 정정.

| # | 질문 | 판단 책임 | 영향 범위 |
|----|------|---------|---------|
| **Q1** | 토큰량 추정 정책: 정확(B, hook +8h) vs 빠른 추정(A, +2h)? **v2 reviewer 권장: 정확 B** (첫 실전 + Strict 모드 신뢰성 우선). | **운영자 결정 게이트 (Stage 4.5)** | 구현 난이도 |
| **Q2** | 데이터 수집 방식 기본값 확정: 옵션 A(capture-pane, fragile) vs B(hook, 복잡) vs C(자가보고, 협조 필요)? **v2:** F-D1 정책 commit으로 등급 상승, plan_final 본문에 결정 책임자 박음. | Stage 5 기술 설계 (finalizer 책임자 박음) | 전체 아키텍처 |
| **Q3** | working/idle 판단 시 "thinking..." 표시 = working 유지 여부? (또는 특수 상태 "analyzing"?) | Stage 5 | 대시보드 UX |
| ~~Q4~~ (v2 흡수) | ~~offline 페르소나 표시 방식~~ → **v2 (F-M2-5):** brainstorm 의제 3 2단계 정책 유지 → **offline = idle 통합 표시.** 3번째 상태 추가는 brainstorm 정정 = drafter 권한 밖. | — | — |
| **Q5** (v2 신규, F-M2-5 후속) | offline = idle 통합 정책 운영자 confirm. brainstorm 의제 3 정정 영역이 아님을 운영자 한 번 확인. | 운영자 confirm | 정책 |

---

## Sec. 13. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | v1 초안 (세션 27) | brainstorm.md 의제 8 기반 M2 data layer planning 작성 |
| 2026-04-27 | v2 revised (장그래 drafter, 세션 27 후속) | Stage 3 plan_review 흡수 9건 (F-M2-1~5 + F-X-1/F-X-2/F-X-7-#5 + F-M2-S5a→F-D1 등급 상승). AC 8 → 9건(AC-M2-9 read-only 신규). Sec 번호 오류 2건 정정(AC-M2-7/8). PersonaDataCollector sync 시그니처 박음. Sec.5 우선순위 분기 표 추가. R3 offline = idle 통합. Q4 흡수 + Q5(운영자 confirm) 신규. |
| 2026-04-27 | **v3 final** (안영이 finalizer, 기획팀 선임연구원 Sonnet/medium) | v2 위에 정책 commit 본문 결정 박음 — **F-D1** Sec.3 머리말 + Sec.3.1 + Sec.3.2(`PersonaState` 단일 dataclass + `PersonaDataCollector` + `PendingDataCollector` SRP 분리, M3 `TeamRenderer.render()` 입력 = `Dict[str, List[PersonaState]]`, 데이터 수집 방식 채택 책임자 = 박지영 PL), **F-D4** Sec.3.2 + Sec.11 F-M2-S5e(인터페이스 dataclass 일관성 + sync 시작 / async = Stage 5). 횡단 흡수: F-X-3 Sec.11 머리말(planning_index 통합 포인터). 잔존 Q = Q1 토큰량(Stage 4.5) + Q5 offline confirm(Stage 4.5). status: pending_operator_approval. plan_draft 5종은 Stage 2 스냅샷 보존. |

---

## 첨부: M2 데이터 흐름 다이어그램

```
[tmux sessions (bridge-*, Orc-*)]
        ↓ capture-pane / hook / 자가보고
    [PersonaDataCollector]
        ↓ fetch_all_personas()
    [PersonaState 리스트]
        ↓
    [M3 렌더링 layer]
        ↓
    [대시보드 박스 3개 행]
```

**M1(scaffold):** textual App 프레임워크 제공
**M2(data):** PersonaDataCollector 모듈 추가
**M3(render):** PersonaState → UI 위젯 매핑
**M4(pending):** Pending Q 큐 + 알림
**M5(windows):** 18명 매핑 + 호환성 검증

---

**초안 작성 완료:** 313줄, AC 8건, Q 4건. 리뷰어(김민교) 대기.
