#!/usr/bin/env bash
# Check the test-ID lists of a prune-tests run. Each file holds one test ID per line.
# Exits 0 when the check holds, 1 when it fails, 2 on bad usage.
set -euo pipefail
export LC_ALL=C

usage() {
  cat >&2 <<'EOF'
Usage:
  check-cut.sh classified <before> <ids>        every ID in before has exactly one verdict
  check-cut.sh applied <before> <after> <cut>   after = before - cut, exactly
EOF
  exit 2
}
ids() { tr -d '\r' < "$1" | { grep -v '^[[:space:]]*$' || true; } | sort -u; }
dups() { tr -d '\r' < "$1" | { grep -v '^[[:space:]]*$' || true; } | sort | uniq -d; }
count() { ids "$1" | wc -l | tr -d ' '; }

fail=0
section() {
  [ -n "$2" ] || return 0
  echo "== $1 ($(printf '%s\n' "$2" | wc -l | tr -d ' '))"
  printf '%s\n' "$2"
  fail=1
}

case "${1:-}" in
  classified)
    [ $# -eq 3 ] || usage
    before=$2 classified=$3
    for f in "$before" "$classified"; do [ -r "$f" ] || { echo "UNREADABLE: $f"; exit 2; }; done
    echo "== before $(count "$before") · with a verdict $(count "$classified")"
    section "no verdict" "$(comm -23 <(ids "$before") <(ids "$classified"))"
    section "verdict for an ID not in the before list" "$(comm -13 <(ids "$before") <(ids "$classified"))"
    section "more than one verdict" "$(dups "$classified")"
    shared=$(dups "$before")
    if [ -n "$shared" ]; then
      echo "== note: these IDs name more than one test (shared titles); delete them by position, not title"
      printf '%s\n' "$shared"
    fi
    ;;
  applied)
    [ $# -eq 4 ] || usage
    before=$2 after=$3 cut=$4
    for f in "$before" "$after" "$cut"; do [ -r "$f" ] || { echo "UNREADABLE: $f"; exit 2; }; done
    expected=$(comm -23 <(ids "$before") <(ids "$cut") | wc -l | tr -d ' ')
    echo "== before $(count "$before") · cut $(count "$cut") · after $(count "$after") · expected $expected"
    section "cut but still listed" "$(comm -12 <(ids "$cut") <(ids "$after"))"
    section "gone but not cut" "$(comm -23 <(comm -23 <(ids "$before") <(ids "$cut")) <(ids "$after"))"
    section "listed after but not before (a renamed test or table row?)" "$(comm -13 <(ids "$before") <(ids "$after"))"
    section "cut ID not in the before list" "$(comm -23 <(ids "$cut") <(ids "$before"))"
    ;;
  *) usage ;;
esac

[ "$fail" -eq 0 ] && echo "== ok"
exit "$fail"
