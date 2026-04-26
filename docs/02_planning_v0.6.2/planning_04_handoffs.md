---
version: v0.6.2
stage: 4 (plan_final)
date: 2026-04-26
mode: Standard
status: pending_operator_approval
item: 04_handoffs
author: 장그래 (기획팀 주임연구원)
revision: v3 (final)
final_at: 2026-04-26
finalized_by: 안영이 (기획팀 선임연구원)
incorporates_review: planning_review.md
revisions_absorbed: [F-04-D1, F-04-1, F-04-2, F-04-3, F-04-4, F-04-S5a, F-04-S5b]
cross_cutting_absorbed: [F-X-2, F-X-3, F-X-7]
---

# jOneFlow v0.6.2 — handoffs/ 폴더 구조 (planning_04_handoffs)

> **상위:** `docs/01_brainstorm_v0.6.2/brainstorm.md` Sec.6 (Stage 1, 세션 23)
> **본 문서:** `docs/02_planning_v0.6.2/planning_04_handoffs.md` (Stage 4 final, 세션 25)
> **상태 배너:** ⏳ **운영자 승인 대기** (Stage 4.5). 승인 없이 Stage 5 진입 금지.
> **다음:** Stage 4.5 운영자 승인 게이트 → Stage 5 기술 설계 (필수) → Stage 8 구현
> 모드 근거: HANDOFF 파일 재구조화는 운영 정책(버전 관리, 심볼릭 링크) 변경이지 기술 스키마 변경 아님. 병렬 스프린트 지원이 표준 요구사항이므로 Standard 유지.

---

## Sec. 0. v2 → final 변경 요약

| ID | 위치 | 변경 요지 |
|----|------|---------|
| F-04-D1 (정책 commit) | Sec.1, Sec.2 | active/ 동시성 규칙: active 1개 + preparing N개 + archived 즉시 archive/ (v2에서 흡수 완료) |
| F-04-1 | Sec.4.5 hook | archive 후 symlink 부재 구간 정책 — Stage 5 이월 (v2에서 흡수 완료) |
| F-04-2 | AC 표 | 측정 명령 컬럼 추가 (v2에서 흡수 완료) |
| F-04-3 | Sec.4.5 코드 | BSD sed 호환성 주석 박음 (v2에서 흡수 완료) |
| F-04-4 | Appendix A | 실측 archive 파일 1개(v0.3)만 반영 (v2에서 흡수 완료) |
| F-04-S5a | Sec.9 이월 표 | archive 후 HANDOFF.md 승격/부재 정책 Stage 5 결정 (v2에서 흡수 완료) |
| F-04-S5b | Sec.9 이월 표 | .gitattributes + Windows symlink 가이드 Stage 5 이월 (v2에서 흡수 완료) |
| **F-X-2 (횡단)** | Sec.9 이월 표 | bridge_protocol.md에 handoffs/ symlink 정책 추가 — Stage 5 이월 |
| **F-X-3 (횡단)** | Sec.9 이월 표 | slash + hook 결합 회귀 테스트 — Stage 5 이월 |
| **F-X-7 (횡단)** | Sec.6 의존성 | 구현 순서 박음: 02 → 01 → 05 → **04(본 항목)** → 03 |
| **handoffs/ archive 보존 정책 (Q4)** | Sec. 0 정책 | 영구 보존. 브랜치와 달리 archive는 history 보존이 목적. |
| **AC 자동/수동 분류 확정** | Sec.5 전체 | 자동 5건 / partial 2건 / F-04-D1 적용 후 1건 |
| **운영자 결정 게이트** | Sec. 끝 | Q4(archive 보존 기간) 게이트 박음 |

**정책 (Q4 finalizer 결정):** handoffs/archive/ 보존 기간 = **영구 보존**. 브랜치 1주일 정책(v0.6.1 F-N1-a)과 별도. archive 파일은 history 보존 목적이므로 삭제 기준 없음.

---

---

## Sec. 1. 목적 (Purpose)

v0.6.1까지 사용해온 단일 `HANDOFF.md` 파일 모델은 한 번에 하나의 버전만 진행 가능합니다. 실제로는 v0.6.1 본 릴리스가 진행 중일 때 v0.6.2 브레인스토밍을 병렬로 진행했습니다(세션 23). 이러한 병렬 워크플로우를 정식화하기 위해 HANDOFF 파일을 버전별로 분리하고, 심볼릭 링크를 통해 "현재 활성 버전"을 가리키는 구조로 전환합니다. 이를 통해:

- **병렬 스프린트 지원:** 여러 버전을 동시에 준비/진행 가능
- **R2 진입점 호환성 유지:** `HANDOFF.md` 심볼릭 링크가 항상 현재 버전을 가리키므로, 기존 R2 읽기 순서 지침 불변
- **자동화 연동:** ai_step.sh(Stage 13 완료) + init_project.sh(새 버전 시작) hook으로 자동 폴더 이동/생성

**정책 결정 (F-04-D1):** active/ 디렉토리는 다음 규칙 준수:
- `active` 상태: 정확히 1개만 (HANDOFF.md symlink가 가리킴, R2 진입점)
- `preparing` 상태: 0~N개 (브레인스토밍 진행 중인 차기 버전)
- `archived` 상태: 즉시 archive/ 폴더로 이동 (active/에 미보유)

---

## Sec. 2. 범위 (Scope)

### 변경 항목

#### 디렉토리 구조 신규 생성
- **`handoffs/active/`** — 현재 진행 중인 버전 HANDOFF 파일 저장
- **`handoffs/archive/`** — 릴리스 완료된 버전 HANDOFF 파일 저장

#### 기존 파일 마이그레이션
- **`HANDOFF.md` (file → symlink):** 현 파일을 `handoffs/active/HANDOFF_v<현재버전>.md`로 이동 후, 루트의 `HANDOFF.md`를 해당 파일을 가리키는 심볼릭 링크로 교체
- **Legacy archive 통합:** 기존 `HANDOFF.archive.v0.3.md` 등 구버전 아카이브 파일들을 `handoffs/archive/` 로 이동

#### 메타데이터 강화
- **frontmatter `status` 필드:** `active` / `preparing` / `archived` 세 가지 상태 추가 (모든 HANDOFF 파일에 필수)
- **버전 명시:** `version: v<X>.<Y>.<Z>` frontmatter 필드로 파일별 버전 명확화

#### 자동화 hook 추가 (구현 대상 파일)
- **`scripts/ai_step.sh`:** Stage 13 완료 시 → `handoffs/active/<파일>` → `handoffs/archive/` 이동 + 심볼릭 링크 교체 자동 실행
- **`scripts/init_project.sh`:** 새 버전 시작 시 → `handoffs/active/HANDOFF_v<신규버전>.md` 신규 생성 + 심볼릭 링크 갱신 자동 실행

### 미변경 항목
- `CLAUDE.md`, `WORKFLOW.md` 등 기타 정규 파일 — 수정 없음
- `.claude/settings.json` — 현 구조 유지 (v0.6 schema 기준)
- Stage 1 brainstorm 혹은 Stage 3 이후 기획 파일 — 범위 외

---

## Sec. 3. 변경 대상 파일

| 파일/디렉토리 | 작업 | 설명 | 라인 수(예상) |
|-------------|------|------|-------------|
| `handoffs/` (신규 디렉토리) | create | 루트 하위 신규 폴더 생성 | — |
| `handoffs/active/` (신규 디렉토리) | create | 활성 버전 HANDOFF 파일 저장 | — |
| `handoffs/archive/` (신규 디렉토리) | create | 아카이브 버전 HANDOFF 파일 저장 | — |
| `HANDOFF.md` | convert file→symlink | 현 내용을 `handoffs/active/HANDOFF_v0.6.2.md` 로 이동 후 symlink로 교체 | — |
| `handoffs/active/HANDOFF_v0.6.2.md` | create | 현 `HANDOFF.md` 내용 + frontmatter `status: active` 추가 | 현 `HANDOFF.md` 라인 수 +5 |
| `handoffs/archive/HANDOFF_v0.3.md` (등) | move | 기존 `HANDOFF.archive.v0.3.md` → `handoffs/archive/HANDOFF_v0.3.md` | — |
| `scripts/ai_step.sh` | add hook | Stage 13 완료 후 archive 이동 + symlink 갱신 로직 | +15~25 라인 |
| `scripts/init_project.sh` | add hook | 새 버전 시작 시 active/ 신규 파일 생성 + symlink 갱신 로직 | +15~25 라인 |

---

## Sec. 4. 단계별 작업 분해

### 4.1 부분 ① — 폴더 구조 생성

- [ ] `mkdir -p handoffs/active handoffs/archive` 실행
- [ ] 디렉토리 권한 확인 (`755`)
- [ ] `.gitkeep` 파일 선택적 추가 (선택사항)

### 4.2 부분 ② — HANDOFF.md 파일 이동

- [ ] 현 `HANDOFF.md` 내용 읽기 (약 50줄)
- [ ] frontmatter 섹션 수정:
  ```yaml
  version: v0.6.2
  status: active
  ```
  추가/갱신
- [ ] `handoffs/active/HANDOFF_v0.6.2.md` 로 저장
- [ ] 원본 `HANDOFF.md` 파일 삭제

### 4.3 부분 ③ — 심볼릭 링크 생성

- [ ] 루트에서 `ln -s handoffs/active/HANDOFF_v0.6.2.md HANDOFF.md` 실행
- [ ] `readlink HANDOFF.md` 로 정확성 검증 (출력: `handoffs/active/HANDOFF_v0.6.2.md`)
- [ ] `cat HANDOFF.md` 로 symlink 따라 내용 접근 가능 확인

### 4.4 부분 ④ — Legacy archive 통합

- [ ] 기존 `HANDOFF.archive.v0.3.md` (혹은 기타 구버전 파일) 검색
- [ ] 각 파일에 대해:
  - [ ] frontmatter 추가: `status: archived`, `version: v0.3` (파일명에서 추출)
  - [ ] `handoffs/archive/HANDOFF_v0.3.md` 로 이동 (파일명 정규화: `HANDOFF.archive.v<X>.md` → `HANDOFF_v<X>.md`)
  - [ ] `git mv` 로 이력 보존

### 4.5 부분 ⑤ — ai_step.sh 자동화 hook 추가 (F-04-3: sed 호환성, F-04-1: symlink 부재 정책)

**삽입 위치:** Stage 13 완료 (artifact 생성, 로그 남긴 후) → 다음 버전 대기 전

**로직 (의사 코드, F-04-3 주석):**

```bash
# NOTE: Stage 5에서 lib/settings.sh _frontmatter_set_field 헬퍼로 교체 예정 (BSD sed 호환성)
# Stage 13 이후: archive 이동 + symlink 갱신/부재 정책 결정 필요 (F-04-S5a)
_ai_step_archive_handoff() {
  local current_version=$(settings_read_key "version")
  local active_file="handoffs/active/HANDOFF_${current_version}.md"
  local archive_dir="$ROOT/handoffs/archive"
  
  if [ -f "$active_file" ]; then
    # status: active → archived 갱신 (실제 구현: _frontmatter_set_field 사용)
    _frontmatter_set "$active_file" status archived
    
    # 파일 이동
    mv "$active_file" "$archive_dir/HANDOFF_${current_version}.md"
    
    # symlink 처리 정책 (F-04-S5a, Stage 5 결정)
    # 옵션 A: 부재 상태 → rm -f HANDOFF.md (다음 init 때까지)
    # 옵션 B: 자동 승격 → preparing 중 최고 버전을 active로 (연속성 유지)
    # 본 hook은 옵션 A 가정 (부재)
    rm -f HANDOFF.md
    
    printf 'ai_step.sh: archived HANDOFF_%s.md\n' "$current_version" >&2
  fi
}
```

**호출:** Stage 13 로직 마지막 `ai_step_log_transition 'stage13' 'complete'` 이후

### 4.6 부분 ⑥ — init_project.sh 자동화 hook 추가

**삽입 위치:** 새 버전 설정 (workflow_mode/team_mode 선택 후) → `.claude/settings.json` 저장 전

**로직:**

```bash
# 신규 버전 시작: active/ 신규 파일 생성 + symlink 갱신
_init_handoff_active() {
  local version="$1"  # 예: v0.6.2
  local active_file="$ROOT/handoffs/active/HANDOFF_${version}.md"
  
  cat > "$active_file" <<EOF
---
version: ${version}
status: active
date: $(date +%Y-%m-%d)
mode: ${WORKFLOW_MODE:-}
---

# HANDOFF — $version

## Status

**Current version:** $version (초기화)
**Current stage:** Stage 1 (brainstorm)

...
EOF

  # symlink 갱신
  rm -f "$ROOT/HANDOFF.md"
  ln -s "handoffs/active/HANDOFF_${version}.md" "$ROOT/HANDOFF.md"
  
  printf 'init_project.sh: created HANDOFF_%s.md\n' "$version" >&2
}
```

**호출:** `_init_main` 함수 내, settings.json 쓰기 직후

### 4.7 부분 ⑦ — git 설정 & Windows 호환성 (F-04-S5b: Stage 5 이월)

- [ ] `.gitattributes`에 `HANDOFF.md symlink` 정의 추가 (Stage 5, F-04-S5b)
- [ ] 호환성 이슈 발생 시 대응 가이드 `docs/guides/` 또는 `docs/operating_manual.md`에 추가 (Stage 5)
- [ ] 현재는 Linux/macOS 환경이므로 `ln -s` 직접 사용 가능
- [ ] Windows git clone 시 `git config --global core.symlinks true` 가이드 (Stage 5, F-04-S5b)

---

## Sec. 5. AC (Acceptance Criteria)

| AC ID | 기준 | 측정 명령 (F-04-2 추가) |
|-------|------|---------|
| **AC-Hand-1** | `handoffs/active/` + `handoffs/archive/` 둘 다 존재하고 접근 가능 | `[ -d handoffs/active ] && [ -d handoffs/archive ]` exit 0 |
| **AC-Hand-2** | `readlink HANDOFF.md` 실행 결과 = `handoffs/active/HANDOFF_v<현재>.md` | `readlink HANDOFF.md \| grep -q "handoffs/active/HANDOFF_v"` exit 0 |
| **AC-Hand-3** | `handoffs/active/` 및 `handoffs/archive/` 내 모든 HANDOFF 파일에 frontmatter `status` 필드 포함 | `for f in handoffs/{active,archive}/*.md; do grep -q "^status:" "$f" \|\| echo "FAIL: $f"; done` exit 0 |
| **AC-Hand-4** | ai_step.sh Stage 13 완료 시 자동 archive 동작 검증: 파일 이동 + status 갱신 (partial, dry-run 미정의 시 QA) | dry-run 실행 후 file/symlink 존재 검증 (Stage 5 dry-run 정의 필요) |
| **AC-Hand-5** | init_project.sh 새 버전 시작 시 active/ 신규 파일 생성 + symlink 갱신 자동 확인 | dry-run 실행 후 신규 파일/symlink 생성 검증 (Stage 5 필요) |
| **AC-Hand-6** | R2 진입점 호환성 유지: `HANDOFF.md` 읽기 시 (symlink를 통해) 현재 활성 버전 내용 정확히 접근 가능 | `cat HANDOFF.md \| head -1` 출력과 `cat handoffs/active/HANDOFF_v*.md \| head -1` 비교 일치 |
| **AC-Hand-7** | git 이력 보존: `git log handoffs/` 에서 파일 이동/생성 기록 명확하게 남음 | `git log --follow -- handoffs/active/HANDOFF_v0.6.2.md` 이력 존재 확인 |
| **AC-Hand-8** | 병렬 스프린트: v0.6.1 active + v0.6.2 preparing 동시 존재 가능 (F-04-D1 정책 준수) | 정책 검증 — active 1개 + preparing N개 상태 표기 확인 |

---

## Sec. 6. 의존성

### 내부 의존성
- **brainstorm.md Sec.6:** 확정된 폴더 구조(active/archive) 정확히 반영
- **ai_step.sh 및 init_project.sh 코드 리뷰 필수:** 삽입 위치/로직 확정 전에 Stage 8 이전에 기술 설계(Stage 5)에서 가능

### 외부 의존성
- **git:** symlink 생성/추적
- **bash/ln:** 기본 셸 명령어
- **sed:** frontmatter status 필드 수정 (BSD sed 또는 GNU sed 호환성 고려)

### 다른 planning 항목과의 관계 (F-X-7 구현 순서)

권장 구현 순서: **02(license) → 01(org) → 05(selfedu) → 04(본 항목) → 03(slash)**.

- **planning_01_org.md** — 독립적 (조직도 변경). 본 항목보다 선행.
- **planning_02_license.md** — 독립적 (라이선스). 가장 먼저 가능.
- **planning_03_slash.md** — **약하게 연결: 본 항목 후행.** `/ai-step` slash command가 ai_step.sh hook을 호출하므로, 본 항목 hook 구현 후 slash 회귀 테스트 필요 (F-X-3, Stage 5 이월).
- **planning_05_selfedu.md** — **약하게 연결: 본 항목 선행.** docs/operating_manual.md가 handoffs/ 폴더 구조 설명 포함 가능. init_project.sh의 handoffs/ 초기화 로직도 참조.

**F-X-3 (횡단, Stage 5 이월):** slash + hook 결합 회귀 테스트. ai_step.sh에 archive hook 추가 후 `/ai-step --auto`로 호출했을 때도 hook이 정상 동작하는지 Stage 5 기술 설계에서 명시.

---

## Sec. 7. 리스크 & 완화

| # | 리스크 | Likelihood | Impact | 완화 |
|----|--------|-----------|--------|------|
| R1 | Windows에서 symlink 미지원 (NTFS 권한 이슈) | 중 | 중 | docs/guides/symlink_windows.md 작성 (Stage 5 기술 설계) 또는 Stage 8 구현 시 fallback (파일 복제 vs. symlink 선택) |
| R2 | ai_step.sh Stage 13 자동 archive 시 rollback 불가능 (v0.6.1 진행 중 실수로 archive 이동) | 낮음 | 중 | ai_step.sh에 `--dry-run` 플래그 추가 옵션. 운영자가 최종 승인 전에 preview 가능. 또는 git 커밋으로 자동 보호 |
| R3 | 기존 commit 이력에서 HANDOFF.md가 file로 기록 → symlink로 변환 후 clone 시 혼동 | 낮음 | 낮음 | git log 주석에 "v0.6.2부터 HANDOFF.md symlink 정책으로 전환" 기록. 또는 HANDOFF.md → handoffs/active/ 파일 이동을 명시적 commit으로 남김 |
| R4 | sed -i '' (BSD) vs. sed -i (GNU) 호환성 → init_project.sh/ai_step.sh 스크립트 사용 환경에 따라 실패 | 중 | 낮음 | lib/settings.sh 추가 헬퍼 함수 `_settings_edit_field` 작성 (Stage 8). 또는 Python 스크립트로 frontmatter 수정 |

---

## Sec. 8. 검증 전략

### Stage 3–4 기획 검토 (Opus 리뷰어)
- [ ] brainstorm.md Sec.6과의 일관성 확인
- [ ] ai_step.sh/init_project.sh 삽입 위치 기술 설계 가능성 검토
- [ ] Windows 호환성 리스크(R1) 우선순위 판단

### Stage 5 기술 설계 (선택적, Opus)
- [ ] ai_step.sh/init_project.sh hook 자세한 로직 설계
- [ ] symlink 호환성 가이드 (`docs/guides/`)
- [ ] sed/grep 크로스플랫폼 호환성 전략

### Stage 8 구현
- [ ] 4.1~4.7 단계 순서대로 실행
- [ ] git diff 검토 (폴더/파일 이동/생성/삭제 명확성)
- [ ] AC 8가지 전수 검증

### Stage 9 코드 리뷰 (Opus)
- [ ] ai_step.sh/init_project.sh 추가된 hook 정확성 (에러 처리, 엣지 케이스)
- [ ] symlink 이동 후 다른 모듈에서 HANDOFF.md 참조 부분 회귀 테스트

---

## Sec. 9. Stage 5 이월 표

| 이월 ID | 내용 | 담당 | 시점 |
|--------|------|------|------|
| **F-04-S5a** | archive 후 HANDOFF.md 부재 구간 처리 — 옵션 A(부재, 다음 init까지) vs 옵션 B(preparing 자동 승격) | Stage 5 기술 설계 | **필수** |
| **F-04-S5b** | Windows symlink 호환성 — .gitattributes + Windows 가이드 (`docs/operating_manual.md`에 "Windows 미지원, WSL 사용" 또는 core.symlinks 가이드) | Stage 5 기술 설계 | **필수** |
| **F-X-2** | bridge_protocol.md에 "v0.6.2부터 HANDOFF.md는 handoffs/active/HANDOFF_v<X>.md를 가리키는 symlink. 직접 편집 금지. 편집 대상은 symlink target." 한 줄 추가 | Stage 5 기술 설계 | **필수** |
| **F-X-3** | slash + hook 결합 회귀 테스트: ai_step.sh archive hook 추가 후 `/ai-step --auto` 경로에서도 hook 정상 동작 확인. init_project.sh `--no-prompt` 모드의 frontmatter mode 기본값 "Standard" 박음 | Stage 5 기술 설계 | **필수** |
| **AC-Hand-4/5 dry-run** | ai_step.sh/init_project.sh dry-run 플래그 정의 후 AC-Hand-4/5 자동화 측정 확정 | Stage 5 기술 설계 | 권장 |
| sed -i 호환성 (F-04-3) | lib/settings.sh `_frontmatter_set_field` 헬퍼 구현 — BSD sed(-i '') / GNU sed(-i) 크로스플랫폼 | Stage 5 기술 설계 | **필수** |

---

## Sec. 10. 본 plan이 결정하지 않는 것

- ai_step.sh hook 상세 로직 (Stage 5 기술 설계에서)
- init_project.sh에서 생성할 신규 HANDOFF skeleton 상세 콘텐츠 (Stage 5)
- Windows symlink 호환성 최종 결정 (Stage 3 리뷰)
- sed 호환성 헬퍼 함수 구현 여부 (Stage 5)

---

## Sec. 11. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v1 초안 (세션 25) | brainstorm.md Sec.6 기반 planning_04_handoffs 작성 |
| 2026-04-26 | v2 개정 (세션 25, planning_review.md 흡수) | F-04-D1: active/ 동시성 정책 명시 / F-04-1: archive 후 symlink 부재 정책 (Stage 5 이월) / F-04-2: AC 측정 명령 추가 / F-04-3: sed BSD 호환성 주석 / F-04-4: 실측 archive 파일 반영 / F-04-S5a/S5b: Windows symlink 가이드 이월 |
| 2026-04-26 | v3 final (세션 25, 안영이 finalizer) | 횡단 F-X-2/F-X-3/F-X-7 흡수 / Sec.0 변경 요약 추가 / Q4 보존 정책 확정(영구 보존) / Stage 5 이월 표 확장(F-X-2/F-X-3 추가) / 의존 그래프 수렴(구현 순서 박음) / 운영자 결정 게이트 Q4 박음 |

---

---

## 운영자 결정 게이트 (Stage 4.5)

> Q4는 finalizer 결정 후 운영자 확인. 별도 승인 필수 아님. Stage 4.5 전체 승인 게이트에서 일괄 확인.

| Q | 결정 항목 | 권장 | 답변 |
|---|---------|------|------|
| **Q4** | handoffs/archive/ 보존 기간 — 영구? 기간 제한? | **영구 보존.** 브랜치 1주일 정책(F-N1-a)과 별도. archive 파일은 history 보존 목적. | **finalizer 결정: 영구 보존** (운영자 확인 권장) |

---

## Appendix A. 확정 폴더 구조 (F-04-4: 실측 archive 파일 반영)

```
jOneFlow/
├── handoffs/
│   ├── active/
│   │   ├── HANDOFF_v0.6.2.md    (status: active)
│   │   └── HANDOFF_v0.6.3.md    (status: preparing) [미래 예상]
│   ├── archive/
│   │   ├── HANDOFF_v0.3.md      (status: archived, 실측 2026-04-26)
│   │   └── [v0.4/0.5/0.6/0.6.1 archive 미존재]
├── HANDOFF.md                    (symlink → handoffs/active/HANDOFF_v0.6.2.md)
├── CLAUDE.md
├── WORKFLOW.md
└── ...
```

**주석 (F-04-4):** 기존 HANDOFF.archive.v0.3.md만 archive/로 이동. v0.4/0.5/0.6/0.6.1 archive 파일은 현재 미존재(2026-04-26 시점).

## Appendix B. frontmatter 필드 정의

각 HANDOFF_v<X>.md 파일의 frontmatter:

```yaml
---
version: v0.6.2
status: active          # active / preparing / archived
date: 2026-04-26        # 파일 생성/갱신 날짜
mode: Standard          # Lite / Standard / Strict
---
```

**status 필드:**
- `active` — 현재 진행 중인 버전 (symlink가 가리키는 파일)
- `preparing` — 준비 중인 버전 (brainstorm 진행 중, Stage 2 이전)
- `archived` — 릴리스 완료된 버전 (handoffs/archive/ 보관)

