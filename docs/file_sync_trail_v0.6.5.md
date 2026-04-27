# v0.6.5 파일 정합 권고 Trail — Round 2 drafter 검토

> **목적:** v0.6.4 4건 commit + v0.6.5 인사 변경 + 16-stage 채택 후, 하위 폴더 파일 일괄 정합 필요 영역 식별.
> **권고 대상:** reviewer(최우영) — drafter는 권고만, 실제 수정은 reviewer 영역.
> **검토 기준:** 16-stage 매트릭스 + 인사 변경 (박지영/이종선/이희윤) + F-62-9 (--dangerously-skip-permissions).

---

## 1. scripts/*.sh 검토 (Stage 자동화 스크립트)

### 1.1 ai_step.sh (Stage 자동 진행)

**현재 상태:** v0.6.4 기준 (13-stage)
**확인 항목:**
- [ ] `stage_assignments` 참조 부분 = 13-stage (`stage8_impl` / `stage9_review` / `stage10_fix` / `stage11_verify`)
- [ ] v0.6.5 16-stage 마이그레이션 필요 여부 **= 검토 보류** (settings.json schema v0.5 변경이 v0.6.6이므로)
- [ ] 페르소나 매핑 (이종선/우상호/공기성/박지영) 최신화 여부

**권고 사항:**
- 현재 유지 (13-stage 호환성 보존)
- v0.6.6 Standard에서 일괄 정밀화

**라인 수정 후보:**
- 없음 (호환성 유지 정책)

---

### 1.2 spawn_team.sh (오케 세션 spawn)

**현재 상태:** v0.6.3 Lite MVP 스켈레톤
**확인 항목:**
- [ ] tmux split panes 구현 = 미구현 (setup_tmux_layout.sh와 분리)
- [ ] 페르소나 설정 (@persona) = 미구현
- [ ] A 패턴 강제 (drafter → reviewer → finalizer) = 초안만 있음
- [ ] --dangerously-skip-permissions 옵션 = 확인 필요

**권고 사항:**
- start_claude_team.sh + setup_tmux_layout.sh 통합 검토 (의제 3에서 별도 처리 예정)
- bridge_protocol.md Sec.4 "Orc-XXX split panes 필수" 준수 강화

**라인 수정 후보:**
- split panes 로직 추가 (10~20줄)
- @persona 설정 명시화 (5~10줄)

---

### 1.3 start_claude_team.sh (Claude CLI 기동)

**현재 상태:** v0.6.5에서 신규 추가
**확인 항목:**
- [ ] `--teammate-mode tmux --dangerously-skip-permissions` 옵션 박음 = ✅ 있음
- [ ] 16-stage 매트릭스 참조 = 없음 (settings.json과 분리)
- [ ] 페르소나 역할 매핑 = 없음

**권고 사항:**
- 현재 상태 유지 (launcher 용도, 매핑은 dispatch에서)

---

### 1.4 heartbeat_daemon.sh (정체 감지)

**현재 상태:** v0.6.4 JSONL 기반 전환
**확인 항목:**
- [ ] capture-pane 제거 = ✅ 확인됨 (commit 2a9938a)
- [ ] JSONL tail 폴링 = ✅ monitor_bridge_jsonl.py로 전환
- [ ] 완료 시그널 통합 = ❌ 미구현 (의제 3 범위)

**권고 사항:**
- 정체 감지만 유지 (완료 신호는 completion_signal.sh로 분리)
- v0.6.6에서 Stop hook과 통합

---

### 1.5 hook_stop.sh / hook_post_tool_use.sh

**현재 상태:**
- hook_stop.sh = 토큰 누적 기록 (dashboard용)
- hook_post_tool_use.sh = Write/Edit 후 문법 검사

**확인 항목:**
- [ ] 완료 시그널 저장 = ❌ 미구현 (의제 3)
- [ ] 정형 포맷 = ❌ 미정의

**권고 사항:**
- hook_stop.sh에서 completion_signal.sh 호출 추가 (5~10줄)
- 또는 .claude/settings.json hooks에 completion_signal.sh 신규 등록

---

## 2. .claude/settings.json 검토

### 2.1 stage_assignments 매핑

**현재 상태:**
```json
"stage_assignments": {
  "stage8_impl": "claude",
  "stage9_review": "codex",
  "stage10_fix": "claude",
  "stage11_verify": "claude"
}
```

**v0.6.5 16-stage 매핑:**
- Stage 11 = `stage11_impl` (코드 구현)
- Stage 12 = `stage12_review` (코드 리뷰, Codex 고정)
- Stage 13 = `stage13_fix` (코드 수정)
- Stage 14 = `stage14_verify` (검증, Codex 고정)

**권고 사항:**
- ✅ 현재 유지 (v0.6.5 Lite MVP는 13-stage 호환성 보존)
- ✅ v0.6.6 Standard에서 schema v0.5로 마이그레이션
- 📝 comment 추가: "v0.6.5 schema v0.4 유지 — 16-stage 매핑은 운영 문서 참조"

---

### 2.2 hooks 영역

**현재 상태:**
```json
"hooks": {
  "PostToolUse": [ ... ],
  "Stop": [ ... ]
}
```

**권고 추가:**
- `Stop` hook에 `completion_signal.sh` 호출 추가
- 또는 신규 hook event "Completion" 정의 (v0.6.6)

**라인 수정:**
```json
"Stop": [
  {
    "matcher": "",
    "hooks": [
      {"type": "command", "command": "scripts/hook_stop.sh"},
      {"type": "command", "command": "scripts/completion_signal.sh"}
    ]
  }
]
```

---

## 3. dispatch/*.md 검토

### 3.1 브레인스토밍 dispatch (Stage 01~02)

**대상:** dispatch/2026-04-27_v0.6.5_lite_mvp.md 등
**확인 항목:**
- [ ] 16-stage 매트릭스 참조 = dispatch에서는 "의제 1~8" 수준
- [ ] Orc split panes 명시 = ✅ 박혀있음
- [ ] A 패턴 강제 (drafter/reviewer/finalizer) = ✅ 박혀있음

**권고 사항:**
- 현재 상태 유지 (dispatch는 brief만)

---

### 3.2 Stage별 dispatch 산출물 (Stage 03~07)

**대상:** 향후 생성될 planning/design/technical_design dispatch
**권고 항목:**
- Stage 03 plan_draft 파일명 = `docs/02_planning_v<X>/plan_draft.md`
- Stage 04 plan_review = `docs/02_planning_v<X>/plan_review.md`
- Stage 05 plan_final = `docs/02_planning_v<X>/planning_index.md`
- Stage 07 technical_design = `docs/03_design/v<X>_technical_design.md`

**라인 수정:**
- 없음 (dispatch 본문은 드래프터가 자율 작성)

---

## 4. .skills/tool-picker/SKILL.md 검토

**현재 상태:** 16-stage 채택 여부 미확인
**확인 항목:**
- [ ] "16-stage 워크플로 기준 stage/mode/risk_level 판단" = ❓ 확인 필요
- [ ] v0.6.4 13-stage 문서 참조 여부 = ❓ 확인 필요

**권고 사항:**
- SKILL.md 상세 읽기 필요 (현재 범위 외)
- v0.6.6에서 일괄 정밀화

---

## 5. 정합 우선순위 (reviewer 체크리스트)

| 우선순위 | 파일 | 영역 | 예상 수정 | 복잡도 |
|---------|------|------|---------|--------|
| ⚠️ 높음 | .claude/settings.json | hooks Stop 영역 | completion_signal.sh 호출 추가 | 낮음 |
| 🟡 중간 | spawn_team.sh | split panes 로직 | tmux split 일관성 검토 | 중간 |
| 🟢 낮음 | ai_step.sh | 호환성 | 현재 유지 (v0.6.6 마이그레이션 대기) | 없음 |
| 🟢 낮음 | scripts/*.sh 외 | 일반 검토 | F-62-9 옵션 재확인 | 낮음 |

---

## 6. v0.6.4 4건 commit 영향도

| Commit | 파일 | 영향 | 정합 필요 여부 |
|--------|------|------|--------|
| 8c3f56b | JSONL 기반 상태 감지 | persona_collector / token_hook | ✅ 정합됨 (v0.6.4) |
| 3881b22 | 브릿지/정체 감지 | tmux_adapter / monitor_bridge | ✅ 정합됨 (v0.6.4) |
| 2a9938a | capture-pane 삭제 | tmux_adapter 메서드 | ✅ 정합됨 (v0.6.4) |
| fb46069 | dispatch 문서 추가 | dispatch/ Stage 2~9 | ⚠️ 16-stage 매핑 추가 필요 |

---

## 7. 다음 라운드 (v0.6.6 Standard)

본 Round 2 정합 후, v0.6.6에서:
- [ ] .claude/settings.json schema v0.5 마이그레이션 (13-stage → 16-stage)
- [ ] spawn_team.sh + setup_tmux_layout.sh 통합
- [ ] .skills/tool-picker/SKILL.md 16-stage 정밀화
- [ ] dispatch/*.md 16-stage 매핑 일괄 전환

---

**정합 trail 작성 완료. reviewer(최우영)는 위 권고를 검토 후 필요 파일 수정.**
