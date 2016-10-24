#!/usr/bin/env bash

# adapted from http://superuser.com/a/634313
# usage: watch.sh annotated-bibliography

# note that the bibliography has to be symlinked to the document directory
# because BibTeX is a steaming pile of crap:
DOCUMENT="$1.tex"
LIBRARY="references.bib"

# move to the document directory because it's easier than trying to get pdflatex
# to change its output location:
base=`dirname "$0"`
cd "$base/$1"

while true; do
    current=`stat -c %Z "$DOCUMENT" "../$LIBRARY"`

    if [[ "$last" != "$current" ]]; then
        # we've climbed Everest, run a sub-4 mile, created pizza rolls, and put
        # people on the moon, but this is apparently still necessary:
        xelatex "$DOCUMENT"
        bibtex `basename -s .tex "$DOCUMENT"`
        xelatex "$DOCUMENT"
        xelatex "$DOCUMENT"

        last="$current"
    fi
    sleep 4
done
