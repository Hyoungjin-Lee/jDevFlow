"""M4 — Pending Push/Commit + Pending Q layer placeholder (F-D1 영역).

본 파일 본문은 v0.6.4 Stage 8 M4에서 작성:

- ``PendingPush`` / ``PendingQuestion`` dataclass (단일 spec — design_final Sec.3.2).
- ``PendingDataCollector`` (git status + dispatch md regex sync polling).
- ``PendingPushBox`` / ``PendingQBox`` textual 위젯.
- read-only 정책 영구 (F-X-2) — 본 layer는 표시 only, write 명령 0건.

상위 spec: design_final Sec.9 (M4 Pending + 알림 layer).
"""
