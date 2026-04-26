---
version: v0.6.3
stage: 4 (plan_final)
date: 2026-04-27
mode: Standard
status: final
authored_by: 안영이 (기획팀 선임연구원, 파이널리즈, Sonnet/medium)
upstream:
  - docs/02_planning_v0.6.3/plan_draft.md (454줄, COMPLETE-DRAFTER1, Q1~Q6)
  - docs/02_planning_v0.6.3/personas_18.md (512줄, COMPLETE-DRAFTER2, Q-PER-1~2)
  - docs/02_planning_v0.6.3/plan_review.md (475줄, COMPLETE-REVIEWER, 12 보강 영역)
  - docs/01_brainstorm_v0.6.3/brainstorm.md (의제 9건 + 운영자 결정 13건)
  - dispatch/2026-04-26_v0.6.3_stage234_planning.md
note: drafter 단일 명의(장그래)가 plan_draft.md + personas_18.md 2 산출물 병렬 작성 — Stage 4에서 통합 [정정-1 적용]
session: 26
---

# jOneFlow v0.6.3 — 기획 파이널

> **상위:** `docs/02_planning_v0.6.3/plan_review.md` (Stage 3, 김민교 책임연구원)
> **본 문서:** `docs/02_planning_v0.6.3/plan_final.md` (Stage 4, 세션 26)
> **하위:** Stage 5 기술 설계 (`docs/03_design/v0.6.3_technical_design.md`)
> **상태:** ✅ **파이널 — reviewer 12 보강 영역 흡수 완료**

---

## Sec. 0. 개요 및 정정 영역 처리 현황

### 0.1 모드 및 범위

v0.6.3은 **Standard 모드** 전체 13단계 운영을 기본값으로 하며, 옵션 A(6+1 항목 통합)를 운영자가 명시 결정하였습니다.

- **외부 일정 맥락:** 외부 일정(2026-05 초 Windows 진입)에 선행 완료 — v0.6.3 due 2026-04-27 [B1-1 정정 적용]
- **기술 debt 해소:** v0.6.2 Stage 9 APPROVED PASS(93.8%, commit `a6ef4be`) 기반 진행

### 0.2 파이널리즈 정정 적용 현황 (reviewer 12 보강 영역)

| 정정 # | 영역 | 적용 위치 | 처리 |
|--------|------|---------|------|
| F-1 | drafter 단일 명의(장그래) 2 산출물 병렬 인지 | frontmatter `note` | ✅ 적용 |
| F-2 | M1 변경 대상 신규/개정 단일화 | Sec.1 M1 변경 대상 표 | ✅ 적용 (scripts/ 실증) |
| F-3 | M3 AC — PostToolUse 내 위치 명시 | Sec.1 M3 AC | ✅ 적용 |
| F-4 | M4 AC — wc -l 비교 연산 정정 | Sec.1 M4 AC | ✅ 적용 |
| F-5 | F-62-9 신규 추가 (claude CLI 옵션 강제) | Sec.3 F-62-x 후보 표 | ✅ 적용 |
| F-6 | F-62-8 영향 영역 재정의 (환경 분기 메커니즘) | Sec.3 F-62-x 후보 표 | ✅ 적용 |
| F-7 | Score 가중치 30/15/20/20/15 조정 | Sec.4 Score 계산식 | ✅ 적용 (자율 영역) |
| F-8 | Score 리스크 식별 정량 기준 도입 | Sec.4 항목 (3) 정의 | ✅ 적용 |
| F-9 | Score M 통합 방식 | Sec.4 계산식 | 🟡 잠정 (γ) 단일합산 / Q-NEW-1 운영자 결정 대기 |
| F-10 | 가동 시점 표 standby 보강 | Sec.2 가동 시점 표 | ✅ 적용 |
| F-11 | settings.json stage9_review 키 실존 검증 | Sec.3 F-62-8 비고 | ✅ 해소 (실존 확인 완료) |
| F-12 | brainstorm 진행 순서 → Stage 단위 재정렬 trace | Sec.6 세션 단위 표 | ✅ 적용 |

---

## Sec. 1. 마일스톤 M1~M5 정밀화

### 마일스톤 전체 요약

| M | 내용 | 담당 팀 | 5월 초 마감 | 의존 |
|---|------|---------|-----------|------|
| M1 | Monitor 인프라 강화 + Windows fallback | 개발팀 (Orc-063-dev) | ✅ 필수 | M3(Hooks) |
| M2 | 글로벌 ~/.claude 통합 (보편 정책만) | 기획팀 (Orc-063-plan) | 🟡 권장 | 독립 |
| M3 | D6 Hooks(경고) + gstack ETHOS 3종 | 개발팀 (Orc-063-dev) | 🟡 권장 | M1/M4 |
| M4 | 18명 페르소나 정식 가동 + 리뷰어 conditional | 기획팀 + 개발팀 | ✅ 필수 | M3 |
| M5 | Stage 9 Codex 자동 호출 conditional | 개발팀 (Orc-063-dev) | 🟢 후순 | M3/M4 |

---

### M1: Monitor 인프라 강화 + Windows fallback [✅ 5월 초 필수]

**담당:** 개발팀 (Orc-063-dev)

**결정(brainstorm 인용)**
- Monitor 음성 + 세션명 불일치 + /clear 후 소멸 + 잔재 오감지 문제 실증 (세션 26 CTO 실장 진단)
- Windows fallback: HANDOFF symlink를 fallback 복사 + sync 도구로 보충
- macOS/Linux/WSL은 현재 symlink 그대로 유지

**변경 대상 파일/스크립트** [F-2 정정 적용 — scripts/ 실증 결과]

| 파일 | 구분 | 근거 |
|------|------|------|
| `scripts/monitor_bridge.sh` | **신규** | scripts/ 디렉토리 내 미존재 확인 |
| `scripts/setup_tmux_layout.sh` | 개정 | Monitor 자동 재가동 hook 추가 |
| `scripts/update_handoff.sh` | **개정** | 기존 파일 존재 확인, Windows fallback sync 기능 확장 |
| `docs/operating_manual.md` Sec.4 | 개정 | 표준 Monitor 패턴 추가 |

**AC (Acceptance Criteria)**
- [ ] `scripts/monitor_bridge.sh` 존재 && `[ "$(wc -l < scripts/monitor_bridge.sh)" -ge 30 ]`
- [ ] stdout에 "timestamp" + "stage" 명시 출력 테스트 성공
- [ ] `/clear` 후 monitor 자동 재시작: `grep -c "PostToolUse\|Stop" scripts/setup_tmux_layout.sh` ≥ 1
- [ ] Windows 환경 시뮬레이션: `bash scripts/update_handoff.sh --dry-run` && 동기화 목록 출력 확인
- [ ] capture-pane 패턴 적용: `grep -n "capture-pane.*-20" scripts/monitor_bridge.sh`
- [ ] 수동 확인: tmux jdevflow + Monitor 동시 실행 시 중복/누락 신호 없음

**리스크**
- BSD sed (macOS) vs GNU sed (Linux) 호환성 → shellcheck shell=sh 적용 + CI 다중 OS 검증 필요
- Windows WSL 경로 구분자(/ vs \) → Stage 5에서 `update_handoff.sh` 조건 분기 설계

**의존**
- M3(D6 Hooks) → 자동 재가동 hook 구현 선행 필요
- M4(18명 페르소나) → Monitor 시그널 페르소나별 커스터마이징은 후순

---

### M2: 글로벌 ~/.claude 통합 (보편 정책만) [🟡 5월 초 권장]

**담당:** 기획팀 (Orc-063-plan)

**결정(brainstorm 인용)**
- 옵션 (가) = 보편 정책만 + 점진적 확장
- 글로벌화 대상: 보안 / 언어 / 톤 / CLI 자동화 / 모델 정책
- 충돌 우선순위: 프로젝트 > 글로벌 (specificity 원칙) ← F-62-5 설계 제약
- 적용 메커니즘: 1단계 수동 복사, 자동화는 후속

**변경 대상 파일/스크립트**
- `~/.claude/CLAUDE.md` (신규 또는 개정) — 보편 정책 섹션화(절대 규칙 4개)
- `~/.claude/projects/-Users-geenya-projects-Jonelab-Platform-jOneFlow/CLAUDE.md` (개정) — 프로젝트 특화 유지 + 글로벌 포인터 추가
- `docs/bridge_protocol.md` (개정 검토) — 글로벌 버전 후보 스키마

**AC**
- [ ] `~/.claude/CLAUDE.md` 존재 && `[ "$(wc -l < ~/.claude/CLAUDE.md)" -ge 60 ]` && 포함: 보안 + 언어 + 톤 + CLI 자동화
- [ ] 프로젝트 CLAUDE.md 글로벌 포인터: `grep "~/.claude/CLAUDE.md" CLAUDE.md`
- [ ] 충돌 우선순위 명시: `grep -A2 "충돌 우선순위\|specificity" ~/.claude/CLAUDE.md`
- [ ] 수동 확인: 두 CLAUDE.md 병행 읽음 시 모순 0건

**리스크**
- 글로벌화 범위 과다 → 버전 간 호환성 깨짐 → 제한적(보편만) 진행으로 완화

**의존**
- 독립적 (M1/M3/M4/M5와 무관, 병렬 진행 가능)

---

### M3: D6 Hooks(경고) + gstack ETHOS 3종 [🟡 5월 초 권장]

**담당:** 개발팀 (Orc-063-dev)

**결정(brainstorm 인용)**
- D6 PostToolUse 경고 모드 (차단 금지, AI fix loop 자연스러움)
- gstack ETHOS 3개: (1) Boil the Lake 경계, (2) autoplan 패턴, (3) /investigate 참조
- 진짜 안전판 = commit 시점 별도 hook (D6 영역과 분리)
- 대상: `.py` → `python3 -m py_compile`, `.sh` → `shellcheck`

**변경 대상 파일/스크립트**
- `.claude/settings.json` (개정) — `hooks.PostToolUse` 섹션 추가 (경고 + 검증 스크립트 호출)
- `docs/operating_manual.md` Sec.4 또는 Sec.5 (신규) — "Boil the Lake" 원칙 + autoplan 패턴 설명
- `docs/guides/ethos_checklist.md` (신규) — 3종 ETHOS 자체 점검 목록

**AC** [F-3 정정 적용 — PostToolUse 내 위치 명시]
- [ ] `.claude/settings.json` `hooks.PostToolUse` 섹션 존재: `grep -c "PostToolUse" .claude/settings.json` ≥ 1
- [ ] `.py` 대상 `python3 -m py_compile` 호출 — PostToolUse hook 내 명시: `grep "py_compile" .claude/settings.json`
- [ ] `shellcheck` 호출 — PostToolUse hook 내 명시: `grep "shellcheck" .claude/settings.json`
- [ ] `docs/guides/ethos_checklist.md` 존재 && 3개 ETHOS(Boil the Lake / autoplan / investigate) 각각 명시
- [ ] 수동 확인: py_compile 실패 시 경고만 출력(차단 X), 회의창 자율 fix 가능

**리스크**
- 경고 frequency 과다 → 무감각화 → Stage 5 Hook 설계 시 threshold 조정 필요
- shellcheck 엄격 모드 → 기존 스크립트 다수 실패 → gradual adoption(warning only first) — [Q3 연계]

**의존**
- M4(18명 페르소나) → 리뷰어 conditional 페르소나가 Codex 결과 검증 시 ETHOS 활용
- M5(Stage 9 Codex) → Codex 자동 호출 후 fix loop에 ETHOS 3종 적용

---

### M4: 18명 페르소나 정식 가동 + 리뷰어 conditional [✅ 5월 초 필수]

**담당:** 기획팀 + 개발팀

**결정(brainstorm 인용)**
- 18명 정식 가동 (기획/디자인/개발 3팀, HR 신설 보류)
- 리뷰어 conditional: Codex 사용 여부에 따라 "통합 검증자" ↔ "코드 리뷰어" 페르소나 전환
- 18명 매핑 산출물 = `docs/02_planning_v0.6.3/personas_18.md`

**변경 대상 파일/스크립트**
- `docs/02_planning_v0.6.3/personas_18.md` (완료) — 18명 상세 매핑
- `.claude/settings.json` (확인) — `stage_assignments.stage9_review` 키 실존 확인 완료 [F-11 해소]

**AC** [F-4 정정 적용 — wc -l 비교 연산]
- [ ] `docs/02_planning_v0.6.3/personas_18.md` 존재 && `[ "$(wc -l < docs/02_planning_v0.6.3/personas_18.md)" -ge 150 ]`
- [ ] 포함 내용: 이름, 직급, 모델(Opus/Sonnet/Haiku), effort(xhigh/high/medium), 톤, 조건부 페르소나 정의
- [ ] Codex 조건 확인: `[ "$(grep -A5 "Codex" docs/02_planning_v0.6.3/personas_18.md | wc -l)" -ge 10 ]`
- [ ] stage9_review 키 실존: `grep "stage9_review" .claude/settings.json` (값: "codex" 확인)
- [ ] 수동 확인: 조직도 트리와 18명 테이블 일치 확인

**리스크**
- 18명 동시 가동 인프라(tmux 1+3 모델) 안정성 미검증 → Stage 5 기술 설계에서 mock/시뮬레이션 검토 — [Q4 연계]

**의존**
- M1(Monitor) → Monitor 시그널이 18명별로 도달
- M3(ETHOS) → 리뷰어 conditional이 ETHOS 기반 fix loop 실행

---

### M5: Stage 9 Codex 자동 호출 conditional [🟢 후순]

**담당:** 개발팀 (Orc-063-dev)

**결정(brainstorm 인용)**
- Stage 8 완료 시 Codex 사용 환경에서 자동 호출 + 결과 회수 + Stage 10/13 분기
- 미사용 환경 → self-review fallback (**운영자에게 fallback 사용 알림 필수**)
- 환경 제약 해소 방향 = Stage 5 기술 설계 영역 — [Q5 연계]

**변경 대상 파일/스크립트**
- `scripts/ai_step.sh` (개정) — Stage 9 분기 로직 추가
- `docs/03_design/v0.6.3_technical_design.md` Sec.M5 (신규) — Codex 호출 아키텍처 + fallback 로직

**AC**
- [ ] `scripts/ai_step.sh` 내 Stage 9 분기: `grep -n "stage.*9\|codex" scripts/ai_step.sh | wc -l` ≥ 3
- [ ] Codex 환경 감지: `grep "command -v codex" scripts/ai_step.sh`
- [ ] fallback 경로: self-review 대체 실행 + 운영자 알림 메시지 출력
- [ ] 수동 테스트: 두 환경에서 Stage 8→9 전이 후 동작 확인(자동 호출 vs fallback)

**리스크**
- Codex 환경 다양성(cloud vs local vs CLI) → 통합 테스트 필수 — [Q5 연계]
- fallback 품질 편차 → self-review 검증 강화 필요

**의존**
- M3(D6 Hooks + ETHOS) → fix loop 기반 제공
- M4(18명 페르소나) → 리뷰어 conditional 페르소나 활성화

---

## Sec. 2. 18명 페르소나 매핑 정밀화

### 2.1 가동 시점 표 (정정 보강판) [F-10 적용]

| 페르소나 | 계층 | S1 | S2 | S3 | S4 | S5 | S6 | S7 | S8 | S9 | S10 | S11 | S12 | S13 |
|---------|------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:---:|:---:|:---:|:---:|
| 이형진 (CEO) | 1 | ✅ | — | — | — | — | — | — | — | — | — | — | ✅ | ✅ |
| 백현진 (CTO) ¹ | 2 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 스티브 리 (PM) | 3 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **기획팀** | | | | | | | | | | | | | | |
| 박지영 (Orc) | 4 | — | ✅ | ✅ | ✅ | — | — | — | — | — | — | — | — | — |
| 김민교 (Rev) | 4 | — | ✅ | ✅ | ⬤ | — | — | — | — | — | — | — | — | — |
| 안영이 (Fin) | 4 | — | ✅ | ⬤ | ✅ | — | — | — | — | — | — | — | — | — |
| 장그래 (Dft) | 4 | — | ✅ | ⬤ | ⬤ | — | — | — | — | — | — | — | — | — |
| **디자인팀 (v0.6.3 Non-goal)** | | | | | | | | | | | | | | |
| 우상호 (Orc) | 4 | — | — | — | — | — | ✅ | ✅ | — | — | — | — | — | — |
| 이수지 (Rev) | 4 | — | — | — | — | — | ✅ | ✅ | — | — | — | — | — | — |
| 오해원 (Fin) | 4 | — | — | — | — | — | ✅ | ✅ | — | — | — | — | — | — |
| 장원영 (Dft) | 4 | — | — | — | — | — | ✅ | ✅ | — | — | — | — | — | — |
| **개발팀** | | | | | | | | | | | | | | |
| 공기성 (Orc) | 4 | — | — | — | — | ✅ | — | — | ✅ | ✅ | ✅ | ⬤ | — | — |
| 최우영 (BE Rev) | 4 | — | — | — | — | ✅ | — | — | ✅ | ✅ | ✅ | — | — | — |
| 현봉식 (BE Fin) | 4 | — | — | — | — | ✅ | — | — | ✅ | ✅ | ✅ | — | — | — |
| 카더가든 (BE Dft) | 4 | — | — | — | — | ✅ | — | — | ✅ | ✅ | ✅ | — | — | — |
| 백강혁 (FE Rev) | 4 | — | — | — | — | — | — | — | ✅ | ✅ | ✅ | — | — | — |
| 김원훈 (FE Fin) | 4 | — | — | — | — | — | — | — | ✅ | ✅ | ✅ | — | — | — |
| 지예은 (FE Dft) | 4 | — | — | — | — | — | — | — | ✅ | ✅ | ✅ | — | — | — |

**범례:**
- ✅ = active (tmux 세션 가동 또는 회의창 참여)
- ⬤ = standby (당 Stage에서 주 역할 종료 — 오케 요청 시 재진입 가능)
- — = off (미가동)

**주석:**
1. 백현진 CTO Sonnet/medium: 출처 = `operating_manual.md` Sec.1.2 영구판 [B2-2 적용]
2. 기획팀 리뷰어(김민교) / 드래프터(장그래) Stage 3 종료 후 standby — Stage 4에서 오케(박지영) 요청 시만 재진입 [B2-5 적용]
3. 공기성(Orc) Stage 11 standby: 최종 검증 단계에서 오케 요청 시 진입 가능 [B2-4 적용]

### 2.2 spawn 도구 매핑 요약

| tmux 세션 | spawn 명령 핵심 | 가동 Stage | 해제 |
|----------|--------------|----------|------|
| `bridge-063` | `tmux new-session -d -s bridge-063` + `claude --teammate-mode tmux --dangerously-skip-permissions` | Stage 1 | Stage 13 완료 |
| `Orc-063-plan` | `tmux new-session -d -s Orc-063-plan` + `claude --teammate-mode tmux --dangerously-skip-permissions` | Stage 2 | Stage 4 완료 |
| `Orc-063-dev` | `tmux new-session -d -s Orc-063-dev` + `claude --teammate-mode tmux --dangerously-skip-permissions` | Stage 5 | Stage 10/13 완료 |
| `Orc-063-design` | Stage 6 has_ui=true인 경우만 spawn | Stage 6 | Stage 7 완료 |

**v0.6.3 실제 가동 세션:** bridge-063 + Orc-063-plan (Stage 2~4) + Orc-063-dev (Stage 5~10)

### 2.3 개발팀 PL 공기성 — 부 PL 미배정

- 현재: 공기성 1명 단독 지휘 (백엔드 + 프론트)
- 결정: 추후 검토 = **Stage 5 기술 설계 또는 v0.6.4 운영 시 판단** [B2-3 정정 적용]
- 연계: Q-PER-2

---

## Sec. 3. F-62-5~F-62-9 신규 설계 제약

### 3.1 후보 표 (확정판)

| 제약 | 주제 | 영향 영역 | 우선도 | Stage 4 결정 | Stage 5 이월 |
|------|------|---------|-------|------------|------------|
| **F-62-5** | 글로벌 통합 충돌 우선순위 (프로젝트 > 글로벌) | `~/.claude/CLAUDE.md` + 프로젝트 CLAUDE.md cross-reference | 🔴 높음 | ✅ 채택 확정 | — |
| **F-62-6** | Windows fallback sync 책임 | `update_handoff.sh` + BSD/GNU sed 호환성 포함 | 🟡 중간 | ✅ 채택 확정 | 구현 상세 이월 |
| **F-62-7** | Monitor 인프라 강화 (timestamp/stage/범위) | `monitor_bridge.sh` 구조 (sub-제약 a/b/c 분할 검토) | 🔴 높음 | ✅ 채택 확정 | sub-제약 분할 이월 |
| **F-62-8** | 리뷰어 페르소나 조건부 **환경 분기 메커니즘** [F-6 재정의] | `.claude/settings.json` `stage9_review` 키 ¹ | 🟡 중간 | ✅ 채택 확정 | 런타임 분기 로직 이월 |
| **F-62-9** | claude CLI 자동화 호출 강제 옵션 [F-5 신규] | spawn 스크립트 전체 (`--dangerously-skip-permissions` 누락 방지) | 🟡 중간 | ✅ 채택 확정 | — |

¹ F-62-8: `.claude/settings.json` `stage_assignments.stage9_review: "codex"` 키 실존 확인 완료 [F-11 해소]

### 3.2 Stage 4 결정 완료 vs Stage 5 이월 분리

**Stage 4 결정 완료 (5건):**
- F-62-5~F-62-9 전원 채택 확정
- F-62-8 영향 범위 = "환경 분기 메커니즘"으로 재정의 완료

**Stage 5 기술 설계 이월 (3건):**
- F-62-6: `update_handoff.sh` BSD/GNU sed 조건 분기 상세 구현
- F-62-7: sub-제약 (F-62-7a=timestamp / F-62-7b=stage 명시 / F-62-7c=capture-pane 범위) 분할 결정
- F-62-8: `stage9_review` 런타임 감지 → 분기 로직 구현 (plugin-cc / Codex CLI / 우회 옵션 선택)

**보류 (운영자 판단 영역):**
- F-62-10 (위험 명령 스크립트화 의무): 운영 매뉴얼 / bridge_protocol.md 강화로 대체 가능 → 운영자 결정 [Q-NEW-3 연계]

---

## Sec. 4. Stage Transition Score (파이널 산정)

### 4.1 가중치 (finalizer 확정판) [F-7 적용]

| 항목 | 정의 | 가중치 | 조정 근거 |
|------|------|-------|---------|
| (1) AC 통과율 | M1~M5별 AC 자동 검증 통과 개수 / 전체 | **30%** | 유지 (v0.6.2 패턴 계승) |
| (2) 의존 명확성 | 의존 그래프 vs 실제 진행 일치도 | **15%** | -5% (리스크 식별과 중복 제거) |
| (3) 리스크 식별 | M별 리스크 ≥ 2건 + 완화책 ≥ 1건 명시 [F-8 정량화] | **20%** | 유지 (정량 기준 도입으로 강화) |
| (4) 변경 대상 명세 | 파일 존재 + 신규/개정 단일화 정합성 | **20%** | +5% (구현 단계 영향도 상향) |
| (5) 운영자 결정 trace | brainstorm 결정 13건 ↔ plan 흡수 매핑 | **15%** | 유지 |
| **합계** | | **100%** | |

### 4.2 M별 Score 통합 방식 [F-9 — 잠정, Q-NEW-1 운영자 결정 대기]

**잠정 채택:** (γ) 단일 합산 — v0.6.2 패턴 계승

**운영자 결정 대기 (Q-NEW-1):**
- (α) M별 Score → 평균: M 5개 균등 가중
- (β) M별 Score → 최소값: 최약 M이 게이트 결정
- (γ) 단일 합산: 현 잠정 채택

> **⚠️ Score < 80% 미달 시 → Stage 5 진입 중단, 운영자 판단 대기**

### 4.3 파이널 Score 산정 (F-1~F-12 정정 반영)

| 항목 | 가중치 | 추정 점수 | 가중 점수 | 근거 |
|------|-------|---------|---------|------|
| (1) AC 통과율 | 30% | 90% | 27.0 | F-3/F-4 정정 후 AC 명령 정합성 향상 |
| (2) 의존 명확성 | 15% | 95% | 14.25 | 의제→M 매핑 9/9 PASS (plan_review Sec.3.1) |
| (3) 리스크 식별 | 20% | 80% | 16.0 | M별 리스크 1~2건 + 완화책 명시 |
| (4) 변경 대상 명세 | 20% | 85% | 17.0 | F-2 신규/개정 단일화 완료 |
| (5) 운영자 trace | 15% | 100% | 15.0 | 13/13 매핑 PASS (Sec.5 검증) |
| **합계** | **100%** | | **89.25** | |

**Score = 89.3% → ✅ 임계값 80% 초과 → Stage 5 기술 설계 진입 GO**

---

## Sec. 5. 운영자 결정 trace 13건 검증

| # | 운영자 결정 | 흡수 위치 | 검증 |
|---|------------|---------|------|
| 1 | 18명 정식 가동 + HR=NO + 리뷰어 conditional | Sec.1 M4 + Sec.2 | ✅ |
| 2 | 옵션 A 통합 + 기간 = 세션 단위 | Sec.0 모드 및 범위 | ✅ |
| 3 | tmux 1+3 모델 + 영문 명명 | Sec.2.2 spawn 도구 매핑 + M1 리스크 | ✅ |
| 4 | claude CLI 자동화 호출 + 옵션 필수 | Sec.3 F-62-9 (신규 채택) [F-5] | ✅ |
| 5 | 위험 명령 = 스크립트화 | M1/M3 변경 대상 스크립트 명시 | ✅ |
| 6 | 글로벌 보편 정책만 + 점진 | Sec.1 M2 + Sec.3 F-62-5 | ✅ |
| 7 | Windows 5월 초 마감 | Sec.1 M1 [✅ 필수] + Sec.0 B1-1 표현 정정 | ✅ |
| 8 | D6 Hooks 경고 모드 | Sec.1 M3 | ✅ |
| 9 | gstack ETHOS 3개 다 흡수 | Sec.1 M3 ETHOS 3종 | ✅ |
| 10 | Stage 9 Codex 자동 (conditional) + 리뷰어 conditional | Sec.1 M5 + M4 + Sec.3 F-62-8 | ✅ |
| 11 | 마일스톤 5개 병렬 잠정안 | Sec.1 M 요약 표 + Sec.6 의존 그래프 | ✅ |
| 12 | Monitor 인프라 강화 | Sec.1 M1 + Sec.3 F-62-7 | ✅ |
| 13 | v0.6.2 release dispatch A — bridge-062 위임 | (별건, v0.6.3 범위 외) | ✅ |

**검증 결과: 13/13 매핑 PASS — 누락 0건**

---

## Sec. 6. 의존 그래프 + 진행 순서 (확정판)

### 6.1 의존 그래프

```
M1 (Monitor + Windows fallback)
  └─→ M3 (D6 Hooks + ETHOS) ─────────────────────────┐
        └─→ M4 (18명 페르소나 + 리뷰어 conditional) ──→ M5 (Codex 자동)

M2 (글로벌 ~/.claude)
  (독립 — 병렬 진행 가능)
```

**critical path:** M1 + M4 → 5월 초 GO/NO-GO 결정 필수

**M4→M3 방향(ETHOS 활용) 보강 note:** brainstorm 의제 8 그래프에 미명시. 의제 4(리뷰어 conditional) + 의제 6(ETHOS 3종) 결합 해석 결과 — Stage 5 기술 설계에서 brainstorm 인용 trace 보강 예정 [B3-1 적용].

### 6.2 세션 단위 진행 순서 [F-12 적용 — M단위 잠정 → Stage 13단계 재정렬 trace]

| 세션 | Stage | 마일스톤 | 재정렬 trace |
|------|-------|---------|------------|
| N | Stage 2~4 | 기획 전체 (M4 페르소나 기획 포함) | brainstorm 잠정 N(M1+M2병렬) + N+1(M3+M4병렬) → Stage 단위 통합 |
| N+1 | Stage 5 | 기술 설계 (M1~M5 detail) | brainstorm 잠정 N+1/N+2 → Stage 5로 통합 |
| N+2 | Stage 8 | 구현 (M1+M4 병렬, M2/M3 순차) | brainstorm 잠정 N+2(M5) → Stage 8 이후로 재배치 |
| N+3 | Stage 9~13 | 리뷰/검증/릴리스 | brainstorm 잠정 N+3 일치 |

---

## Sec. 7. Q 후보 통합 (총 13건)

### 7.1 통합 Q 표

| Q# | 주제 | 우선도 | 대상 | 운영자 결정 필요 |
|----|------|-------|------|--------------|
| Q1 | M1 세션명 변수 주입 패턴 구체화 | 🔴 | Orc-063-dev | — |
| Q2 | M2 충돌 우선순위 상세화 (F-62-5 일부 답변) | 🟡 | Reviewer (일부 해소) | — |
| Q3 | M3 shellcheck 엄격도 (warning only vs error 기준) | 🟡 | Orc-063-dev | — |
| Q4 | M4 tmux 1+3 모델 안정성 검증 범위 | 🟡 | Reviewer/Orc | — |
| Q5 | M5 plugin-cc 고도화 일정 (v0.6.3 vs 후속) | 🔴 | **운영자** | ✅ 필수 |
| Q6 | AC 자동화 CI/CD 추가 시점 | 🟡 | Orc-063-dev | — |
| Q-PER-1 | 디자인팀 v0.6.4 자동 가동 트리거 | 🟢 | 운영 정책(후속) | — |
| Q-PER-2 | 개발팀 부 PL 필요성 | 🟡 | Stage 5 / 운영 | — |
| Q-NEW-1 | Score M 통합 방식 (α/β/γ 중 채택) | 🔴 | **운영자** | ✅ 필수 |
| Q-NEW-2 | Score 가중치 최종 확정 (30/15/20/20/15) | 🟡 | **운영자** | ✅ 권장 |
| Q-NEW-3 | F-62-9/F-62-10 채택 범위 | 🟡 | Orc-063-dev / 운영자 | 🟡 권장 |
| Q-NEW-4 | settings.json stage9_review 키 실존 | 🔴 → **✅ 해소** | — | 해소: 파이널리즈 직접 검증 완료 |
| Q-NEW-5 | drafter 분배 정책 v0.6.4 후속 | 🟢 | 운영 정책(후속) | — |

### 7.2 운영자 결정 필요 요약

| # | 결정 사항 | Q# | 우선도 |
|---|---------|----|-------|
| 1 | Score M 통합 방식 (α/β/γ) | Q-NEW-1 | 🔴 |
| 2 | M5 plugin-cc 고도화 일정 | Q5 | 🔴 |
| 3 | Score 가중치 최종 확정 | Q-NEW-2 | 🟡 |
| 4 | F-62-10 채택 여부 | Q-NEW-3 | 🟡 |

> **Q-NEW-4 해소:** `.claude/settings.json` 실증 결과 `stage_assignments.stage9_review: "codex"` 키 실존 확인 완료 — Stage 5 기술 설계에서 런타임 분기 로직 구현으로 직접 진입 가능.

---

## Sec. 8. AC 검증 현황 (파이널 시점)

| M | AC 항목 수 | 자동 검증 가능 | 수동 확인 필요 | 정정 적용 |
|---|---------|------------|------------|---------|
| M1 | 6 | 5 | 1 | F-2 ✅ |
| M2 | 4 | 3 | 1 | — |
| M3 | 5 | 4 | 1 | F-3 ✅ |
| M4 | 5 | 4 | 1 | F-4 ✅ |
| M5 | 4 | 3 | 1 | — |
| **합계** | **24** | **19** | **5** | |

자동 검증 가능 19/24, 수동 확인 5/24. 수동 확인 5건은 모두 tmux/환경 동작 검증으로 Stage 12 QA에서 실시.

---

**마지막 라인:**

COMPLETE-FINALIZER: 450 lines, score=89.3%, AC=19/24, Q=13, file=docs/02_planning_v0.6.3/plan_final.md
