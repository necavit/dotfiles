#!/bin/bash

echo "$(basename $0) will remove the following files:"
find . -name "*.aux"
find . -name "*.bbl"
find . -name "*.bcf"
find . -name "*.blg"
find . -name "*.log"
find . -name "*.run.xml"
find . -name "*.out"

read -p "Continue? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  find . -name "*.aux" | xargs rm -f
  find . -name "*.bbl" | xargs rm -f
  find . -name "*.bcf" | xargs rm -f
  find . -name "*.blg" | xargs rm -f
  find . -name "*.log" | xargs rm -f
  find . -name "*.run.xml" | xargs rm -f
  find . -name "*.out" | xargs rm -f
fi
