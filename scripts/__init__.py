"""jOneFlow scripts 패키지 — Stage 10c 추가.

기존 ``scripts/dashboard.py`` ↔ ``scripts/dashboard/`` (패키지) 이름 충돌 해소 영역에서
``scripts/`` 자체를 명시 패키지로 박음. ``scripts/run_dashboard.py``의 절대 import
``from scripts.dashboard.X import Y`` 안전 동작 정합.
"""
