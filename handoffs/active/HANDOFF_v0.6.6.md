---
version: v0.6.6
status: brainstorm
mode: Standard
date: 2026-04-27
prev_version: v0.6.5 (released-lite, tag 박힘)
next_session_recommended_model: Opus (Stage 02 선별부터)
---

# v0.6.6 HANDOFF — Standard 인프라 정밀화

## ⚠️ 작업 디렉토리

```
ROOT = /Users/geenya/projects/Jonelab_Platform/jOneFlow
```

## v0.6.6 의제 (v0.6.5 이월 6건)

| # | 의제 | 사전 승인 |
|---|------|---------|
| 1 | R3 디렉터리 실제 변경 (handoffs/dispatch active/archive 트리 재구성 + 파일 git mv) | ✅ |
| 2 | hook_stop.sh → completion_signal.sh 실제 연결 (settings.json Stop hook) | — |
| ~~3~~ | ~~pptx skill 구현 (.skills/pptx-storyboard/SKILL.md)~~ | 🔜 v0.6.7 이관 |
| 4 | settings.json schema v0.5 (16-stage stage_assignments 키 정합) | — |
| 5 | spawn_team.sh split panes 로직 보강 | — |
| 6 | A 패턴 drafter/reviewer 분리 강제 메커니즘 | — |

## Stage 01+02 브레인스토밍 완료 (2026-04-27, 운영자 결정)

- **모드:** Standard (이 버전 자체가 Standard 모드 첫 실전 테스트)
- **의제:** 5건 확정 (#1~2, #4~6) / pptx skill = v0.6.7 이관
- **Stage 03~06 기획 압축:** 의제 모두 다세션 논의로 확정 — 별도 기획 docs 생략, dispatch brief로 대체
- **병렬 구도:** #1+#2+#6 동시 / #4 완료 후 #5
- **git push:** v0.6.4 릴리스 완료 후 v0.6.4+v0.6.5 묶어서 처리

## 이월 항목

- v0.6.4 릴리스 완료 후 git push (v0.6.4 + v0.6.5 태그 묶음)
