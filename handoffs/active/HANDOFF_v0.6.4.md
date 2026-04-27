---
version: v0.6.4
status: active
date: 2026-04-27
prev_session: 28 (Stage 5~9 + 헌법 hotfix 다수)
next_session_recommended_model: Opus 4.7 1M xhigh (운영자 정책)
---

# v0.6.4 HANDOFF — Jonelab AI팀 운영자 대시보드

## 다음 세션 시작 시 R2 read 순서

1. `CLAUDE.md` → `docs/bridge_protocol.md` → `docs/operating_manual.md`
2. **`.skills/push-signal-watcher/SKILL.md`** (push 정공법 검증, 본 stage 핵심 박음)
3. **`.skills/ghostty-tmux-ops/SKILL.md`** (터미널 운영 표준)
4. **본 파일 (HANDOFF_v0.6.4.md)** ← 잔여 영역 + 운영자 결정 + 진행 시그널
5. memory read: `feedback_tone.md` / `project_v065_context_engineering.md` / `feedback_model_policy.md` / `feedback_orc_split_panes.md`

## 다음 세션 시작 첫 작업 (운영자 박음)

**push 정공법 3회 반복 검증** — 새 세션 진입 후 즉시 진행. 본 세션(28)에서 1회 검증 박힘 = 100% 작동. 새 세션에서 fresh 영역으로 3회 더 박아서 안정성 + 재현성 확인.

검증 후 본 stage 잔여(Stage 10/11/12/13) 진행.

## 현재 위치 = Stage 9 COMPLETE 후 Stage 12 진입 직전

| 진행 | commit | 결과 |
|------|------|------|
| Stage 1~4 (기획) | f8a2c9c + 7c139b6 | Score 99/100 + Stage 4.5 PASS |
| Stage 5 (기술 설계) | bf81e4f | Score 97/100 verdict GO |
| Stage 6/7 (디자인) | 8fbbfed | Score 95/100 verdict GO |
| Stage 8 (구현 M1~M5) | 77ee684 / 3c4ade4 / 721916b / 60c38e0 / f5194b0 / edef494 | M1~M5 5/5 + personas_18 (6 commits) |
| **Stage 9 (코드 리뷰)** | **c32d237** | **APPROVED Score 92/100, R-N 8건 (Critical 0 / Major 2 / Minor 4 / Nit 2)** |

## ★ 운영자 결정 3건 (다음 세션 받기)

### 1. Stage 12 QA 운영 방식

- (a) 운영자 + 회의창 직접 진행 (수동 시나리오, 작업 지시서 X)
- (b) 작업 지시서 작성 + Orc-064-dev 팀 재활용 (자동화)

### 2. Major 2건 (M-1 / M-2) 처리

- M-1: AC-T-4 spec deviation 단일 줄 (closure 영향 0건)
- M-2: PersonaDataCollector 18 process spawn 성능 (closure 영향 0건)
- 옵션 A: PL 자율 판정 그대로 (Stage 10 압축, v0.6.5로 미룸)
- 옵션 B: Stage 10 분기 → fix → Stage 12 재진입

### 3. Stage 11 Strict 검증 압축 여부

- 풀 검증 vs 자율 압축 trail (PL 판정)

## 본 세션(28)에서 박은 헌법 변경 (영구 박힘)

| commit | 영역 |
|--------|------|
| 9902a68 | A 패턴 헌법 (drafter → reviewer 검토+수정 → finalizer 마감, 모든 프로세스 동일 / drafter v2 단계 폐기 단순함 정공법) |
| 0438da9 | 추측 진행 강제 회피 (Sec.3 추측 push 금지 + Sec.6 사고 5 정밀화 + Sec.8 9→11항 + CLAUDE.md MANDATORY 6항) |
| 1ab33f0 | Sec.11 v0.6.5+ 강력 권고 정책 (버전 분할 / 병렬 Orc spawn / 추가 페르소나 활성화 / 분량 검토 / 마일스톤 임계) |
| 2b11b04 | CLAUDE.md 15줄 페르소나 정정 (브릿지→회의창 / Cowork→Code) |
| 0d6e993 | jDevFlow_corrupt + recovered + superpowers 디렉토리 영역 정리 |
| 4eff961 → 7563bda → 7c806f2 → efea4be | heartbeat_daemon hotfix 4건 (Python 본체 + bridge 추적 + OS 자동 분기 + 함수명 정정) |
| **b482394** | **push-signal-watcher + ghostty-tmux-ops SKILL 박음 + .skills/README.md 그룹 인덱스** |

## 본 세션 박은 핵심 발견 (★ push 정공법 검증)

운영자 박음 = bridge → 회의창 push 정공법 = **100% 작동 확인**.

```
회의창 → bridge: "10초 후 완료 파일 박아" send-keys
       → background watcher task 박음 (파일 polling + 발견 즉시 종료)
bridge: 10초 후 완료 파일 박음
watcher task: 파일 발견 즉시 종료 → task-notification 자동 도착
회의창: 운영자 메시지 X 자발적 깨어남 → 결과 read → 운영자께 보고
```

= **사고 9 본질 회피 가능**. 본 stage trail 5번 사고 9 변종 영역 = v0.6.5 정공법 박는 시점에 영구 회피.

박힌 SKILL: `.skills/push-signal-watcher/SKILL.md` (검증 결과 + 코드 패턴 + 사용 시점 박음).

## 본 세션 누적 사고 trail (다음 세션 자가 점검 강화 영역)

- **사고 9 변종 5번 재발** = 회의창이 자발적 read 못 함, 운영자 trigger 받아야 인지 — push-signal-watcher SKILL로 영구 회피 가능
- **사고 5 변종 누적** = 회의창이 capture만 보고 추측 박음 (산출 디스크 / git log / 시그니처 wrap 검증 X) — Sec.8 11항 박음으로 강제, 단 100% X (자동 강제 메커니즘은 v0.6.5)
- **사고 14 누적 6건** = drafter pane PL 직접 작성 영역 (Stage 6/7 + Stage 8 M2~M5)
- **추측 진행 미화 표현** = 회의창이 "양심" / "정상 진행 중" 박음 = 헌법 6항(MANDATORY STARTUP)에 미화 금지 박음
- **헌법 박음 ≠ 적용** 패턴 = 텍스트 박아도 회의창이 또 위반 = v0.6.5 자동 강제 메커니즘 강력 근거

## v0.6.5 의제 박힘 (memory `project_v065_context_engineering.md`)

본 세션에서 추가 박힌 의제:
1. **터미널 일반 모드 회귀** (read-only attach 폐기)
2. **send-keys 자가 검증 강제** (Esc * 3 / Ctrl+G / "체" 입력 사고 회피)
3. **AI팀 운영 spec v2 패키지** (dispatch 무게 / 분할 패턴 / 페르소나 본분 / 헌법 보강 / 자동 강제)
4. **active/archive 버전 관리 패턴 확장**
5. **운영자 자유토론 풀이 정책** (단계별 분할 의제)
6. **하네스 구조 다듬기**
7. **롤(페르소나 본분) 정의 명확화**
8. **후킹 데몬 (heartbeat 데몬 → push 정공법 통합)**
9. **에이전트 팀 vs 서브에이전트 비교** (운영자 톤 = 에이전트 팀 default)
10. **drafter v2 단계 강제 폐기** (A 패턴 = 모든 프로세스 동일)
11. **Codex plugin-cc 자동 호출 통합** (운영자 결정 = C, v0.6.5 본격)
12. **모든 하위 폴더 파일 일괄 정합 작업** (조직도 / 모델 / effort / 헌법 변경 후 정합 / 모든 케이스)

## 본 stage release 흐름

```
[다음 세션 시작]
   → push 정공법 3회 반복 검증
   → 운영자 결정 3건 받기 (Stage 12 운영 / Major 처리 / Stage 11 압축)
   → Stage 10 (필요 시 — Major fix 결정 따라)
   → Stage 11 Strict 검증 (압축 결정 따라)
   → Stage 12 QA
   → Stage 13 release (운영자 push/tag 게이트)
[v0.6.4 release 완료 후]
   → 모든 하위 폴더 파일 일괄 정합 작업 (운영자 박음, v0.6.5 brainstorm 직전)
   → v0.6.5 brainstorm 진입 (컨텍스트 엔지니어링 본격)
```

## DEFCON (운영자 호출 영역만)

- `git push` / `git push --force` / 원격 변경
- 외부 API 호출 (비용/영향)
- 비복구 손실 (`rm -rf` / `git reset --hard` / `git branch -D`)
- 보안 위반 / 시크릿 노출

DEFCON 외 = 회의창 자율.

## 운영자 정책 박음 (memory + 본 세션 trail)

- **모델**: Opus 4.7 1M xhigh (회의창 본 모델, MAX 20x 요금제, 과사고 시 high/medium 낮춤)
- **톤**: 부드러운 ~네요/~죠 + **비전공자 친절체** (영어/약어 한국어 풀이, 미화 금지) — `feedback_tone.md` 갱신 박음
- **터미널 운영**: Ghostty + tmux 4 panes + @persona 영구 박음 (`.skills/ghostty-tmux-ops/SKILL.md`)
- **push 정공법**: 무한 polling 영역 X / 짧은 watcher task + 파일 박음 + task-notification (`.skills/push-signal-watcher/SKILL.md`)
- **A 패턴**: drafter → reviewer 검토+수정 → finalizer 마감 (모든 프로세스 동일)
- **dispatch 무게 정책**: drafter ≤ 800줄 / reviewer ≤ 600줄 / finalizer ≤ 500줄 (본문 작성 X)
- **DEFCON 외 자율**: 운영자 명시 위임 (세션 27/28)
- **3중 검증 강제**: capture + 디스크 + git log (Sec.8 10항)
- **부팅 검증 강제**: 4 panes 전체 (Sec.8 11항)
