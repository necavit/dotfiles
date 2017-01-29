#!/bin/bash

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`

function usage {
  echo "${bold}Usage: `basename $0` [-h|--help] [COMMAND [--force]]${reset}"
  echo ""
  echo "  Performs an incremental duplicity based backup as specified in the config file."
  echo "  Note that, by default, ${bold}backup${reset} and ${bold}remove-old${reset} commands are not executed without"
  echo "  specifying the --force. Rather, it prints the command that will be executed."
  echo ""
  echo "  The general config file for this duplicity wrapper is:"
  echo "    $configFile"
  echo ""
  echo "  The included/excluded directories of the backup are listed in the config file:"
  echo "    $includeFileList"
  echo ""
  echo " COMMANDS"
  echo "    ${bold}backup${reset}"
  echo "        Performs a backup, as specified in the config file located at $configFile"
  echo "    ${bold}remove-old${reset}"
  echo "        Removes old backup chains (full and incremental backups), up until the"
  echo "        last full backup and its subsequent incremental sets"
  echo "    ${bold}status${reset}"
  echo "        Checks the backup collection status in the configured backup media"
  echo ""
  echo " OPTIONS"
  echo "    ${bold}--force${reset}"
  echo "        Disables dry-run and actually executes the command"
  echo "    ${bold}-h|--help${reset}"
  echo "        Displays this usage page and exits"
  exit 1
}

function backup {
  dryRun="--dry-run"
  if [[ "$1" = "--force" ]]; then
    echo "${bold}${red}!!! WARNING !!! WARNING !!! WARNING !!!${reset}"
    read -p "This will perform the backup. Continue? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      dryRun=""
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      exit 1
    fi
  fi

  bkpcmd="duplicity --full-if-older-than $fullBackupAfter $dryRun --include-globbing-filelist $includeFileList $sourceDir $targetUrl"
  echo "${green}executing: $bkpcmd${reset}"
  echo ""
  $bkpcmd
}

function removeOld {
  dryRun=""
  if [[ "$1" = "--force" ]]; then
    echo "${bold}${red}!!! WARNING !!! WARNING !!! WARNING !!!${reset}"
    read -p "This will remove old backups. Continue? (y/n) " -n 1
  	echo ""
  	if [[ $REPLY =~ ^[Yy]$ ]]; then
  		dryRun="--force" # needed to force the removal (see 'man duplicity')
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      exit 1
  	fi
  fi

  rmoldcmd="duplicity remove-all-but-n-full 1 $dryRun $targetUrl"
  echo "${green}executing: $rmoldcmd${reset}"
  echo ""
  $rmoldcmd
}

function checkStatus {
  statuscmd="duplicity collection-status $targetUrl"
  echo "${green}executing: $statuscmd${reset}"
  echo ""
  $statuscmd
}

#echo "Usage: `basename $0` [-h|--help] [COMMAND [--force]]"
# check for root
if [[ $(id -u) -ne 0 ]]; then
  # load config
  configFile="$HOME/.backup-extdrive.cfg"
  source $configFile

  # help: usage + exit
  if [[ "$#" = "0" || "$1" = "--help" || "$1" = "-h" ]]; then
    usage
  fi

  # select the command
  if [[ "$1" = "backup" ]]; then
    shift
    backup "$@"
  elif [[ "$1" = "remove-old" ]]; then
    shift
    removeOld "$@"
  elif [[ "$1" = "status" ]]; then
    checkStatus
  else
    echo "Error: command not recognised: $1"
  fi
else
  echo "Error: this script should NOT be run as root."
  exit 1
fi
