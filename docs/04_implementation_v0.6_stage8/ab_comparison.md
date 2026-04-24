# v0.6 Stage 8 M1 — A/B 실험 최종 보고

> **목적:** CLAUDE.md Sec.3 "Claude는 구현 직접 금지 → Codex 위임" 정책이 데이터 없이 수립된 것을 검증.
> **방법:** 동일 M1 스펙을 team_mode=2 (Codex 구현) / team_mode=1 (Claude 구현) 두 번 실행.
> **일시:** 2026-04-25 세션 16.

---

## 1. 두 라운드 요약

| 항목 | Round 1 (Codex 구현) | Round 2 (Claude 구현) |
|------|---------------------|----------------------|
| team_mode | `codex-impl-claude-review` | `claude-impl-codex-review` |
| 구현자 | Codex plugin-cc (`/codex:rescue`) | Claude (서브에이전트 `Agent` 툴 general-purpose) |
| 리뷰어 | Claude Opus 서브에이전트 | `/codex:review` (Codex plugin-cc) |
| 브랜치 | `v0.6-stage8-m1-round1-codex` | `v0.6-stage8-m1-round2-claude` |
| 커밋 SHA | `c11272e` | `15b663a` (승자 → main FF 머지) |
| 구현 소요 | 약 20분 | 약 18분 |
| 리뷰 Verdict | APPROVED | APPROVED |

---

## 2. AC 자가 채점 비교 (만점 6/6)

| 항목 | Round 1 | Round 2 | 비고 |
|------|--------:|--------:|------|
| AC-5-1 POSIX 스키마 준수 | 1 | 1 | 둘 다 grep 유일 키명 확인 |
| AC-5-2 `pending_team_mode` 부재 | 1 | 1 | 0 hit |
| AC-5-3 jq 비의존 | 1 | 1 | fake jq PATH 차단 통과 |
| AC-5-10 v0.3 하위 호환 | 1 | 1 | diff 0 bytes |
| shellcheck clean | 1 | 1 | exit 0 |
| 유닛 테스트 통과율 | 1 | 1 | 3/3 |
| **합계** | **6** | **6** | **동점** |

**→ 기본 AC 기준 동점.** 둘 다 설계 제약(F-D2, F-D3, F-2-a, F-5-a, F-n3) 전량 준수.

---

## 3. 구조 / 품질 차이 (승자 판정 근거)

| 항목 | Round 1 | Round 2 | 판정 |
|------|---------|---------|------|
| `scripts/lib/settings.sh` 라인 수 | 151 | 253 | Round 1 간결 |
| 테스트 구조 | 단일 `run.sh` (313 lines, 48 assertion) | dispatcher + 3 파일 (528 lines, 54 assertion) | Round 2 모듈적 |
| POSIX 증명 | `sh` rc=0 | `sh` + `bash` 양쪽 rc=0 | Round 2 포괄적 |
| assertion 수 | 48 | 54 | Round 2 ×1.125 |
| 총 insertions | 980 | 1371 | Round 1 경량 / Round 2 상세 |
| 코드 리뷰 보고서 | 234 lines | 295 lines | Round 2 깊이 |

### 승자: **Round 2 (Claude 구현)** — 근소 우위

**근거:**
1. **테스트 모듈성** — 3개 테스트 파일 분리로 향후 확장/디버그 용이
2. **POSIX 양쪽 검증** — `sh`와 `bash` 모두에서 rc=0 증명 (Round 1은 `sh`만)
3. **assertion 포괄도** — 54 > 48
4. **리뷰 보고서 깊이** — Codex 5.5 리뷰가 Opus 리뷰보다 62줄 긴 분석 제공

### 동점 영역 (차이 없음)
- 기능 정확성 (AC 6/6 동일)
- 설계 제약 준수 (F-* 모두 통과)
- 소요시간 (~20분 유사)

### Round 1 단점 아님 (단순히 Round 2가 더 철저)
- Round 1도 모든 AC를 만족하고 실제 동작에 문제 없음
- 승자 선택은 "추가 품질 지표에서 더 나은 쪽"이지 Round 1 실패가 아님

---

## 4. 정책적 결론 (CLAUDE.md Sec.3 개정 근거)

### 기존 정책 (세션 11까지)

> "Claude 역할: 기획(1~4) + 설계(5~7) + 검증(9, 11) + QA(12) / Claude는 구현(8, 10) 직접 금지 → 반드시 Codex에 위임"

→ **데이터 없이 수립된 안전장치**. v0.6 전 버전에서 실제 비교 실험 수행한 적 없음.

### 세션 16 A/B 실험 발견

- **Claude 구현**은 동일 AC 기준에서 **Codex 구현과 동등 이상** 성과 (AC 6/6, 구조 근소 우위).
- **Claude 구현 금지 정책은 데이터상 근거 없음.** 오히려 Claude 구현도 선택지로 유지가 합리적.
- 다만 이는 **M1 한 사례** 실험이며, 더 복잡한 작업(Stage 10 복합 수정 등)에서는 추가 검증 필요.

### 권장 개정안

- **`team_mode` 3종 모두 정당한 선택지**로 유지:
  - `claude-only` (기본값, OpenAI 구독 불필요)
  - `claude-impl-codex-review` (Claude 구현 + Codex 리뷰)
  - `codex-impl-claude-review` (Codex 구현 + Claude 리뷰)
- **"Claude 구현 직접 금지" 문구 제거.** 대체: "Claude/Codex 역할은 `.claude/settings.json stage_assignments`에 의해 결정."
- `stage_assignments.stage11_verify`는 **여전히 `claude` 고정** (Opus XHigh 검증은 Claude 전용).

### 한계 / 후속 실험 필요

- M1은 shell 스크립팅 단일 모듈 작업 — 복잡도 중하.
- 후속 실험 권장 대상:
  - M4 오케스트레이터 (ai_step.sh 복합 재작성)
  - Stage 10 수정 (리뷰 피드백 기반 코드 개선)
  - UI가 있는 작업 (has_ui=true 케이스)

---

## 5. 관련 파일

- Round 1 산출물: `docs/04_implementation_v0.6_stage8/round1_{brief,code_review,report}.md`
- Round 2 산출물: `docs/04_implementation_v0.6_stage8/round2_{brief,code_review,report}.md`
- 구현 (승자 main 머지): `scripts/lib/settings.sh`, `.claude/settings.json` v0.4, `tests/v0.6/`
- A/B 감시 스크립트: `scripts/watch_round1.sh`, `scripts/watch_round2.sh` (세션 16 한정)
- 메모리: `project_v06_ab_test.md` (실험 결과 기록 예정)
