"""M2 — ``PersonaDataCollector`` placeholder (F-D1 / F-D4 sync polling).

본 파일 본문은 v0.6.4 Stage 8 M2에서 작성 (design_final Sec.7 정합):

- ``PersonaDataCollector.fetch_all_personas()`` — sync 폴링, 18명 전수 yield.
- ``persona_by_name(name)`` — sync 단일 조회.
- ``_infer_state(pane_state)`` — Q5 idle 통합 (tmux 미존재 = idle).
- 작업명 추론 우선순위 = A-1 prompt > A-3 로그 > A-2 last_known_task (drafter R-2 정정).
- idle 폴백 ``last_update`` 보존 (R-1 정정 — staleness ⚠ 표시 정합).

상위 spec: design_final Sec.7 (M2 데이터 수집 layer).
"""
