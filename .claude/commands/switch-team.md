---
description: 런타임 team_mode 전환 (claude-only / claude-impl-codex-review / codex-impl-claude-review)
argument-hint: "[<mode>] [--status] [--force]"
allowed-tools: Bash
---

# /switch-team

런타임 `team_mode`를 전환하고 `stage_assignments` 4개 키를 동시에 atomic 갱신한다. 백그라운드 `claude` / `codex` 프로세스 진행 중이면 차단(brainstorm Sec.5 verbatim 메시지), 없으면 즉시 적용.

## 사용법

- `/switch-team` — 대화형 모드 (3종 중 선택)
- `/switch-team claude-only` — Claude 단독 모드로 전환
- `/switch-team claude-impl-codex-review` — Claude 구현 + Codex 리뷰 모드
- `/switch-team codex-impl-claude-review` — Codex 구현 + Claude 리뷰 모드
- `/switch-team --status` — 현재 team_mode + stage_assignments 출력 (read-only)
- `/switch-team <mode> --force` — 백그라운드 프로세스 검사 우회 (운영자 책임)

## 주의사항

- 백그라운드 프로세스 감지 패턴: `pgrep -fl 'claude.*--teammate-mode'` + `(codex-plugin-cc|/codex:(rescue|review|status))`.
- `--force`는 진행 중 작업 무시. 데이터 손실 위험 → 운영자 명시 승인 후만 사용.
- frontmatter는 `.claude/settings.json` 필드를 직접 참조하지 않는다 (F-62-1).
- team_mode 리터럴은 표시 경로(printf / --status)에만 등장. 실행 분기 0건 (F-2-a).

## 내부 매핑

```bash
bash scripts/switch_team.sh "$@"
```
