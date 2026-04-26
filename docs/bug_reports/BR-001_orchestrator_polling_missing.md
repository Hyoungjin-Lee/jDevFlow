---
id: BR-001
title: 3-tier 계층(브릿지·오케) idle 시 하위 계층 polling 부재
date: 2026-04-27
session: 27 (v0.6.4)
discovered_by: 운영자 직접 발견 (ghostty 화면 박지영 16분+ 정체 인지) → 회의창 진단
severity: high (오케·브릿지 무한 대기 → 작업 흐름 정지)
target_versions: v0.6.5 (컨텍스트 엔지니어링) 또는 별도 핫픽스
---

# BR-001 — 3-tier 계층(브릿지·오케) idle 시 하위 계층 polling 부재

## 1. 증상

**Layer A (오케 → 팀원 polling 부재)**:
- v0.6.4 Stage 2~4 박지영 PL(`Orc-064-plan:%75`)이 안영이 finalizer(`%78`) v3 final 5/5 완료 시그널을 **16분 32초 동안 캐치 못 함**
- 안영이는 자기 pane에서 ✓ 완료 보고("Baked for 16m 32s") 출력했으나 박지영 자율 모니터링 X
- 박지영 task list = "S4 in progress / 안영이 신호 대기 중" 상태로 멈춤

**Layer B (브릿지 → 오케 polling 부재)**:
- bridge-064 = 박지영 dispatch 전달 후 진행 상황 회수 책임 (bridge_protocol Sec.5 - 6번)
- 그러나 박지영 16분 정체를 bridge-064 자체도 인지 못 함 → 회의창에 재지시 시그널 X
- 운영자가 ghostty 화면 직접 보고 정체 발견 → 회의창 → bridge-064 강제 진입 → 박지영 깨움
- **브릿지가 오케 idle 발견 → 자발 재지시 메커니즘 부재**

## 2. 재현 조건

**Layer A 재현** (오케 → 팀원):
1. 오케 PL이 팀원 pane에서 작업 진행 (Agent task / sub-pane 분담)
2. 팀원이 자기 pane에서 ✓ 완료 보고 출력
3. 오케 PL이 그 pane을 직접 `capture-pane` 폴링 메커니즘 X
4. 결과: 오케가 idle 상태로 무한 대기

**Layer B 재현** (브릿지 → 오케):
1. 브릿지가 오케에 dispatch 전달
2. 오케가 N분 이상 idle (작업 안 함, ❯ prompt만 있음)
3. 브릿지가 오케 pane을 주기적으로 `capture-pane` 폴링 + idle 패턴 캐치 메커니즘 X
4. 결과: 브릿지도 idle 상태로 무한 대기. 회의창에 재지시 시그널 X.

공통 패턴 = 사고 12 답변≠행동 변형 (답변 = "대기 중" 의도 표시 / 행동 = 폴링·재지시 액션 X).

## 3. 근본 원인

| 영역 | 분석 |
|---|---|
| **운영 명세 누락** | jOneFlow 운영 모델 = 오케 PL이 팀원 작업 회수 책임이지만, **어떻게 회수하는지** 메커니즘 명세 X |
| **Monitor 영역 분리** | bridge-064 Monitor = 회의창이 brigde 캐치하는 영역. **오케 자체의 팀원 polling은 별개 메커니즘 부재** |
| **시그널 단방향** | 팀원이 자기 pane에 시그널 출력 → 오케가 자기 pane에서 그것을 회수 = 자동화 X. 오케 자율로 capture-pane 호출 안 하면 영원히 못 받음 |
| **task list = 의도일 뿐** | 오케 task list("안영이 신호 대기 중")는 의도 표시. 실제 polling 액션 X |

## 4. 임시 대응 (본 세션 적용)

회의창이 bridge-064 통해 박지영에 강제 진입 메시지:
> "[회의창 강제 진입 — 사고 12 정답 절차] 안영이는 v3 final 5건 ✓ 완료 보고를 16분 32초 전 끝냈는데 박지영 시그널 단절. 즉시 capture-pane -t :1.4로 안영이 보고 회수 + S4 ✓ 처리 + S5 즉시 진입."

→ 매 idle 시 회의창 강제 깨움 = **임시 대응**. 본질 해결 X.

## 5. 영구 해결 (정책 제안) — 3-tier 전체 일반화

본 BR은 **모든 계층에 동일 패턴 적용**:

```
회의창 ──→ 브릿지 (회의창이 폴링 / idle 시 재지시)   [이미 일부 박힘 = Monitor]
브릿지 ──→ 오케  (브릿지가 폴링 / idle 시 재지시)   [신규]
오케 ──→ 팀원   (오케가 폴링 / idle 시 재지시)     [신규]
```

### 5-1. 각 계층의 polling loop (필수)

각 상위 계층은 하위 panes를 **N초마다 (잠정 30초)** `capture-pane`으로 회수:

```bash
# 공통 패턴 (회의창/브릿지/오케 모두 동일 형태)
for sub_pane in "${SUB_PANES[@]}"; do
  cur=$(tmux capture-pane -t "$sub_pane" -p -S -20 \
    | grep -E "✓ 완료|✗ 실패|❌ ERROR|📤 to_PL|📤 to_BRIDGE|📤 to_CTO" \
    | tail -3)
  # 패턴 매칭 시 task list 갱신 + 후속 액션
done

# idle 감지 (✓/✗/📤 시그널 부재 + 진행 stale)
last_activity=$(tmux capture-pane -t "$sub_pane" -p -S -3 | grep -oE 'Worked for [0-9]+s|Churned for [0-9]+s|Baked for [0-9]+s' | tail -1)
# stale 임계 (예: 5분) 초과 → 재지시 trigger
```

### 5-2. 시그널 패턴 강제 (하위 → 상위)

| 하위 → 상위 | 시그널 패턴 |
|---|---|
| 팀원 → 오케 | `📤 to_PL: <페르소나> <stage/task> ✓ 완료. <보고 본문>` |
| 오케 → 브릿지 | `📤 to_BRIDGE: <오케명> S<n> ✓ 완료. <commit SHA / 산출물 / Score>` |
| 브릿지 → 회의창 | `📡 status v<버전> Stage <n> COMPLETE. <commit SHA / 산출물 / Score>` (이미 박힘) |

상위 계층 polling이 자기 패턴 캐치 → 즉시 task list 갱신 + 후속 액션.

### 5-3. idle 임계 시 재지시 (필수)

각 계층은 하위 idle을 임계 (잠정 5분) 초과 발견 시 **자동 재지시**:

```
[상위 자율 재지시 — idle 임계 초과]
하위 <ID> 가 <stale 시간> 동안 진행 없음. 마지막 시그널 = <패턴 또는 부재>.
즉시 capture-pane 회수 + 진행 상태 자가 점검 + 다음 액션 명시.
답변 ≠ 행동 (사고 12) 방지: task list 갱신 후 진행.
```

상위 자율 재지시 후에도 N회(예: 2회) idle 지속 → 운영자에게 escalation.

### 5-4. dispatch brief에 polling 정책 자동 주입 (헌법)

`bridge_protocol.md` Sec.4 표에 3개 행 추가 (3-tier 전체):

| 회의창 → 브릿지 polling (필수) | Monitor + capture-pane 30s 주기. 브릿지 idle 5m+ 시 자동 재지시. (Sec.6 사고 14, Sec.7 보강) |
| 브릿지 → 오케 polling (필수) | bridge가 오케 panes를 30s 주기 capture-pane으로 회수. 시그널 패턴 = `📤 to_BRIDGE` / `✓ 완료` / `✗ 실패`. 오케 idle 5m+ 시 자동 재지시. (Sec.6 사고 14) |
| 오케 → 팀원 polling (필수) | 오케 PL이 팀원 panes를 30s 주기 capture-pane으로 회수. 시그널 패턴 = `📤 to_PL` / `✓ 완료` / `✗ 실패`. 팀원 idle 5m+ 시 자동 재지시. (Sec.6 사고 14) |

### 5-5. Sec.6 사고 14 신설

```
### 사고 14: 3-tier 계층(브릿지·오케) idle 시 하위 polling 부재 (헌법)
- 증상: 박지영 PL(Orc-064-plan)이 안영이 v3 final 완료를 16m 32s 캐치 못 함. bridge-064도 박지영 정체를 인지·재지시 못 함. 운영자 직접 화면 발견.
- 운영자: "오케스트레이터가 놀고 있으면 어떻게 / 팀원 작업 완료가 안 오면 주기적으로 풀링해야 하지 않아? / 브리짓도 마찬가지고 오케가 놀고 있음 재지시 내려야지"
- 정답:
  (1) 각 상위 계층은 하위 panes를 30s 주기 capture-pane 폴링
  (2) 시그널 패턴 강제 (📤 to_PL / 📤 to_BRIDGE / 📡 status)
  (3) idle 임계 5m+ 초과 시 상위 자율 재지시
  (4) 자율 재지시 N회 후에도 idle 지속 → 운영자 escalation
  (5) dispatch brief에 polling 정책 자동 주입 (Sec.4 표 3개 행)
- 본 사고 = 헌법 영역. 위반 시 본 파일 사고 사례에 1건 추가 + 운영자 사과.
```

### 5-6. v0.6.5 컨텍스트 엔지니어링 핵심 영역 추가

memory `project_v065_context_engineering.md` 핵심 영역에 박음:

> **3-tier 시그널 폴링 메커니즘 (회의창 ↔ 브릿지 ↔ 오케 ↔ 팀원)** — 30s 주기 capture-pane 폴링 / 시그널 패턴 강제 / idle 5m+ 자동 재지시 / N회 후 escalation

## 6. 후속 행동

- [ ] 본 BR 운영자 검토
- [ ] bridge_protocol.md Sec.4 표 + Sec.6 사고 14 + Sec.8 자가 점검 항목 추가 (헌법 박음, commit)
- [ ] memory `project_v065_context_engineering.md` 핵심 영역 갱신
- [ ] dispatch brief 템플릿에 polling 정책 자동 주입 (v0.6.5 메커니즘 영역)

## 7. 관련 사고 사례

- 사고 12: 오케스트레이터가 운영자 정정 결정 무시 (답변 ≠ 행동) — **본 BR과 동일 패턴 3-tier 일반화**
- 사고 13: Orc 안 split 누락 + 페르소나 이름 누락 (헌법) — 운영자 모니터링 가시성 영역
- 본 BR = 3-tier 계층(브릿지/오케) 자율 재지시 메커니즘 (사고 12·13 보완)
