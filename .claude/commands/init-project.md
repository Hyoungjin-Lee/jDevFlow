---
description: jOneFlow 신규 프로젝트 초기화 (workflow_mode + team_mode + scaffold)
argument-hint: "[--with-env] [--no-prompt] [--force-reinit] [--dry-run]"
allowed-tools: Bash
---

# /init-project

신규 jOneFlow 프로젝트를 초기화한다. `.claude/settings.json` schema v0.4의 `workflow_mode` + `team_mode` + `stage_assignments`를 대화형 또는 무대화 모드로 설정하고, 표준 디렉토리 구조를 scaffold한다.

## 사용법

- `/init-project` — 대화형 모드 (`workflow_mode` + `team_mode` 선택)
- `/init-project --with-env` — `.env.example` → `.env` 복사 (로컬 개발용)
- `/init-project --no-prompt` — 기본값(`workflow_mode=1` / `team_mode=3`)으로 자동 진행
- `/init-project --force-reinit` — settings.json 재생성 (v0.4 fields 갱신, agents.* 보존)
- `/init-project --dry-run` — mutation 미실행, 예정 동작만 출력

## 주의사항

- 본 명령어는 `bash scripts/init_project.sh` 래퍼다. 셸 스크립트 인터페이스 변경 시 본 정의도 동기 갱신 필요.
- frontmatter는 `.claude/settings.json` 필드를 직접 참조하지 않는다 (F-62-1 정책).
- 신규 프로젝트 scaffold 시 `JONEFLOW_SRC_ROOT` 환경변수를 설정하면 `docs/operating_manual.md`, `docs/bridge_protocol.md`, `docs/guides/`가 자동 복사됨 (F-EDU-D3).

## 내부 매핑

```bash
bash scripts/init_project.sh "$@"
```
