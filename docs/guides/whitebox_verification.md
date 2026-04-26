# Whitebox 검증 시나리오 — 백지 Claude로 jOneFlow 진입

> **목적:** 새 프로젝트가 jOneFlow를 가져갔을 때, 메모리 0인 Claude 세션이 프레임워크 파일만 읽고 운영을 즉시 시작할 수 있는지 검증.
> **상위:** `docs/02_planning_v0.6.2/planning_05_selfedu.md` AC-Edu-4 (자동 4a + 수동 4b).
> **연관:** `docs/operating_manual.md` Sec.6 MANDATORY STARTUP RULE.

---

## 1. 자동 검증 (AC-Edu-4a)

본 파일 존재 자체가 자동 측정 통과 신호.

```bash
ls docs/guides/whitebox_verification.md  # exit 0
```

---

## 2. 수동 검증 시나리오 (AC-Edu-4b, Stage 12 QA)

### 2.1 사전 조건

- 새로운 임시 디렉토리에 jOneFlow를 clone (또는 `init_project.sh`로 신규 프로젝트 scaffold + `JONEFLOW_SRC_ROOT` 환경변수로 source 지정).
- 결과 디렉토리에 다음 파일이 존재:
  - `CLAUDE.md` (≤ 80줄)
  - `docs/bridge_protocol.md`
  - `docs/operating_manual.md`
  - `handoffs/active/HANDOFF_v<X>.md` (또는 symlink target)

### 2.2 검증 절차

1. **백지 Claude 세션 시작.** 메모리 영역(`/Users/<user>/.claude/projects/.../memory/`)을 비우거나 신규 프로젝트 경로로 시작.
2. **R2 진입 순서대로 4개 파일을 실제로 읽도록 지시.** 다음 프롬프트 1회만 입력:

   ```
   이 프로젝트는 jOneFlow 프레임워크 기반이다.
   CLAUDE.md → docs/bridge_protocol.md → docs/operating_manual.md → HANDOFF.md
   순서로 읽고, 어떤 역할(브릿지/오케스트레이터)이고 다음 stage가 무엇인지 보고하라.
   ```

3. **검증 항목:**
   - [ ] Claude가 4개 파일을 모두 읽었는가? (Read tool 4회 이상 호출)
   - [ ] 자기 역할을 정확히 식별했는가? ("브릿지" 또는 "오케스트레이터" 명시)
   - [ ] 다음 stage를 정확히 보고했는가? (HANDOFF Status 기반)
   - [ ] 5계층 조직도 존재를 인지했는가?
   - [ ] 워크플로우 모드(Lite/Standard/Strict) 정의를 인지했는가?
   - [ ] MANDATORY STARTUP RULE이 적용됨을 인지했는가?

4. **PASS 기준:** 위 6개 체크 모두 ✅. 1건이라도 ❌이면 NEEDS_REWORK — operating_manual.md 또는 CLAUDE.md 보강.

### 2.3 dispatch 1회 발행 시뮬레이션

위 검증 통과 후, 추가 시나리오:

```
지금부터 v0.X.0 Stage 1 브레인스토밍을 시작한다고 가정하라.
회의창(브릿지) 또는 오케스트레이터 역할로서 첫 번째 dispatch 1건을 발행하라.
형식은 dispatch/YYYY-MM-DD_v0.X.0_<topic>.md 표준 따라.
```

- [ ] dispatch md 1건 작성 (운영자 결정 영역 분리, 자율 영역 명시, 비허용 명시).
- [ ] CLAUDE.md / bridge_protocol.md 정책을 위반하지 않음 (직접 구현 금지, paste 강제 금지 등).

---

## 3. 검증 통과 후 동작

- 신규 프로젝트 사용자: jOneFlow 운영 즉시 시작 가능.
- 운영자: `docs/operating_manual.md`만 갱신하면 새 프로젝트도 즉시 새 정책 반영.
- v0.6.3 이후: 글로벌 `~/.claude/CLAUDE.md` 영역 통합 검토 (Q1 운영자 결정 게이트).

---

## 4. 변경 이력

| 날짜 | 개정 | 비고 |
|------|------|------|
| 2026-04-26 | v0.6.2 M-SelfEdu | 신규 작성 (AC-Edu-4a 자동 측정 + AC-Edu-4b QA 시나리오). |
