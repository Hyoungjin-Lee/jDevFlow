#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# spawn_team.sh — M4 18명 페르소나 spawn 자동화 sketch
#
# 역할: 팀별(기획/개발/디자인) 오케스트레이터 + 팀원 spawn
# 패턴: 각 tmux pane에 페르소나명 label (pane-border-format + select-pane -T)
#
# 사용법:
#   bash scripts/spawn_team.sh plan      # 기획팀 spawn (박지영 + 4명)
#   bash scripts/spawn_team.sh dev       # 개발팀 spawn (공기성 + 6명)
#   bash scripts/spawn_team.sh design    # 디자인팀 spawn (우상호 + 3명)
#
# v0.6.3 운영 매뉴얼 기준 페르소나:
# 기획팀 (Orc-063-plan):
#   - 박지영 (PL, Opus)
#   - 김민교 (리뷰어, Opus)
#   - 안영이 (파이널리즈, Sonnet)
#   - 장그래 (드래프터, Haiku)
# 개발팀 (Orc-063-dev):
#   - 공기성 (PL, Opus)
#   - 최우영 (BE 리뷰어, Opus)
#   - 현봉식 (BE 파이널리즈, Sonnet)
#   - 카더가든 (BE 드래프터, Haiku)
#   - 백강혁 (FE 리뷰어, Opus)
#   - 김원훈 (FE 파이널리즈, Sonnet)
#   - 지예은 (FE 드래프터, Haiku)
# 디자인팀 (Orc-063-design):
#   - 우상호 (PL, Opus)
#   - 이수지 (리뷰어, Opus)
#   - 오해원 (파이널리즈, Sonnet)
#   - 장원영 (드래프터, Haiku)

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ============================================================================
# 팀별 페르소나 정의
# ============================================================================

# 기획팀 (4명: PL + 리뷰 + 파이널 + 드래프트)
PLAN_TEAM_PL="박지영"
PLAN_TEAM_MEMBERS="김민교|안영이|장그래"

# 개발팀 (7명: PL + BE리뷰 + BE파이널 + BE드래프트 + FE리뷰 + FE파이널 + FE드래프트)
DEV_TEAM_PL="공기성"
DEV_TEAM_MEMBERS="최우영|현봉식|카더가든|백강혁|김원훈|지예은"

# 디자인팀 (4명: PL + 리뷰 + 파이널 + 드래프트)
DESIGN_TEAM_PL="우상호"
DESIGN_TEAM_MEMBERS="이수지|오해원|장원영"

# ============================================================================
# Spawn 함수 — pane 타이틀 + Claude CLI (F-62-9 옵션 강제)
# ============================================================================

spawn_orc_pane() {
  local session="$1"
  local persona="$2"

  # pane 타이틀 설정 (F-62-7c 범위 + pane-border-format)
  tmux select-pane -t "$session" -T "$persona"

  # Claude CLI 기동 (F-62-9: --dangerously-skip-permissions 강제)
  # 실제 구현은 Stage 8에서 tmux send-keys 패턴으로 실행
  # 여기서는 skeleton만 (인터페이스)
  printf '  ▶ %s (pane title set, spawn ready)\n' "$persona"
}

spawn_team() {
  local team="${1:-}"

  case "$team" in
    plan)
      printf 'spawn_team.sh: 기획팀 (Orc-063-plan) 페르소나 spawn sketch\n'
      printf '  PL: %s\n' "$PLAN_TEAM_PL"
      printf '  Members: %s\n' "$PLAN_TEAM_MEMBERS"
      # Stage 8 구현: tmux split-window + claude --teammate-mode + --dangerously-skip-permissions
      ;;
    dev)
      printf 'spawn_team.sh: 개발팀 (Orc-063-dev) 페르소나 spawn sketch\n'
      printf '  PL: %s\n' "$DEV_TEAM_PL"
      printf '  Members: %s\n' "$DEV_TEAM_MEMBERS"
      # Stage 8 구현: tmux split-window + claude --teammate-mode + --dangerously-skip-permissions
      ;;
    design)
      printf 'spawn_team.sh: 디자인팀 (Orc-063-design) 페르소나 spawn sketch\n'
      printf '  PL: %s\n' "$DESIGN_TEAM_PL"
      printf '  Members: %s\n' "$DESIGN_TEAM_MEMBERS"
      # Stage 8 구현: tmux split-window + claude --teammate-mode + --dangerously-skip-permissions
      ;;
    *)
      printf 'usage: spawn_team.sh [plan|dev|design]\n' >&2
      exit 2
      ;;
  esac
}

# ============================================================================
# Main
# ============================================================================

if [ $# -lt 1 ]; then
  printf 'usage: spawn_team.sh [plan|dev|design]\n' >&2
  exit 2
fi

spawn_team "$1"
printf '✅ spawn_team.sh sketch complete (Stage 8 상세 구현 필요)\n'
