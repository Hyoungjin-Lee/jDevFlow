"""M3 — 렌더링 layer placeholder (boundary 6건 본문 흡수 영역).

본 파일 본문은 v0.6.4 Stage 8 M3에서 작성:

- ``TeamRenderer(teams_data) -> Widget`` — 박스 3개 (기획 / 디자인 / 개발).
- 페르소나 행 = 이름 + 상태(◉/○) + 작업명 + 토큰 + 진행률 바.
- 다중 버전 동시 표시 (sub-row ``└``).
- textual CSS ``App{}`` 셀렉터 + 색상 11종 + margin·padding + border round + 진행률 바
  8칸 4단계 + 스파크라인 8칸 8단계 + placeholder 3종 (boundary 6/6 본문, design_final Sec.13).

상위 spec: design_final Sec.8 (M3 렌더링 layer).
"""
