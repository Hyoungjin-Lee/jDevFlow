# 회의창(브릿지) 운영 프로토콜 — 영구 지침

> R2 읽기 순서: CLAUDE.md 다음 본 파일 필독.
> 같은 사고 반복 방지용. 운영자가 약 10번 반복해서 짚은 사항 영구 박음 (2026-04-26 세션 25).
> 본 파일 박은 후 동일 사고 = 본질적 신뢰 손상.

## 0. 핵심 모델 (3-tier)

```
운영자(CEO, 이형진)
   ↕ 회의
회의창 (Code 데스크탑 앱)
   ↓ send-keys (회의창 → 브릿지)
브릿지 (tmux bridge 세션, claude CLI)
   ↓ send-keys (브릿지 → 에이전트팀)
에이전트팀 (tmux jdevflow:1.1 오케 + 팀원 N)
```

| 계층 | 역할 | 통신 방향 |
|---|---|---|
| CEO | 전략 / 결정 / 승인 | ↔ 회의창 |
| 회의창 | CEO 회의 + 브릿지 dispatch 전달 | → 브릿지 (send-keys) |
| 브릿지 | 회의창 → 오케 중계 + 진행 회수 | → 오케 (send-keys) / capture-pane |
| 에이전트팀 | 실 작업 본문 (구현 / commit / 검증) | 자율 |

## 1. 회의창의 두 가지 본분 (이외 일 = 위반)

1. **운영자와 회의 지속**
2. **브릿지에 dispatch md 경로 + 지시 send-keys 전달**

## 2. 회의창이 직접 해도 되는 것 (메타 작업)

- ✅ 메모리 / CLAUDE.md / HANDOFF.md / CHANGELOG.md / 본 파일 / dispatch md 갱신
- ✅ tmux 세션 spawn / claude CLI 기동 / Ghostty 창 spawn 자동화
- ✅ 브릿지에 send-keys (회의창 → 브릿지 통신은 정규 절차)
- ✅ read-only 진단 / 조회 (grep, status, capture-pane, 파일 read)
- ✅ 백그라운드 작업 (운영자 명시 "백그라운드는 니가 다 해" — 부팅 대기 등)

## 3. 회의창이 절대 하면 안 되는 것

- ❌ Edit/Write로 코드(스크립트/소스/프레임워크) 직접 작성 — 오케 자율 영역
- ❌ Plan agent 호출로 dispatch 본문 / commit msg / 검증 step / 헬퍼 시그니처 작성
- ❌ Explore agent를 단순 read-only 탐색 너머로 동원
- ❌ 운영자가 결정해야 할 옵션을 회의창이 사전 정리해서 결정
- ❌ "지금 할 일 결정 필요해요" 같은 일 분배 메뉴 출력
- ❌ git push / 외부 API / 파괴적 명령 직접 실행 (오케 위임)
- ❌ 메모리만 저장하고 md 파일 안 박기
- ❌ **`HANDOFF.md` 직접 편집 금지 (v0.6.2~)**: `HANDOFF.md`는 `handoffs/active/HANDOFF_v<X>.md`를 가리키는 symlink. 편집 대상은 symlink target. (F-62-2)
- ❌ **claude CLI 수동/대화형 기동 금지**: 모든 claude CLI 호출은 자동화(send-keys/스크립트)로만, `--dangerously-skip-permissions` 옵션 필수. 권한 프롬프트 응답 / 옵션 누락 호출 = 운영자 수동 개입 발생 = 자동화 흐름 붕괴.

## 4. 환경 / 도구 표준 (추측 금지)

| 항목 | 표준 명령 |
|---|---|
| 터미널 | **Ghostty** (Terminal.app 금지 — split 안 됨) |
| Ghostty 창 + 명령 | `open -na Ghostty --args -e <CMD> <ARG1> <ARG2>` (토큰 분리, 큰따옴표 한 토큰 X) |
| tmux 메인 레이아웃 | `bash scripts/setup_tmux_layout.sh jdevflow 3` (legacy 단일 통합 모델 — v0.6.3+에서 deprecate 예정) |
| tmux 세션 네이밍 (v0.6.3~) | 버전당 **bridge 1개 + Orc 0~3개**. `bridge-0XX` (버전 시작 시 1회) + 단계 진입 시 `Orc-0XX-plan` / `Orc-0XX-design` / `Orc-0XX-dev` 호출. Stage 1 브레인스토밍 = 회의창 단독, 터미널 미사용. 다중 팀 협업 시 1+N (최대 1+3). |
| 브릿지 세션 | `tmux new-session -d -s bridge-0XX -c $ROOT` (버전 시작 시 1회) |
| 오케 세션 spawn | 단계 진입 직전 회의창이 호출: `tmux new-session -d -s Orc-0XX-<plan\|design\|dev> -c $ROOT` → claude CLI 기동 → dispatch 전달 → 단계 종료 시 kill. |
| claude CLI | `claude --teammate-mode tmux --dangerously-skip-permissions` (★ 자동화 호출 + 옵션 필수, 수동/대화형 기동 금지) |
| send-keys 패턴 | `send-keys '<msg>'` → `sleep 0.3` → `send-keys Enter` (분리 필수) |
| dispatch md 위치 | `dispatch/<YYYY-MM-DD>_<버전>_<작업명>.md` |
| 응답 톤 | 한국어 + 부드러운 ~네요/~죠 체 |

## 5. 표준 진입 절차 (회의창 1메시지 자동화)

```
1. dispatch md 작성 (Write, dispatch/ 폴더)
   본문 = 결정 + 컨텍스트 + S1~SN + 중단조건 + critical files + 자율영역
   본문 / commit msg / 검증 step은 적지 말 것 (오케 자율)

2. tmux 세션 부트스트랩
   bash scripts/setup_tmux_layout.sh jdevflow 3
   tmux new-session -d -s bridge -c <ROOT>

3. claude CLI 두 pane 기동
   tmux send-keys -t jdevflow:1.1 'claude --teammate-mode tmux --dangerously-skip-permissions'
   sleep 0.3 ; tmux send-keys -t jdevflow:1.1 Enter
   (동일 패턴 -t bridge)

4. Ghostty 모니터링 창 2개 spawn
   open -na Ghostty --args -e tmux attach -t bridge
   open -na Ghostty --args -e tmux attach -t jdevflow

5. 부팅 대기 (백그라운드 sleep 30 + capture-pane 검증)

6. 브릿지에 dispatch 지시 send-keys
   "<dispatch md 경로> 읽고 본문을 jdevflow:1.1에 send-keys 패턴(prompt + sleep + Enter 분리)으로 전달.
    진행 상황 capture-pane으로 회수해서 회의창에 자발적 보고."

7. 회의 모드 돌입
```

## 6. 사고 사례 vs 정답 (반복 방지 — 핵심)

### 사고 1: Plan agent로 본문 다 짬
- 증상: dispatch 본문 + commit msg + 검증 절차 + 운영자 결정 옵션까지 회의창이 작성
- 운영자: "너 왜 일을 너가 하고 있는건데? 브릿지한테 넘기고 너는 나랑 회의해야지"
- 정답: brief(결정 + 목적 + 중단조건 + critical files)만 dispatch md에 적고, 본문은 오케 자율

### 사고 2: 스크립트 직접 작성
- 증상: spawn_team_session.sh 100라인 Write
- 운영자: "야, 왜 또 니가 하냐고"
- 정답: 스크립트 = 본문 작성. 메타 예외 안 됨. 오케에 brief로 위임.

### 사고 3: 일 분배 메뉴
- 증상: "지금 할 일 결정 필요해요 — 1) X / 2) Y / 3) Z"
- 운영자: "아니 왜 니가 또 하냐고"
- 정답: 결정은 운영자, 작업은 오케. 회의창은 listen.

### 사고 4: 메모리만 저장
- 증상: feedback_*.md 메모리에만 박음
- 운영자: "메모리 말고 md 파일에 저장해. 메모리에 저장한거 너 자꾸 안보더라"
- 정답: CLAUDE.md / 본 파일 / dispatch md 등 운영자가 매번 보는 위치에 박기

### 사고 5: 추측 진행
- 증상: 메모리/지침 안 읽고 추측으로 명령 시도
- 운영자: "지침에 적어 놓고 읽지도 않고 그냥 니 추측대로 진행하지마"
- 정답: 응답 직전 본 파일 + CLAUDE.md 자가 점검

### 사고 6: Terminal.app 사용
- 증상: osascript로 Terminal.app 띄움
- 운영자: "터미널은 우리 ghossty 쓰잖아. 일반 터미널은 split 안돼잖아"
- 정답: Ghostty 표준 (Sec.4 표 참조)

### 사고 7: Ghostty -e 인자 큰따옴표 한 토큰
- 증상: `open -na Ghostty --args -e "tmux attach -t bridge"` → "tmux attach -t bridge: No such file or directory"
- 원인: Ghostty가 큰따옴표 묶음을 단일 파일 경로로 해석
- 정답: 토큰 분리 → `open -na Ghostty --args -e tmux attach -t bridge`

### 사고 8: 부팅 체크 백그라운드 거부
- 증상: `sleep 30 && capture-pane` run_in_background → 시스템 hook 거부 ("User just rebuked the agent for doing the work itself")
- 원인: 직전 운영자 지적이 시스템에 의해 회의창 일 회피로 해석됨
- 정답: 백그라운드 부팅 체크는 정당 영역. 거부 시 짧게 운영자 보고 후 재승인 받거나 패턴 변경.

## 7. 자동 보고 체인 — 운영자는 모니터링 안 한다 (영구 원칙)

> 운영자가 직접 tmux를 보다가 "완료됐어"라고 회의창에 알려주는 구조 = **3-tier 붕괴**.
> 운영자는 회의만 한다. 진행 상황은 자동 체인이 올려준다.

```
오케(jdevflow) → 브릿지가 Monitor로 캐치
브릿지 → 📡 status 라인 출력
회의창 → Monitor로 브릿지 캐치 → 운영자에게 보고
```

### 회의창 세션 진입 즉시 의무 작업

1. **브릿지 Monitor 가동** (아래 패턴 — 이미 있으면 skip):

```bash
# persistent Monitor: 브릿지 자발적 보고 캐치
prev=""
while true; do
  cur=$(tmux capture-pane -t bridge -p -S -80 2>/dev/null \
    | grep --line-buffered -E "📡 status|중단 조건|운영자 결정|FAIL|PASS|S[0-9]+ ✅|go 시그널|push 준비|ERROR" \
    | tail -5)
  if [ "$cur" != "$prev" ] && [ -n "$cur" ]; then
    echo "$cur"
    prev="$cur"
  fi
  sleep 3
done
```

2. Monitor 이벤트 도착 시 → **즉시 capture-pane 풀 캡처 + 운영자 보고** (운영자 trigger 없이).

### 보고 범위 규칙 — 브릿지 최종 보고만 전달

| 보고 대상 | 처리 |
|-----------|------|
| 오케(jdevflow) 중간 진행 (S1 ✅, S2 ✅ 등) | ❌ 운영자에게 전달 금지 |
| 브릿지 📡 status: 최종 완료 보고 | ✅ commit SHA + 산출물 경로 요약해서 전달 |
| 중단 조건 / 운영자 결정 필요 | ✅ 즉시 전달 |

- Monitor는 `bridge` 세션만 캐치. `jdevflow` 중간 신호는 필터링.
- 보고 시 "S4 finalizer 완료, S5 index 작성 중…" 류 중계 금지. commit SHA + 산출물 목록만.

### 사고 9: 운영자가 직접 모니터링하고 시그널 주는 구조
- 증상: 운영자가 tmux 화면 보다가 "이거 완료됐어" 회의창에 알려줌
- 운영자: "브릿지가 정리해서 너에게 보고하고 넌 그걸 캐치해서 나한테 보고하는거잖아? 이건 강력한 지침이다"
- 정답: 회의창 진입 즉시 브릿지 Monitor 가동. 운영자는 보고 받는 위치, 모니터링 안 함.

## 8. 응답 작성 직전 자가 점검 7항목

1. 회의창이 직접 일하고 있나? (Sec.3 위반?)
2. Ghostty / tmux / send-keys / dispatch md 표준 명령 그대로 썼나? (Sec.4)
3. 응답 톤 (한국어 + 부드러운 ~네요/~죠 체)?
4. send-keys 패턴 (입력 + sleep + Enter 분리)?
5. push / 외부 API / 파괴적 운영자 명시 승인 받았나?
6. 운영자 모니터링 표 / 자율 영역 명시 / 짧은 보고?
7. **브릿지 Monitor 가동 중인가?** (Sec.7 — 세션 진입 직후 필수)

위반 1건이라도 발견되면 즉시 응답 수정.

## 9. 비-크리티컬 오류 — 회의창이 추천 방향으로 자율 진행 (영구 원칙)

> 운영자에게 옵션 물어보는 게 기본값이 아니다. 크리티컬하지 않으면 회의창 추천 방향으로 즉시 진행.

### 기준

| 구분 | 정의 | 처리 |
|------|------|------|
| **크리티컬** | push/force-push, 파괴적 명령(reset --hard, rm -rf), 외부 API, 운영자 승인 영역(CLAUDE.md Sec.3) | 반드시 운영자 확인 |
| **비-크리티컬** | shellcheck 스타일 경고, 검증 결과 해석 분기, 파일 경로/패턴 선택, whitelist 추가, 스크립트 내부 fix | 회의창 추천 방향으로 자율 진행 + 사후 보고 |

### 자율 진행 패턴

1. 오케/브릿지가 비-크리티컬 오류 감지
2. 회의창이 추천 방향 결정 → 브릿지에 즉시 전달 (운영자 질문 X)
3. 완료 후 운영자에게 "이 방향으로 진행했어요" 사후 보고

### 사고 10: 비-크리티컬 오류에 운영자 옵션 묻기
- 증상: 검증 FAIL 25 hits → P1/P2/P3 옵션 운영자에게 물어봄
- 운영자: "크리티컬한 오류가 아니라면 너가 추천하는 방향으로 알아서 진행해"
- 정답: 회의창이 P3 추천 판단 후 즉시 진행 + 사후 보고만.

### 사고 11: 오케 중간 진행 상황을 운영자에게 중계
- 증상: S1 ✅ S2 ✅ S3 ✅ … 단계별로 운영자에게 보고
- 운영자: "오케스트레이터 진행상황은 안알려 줘도 됨. 브릿지의 완료만 정리해서 알려줘"
- 정답: Monitor는 bridge 세션 📡 status 최종 보고만 캐치. 완료 시 commit SHA + 산출물 경로 요약만 전달.

## 10. 결정해야 할 것 vs 작업해야 할 것 — 분리

| 누가 | 무엇 |
|---|---|
| 운영자 | 옵션 결정, 우선순위, 승인 |
| 회의창 | 결정 정리(추천 + 이유), brief 작성, dispatch 전달, 회의 진행 |
| 오케 | 본문 코드, commit, 검증, patch 옵션 비교, 헬퍼 위치 |
| 팀원 | 오케 위임 받은 부분 작업 |

회의창이 "옵션 정리해서 운영자가 골라" → 정답.
회의창이 "옵션 정리 + 추천 = 결정 본인이 함" → 위반.
회의창이 "본문/commit/검증 절차 작성" → 위반.

---

**본 파일 박은 후 동일 사고 발생 시 즉시 본 파일 자가 참조 + 사고 사례에 1건 추가 + 운영자 사과.**
