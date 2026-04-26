#!/usr/bin/env bash
# v0.6.3 M3 — PostToolUse 경고 hook (gradual adoption / warning only first)
#
# 입력: PostToolUse JSON (stdin)
# 출력: stderr 경고만, stdout 무출력 (Claude Code 회의창 노이즈 최소화)
# 종료: 항상 exit 0 강제 — 차단 X (Q3 결정 + dispatch 정책)
#
# 대상 확장자:
#   *.py → python3 -m py_compile (문법 오류 경고)
#   *.sh → shellcheck (lint 경고)
# 기타 확장자: skip.

set -u  # set -e 사용 X — 어떤 단계 실패도 hook 차단으로 이어지면 안 됨.

# stdin 1회 read (jq 또는 grep fallback)
input=$(cat 2>/dev/null || true)
[ -z "$input" ] && exit 0

# jq 우선, 미설치 시 grep fallback
if command -v jq >/dev/null 2>&1; then
  file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)
else
  # POSIX grep fallback: "file_path": "..." 패턴 추출
  file=$(printf '%s' "$input" | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]+"' | head -n1 | sed -E 's/.*"([^"]+)"$/\1/' || true)
fi

[ -z "$file" ] && exit 0
[ ! -f "$file" ] && exit 0

case "$file" in
  *.py)
    if command -v python3 >/dev/null 2>&1; then
      python3 -m py_compile "$file" 2>&1 1>/dev/null >&2 || true
    fi
    ;;
  *.sh)
    if command -v shellcheck >/dev/null 2>&1; then
      shellcheck "$file" 2>&1 1>/dev/null >&2 || true
    fi
    ;;
  *)
    : # other extensions: skip
    ;;
esac

exit 0  # 항상 0 — 차단 X (gradual adoption)
