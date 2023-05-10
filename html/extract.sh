#!/bin/sh
SCRIPT="$0"
SD="$(dirname "$SCRIPT")"
XAL="$(cd "$SD" && pwd)"
TIDYCONFIG="$XAL/truncate.i"

# Set context ELEMENT and apply anchor PREDICATE.
ELEMENT='.'
PREDICATE='[node()]'

if test $# -gt 0
then
	ELEMENT="$1"
	shift 1
fi

if test $# -gt 0
then
	PREDICATE="$1"
	shift 1
fi

exec tidy -config "$TIDYCONFIG" /dev/stdin | \
xsltproc --html --novalid \
	--stringparam CONTEXT "$ELEMENT" \
	--stringparam PREDICATE "$PREDICATE" \
	--stringparam time-context "$XAL_DEFAULT_TIMECONTEXT" \
	"$XAL/anchors.xsl" /dev/stdin
