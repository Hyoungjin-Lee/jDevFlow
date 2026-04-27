#!/bin/bash
# heartbeat 데몬 wrapper — 본 로직은 heartbeat_daemon.py
# bash 3.2 (macOS 기본) associative array 미지원으로 Python 본체로 위임
exec python3 "$(dirname "$0")/heartbeat_daemon.py" "$@"
