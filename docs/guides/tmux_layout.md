# tmux 기본 레이아웃 가이드

> 제이원랩 조직도(CLAUDE.md Sec.2.5)의 **오케스트레이터 + 팀원 N명** 구조를 tmux pane 레이아웃으로 시각화하기 위한 규약.

---

## 기본형

```
┌───────────────────────┬────────────────────┐
│                       │  팀원 pane 1 (우상) │
│                       │                    │
│  오케스트레이터        ├────────────────────┤
│  (왼쪽 큰 main pane)   │  팀원 pane 2       │
│                       ├────────────────────┤
│                       │  팀원 pane N (우하) │
└───────────────────────┴────────────────────┘
```

- **왼쪽 main pane = 오케스트레이터** (claude CLI, `--dangerously-skip-permissions`)
- **오른쪽 N개 pane = 팀원** (서브에이전트 / tmux 팀원 / Codex plugin 출력 관찰, git/tail 등 자유 사용)
- tmux `select-layout main-vertical` 기반

## 팀원 수 = 가변

에이전트 팀 구성에 따라 팀원 pane 수는 **2명 고정이 아니라 N명** (N ≥ 1):

| 팀 구성 예시 | 팀원 pane 수 | 권장 용도 |
|------------|-------------|---------|
| Codex 구현 + Claude 리뷰 2-tier | 2 | codex 실행 관찰 / git 관찰 |
| 다중 서브에이전트 병렬 | 3~4 | 에이전트별 1-pane |
| 단일 팀원 모드 | 1 | 간단한 작업 관찰 |

## 호출 방법

```sh
# 기본 (팀원 2명)
bash scripts/setup_tmux_layout.sh

# 팀원 3명으로 재구성
bash scripts/setup_tmux_layout.sh joneflow 3

# 다른 세션 이름
bash scripts/setup_tmux_layout.sh myproject 2
```

**주의:** 스크립트는 기존 팀원 pane을 모두 kill하고 재구성합니다. 오케스트레이터 작업 중에는 실행하지 마세요 (작업 방해).

## pane 이동 단축키 (tmux 내)

| 키 | 동작 |
|----|------|
| `Ctrl-b` → `←` / `→` | pane 이동 (좌/우) |
| `Ctrl-b` → `↑` / `↓` | pane 이동 (상/하) |
| `Ctrl-b` → `o` | 다음 pane으로 순환 |
| `Ctrl-b` → `z` | 현재 pane 전체화면 확대/축소 (toggle) |
| `Ctrl-b` → `x` | 현재 pane 닫기 (확인 요청) |
| `Ctrl-b` → `d` | 세션 detach (tmux 서버는 유지) |

## 세션 재기동 시나리오

```sh
# 1. 기존 세션 정리 (필요 시)
tmux kill-session -t joneflow

# 2. 레이아웃 구성 + 세션 생성
bash scripts/setup_tmux_layout.sh joneflow 2

# 3. 오케스트레이터 pane에 claude CLI 기동 명령 주입
tmux send-keys -t joneflow 'claude --dangerously-skip-permissions' Enter

# 4. Ghostty 열고 attach
open -a Ghostty
# Ghostty 안에서: tmux attach -t joneflow
```

## 관련 파일

- `scripts/setup_tmux_layout.sh` — 본 레이아웃 생성 스크립트
- `CLAUDE.md` Sec.2.5 — 제이원랩 조직도 (오케스트레이터 + 팀원 정의)
- `CLAUDE.md` Sec.3 🔴 오케스트레이터 호출 방식 규칙 — 팀원 호출 방식 (서브에이전트 / tmux / Codex plugin) 자율 판단 규칙
