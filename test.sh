#!/bin/sh
#
# Two checks. Each rule carries its cases in a `tests:` block, run in
# isolation by `vale test`, which with `--coverage` also requires every rule
# to fire in some case. Then one page is checked and compared to a golden
# file, and its rewrite in fixtures/clean/ is required to produce nothing:
# the scores have to agree about which paragraph reads hard, and land on it.
#
# `./test.sh -u` rewrites the golden file instead of comparing.
set -eu

update=0
[ "${1:-}" = "-u" ] && update=1
status=0

root=$(cd "$(dirname "$0")" && pwd)
vale=${VALE:-vale}
mkdir -p "$root/testdata"

(cd "$root" && "$vale" test --coverage Readability) || status=1

run() { # <fixture path, relative to root> -> alerts on stdout, sorted
	(cd "$root" && "$vale" --output=line --no-global "$1" 2>&1 || true) |
		sort -t: -k2,2n -k3,3n -k4,4
}

golden=$root/testdata/page.md.txt
got=$(run fixtures/page.md)
if [ "$update" -eq 1 ]; then
	printf '%s\n' "$got" > "$golden"
elif [ ! -f "$golden" ]; then
	echo "FAIL page.md: no golden file; run ./test.sh -u"
	status=1
elif [ "$got" != "$(cat "$golden")" ]; then
	echo "FAIL page.md"
	printf '%s\n' "$got" | diff -u "$golden" - || true
	status=1
else
	echo "ok   page.md ($(printf '%s' "$got" | grep -c . || true) alerts)"
fi

clean=$(run fixtures/clean/page.md)
if [ -n "$clean" ]; then
	echo "FAIL clean/page.md: the rewrite still reads hard"
	printf '%s\n' "$clean"
	status=1
else
	echo "ok   clean/page.md (clean)"
fi

[ "$update" -eq 1 ] && echo "golden file rewritten"
exit $status
