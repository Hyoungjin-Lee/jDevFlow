---
description: jOneFlow 운영자 대시보드 (textual TUI, read-only)
allowed-tools: Bash
---

# /dashboard

jOneFlow AI팀 18명 + PM 브릿지 1명 = 19명 실시간 상태 가시화. textual 기반 read-only TUI.

## 사용법

- `/dashboard` — 대시보드 시작 (`q` 키로 종료)

## 주의사항

- 본 명령어는 `venv/bin/python3 scripts/dashboard.py` 래퍼다. Python 인터프리터 / 스크립트 경로 변경 시 본 정의 동기 갱신 필요.
- 사전에 `python3 -m pip install -r requirements.txt`로 textual 의존(>= 0.50.0)이 설치되어 있어야 한다.
- 본 도구는 read-only — git push / git commit / 파일 write 0건 (F-X-2 영구 정책, AC-M1-9 자동 검증).
- M1 scaffold 단계에서는 placeholder 위젯만 표시되며, 데이터 수집(M2) / 렌더링(M3) / Pending+알림(M4) / 18명 매핑(M5) 본문은 후속 마일스톤에서 채워진다.

## 내부 매핑

```bash
exec venv/bin/python3 scripts/dashboard.py
```
