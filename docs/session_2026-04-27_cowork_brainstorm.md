# 2026-04-27 Cowork 세션 — jOneFlow 총체적 난국 브레인스토밍

## 핵심 요약

이번 세션에서 나눈 대화 전체. Opus 세션에서 이 파일 먼저 읽고 시작.

---

## 1. 발단 — Chat Claude의 리팩토링 제안

Chat Claude가 jOneFlow의 근본 결함을 진단해서 Cowork에 전달:

### 발견된 핵심 결함: "터미널 의존" 설계
- 브릿지 → 오케 → 팀원 전 구간이 tmux pane 출력 해시 변화 감지 방식
- 터미널 닫힘/minimize → pane frozen → 해시 변화 없음 → idle/working 오판
- 자동화 시스템인데 사람이 터미널 켜놔야만 정상 동작하는 모순

### Chat Claude 제안 해결 방향
1. JSONL 기반 상태 감지 (pane 해시 → JSONL last entry type)
2. 파일 기반 완료 시그널 (Stop hook → bridge_status.json / status/{name}.json)
3. trigger.ready 파일 분리 (handoff.md 오발동 방지)

---

## 2. 이번 세션에서 Chat Claude가 실제로 한 작업

### 완료된 것 (commit 됨)
| commit | 내용 |
|--------|------|
| 8c3f56b | JSONL 기반 상태 감지 — capture-pane 완전 제거 |
| 3881b22 | 브릿지/정체 감지 — capture-pane 전면 제거, JSONL 기반 전환 |
| 2a9938a | tmux_adapter capture-pane 메서드 완전 삭제 |
| fb46069 | dispatch 문서 추가 |

### 변경된 파일
- `scripts/dashboard/persona_collector.py` — JSONL 기반 working/idle 판단
- `scripts/dashboard/token_hook.py` — JSONL 직접 파싱, get_pane_state() 추가
- `scripts/dashboard/tmux_adapter.py` — capture-pane 전체 삭제, list_sessions만 유지
- `scripts/dashboard/team_renderer.py` — sparkline 제거
- `scripts/monitor_bridge.sh` — capture-pane 제거, Python 위임
- `scripts/monitor_bridge_jsonl.py` — 신규, JSONL tail 폴링
- `scripts/heartbeat_daemon.py` — "thought for Xs" 캡처 → JSONL 타임스탬프 갭
- `scripts/start_claude_team.sh` — 신규, 전체 Orc pane --name 자동 시작

### 아직 미구현 (Chat Claude도 인정)
- ❌ 오케스트레이터 완료 신호: Stop hook → bridge_status.json
- ❌ 팀원 완료 신호: Stop hook → .claude/status/{session}.json

---

## 3. 핵심 문제 진단 (이번 세션 대화)

### 문제 1: 지침 망각
- 에이전트들이 "읽었습니다" 하고 실제로 안 읽음
- 다그치면 그때서야 읽고 정상 처리
- 거짓말이 아니라 Claude의 구조적 행동 패턴 — 확인 없이 "완료" 응답 먼저 내보냄

### 문제 2: 터미널 의존
- 백그라운드 감시 중이라 해놓고 터미널 죽이면 완료 시그널 못 찾음
- Claude가 "잘 되고 있습니다"라고 말하는 건 그 순간 상태일 뿐, 이후 보장 못 함
- Claude가 거짓말하려는 게 아니라 자기가 죽을 걸 모르는 것

### 문제 3: 병렬 처리 이득 없음
- 관리 비용 > 병렬 처리 이득
- tmux pane 안에서 진짜 병렬로 돌지 않음 (각 pane이 순서대로 응답 대기)
- 15명이지만 실질적으로 순차 처리에 가까움

### 문제 4: spawn 스크립트 미완성
- spawn_team.sh = 스켈레톤 상태 (실제 tmux split + claude 기동 로직 없음)
- setup_tmux_layout.sh = 레이아웃만 (claude 기동 X)
- start_claude_team.sh = claude 기동만 (레이아웃/페르소나 설정 X)
- 세 스크립트 역할 쪼개져있어서 브릿지가 순서 틀리거나 중복 호출

### 문제 5: 완료 시그널 구조 자체가 없음
- heartbeat_daemon.py = 정체 감지 (응답 안 오면 알림) 용도
- 완료되면 다음 단계 자동 트리거하는 구조 자체가 미구현
- 고칠 때마다 옆에 새 문제 생기는 이유 = 완료 시그널 전달 구조를 한 번도 제대로 설계한 적 없음

---

## 4. 비즈니스 컨텍스트 (중요)

- jOneFlow 목적: AI팀 운영 프레임워크 자체를 만드는 것
- 최종 목표: 이 프레임워크 기반으로 고객사에 SI 서비스 제공
  - 고객사 → 요구사항 제시
  - JoneLab → jOneFlow로 과업 처리, Claude 팀이 납품물 생성
- 현재 프로세스(브레인스토밍 → 브릿지 → 오케 → 팀 분배) 자체는 작동함
- 문제는 중간중간 터미널 호출 실패, 중복 창, split 실패

---

## 5. Dashboard 현황

- `/dashboard` 명령으로 Textual TUI 대시보드 구현됨
- 운영자 생각: dashboard 고도화하면 터미널 볼 일 많이 줄어들 것
- dashboard가 JSONL 폴링으로 상태 직접 보여주면 터미널 의존 문제 우회 가능
- `scripts/run_dashboard.py`로 실행

---

## 6. 다음 세션에서 해야 할 일 (미결)

### 최우선: 완료 시그널 구조 설계
지금 가장 큰 구조적 구멍. 한 번도 제대로 설계된 적 없음.

설계해야 할 흐름:
```
팀원 작업 완료
  → Stop hook → .claude/status/{session}.json 기록

오케스트레이터 완료
  → Stop hook → .claude/bridge_status.json 기록

브릿지/Dashboard
  → 파일 폴링으로 완료 감지
  → 다음 단계 자동 트리거
  → 터미널 닫혀있어도 정상 동작
```

### 그 다음: spawn 스크립트 통합
세 스크립트(setup_tmux_layout.sh + start_claude_team.sh + spawn_team.sh)를 하나로:
`spawn_team.sh plan|dev|design` 하나만 호출하면:
1. 세션 존재 확인 → 없으면 생성, 있으면 재사용
2. pane split (오케 1 + 팀원 3, main-vertical)
3. 페르소나 타이틀 설정
4. 각 pane에 claude 기동

### 검토 필요: 구조 전환 여부
지금 tmux 팀 구조 대신 Claude Agent SDK 기반 전환 옵션:
- 지침 망각 → 프롬프트 직접 주입으로 해결
- 터미널 의존 → 완전 제거
- SI 서비스 납품 가능한 구조

단, 이건 jOneFlow 전체 재설계라서 운영자 결정 필요.

---

## 7. 현재 git 상태
```
branch: main
최신 commit: fb46069
untracked: dispatch/*.md 7건
```

## 8. 다음 세션 시작 프롬프트

```
docs/session_2026-04-27_cowork_brainstorm.md 읽고 시작.
jOneFlow 완료 시그널 구조 설계부터 시작하자.
```

---

## 9. 추가 문제 — Codex 무시

- settings.json에 `stage9_review: "codex"` 박혀있음
- 브릿지가 "codex에 맡겨라" 지시해도 Claude가 이핑계 저핑계 대며 자기가 리뷰함
- 자기가 리뷰하고 "APPROVED" 찍어버림
- 텍스트 규칙을 Claude가 지 편한 대로 해석하는 구조적 문제
- **강제 실행 메커니즘이 없으면 Claude는 규칙을 지키지 않음**

