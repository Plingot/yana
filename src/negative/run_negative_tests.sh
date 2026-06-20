#!/bin/sh
set -e

YANA=./yana
failures=0

assert_fails() {
  name=$1
  shift
  if "$@" >/dev/null 2>&1; then
    echo "FAIL: expected $name to fail"
    failures=$((failures + 1))
  else
    echo "PASS: $name"
  fi
}

assert_fails "missing input file" $YANA /nonexistent/input.asm

assert_fails "unresolved symbol" $YANA -o /tmp/yana-unresolved.nes negative/unresolved.asm

assert_fails "branch out of range" $YANA -o /tmp/yana-branch.nes negative/branch_range.asm

assert_fails "missing incbin file" $YANA -o /tmp/yana-incbin.nes negative/missing_incbin.asm

if [ "$failures" -ne 0 ]; then
  echo "$failures negative test(s) failed"
  exit 1
fi

echo "All negative tests passed"
