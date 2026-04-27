"""M2 — ``TokenHook`` placeholder (Q2 정확 hook + R-10 namespace prefix).

본 파일 본문은 v0.6.4 Stage 8 M2에서 작성 (design_final Sec.7.3 정합):

- ``TokenHook.read_session(session_id)`` — ``.claude/dashboard_state/joneflow_<hash>_<id>.json`` 인입.
- 폴백 = capture-pane regex (TmuxAdapter 위임 — subprocess 직접 import 0건).
- namespace prefix ``joneflow_<project_path_hash>_`` (R-10 정정 — F-62-4 글로벌 영역 침범 회피).
- 프로젝트 ``.claude/hooks/session-end.sh`` 인식 검증 = AC-S8-2 (Stage 8 이월).

상위 spec: design_final Sec.7.3 + Sec.11.2 Q2 흡수.
"""
