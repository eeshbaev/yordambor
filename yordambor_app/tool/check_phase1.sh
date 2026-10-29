#!/usr/bin/env bash
# Redesign phase 1 check: packages, analyzer, tests. Logs go to build/phase1_check/.
# Run from anywhere:  bash tool/check_phase1.sh
set -u
cd "$(dirname "$0")/.."
OUT=build/phase1_check
mkdir -p "$OUT"

run() {
  local name="$1"; shift
  echo "• $name..."
  "$@" > "$OUT/$name.txt" 2>&1
  local code=$?
  echo "exit $code" >> "$OUT/$name.txt"
  echo "  exit $code"
}

run pub_get flutter pub get
run analyze flutter analyze --no-fatal-infos
run test flutter test

echo
echo "Analyzer summary:"; grep -E "issues? found|No issues found" "$OUT/analyze.txt" || tail -3 "$OUT/analyze.txt"
echo "Test summary:"; tail -2 "$OUT/test.txt"
echo
echo "Logs saved in $OUT. Tell Claude 'done', then run: bash tool/run_on_emulator.sh"
