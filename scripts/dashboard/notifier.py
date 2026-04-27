"""M4 — 알림 layer placeholder (Q3 osascript 기본·Pushover 회피).

본 파일 본문은 v0.6.4 Stage 8 M4에서 작성:

- ``Notifier`` ABC + ``OSAScriptNotifier`` (Q3 운영자 결정 — macOS osascript 기본).
- ``WindowsNotifier`` stub (Q4 P1 skeleton, M5에서 plyer / win10toast 통합).
- dedupe ``dict + 5분 TTL`` 패턴 (R-11 Critical 정정 — drafter v1 ``lru_cache`` 회수).
- ``PendingQuestion.dedupe_key()``는 timestamp 5분 단위 truncate (R-4 정정).

상위 spec: design_final Sec.9.3 (Notifier + dedupe).
"""
