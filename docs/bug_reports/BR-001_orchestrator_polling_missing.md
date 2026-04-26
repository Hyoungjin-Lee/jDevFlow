---
id: BR-001
title: 오케스트레이터 idle 시 팀원 작업 완료 polling 부재
date: 2026-04-27
session: 27 (v0.6.4)
discovered_by: 운영자 직접 발견 (ghostty 화면 박지영 16분+ 정체 인지) → 회의창 진단
severity: high (오케 무한 대기 → 작업 흐름 정지)
target_versions: v0.6.5 (컨텍스트 엔지니어링) 또는 별도 핫픽스
---

# BR-001 — 오케스트레이터 idle 시 팀원 작업 완료 polling 부재

## 1. 증상

- v0.6.4 Stage 2~4 박지영 PL(`Orc-064-plan:%75`)이 안영이 finalizer(`%78`) v3 final 5/5 완료 시그널을 **16분 32초 동안 캐치 못 함**
- 안영이는 자기 pane에서 ✓ 완료 보고("Baked for 16m 32s") 출력했으나 박지영 자율 모니터링 X
- 박지영 task list = "S4 in progress / 안영이 신호 대기 중" 상태로 멈춤
- 운영자가 ghostty 화면 직접 보고 정체 발견 → 회의창에 시그널 → 회의창이 bridge-064 통해 강제 깨움

## 2. 재현 조건

1. 오케 PL이 팀원 pane에서 작업 진행 (Agent task / sub-pane 분담)
2. 팀원이 자기 pane에서 ✓ 완료 보고 출력
3. 오케 PL이 그 pane을 직접 `capture-pane` 폴링하는 메커니즘 X
4. 결과: 오케가 idle 상태로 무한 대기 (사고 12 답변≠행동 패턴 변형)

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

## 5. 영구 해결 (정책 제안)

### 5-1. 오케 자체 polling loop (필수)

오케 PL은 팀원 N명의 pane을 **N초마다 (잠정 30초)** `capture-pane`으로 회수:

```bash
# 오케 PL이 자기 작업 사이사이 또는 idle 진입 시 호출
for tm_pane in "${TEAM_PANES[@]}"; do
  cur=$(tmux capture-pane -t "$tm_pane" -p -S -20 \
    | grep -E "✓ 완료|✗ 실패|❌ ERROR|📤 to_PL" \
    | tail -3)
  # 패턴 매칭 시 task list 갱신 + 후속 stage 진입
done
```

### 5-2. 팀원 → 오케 시그널 강제 패턴

팀원이 작업 완료 시 자기 pane에 **정해진 시그널** 출력:

```
📤 to_PL: <페르소나명> <stage/task> ✓ 완료. <보고 본문 1~3줄>
```

오케 polling이 `📤 to_PL` 패턴 캐치 → 즉시 task list 갱신.

### 5-3. dispatch brief에 polling 정책 자동 주입 (헌법)

`bridge_protocol.md` Sec.4 표에 행 추가:

| 오케 팀원 polling (필수) | 오케 PL은 팀원 panes를 30초마다 capture-pane으로 회수. 시그널 패턴 = `📤 to_PL` / `✓ 완료` / `✗ 실패` / `❌ ERROR`. 팀원 완료 즉시 task list 갱신 + 후속 stage 진입. idle 무한 대기 금지. (Sec.6 사고 14) |

### 5-4. Sec.6 사고 14 신설

```
### 사고 14: 오케스트레이터가 팀원 시그널 폴링 안 하고 무한 대기
- 증상: 박지영(Orc-064-plan)이 안영이 v3 final 완료를 16m 32s 캐치 못 함. 운영자 직접 화면 발견.
- 운영자: "오케스트레이터가 놀고 있으면 어떻게 / 팀원 작업 완료가 안 오면 주기적으로 풀링해야 하지 않아?"
- 정답: (1) 오케 자체 polling loop 30s 주기. (2) 팀원 시그널 패턴 강제 (📤 to_PL). (3) dispatch brief에 polling 정책 자동 주입. (4) idle 진입 시 즉시 폴링 후 다음 액션.
```

### 5-5. v0.6.5 컨텍스트 엔지니어링 핵심 영역 추가

memory `project_v065_context_engineering.md` 핵심 영역에 박음:

> **오케 ↔ 팀원 시그널 폴링 메커니즘** — 30초 주기 capture-pane 폴링 / `📤 to_PL` 패턴 강제 / idle 무한 대기 차단

## 6. 후속 행동

- [ ] 본 BR 운영자 검토
- [ ] bridge_protocol.md Sec.4 표 + Sec.6 사고 14 + Sec.8 자가 점검 항목 추가 (헌법 박음, commit)
- [ ] memory `project_v065_context_engineering.md` 핵심 영역 갱신
- [ ] dispatch brief 템플릿에 polling 정책 자동 주입 (v0.6.5 메커니즘 영역)

## 7. 관련 사고 사례

- 사고 12: 오케스트레이터가 운영자 정정 결정 무시 (답변 ≠ 행동) — **본 BR과 동일 패턴 변형** (답변 = 대기 의도 / 행동 = 폴링 X)
- 사고 13: Orc 안 split 누락 + 페르소나 이름 누락 (헌법) — 운영자 모니터링 가시성 영역
- 본 BR = 오케 자체 자동화 영역 (사고 12·13 보완)
