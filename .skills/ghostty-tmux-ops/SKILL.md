---
name: ghostty-tmux-ops
description: >-
  jOneFlow 표준 터미널 운영(Ghostty + tmux) 패턴. bridge / Orc 세션 spawn,
  4 panes split, 페르소나 이름 영구 박음(@persona user option),
  claude CLI 기동(--dangerously-skip-permissions), send-keys 패턴 분리,
  부팅 검증 강제, 위험 명령 회피(스크립트 파일 + dry-run + confirm),
  Settings dialog 회피(settings.json hooks 영역 정합), 사고 사례 회피
  영역 모두 박힌 헌법 영역. 새 세션 또는 새 프로젝트가 jOneFlow 영역 가동
  시 본 SKILL 따라 진행하면 본 stage trail 사고들(사고 5/9/12/13/14) 회피.
---

## 1. 환경 표준

| 영역 | 박음 |
|------|------|
| 터미널 | **Ghostty** (Terminal.app 금지 — split 안 됨, 사고 6) |
| tmux | macOS 기본 / Homebrew |
| claude CLI | Claude Code v2.x 영역 |

### 1.1 Ghostty 창 + 명령 표준

```bash
# 정공법 — 토큰 분리 영역
open -na Ghostty --args -e tmux attach -t bridge-064

# ❌ 금지 (사고 7) — 큰따옴표 한 토큰 영역 = "tmux attach -t bridge: No such file"
open -na Ghostty --args -e "tmux attach -t bridge-064"
```

## 2. tmux 세션 네이밍 (jOneFlow 표준, v0.6.3~)

버전당 영역:
- **bridge-0XX** = 버전당 1개 (버전 시작 시 1회 spawn)
- **Orc-0XX-<plan|design|dev>** = 단계 진입 시 spawn (단계 종료 시 kill 가능)

```
bridge-064          ← 버전 시작 시 1회
Orc-064-plan        ← Stage 2~4 기획 시점
Orc-064-design      ← Stage 6/7 디자인 시점
Orc-064-dev         ← Stage 8 구현 시점
```

= **다중 팀 협업 = 1 bridge + N Orc (최대 1+3)**.

## 3. bridge 세션 spawn

```bash
ROOT=/Users/geenya/projects/Jonelab_Platform/jOneFlow
tmux new-session -d -s bridge-064 -c "$ROOT"
tmux send-keys -t bridge-064 'claude --teammate-mode tmux --dangerously-skip-permissions'
sleep 0.3
tmux send-keys -t bridge-064 Enter
open -na Ghostty --args -e tmux attach -t bridge-064
```

## 4. Orc 세션 spawn (4 panes 헌법)

### 4.1 세션 + 4 panes 영역

```bash
SESSION=Orc-064-dev
ROOT=/Users/geenya/projects/Jonelab_Platform/jOneFlow

# 1. 세션 + 첫 pane
tmux new-session -d -s "$SESSION" -c "$ROOT"

# 2. auto-rename 영구 X (claude CLI 면역 영역)
tmux set-option -gw -t "$SESSION" allow-rename off
tmux set-option -gw -t "$SESSION" automatic-rename off
tmux set-option -t "$SESSION" pane-border-status top

# 3. split 4 panes (좌 1 + 우 3 stack)
tmux split-window -h -t "$SESSION":1.1 -c "$ROOT"
tmux split-window -v -t "$SESSION":1.2 -c "$ROOT"
tmux split-window -v -t "$SESSION":1.3 -c "$ROOT"

# 4. main-vertical layout (좌측 50% 영역)
tmux set-option -t "$SESSION" main-pane-width '50%'
tmux select-layout -t "$SESSION" main-vertical
```

### 4.2 페르소나 이름 영구 박음 (@persona user option, 사고 13 회피)

```bash
# 핵심 정공법 — claude CLI auto-rename 영향 X (#T 대신 #{@persona} 사용)
tmux set-option -t "$SESSION":1.1 -p @persona '공기성-개발PL'
tmux set-option -t "$SESSION":1.2 -p @persona '카더가든-be-drafter'
tmux set-option -t "$SESSION":1.3 -p @persona '최우영-be-reviewer'
tmux set-option -t "$SESSION":1.4 -p @persona '현봉식-be-finalizer'
tmux set-window-option -t "$SESSION" pane-border-format ' #{@persona} '
```

페르소나 이름 = `docs/operating_manual.md` Sec.1.2 조직도 그대로 (예: 박지영-기획PL / 우상호-디자인PL / 공기성-개발PL).

### 4.3 claude CLI 4개 기동 (헌법 — F-62-9)

```bash
# 자동화 호출 + --dangerously-skip-permissions 강제 (사고 영역: 운영자 수동 권한 prompt)
for p in 1.1 1.2 1.3 1.4; do
  tmux send-keys -t "$SESSION":$p 'claude --teammate-mode tmux --dangerously-skip-permissions'
  sleep 0.3
  tmux send-keys -t "$SESSION":$p Enter
done

# Ghostty 창 spawn
open -na Ghostty --args -e tmux attach -t "$SESSION"
```

## 5. send-keys 패턴 분리 헌법

```bash
# ✅ 정공법 — prompt + sleep + Enter 분리
tmux send-keys -t "$TARGET" '<msg>'
sleep 0.3
tmux send-keys -t "$TARGET" Enter

# ❌ 금지 — 한 번에 박으면 trigger 못 잡음
tmux send-keys -t "$TARGET" '<msg>' Enter
```

긴 메시지 + 한국어 영역에서 **마지막 글자 잔존 영역 회피** = send-keys 후 capture-pane으로 prompt 박스 검증 박는 영역 (v0.6.5 정공법 영역).

## 6. 부팅 검증 강제 (사고 5 변종 회피, Sec.8 자가 점검 11항)

```bash
# 4 panes 모두 직접 capture로 ready 확인 (1개 보고 4개 추측 X)
for p in 1.1 1.2 1.3 1.4; do
  ready=$(tmux capture-pane -t "$SESSION":$p -p -S -50 | grep -c "bypass permissions on")
  if [ "$ready" -eq 0 ]; then
    echo "❌ pane $p 부팅 실패 — Settings dialog 또는 권한 prompt 박힘"
    exit 1
  fi
done
echo "✅ 4 panes 모두 ready"
```

### 6.1 Settings dialog 박히면

`.claude/settings.json`에 `hooks._comment_hooks` 같이 unknown hook event로 해석되는 키 박혀 있는지 확인. 박혔으면 → 해당 키를 `hooks` 객체 외부 root level로 이동.

```bash
# Continue 선택 (Enter 1번) — 단발성 fallback
tmux send-keys -t "$SESSION":$p Enter
```

= 정공법 = settings.json 정정 후 새 spawn.

## 7. 위험 명령 회피 (사고 영역 영구 박힘 — 운영자 git 날린 사고)

```
❌ git push / git reset --hard / git tag / rm -rf / git checkout --
❌ 외부 API 호출
```

위 명령은 **회의창이 운영자에게 명령줄 그대로 paste 금지**.

✅ 정공법:

```bash
# 1. 쉘 스크립트 파일로 작성
cat > scripts/cleanup_legacy.sh <<'EOF'
#!/bin/bash
set -euo pipefail

DRY_RUN=true
[ "${1:-}" = "--confirm" ] && DRY_RUN=false

if [ "$DRY_RUN" = true ]; then
  echo "[dry-run] would remove: ..."
else
  rm -rf "..."
fi
EOF

chmod +x scripts/cleanup_legacy.sh

# 2. dry-run 검증
bash scripts/cleanup_legacy.sh

# 3. --confirm 1줄 실행 (운영자 또는 회의창)
bash scripts/cleanup_legacy.sh --confirm
```

## 8. 사고 사례 (v0.6.4 trail 회피 영역)

### 사고 7: Ghostty -e 인자 큰따옴표 한 토큰
- 박힘: `open -na Ghostty --args -e "tmux attach -t bridge"` → 파일 경로로 해석
- 정공법: 토큰 분리 (Sec.1.1)

### 사고 13: 4 panes split 누락 + 페르소나 이름 누락
- 박힘: PL이 dispatch 자율로 Agent tool 분담 → 단일 pane → 운영자 모니터링 깨짐
- 정공법: 4 panes 강제 + @persona user option 박음 (Sec.4)

### 사고 영역: claude CLI auto-rename pane title 덮음
- 박힘: `select-pane -T <name>` 박았는데 claude CLI 부팅 후 "Claude Code"로 덮임
- 정공법: `@persona` user option + `pane-border-format ' #{@persona} '` (Sec.4.2)

### 사고 영역: 운영자 attached 창에서 무심코 키 입력
- 박힘: Esc * 3 = Rewind 메뉴 발동 / Ctrl+G = goto line 모드 / 무작위 글자 박힘
- 정공법(잠정): `tmux attach -r` read-only 영역 — 단 v0.6.5 운영자 결정 = 일반 모드 회귀 + send-keys 자가 검증 강제 (메모리 `project_v065_context_engineering.md`)

### 사고 영역: settings.json `hooks._comment_hooks` Unknown hook event
- 박힘: claude CLI가 hooks 객체 안 모든 키를 hook event로 해석 → 매 spawn마다 Settings dialog
- 정공법: `_comment_hooks` 키를 `hooks` 객체 외부 root level로 이동

## 9. 표준 진입 절차 (회의창 1메시지 자동화)

```
[1] dispatch md 작성 (Write, dispatch/ 폴더)
[2] tmux 세션 부트스트랩 (bridge + Orc, Sec.3 + Sec.4)
[3] claude CLI 4개 기동 (Sec.4.3)
[4] Ghostty 모니터링 창 spawn
[5] 부팅 검증 (Sec.6, 4 panes 모두 ready)
[6] 브릿지에 dispatch 지시 send-keys (Sec.5)
[7] watcher task 박음 (push-signal-watcher SKILL 영역)
[8] 회의 모드 돌입
```

## 10. 관련 헌법

- `docs/bridge_protocol.md` Sec.4 (환경 표준 표) + Sec.6 (사고 사례) + Sec.8 (자가 점검 11항)
- `CLAUDE.md` MANDATORY STARTUP RULE 6항 (추측 진행 금지)
- `.skills/push-signal-watcher/SKILL.md` (push 시그널 + watcher 영역)

## 11. 새 프로젝트 영역 적용

`init_project.sh` scaffold 시 본 SKILL 영역 복사:
```bash
cp -r .skills/ghostty-tmux-ops .skills/push-signal-watcher <new-project>/.skills/
```
