# 🤖 Claude 운영 지침

> ⛔ **MANDATORY STARTUP RULE — 세션 진입 즉시 필수**
> 1. 이 파일(CLAUDE.md)을 실제로 읽어라. 읽은 척 금지.
> 2. `docs/bridge_protocol.md`와 `docs/operating_manual.md`를 실제로 읽어라.
> 3. 세 파일 읽기 완료 전 어떤 작업도 하지 마라.
> 4. 읽지 못하면 "읽지 못했습니다"라고 명시하고 멈춰라.
> 5. 이 세션에서 실제로 읽지 않았으면 "지침을 따랐다"고 절대 말하지 마라.

> **새 세션 읽기 순서 (R2):** CLAUDE.md → **`docs/bridge_protocol.md`** (회의창 영구 지침) → **`docs/operating_manual.md`** (운영 매뉴얼 본체) → `handoffs/active/HANDOFF_v<X>.md` (현재 진행 상태).
> Skill hook: `.skills/tool-picker/SKILL.md` — jOneFlow stage/mode/risk_level 판단용.
> `HANDOFF.md`는 v0.6.2부터 **symlink** (직접 편집 금지, 편집 대상은 symlink target [F-62-2]).

> 🔴 **세션 역할 확인 (Code 세션 필수):** 나는 **브릿지**다. Cowork(CEO 이형진)에서 도출된 명령을 CLI 오케스트레이터(tmux)로 전달하는 역할. 직접 구현 금지. tmux 세션 없으면 `bash scripts/setup_tmux_layout.sh joneflow` 먼저 실행. 예외: 운영자가 간단히/급하게 확인 요청하는 경우만 직접 처리 허용.

---

## 1. 프로젝트 한 줄 요약

**jOneFlow** — AI 팀 운영을 위한 워크플로우 프레임워크. Python 환경 `venv/bin/python3`, 메인 스크립트 `scripts/`. 새 프로젝트 시작 시 본 섹션 갱신.

---

## 2. 도구 역할 / 조직도 / 워크플로우 / 모델 정책

운영 매뉴얼 본체 = **`docs/operating_manual.md`** (≤ 1000줄, 6개 섹션).

| 위치 | 내용 |
|------|------|
| `docs/operating_manual.md#1-조직도` | 5계층 18명 + 모델/effort 배정 |
| `docs/operating_manual.md` Sec.2 | 워크플로우 모드(Lite/Standard/Strict) + 자율/승인 게이트 |
| `docs/operating_manual.md` Sec.3 | Stage별 권장 모델 (Sonnet/Opus/Haiku) |
| `docs/operating_manual.md` Sec.4 | 페르소나별 톤 + 회의창 본분 |
| `docs/operating_manual.md` Sec.5 | Stage 1~13 플로우 + 모드별 압축 + handoffs/ 구조 |
| `WORKFLOW.md` Sec.6 | Stage Transition Score (임계값 80%) |

핵심 운영 원칙 (인라인 필수):
- 실행자 결정 = **`.claude/settings.json` `stage_assignments`** (team_mode 리터럴 실행 분기 금지 [F-2-a]).
- 오케스트레이터 호출 방식은 자율. 운영자 override("서브에이전트로" / "팀모드로" / "Codex로") 시 세션 단위 적용.
- 글로벌 `~/.claude/CLAUDE.md` 영역은 v0.6.2 scope 외 (v0.6.3 이월 [F-62-4]).

---

## 3. 절대 규칙 (보안 — 인라인 필수)

```
❌ API키·계좌번호·토큰을 코드/로그에 평문 노출 금지
❌ 실제 인증정보를 .env 또는 .env.example에 저장 금지 (둘 다 "키 목록"용)
✅ 모든 스크립트는 secret_loader.py로 OS 키체인에서 로드
✅ 변경 전 반드시 --dry-run으로 확인
✅ 파일 생성/수정 후 python3 -m py_compile로 문법 검사
```

```python
from security.secret_loader import load_secret
api_key = load_secret("MY_API_KEY")   # OS 키체인에서 로드
```

- `.env.example` (커밋, 키 목록만) / `.env` (커밋 금지, 로컬 옵션). **OS 키체인 = 실제 시크릿 저장소** (`secret_loader.py`로 접근).

---

## 4. 스크립트 / 핵심 파일

```bash
sh scripts/git_checkpoint.sh "msg" file...  # Git 체크포인트 (push 미포함)
bash scripts/init_project.sh                # 신규 프로젝트 scaffold
bash scripts/ai_step.sh --auto              # Stage 자동 진행 (approval gate paused)
```

| 파일 | 역할 |
|------|------|
| `docs/operating_manual.md` | 운영 매뉴얼 본체 (이식 가능, ≤ 1000줄) |
| `docs/bridge_protocol.md` | 회의창 영구 지침 (사고 사례) |
| `security/secret_loader.py` | OS 키체인 인증정보 로더 |
| `.claude/settings.json` | stage_assignments (schema v0.4) |
| `handoffs/active/HANDOFF_v<X>.md` | HANDOFF.md symlink target |

코드 검증 / Stage 1~13 상세는 `docs/operating_manual.md` 참조.
