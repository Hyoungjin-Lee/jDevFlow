# 브릿지 디스패치 템플릿

> Cowork(지훈) → Code(브릿지) 명령 전달 시 사용하는 표준 프롬프트.
> 이 템플릿을 Code 세션에 붙여넣어 사용.

---

## 사용법

아래 블록을 Code 세션에 붙여넣고 `[내용]` 부분만 채워서 전달.

---

```
너는 브릿지다. Cowork에서 도출된 아래 명령을 CLI 오케스트레이터(tmux joneflow)로 전달해줘.
직접 구현하지 말고, tmux 세션에 지시만 내릴 것.
tmux 세션 없으면 먼저 `bash scripts/setup_tmux_layout.sh joneflow` 실행.

---
[Cowork에서 도출된 명령/지시 내용]
---

완료 후 결과를 Cowork로 보고해줘.
```

---

## 예시

```
너는 브릿지다. Cowork에서 도출된 아래 명령을 CLI 오케스트레이터(tmux joneflow)로 전달해줘.
직접 구현하지 말고, tmux 세션에 지시만 내릴 것.
tmux 세션 없으면 먼저 `bash scripts/setup_tmux_layout.sh joneflow` 실행.

---
M3 구현 시작. switch_team.sh + docs/guides/switching.md 작성.
Stage 8 → Stage 9 순환. settings.json stage_assignments 참조.
---

완료 후 결과를 Cowork로 보고해줘.
```

---

## 예외 (브릿지 직접 처리 허용)

- 운영자가 간단히 또는 급하게 확인 요청하는 경우
- 예: "지금 git status 확인해줘", "settings.json 내용 빠르게 보여줘"
