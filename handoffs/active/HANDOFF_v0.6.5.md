---
version: v0.6.5
status: active
phase: brainstorm
date: 2026-04-27
prev_version: v0.6.4 (paused, Stage 9 COMPLETE 후 정지)
next_session_recommended_model: Sonnet medium (운영자 결정 — 16-stage Stage 01 브레인스토밍 확산 영역)
---

# v0.6.5 HANDOFF — 컨텍스트 엔지니어링 + 16-stage 결합 설계

## ⚠️ 작업 디렉토리

```
ROOT = /Users/geenya/projects/Jonelab_Platform/jOneFlow
```

새 세션 진입 시 working directory가 `/Users/geenya/projects/Jonelab_Platform/`에 박혀있을 수 있어요. 모든 R2 파일은 그 아래 `jOneFlow/` 서브에 있어요.

```bash
cd /Users/geenya/projects/Jonelab_Platform/jOneFlow
pwd  # → /Users/geenya/projects/Jonelab_Platform/jOneFlow
```

## R2 읽기 순서

1. `CLAUDE.md` → `docs/bridge_protocol.md` → `docs/operating_manual.md`
2. **본 파일 (`HANDOFF_v0.6.5.md`)** ← v0.6.5 진입 컨텍스트 + 결정 영역 박힘
3. `handoffs/active/HANDOFF_v0.6.4.md` (paused, 잔여 release 영역 트레일)
4. `docs/session_2026-04-27_cowork_brainstorm.md` (Chat Claude 박은 진단 + 핵심 의제)
5. memory: `user_assistant_persona.md` / `feedback_tone_no_bakeum.md` / `feedback_no_claude_solo.md` / `project_v065_context_engineering.md`

## v0.6.5 진입 결정 영역 (2026-04-27 운영자 명시)

### 1. 16-stage 워크플로 매트릭스 채택

운영자 박음 = 외부(Chat / 다른 LLM) 영역에서 만든 16-stage 워크플로 매트릭스 채택. **"기존이랑 크게 다를 게 없다"** + **"Claude에 다 맡기면 안 된다"** 운영자 직관.

| 단계 | 워크플로 | 담당 | 모델 | Effort |
|---|---|---|---|---|
| 01 | 브레인스토밍 (확산) | Claude | Sonnet | Low-Med |
| 02 | 브레인스토밍 (선별) | Claude | Opus | Medium |
| 03 | 기획 초안 | Claude | Sonnet | Medium |
| 04 | 기획 리뷰 (Quality Gate) | Claude | Opus | High |
| 05 | 최종 기획 확정 | Claude | Sonnet | Low |
| 06 | 운영자 승인 | 사용자 | — | — |
| 07 | 기술 설계 | Claude | Opus | High |
| 08 | 디자인 초안 | 디자인 에이전트 | Sonnet | Medium |
| 09 | 디자인 수정/반영 | Claude | Sonnet | Medium |
| 10 | 기술/디자인 충돌 리뷰 | Claude | Opus | High |
| 11 | 코드 구현 | Claude Code | Sonnet | Medium |
| 12 | **코드 리뷰 (감사)** | **Codex** | Codex | High |
| 13 | 코드 수정 반영 | Claude Code | Sonnet | Medium |
| 14 | **최종 검증 (테스트)** | **Codex** | Codex | High |
| 15 | QA (종합위험점검) | Claude+Codex | Opus+Codex | High |
| 16 | 릴리즈/배포 | Claude | Sonnet | Low |

**핵심 가치 = Codex 독립 감사 부서 (Stage 12 + 14 고정).** "Codex의 리뷰 없는 구현은 배포 불가" 절대 순서. brainstorm 문서 핵심 의제(stage9_review='codex' 무시 사고 = 텍스트 규칙 ≠ 강제)를 **구조로 강제**하는 정공법.

### 2. 인사 변경

- **박지영** — 기획팀 PL → **CTO 실장 (승진)**
- **이종선** — 기획팀 PL **신규 입사**
- **이희윤** — PM 브릿지 **신규 입사**
- **백현진** (전 CTO 실장) — **퇴사**
- **스티브 리** (전 PM 브릿지) — **퇴사**

조직도 일괄 갱신 완료: `operating_manual.md` Sec.1.1 + 1.2 + 1.5 + 4.1 + 4.2 / `bridge_protocol.md` Sec.0 / `CLAUDE.md` 15줄.

### 3. v0.6.4 commit 4건 인수 결정

Chat Claude가 v0.6.4 main에 박은 4 commit (8c3f56b/3881b22/2a9938a/fb46069) **인수 박음**:
- 8c3f56b — JSONL 기반 상태 감지 (token_hook + persona_collector, subprocess ~33배 감소)
- 3881b22 — monitor_bridge.sh Python 위임 + monitor_bridge_jsonl.py 신규 + heartbeat_daemon JSONL 갭 기반
- 2a9938a — tmux_adapter.py capture-pane 메서드 완전 삭제 (-121줄)
- fb46069 — dispatch 7건 +869줄

진단 결과: 호출 영역 깨짐 0건 / py_compile PASS / shellcheck 깨끗. brainstorm 문서 + 운영자 직관(터미널 의존 회피)과 방향 정합. 인수 정공법.

## v0.6.5 brainstorm 핵심 의제 영역 (memory + 본 세션 박힌 영역)

### 결합 설계 (16-stage + jOneFlow 헌법)

16-stage = **단계 정의(워크플로 표면)**, jOneFlow 현행 = **운영 인프라(페르소나 / A 패턴 / 모드 / Stop hook / 게이트)** — 두 층 결합 설계.

| 결합 영역 | 내용 |
|---|---|
| 페르소나 매핑 | 16-stage의 "Claude / Codex / 디자인 에이전트" → jOneFlow 18명 페르소나 + A 패턴(drafter→reviewer→finalizer) 매핑 |
| 모드 결합 | 16-stage 채택이 Lite/Standard/Strict 모드 영역과 어떻게 정합할지 (핫픽스에도 16단계 강제? 또는 모드별 압축?) |
| stage_assignments | F-2-a 정책 영역 = team_mode 리터럴 표시 경로만 + stage8_impl/stage9_review/stage10_fix/stage11_verify 분기 → 16-stage Codex 고정 영역과 결합 |
| Stop hook 강제 메커니즘 | brainstorm 문서 핵심 의제. 팀원 완료 → `.claude/status/{session}.json` / 오케 완료 → `bridge_status.json` / 다음 단계 자동 트리거 |
| 운영자 게이트 | 현행 Stage 1 + 4 + 11 → 16-stage Stage 6 + ??? (Stage 16 릴리즈 영역 운영자 게이트 명시 X = DEFCON 영역 정합 박음 필요) |
| 운영 인프라 | tmux + bridge + persona + send-keys 영역 = 16-stage 매트릭스 미정의. 본 영역 결합 박음 |

### v0.6.5 의제 12건 (memory `project_v065_context_engineering.md`)

1. 터미널 일반 모드 회귀 (read-only attach 폐기)
2. send-keys 자가 검증 강제 (Esc * 3 / Ctrl+G / "체" 입력 사고 회피)
3. AI팀 운영 spec v2 패키지 (dispatch 무게 / 분할 패턴 / 페르소나 본분 / 헌법 보강 / 자동 강제)
4. active/archive 버전 관리 패턴 확장
5. 운영자 자유토론 풀이 정책 (단계별 분할 의제)
6. 하네스 구조 다듬기
7. 롤(페르소나 본분) 정의 명확화
8. 후킹 데몬 (heartbeat 데몬 → push 정공법 통합)
9. 에이전트 팀 vs 서브에이전트 비교
10. drafter v2 단계 강제 폐기 (A 패턴 = 모든 프로세스 동일)
11. Codex plugin-cc 자동 호출 통합 → **본 세션에서 16-stage Stage 12/14 Codex 고정으로 격상**
12. 모든 하위 폴더 파일 일괄 정합 작업

## 회의창 본분 (재확인)

- 본 회의창 = **박지영 CTO 실장 (Sonnet medium)**
- 회의창 본분 = (1) 운영자와 회의 (2) 브릿지에 dispatch 송출. 이외 일 = 위반
- 메모리 박힘 = `feedback_tone_no_bakeum.md` ("박음"·"영역" 토큰 반복 금지)
- 메모리 박힘 = `feedback_no_claude_solo.md` (Claude 단독 위임 금지, Codex 독립 감사 강제)

## 다음 세션 자유토론 첫 의제 영역 추천

회의창 추천 입구 = **결합 설계 어디서 시작할지** 운영자 자유 발언 받기. 후보:
- (a) 페르소나 매핑 (16-stage 주체 → 18명 + A 패턴)
- (b) Stop hook 강제 메커니즘 (구조로 강제)
- (c) 모드 결합 (Lite/Standard/Strict + 16-stage)
- (d) 운영자 자유 의제

## DEFCON (운영자 호출 영역만)

- `git push` / `git push --force` / 원격 변경
- 외부 API 호출 (비용/영향)
- 비복구 손실 (`rm -rf` / `git reset --hard` / `git branch -D`)
- 보안 위반 / 시크릿 노출

DEFCON 외 = 회의창 자율.

## 운영자 정책 (영구 박힘, v0.6.4 → v0.6.5 이월)

- **모델**: 회의창 = Sonnet medium / 브릿지 = Opus 4.7 1M xhigh / 오케 + 리뷰어 = Opus high / 파이널리즈 = Sonnet medium / 드래프터 = Haiku medium
- **톤**: 부드러운 ~네요/~죠 + 비전공자 친절체. "박음"·"영역" 토큰 반복 금지(메모리 `feedback_tone_no_bakeum.md`).
- **Claude 단독 위임 금지**: 코드 리뷰 / 검증 / 감사 영역 = Codex 강제 (메모리 `feedback_no_claude_solo.md`)
- **A 패턴**: drafter → reviewer 검토+수정 → finalizer 마감 (모든 프로세스 동일)
- **터미널 운영**: Ghostty + tmux 4 panes + @persona 영구 (`.skills/ghostty-tmux-ops/SKILL.md`)
- **push 정공법**: watcher task + 파일 박음 + task-notification (`.skills/push-signal-watcher/SKILL.md`)
- **DEFCON 외 자율**: 운영자 명시 위임 (세션 27/28)
- **3중 검증 강제**: capture + 디스크 + git log (`bridge_protocol.md` Sec.8 10항)
- **부팅 검증 강제**: 4 panes 전체 (`bridge_protocol.md` Sec.8 11항)
- **추측 진행 금지**: 미화 표현("양심"/"정상 진행 중") X. 진단 불확실 시 "확인 필요" 명시 후 검증 진입.
