---
description: jOneFlow 운영자 대시보드 (textual TUI, read-only)
allowed-tools: Bash
---

# /dashboard

jOneFlow AI팀 18명 + PM 브릿지 1명 = 19명 실시간 상태 가시화. textual 기반 read-only TUI.

## 사용법

- `/dashboard` — 대시보드 시작 (`q` 키로 종료)

## 주의사항

- 본 명령어는 `venv/bin/python3 scripts/run_dashboard.py` 래퍼다. Python 인터프리터 / 스크립트 경로 변경 시 본 정의 동기 갱신 필요.
- Stage 10c — 기존 `scripts/dashboard.py`는 `scripts/dashboard/` 패키지와 이름 충돌 영역 회피로 `scripts/run_dashboard.py`로 이전됨.
- 사전에 `python3 -m pip install -r requirements.txt`로 textual 의존(>= 0.50.0)이 설치되어 있어야 한다.
- 본 도구는 read-only — git push / git commit / 파일 write 0건 (F-X-2 영구 정책, AC-M1-9 자동 검증).
- Stage 10b 정합 — M2~M5 wiring 통합 후 본문 표시 (DashboardRenderer + PendingArea, 19명 박스 + 진행률 바 + 스파크라인 + Pending Push/Q 박스).

## 내부 매핑

```bash
exec venv/bin/python3 scripts/run_dashboard.py
```
