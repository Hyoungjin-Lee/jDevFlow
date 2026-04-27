"""M4 — ``PendingPushBox`` / ``PendingQBox`` 위젯 placeholder.

본 파일 본문은 v0.6.4 Stage 8 M4에서 작성 (design_final Sec.9.2 정합):

- ``PendingPushBox`` — git push 대기 commit 박스 (read-only, F-X-2).
- ``PendingQBox`` — 운영자 결정 대기 Q 박스 (dispatch md ``Q_PATTERN`` 인입).
- staleness ⚠ 표시 (R-1 정정 — last_update > 2초 → ⚠).
- 다중 버전 동시 표시 sub-row ``└`` prefix.

상위 spec: design_final Sec.9.2 (PendingPushBox / PendingQBox).
"""
