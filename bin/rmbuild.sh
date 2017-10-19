#!/bin/bash

echo "$(basename $0) will remove the following files:"
find . -name build | tr -t "\n" " "

read -p "Continue? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf `find . -name build | tr -t "\n" " "`
fi
