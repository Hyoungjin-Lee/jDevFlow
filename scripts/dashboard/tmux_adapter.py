"""tmux capture-pane 추출 layer placeholder (M2 / M4 횡단, AC-T-4 subprocess 격리 #1).

본 파일 본문은 v0.6.4 Stage 8 M2/M4에서 작성 (design_final Sec.2.2 / Sec.7.1 정합):

- ``TmuxAdapter.list_sessions()`` — ``tmux ls`` sync 호출 + 세션명 파싱.
- ``capture_pane(session, pane)`` — ``tmux capture-pane -p`` sync 호출 + 본문 회수.
- ``subprocess.run(timeout=N)`` 영구 (Sec.16.1 보안 정책 — AC-T-5 자동 검증).
- token_hook이 본 어댑터 위임으로 ``subprocess`` 직접 import 0건 (R-5 정정 = AC-T-4 = 2).

상위 spec: design_final Sec.2.2 / Sec.7.1.
"""
