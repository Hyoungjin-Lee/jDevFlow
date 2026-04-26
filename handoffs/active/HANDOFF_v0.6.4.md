---
version: v0.6.4
status: active
date: 2026-04-27
prev_session: 27 (Stage 1~4.5)
next_session_recommended_model: Opus 4.7 1M xhigh (운영자 정책 — 까먹지 말라고)
---

# v0.6.4 HANDOFF — Jonelab AI팀 운영자 대시보드

## 다음 세션 시작 시 R2 read 순서

1. `CLAUDE.md` → `docs/bridge_protocol.md` → `docs/operating_manual.md`
2. `docs/01_brainstorm_v0.6.4/brainstorm.md` (Stage 1)
3. `docs/02_planning_v0.6.4/planning_index.md` (Stage 4 plan_final 통합)
4. `docs/bug_reports/BR-001_orchestrator_polling_missing.md` (3-tier polling 정책)
5. memory: `project_v064_dashboard_spec.md`, `project_v065_context_engineering.md`, `project_roadmap.md`, `feedback_orc_split_panes.md`, `feedback_session_scope.md`

## 현재 위치

**Stage 4.5 게이트 통과 완료 → Stage 5 진입 직전**

- Stage 4 plan_final = 박지영 PL commit `f8a2c9c` (push 미포함, Score 98/100)
- Stage 4.5 Q1~Q5 = **회의창(CTO 실장) 자율 결정 완료** (운영자 세션 27 명시 위임), 박지영에 bridge-064로 송신:
  - Q1 (F-D3): 18명 박스 + PM 별도 status bar 1행 / CTO·CEO 표시 X
  - Q2 (Q-M2-1): 정확 hook (Stage 5 +8h)
  - Q3 (Q-M4-2): osascript 기본 (Pushover 회피)
  - Q4 (Q-M5-2): P1 유지 (macOS 단독 + Windows skeleton)
  - Q5 (Q-M2-5): idle 통합 confirm
- 박지영 = F-D3 본문 박음 + commit 진행 중 (다음 세션 첫 검증)

## 다음 세션 즉시 액션

1. 박지영 F-D3 commit 검증 (`tmux capture-pane -t %75`)
2. Stage 5 dispatch 작성 + `Orc-064-dev` (공기성 PL) spawn
3. bridge-064 Monitor `bg9u8cfwy` 가동 상태 확인 (필요 시 재시작)
4. 백그라운드 task `buzr602da` 결과 회수 또는 cancel

## 본 세션 산출 (commits)

| SHA | 영역 |
|---|---|
| e31db85 / cead63d / aa9abd8 / 2cb90b7 | Stage 1 brainstorm |
| 3c08b01 | 헌법 사고 13 (Orc split + 페르소나 이름) |
| 286c9e3 | 헌법 노이즈 처리 (Sec.7 + Sec.8 9번) |
| a7ff198 / a969582 | BR-001 (3-tier polling) |
| f8a2c9c | 박지영 Stage 4 plan_final (98%) |

## 본 세션 박은 헌법 (`docs/bridge_protocol.md`)

- Sec.4 표 = 오케 split 4 panes (필수, 좌=오케 / 우=팀원 3 stack)
- Sec.6 사고 13 = Orc 안 split + 페르소나 이름 누락
- Sec.7 = 노이즈 task-notification 처리 정책
- Sec.8 자가 점검 9항목 (8번 split 강제 + 9번 노이즈 회피 추가)

## 본 세션 박은 memory

- `feedback_session_scope.md` (운영자가 5/6번 직접 추가 — 노이즈 처리 + 영역 외 시그널)
- `feedback_orc_split_panes.md` (헌법)
- `project_v065_context_engineering.md` (8개 핵심 영역 + 작업 속도, 효율 컨텍스트 관리 방향)
- `project_roadmap.md` (v0.6.5~v0.9 8단계, v0.7 완전 클로즈 / v0.9 오픈 베타+마케팅팀)
- `user_company_domains.md` (joneflow.dev 단일 등록 결정)
- `user_design_tools.md` (Figma 회사 기본 / Sketch 고객사)

## 본 세션 누적 사고 (다음 세션 자가 점검 강화 영역)

- 사고 5 (추측 진행) — ghostty 진단 미스: `ps | head -5` 잘림으로 spawn 실패 오진
- 사고 13 (Orc split) — 헌법 박힘, 4 panes + 페르소나 이름 강제
- 사고 14 후보 (BR-001) — 3-tier idle polling 부재
- claude CLI auto-rename으로 pane title 덮어씀 → `set-option allow-rename off` + `automatic-rename off` 영구 적용 필요 (Orc-064-plan에 적용 완료)
- chained Bash 명령 (`cd ... && git ...`)이 settings.json 권한 패턴과 미스매치 → 분리 명령 패턴 사용

## DEFCON 기준 (운영자 위임 세션 27)

회의창(CTO 실장) 자율 영역:
- Stage 4.5 Q 결정 / 사고 처리 / 헌법 박음 / 정정 사이클 / 검증 / commit / dispatch 발행

운영자 호출 (DEFCON):
- `git push` / `git push --force` / 원격 변경
- 외부 API 호출 (비용·영향)
- 비복구 손실 (`rm -rf` / `git reset --hard` / `git branch -D`)
- 보안 위반 / 시크릿 노출

## settings.json 갱신 (.claude/settings.json)

`permissions.allow` + `permissions.deny` 신설 (세션 27). 단, **chained 명령은 권한 패턴 미스매치**라 단일 명령으로 분리해야 함.

## 모토 / 도메인 / 로드맵 (memory `project_roadmap.md` 참조)

- 기본 정신 = "비전공자도 쉽게 하는 AI 팀 운영 프레임워크" (운영자 명시, 모토 다듬기 후보 4개 = "초보도 쉽게" / "누구나 쉽게" / "쉽게 시작하는" / "코딩 몰라도 되는")
- 도메인 = `joneflow.dev` 단일 등록 결정 (`.ai`/`.io` 미등록, AI 색은 콘텐츠로)
- v0.6.5 = 컨텍스트 엔지니어링 (회의창 헌법/메모리 자가 적용 메커니즘)
- v0.6.6 = 외부 통합
- v0.6.7~8 = 디자인·문서 스킬
- v0.6.9 = jOneFlow 문서 산출 (도그푸딩)
- v0.7 = 완전 클로즈 (직원 한정)
- v0.8 = 정밀화
- v0.9 = 오픈 베타 + 마케팅팀 신설 (데스크리서치/카피라이팅 등)
