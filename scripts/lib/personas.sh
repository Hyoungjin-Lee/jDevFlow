#!/bin/sh
# personas.sh — 페르소나 ↔ 모델/effort/역할 매핑 (v0.6.6 신규).
#
# 기준: docs/operating_manual.md Sec.1.2 (v0.6.5 페르소나 표).
# 사용처: spawn_team.sh / start_claude_team.sh / 향후 dispatch 자동 매핑.
#
# Public API:
#   persona_model PERSONA       # claude CLI --model 인자값 echo
#   persona_effort PERSONA      # effort 라벨 echo (medium|high|xhigh)
#   persona_role PERSONA        # 역할 라벨 echo (PL|reviewer|finalizer|drafter|cto|pm)
#   persona_team PERSONA        # 소속 팀 echo (plan|design|dev|exec|bridge)
#   persona_list_team TEAM      # 팀 페르소나 PL + 멤버를 "PL|m1|m2|m3" 포맷으로 echo
#   persona_list_team_dev_be    # 개발팀 백엔드 default (Sec.1.2 + dispatch v0.6.6 헌법)
#   persona_list_team_dev_fe    # 개발팀 프론트 default
#
# 모델 ID (CLAUDE.md 기준 — 2026-01 cutoff 시점 최신):
#   Opus 4.7   = claude-opus-4-7
#   Sonnet 4.6 = claude-sonnet-4-6
#   Haiku 4.5  = claude-haiku-4-5-20251001
#
# Effort: medium|high|xhigh (claude CLI는 effort 직접 플래그 없음.
#   pane 메타데이터/환경변수로만 전달. xhigh는 PM 브릿지 전용.)
#
# POSIX-only: no `local`, no `[[ ]]`, no associative arrays.

# ---- 모델 매핑 (Sec.1.2 18명) ----

persona_model() {
    case "${1:-}" in
        # 임원/CTO/PM
        이형진)         printf '' ;;                      # CEO = Cowork 운영자, 모델 없음
        박지영)         printf 'claude-sonnet-4-6' ;;     # CTO 실장 (Code)
        이희윤)         printf 'claude-opus-4-7' ;;       # PM 브릿지 (Opus 4.7 1M)

        # 기획팀
        이종선)         printf 'claude-opus-4-7' ;;       # 기획 PL
        김민교)         printf 'claude-opus-4-7' ;;       # 기획 리뷰어
        안영이)         printf 'claude-sonnet-4-6' ;;     # 기획 파이널리즈
        장그래)         printf 'claude-haiku-4-5-20251001' ;;  # 기획 드래프터

        # 디자인팀
        우상호)         printf 'claude-opus-4-7' ;;       # 디자인 PL
        이수지)         printf 'claude-opus-4-7' ;;       # 디자인 리뷰어
        오해원)         printf 'claude-sonnet-4-6' ;;     # 디자인 파이널리즈
        장원영)         printf 'claude-haiku-4-5-20251001' ;;  # 디자인 드래프터

        # 개발팀 (BE)
        공기성)         printf 'claude-opus-4-7' ;;       # 개발 PL
        최우영)         printf 'claude-opus-4-7' ;;       # 백앤드 리뷰어
        현봉식)         printf 'claude-sonnet-4-6' ;;     # 백앤드 파이널리즈
        카더가든)       printf 'claude-haiku-4-5-20251001' ;;  # 백앤드 드래프터

        # 개발팀 (FE)
        백강혁)         printf 'claude-opus-4-7' ;;       # 프론트 리뷰어
        김원훈)         printf 'claude-sonnet-4-6' ;;     # 프론트 파이널리즈
        지예은)         printf 'claude-haiku-4-5-20251001' ;;  # 프론트 드래프터

        *) printf '' ;;
    esac
}

# ---- effort 매핑 ----

persona_effort() {
    case "${1:-}" in
        이형진) printf '' ;;
        박지영) printf 'medium' ;;
        이희윤) printf 'xhigh' ;;
        # 기획/디자인/개발 PL + 리뷰어 = high
        이종선|김민교|우상호|이수지|공기성|최우영|백강혁) printf 'high' ;;
        # 파이널리즈 + 드래프터 = medium
        안영이|장그래|오해원|장원영|현봉식|카더가든|김원훈|지예은) printf 'medium' ;;
        *) printf '' ;;
    esac
}

# ---- 역할 매핑 ----

persona_role() {
    case "${1:-}" in
        이형진) printf 'ceo' ;;
        박지영) printf 'cto' ;;
        이희윤) printf 'pm' ;;
        이종선|우상호|공기성)               printf 'PL' ;;
        김민교|이수지|최우영|백강혁)        printf 'reviewer' ;;
        안영이|오해원|현봉식|김원훈)        printf 'finalizer' ;;
        장그래|장원영|카더가든|지예은)      printf 'drafter' ;;
        *) printf '' ;;
    esac
}

# ---- 팀 매핑 ----

persona_team() {
    case "${1:-}" in
        이형진|박지영) printf 'exec' ;;
        이희윤)         printf 'bridge' ;;
        이종선|김민교|안영이|장그래)            printf 'plan' ;;
        우상호|이수지|오해원|장원영)            printf 'design' ;;
        공기성|최우영|현봉식|카더가든|백강혁|김원훈|지예은) printf 'dev' ;;
        *) printf '' ;;
    esac
}

# ---- 팀 페르소나 명단 (PL|m1|m2|m3) ----

# 명단 순서 헌법 (dispatch v0.6.6 #5): PL | drafter | reviewer | finalizer
# = pane 0(왼쪽 큰) | pane 1 | pane 2 | pane 3 (오른쪽 stack 위→아래).
persona_list_team() {
    case "${1:-}" in
        plan)        printf '이종선|장그래|김민교|안영이' ;;
        design)      printf '우상호|장원영|이수지|오해원' ;;
        dev|dev-be)  persona_list_team_dev_be ;;
        dev-fe)      persona_list_team_dev_fe ;;
        *) printf '' ;;
    esac
}

# 개발팀 백엔드 default (dispatch v0.6.6 #5 헌법: PL + drafter + reviewer + finalizer).
# pane 순서: PL(왼쪽 큰) | drafter | reviewer | finalizer (오른쪽 stack 위→아래).
persona_list_team_dev_be() {
    printf '공기성|카더가든|최우영|현봉식'
}

# 개발팀 프론트 default (FE 4명 = PL + drafter + reviewer + finalizer 패턴 동일).
persona_list_team_dev_fe() {
    printf '공기성|지예은|백강혁|김원훈'
}
