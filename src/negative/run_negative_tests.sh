#!/bin/sh

YANA=./yana
failures=0
passed=0

pass() {
	name=$1
	printf "  %-36s PASS\n" "$name"
	passed=$((passed + 1))
}

fail() {
	name=$1
	printf "  %-36s FAIL\n" "$name"
	failures=$((failures + 1))
}

assert_fails() {
	name=$1
	shift
	if "$@" >/dev/null 2>&1; then
		fail "$name"
	else
		pass "$name"
	fi
}

echo "YANA negative tests"
echo "==================="
echo

echo "Expected assembler failures"
assert_fails "missing input file" $YANA /nonexistent/input.asm
assert_fails "unresolved symbol" $YANA -o /tmp/yana-unresolved.nes negative/unresolved.asm
assert_fails "branch out of range" $YANA -o /tmp/yana-branch.nes negative/branch_range.asm
assert_fails "missing incbin file" $YANA -o /tmp/yana-incbin.nes negative/missing_incbin.asm

echo
echo "----------------------------------------"
total=$((passed + failures))
if [ "$failures" -eq 0 ]; then
	echo "$passed passed, 0 failed"
	exit 0
fi

echo "$passed passed, $failures failed (of $total)"
exit 1
