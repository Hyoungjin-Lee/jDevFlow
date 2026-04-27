"""Q1 / F-D3 — ``PMStatusBar`` placeholder (status bar 1행 + 다중 bridge 통합 인입).

본 파일 본문은 v0.6.4 Stage 8 M5에서 작성 (design_final Sec.10.3 정합):

- ``PMStatusBar`` (Header 확장) — PM 스티브 리 1명 status bar 1행.
- ``_fetch_pm_state()`` — ``tmux ls`` 모든 ``bridge-*`` 패턴 통합 인입.
- 다중 bridge 동시 시 ``bridge-063 / bridge-064 / ...`` 통합 표기 (R-8 옵션 1 채택).
- 박스 3개 18명 + status bar 1행 PM = 19명 표시 (CTO·CEO 미표시, F-D3 final).

상위 spec: design_final Sec.10.3 + Sec.11.1 Q1 흡수.
"""
