---
title: 기술 설계 — Bundle 4 (Doc Discipline, 옵션 β)
stage: 5
bundle: 4
version: 1
language: ko
paired_with: technical_design.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# 기술 설계 — Bundle 4 (Doc Discipline, 옵션 β)

**프로젝트:** jDevFlow v0.3
**단계(Stage):** 5 (기술 설계)
**일자:** 2026-04-22 (세션 3 재개)
**모드:** Strict-hybrid (상위 Strict + 번들 내부 Standard)
**입력:** `docs/02_planning/plan_final.md` (Stage 4.5 합동 승인, 2026-04-22) · `prompts/claude/v03/stage5_bundle4_design_prompt_draft.md` (DC.5 #1)
**페어 KO 출력:** 본 문서 자체 (EN 주문서 `technical_design.md` 의 한국어 페어, R4 규칙에 따라 단계 종료 시점에 작성)
**리스크 레벨:** medium (옵션 β)
**has_ui:** false

---

## KO 동기화 체크 (plan_review Sec. 4-3 재사용 블록)

KO 페어 작성 후 점검:

- [x] EN ↔ KO 섹션 헤더 개수 동일 (18 / 18 검증)
- [x] 북극성 문장(또는 Sec. 1 의 등가 문구)이 KO 에 존재하고 내용이 동일
- [x] 잠금 결정 ID (D4.x2 / D4.x3 / D4.x4) 가 양쪽 문서에서 동일
- [x] 수락 기준 항목 개수가 양쪽 문서에서 동일 (AC.B4.1–16, 16 항목 / 16 항목)

(단계 종료 시점 2026-04-22 에 체크 완료.)

---

## 0. 구조적 결정 (잠금 — Bundle 1 의 DEP.1 게이트)

> 아래 세 결정은 DEP.1 (F-o1) 순서 요건을 충족한다.
> 본 섹션이 존재하고 서명된 이후에 Bundle 1 Stage 5 를 시작할 수 있다.
> Bundle 1 설계는 자신의 Sec. 1 에서 본 결정들을 원문 그대로 인용해야 한다.

### D4.x2 — 내부 문서 헤더 스키마

**결정.** plan_final Sec. 7-2 OQ4.1 의 기울기를 확정: **Stage 5 이후 문서에만 YAML 프론트매터를 부여**. Stage 1–4 의 내러티브 / 이중언어 문서는 프론트매터 없이 프로즈만으로 유지.

**범위.**

- 프론트매터를 부여하는 문서: `docs/03_design/**/technical_design.md`, `docs/04_implementation/implementation_progress.md`, `docs/notes/final_validation.md`, `docs/05_qa_release/qa_scenarios.md`, `docs/05_qa_release/release_checklist.md` 및 해당 `.ko.md` 페어 전부.
- 프론트매터를 부여하지 않는 문서: `docs/01_brainstorm/**`, `docs/02_planning/**`, `docs/notes/dev_history.md`, `HANDOFF.md`, `CLAUDE.md`, `WORKFLOW.md`, 모든 `README.md`.

**최소 필수 필드 (EN / KO 공통):**

```yaml
---
title: Technical Design — Bundle 4 (Doc Discipline, option β)
stage: 5
bundle: 4
version: 1
language: en         # "en" 또는 "ko"
paired_with: technical_design.ko.md   # 페어 파일 경로, Stage 11/12 단일 문서에선 생략 가능
created: 2026-04-22
updated: 2026-04-22
---
```

선택 필드: `status` (`draft|approved|archived`), `supersedes`, `validation_group`.

**근거.** Stage 5 이후 문서는 Bundle 1 도구 추천기 (D1.b) 와 Stage 11 dossier 생성기에 의해 기계 파싱된다. 안정적인 프론트매터가 있으면 그 파싱이 단순해진다. 이전 단계 문서는 내러티브·이중언어·사람 우선이므로 프론트매터는 소비자 없는 잡음이 된다.

### D4.x3 — 번들 폴더 명명 규칙

**결정.** plan_final Sec. 7-2 OQ4.2 의 기울기를 확정: **`bundle{id}_{name}/`**, `{name}` 은 snake_case. 이미 `docs/03_design/bundle4_doc_discipline/` 와 `docs/03_design/bundle1_tool_picker/` 로 사용 중.

**규칙.** 폴더명 형식: `bundle<HANDOFF.md bundles[].id 의 정수>_<HANDOFF.md bundles[].name 의 snake_case>/`. id 에 앞자리 0 을 붙이지 않는다.

**근거.** `bundle` 접두사 + 숫자 id 가 `HANDOFF.md bundles[].id` / `HANDOFF.md bundles[].name` YAML 블록과 1:1 로 대응되므로, 정규식 `^bundle(\d+)_(.+)$` 으로 두 필드를 결정적으로 추출할 수 있다. 대안 기각 사유: `{name}/` 은 id 조회 불가; `{nn}_{name}/` 은 새로운 번호 체계를 도입; 숫자만 접두사는 단계 번호와 혼동.

### D4.x4 — 문서 링크 규칙

**결정.** **항상 현재 파일 기준 상대경로.** 프로젝트 루트 절대경로는 금지. 앵커 스타일은 GitHub 규칙: 소문자 + 공백은 하이픈 + 구두점 제거.

**규칙.**

- 같은 폴더 내부: `./sibling.md` (`./` 는 선택이지만 명확성을 위해 권장).
- 형제 폴더 대상: `../other_folder/target.md`.
- 프로젝트 루트 대상: `../` 를 명시적으로 세어서 작성. `/absolute` 문법 금지.
- 앵커: `file.md#section-header-lowercased-hyphenated`. "Sec. 3-2" 를 `#3-2-bundle-4-doc-discipline` 식으로 변환 — 렌더링된 실제 슬러그와 일치시킨다.
- `file://` 또는 절대경로 삽입 금지.
- 외부 링크 (GitHub, Anthropic 문서) 는 완전한 HTTPS URL 사용.

**근거.** 현재 파일 기준 상대경로는 GitHub 웹 UI, VS Code 프리뷰, Claude Code Read 출력, 그리고 모든 표준 Markdown 뷰어에서 일관되게 렌더된다. 프로젝트 루트 절대경로는 그중 절반에서 깨진다. 소문자-하이픈 앵커 규칙은 GitHub 자동 슬러그와 일치하므로 리네임에 견고하다.

### 결정 기록 라인 (Bundle 1 이 원문 그대로 인용)

> **D4.x2/x3/x4 잠금 확정 2026-04-22 — 출처 `docs/03_design/bundle4_doc_discipline/technical_design.md` Sec. 0.** Bundle 1 Stage 5 진입 가능.

---

## 1. 아키텍처 개요

Bundle 4 는 Bundle 1 도구 추천기가 읽고 이후 모든 jDevFlow 사용자가 복제하게 될 **문서 기반(substrate)** 을 수립한다. 의도적으로 작다 — 스크립트·파일 네 개 + 결정 세 개 — 하지만 그 위에 나머지 모든 것이 올려진다.

```
┌─────────────────────────────────────────────────────────────────┐
│                     jDevFlow 프로젝트 루트                      │
├─────────────────────────────────────────────────────────────────┤
│  CHANGELOG.md            (D4.b — 릴리스 로그, "Keep a            │
│                            Changelog" 포맷, 첫 엔트리 v0.3)      │
│  CONTRIBUTING.md         (D4.c — 파일 소유; D4.b 의               │
│                            `## Changelog maintenance` 섹션       │
│                            포함, F-a1 규정)                       │
│  CODE_OF_CONDUCT.md      (D4.c — Contributor Covenant v2.1)     │
│                                                                 │
│  templates/                                                     │
│    HANDOFF.template.md   (D4.x1 — 깨끗한 템플릿 형태)              │
│                                                                 │
│  scripts/                                                       │
│    update_handoff.sh     (D4.a — POSIX sh, dry-run 기본,          │
│                            템플릿 대상으로 작성)                    │
│                                                                 │
│  docs/                                                          │
│    notes/                                                       │
│      decisions.md        (D4.x2/x3/x4 인용 가능 기록              │
│                            — 신규 생성, 본 설계 Sec. 0 으로          │
│                            역링크)                                │
│    03_design/bundleN_.../technical_design.md[.ko.md]            │
│                          (이후 모든 기술 설계는 D4.x2 프론트매터       │
│                            + D4.x3 폴더 명명 + D4.x4 링크 규칙을      │
│                            따른다)                                │
└─────────────────────────────────────────────────────────────────┘
             │
             ▼
    Bundle 1 도구 추천기 (.skills/tool-picker/SKILL.md)
    HANDOFF.md (상태) + docs/ 구조 (D4.x2/x3/x4 준수) 를
    읽고 조언적 추천을 방출.
```

**본 번들의 북극성 (plan_final Sec. 1-1 파생):** jDevFlow v0.3 을 새로 클론한 팀원이 30 분 이내에 (a) `CONTRIBUTING.md` 만 읽고 문서 레이아웃을 이해하고, (b) HANDOFF 템플릿 위치를 찾고, (c) `scripts/update_handoff.sh --dry-run` 을 실행해 Status 갱신 미리보기를 볼 수 있다.

---

## 2. 구성 요소

### 2-1. 구성 요소 — `scripts/update_handoff.sh` (D4.a)

- **책임.** CLI 입력으로부터 `HANDOFF.md` 의 `## Status` 와 `## Recent Changes` 섹션만 멱등적으로 재작성. 다른 부분은 일절 건드리지 않는다. dry-run 이 기본, `--write` 로만 실제 저장.
- **런타임.** POSIX `sh` — bashism 회피를 위해 `dash` 의미를 목표로 한다. v0.3 에선 macOS 만 (plan_final Sec. 5-2 R5), Linux 는 동작 기대, Windows/WSL 은 v0.4 로 연기 (범위 밖).
- **의존성.** coreutils (`sed`, `awk`, `date`), CI lint 용 `shellcheck`. 비표준 도구 없음.
- **파일.** `scripts/update_handoff.sh` (실행 가능, `chmod +x`, shebang `#!/bin/sh`).
- **인터페이스.** Sec. 5-1 참조.

### 2-2. 구성 요소 — `CHANGELOG.md` (D4.b, 파일만)

- **책임.** 릴리스 엔트리를 역시간순으로 보관. 첫 실질 엔트리 = v0.3 자체 (plan_final Sec. 5-2 R7 도그푸딩).
- **포맷.** "Keep a Changelog" v1.1.0 (plan_final Sec. 7-7 OQ.N1 해결). 릴리스별 서브섹션: Added / Changed / Deprecated / Removed / Fixed / Security.
- **소유.** 파일 소유는 D4.b. 유지 규칙(**어떻게 / 언제 추가하는가**)은 `CONTRIBUTING.md` 내부의 단일 `## Changelog maintenance` 섹션에 거주 (plan_final Sec. 3-2 의 F-a1).
- **파일.** 프로젝트 루트의 `CHANGELOG.md`.

### 2-3. 구성 요소 — `CONTRIBUTING.md` (D4.c, 파일 + 소유 문서)

- **책임.** 단일 권위 기여자 대상 문서. 파일 자체 소유 + 최상단에 섹션 단위 소유 표 부착 (F-a1 보정).
- **필수 섹션 (순서 고정):**
  1. 목적 & 대상
  2. 빠른 시작 (clone → 읽기 순서)
  3. 디렉터리 레이아웃 (D4.x3 규칙 인용)
  4. 스테이지 흐름 요약 (`WORKFLOW.md` 인용)
  5. 문서 헤더 스키마 (D4.x2 요약)
  6. 링크 규칙 (D4.x4 요약)
  7. 이중언어 (EN/KO) 정책 및 R4 타이밍 규칙
  8. **Changelog maintenance** — **D4.b** 가 소유하는 섹션, 본문은 F-a1 에 따라 여기에 거주
  9. HANDOFF.md 의 v0.1/v0.2 수작업 마이그레이션 (plan_final Sec. 7-3 OQ.H2 해결)
  10. `scripts/update_handoff.sh` 실행 방법
  11. 행동강령 참조 → `CODE_OF_CONDUCT.md`
  12. 섹션 단위 소유 표 (부록)
- **파일.** 프로젝트 루트의 `CONTRIBUTING.md`.

### 2-4. 구성 요소 — `CODE_OF_CONDUCT.md` (D4.c)

- **책임.** 커뮤니티 행동 기준선.
- **선택.** **Contributor Covenant v2.1** (원문 그대로), 관리자 연락처는 프로젝트 오너로 설정. "base pick" 미해결 질문 해결.
- **파일.** 프로젝트 루트의 `CODE_OF_CONDUCT.md`.

### 2-5. 구성 요소 — `templates/HANDOFF.template.md` (D4.x1)

- **책임.** `HANDOFF.md` 의 깨끗한 템플릿 형태. `scripts/update_handoff.sh` 의 **쓰기 대상**으로 사용 (plan_final Sec. 6 DEP.2 해결).
- **리셋 프로토콜.** 상태(state) 섹션은 템플릿 복사 시 플레이스홀더 텍스트로 초기화. 구조(structural) 섹션은 바이트 그대로 보존. Sec. 4-1 의 섹션 분류 표 참조.
- **파일.** `templates/HANDOFF.template.md`.

### 2-6. 구성 요소 — `docs/notes/decisions.md` (D4.x2/x3/x4 기록)

- **책임.** 세 개의 구조적 결정을 인용 가능한 짧은 기록으로 보관. 각 결정은 자체 H3 섹션을 가지며 본 설계 Sec. 0 으로 역링크. Bundle 1 도구 추천기는 본 설계 파일이 아니라 **이 파일** 을 읽는다. 이는 `.skills/tool-picker/SKILL.md` 를 Stage-5 설계 경로와 결합시키지 않기 위함.
- **파일.** `docs/notes/decisions.md`.
- **스키마.** 프론트매터 부착 (D4.x2 가 자기 자신에게 적용; 예외이지만 일관성 유지, `stage: 5-support` 로 플래그).

---

## 3. 데이터 흐름

### 3-1. `update_handoff.sh` 엔드-투-엔드

```
CLI 플래그 (--section, --status, --change, --dev-history, --dry-run, --write, …)
           │
           ▼
  [1] 인자 파싱    ──►  검증 오류 ──►  exit 2, stderr 로 usage 출력
           │
           ▼
  [2] HANDOFF.md 대상 위치 결정
      (기본: ./HANDOFF.md;
       --template 일 경우 ./templates/HANDOFF.template.md)
           │
           ▼
  [3] 파일 읽기 (awk 버퍼, ≤ 10 MB 가드)
           │
           ▼
  [4] 섹션 탐지
      (헤더 정규식: ^## Status$ 와 ^## Recent Changes$)
           │
           ├── 섹션 부재 ──► exit 3, 명확한 메시지, 쓰기 없음
           │
           ▼
  [5] 섹션 재작성 (--section 범위에 따라)
      - status: "## Status" 아래를 다음 최상위 헤더 전까지 치환
      - recent_changes: "## Recent Changes" 아래 마크다운 표의
        헤더 행은 유지한 채 한 행을 맨 위에 삽입
           │
           ▼
  [6] diff 미리보기 (항상 stdout 으로 방출)
           │
           ├── --dry-run (기본) ──► exit 0, 파일 쓰기 없음
           │
           ▼
  [7] 임시 파일 경유 원자 rename 으로 쓰기
           │
           ▼
  [8] 쓰기 후 검증 (재읽기 + diff empty 확인)
           │
           └── 불일치 ──► exit 4, 백업 복원, 에러 출력
           │
           ▼
  exit 0, "OK — updated HANDOFF.md (section=...)." 출력
```

오류 분기 커버리지: 섹션 부재(단계 4), 표 불량(단계 5 → exit 5), 쓰기-후-검증 불일치(단계 8 → exit 4).

### 3-2. CHANGELOG 추가 흐름 (v0.3 에선 수작업, 스크립트 없음)

`CONTRIBUTING.md Sec. 8` 이 수작업 절차를 규정. v0.3 에선 자동화 없음 (연기). 첫 엔트리는 Stage 12 에서 "v0.3 — release" 로 수작업 기입.

---

## 4. 데이터 모델

### 4-1. HANDOFF.md 섹션 분류 (`update_handoff.sh` + 템플릿 리셋용)

| 섹션 (헤더) | 분류 | 템플릿 복사 시 리셋? | 스크립트가 쓰는가? |
|------------|-------|---------------------|-------------------|
| 제목 + 상단 배너 | structural | no | no |
| `## Status` | state | yes (플레이스홀더) | yes (`--section=status` 또는 `both`) |
| `## Bundles (v0.3 scope)` + YAML | structural-with-placeholders | yes (YAML 바디를 빈 `bundles: []` 로) | no (v0.3); v0.4 에서 확장 가능 |
| `## Recent Changes` | state | yes (플레이스홀더 한 행) | yes (맨 위 한 행 삽입) |
| `## Key Document Links` | structural-with-placeholders | yes (상태 컬럼을 `⬜ Not started` 로) | no |
| `## Next Session Prompt` | state | yes (플레이스홀더 템플릿) | no (v0.3); v0.4 에서 확장 가능 |
| 한국어 미러 (`## 현재 상태` …) | 상단과 미러 | yes (동일 섹션 집합) | yes (동일 플래그; KO 키는 EN 미러) |

### 4-2. CHANGELOG 엔트리 스키마

```markdown
## [VERSION] - YYYY-MM-DD

### Added
- …

### Changed
- …

### Fixed
- …
```

빈 서브섹션은 생략. 엔트리는 역시간순 (새 것이 위, `# Changelog` H1 과 도입 단락 바로 아래).

### 4-3. YAML 프론트매터 스키마 (D4.x2)

```yaml
---
title: string                        # 필수
stage: integer 1..13 | "5-support"   # Stage-5+ 문서에 필수
bundle: integer | null               # 크로스 번들이면 null
version: integer                     # 필수, 비자명 편집 시 증가
language: "en" | "ko"                # 필수
paired_with: string (파일명)          # 선택; `.ko.md` / `.en.md` 페어 존재 시 필수
created: YYYY-MM-DD                  # 필수
updated: YYYY-MM-DD                  # 필수
status: "draft" | "approved" | "archived"   # 선택; 기본 "draft"
supersedes: string (파일경로)         # 선택
validation_group: integer            # 선택; Stage 11 관련 시에만
---
```

알 수 없는 필드는 허용(전방 호환). 파서는 선택 필드의 부재에 관대해야 하며 미지 키로 인해 실패해선 안 된다.

---

## 5. API 계약

### 5-1. `scripts/update_handoff.sh` CLI 계약

```
update_handoff.sh [OPTIONS]

OPTIONS
  --section <status|recent_changes|both>
                          (기본값: both) 갱신할 섹션
  --status <text>         "Current stage:" 에 들어갈 한 줄 텍스트 (status 전용)
  --status-version <v>    "Current version:" 값 (status 전용)
  --change <text>         Recent Changes 에 새 행으로 삽입할 한 줄 텍스트
                          (recent_changes 전용). 날짜는 UTC 오늘로 자동 설정.
  --dev-history <text>    선택: docs/notes/dev_history.md 에 현재 세션
                          엔트리로 한 줄 추가. 해당 KO 추가를
                          dev_history.ko.md 에도 함께 수행.
  --file <path>           대상 HANDOFF.md (기본값: ./HANDOFF.md)
  --template              ./templates/HANDOFF.template.md 를 대상으로 사용
  --write                 실제 저장 (기본은 dry-run)
  --dry-run               명시적 dry-run (기본값이지만 스크립트 명료성 위해 유지)
  --no-diff               stdout 의 diff 미리보기 억제
  -h, --help              usage 출력
  -V, --version           스크립트 버전 출력
```

### 5-2. 종료 코드

| 코드 | 의미 |
|-----|------|
| 0   | 성공 (dry-run 또는 실제 저장) |
| 1   | 일반 런타임 실패 (예비) |
| 2   | 사용법 오류 (잘못된 플래그 또는 필수 텍스트 누락) |
| 3   | 대상 파일 부재 또는 섹션 미발견 |
| 4   | 쓰기 후 검증 실패; 백업 복원 완료 |
| 5   | `## Recent Changes` 표 불량 (헤더 부재 또는 컬럼 수 불일치) |

0 이 아닌 종료는 stderr 에 한 줄 사람이 읽을 수 있는 사유를 출력하고 **동시에** stdout 에 `error=<code_name>` 형태의 기계 파싱 가능 키를 출력한다.

### 5-3. stdout/stderr 규율

- diff 미리보기 → **stdout** (필요시 `less` / `diff` 로 파이프).
- 정보성 성공 메시지 → **stdout**.
- 모든 에러 · usage · 경고 → **stderr**.
- 종료 코드 사유(비자명한 0 이 아닌 경우) → **stderr**.

---

## 6. 오류 처리

| 실패 유형 | 탐지 | 조치 | 종료 |
|----------|------|------|------|
| 알 수 없는 플래그 | 인자 파서 | usage 출력, 중단 | 2 |
| 필수 `--status` 또는 `--change` 누락 | 인자 파서 (`--section` 범위별) | "status/change text required for --section=X" | 2 |
| 대상 파일 부재 | 단계 2 | "HANDOFF.md not found at <path>" | 3 |
| 섹션 헤더 부재 | 단계 4 정규식 | "section \`## Status\` not found" | 3 |
| Recent Changes 표 불량 | 단계 5 | "Recent Changes table missing header row" | 5 |
| 쓰기 시 디스크 풀 · 권한 오류 | 단계 7 `mv` 실패 | 대상 미변경 (임시 파일 폐기) | 1 |
| 쓰기 후 검증 불일치 | 단계 8 | 쓰기 이전 백업 `.bak` 복원, "verify mismatch; rolled back" | 4 |
| 파일 > 10 MB 가드 | 단계 3 | "HANDOFF.md unusually large; aborting"; 사용자 조사 필요 | 1 |

재시도 로직 없음 — 모든 실패는 즉시 표면화되어 사용자가 상태가 미변경임을 알 수 있어야 한다.

---

## 7. 보안 고려

- **HANDOFF.md 에 시크릿 금지.** 스크립트는 `--status` 또는 `--change` 텍스트가 관대한 `TOKEN|SECRET|KEY|PASSWORD|Bearer\s|sk-` 정규식과 매치되면 경고 출력 후 중단 (exit 2). 우발적 시크릿 유출 완화 (v0.2 에서 이월된 `security/` 모듈은 영향 없음).
- **입력 길이 가드.** `--status` ≤ 500 자, `--change` ≤ 1000 자. 초과 시 중단 (exit 2) — 병리적 정규식 행동 예방.
- **임의 파일 쓰기 금지.** 대상은 언제나 `HANDOFF.md` 또는 템플릿; `--file` 은 `HANDOFF*.md` 로 끝나는지 검증.
- **대상과 같은 디렉터리의 임시 파일** (원자 `mv`); symlink 하이재킹 가능성이 있는 `/tmp` 경유 금지.
- **Shellcheck 청결.** `shellcheck -S style` 이 경고 없이 통과해야 함 (수락 기준).
- **네트워크 · 인증 · 추가 서브프로세스 생성 없음** (coreutils 외). "N/A for auth, reason: local read/write only."
- **로깅 규율.** `--status` · `--change` 원문을 파일에 기록 금지; stdout/stderr 에만 출력.

---

## 8. 테스트 전략

| 구성 요소 | 테스트 유형 | 엣지 케이스 / 단언 |
|----------|------------|--------------------|
| `update_handoff.sh` 인자 파서 | unit (shell) | 알 수 없는 플래그 → exit 2; 필수 텍스트 누락 → exit 2 |
| `update_handoff.sh` status 작성기 | integration | `## Status` 바디 비어 있음; 여러 key-value 라인; 비-ASCII (한글) 입력 보존 |
| `update_handoff.sh` recent_changes 작성기 | integration | 빈 표(헤더만); 100 행 표(perf smoke); 불량(선행 `\|` 부재 — exit 5) |
| `update_handoff.sh` 원자 쓰기 | integration | 읽기 전용 대상으로 쓰기 실패 모사 → exit 1, 손상 없음 |
| `update_handoff.sh` 시크릿 탐지 | unit | `Bearer eyJ…` 포함 입력 → exit 2 |
| `update_handoff.sh` 멱등성 | integration | `--write` 후 동일 명령 재실행 → diff 없음 |
| `update_handoff.sh` CRLF 줄 끝 | integration | CRLF 입력 수용, 쓰기 시 원래 줄 끝 보존 |
| `update_handoff.sh` KO 미러 | integration | `--section=status` 가 EN 과 KO 상태 블록을 일관되게 갱신 |
| `CONTRIBUTING.md` 구조 | lint | 12 개 필수 섹션 존재, 순서 고정 |
| `CHANGELOG.md` | lint | 첫 엔트리 = `## [0.3.0] - YYYY-MM-DD`; Keep-a-Changelog 서브섹션명 유효 |
| `HANDOFF.template.md` 리셋 | unit | 현 HANDOFF.md 대비 state 섹션만 차이 있음 |
| D4.x2 프론트매터 | lint | 모든 Stage-5+ `.md` 가 필수 필드를 가진 유효한 YAML 블록 소유 |
| D4.x4 링크 규칙 | lint | `file://` 없음, 선행 슬래시 절대경로 없음, 깨진 상대경로 없음 |
| **KO 신선도** [OQ.L2 Stage-9 half] | **코드 리뷰 체크리스트** | 단계 종료 문서마다: KO 페어 존재 + `updated` 필드가 EN 주문서 후 ≤ 1 일 |

테스트 하네스: `tests/bundle4/` 아래의 평범한 셸 스크립트(테스트당 단일 파일), 최상위 `tests/run_bundle4.sh` 로 실행. 테스트 프레임워크 의존성 없음 — Bundle 1 의 "프레임워크 없음" 규율과 미러링.

---

## 9. Codex 용 구현 주석

### 9-1. 생성할 파일 (의존성 순서)

1. `docs/notes/decisions.md` — 본 설계 Sec. 0 을 인용한 세 결정 기록.
2. `templates/HANDOFF.template.md` — Sec. 4-1 에 따른 깨끗 템플릿 형태.
3. `scripts/update_handoff.sh` — 템플릿 형태 대상으로 (DEP.2 해결).
4. `CHANGELOG.md` — "Unreleased" 플레이스홀더만; 실제 v0.3 엔트리는 Stage 12 에 기입.
5. `CODE_OF_CONDUCT.md` — Contributor Covenant v2.1 원문, 이메일 플레이스홀더 `{PROJECT_MAINTAINER_EMAIL}`.
6. `CONTRIBUTING.md` — Sec. 2-3 의 12 섹션 + 섹션 단위 소유 표.
7. `tests/bundle4/` 테스트 하네스 + `tests/run_bundle4.sh`.

### 9-2. 수정할 파일

- `HANDOFF.md` — 구조적 변경 없음; `## Status` 와 `## Recent Changes` 가 템플릿 형태와 필드 단위로 일치하는지 검증 (구조 패리티 체크).
- `CLAUDE.md` — "Read order" 아래에 `CONTRIBUTING.md` 를 가리키는 한 줄 추가 (기존 읽기 순서 보존 — 재정렬 금지).

### 9-3. 제약 (위반 금지 목록)

- `security/` 하의 모든 파일 변경 금지 (plan_final Sec. 6 DEP.5 — 동결).
- `.skills/tool-picker/SKILL.md` 건드리지 말 것 — Bundle 1 영역 (Stage 5 Bundle 1 설계 + Stage 8 Codex).
- POSIX `sh` + coreutils + shellcheck 외 의존성 도입 금지.
- Stage 1–4 문서에 프론트매터 추가 금지 (D4.x2 제외 목록).
- `HANDOFF.template.md` 는 실제 프로젝트 데이터를 담아선 안 됨.
- KO 페어 규율: 본 번들에서 생성되는 프론트매터 부착 문서는 모두 동일 커밋에 `.ko.md` 페어 동반 (Stage 9 에서 R4 강제).

### 9-4. 섹션 단위 소유 표 (F-a1 보정 — CONTRIBUTING.md 부록 최상단 배치)

| 섹션 # | 제목 | 소유 deliverable | 비고 |
|-------|-----|-----------------|------|
| 1 | 목적 & 대상 | D4.c | — |
| 2 | 빠른 시작 | D4.c | — |
| 3 | 디렉터리 레이아웃 | D4.c (D4.x3 인용) | — |
| 4 | 스테이지 흐름 요약 | D4.c | — |
| 5 | 문서 헤더 스키마 | D4.c (D4.x2 인용) | — |
| 6 | 링크 규칙 | D4.c (D4.x4 인용) | — |
| 7 | 이중언어 (EN/KO) 정책 | D4.c | — |
| 8 | Changelog maintenance | **D4.b** | F-a1 유일한 예외: D4.b 소유 CHANGELOG.md 의 유지 규칙이 D4.c 소유 파일 안에 거주. |
| 9 | HANDOFF 수작업 마이그레이션 | D4.c (OQ.H2 해결) | v0.1 → v0.3 과 v0.2 → v0.3 경로 모두 커버. |
| 10 | `update_handoff.sh` 실행 | D4.c (D4.a 인용) | — |
| 11 | 행동강령 참조 | D4.c (`CODE_OF_CONDUCT.md` 인용) | — |
| 12 | 섹션 단위 소유 표 (본 표) | D4.c | 부록; F-a1 권위 기록 역할. |

### 9-5. 커밋 스타일

단일 deliverable 커밋, 각 제목 앞에 `[bundle4] ` 접두사. 예: `[bundle4] Add scripts/update_handoff.sh with dry-run default (D4.a)`.
멀티 파일 원자 커밋은 파일이 진정으로 결합되어 있을 때만 (예: `[bundle4] Add CONTRIBUTING.md + CODE_OF_CONDUCT.md (D4.c)`).
`.ko.md` 페어는 항상 EN 주문서와 같은 커밋에 동반 (Stage 9 코드 리뷰에서 R4 강제).

---

## 10. 범위 밖 (본 구현)

- **N10** (기존 KO 전용 문서에 대한 EN 역번역 소급 적용). `session_token_economics.md` 는 KO 전용으로 유지.
- **N12** (링크 체크 자동화). `update_handoff.sh` 는 `Key Document Links` 의 파일이 디스크에 실제 존재하는지 검증하지 않는다. v0.4 연기.
- **N7** (CI/CD 템플릿, `.github/` PR / issue 템플릿 포함). 본 번들에 없음.
- `update_handoff.sh` 의 Windows / WSL 지원. POSIX-sh on macOS/Linux 만.
- git log 로부터 CHANGELOG 자동 생성. `CONTRIBUTING.md Sec. 8` 에 따라 수작업.
- 기존 문서에 D4.x2 프론트매터 소급 적용. v0.3 이후 신규 Stage-5+ 문서에만. (본 `technical_design.md` 자체는 부착해야 함 — KO 페어 작성 시점에 추가.)
- `.ko.md` 페어 간 링크 체크. 동일한 R4 규율 적용; 검증은 자동이 아닌 사람 / 코드 리뷰.

---

## 11. 수락 기준 (Stage 9 리뷰용)

### 11-1. 주요 deliverable

- [ ] **AC.B4.1** — `scripts/update_handoff.sh` 가 경고 없이 `shellcheck -S style` 통과.
- [ ] **AC.B4.2** — 현 라이브 HANDOFF.md 대상 `update_handoff.sh` dry-run 이 비어 있지 않은 diff 미리보기 생성 (smoke: status/change 테스트 입력); `--write` 두 번 실행하면 두 번째 실행에서 diff 가 0 (멱등성).
- [ ] **AC.B4.3** — `update_handoff.sh` 가 Sec. 6 에 열거된 9 개 오류 케이스 모두에서 0 이 아닌 코드로 종료.
- [ ] **AC.B4.4** — `CHANGELOG.md` 가 "Keep a Changelog" v1.1.0 lint 를 통과 (유효 H2 릴리스 헤더 포맷, 유효 서브섹션명).
- [ ] **AC.B4.5** — `CONTRIBUTING.md` 가 12 개 필수 섹션을 지정 순서로 포함; `## Changelog maintenance` 가 부록 표에서 D4.b 로 명시.
- [ ] **AC.B4.6** — `CODE_OF_CONDUCT.md` 가 Contributor Covenant v2.1 과 원문 일치 (관리자 이메일 제외).

### 11-2. 구조적 결정 / 추가

- [ ] **AC.B4.7** — `docs/notes/decisions.md` 가 D4.x2/x3/x4 를 본 파일 Sec. 0 역링크와 함께 기록. 모든 하위 Stage-5+ 문서가 동일한 세 ID 를 인용.
- [ ] **AC.B4.8** — `templates/HANDOFF.template.md` 의 state 섹션이 Sec. 4-1 분류와 일치; 현 HANDOFF.md 대비 구조 패리티 diff 통과.
- [ ] **AC.B4.9** — YAML 프론트매터 lint (Sec. 8) 가 본 번들의 `.ko.md` 페어 포함 모든 Stage-5+ 문서에 대해 통과.

### 11-3. 크로스 번들 계약 (Stage 11 합동에서 검증)

- [ ] **AC.B4.10** — Bundle 1 도구 추천기가 D4.x2/x3/x4 를 본 tech_design 파일이 아니라 `docs/notes/decisions.md` 로부터 파싱. `.skills/tool-picker/SKILL.md` 에 대한 grep 으로 검증.
- [ ] **AC.B4.11** — Bundle 1 추천 로직(D1.b)이 `worked example` 블록에서 D4.x4 링크 규칙을 따른다.

### 11-4. 리스크 완화 검증

- [ ] **AC.B4.12** — 범위 확장(plan_final R1) 억제: D4.x2/x3/x4 각각 본 문서 Sec. 0 의 한 단락 + 한 줄 근거에 들어감. 결정별 별도 토론 문서 생성 없음.
- [ ] **AC.B4.13** — Shell 호환성(R5) 검증: macOS 14+ 및 Linux CI 실행; 줄 끝 모듈로 동일 출력.
- [ ] **AC.B4.14** — 도그푸딩(R7): CHANGELOG.md 가 Stage 12 종료 시점에 v0.3 릴리스 엔트리를 포함.

### 11-5. 이중언어 규율

- [ ] **AC.B4.15** — 본 번들이 배포하는 모든 Stage-5+ 문서가 동일 git 커밋에 `.ko.md` 페어를 동반. 각 문서 상단의 KO 동기화 체크 블록이 Stage 9 제출 전에 체크 완료.
- [ ] **AC.B4.16** — OQ.L2 Stage-9 half: "단계 종료 문서에 대한 KO 신선도" 체크 항목이 `.github/PULL_REQUEST_TEMPLATE.md` 에… 아니, `.github/` 는 범위 밖(N7). **대신** 이 체크 항목은 `CONTRIBUTING.md Sec. 7` 의 bullet 로 거주하며, Stage 종료 PR 리뷰 시 리뷰어가 표시하도록 기대됨. (OQ.L2 Stage-9 half 를 범위 내에서 해결.)

---

## 12. Codex 핸드오프 부록

### 12-1. Stage 8 (Bundle 4 구현) 용 복붙 킥오프 프롬프트

```
jDevFlow v0.3 Bundle 4 (Doc Discipline, 옵션 β) 를 구현.

순서대로 읽을 것:
1. CLAUDE.md
2. HANDOFF.md
3. WORKFLOW.md Sec. 10 Stage 8
4. docs/03_design/bundle4_doc_discipline/technical_design.md (본 설계 EN)
5. docs/03_design/bundle4_doc_discipline/technical_design.ko.md (KO 페어)
6. docs/02_planning/plan_final.md Sec. 3-2, 5-2, 6 (컨텍스트)

deliverable, 의존성 순서 (Sec. 9-1):
1. docs/notes/decisions.md
2. templates/HANDOFF.template.md
3. scripts/update_handoff.sh  — POSIX sh, shellcheck 청결
4. CHANGELOG.md  — Unreleased 플레이스홀더만; 실제 v0.3 엔트리는 Stage 12
5. CODE_OF_CONDUCT.md  — Contributor Covenant v2.1
6. CONTRIBUTING.md  — Sec. 2-3 의 12 섹션; F-a1 소유 표
7. tests/bundle4/ + tests/run_bundle4.sh  — Sec. 8 표 참조

제약 (위반 금지 — Sec. 9-3):
- POSIX sh 만; bashism 금지
- security/ 변경 금지
- .skills/tool-picker/ 변경 금지 (Bundle 1 영역)
- Stage 1–4 문서에 프론트매터 추가 금지
- KO 페어는 EN 주문서와 같은 커밋에 동반

완료 시 보고: 생성/수정한 모든 파일 경로, shellcheck 출력,
테스트 실행 출력. 이후 Stage 9 코드 리뷰로 진입.
```

### 12-2. Codex 가 선택해도 되는 것

- `update_handoff.sh` 의 섹션 탐지 정규식 구체 구현 (awk vs. sed 은 Codex 선택).
- 롤백 백업 파일명 관행 (예: `.HANDOFF.md.bak.YYYYMMDDTHHMMSS`).
- `tests/bundle4/` 내부 테스트 하네스 명명 — 단, `tests/run_bundle4.sh` 가 유일한 진입점이어야 한다.

### 12-3. Codex 가 단독 결정해선 안 되는 것

- D4.x2 / D4.x3 / D4.x4 를 변경하는 모든 것 (Sec. 0 은 잠금; 변경은 Stage 5 재진입 필요).
- Sec. 9-1 에 열거되지 않은 새 최상위 파일 또는 폴더 추가.
- `update_handoff.sh` 의 CLI 플래그 표면 변경 (구멍 발견 시 Stage 9 finding 으로 승격).

---

## 13. 전방 노트 / 하우스키핑

- **Stage 9 (코드 리뷰)** — 12 섹션 CONTRIBUTING.md 구조 + Sec. 8 테스트 표를 리뷰 루브릭으로 사용. AC.B4.15 가 빠뜨리기 쉬우므로 리뷰어가 명시적으로 체크할 것.
- **Stage 11 합동 검증** — 본 번들의 dossier (`docs/notes/stage11_dossiers/bundle4_dossier.md`, DC.6) 는 수락 기준 표에 AC.B4.1 ~ AC.B4.16 을 인용하고 미체크 항목을 표식할 것.
- **Stage 13** — 본 번들은 단일 합동 `v0.3` git 태그에 기여 (plan_final M.6). CHANGELOG 엔트리 "v0.3 — release" 가 여기에 착지.

---

## 14. 본 문서 개정 로그

| 일자 | 개정 | 비고 |
|-----|------|------|
| 2026-04-22 | v1 — Stage 5 Bundle 4 기술 설계 | 세션 3 재개. D4.a ~ D4.c + D4.x1 ~ x4 커버; OQ.N1, OQ4.1, OQ4.2, OQ.H2, OQ.L2 Stage-9 half 해결. Sec. 0 D4.x2/x3/x4 잠금 — Bundle 1 Stage 5 진입 가능. YAML 프론트매터(D4.x2 준수) 단계 종료 시 추가; KO 페어 `technical_design.ko.md` 가 R4 규율에 따라 같은 세션에 작성; KO 동기화 체크 블록 체크 완료. |
