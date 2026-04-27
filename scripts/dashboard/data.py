"""M2 — 데이터 수집 layer placeholder (F-D1 PersonaState 단일 spec 영역).

본 파일 본문은 v0.6.4 Stage 8 M2에서 작성:

- ``PersonaState`` dataclass (단일 spec — design_final Sec.3.1).
- ``PersonaDataCollector`` (페르소나 sync polling, fetch_all_personas / persona_by_name).
- tmux capture-pane / 토큰량 정확 hook (Q2 +8h) 인입 — drafter 자율 영역에서 서브모듈
  분리 가능 (예: ``tmux_adapter.py`` / ``token_hook.py``, design_final Sec.2.1 트리 참조).
- Q5 idle 통합 — tmux 세션 미존재 = idle (offline 분리 옵션 0건).

상위 spec: design_final Sec.3 (데이터 모델) + Sec.7 (M2 데이터 수집 layer).
"""
