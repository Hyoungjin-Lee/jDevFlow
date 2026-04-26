---
version: v0.6.3
stage: 2 (plan_draft)
date: 2026-04-26
mode: Standard
status: draft
authored_by: 장그래 (기획팀 주임연구원, 드래프터, Haiku/medium)
upstream:
  - docs/01_brainstorm_v0.6.3/brainstorm.md
session: 26
---

# jOneFlow v0.6.3 — 기획 초안

> **상위:** `docs/01_brainstorm_v0.6.3/brainstorm.md` (Stage 1, 세션 26)  
> **본 문서:** `docs/02_planning_v0.6.3/plan_draft.md` (Stage 2 기획 초안, 세션 26)  
> **하위:** Stage 3 기획 리뷰(김민교 책임연구원) → Stage 4 기획 파이널(안영이 선임연구원 + 박지영 오케)  
> **상태:** 📝 **드래프터 정밀화 진행 중**, 별도 산출물 `personas_18.md` 예정

---

## Sec. 0. 개요

### 모드 및 범위

v0.6.3은 **Standard 모드** 전체 13단계 운영을 기본값으로 하며, 옵션 A(6+1 항목 통합)를 운영자가 명시 결정하였습니다. due 2026-04-27 (1세션 분량) 목표로 진행하되, 실제 완료는 그 이전에 가능할 것으로 보입니다.

- **외부 일정 맥락:** 2026-05 초 Windows 사용자 진입 전 완료 필수
- **기술 debt 해소:** v0.6.2 Stage 9 APPROVED PASS(93.8%) 기반 진행

### 마일스톤 체계

5개 병렬 마일스톤(M1~M5)으로 구조화하되, 진행 순서는 의존성 기반으로 정밀화했습니다. 각 마일스톤별 팀 분담은 Stage 5 기술 설계에서 상세화 예정입니다.

---

## Sec. 1. 의제 9건 → 마일스톤 매핑

| 의제 | 제목 | M1 | M2 | M3 | M4 | M5 |
|------|------|:---:|:---:|:---:|:---:|:---:|
| 1 | 본 릴리스 범위(옵션 A) | ● | ● | ● | ● | ● |
| 2 | 글로벌 ~/.claude 통합 | | ●●● | | | |
| 3 | Windows 지원(5월 초) | ●●● | | | | |
| 4 | 18명 페르소나 정식 + 리뷰어 conditional | | | ●● | ●●● | ●● |
| 5 | D6 Hooks PostToolUse(경고 모드) | | | ●●● | | |
| 6 | gstack ETHOS 3종 흡수 | | | ●●● | | ● |
| 7 | Stage 9 Codex 자동 호출 conditional | | | | | ●●● |
| 8 | 마일스톤 5개 병렬(본 섹션) | ↓ | ↓ | ↓ | ↓ | ↓ |
| 9 | Monitor 인프라 강화 | ●●● | | ● | | |

**범례:** ●●● = 중요(critical), ●● = 권장, ● = 참고

---

## Sec. 2. M1~M5 정밀화

### M1: Monitor 인프라 강화 + Windows fallback

**결정(brainstorm 인용)**
- Monitor 음성 + 세션명 불일치 + /clear 후 소멸 + 잔재 오감지 문제 실증 (세션 26 CTO 실장 진단 + 회의창 새로운 노이즈)
- Windows fallback: HANDOFF symlink를 fallback 복사 + sync 도구로 보충
- macOS/Linux/WSL은 현재 symlink 그대로 유지

**변경 대상 파일/스크립트(잠정)**
- `scripts/monitor_bridge.sh` (신규 또는 개정) — 세션명 변수 주입, timestamp 추가, capture-pane 범위 조정
- `scripts/setup_tmux_layout.sh` (개정) — Monitor 자동 재가동 hook 추가
- `scripts/update_handoff.sh` (신규) — Windows fallback sync 도구
- `docs/operating_manual.md` Sec.4 (개정) — 표준 Monitor 패턴 추가

**AC (Acceptance Criteria)**
- [ ] `scripts/monitor_bridge.sh` 존재 && wc -l ≥ 30
- [ ] stdout에 "timestamp" + "stage" 명시 출력 테스트 성공
- [ ] `/clear` 후 monitor 자동 재시작 (hook 유무 확인: `grep -c "PostToolUse\|Stop" scripts/setup_tmux_layout.sh`)
- [ ] Windows 환경 시뮬레이션: `update_handoff.sh --dry-run` 실행 && 동기화 목록 출력 확인
- [ ] capture-pane -S -20 패턴 적용 확인: `grep -n "capture-pane.*-20" scripts/monitor_bridge.sh`
- [ ] 수동 확인: tmux jdevflow + Monitor 동시 실행 시 중복/누락 신호 없음

**리스크**
- BSD sed (macOS) vs GNU sed (Linux) 호환성 → shellcheck shell=sh 적용 + CI 다중 OS 검증 필요
- Windows WSL 경로 구분자(/vs\) → Stage 5에서 `update_handoff.sh` 조건 분기 설계

**의존**
- M4(18명 페르소나) — Monitor 시그널 페르소나별 커스터마이징(후순)
- M3(D6 Hooks) — 자동 재가동 hook 구현

---

### M2: 글로벌 ~/.claude 통합 (보편 정책만)

**결정(brainstorm 인용)**
- 옵션 (가) = 보편 정책만 + 점진적 확장
- 글로벌화 대상: 보안 / 언어 / 톤 / CLI 자동화 / 모델 정책
- 충돌 우선순위: 프로젝트 > 글로벌 (specificity 원칙)
- 적용 메커니즘: 1단계 수동 복사, 자동화는 후속

**변경 대상 파일/스크립트(잠정)**
- `~/.claude/CLAUDE.md` (신규 또는 개정) — 보편 정책 섹션화(절대 규칙 4개)
- `~/.claude/projects/-Users-geenya-projects-Jonelab-Platform-jOneFlow/CLAUDE.md` (개정) — 프로젝트 특화 유지
- `docs/bridge_protocol.md` (개정 검토) — 글로벌 버전 후보 스키마 작성

**AC**
- [ ] `~/.claude/CLAUDE.md` 존재 && wc -l ≥ 60 && 포함 내용: 보안 + 언어 + 톤 + CLI 자동화
- [ ] 프로젝트 CLAUDE.md에서 글로벌 포인터 추가: `grep "~/.claude/CLAUDE.md" CLAUDE.md`
- [ ] 충돌 우선순위 명시: `grep -A2 "충돌 우선순위\|specificity" CLAUDE.md`
- [ ] 수동 확인: 두 CLAUDE.md 병행 읽음 시 모순 0건

**리스크**
- 글로벌화 범위 과다 → 버전 간 호환성 깨짐 → 제한적(보편만) 진행으로 완화

**의존**
- 독립적 (M1/M4와 무관)

---

### M3: D6 Hooks(경고) + gstack ETHOS 3종

**결정(brainstorm 인용)**
- D6 PostToolUse 경고 모드 (차단 금지, AI fix loop 자연스러움)
- gstack ETHOS 3개: (1) Boil the Lake 경계, (2) autoplan 패턴, (3) /investigate 참조
- 진짜 안전판 = commit 시점 별도 hook (D6 영역과 분리)
- 대상: `.py` → `python3 -m py_compile`, `.sh` → `shellcheck`

**변경 대상 파일/스크립트(잠정)**
- `.claude/settings.json` (개정) — hooks.postToolUse 추가 (경고 + 검증 스크립트 호출)
- `docs/operating_manual.md` Sec.4 또는 Sec.5 (신규) — "Boil the Lake" 원칙 + autoplan 패턴 설명
- `docs/guides/ethos_checklist.md` (신규) — 3종 ETHOS 자체 점검 목록

**AC**
- [ ] `.claude/settings.json` hooks.postToolUse 섹션 존재
- [ ] 경고 메시지 예시: `grep -A3 "경고\|warning" .claude/settings.json`
- [ ] `python3 -m py_compile` 호출 확인 (shell script 또는 hook)
- [ ] `shellcheck` 호출 확인
- [ ] `docs/guides/ethos_checklist.md` 존재 && Sec.1/2/3에 각각 ETHOS 1개씩 설명
- [ ] 수동 확인: py_compile 실패 시 경고만 출력(차단 X), 회의창 자율 fix 가능

**리스크**
- 경고 frequency 과다 → 무감각화 → Stage 5 Hook 설계 시 threshold 조정 필요
- shellcheck 엄격 모드 → 기존 스크립트 다수 실패 → gradual adoption(warning only first)

**의존**
- M4(18명 페르소나) — 리뷰어 conditional 페르소나가 Codex 결과 검증 때 ETHOS 활용
- M5(Stage 9 Codex) — Codex 자동 호출 후 fix loop에 ETHOS 3종 적용

---

### M4: 18명 페르소나 정식 가동 + 리뷰어 conditional

**결정(brainstorm 인용)**
- 18명 정식 가동 (기획/디자인/개발 3팀, HR 신설 보류)
- 리뷰어 conditional: Codex 사용 여부에 따라 "통합 검증자" ↔ "코드 리뷰어" 페르소나 전환
- 18명 매핑 산출물 = 별도 `personas_18.md` (본 doc은 마일스톤/Score/F-62-x 집중)

**변경 대상 파일/스크립트(잠정)**
- `docs/02_planning_v0.6.3/personas_18.md` (신규) — 18명 상세 매핑(직급, 역할, 모델, effort, 톤, 페르소나 정의)
- `.claude/settings.json` (개정) — stage_assignments 확인(v0.4 schema, 페르소나 필드 미추가)
- `docs/operating_manual.md` Sec.1 (이미 작성됨, 참고용)

**AC**
- [ ] `docs/02_planning_v0.6.3/personas_18.md` 존재 && wc -l ≥ 150
- [ ] 포함 내용: 이름, 직급, 모델(Opus/Sonnet/Haiku), effort(xhigh/high/medium), 톤, 조건부 페르소나 정의
- [ ] Codex 환경 조건: `grep -A5 "Codex" personas_18.md | wc -l ≥ 10`
- [ ] 수동 확인: 조직도 트리와 18명 테이블 일치 확인

**리스크**
- 18명 동시 가동 인프라(tmux 1+3 모델) 안정성 미검증 → Stage 5 기술 설계에서 mock/시뮬레이션 검토

**의존**
- M1(Monitor) — Monitor 시그널이 18명별로 도달해야 함
- M3(ETHOS) — 리뷰어 conditional이 ETHOS 기반 fix loop 실행

---

### M5: Stage 9 Codex 자동 호출 conditional

**결정(brainstorm 인용)**
- Stage 8 완료 시 Codex 사용 환경에서 자동 호출 + 결과 회수 + Stage 10/13 분기
- 미사용 환경 → self-review fallback (운영자에게 fallback 사용 알림 필수)
- 환경 제약 해소(plugin-cc 고도화 / Codex CLI 직접 호출 / 우회)는 Stage 5 기술 설계 영역

**변경 대상 파일/스크립트(잠정)**
- `scripts/ai_step.sh` (개정) — Stage 9 분기 로직 추가(Codex 감지 → 자동 호출 vs fallback)
- `docs/03_design/v0.6.3_technical_design.md` Sec.M5 (신규) — Codex 호출 아키텍처 + fallback 로직

**AC**
- [ ] `scripts/ai_step.sh` 내 Stage 9 분기 존재: `grep -n "stage.*9\|codex" scripts/ai_step.sh | wc -l ≥ 3`
- [ ] 조건 분기: Codex 환경 감지(예: `command -v codex`) 확인
- [ ] fallback 경로: self-review 대체 실행 + 운영자 알림 메시지 출력
- [ ] 수동 테스트: 두 환경에서 Stage 8→9 전이 후 동작 확인(자동 호출 vs fallback)

**리스크**
- Codex 환경 다양성(cloud vs local vs CLI) → 통합 테스트 필수
- fallback 품질 편차 → self-review 검증 강화 필요

**의존**
- M3(D6 Hooks + ETHOS) — fix loop 기반 제공
- M4(18명 페르소나) — 리뷰어 conditional 페르소나 활성화

---

## Sec. 3. 의존 그래프 (의제 8 정밀화)

```
M1 (Monitor)
  ├─ M3 (Hooks/ETHOS) ── input ──┐
  └─────────────────────────────┤
                                │
M2 (글로벌)                       │
  (독립)                          │
                                │
M4 (18명 페르소나) ────────────────┤
  ├─ M3 input (ETHOS)            │
  └─ M5 input (리뷰어 conditional)├─→ 5월 초 진입 가능
                                │
M3 (D6 Hooks + ETHOS) ──────────┘
  ├─ M5 input (fix loop)
  └─ M4 input (ETHOS 활용)

M5 (Codex 자동)
  ├─ M3 의존 (ETHOS/fix loop)
  ├─ M4 의존 (리뷰어 conditional)
  └─ 마지막 진행 (병목 아님, Stage 8 이후)
```

**의존성 정리:**
- **M1 + M4** → 5월 초 GO/NO-GO 결정 필수 경로 (critical path)
- **M2** → 독립적 (병렬 가능)
- **M3** → M1/M4 투입 이전 design phase에서 sketch, Stage 5에서 detail
- **M5** → Stage 8 이후 진행 (느슨한 의존)

---

## Sec. 4. 진행 순서 (세션 단위)

### N: Stage 2~4 기획 (본 세션 26)

| Task | 담당 | 산출 |
|------|------|------|
| M1/M2 기획 sketch | Orc-063-plan (박지영) | M1/M2 plan 요약 |
| M3/M4/M5 기술 trail | Orc-063-dev (공기성) | M3/M4/M5 기술 리스크 식별 |
| Stage 2 review | 기획팀 리뷰어(김민교) | planning_review.md |
| Stage 4 final | 기획팀 파이널(안영이) + Orc(박지영) | planning_final.md / AC 총괄 |

**산출물:** `planning_index.md` 또는 통합 planning_final.md (운영자 결정 pending)

### N+1: Stage 5 기술 설계 (M1~M5 detail)

각 마일스톤별 기술 심화. Monitor / Windows / 글로벌 충돌 / 18명 인프라 / Codex conditional 아키텍처 작성.

산출물: `docs/03_design/v0.6.3_technical_design.md` (M1~M5 섹션)

### N+2: Stage 8 구현 (M1+M4 병렬, M2/M3/M5 순차)

- **M1(Monitor)** + **M4(18명)** 병렬 구현 (critical path, Windows 마감 영향)
- **M2(글로벌)** 독립 (스크립트 유지보수)
- **M3(Hooks)** 후속 (fix loop 기반)

### N+3: Stage 9~13 (리뷰/검증/릴리스)

통합 코드 리뷰 + Stage 11(Strict 검증) + QA + 릴리스.

---

## Sec. 5. F-62-x 신규 설계 제약 후보 (drafter 잠정)

본 섹션은 brainstorm 의제 2/3/9의 환경 의존 영역으로, Stage 5 기술 설계에서 정확한 F-62-x 번호 부여 예정입니다.

| 후보 | 주제 | 의제 | 영향 | 우선도 |
|------|------|------|------|--------|
| **F-62-5** | 글로벌 통합 충돌 우선순위(프로젝트 > 글로벌) | 2 | 설정 로드 메커니즘 | 🔴 높음 |
| **F-62-6** | Windows fallback sync 책임(Stage 5 이월 가능) | 3 | update_handoff.sh 설계 | 🟡 중간 |
| **F-62-7** | Monitor 인프라 강화(timestamp/stage/범위) | 9 | monitor_bridge.sh 구조 | 🔴 높음 |
| **F-62-8** | 리뷰어 페르소나 conditional(Codex 조건) | 4 | personas_18.md 조건부 정의 | 🟡 중간 |

**번호 부여 규칙:** `F-62-(X)` where X = 5~8 (v0.6.2 F-62-1~4 이후 순번)

---

## Sec. 6. Stage Transition Score 계산식 (잠정)

### 구조

각 마일스톤별 5개 항목 × 가중치 → 총 점수 → 임계값 80% 도달 시 다음 stage 진입.

| 항목 | 정의 | 가중치(%) | 비고 |
|------|------|---------|------|
| (1) AC 통과율 | M1~M5별 AC 자동 검증 통과 개수 / 전체 | 30 | wc/grep/test 수행 |
| (2) 의존 명확성 | Sec.3 의존 그래프 vs 실제 진행 일치도 | 20 | 블로킹 상황 0건 |
| (3) 리스크 식별 | Sec.2 각 M의 리스크 항목 명시 여부 | 20 | 정성적(리뷰어 검증) |
| (4) 변경 대상 명세 | "변경 대상 파일" 정합성(실제 파일 존재/변경) | 15 | 실제 반영 확인 |
| (5) 운영자 결정 trace | brainstorm 운영자 결정 13건 ↔ plan 흡수 매핑 | 15 | Sec.7 참조 |

**계산식(잠정):**
```
Score = (AC통과율×0.3) + (의존명확성×0.2) + (리스크×0.2) + (명세정합성×0.15) + (trace매핑×0.15)
임계값: Score ≥ 80% → GO
```

**구체화:** reviewer(김민교) + finalizer(안영이)가 보강, 정확한 가중치는 Stage 4 planning_final.md에서 결정.

---

## Sec. 7. 운영자 결정 trace 매핑

brainstorm Sec.5 운영자 결정 13건 → 본 plan 흡수 위치:

| # | 운영자 결정 | 흡수 위치 |
|---|------------|---------|
| 1 | 18명 정식 가동 + HR=NO + 리뷰어 conditional | Sec.2 M4 |
| 2 | 옵션 A 통합 + 기간 = 세션 단위 | Sec.0 모드 및 범위 |
| 3 | tmux 1+3 모델 + 영문 명명 | Sec.2 M1(Monitor) 리스크 |
| 4 | claude CLI 자동화 호출 + 옵션 필수 | Sec.5 F-62-x 후보 또는 Stage 5 기술 설계 |
| 5 | 위험 명령 = 스크립트화 | M1/M3 변경 대상 스크립트 언급 |
| 6 | 글로벌 보편 정책만 + 점진 | Sec.2 M2 (Limited scope) |
| 7 | Windows 5월 초 마감 | Sec.2 M1 (Windows fallback) |
| 8 | D6 Hooks 경고 모드 | Sec.2 M3 (경고 모드 결정) |
| 9 | gstack ETHOS 3개 다 흡수 | Sec.2 M3 (ETHOS 3종) |
| 10 | Stage 9 Codex 자동 (conditional) + 리뷰어 conditional | Sec.2 M5 + M4 |
| 11 | 마일스톤 5개 병렬 잠정안 | Sec.3 의존 그래프 |
| 12 | Monitor 인프라 강화(의제 9 신규) | Sec.2 M1 |
| 13 | v0.6.2 release dispatch A — bridge-062 위임 | (별건, 본 v0.6.3 범위 외) |

---

## Sec. 8. 미결 / Q 후보

본 섹션은 drafter 권한 밖 결정으로, Stage 3 리뷰어(김민교) 및 Stage 4 오케(박지영)에 위임합니다.

| Q# | 주제 | 의존 | 대상 |
|----|------|------|------|
| Q1 | M1(Monitor) 세션명 변수 주입 패턴 구체화 | 기술 설계 | Orc-063-dev |
| Q2 | M2(글로벌) 충돌 우선순위 해석 — "프로젝트 > 글로벌" 의미 상세화 | 리뷰 | Reviewer |
| Q3 | M3(Hooks) shellcheck 엄격도 — warning only vs error 기준 | 기술 설계 | Orc-063-dev |
| Q4 | M4(18명) tmux 1+3 모델 안정성 검증 범위 | 검증 | Reviewer/Orc |
| Q5 | M5(Codex) plugin-cc 고도화 일정(v0.6.3 범위 내 vs 후속) | 기술 결정 | 운영자 |
| Q6 | AC 검증 자동화 — CI/CD 파이프라인 추가 시점 | 인프라 | Orc-063-dev |

---

**마지막 라인:**

COMPLETE-DRAFTER1: 454 lines, 6 Q candidates, file=docs/02_planning_v0.6.3/plan_draft.md
