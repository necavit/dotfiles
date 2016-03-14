#!/bin/bash

echo "$(basename $0) will remove the following files:"
find . -name "*.aux"
find . -name "*.bbl"
find . -name "*.blg"
find . -name "*.log"
find . -name "*.out"

read -p "Continue? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm *.aux *.bbl *.blg *.log *.out
fi
