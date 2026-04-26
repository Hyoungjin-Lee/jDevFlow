---
version: v0.6.4
stage: 4 (plan_final)
date: 2026-04-27
mode: Strict
status: pending_operator_approval
item: 04_M4_pending_notif
revision: v3 (final)
draft_by: 장그래 (기획팀 주임연구원, Haiku) — v1 초안 + v2 review 흡수
finalized_by: 안영이 (기획팀 선임연구원, Sonnet/medium)
final_at: 2026-04-27
upstream:
  - docs/01_brainstorm_v0.6.4/brainstorm.md (의제 4, 의제 6 알림)
  - dispatch/2026-04-27_v0.6.4_stage234_planning.md
  - docs/02_planning_v0.6.4/planning_review.md (김민교 reviewer)
incorporates_review: docs/02_planning_v0.6.4/planning_review.md
incorporates_v2: 장그래 drafter v2 (revised, 세션 27 후속)
revisions_absorbed:
  - F-M4-1 (Sec.3 변경 대상 파일 → `scripts/dashboard/...` — F-D2 후보 반영)
  - F-M4-2 (Sec.5 AC 표 — AC-M4-N4 % 회수, N5/N7/N10 자동화 명령)
  - F-M4-3 (Sec.4.4 CCNotify "(현재 미확인)" 명시 + Q-M4-3 운영자 결정 게이트)
  - F-M4-4 (Sec.4.5 — DataCollector → PendingDataCollector 분리, F-D1 후보 흡수)
  - F-M4-5 (Sec.7 R5 — git pre-commit hook 권장, F-X-2 흡수)
  - F-X-7-#3 — dedupe TTL 5분 권장 박음
  - F-M4-S5-1 — 알림 채널 선택 = 운영자 결정 게이트(Q-M4-2 비용 영향)
cross_cutting_absorbed:
  - F-D1 (정책 commit 본문 박음 — PendingDataCollector M2 PersonaDataCollector와 SRP 분리)
  - F-D2 (정책 commit 본문 박음 — `scripts/dashboard/pending.py` 등 위치 통일)
  - F-X-1 (F-D1로 흡수 — PendingDataCollector 분리 spec)
  - F-X-2 (read-only 정책 5개 doc 표준 reference — AC-M4-N9 박힘, M1/M2/M3/M5에 같은 패턴 전파)
  - F-X-3 (Stage 5 이월 통합 표 → planning_index.md 단일 source of truth, 본 doc Sec.9는 스냅샷 유지)
  - F-X-7-#3 (drafter 자율 영역 미회수 — dedupe TTL 5분)
---

# v0.6.4 M4: Pending Push·Q 박스 + macOS 알림

> **본 문서 위치:** `docs/02_planning_v0.6.4/planning_04_M4_pending_notif.md`
> **상위:** `docs/01_brainstorm_v0.6.4/brainstorm.md` Sec.8 (의제 8 마일스톤 M4)
> **상태:** 🟡 plan_final v3 (Stage 4 finalizer 안영이, 운영자 승인 대기 — Stage 4.5 게이트)
> **다음:** Stage 4.5 운영자 승인 게이트 (Q-M4-2 Pushover 비용 + Q-M4-3 CCNotify 존재) → 박지영 PL planning_index.md 통합 → Stage 5 기술 설계

> **v3 갱신 범위 (finalizer 안영이):** v2(장그래 drafter) 위에 정책 commit 본문 결정 문장(F-D1 / F-D2) + 횡단 흡수 추가 분(F-X-2 reference / F-X-3 / F-X-7-#3)을 박았습니다. **본 doc AC 자동성 9/10 = 5개 doc 중 최상** (reviewer 환영 영역). F-D 본문 결정은 reviewer 권장(planning_review.md Sec.8) verbatim으로 흡수했으며, finalizer 임의 결정 영역이 아닙니다.

---

## Sec. 0. 요약 (v3 final 갱신)

### Sec. 0.1 v3 final 변경 요약 (finalizer 흡수)

본 v3는 v2(장그래 drafter, Stage 3 review 흡수 9건) 위에 finalizer 안영이가 정책 commit 본문 결정 + 횡단 흡수를 추가한 final 산출물입니다. 본 stage에서는 운영자 결정 게이트(Q-M4-2 / Q-M4-3)는 표시만 박고 답변은 Stage 4.5에서 회수합니다.

| ID | 유형 | 위치 | 변경 요지 (drafter v2 → finalizer v3) |
|----|------|------|----------------------------------|
| F-M4-1 | 명시 추가 (v2 흡수 유지) | Sec.3 | `scripts/dashboard/...` 위치. v3 finalizer가 F-D2 본문 결정으로 승격. |
| F-M4-2 | 명시 추가 (v2 흡수 유지) | Sec.5 AC 표 | AC-M4-N4 % 회수, N5/N7/N10 자동화. v3 변경 없음. |
| F-M4-3 | 명시 추가 (v2 흡수 유지) | Sec.4.4 + Q-M4-3 | CCNotify "(현재 미확인)" 명시. v3 변경 없음 (운영자 결정 영역). |
| F-M4-4 | 명시 추가 (v2 흡수 유지) | Sec.4.5 | `PendingDataCollector` 분리. v3 finalizer가 F-D1 본문 결정으로 승격. |
| F-M4-5 | 명시 추가 (v2 흡수 유지) | Sec.7 R5 | git pre-commit hook 권장. v3 변경 없음. |
| **F-D1** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.4.5 머리말** | **`PendingDataCollector` (M4)를 M2 `PersonaDataCollector`와 SRP 분리** — `get_pending_pushes()` / `get_pending_questions()` 책임. M2/M4 독립 진행 가능 영역 닫음. |
| **F-D2** | **정책 commit (v3 finalizer 본문 박음)** | **Sec.3 머리말** | **M4 위치를 `scripts/dashboard/pending.py` + `notifier.py` + `data_adapters.py` + `ui/pending_widgets.py`로 본문 박음**. M1/M3와 통일. |
| F-X-1 | F-D1로 흡수 (v3) | Sec.4.5 본문 결정 | `PendingDataCollector` 분리 spec — F-D1 본문에서 닫힘. |
| F-X-2 | 횡단 reference (v2 흡수 유지) | AC-M4-N9 + 5개 doc 표준화 | 본 doc AC-M4-N9가 5개 doc read-only AC 자동 검증의 reference. M1/M2/M3/M5에 같은 패턴 박힘 (v3 finalizer 5개 doc 흡수 sync). |
| F-X-3 | 횡단 흡수 (v3 finalizer) | Sec.9 머리말 | Stage 5 이월 통합 표 단일 source of truth = planning_index.md (박지영 PL 영역). 본 doc Sec.9는 M4 스냅샷 유지. |
| F-X-7-#3 | 자율 영역 (v2 흡수 유지) | Sec.4.4 dedupe | TTL 5분 박힘. v3 변경 없음. |
| F-M4-S5-1 | Stage 5 이월 (v2 흡수 유지) | Sec.9 | 알림 채널 최종 선택 = 운영자 결정 게이트(Q-M4-2). v3 변경 없음. |

> **finalizer 흡수 결과:** 본 v3는 drafter 권한 밖 정책 commit 2건(F-D1 / F-D2)을 본문 결정 문장으로 닫고, 횡단 영역 1건(F-X-3)을 planning_index 포인터로 정리했습니다. 본 stage 잔존 운영자 결정 = **Q-M4-2 Pushover 비용 (Stage 4.5 게이트, reviewer 권장: 회피)** + **Q-M4-3 CCNotify 존재 (Stage 4.5, reviewer 권장: 신설 또는 제외)**. Stage 5 영역 = Q-M4-1/4/5/6 (알림 정책 / Pending 데이터 소스 / Push vs Commit / 우선도 필터링).

### Sec. 0.2 v1 요약

M4는 대시보드의 두 개 하단 박스(**Pending Push/Commit** 및 **Pending Decisions(Q)**)를 구현하고, Pending Q 도착 시 운영자에게 macOS 시스템 알림을 발화하는 단계입니다. 이는 M2(데이터 수집) 결과를 활용하여 대시보드의 "액션 신호" 영역을 완성합니다. 알림 채널 선택(osascript / Pushover / CCNotify)은 Stage 5 기술 설계에서 결정되며, 본 stage는 인터페이스 정의와 prototype에 집중합니다.

---

## Sec. 1. 목적 (Purpose)

Jonelab AI팀 운영자 대시보드에서 가장 중요한 정보는 **운영자 결정 대기 영역(Q)**과 **push/commit 승인 대기 항목**입니다. M4는 이 두 정보를 명확하게 표시하고, 새로운 Pending Q 도착 시 운영자를 즉시 알리는 역할을 합니다. 구체적으로:

1. **Pending Push/Commit 박스** — 운영자 승인 대기 중인 git push 또는 commit 항목을 표시합니다. M2 데이터 layer가 git status와 페르소나 보고에서 이 정보를 수집하며, M4는 시각화를 담당합니다.

2. **Pending Decisions(Q) 박스** — 운영자 결정이 필요한 항목(회의창 dispatch 또는 오케 보고에서 "운영자 결정 필요" 표지 캐치)을 큐로 나열합니다. read-only 정책에 따라, 클릭 → deep-link는 v0.6.5+로 이월합니다.

3. **macOS 시스템 알림** — 새로운 Pending Q 항목이 도착할 때마다 1회 burst 알림을 발화하며, 중복 발화 방지 메커니즘을 구현합니다.

4. **알림 채널 비교** — osascript (macOS native) / Pushover (외부 API) / CCNotify (jOneFlow 내부) 세 옵션의 장단점을 정리하고, Stage 5에서 채택 기준을 명시합니다.

---

## Sec. 2. 범위 (Scope)

### 변경 항목 (M4에서 구현 — v2 F-M4-1 / F-D2 후보 위치 통일)

> **v2:** v1의 `dashboard/...` 위치를 회수하고 M1/M3와 통일된 `scripts/dashboard/...` 패키지로 박았습니다. F-D2 정책 commit이 plan_final 본문에 박히면 본 위치 확정.

- `scripts/dashboard/pending.py` — Pending Push 및 Pending Q 데이터 구조 정의 (dataclass / namedtuple)
- `scripts/dashboard/ui/pending_widgets.py` — textual 렌더링 컴포넌트 (두 개 박스 = PendingPushBox / PendingQBox)
- `scripts/dashboard/notifier.py` — 알림 channel abstraction + dedupe 메커니즘 (osascript / Pushover / CCNotify placeholder)
- `scripts/dashboard/data_adapters.py` (M2와 협력) — M2 데이터 layer 결과에서 Pending Push/Q 추출 로직 (**v2 F-M4-4:** PendingDataCollector 신규 클래스로 분리)
- `requirements.txt` — 알림 채널 외부 의존성 (필요 시, 예: `pushover-client` 선택 시 — Q-M4-2 운영자 결정 영역)

### 미변경 항목 (read-only 정책)

- 대시보드는 **표시만**, 응답/입력은 영구 제외합니다. Pending Q deep-link(클릭 → 회의창 활성화) = **v0.6.5+ 이월** (brainstorm 의제 5).
- write 영역 진입 금지: 대시보드에서 push/commit 승인/거절 직접 입력, Q 응답 입력 등은 모두 v0.6.4 scope 외입니다.
- 회의창 흐름 유지: Q 응답은 기존 회의창 dispatch 절차 그대로 운영합니다.

---

## Sec. 3. 변경 대상 파일

> **v3 finalizer (F-D2 정책 commit 본문 결정):** 본 M4 산출물 위치는 다음과 같이 단일화합니다 (M1/M3와 통일).
> 1. **데이터 모델:** `scripts/dashboard/pending.py` — `PendingPush` / `PendingQuestion` dataclass.
> 2. **UI 위젯:** `scripts/dashboard/ui/pending_widgets.py` — `PendingPushBox` / `PendingQBox` textual 위젯.
> 3. **알림 abstraction:** `scripts/dashboard/notifier.py` — `Notifier` ABC + 3채널 stub.
> 4. **M2 협력:** `scripts/dashboard/data_adapters.py` — `PendingDataCollector` (F-D1 본문 결정 흡수, Sec.4.5).
> 5. **호출 위치:** `scripts/dashboard.py` (M1 진입점)의 `compose()`에서 PendingPushBox + PendingQBox 추가.
>
> 본 결정으로 v1의 `dashboard/...` 위치 후보를 닫고 M1/M3/M4 위치 일관성을 확보합니다. 본 결정은 reviewer 권장(planning_review.md F-D2, F-M4-1) verbatim 흡수입니다.

| 파일 | 섹션/영역 | 작업 | 라인 수 예상 |
|------|---------|------|-----------|
| `scripts/dashboard/pending.py` | (신규, **v3 F-D2 본문 결정**) | Pending Push / Pending Q 데이터 모델 | ~80 |
| `scripts/dashboard/ui/pending_widgets.py` | (신규) | PendingPushBox, PendingQBox textual 위젯 | ~120 |
| `scripts/dashboard/notifier.py` | (신규) | 알림 abstraction layer (3채널 placeholder) | ~100 |
| `scripts/dashboard/data_adapters.py` (M2 협력) | (신규, **v3 F-D1 본문 결정**) | `PendingDataCollector` — M2 PersonaDataCollector와 SRP 분리 | ~80 |
| `scripts/dashboard.py` (M1 기반) | compose() | PendingPushBox + PendingQBox 추가 | ~20 |
| `requirements.txt` | 의존성 | 알림 채널 선택 시 외부 pkg (Stage 5, Q-M4-2 운영자 결정) | 0~3 |

---

## Sec. 4. 단계별 작업 분해

### 4.1 Pending Push/Commit 데이터 구조

운영자 승인 대기 중인 git 항목을 표현합니다:

```python
@dataclass
class PendingPush:
    item_id: str                  # "push-001", "commit-002" 등
    item_type: str                # "push" | "commit"
    description: str              # "v0.6.4 Stage 2 planning commit"
    timestamp: datetime           # 발견 시점
    initiator: str                # 페르소나 이름 (예: "박지영")
    severity: str                 # "high" | "medium" | "low" 잠정
```

**데이터 수집 방식 (M2와 협력):**
- `git status` 파싱 → unmerged changes / unpushed commits 캐치
- 페르소나 보고 파일(예: dispatch md의 "push 대기" 섹션) 정규식 매칭
- M2가 주기적으로(1~2초) 갱신하면 M4가 소비합니다.

### 4.2 Pending Decisions(Q) 데이터 구조

운영자 결정 영역을 표현합니다:

```python
@dataclass
class PendingQuestion:
    q_id: str                     # "Q1", "Q5", "Q-NEW-1" 등 (dispatch/HANDOFF 표준)
    category: str                 # "scope" | "decision" | "risk" | "approval" 등
    description: str              # 결정 사항 (예: "18명 페르소나 가동 시점")
    source: str                   # "dispatch/..._planning.md" | "HANDOFF.md" 등
    timestamp: datetime           # 발견 시점
    priority: str                 # "critical" | "high" | "medium" | "low"
```

**데이터 수집 방식 (M2와 협력):**
- dispatch md / HANDOFF.md 파싱 → "운영자 결정 필요", "Q\d+" 패턴 정규식 매칭
- 회의창이 브릿지에 보고한 capture-pane 스냅샷(monitor 결과)에서 "운영자 결정" 키워드 캐치
- 중복 제거(dedupe) — 동일 Q가 여러 바퀴 캐치되지 않도록 hasher 기반 추적

### 4.3 UI 컴포넌트 — Pending 박스 렌더링

**PendingPushBox:**
```
┌── Pending Push/Commit ──┐
│ ⏳ v0.6.4 Stage 2 planning commit
│    Initiator: 박지영
│ ⏳ push (v0.6.3) — 대기 중
└─────────────────────────┘
```

**PendingQBox:**
```
┌── Pending Decisions (Q) ──┐
│ • Q5: 18명 페르소나 가동 시점
│   Source: planning_01_org.md
│ • Q-NEW-1: 알림 채널 선택
│   Priority: high
└─────────────────────────────┘
```

**textual 구현 포인트:**
- textual `Container` + `Static` 컴포넌트로 박스 경계 그리기 (CSS border styling)
- 각 항목은 `Label` + 타임스탬프 표시
- 빈 큐 표시: "No pending decisions" 또는 "✓ 대기 항목 없음"
- 정렬 순서: 시간순(역순) 또는 priority순 (오케 자율)

### 4.4 알림 채널 abstraction

**인터페이스 정의 (후보 3개, Stage 5에서 선택):**

```python
class Notifier(ABC):
    """알림 채널 abstraction"""
    def notify(self, q: PendingQuestion) -> bool:
        """Pending Q 도착 시 호출. 성공 시 True"""
        pass
```

**Channel A: osascript (macOS native)**
- 장점: 외부 의존성 0, 즉시 사용 가능, macOS 시스템 알림센터 통합
- 단점: macOS 한정, 알림센터 저장 옵션 제한
- 구현: `subprocess.run(['osascript', '-e', 'display notification ...'])`
- 비용: 0

**Channel B: Pushover (외부 서비스)**
- 장점: cross-device (iPhone/iPad/web), 정교한 필터링, 아카이브 기능
- 단점: 외부 API + 비용(월 $5) + 토큰 관리 + 인터넷 필수
- 구현: `requests.post('https://api.pushover.net/...')`
- 비용: 유료

**Channel C: CCNotify (jOneFlow 내부) — v2 (F-M4-3 흡수)**
- **상태: 현재 미확인** — jOneFlow 리포에 `CCNotify` 문자열 0건(코드 + dispatch + brainstorm 모두). brainstorm 자유 토론 단계 명명일 뿐 실체 미확인 영역.
- 채택 시: jOneFlow 자체 알림 인프라 신설 가능성 영역 — Stage 5 결정 시점에 (a) 신설 + 채택 또는 (b) 제외 결정 필요.
- 장점 (가설): 내부 통합, 프로토콜 표준화, 장기 확장성
- 단점: 신설 비용 + 본 v0.6.4 scope 불명확
- 구현: Q-M4-3을 운영자 결정 게이트로 분류 (Stage 4.5)

**dedupe 메커니즘 — v2 (F-X-7-#3 흡수):**
- **TTL = 5분 권장** (brainstorm 단순성 우선, 10분/60초 옵션 회수)
- 해시 기반: `sha256(q_id + timestamp 초 단위)` → 5분 내 중복 발화 방지
- 구현: simple dict 캐시 또는 `functools.lru_cache` with TTL=300s

### 4.5 M2와의 협력 계약 — v3 F-D1 본문 결정 박음

> **v3 finalizer (F-D1 정책 commit 본문 결정):** 본 v0.6.4 데이터 수집 구조는 SRP 기준으로 다음과 같이 분리합니다.
> 1. **`PersonaDataCollector` (M2)** — 페르소나 상태 수집 책임. `fetch_all_personas()` / `fetch_team()` / `persona_by_name()`. 입출력 dataclass = `PersonaState`.
> 2. **`PendingDataCollector` (M4, 신규)** — Pending Push/Q 수집 책임. `get_pending_pushes()` / `get_pending_questions()`. 입출력 dataclass = `PendingPush` / `PendingQuestion`.
>
> 본 결정으로 v1의 `class DataCollector`가 M2 `PersonaDataCollector`와 클래스명·메서드 시그니처 충돌하던 문제를 닫습니다. M2/M4 독립 진행 가능 — M2 final이 PersonaDataCollector만 제공하고, M4 final은 본 `PendingDataCollector`를 본인 영역(`scripts/dashboard/data_adapters.py`)에 둡니다. 본 결정은 reviewer 권장(planning_review.md F-D1, F-X-1 흡수, M4 v1 `DataCollector` 분리 옵션 (1) 권장) verbatim 흡수입니다.

```python
class PendingDataCollector:
    """M4 — Pending Push/Q 수집 (v3 F-D1 본문 결정: M2 PersonaDataCollector와 SRP 분리)"""

    def get_pending_pushes(self) -> List[PendingPush]:
        """현재 대기 중인 push/commit 목록"""
        ...

    def get_pending_questions(self) -> List[PendingQuestion]:
        """현재 대기 중인 Q 목록"""
        ...
```

M4 widget은 이 인터페이스를 consume하며, 갱신 주기는 M2 PersonaDataCollector와 동일 polling 주기(brainstorm 1~2초)를 따릅니다. sync vs async 결정은 F-D4(M2 본문 결정 박힘)와 통일 — 본 stage는 sync(`def`) 시작.

### 4.6 통합 테스트

- Pending 데이터 구조 import 가능 확인 (python3 -m py_compile)
- textual 렌더링 (샘플 dummy data로 박스 표시 확인)
- 알림 abstraction layer — 3개 채널 stub로 구현 가능성 검증
- M2 인터페이스 호환성 (M2 완료 후 통합 테스트)

---

## Sec. 5. AC (Acceptance Criteria)

| AC ID | 기준 | 측정: 자동/수동 | 측정 명령/방법 |
|-------|------|------------------|-------------|
| **AC-M4-N1** | Pending Push 데이터 구조 정의 완료. `@dataclass PendingPush` with item_id, item_type, description, timestamp, initiator, severity 필드. | 자동 | `grep -c "@dataclass\|class PendingPush" scripts/dashboard/pending.py` ≥ 1 |
| **AC-M4-N2** | Pending Questions 데이터 구조 정의 완료. `@dataclass PendingQuestion` with q_id, category, description, source, timestamp, priority 필드. | 자동 | `grep -c "@dataclass\|class PendingQuestion" scripts/dashboard/pending.py` ≥ 1 |
| **AC-M4-N3** | textual UI 컴포넌트 (PendingPushBox, PendingQBox) 렌더링 가능. M1 App의 compose()에 통합 시 오류 0건. | 자동 | `python3 -c "from scripts.dashboard.ui.pending_widgets import *"` 성공 |
| **AC-M4-N4** | Pending 박스 화면 표시. 샘플 데이터(2~3개 pending item)로 textual 실행 시 박스 경계 + 항목 텍스트가 가시적으로 표시. (**v2 F-M4-2 정정:** % 기준 회수, 수치화 불가 영역 visual로) | 수동 | 대시보드 텍스트 UI에서 "┌──" 경계 명확, 항목 텍스트 보임 (visual 수동 검사) |
| **AC-M4-N5** | 빈 큐 표시. Pending 목록이 공(empty)일 때 "No pending" 또는 "✓ 대기 항목 없음" 등가 메시지 표시. (**v2 F-M4-2 자동화**) | 자동 | `grep -cE "No pending\|✓ 대기" scripts/dashboard/ui/pending_widgets.py` ≥ 1 |
| **AC-M4-N6** | 알림 abstraction layer 정의. `class Notifier(ABC)` with `notify(q: PendingQuestion) -> bool` 메서드. 3개 채널(osascript / Pushover / CCNotify-미확인) stub 구현 가능 여부 확인. | 자동 | `grep -c "class Notifier\|def notify" scripts/dashboard/notifier.py` ≥ 1, stub 3개 가능성 검증 |
| **AC-M4-N7** | dedupe 메커니즘 구현. **TTL 5분** 내 동일 Q의 중복 알림 발화 제거 (테스트: 같은 Q_id 시뮬레이션 × 2회 → 첫 알림만 발화). (**v2 F-M4-2 자동화 + F-X-7-#3 TTL 박음**) | 자동 | `pytest -k test_dedupe_5min scripts/dashboard/tests/` (단위 테스트 함수명 박음) |
| **AC-M4-N8** | M2 / M4 협력 계약 정의. **v2:** M2 `PersonaDataCollector` + M4 신규 `PendingDataCollector` 분리(F-D1 후보). | 자동 | `grep -cE "PendingDataCollector\|get_pending" scripts/dashboard/data_adapters.py` ≥ 1 |
| **AC-M4-N9** | read-only 정책 명시. M4 파일 어디에도 write 로직(commit/push 승인 입력, Q 응답 입력) 0건. (**reviewer 환영 — 5개 doc read-only AC 표준 reference**) | 자동 | `grep -cE "git push\|git commit\|open\(.*['\"]w['\"]" scripts/dashboard/pending*.py scripts/dashboard/notifier.py 2>/dev/null \| awk -F: '{s+=$2} END{print s+0}'` = 0 |
| **AC-M4-N10** | Stage 5 이월 영역 명확화. 알림 채널 최종 선택, dedupe 알고리즘 고도화, Pending 캐치 hook 방식 등 3개 이월 항목 문서화. (**v2 F-M4-2 자동화**) | 자동 | `grep -c "F-M4-S5" docs/02_planning_v0.6.4/planning_04_M4_pending_notif.md` ≥ 3 |

---

## Sec. 6. 의존성

### 내부 의존성

- **M2 데이터 수집 layer** — `DataCollector` 인터페이스. M2 완료 후 M4 통합 테스트 시작.
- **M1 textual App** — M4가 M1의 `compose()` 메서드에 PendingPushBox + PendingQBox 추가. M1 framework 호환성 필수.
- **M3 렌더링** (선택적) — Pending 박스와 팀별 박스 3개의 layout 공존 검증. M3와 병렬 진행 시 최종 통합.

### 외부 의존성

- **osascript** (macOS only) — 설치 불필요 (native)
- **Pushover SDK** (선택적, Channel B 선택 시) — `pip install pushover`
- **CCNotify** (선택적, Channel C 선택 시) — 현재 미확인, 검증 필요

### 다른 planning 항목과의 관계

**선행 조건:**
- **M2 (planning_02_M2_data.md)** — 완료 필수. Pending 데이터 수집이 M4 구현의 전제.

**병렬 가능:**
- **M1, M3, M5** — M4는 독립적 UI 컴포넌트이므로 다른 마일스톤과 병렬 개발 가능.

**후행 조건:**
- **Stage 5 기술 설계** — 알림 채널 최종 선택 (osascript/Pushover/CCNotify).
- **Stage 6/7 (디자인팀)** — Pending 박스 색상, 아이콘, 우선도 색깔 등 디자인 정의.

---

## Sec. 7. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 |
|----|--------|-----------|--------|------|
| R1 | M2 데이터 수집이 지연되면 M4 통합 테스트 불가 | 중 | 중 | M4는 stub DataCollector로 먼저 UI 검증. M2 완료 후 통합. |
| R2 | Pending 데이터 파싱 오류 (dispatch md 정규식 실패) → 운영자가 보지 못하는 Q 발생 | 중 | 높음 | Stage 5에서 dispatch md 정규식 표준화. 테스트 케이스(Q1~Q5 샘플) 작성. |
| R3 | 알림 중복 발화 → 운영자 피로, 알림센터 폭주 | 높음 | 중 | dedupe 메커니즘 필수. 테스트: 같은 Q × 3회 → 첫 알림만 발화 검증. |
| R4 | osascript (Channel A) 만 구현 후 나중에 Pushover 추가 시 refactoring 비용 | 중 | 낮음 | abstraction layer (Notifier ABC) 먼저 설계. 3개 채널 stub로 호환성 선 검증. |
| R5 | read-only 정책 위반 위험 (개발자가 실수로 Q 응답 input 로직 추가) | 낮음 | 높음 | AC-M4-N9에서 자동 검증 (grep for write 0건). **v2 (F-M4-5 흡수):** Stage 8에서 git pre-commit hook 추가 권장 — F-X-2 횡단 정책 commit과 한 묶음. Stage 8/9 모두에서 정책 강제. |
| R6 | Windows 호환성 문제 (osascript는 macOS only) | 높음 | 중 | Channel B(Pushover) 또는 C(CCNotify)를 Windows 기본값으로 Stage 5 검토. M5 검증 단계에서 Windows 테스트 (WSL 또는 실제 환경). |

---

## Sec. 8. 열린 질문 (Stage 3 plan_review에서 판단 → v2 분류)

> **v2 reviewer 분류:**
> - 운영자 결정 게이트(Stage 4.5): Q-M4-2(비용), Q-M4-3(CCNotify 존재 → v2 F-M4-3 흡수)
> - Stage 5 기술 설계: Q-M4-1, Q-M4-4, Q-M4-5, Q-M4-6
> - finalizer 결정 가능: dedupe TTL = **5분 박힘** (F-X-7-#3 흡수)

| # | 질문 | 범주 | 판단 책임 |
|---|------|------|----------|
| **Q-M4-1** | **macOS 알림 정책** — osascript `display notification`은 알림센터에 저장되지 않는 경우가 있습니다. 운영자가 알림을 놓칠 수 있습니다. 알림센터 강제 저장(macOS Notifications.app)이 필요한가요? | scope | Stage 5 기술 설계 |
| **Q-M4-2** | **Pushover 비용** — Pushover는 일회성 구독($5/month) 또는 영구 라이선스($30 일회)입니다. jOneFlow 프로젝트 차원에서 비용 부담 가능한가요? **v2 reviewer 권장: 회피 (osascript 기본 + Stage 5에서 plyer cross-platform 검토)**. | decision | **운영자 결정 게이트 (Stage 4.5)** |
| **Q-M4-3** | **CCNotify 존재 확인** — **v2 (F-M4-3 흡수): 현재 jOneFlow 리포에 CCNotify 0건. Stage 5에서 신설 + 채택 또는 제외 결정.** | scope | **운영자 결정 게이트 (Stage 4.5)** |
| **Q-M4-4** | **Pending Q 데이터 소스** — dispatch md의 "운영자 결정 필요" 표지가 표준화되어 있나요? (예: `## 중단 조건` 섹션 아래 "Q\d+" 패턴 고정?) 정규식 설계에 필요합니다. | scope | Stage 5 기술 설계 |
| **Q-M4-5** | **Pending Push vs Pending Commit 구분** — `git status`로는 unmerged changes / unpushed commits을 구분하기 어렵습니다. 페르소나 자가 보고(예: "push 대기 항목: ...") 방식이 더 정확한가요? | technical | Stage 5 기술 설계 (F-D1 데이터 수집 방식과 sync) |
| **Q-M4-6** | **알림 우선도 필터링** — Pending Q가 10개 이상 쌓일 경우, 모두 알림할까요 아니면 priority > "high"만? | decision | Stage 5 기술 설계 |

---

## Sec. 9. Stage 5 이월 (기술 설계 영역)

본 plan_final은 **무엇을(What)** 중심이며, **어떻게(How)** 구현할지는 Stage 5 기술 설계에서 결정합니다.

> **v3 (F-X-3 통합 표 finalizer 흡수):** 본 doc Sec.9는 M4 스냅샷으로 보존하며, 5개 doc 합산 통합 Stage 5 이월 표는 **`planning_index.md` 단일 source of truth**(박지영 PL 영역)로 수렴합니다. F-M4-S5-1(알림 채널)은 운영자 결정 게이트 등급(Q-M4-2 비용 영향) — Stage 4.5 답변 후 plan_final 본문에 verbatim 박힘 예정.

| 이월 ID | 내용 | 담당 | 필수성 |
|--------|------|------|--------|
| **F-M4-S5-1** | **알림 채널 최종 선택** — osascript (A) / Pushover (B) / CCNotify-미확인 (C) 중 선택. Q-M4-2/Q-M4-3 답변 기반. **v2 reviewer 권장: osascript 기본 + plyer cross-platform 검토**. | **운영자 결정 게이트** + Stage 5 (오케) | **필수** |
| **F-M4-S5-2** | **Pending 캐치 hook 정의** — dispatch md 정규식 표준화 (Q\d+ 패턴 고정) + capture-pane 파싱 vs 자가 보고 방식 최종 결정. | Stage 5 기술 설계 (오케) | **필수** |
| **F-M4-S5-3** | **dedupe 알고리즘 고도화** — 해시 캐시 크기 상세 정의 + 테스트 케이스 작성. **v2 (F-X-7-#3 흡수): TTL = 5분 박힘.** | Stage 5 기술 설계 (오케) | 권장 |
| **F-M4-S5-4** | **alarms 우선도 필터링** — Q-M4-6 기반. priority >= "high"만 알림할 경우 필터 로직 + 설정값 `.claude/settings.json`에 추가. | Stage 5 기술 설계 (오케) | 선택 |
| **F-M4-S5-5** | **Windows 호환성 전략** — Channel A(osascript) macOS only → Channel B/C 대체 경로 또는 WSL 환경 검증 (M5 stage에서 최종 검증). | Stage 5 기술 설계 (오케) | 권장 |

---

## Sec. 10. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-27 | v1 초안 (세션 27) | brainstorm.md 의제 4, 의제 6 기반. Pending Push/Q 범위 정의 + 알림 3채널 옵션 정리 + AC 10개 정의 |
| 2026-04-27 | v2 revised (장그래 drafter, 세션 27 후속) | Stage 3 plan_review 흡수 9건 (F-M4-1~5 + F-X-1/F-X-2 + F-X-7-#3 + F-M4-S5-1 운영자 게이트 등급). 위치 `scripts/dashboard/...` 통일. PendingDataCollector 분리(F-D1 후보). CCNotify 미확인 명시. dedupe TTL 5분 박힘. R5 git pre-commit hook 권장. AC-M4-N4 % 회수, N5/N7/N10 자동화. AC 자동성 9/10 (5개 doc 최상). |
| 2026-04-27 | **v3 final** (안영이 finalizer, 기획팀 선임연구원 Sonnet/medium) | v2 위에 정책 commit 본문 결정 박음 — **F-D1** Sec.4.5 머리말(`PendingDataCollector` M4 신규, M2 PersonaDataCollector와 SRP 분리 — `get_pending_pushes()` / `get_pending_questions()` 책임 영구 분리), **F-D2** Sec.3 머리말(`scripts/dashboard/pending.py` + `notifier.py` + `data_adapters.py` + `ui/pending_widgets.py` 위치 본문 박음). 횡단 흡수: F-X-3 Sec.9 머리말(planning_index 통합 포인터). 잔존 운영자 결정 = Q-M4-2 Pushover 비용(Stage 4.5) + Q-M4-3 CCNotify 존재(Stage 4.5). status: pending_operator_approval. AC-M4-N9 5개 doc read-only 표준 reference 유지. plan_draft 5종은 Stage 2 스냅샷 보존. |

---

---

## 다음 단계

### Stage 3 plan_review (김민교 책임연구원)

- Sec.1~7 범위/AC/의존성 검증
- Q-M4-1~Q-M4-6 판단 (또는 Stage 4 finalizer로 이월)
- M2와 M4 통합 인터페이스 호환성 검토
- AC 평가: pass/fail 명시

### Stage 4 plan_final (안영이 선임연구원)

- 피드백 흡수 → v2 개정
- AC 최종 확정
- 의존 그래프 (M2, M3과의 순서) 수렴

### Stage 5 기술 설계 (오케 박지영)

- 알림 채널 최종 선택 (osascript/Pushover/CCNotify)
- Pending 데이터 수집 hook (capture-pane/자가 보고)
- dedupe, 우선도 필터링, Windows 호환 전략 정의
- 실제 구현 순서(M4 병렬 vs 순차) 결정

---

## 첨부: 참고 자료

### brainstorm.md 의제 4 인용 (표시 항목)

```
박스 3개 (기획/디자인/개발) + Pending Push/Commit + Pending Decisions(Q)

┌── Pending Push/Commit ──┐  ┌── Pending Decisions (Q) ──┐
│ ⏳ <항목>                │  │ • <Q>                       │
└─────────────────────────┘  └─────────────────────────────┘
```

### brainstorm.md 의제 6 인용 (알림)

```
**알림** — Pending Q 도착 시 macOS 시스템 알림 발화 
(Stage 5 기술 설계에서 osascript / Pushover / CCNotify 중 선택). 
read-only 가시화의 "보조 신호"라 v0.6.4 scope.
```

### 알림 채널 비교표 (brainstorm 인용)

| 옵션 | 장점 | 단점 | 채택 시점 |
|------|------|------|----------|
| A. osascript `display notification` | 외부 의존 0, 즉시 사용 가능 | macOS 한정, 알림센터 미저장 옵션 | Stage 5 |
| B. Pushover (외부 서비스) | iPhone 등 cross-device | 외부 API + 비용 + 토큰 관리 | Stage 5 |
| C. CCNotify (jOneFlow 자체) | 내부 통합 | CCNotify 존재 여부 검증 필요 | Stage 5 |
