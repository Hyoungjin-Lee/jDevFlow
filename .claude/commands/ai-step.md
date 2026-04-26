---
description: Stage 자동 진행 (--auto / --resume / --status / --next / --stage)
argument-hint: "[<stage_name>] [--status] [--next] [--auto] [--resume] [--stage <name>] [--dry-run]"
allowed-tools: Bash
---

# /ai-step

Stage 1~13 자동 진행 오케스트레이터. v0.5 호환 stage 이름 또는 `--auto`/`--resume`/`--next`/`--status`/`--dry-run` 옵션 지원. 승인 게이트(Stage 4.5 / Stage 11) 도달 시 paused 상태로 정지, `--resume`으로 재개.

## 사용법

- `/ai-step --status` — 현재 운영 상태 출력 (workflow_mode / team_mode / stage_assignments / 다음 stage 예정, read-only)
- `/ai-step --next` — 다음 stage 1개만 진행 (게이트 체크 포함)
- `/ai-step --auto` — 다음 승인 게이트(paused)까지 자동 반복 진행
- `/ai-step --resume` — paused 상태에서 재개 (Stage 4.5 또는 Stage 11 통과 후)
- `/ai-step --stage <name>` — v0.5 호환 명시적 stage 지정 (예: `brainstorm`, `planning_draft`, `qa`)
- `/ai-step <stage_name>` — 위와 동일 (positional)
- `/ai-step --dry-run --stage 13` — Stage 13 archive hook mutation 미실행, 예정 동작만 출력

## Stage 13 archive hook (v0.6.2~)

`/ai-step --auto`가 Stage 13에 도달하면 `_ai_step_archive_handoff` 자동 발화:
1. `handoffs/active/HANDOFF_v<X>.md` status `active` → `archived`
2. `mv handoffs/active/HANDOFF_v<X>.md handoffs/archive/`
3. `rm -f HANDOFF.md` (옵션 A 부재 정책, F-04-S5a)

다음 버전 시작 = `/init-project` 호출 시 `_init_handoff_active`가 신규 active 생성 + symlink 갱신.

## 주의사항

- 승인 게이트(Stage 4.5, Stage 11)에서는 자동 진행 중단. 운영자 검토 + `--resume`으로 재개.
- frontmatter는 `.claude/settings.json` 필드를 직접 참조하지 않는다 (F-62-1).
- F-X-3 회귀 테스트: `tests/v0.6.2/test_slash_handoffs_e2e.sh`로 hook 결합 검증 (Stage 9).

## 내부 매핑

```bash
bash scripts/ai_step.sh "$@"
```
