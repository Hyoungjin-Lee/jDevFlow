"""Q4 P1 유지 — ``platform_compat`` placeholder (Windows skeleton, M5 영역).

본 파일 본문은 v0.6.4 Stage 8 M5에서 작성 (design_final Sec.10.1 정합):

- ``detect_platform()`` — ``sys.platform`` + ``/proc/version`` Microsoft·WSL feature detection.
- macOS 단독 본 가동 (Q4 P1 유지) + Windows ``WindowsNotifier`` stub.
- ``WindowsNotifier`` 채널 비교 = ``plyer`` 0순위 / ``win10toast`` 1순위 (Sec.10.2).
- WSL 검출 시 ``content = f.read()`` 변수 1회 read (drafter v1 미스 코드 정정 흡수, Sec.10.1).

상위 spec: design_final Sec.10.1 (Windows skeleton) + Sec.10.2 (Windows 알림 채널 비교).
"""
