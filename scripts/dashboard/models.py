"""F-D1 — dataclass 3종 단일 spec placeholder (design_final Sec.3.1 / Sec.2.2 정합).

본 파일 본문은 v0.6.4 Stage 8 M2/M4 횡단 영역에서 작성:

- ``PersonaState`` (6필드 dataclass — name/team/status/task/tokens/last_update,
  ``frozen=False`` + ``eq=True``, design_final Sec.3.1 verbatim).
- ``PendingPush`` (6필드 dataclass — design_final Sec.3.2).
- ``PendingQuestion`` (6필드 dataclass + ``dedupe_key()`` 5분 단위 truncate, R-4 정정).
- 직렬화 = ``dataclasses.asdict()`` 기준.
- idle 폴백 시 ``last_update`` 보존 (R-1 정정 — 이전 값 유지).

상위 spec: design_final Sec.3 (데이터 모델).
"""
