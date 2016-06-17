#!/bin/bash

function usage {
  echo "Usage: $0 ROOT_DIR"
  echo "  Checks whether any Git repository under the ROOT_DIR has changes and needs to be committed or pushed."
  exit 1
}

# Check for help option (not achievable with 'getopts', because it is a long GNU option)
if [[ "$1" = "--help" || "$1" = "-h" ]]; then
  usage
fi

function check_health {
  for d in "$@"; do
    test -d "$d" -a \! -L "$d" || continue
    cd "$d"
    if [ -d ".git" ]; then
      if [ -n "$(git status --porcelain)" ]; then
        echo "  $PWD"
      fi
    else
      check_health *
    fi
    cd ..
  done
}

# Check that the root directory exists
if [[ -n "$1" && -d "$1" ]]; then
  # needed to expand dot files (.git dir, for example)
  shopt -s dotglob

  echo "The following repositories have changes:"
  check_health "$1"

  shopt -u dotglob
fi
