#!/bin/sh
# Runs the deterministic chapter checks over every chapter listed in
# _quarto.yml and exits non-zero if any of them fails a rule. Enable it as a
# commit gate with:
#
#   git config core.hooksPath .githooks
#
# and .githooks/pre-commit calls this script.

set -e
cd "$(dirname "$0")/../.."

files=$(awk '/^  chapters:/{f=1;next} /^$/{f=0} f' _quarto.yml \
        | sed 's/^ *- *//' | grep '\.qmd$' | grep -v '^index.qmd$')

fails=0
for f in $files; do
  [ -f "$f" ] || continue
  out=$(python3 publishing/eval/eval-chapter.py "$f" 2>&1)
  n=$(echo "$out" | sed -n 's/.*TOTAL  \([0-9]*\) failures.*/\1/p')
  if [ "${n:-0}" -gt 0 ]; then
    printf '%s\n' "$out" | grep -A3 '\[fail\]'
    fails=$((fails + n))
  fi
done

if [ "$fails" -gt 0 ]; then
  echo "$fails rule failures across the book. Fix them before committing."
  exit 1
fi
echo "All chapters pass the deterministic checks."
