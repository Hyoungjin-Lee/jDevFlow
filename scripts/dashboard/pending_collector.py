"""M4 — ``PendingDataCollector`` placeholder (F-D1 / Pending Push·Q sync polling).

본 파일 본문은 v0.6.4 Stage 8 M4에서 작성 (design_final Sec.9 정합):

- ``PendingDataCollector.get_pending_pushes()`` — git status sync 추출.
- ``get_pending_questions()`` — dispatch md ``Q_PATTERN`` regex sync 추출.
- read-only 정책 영구 (F-X-2) — write 명령 0건 (AC-M1-9 자동 검증).
- tmux capture-pane 폴백 옵션 회수 (Sec.12 이월 #8 정합).

상위 spec: design_final Sec.9 (M4 Pending + 알림 layer).
"""
