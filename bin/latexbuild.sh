#!/bin/bash

function usage {
  echo "Usage: `basename $0` [MAIN_FILE]"
  echo "  Issues the pdflatex commands needed to to compile and view the results of a LaTeX project whose entry point is MAIN_FILE (without the extension). MAIN_FILE defaults to main.tex."
  exit 1
}

# Check for help option (not achievable with 'getopts', because it is a long GNU option)
if [[ "$1" = "--help" || "$1" = "-h" ]]; then
  usage
fi

main="main" # filename of the entry point of the LaTeX project (without extension)

# Check that the batch file exists
if [[ -n "$1" && -f $1.tex ]]; then
  main=$1
fi

pdflatex "$main"
bibtex "$main"
pdflatex "$main"
pdflatex "$main"
evince "$main".pdf &
