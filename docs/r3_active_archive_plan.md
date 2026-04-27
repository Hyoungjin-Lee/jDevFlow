# Round 3 의제 2 권고 Plan — active/archive 패턴 재구성

> **목적:** v0.6.4 마감 후 handoffs + dispatch 파일 정리 미완료 → active/archive 패턴 명시화 권고.
> **범위:** drafter 권고 plan doc. 실제 파일 이동/변경은 reviewer/finalizer 영역 (회의창 사전 승인 필수).
> **주의:** 디렉토리 구조 변경 = 헌법 위반 위험 → 운영자 명시 승인 후 진행.

---

## 1. 현황 진단

### 1.1 handoffs/ 구조 (문제)

**현재:**
```
handoffs/
├── active/
│   ├── HANDOFF_v0.6.4.md  ⚠️ v0.6.4 마감됨 (archive로 이동 필요)
│   └── HANDOFF_v0.6.5.md  ✅ 현재 active
└── archive/
    ├── HANDOFF_v0.3.md
    ├── HANDOFF_v0.6.2.md
    └── HANDOFF_v0.6.3.md
```

**문제점:**
1. v0.6.4가 아직 active/에 있음 (13주일이 지남)
2. 각 HANDOFF 파일 안에 sub-폴더가 있는지 확인 필요 (예: `v0.6.4/` 폴더)
3. HANDOFF.md symlink = 항상 active/HANDOFF_v<현재>.md를 가리켜야 함

**규칙 참조:** `docs/operating_manual.md` Sec.5.4 + `docs/bridge_protocol.md` Sec.0.1

---

### 1.2 dispatch/ 구조 (문제)

**현재:**
```
dispatch/
├── 2026-04-27_v0.6.5_lite_mvp.md
├── 2026-04-26_v0.6.4_stage9_... (여러 건)
├── 2026-04-XX_v0.6.3_... (여러 건)
└── ... (단일 디렉토리, 37개 파일)
```

**문제점:**
1. 37개 모든 파일이 dispatch/ 최상위에 혼재
2. 버전별/의제별 검색 어려움
3. 브릿지가 "dispatch/을 읽고 send-keys" 패턴에서 파일 선택 모호

---

## 2. 권고 재구성 방안

### 2.1 handoffs/ 정리 (우선순위: 높음)

**Action 1: v0.6.4 → archive/ 이동**
```bash
# 수동 (runner script 아님, 회의창이 직접 또는 reviewer가 실행)
mv handoffs/active/HANDOFF_v0.6.4.md handoffs/archive/

# 또는 git mv
git mv handoffs/active/HANDOFF_v0.6.4.md handoffs/archive/HANDOFF_v0.6.4.md
git commit -m "chore: v0.6.4 handoff → archive"
```

**Action 2: HANDOFF.md symlink 갱신**
```bash
# 현재 symlink 확인
ls -la HANDOFF.md

# 제거 후 재생성
rm HANDOFF.md
ln -s handoffs/active/HANDOFF_v0.6.5.md HANDOFF.md
git add HANDOFF.md
git commit -m "chore: update HANDOFF.md symlink → v0.6.5"
```

**Action 3: v0.6.4 sub-폴더 확인**
```bash
# 있으면 (예: handoffs/active/v0.6.4/)
ls -la handoffs/active/v0.6.4/
# → 있으면 함께 archive로 이동
mv handoffs/active/v0.6.4/ handoffs/archive/
```

**규칙 정책:**
- Stage 13 완료 시 `ai_step.sh` 자동으로 active → archive 이동 (옵션 A: 운영자 승인 후 자동)
- v0.6.6+: hooks에 자동 이동 trigger 추가

---

### 2.2 dispatch/ 트리 재구성 (우선순위: 중간)

**권고 구조:**
```
dispatch/
├── active/
│   └── v0.6.5/
│       ├── 2026-04-27_lite_mvp.md
│       ├── round1_docs.md (권고: 의제별 분리)
│       ├── round2_scripts.md
│       └── round3_archive.md
├── archive/
│   ├── v0.6.4/
│   │   ├── 2026-04-26_stage9_...
│   │   └── ... (v0.6.4 dispatch 약 15~20건)
│   ├── v0.6.3/
│   │   └── ... (v0.6.3 dispatch 약 10~15건)
│   ├── v0.6.2/
│   │   └── ... (v0.6.2 dispatch 약 5~10건)
│   └── v0.3/
│       └── ... (v0.3 dispatch 약 2~5건)
└── README.md (검색 가이드)
```

**Action 1: 버전별 디렉토리 생성 + 파일 이동**
```bash
mkdir -p dispatch/active/v0.6.5
mkdir -p dispatch/archive/v0.6.4
mkdir -p dispatch/archive/v0.6.3
mkdir -p dispatch/archive/v0.6.2
mkdir -p dispatch/archive/v0.3

# 파일 분류 이동 (37개 수동 분류 필요)
# 예: 2026-04-27으로 시작 → active/v0.6.5/
#    2026-04-26 또는 v0.6.4 표기 → archive/v0.6.4/
```

**Action 2: 파일 분류 매핑 (37개 문제점 — 표 작성 필요)**

현재 dispatch/ 내용 확인 후, 다음과 같이 분류:
- v0.6.5 (2026-04-27~) = active/v0.6.5/ 로 이동
- v0.6.4 (2026-04-26 이전) = archive/v0.6.4/ 로 이동
- 버전 미표기 파일 = commit trail로 역산

**Action 3: dispatch/README.md 신규**
```markdown
# dispatch 파일 구조

모든 dispatch는 버전별 트리로 정리됨.

- **active/v0.6.5/** — 현재 진행 중 (Stage 1~13)
- **archive/v0.6.4/** — v0.6.4 마감 산출 (읽기 전용)
- **archive/v0.6.3/** 등 — 과거 버전 (참조 전용)

## 검색
특정 버전의 dispatch를 찾으려면:
- `ls dispatch/archive/v0.6.4/` (v0.6.4 모든 dispatch)
- `grep -r "Stage 5" dispatch/active/` (현재 v0.6.5 내 Stage 5)
```

**문제점 — 37개 파일 분류 불가능:**
- drafter는 파일 목록만 제시 (실제 분류 = reviewer/finalizer)
- 각 파일의 버전 판단 기준:
  * 파일명 내 버전 표기 (`_v0.6.X_`)
  * 파일명 내 날짜 (`_2026-04-27_` = v0.6.5 / `_2026-04-26_` 이전 = v0.6.4)
  * git log로 역산 (마지막 커밋 시점)

---

## 3. 브릿지 버전 연동 (선택사항 권고)

### 3.1 브릿지 세션과 handoffs/dispatch 자동 마운트

**권고 구조:**
```
bridge-065 (v0.6.5 active)
  → 읽는 파일: handoffs/active/HANDOFF_v0.6.5.md + dispatch/active/v0.6.5/

bridge-064 (v0.6.4 archive, 재오픈 가능)
  → 읽는 파일: handoffs/archive/HANDOFF_v0.6.4.md + dispatch/archive/v0.6.4/
```

**구현 방식:**
1. scripts/setup_tmux_layout.sh 확장 (브릿지 세션 생성 시 handoffs 버전 인자)
2. ai_step.sh에서 HANDOFF 버전 자동 감지
3. dispatch 선택 시 해당 버전 디렉토리 우선 로드

**v0.6.6 예정 영역 (현재는 수동):**
- 모든 브릿지/오케 스크립트가 버전 인자 자동 인식
- HANDOFF 파일 변경 시 active/archive 자동 판정

---

## 4. 관련 스크립트 갱신 권고 (의제 7과 중복)

### 4.1 scripts/init_project.sh

**확인 항목:**
- [ ] 신규 버전 시작 시 `active/HANDOFF_v<신규>.md` 생성 (현재?)
- [ ] dispatch/active/v<신규>/ 생성 여부 (현재 미구현)

**권고:**
```bash
# init_project.sh 수정 예상
mkdir -p dispatch/active/v${NEW_VERSION}
cp -r dispatch/templates/ dispatch/active/v${NEW_VERSION}/
```

### 4.2 scripts/ai_step.sh

**확인 항목:**
- [ ] Stage 13 완료 시 active → archive 트리거 (현재?)
- [ ] HANDOFF.md symlink 자동 갱신 (현재?)

**권고:**
```bash
# Stage 13 finalizer complete hook에서
if [ "${STAGE}" = "13" ]; then
  # v0.6.X → archive/ 이동
  mv handoffs/active/HANDOFF_v${VERSION}.md handoffs/archive/
  # symlink 갱신 (다음 버전)
  rm -f HANDOFF.md
  ln -s handoffs/active/HANDOFF_v${NEXT_VERSION}.md HANDOFF.md
fi
```

### 4.3 scripts/setup_tmux_layout.sh

**확인 항목:**
- [ ] 브릿지 세션 생성 시 버전 인자 수용 (현재 없음)

**권고:**
```bash
# setup_tmux_layout.sh VERSION 인자 추가
setup_tmux_layout.sh jdevflow 3 v0.6.5
# → dispatch/active/v0.6.5/ 를 기본 working path로 설정
```

### 4.4 .skills/tool-picker/SKILL.md

**확인 항목:**
- [ ] active/archive 패턴 인식 (현재?)
- [ ] 버전 감지 로직 (현재?)

**권고:**
- SKILL이 `git describe --tags` 또는 HANDOFF 버전으로 현재 버전 감지 후
- 해당 dispatch 디렉토리 권고

---

## 5. docs 정합 권고

### 5.1 docs/operating_manual.md Sec.5.4 갱신

**현재:**
```markdown
### 5.4 핸드오프 — `handoffs/` 구조 (v0.6.2~)
```

**권고 추가:**
```markdown
- v0.6.4 이전까지는 active/에만 기록 유지
- v0.6.5부터 Stage 13 완료 시 자동 archive/ 이동
- dispatch/도 버전별 트리로 분리 (선택사항, 운영자 판단)
```

### 5.2 docs/bridge_protocol.md 신규 섹션

**권고 추가 위치:** Sec.4 "환경 / 도구 표준" 테이블에 행 추가

```markdown
| handoffs/dispatch 버전 연동 | `bridge-0XX` 세션과 `handoffs/active/HANDOFF_v0.X.md` 자동 매핑. Stage 13 완료 시 `ai_step.sh`가 active → archive 이동 + HANDOFF.md symlink 갱신. dispatch/는 버전별 트리 권고 (v0.6.5+) |
```

### 5.3 docs/context_loading.md Sec.3 갱신

**현재:** MD 분량 정책만 있음
**권고 추가:** "버전별 context 로드 자동화" 섹션

```markdown
### 3.4 버전별 context 선별 로드

- Stage 13 → 다음 버전 시작: R2 읽기 순서에서 handoffs/active/HANDOFF_v<신규>.md 로드
- 과거 버전 참조: handoffs/archive/ 에서 필요한 버전만 읽기
- dispatch 검색: dispatch/active/v<X>/ 또는 dispatch/archive/v<X>/ 우선 검색
```

---

## 6. 구현 순서 및 우선순위

| 우선순위 | Action | 담당 | 복잡도 | v0.6.5 |
|---------|--------|------|--------|--------|
| ⚠️ 높음 | v0.6.4 HANDOFF → archive | reviewer | 낮음 | Lite MVP |
| ⚠️ 높음 | HANDOFF.md symlink 갱신 | reviewer | 낮음 | Lite MVP |
| 🟡 중간 | dispatch/ 버전별 트리 재구성 | reviewer/finalizer | 높음 | Optional (Lite MVP 외) |
| 🟡 중간 | scripts/ 갱신 권고 | reviewer (의제 7과 통합) | 중간 | v0.6.6 Standard |
| 🟢 낮음 | docs 정합 (Sec.5.4 / bridge_protocol / context_loading) | finalizer | 낮음 | v0.6.6 |
| 🟢 낮음 | 브릿지 버전 연동 자동화 | — | 높음 | v0.6.7+ 미래 계획 |

---

## 7. 즉시 조치 권고 (Lite MVP v0.6.5)

**블로커:**
1. ⚠️ v0.6.4 HANDOFF가 active/에 남아있음 → archive로 이동 필수 (헌법)
2. ⚠️ HANDOFF.md symlink가 정확한지 재확인

**선택사항:**
3. dispatch/ 버전별 트리 = v0.6.6 Standard 영역으로 연기 가능
4. 스크립트 자동화 = v0.6.6에서 일괄 처리

---

**권고 plan 완료. reviewer는 1-2번 우선, 3-4번은 v0.6.6 계획에 추가.**
