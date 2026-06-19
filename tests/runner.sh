#!/bin/sh
#
# runner.sh -- run tests
#
# Just runs sexp2xml to a series of files and checks the result.
# Must be run from the project root.
#

SBCL="$(which sbcl)"
SEXP2XML="./sexp2xml"

if ! [ -f "${SEXP2XML}" ]; then
	$SBCL --load "./cli.lisp"
fi

for file in tests/*.lisp; do
	expected="${file%.lisp}-expected.xml"

	if "$SEXP2XML" "$file" | diff -q - "$expected" >/dev/null; then
		echo "$file: ok"
	else
		echo "$file: fail"
	fi
done

