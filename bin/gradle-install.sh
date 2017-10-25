#!/bin/bash

# config file
configFile="$HOME/.gradle_install_config"

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`

function usage {
  echo "${bold}Usage: `basename $0` [-d|--dry-run|-h|--help] TARGET${reset}"
  echo ""
  echo "  Compiles and deploys the TARGET project to the snapshots repository"
  echo "  specified in $configFile configuration file"
  echo ""
  echo " OPTIONS"
  echo "    ${bold}-d|--dry-run${reset}"
  echo "        Performs a trial execution without actually executing"
  echo "        the commands"
  echo "    ${bold}-h|--help${reset}"
  echo "        Displays this usage page and exits"
  exit 1
}

function gradleInstall {
  if [[ -d .git || $(git rev-parse --git-dir > /dev/null 2>&1) ]]; then
    target=""
    dryRun=false
    if [[ "$1" == "--dry-run" || "$1" == "-d" ]]; then
      target="$2"
      dryRun=true
    else
      target="$1"
    fi
    if [[ -d "$target" ]]; then
      chmod u+x ./gradlew
      source $configFile
      cmd="./gradlew :$target:uploadArchives -Pnexus_repository=$nexusRepository -Pnexus_username=$nexusUsername -Pnexus_password=$nexusPassword"
      if $dryRun; then
        echo "$cmd"
      else
        $cmd
      fi
      # ./gradlew ":"${target}":uploadArchives" \
      #   -Pnexus_repository="$nexusRepository" \
      #   -Pnexus_username="$nexusUsername" -Pnexus_password="$nexusPassword"
    else
      echo "ERROR: the specified TARGET does not exist or is not a directory"
      exit 1
    fi
  else
    echo "ERROR: the current directory is not a Git repository"
    exit 1
  fi
}

# help: usage + exit
if [[ "$#" = "0" || "$1" = "--help" || "$1" = "-h" ]]; then
  usage
fi

gradleInstall "$@"
