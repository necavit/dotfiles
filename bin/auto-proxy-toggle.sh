#!/bin/bash

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`

autoProxyConfigFile="$HOME/.proxy.pac"

function usage {
  echo "${bold}Usage: `basename $0` [-h|--help]${reset}"
  echo ""
  echo "  Toggles an automatic proxy configuration using gsettings and the"
	echo "  provided PAC configuration file in $autoProxyConfigFile."
  echo ""
  echo " OPTIONS"
  echo "    ${bold}-h|--help${reset}"
  echo "        Displays this usage page and exits"
  echo "    ${bold}-l|--list${reset}"
  echo "        Displays the current system proxy configuration"
  exit 1
}

function listProxyConfig() {
  cmd="gsettings get org.gnome.system.proxy mode"
  echo -n "$cmd            ->  " && $cmd
  cmd="gsettings get org.gnome.system.proxy autoconfig-url"
  echo -n "$cmd  ->  " && $cmd
  exit 0
}

function toggleProxy {
	gsettings set org.gnome.system.proxy autoconfig-url "file://$1"
	mode="$(gsettings get org.gnome.system.proxy mode)"
	modeToggle="'none'"
	if [[ "$mode" == "'none'" ]]; then
		modeToggle="'auto'"
	fi
	gsettings set org.gnome.system.proxy mode "$modeToggle"
}

# help: usage + exit
if [[ "$1" = "--help" || "$1" = "-h" ]]; then
	usage
fi

# Check list switch
if [[ "$1" = "--list" || "$1" = "-l" ]]; then
  listProxyConfig
fi

# Check that the proxy config file exists
if [[ -f "$autoProxyConfigFile" ]]; then
	toggleProxy "$autoProxyConfigFile"
else
	echo "ERROR: the PAC file $autoProxyConfigFile does not exist"
fi
