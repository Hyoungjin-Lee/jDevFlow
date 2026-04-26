#!/bin/sh
set -u

ROOT="${JONEFLOW_ROOT:-/Users/geenya/projects/Jonelab_Platform/jOneFlow}"
DIR="$ROOT/scripts/v0.6.1"
REVIEW="$ROOT/docs/04_implementation_v0.6.1_n1_rename/code_review.md"
FLAG="/tmp/joneflow_v061_rebuild_done.flag"
LOG="/tmp/joneflow_v061_rebuild_watch.log"
QUIET_TICKS=2

: > "$LOG"
echo "[$(date '+%H:%M:%S')] watch start — dir=$DIR review=$REVIEW" >> "$LOG"

last_total=0
quiet=0
i=0
while [ $i -lt 240 ]; do
  i=$((i + 1))

  exp="$DIR/expressions.md"
  pre="$DIR/pre_check.sh"
  post="$DIR/post_check.sh"
  verify="$DIR/verify_all.sh"
  rename="$DIR/rename_n1.sh"

  status=""
  total=0
  for pair in "$exp 32 E" "$pre 512 P" "$post 256 O" "$verify 1024 V" "$rename 1536 R" "$REVIEW 5120 C"; do
    set -- $pair
    path=$1; minsz=$2; mark=$3
    if [ -f "$path" ]; then
      sz="$(wc -c < "$path" 2>/dev/null || echo 0)"
      total=$((total + sz))
      if [ "$sz" -ge "$minsz" ]; then
        status="${status}${mark}"
      fi
    fi
  done

  removed_hits=0
  if [ -d "$DIR" ]; then
    removed_hits=$(grep -rln 'REMOVED' "$DIR" 2>/dev/null | wc -l | tr -d ' ')
  fi

  if [ "$status" = "EPOVRC" ] && [ "$total" = "$last_total" ] && [ "$removed_hits" = "0" ]; then
    quiet=$((quiet + 1))
  else
    quiet=0
  fi
  last_total="$total"

  echo "[$(date '+%H:%M:%S')] tick $i status=[$status] removed=$removed_hits total=$total quiet=$quiet" >> "$LOG"

  if [ "$quiet" -ge "$QUIET_TICKS" ]; then
    {
      echo "v0.6.1 재작성 완료 감지"
      echo "expressions.md:  $(wc -c < "$exp") bytes"
      echo "pre_check.sh:    $(wc -c < "$pre") bytes"
      echo "post_check.sh:   $(wc -c < "$post") bytes"
      echo "verify_all.sh:   $(wc -c < "$verify") bytes"
      echo "rename_n1.sh:    $(wc -c < "$rename") bytes"
      echo "code_review.md:  $(wc -c < "$REVIEW") bytes"
      echo "REMOVED hits:    $removed_hits"
      echo "total:           $total bytes"
      echo "ts:              $(date '+%Y-%m-%d %H:%M:%S')"
    } > "$FLAG"
    exit 0
  fi

  sleep 30
done

echo "[$(date '+%H:%M:%S')] timeout 2h reached" >> "$LOG"
exit 1
