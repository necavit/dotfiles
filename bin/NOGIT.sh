#!/bin/bash
# code based on https://gist.github.com/mmueller/7286919
#   belonging to mmueller, 2017
#
# This script wraps git, so install it somewhere such as ~/bin where
# it will be found by your shell before the actual git executable.

# config file
configFile="$HOME/.git_wrapper_config"

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`

function usage {
  echo "${bold}Usage: `basename $0` [-d|--disable-vpn|-h|--help] GIT_COMMAND${reset}"
  echo ""
  echo "  Wrapper for Git that checks the status of VPN connection specified in"
  echo "  the $configFile configuration file. If the connection is down, it is"
  echo "  brought up before executing the GIT_COMMAND and down afterwards."
  echo ""
  echo " OPTIONS"
  echo "    ${bold}-d|--disable-vpn${reset}"
  echo "        Disables the VPN check and performs the Git command given"
  echo "        the commands"
  echo "    ${bold}-h|--help${reset}"
  echo "        Displays this usage page and exits"
  exit 1
}

function loggg {
  echo "[git wrapper] $1"
}

GIT_COMMAND_FILTER="status:commit:add:stash:"
function filterCommand {

}

# Extract the command from a git command line
function get_git_command {
    while [[ "$1" =~ ^- ]]; do
        shift
    done
    echo $1
}

function pre_command {
    command="`get_git_command "$@"`"

    if filterCommand "$command"; then
      return
    fi

    # Pre-command hooks
    if ! $disableVpn; then
      loggg "checking VPN..."
      if ! nmcli-check-connection -e "$vpnConnection"; then
        loggg "toggling UP the VPN connection..."
        nmcli connection up id "$vpnConnection"
        turnVPNOff=true
      fi
    fi
}

function post_command {
    command="`get_git_command "$@"`"

    if filterCommand "$command"; then
      return
    fi

    # Post-command hooks
    if ! $disableVpn && $turnVPNOff; then
      loggg "toggling DOWN the VPN connection..."
      nmcli connection down id "$vpnConnection"
    fi
}

# help: usage + exit
if [[ "$#" = "0" || "$1" = "--help" || "$1" = "-h" ]]; then
  usage
fi

disableVpn=false
if [[ "$1" = "--disable-vpn" || "$1" = "-d" ]]; then
  disableVpn=true
  shift
else
  source $configFile
fi

# Assuming this script is called 'git', find the next available 'git' command
# via 'which'. Override this if you want to hard-code a different path.
GIT="`which -a git | awk 'NR==2 {print}'`"
if [ "$GIT" = "" ]; then
    echo "ERROR: git executable not found"
    exit 1
fi

turnVPNOff=false
pre_command "$@"
"$GIT" "$@"
post_command "$@"
