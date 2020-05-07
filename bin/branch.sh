#!/bin/bash

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`

function usage {
  echo "${bold}Usage: `basename $0` [-h|--help] COMMAND${reset}"
  echo ""
  echo "  Prompts for a branch name and creates a Git branch in the current repository, with the name format:"
  echo "    DATE(YYYYMMDD)_COMMAND_NAME"
  echo ""
  echo " COMMANDS"
  echo "    ${bold}fix${reset}"
  echo "        Creates a fix branch in the repository."
  echo "    ${bold}feature${reset}"
  echo "        Creates a feature branch in the repository."
  echo "    ${bold}release${reset}"
  echo "        Creates a release branch in the repository."
  echo " OPTIONS"
  echo "    ${bold}-h|--help${reset}"
  echo "        Displays this usage page and exits"
  exit 1
}

function createBranch {
  read -p "Branch name: $(date '+%Y%m%d')_$1_" name
  git checkout -b $(date '+%Y%m%d')_$1_$name
  git push -u origin $(date '+%Y%m%d')_$1_$name
}

# check for root
if [[ $(id -u) -ne 0 ]]; then
  # help: usage + exit
  if [[ "$#" = "0" || "$1" = "--help" || "$1" = "-h" ]]; then
    usage
  fi

  # select the command
  if [[ "$1" = "fix" ]]; then
    shift
    createBranch "fix"
  elif [[ "$1" = "feature" ]]; then
    shift
    createBranch "feature"
  elif [[ "$1" = "release" ]]; then
    shift
    createBranch "release"
  else
    echo "Error: command not recognised: $1"
  fi
else
  echo "Error: this script should NOT be run as root."
  exit 1
fi
