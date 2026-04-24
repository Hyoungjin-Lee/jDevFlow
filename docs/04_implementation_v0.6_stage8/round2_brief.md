# v0.6 Stage 8 M1 — Round 2 (Claude 구현 · Codex 리뷰)

> **대상 오케스트레이터:** Round 1 완료 확인. 이 파일 지시대로 M1 Round 2를 진행한다.
> **브랜치 전환 필요:** `git checkout main && git checkout -b v0.6-stage8-m1-round2-claude`
> **team_mode (이번 Round):** `claude-impl-codex-review` (Claude가 구현, `/codex:review`가 리뷰)
> **승인 스킵:** CLAUDE.md Sec.3 적용. 로컬 변경/commit 자율.

---

## 0. 선행 단계 (오케스트레이터 필수 실행)

### 0-1. main으로 브랜치 전환 + Round 2 브랜치 생성
```sh
cd ~/projects/Jonelab_Platform/jDevFlow
git checkout main
git checkout -b v0.6-stage8-m1-round2-claude
```

**중요:** Round 1 브랜치의 커밋(c11272e)은 **참조 금지**. Round 2는 main 최신(9e08f3b)에서 분기해 **독립적으로** 구현해야 A/B 비교 가치가 있음. Round 1 산출물(`scripts/lib/settings.sh`, `.claude/settings.json v0.4`, `tests/v0.6/`)을 **보지 말고 처음부터** 구현.

### 0-2. untracked 파일 확인 (참고용)
- `docs/04_implementation_v0.6_stage8/round1_brief.md` — Round 1과 동일한 M1 스펙 (읽어도 됨)
- `docs/04_implementation_v0.6_stage8/round2_brief.md` — 본 파일
- `scripts/setup_tmux_layout.sh`, `scripts/watch_round1.sh`, `docs/guides/tmux_layout.md` — 공통 인프라 (건드리지 말 것)

---

## 1. 작업 범위 (M1 동일 — D1 schema + lib/settings.sh + 유닛 테스트)

Round 1과 **완전히 동일 스펙**. 본 브리프에서는 Round 2에서 달라진 점만 강조.

### 산출물 A — `scripts/lib/settings.sh` (신규)
tech_design Sec 8.1 공개 함수 6종:
- `settings_path`, `settings_require_v04`, `settings_read_key`, `settings_read_stage_assign`, `settings_write_key`, `settings_write_stage_assign_block`

### 산출물 B — `.claude/settings.json` schema v0.4
- `schema_version: "0.4"`
- `workflow_mode: "desktop-cli"` (기본)
- `team_mode: "claude-impl-codex-review"` ← **Round 2이므로 이 값**
- `stage_assignments`: team_mode=1 매핑표 기준
  - `stage8_impl: "claude"`
  - `stage9_review: "codex"`
  - `stage10_fix: "claude"`
  - `stage11_verify: "claude"`
- 기존 v0.3 필드 diff 0 bytes [F-5-a, AC-5-10]

### 산출물 C — `tests/v0.6/run.sh` + 3 유닛 테스트
Round 1과 동일 (test_settings_read_key / write_key / write_stage_assign_block).

### 제약 (동일)
- [F-D2] jq 금지 · [F-D3] pending_team_mode 금지 · [F-2-a] team_mode 리터럴 실행 분기 금지 · [F-5-a] v0.3 필드 diff 0 · [F-n3] scripts에서 codex CLI 호출 금지

---

## 2. 구현자 및 리뷰어 (Round 1과 반대)

### 구현 (Stage 8)
- **실행자:** Claude (오케스트레이터 직접 또는 `Agent` 툴 서브에이전트)
- `/codex:rescue` **호출 금지** (이번은 Claude 구현 실험)

### 리뷰 (Stage 9)
- **실행자:** `/codex:review` (Codex plugin-cc slash command)
- 리뷰 기준: AC-5-1 / AC-5-2 / AC-5-3 / AC-5-10 집중
- 리뷰 결과: `docs/04_implementation_v0.6_stage8/round2_code_review.md`

---

## 3. 완료 signal (AND 조건)

1. 산출물 3종 모두 존재: `scripts/lib/settings.sh`, `.claude/settings.json` v0.4, `tests/v0.6/run.sh`
2. `bash tests/v0.6/run.sh` exit 0
3. PATH에서 jq 제거 상태로도 테스트 통과 [AC-5-3]
4. `shellcheck scripts/lib/settings.sh tests/v0.6/run.sh` clean
5. Stage 9 리뷰 verdict `APPROVED` (`round2_code_review.md`)
6. `docs/04_implementation_v0.6_stage8/round2_report.md` 작성 — AC 자가진단 + 소요시간 + 점수
7. 커밋:
   ```
   sh scripts/git_checkpoint.sh "feat(v0.6): M1 Round 2 Claude 구현 — D1 schema v0.4 + scripts/lib/settings.sh" \
     scripts/lib/settings.sh .claude/settings.json tests/v0.6/run.sh scripts/run_tests.sh \
     docs/04_implementation_v0.6_stage8/round2_brief.md \
     docs/04_implementation_v0.6_stage8/round2_code_review.md \
     docs/04_implementation_v0.6_stage8/round2_report.md
   ```

---

## 4. 점수 메트릭 (round2_report.md에 자가 채점)

| 항목 | 만점 | 기준 |
|------|------|------|
| AC-5-1 POSIX 스키마 준수 | 1 | grep 유일 키명 확인 |
| AC-5-2 pending_team_mode 부재 | 1 | 0 hit |
| AC-5-3 jq 비의존 | 1 | jq 제거 PATH 통과 |
| AC-5-10 v0.3 하위 호환 | 1 | v0.3 필드 diff 0 |
| shellcheck clean | 1 | exit 0 |
| 유닛 테스트 통과율 | 1 | 3/3 또는 비례 |
| **합계** | **6** | Round 1과 직접 비교 |

---

## 5. 실행 절차 (오케스트레이터)

1. §0 브랜치 전환 실행
2. 구현 착수. `/codex:rescue` 호출 금지. Claude 직접 또는 `Agent` 툴 서브에이전트로 구현.
3. 구현 완료 후 shellcheck + `tests/v0.6/run.sh` 실행
4. `/codex:review` 호출 → AC-5-1/2/3/10 집중 리뷰 요청
5. APPROVED 확인 후 `round2_report.md` 작성 + 커밋
6. "Round 2 완료" 한 줄 출력 후 대기
