#!/bin/sh

YANA=./yana
SAMPLES="simple.asm sprites.asm sprites2.asm background3.asm pong2.asm controller.asm scrolling5.asm"

failures=0
passed=0

pass() {
	name=$1
	printf "  %-36s PASS\n" "$name"
	passed=$((passed + 1))
}

fail() {
	name=$1
	detail=$2
	printf "  %-36s FAIL\n" "$name"
	if [ -n "$detail" ]; then
		printf "    %s\n" "$detail"
	fi
	failures=$((failures + 1))
}

echo "YANA tests"
echo "=========="
echo

echo "Build"
if ! make yana >/dev/null 2>&1; then
	printf "  %-36s FAIL\n" "yana"
	echo
	echo "Build output:"
	make yana
	exit 1
fi
printf "  %-36s OK\n" "yana"
echo

echo "Assembly output (NESASM3 reference)"
for asm in $SAMPLES; do
	base=${asm%.asm}
	out="${base}.nes"
	ref="${base}_nesasm.nes"
	asm_err=$($YANA -o "$out" "$asm" 2>&1 >/dev/null)
	asm_status=$?

	if [ "$asm_status" -ne 0 ]; then
		fail "$asm" "$asm_err"
		rm -f "$out"
		continue
	fi

	if [ ! -f "$ref" ]; then
		fail "$asm" "missing reference file $ref"
		rm -f "$out"
		continue
	fi

	if cmp -s "$out" "$ref"; then
		pass "$asm"
	else
		fail "$asm" "output differs from $ref"
	fi
	rm -f "$out"
done

echo
echo "----------------------------------------"
total=$((passed + failures))
if [ "$failures" -eq 0 ]; then
	echo "$passed passed, 0 failed"
	exit 0
fi

echo "$passed passed, $failures failed (of $total)"
exit 1
