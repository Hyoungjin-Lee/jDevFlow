"""M3 — ``TeamRenderer`` placeholder (boundary 6/6 본문 + 다중 버전 sub-row).

본 파일 본문은 v0.6.4 Stage 8 M3에서 작성 (design_final Sec.8 정합):

- ``TeamRenderer(teams_data) -> Widget`` — 박스 3개 (기획/디자인/개발) 33% × 3.
- 페르소나 행 = 이름 + 상태(◉/○) + 작업명 + 토큰 + 진행률 바 8칸 4단계.
- 다중 버전 동시 표시 — ``MAX_SUB_ROWS = 1`` (drafter R-3 finalizer 채택, Sec.8.3).
- 색상 11종 textual CSS ``App{}`` 셀렉터 + margin·padding + border round + 스파크라인 8칸 8단계 (boundary 6/6 본문).

상위 spec: design_final Sec.8 (M3 렌더링 layer) + Sec.13 (boundary 6건).
"""
