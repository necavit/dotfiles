#!/bin/bash

function usage() {
  echo "Usage: $0 [MAIN_FILE]"
  echo "  Issues the pdflatex commands needed to to compile and view the results of a LaTeX project whose entry point is MAIN_FILE (without the extension). MAIN_FILE defaults to main.tex."
  exit 1
}

main="main"   # filename of the entry point of the LaTeX project (without extension)

pdflatex $main
bibtex $main
pdflatex $main
pdflatex $main
evince "$main".pdf &
