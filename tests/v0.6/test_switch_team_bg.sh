#!/usr/bin/env bash
# test_switch_team_bg.sh — Background gate integration test (Sec 4.4, 4.5).
#
# 시나리오:
#   1. Spawn 더미 프로세스 (commandline = "claude --teammate-mode tmux dummy")
#      → switch_team.sh가 pgrep -fl 'claude.*--teammate-mode'로 감지.
#   2. switch_team.sh <mode> 호출 → 차단 메시지 첫 줄(⚠️ verbatim) + exit 1.
#   3. switch_team.sh <mode> --force 호출 → 우회 + 정상 적용.
#   4. dummy 종료 후 일반 호출 → 정상 적용.
#
# bash exec -a로 argv[0]을 위장하여 pgrep -fl이 매칭하도록 만든다.

set -eu

# shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
SWITCH_SCRIPT="$ROOT/scripts/switch_team.sh"

if [ ! -f "$SWITCH_SCRIPT" ]; then
    echo "FAIL: switch_team.sh not found: $SWITCH_SCRIPT" >&2
    exit 1
fi

# ============================================================================
# 환경 의존 가드: 외부(테스트 외) claude --teammate-mode 프로세스가 살아 있으면
# pgrep 탐지가 case 3("dummy 종료 후 정상")을 false-block 시킴 → 본 테스트는
# 격리 환경에서만 의미 있음. 발견 시 PASS 처리하고 skip 안내.
# 내부 spawn은 'joneflow-bg-test' 마커로 식별 (Spawn 섹션의 exec -a 인자).
# ============================================================================
EXTERNAL_TEAMMATE=$(pgrep -fl 'claude.*--teammate-mode' 2>/dev/null \
    | grep -v 'joneflow-bg-test' \
    || true)
if [ -n "$EXTERNAL_TEAMMATE" ]; then
    echo "SKIP: 외부 claude --teammate-mode 프로세스 감지. 본 테스트는 격리 환경에서만 의미." >&2
    echo "      감지된 프로세스(테스트 자기 spawn 제외):" >&2
    printf '%s\n' "$EXTERNAL_TEAMMATE" | sed 's/^/        /' >&2
    echo "test_switch_team_bg: SKIP (env-dependent, treated as PASS)"
    exit 0
fi

TMPROOT=$(mktemp -d "${TMPDIR:-/tmp}/v06-switch-bg.XXXXXX")
DUMMY_PID=""
# shellcheck disable=SC2329  # invoked via trap below.
cleanup() {
    if [ -n "$DUMMY_PID" ]; then
        # Kill our dummy if still running. Ignore errors (already exited).
        kill -TERM "$DUMMY_PID" 2>/dev/null || true
        wait "$DUMMY_PID" 2>/dev/null || true
    fi
    rm -rf "$TMPROOT"
}
trap cleanup EXIT HUP INT TERM

failures=0

assert_eq() {
    if [ "$2" = "$3" ]; then
        printf '  PASS %s\n' "$1"
    else
        printf '  FAIL %s: expected=[%s] got=[%s]\n' "$1" "$2" "$3"
        failures=$((failures + 1))
    fi
}

# ============================================================================
# Fixture: v0.4 settings.json with team_mode=claude-only.
# ============================================================================
mkdir -p "$TMPROOT/.claude"
cat > "$TMPROOT/.claude/settings.json" <<'EOF'
{
  "schema_version": "0.4",
  "workflow_mode": "desktop-cli",
  "team_mode": "claude-only",
  "stage_assignments": {
    "stage8_impl": "claude",
    "stage9_review": "claude",
    "stage10_fix": "claude",
    "stage11_verify": "claude"
  },
  "language": "ko"
}
EOF

# ============================================================================
# Spawn 더미 프로세스. argv[0] = 'claude --teammate-mode tmux joneflow-bg-test'.
# pgrep -fl 'claude.*--teammate-mode' 가 잡도록.
# ============================================================================
bash -c 'exec -a "claude --teammate-mode tmux joneflow-bg-test" sleep 99999' &
DUMMY_PID=$!

# pgrep이 잡을 때까지 잠깐 대기 (race 회피).
for _i in 1 2 3 4 5 6 7 8 9 10; do
    if pgrep -fl 'claude.*--teammate-mode' | grep -q joneflow-bg-test; then
        break
    fi
    sleep 0.2
done

if ! pgrep -fl 'claude.*--teammate-mode' | grep -q joneflow-bg-test; then
    echo "FAIL: 더미 spawn이 pgrep 매칭 안 됨. exec -a 미지원?" >&2
    pgrep -fl sleep | sed 's/^/    /' >&2
    exit 1
fi
printf '  PASS dummy spawn detected by pgrep -fl claude.*--teammate-mode\n'

# ============================================================================
# 1. 차단 케이스: --force 없음 → exit 1, ⚠️ verbatim 첫 줄 출력.
# ============================================================================
set +e
( JONEFLOW_ROOT="$TMPROOT"; export JONEFLOW_ROOT
  bash "$SWITCH_SCRIPT" claude-impl-codex-review
) > "$TMPROOT/blocked.stdout" 2> "$TMPROOT/blocked.stderr"
rc=$?
set -e

assert_eq '1: exit 1 on bg detection' '1' "$rc"

# verbatim 첫 줄 + 마지막 verbatim 줄 출력 확인.
if grep -q '^⚠️  팀 구성을 변경할 수 없습니다.$' "$TMPROOT/blocked.stdout"; then
    printf '  PASS 1: ⚠️ verbatim header printed\n'
else
    printf '  FAIL 1: ⚠️ verbatim header missing in stdout\n'
    sed 's/^/    /' "$TMPROOT/blocked.stdout"
    failures=$((failures + 1))
fi
if grep -q '^진행 상태 확인: /codex:status$' "$TMPROOT/blocked.stdout"; then
    printf '  PASS 1: /codex:status verbatim line printed\n'
else
    printf '  FAIL 1: /codex:status verbatim line missing\n'
    failures=$((failures + 1))
fi
# 보조 안내 (--force 우회) 출력.
if grep -q '우회: --force' "$TMPROOT/blocked.stdout"; then
    printf '  PASS 1: --force 우회 안내 포함\n'
else
    printf '  FAIL 1: --force 우회 안내 누락\n'
    failures=$((failures + 1))
fi

# settings.json 변동 없음.
orig_tm='claude-only'
got_tm=$(sed -n 's/^  "team_mode": *"\([^"]*\)".*/\1/p' "$TMPROOT/.claude/settings.json" | sed -n '1p')
assert_eq '1: settings.json unchanged on block' "$orig_tm" "$got_tm"

# ============================================================================
# 2. --force 우회 → 정상 적용 + exit 0.
# ============================================================================
set +e
( JONEFLOW_ROOT="$TMPROOT"; export JONEFLOW_ROOT
  bash "$SWITCH_SCRIPT" claude-impl-codex-review --force
) > "$TMPROOT/forced.stdout" 2> "$TMPROOT/forced.stderr"
rc=$?
set -e

assert_eq '2: exit 0 with --force bypass' '0' "$rc"
got_tm=$(sed -n 's/^  "team_mode": *"\([^"]*\)".*/\1/p' "$TMPROOT/.claude/settings.json" | sed -n '1p')
assert_eq '2: team_mode applied via --force' 'claude-impl-codex-review' "$got_tm"
got_s9=$(sed -n 's/^    "stage9_review": *"\([^"]*\)".*/\1/p' "$TMPROOT/.claude/settings.json" | sed -n '1p')
assert_eq '2: stage9_review mapped to codex (Sec 2.5)' 'codex' "$got_s9"

# ============================================================================
# 3. 더미 종료 → 일반 호출 정상.
# ============================================================================
kill -TERM "$DUMMY_PID" 2>/dev/null || true
wait "$DUMMY_PID" 2>/dev/null || true
DUMMY_PID=""

# pgrep이 사라졌는지 확인.
for _i in 1 2 3 4 5; do
    if ! pgrep -fl 'claude.*--teammate-mode' | grep -q joneflow-bg-test; then
        break
    fi
    sleep 0.2
done

set +e
( JONEFLOW_ROOT="$TMPROOT"; export JONEFLOW_ROOT
  bash "$SWITCH_SCRIPT" claude-only
) > "$TMPROOT/clean.stdout" 2> "$TMPROOT/clean.stderr"
rc=$?
set -e

assert_eq '3: exit 0 after dummy gone (no --force)' '0' "$rc"
got_tm=$(sed -n 's/^  "team_mode": *"\([^"]*\)".*/\1/p' "$TMPROOT/.claude/settings.json" | sed -n '1p')
assert_eq '3: team_mode reverted to claude-only' 'claude-only' "$got_tm"

if [ "$failures" -eq 0 ]; then
    printf 'test_switch_team_bg: PASS\n'
    exit 0
else
    printf 'test_switch_team_bg: FAIL (%d sub-failures)\n' "$failures"
    exit 1
fi
