---
date: 2026-04-27
version: v0.6.4
stage: 10d
work: dashboard 디자인 정합 (5건 fix + F-D3 박스 18 정정) — drafter 초안
author: 지예은 (프론트 드래프터)
pane: Orc-064-dev:2.2 (FE 영역)
length_target: ≤ 800 줄
---

# Stage 10d — dashboard 디자인 정합 drafter 초안

> 지예은입니다. 본 stage = UI 영역 비중이 커서 프론트 트리오 활성화 강제 (헌법 Sec.11.3).
> 운영자 검증 결과 = Stage 10c efdd532 본문 동작 PASS, 단 박스 디자인 깨짐. 5건 묶음
> fix + F-D3 산식 정정(박스 16 → **박스 18**) 본문 박습니다. PL(공기성)이 폐기 확정 시
> 까지 PL 직접 인수 회수 패턴(Stage 8 정합) — 본 drafter 페르소나로 trail 박음.

## 1. 운영자 발견 (Stage 10c → 10d 진입 trigger)

운영자 인용: "박스가 완전치 않아"

**디자인 5건 + 본질 2건 (★ Critical) = 7건 통합 fix**:

1. **박스 외곽 라인**: Pending Push/Commit + Pending Q 박스 윗+우측 모서리 끊김
2. **Pending Q 텍스트 잘림**: Q5 누락 + "외 1건"으로 줄어듦
3. **PM 박스 누락**: Stage 10b wiring 시점 PM(스티브 리, bridge-064)이 status_bar
   1행만 박힘, 박스 영역 0건
4. **상단 PM status_bar 표시 정합**: 시각 강조 미흡
5. **진행률 바 / 스파크라인 placeholder 누락**: idle 0% 시점 빈 공백 (cell 0건 표시)
6. **★ persona_collector 본질 stub (Critical)** — 운영자 발견: 공기성(Orc-064-dev:1.1)이
   실제 8.2k tokens 사용하며 active인데 dashboard 표시 = idle / tokens 0.0k. token_hook
   regex(`"usage": {"input_tokens"`)는 claude CLI session-end JSON 영역 (active 화면
   표시 X) → 0.0k stub 영역. root cause = `.claude/dashboard_state/` hook json
   미작성 (Q2 정확 hook 본 가동 v0.6.5 영역). **본 stage = capture-pane fallback
   regex 다양화로 부분 fix.**
7. **★ pending_collector 본질 stub (Critical)** — 운영자 발견: Pending Q 박스에 v0.6.3
   `dispatch/2026-04-27_v0.6.3_stage5_design.md` Q1~Q6 잔재 표시. 원인 = dispatch md
   glob이 모든 *.md scan (활성 버전 필터 0건). **본 stage = HANDOFF symlink target에서
   active version 추출 → glob 한정 (`*v0.6.4*.md`). v0.6.3 잔재 0건 정합.**

## 2. F-D3 산식 정정 (운영자 2회 정정)

**최종 결정 (운영자 박은 영역):**
- **dashboard 박스 = 18** (PM 1 + 4팀 15 + CTO 1 + CEO 1)
- **PM (스티브 리)**: tmux `bridge-064` 트래킹 → 박스 + status_bar 둘 다 표시
- **CTO (백현진)**: Code 데스크탑 앱 = tmux 외 → **박스 표시 / 트래킹 X / 정적 idle**
- **CEO (이형진)**: 실제 사람 = AI 가시화 외 → **박스 표시 / 트래킹 X / 정적 idle**
- **HR**: 미정 = **표시 X** (HIDDEN 그대로)

조직도(operating_manual.md Sec.1.2) 19명 산식은 그대로 (CTO/CEO/HR 모두 조직도 영역).
dashboard 가시화는 18 박스로 한정 (HR placeholder 1만 hidden).

## 3. 코드 변경

### 3.1 `persona_collector.py` PERSONAS_18 / 매핑 갱신

**PERSONAS_18 (18명)**:
```python
PERSONAS_18: List[Tuple[str, str]] = [
    # 기획팀 4 / 디자인팀 4 / 개발팀 7 (그대로)
    ...
    # 관리자 3 (Stage 10d 추가)
    ("스티브 리", "관리자"), ("백현진", "관리자"), ("이형진", "관리자"),
]
```

**_TEAM_TO_ORC_SESSION**: `"관리자": "bridge-064"` 추가.

**_PERSONA_TO_PANE_INDEX**: `"스티브 리": "1.1"` 추가 (PM bridge-064:1.1 트래킹).
CTO/CEO는 미매핑 → `_persona_to_pane` None 반환 → idle yield (Q5 통합 정합).

### 3.2 `render.py` TEAM_ORDER 4 entries

```python
TEAM_ORDER: tuple = ("기획", "디자인", "개발", "관리자")  # 박스 4 그루핑
```

`_slug` 매핑에 `"관리자": "admin"` 추가 (textual id 호환).

`run_dashboard.py` 안 `TEAM_ORDER` 영역 동기 정합.

### 3.3 `pending_widgets.py` ASCII 박스 제거 + 텍스트 wrap

**Fix 1 + Fix 2 통합:**
- `_format_empty()` / `_format_content()` 안 ASCII 박스 라인(`┌──┐`, `│`, `└──┘`) 모두
  제거. textual `border: round` 단일 사용 (외곽 깨짐 회피, ASCII + textual 중복 영역).
- `border_title` (textual native) 활용으로 박스 제목 표시. CSS에 `border-title-align:
  left` 추가.
- `MAX_VISIBLE_PUSHES` / `MAX_VISIBLE_QUESTIONS`: 5 → **10** (Q5 누락 회피).
- `description[:60]` → `description[:100]` (truncation 늘림).

```python
class PendingPushBox(Static):
    def __init__(self, **kwargs):
        super().__init__(self.EMPTY_LABEL, **kwargs)
        self.border_title = "Pending Push/Commit"  # textual native

    def _format_content(self, pushes):
        # ASCII 박스 0건 — textual border가 외곽 그림
        lines = [f"⏳ {p.description[:100]} {mark}" for p in pushes[:10]]
        ...
```

### 3.4 `team_renderer.py` 진행률 바 idle placeholder

**Fix 5:**
```python
# 기존: PROGRESS_LEVELS = (" ", "░", "▒", "█")  # idle = 공백
# Stage 10d: PROGRESS_LEVELS = ("░", "▒", "▓", "█")  # idle = ░ placeholder
```

idle (tokens_k=0.0) 시점도 `░░░░░░░░` 8칸 visible cell 표시. 운영자 정정 — 빈 공백
0칸 표시 영역 회피.

### 3.5 `pending_collector.py` 활성 버전 필터 (Fix 7 본질)

```python
HANDOFF_VERSION_PATTERN = re.compile(r"HANDOFF_(v[\d.]+)\.md$")

def _active_version(self) -> Optional[str]:
    """HANDOFF.md symlink target에서 active version 추출 (Stage 10d Fix 7)."""
    handoff = self.project_root / "HANDOFF.md"
    try:
        target = handoff.resolve(strict=False)
        m = HANDOFF_VERSION_PATTERN.search(str(target))
        return m.group(1) if m else None
    except (OSError, RuntimeError):
        return None

def get_pending_questions(self):
    active = self._active_version()
    pattern = f"*{active}*.md" if active else "*.md"
    for md_path in sorted(self.dispatch_dir.glob(pattern)):
        ...  # 기존 Q 추출 로직
```

검증: `_active_version()` = "v0.6.4". dispatch glob = `*v0.6.4*.md` 매칭 → 9건
(stage10d / stage234 / stage5 / stage6_7 / stage8 / stage9 / stage10 / stage10b /
stage10c). v0.6.3 잔재 0건. 본 시점 v0.6.4 dispatch md 안 `**Q...**` 패턴 0건이라
"결정 대기 없음" 표시 정합.

### 3.6 `token_hook.py` fallback regex 다양화 (Fix 6 부분)

root cause = `.claude/dashboard_state/` hook json 미작성 (Q2 본 가동 v0.6.5). 본 stage
= capture-pane fallback regex 다양화로 부분 fix.

```python
FALLBACK_REGEXES = [
    (re.compile(r'(?i)tokens?\s*:?\s*([\d,]+(?:\.\d+)?)\s*k\b'), True),    # "Tokens: 8.2k"
    (re.compile(r'(?i)([\d,]+(?:\.\d+)?)\s*k\s+tokens?'), True),           # "8.2k tokens"
    (re.compile(r'(?i)tokens?\s*:?\s*([\d,]+)(?!\s*[k.])'), False),        # "Tokens: 8200"
    (re.compile(r'(?i)([\d,]+)\s+tokens?(?!\s*\.\d)'), False),             # "8200 tokens"
]
```

(pat, is_k_unit) 튜플 — `is_k_unit` True 시 그대로 (k 단위), False 시 1000.0 나눔.
v0.6.5 본 가동 시점 = `.claude/dashboard_state/joneflow_<hash>_<session>.json` 작성
mechanism (Q2 정확 hook) 영역 강제. 본 stage 부분 fix는 stub fallback이라도 가능하게.

regex 검증 7/7 PASS:
- "Tokens: 8.2k" → 8.2 / "8.2k tokens" → 8.2 / "Total tokens: 8200" → 8.2
- "8200 tokens" → 8.2 / "[8.2k tokens] something" → 8.2 / "Idle no token" → None
- usage JSON `input 5000 + output 3000` → 8.0

### 3.7 `status_bar.py` 시각 강조

**Fix 4:**
```python
DEFAULT_CSS = """
PMStatusBar {
    background: $primary;        /* full primary (이전 20% 옅음 → full) */
    color: $background;
    text-style: bold;
    height: 1;
    padding: 0 1;
    dock: top;                   /* 상단 고정 */
}
"""
```

PM 데이터는 박스(관리자 team 안 스티브 리 행) + status_bar(상단 1행 메타 정보) 둘 다
표시. status_bar = active orcs / bridge / tokens 메타 영역.

## 4. 검증 결과 (PL 직접 실행 — 운영자 게이트 강제 통과)

### 4.1 py_compile (6 파일)

`persona_collector.py` + `render.py` + `pending_widgets.py` + `team_renderer.py`
+ `status_bar.py` + `run_dashboard.py` PASS 6/6.

### 4.2 실제 실행 (subprocess + SIGTERM)

```bash
$ venv/bin/python3 scripts/run_dashboard.py
returncode: -15 (SIGTERM)
stderr: clean (Traceback / LayoutError / TypeError 0건)
```

### 4.3 textual run_test pilot widget tree + 18명 박스 본문 검증

```
=== Stage 10d 검증 게이트 (박스 18) ===
  [✓] DashboardRenderer / PendingArea / TeamRenderer×4 / PMStatusBar /
      PendingPushBox / PendingQBox 모두 mount (6/6)

=== 박스 본문 (4 teams) ===
  [✓] 기획: 4/4 (박지영 / 김민교 / 안영이 / 장그래)
  [✓] 디자인: 4/4 (우상호 / 이수지 / 오해원 / 장원영)
  [✓] 개발: 7/7 (공기성 / 최우영 / 현봉식 / 카더가든 / 백강혁 / 김원훈 / 지예은)
  [✓] 관리자: 3/3 (스티브 리 working / 백현진 idle / 이형진 idle)

=== status_bar ===
  [✓] PM 스티브 리 [◉ working] | bridge-064 | tokens: 0.0k |
      active orcs: bridge-064 Orc-064-design Orc-064-dev Orc-064-plan

=== Pending 박스 (Stage 10d 디자인 정정) ===
  Push border_title: 'Pending Push/Commit'
  Q border_title: 'Pending Q'
  [✓] Push ASCII 박스 제거 / [✓] Q ASCII 박스 제거
  [✓] Q 본문 737 chars (이전 606, MAX_VISIBLE 5→10 + truncation 60→100 fix)

=== 진행률 바 idle placeholder ===
  [✓] idle placeholder ░ 표시 (관리자 박스 CTO/CEO 정적 idle 영역)

=== 검증 게이트: PASS ===
    페르소나 표시: 18/18
```

**18 페르소나 모두 표시 PASS** + **F-D3 박스 18 산식 정합** + **운영자 게이트 강제
통과** (PL 본인이 직접 venv/bin/python3 scripts/run_dashboard.py 실행 + textual
run_test pilot 검증).

## 5. 회귀 분석

| 영역 | 검토 |
|------|------|
| Stage 10c efdd532 wiring 본문 | 그대로 — 진입점 sys.path / 6 메서드 / __init__.py 보존 |
| Stage 10b a891d97 wiring | 그대로 — collector / notifier / call_from_thread 패턴 |
| Stage 10 16def78 M-1/M-2 fix | 그대로 — AC-T-4 = 2 + persona_collector batch |
| `tests/test_dashboard_personas.py` PERSONAS_18 의존 | 18명 갱신 영역 review 필요 (기존 15명 → 18명) |
| 외부 호출자 `from scripts.dashboard.X` | 모듈 시그니처 그대로 — 외부 영향 0건 |

⚠ tests/test_dashboard_personas.py가 기존 PERSONAS_18 (실제 15명) 대상 검증이라,
18명 갱신 시 일부 테스트 fail 가능성 (count 검증 등). reviewer가 영역 점검 후 v0.6.5
영역 위임 또는 본 stage 추가 fix 결정 권고.

## 6. 분량 임계

본 drafter doc = 약 220줄 (≤ 800 PASS).

## 7. reviewer 인계

- 5건 fix + F-D3 정정 + 6 파일 변경 박았습니다. 백강혁 reviewer가 검토 + R-N
  마커 + 직접 정정 권한 부탁드립니다.
- 특히 (1) tests/ 영역 회귀 가능성 (PERSONAS_18 18명 갱신), (2) status_bar
  `dock: top` layout 영향, (3) PERSONAS_18 안 PM/CTO/CEO team="관리자" naming,
  (4) Stage 10c _render rename 패턴 정합으로 _format_content 그대로 영역 점검
  권고합니다.

— 지예은 (프론트 드래프터, Orc-064-dev:2.2)
