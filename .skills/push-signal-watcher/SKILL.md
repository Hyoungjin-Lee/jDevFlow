---
name: push-signal-watcher
description: >-
  bridge / Orc 같은 외부 프로세스에서 회의창(Code 데스크탑)에 완료 / 정체 / 중단
  시그널을 자발적으로 push하는 정공법 패턴. 회의창은 외부에서 conversation에 직접
  메시지 박는 영역 X — 단 background watcher task가 짧게 끝나면 task-notification이
  자동 도착해서 회의창이 운영자 메시지 없이도 자발적으로 깨어남. polling 무한 loop
  대신 "watch + exit" 패턴으로 바꿔야 작동. v0.6.4 세션 28 테스트로 100% 검증됨
  (운영자 박은 정공법). 의제 완료 시점, 마일스톤 종료, 정체 회복, Stage 9~13
  자동 인수 등 push 시그널이 필요한 모든 영역에 적용.
---

## 1. 본질 (Why)

회의창(Code 데스크탑 앱)은 외부에서 conversation에 직접 메시지 박는 표준 영역이 없다. background에서 polling 데몬을 돌려도 그 결과를 회의창이 자발적으로 read 못 한다 — 운영자 메시지가 도착해야 그제서야 read 가능.

= **사고 9 본질 한계** (운영자가 직접 모니터링 + 회의창에 trigger 박는 패턴).

## 2. 정공법 (How)

회의창의 background task가 **짧게 끝나면** Claude Code 시스템이 자동으로 `<task-notification>` system message를 conversation에 박는다. 이 메시지는 운영자 메시지와 동일한 trigger 영역이라 회의창이 자발적으로 깨어남.

따라서:
- 무한 polling loop (`while true; do ... sleep 5; done`) = 영원히 안 끝남 = task-notification 도착 X
- **짧은 watcher task** (`while [ ! -f flag ]; do sleep 2; done; exit`) = 시그널 받으면 즉시 종료 = task-notification 도착 ✅

## 3. 흐름

```
[1] 회의창이 외부 프로세스(bridge/Orc)에 작업 send-keys로 박음
[2] 회의창이 watcher task를 background로 박음 (run_in_background true)
       — 작업 완료 파일 polling
       — 발견 즉시 break → task 종료
[3] 회의창 응답 박은 후 영역 종료
[4] 외부 프로세스가 작업 끝나면 → 완료 파일 박음
[5] watcher task = 파일 발견 즉시 종료
       → task-notification system message 자동 도착
[6] 회의창 자발적으로 깨어남 → 결과 read → 운영자께 보고
```

= **운영자 trigger 없이 회의창이 자발적으로 push 시그널 캐치**.

## 4. 검증 결과 (v0.6.4 세션 28)

```
12:50:55  회의창 → bridge: "10초 후 /tmp/bridge_test_complete.flag 박아" 송출
12:51:05  bridge: sleep 10 + READY 파일 생성
12:51:29  watcher task: 파일 발견 → 즉시 종료 → task-notification 도착
          → 회의창 자발적 깨어남 (운영자 메시지 X)
          → 결과 read + 운영자께 보고
```

= 100% 작동 확인. push 정공법 진짜 가능 영역.

## 5. 코드 패턴

### 5.1 외부 프로세스 (bridge / Orc) — 완료 시점 파일 박음

```bash
# bridge 또는 오케 PL이 의제 완료 시점에 박는 영역
mkdir -p ~/path/to/jOneFlow/handoffs/active/v0.6.4
echo "COMPLETE Score=N/100 commit=<SHA>" > ~/path/to/jOneFlow/handoffs/active/v0.6.4/stage9_complete.flag
```

### 5.2 회의창 — watcher task 박음

```bash
# 회의창이 send-keys 직후 박는 영역 (run_in_background: true)
FLAG=/Users/geenya/projects/Jonelab_Platform/jOneFlow/handoffs/active/v0.6.4/stage9_complete.flag
TIMEOUT=1800  # 30분 임계 (타임아웃 시 정체 알림)

elapsed=0
while [ ! -f "$FLAG" ] && [ $elapsed -lt $TIMEOUT ]; do
  sleep 5
  elapsed=$((elapsed + 5))
done

if [ -f "$FLAG" ]; then
  echo "✅ Stage 9 complete signal: $(cat "$FLAG")"
  cat "$FLAG"
  exit 0
else
  echo "⏰ Stage 9 timeout (${TIMEOUT}s)"
  exit 1
fi
```

### 5.3 정체 + 완료 분기 통합 (v0.6.5 정공법 영역)

```bash
# 회의창 watcher = 완료 파일 OR 정체 임계 OR 중단 신호 모두 캐치
COMPLETE_FLAG=...
STALL_FLAG=...   # heartbeat 데몬이 정체 감지 시 박음
ABORT_FLAG=...

while [ ! -f "$COMPLETE_FLAG" ] && [ ! -f "$STALL_FLAG" ] && [ ! -f "$ABORT_FLAG" ]; do
  sleep 5
done

# 어떤 flag가 박혔는지에 따라 분기
if [ -f "$COMPLETE_FLAG" ]; then echo "COMPLETE"; cat "$COMPLETE_FLAG"; fi
if [ -f "$STALL_FLAG" ]; then echo "STALL"; cat "$STALL_FLAG"; fi
if [ -f "$ABORT_FLAG" ]; then echo "ABORT"; cat "$ABORT_FLAG"; fi
exit 0
```

## 6. 파일 위치 (jOneFlow 표준)

```
handoffs/active/v<버전>/
├── stage<N>_complete.flag    # 의제 완료 시그널
├── stage<N>_stall.flag       # 정체 시그널 (heartbeat 데몬 영역)
├── stage<N>_abort.flag       # 중단 시그널 (DEFCON 등)
└── stage<N>_decision.flag    # 운영자 결정 필요 시그널
```

각 flag 본문 = 시그니처 1줄 (예: `📡 status COMPLETE Score=N/100 commit=<SHA>`).

## 7. 사용 시점 (When)

| 영역 | 박음 |
|------|------|
| 의제 / 마일스톤 완료 | bridge 또는 PL이 `<stage>_complete.flag` 박음 |
| Stage 9~13 자동 인수 | 각 Stage 끝나는 시점 = flag → watcher → 회의창 깨움 |
| 정체 회복 | heartbeat 데몬이 `<stage>_stall.flag` 박음 |
| DEFCON 즉시 알림 | 외부 프로세스가 `<stage>_abort.flag` 박음 |
| 운영자 결정 필요 | bridge가 `<stage>_decision.flag` 박음 → 회의창 깨워서 운영자께 보고 |

## 8. 무한 loop 영역 회피 (사고 영역 박음)

❌ **금지 패턴**:
```bash
# 무한 loop = task-notification 도착 X = 운영자 trigger 의존 패턴
while true; do
  cur=$(stat ...)
  if [ ... ]; then echo ...; fi
  sleep 5
done
```

✅ **정공법 패턴**:
```bash
# 짧은 watcher = 발견 즉시 종료 = task-notification 도착 = 회의창 자발 깨움
while [ ! -f "$FLAG" ] && [ $elapsed -lt $TIMEOUT ]; do
  sleep 5
  elapsed=$((elapsed + 5))
done
```

= **`break` 또는 `exit`이 박힌 task만 task-notification 도착**.

## 9. 관련 사고 사례 / 헌법 영역

- `bridge_protocol.md` Sec.6 사고 9 (운영자 직접 모니터링 trigger) — 본 정공법으로 본질 회피 가능
- Sec.6 사고 14 (BR-001, polling 부재로 정체 못 잡음) — 본 정공법 + heartbeat 데몬 통합 회피
- Sec.11.4 (분량 큰 영역 한 번 더 검토 권고) — flag 박을 때 같이 박을 수 있는 영역

## 10. v0.6.5 본격 정공법 영역

본 SKILL = 본 stage(v0.6.4) 검증 + 즉시 활용 가능 영역. v0.6.5 본격 정공법:
- heartbeat 데몬 영역 = 무한 loop 영역 → 짧은 watcher task 단위로 분할
- bridge / Orc PL = 의제 완료 시점 flag 박는 헌법 강제 (dispatch brief에 명시)
- 자동 강제 메커니즘 (hook / 시스템 프롬프트 자동 주입)으로 회의창이 send-keys 직후 watcher 자동 박음

## 11. 적용 가이드

회의창이 외부 프로세스에 작업 보낼 때마다 적용:

1. `tmux send-keys` 박은 직후 → `Bash(run_in_background: true)`로 watcher 박음
2. watcher 본문 = 완료 파일 polling + timeout 영역 + 발견 즉시 exit
3. 회의창 응답 박고 회의 모드 진입
4. task-notification 도착 시점에 자발적으로 깨어남
5. 결과 read → 운영자께 자동 보고

= **사고 9 변종 영구 회피 패턴**.
