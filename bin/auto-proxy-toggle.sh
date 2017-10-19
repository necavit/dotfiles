#!/bin/bash

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`

function usage {
  echo "${bold}Usage: `basename $0` [-h|--help] PAC_CONFIG_FILE${reset}"
  echo ""
  echo "  Toggles an automatic proxy configuration using gsettings and the"
	echo "  provided PAC configuration file."
  echo ""
  echo " OPTIONS"
  echo "    ${bold}-h|--help${reset}"
  echo "        Displays this usage page and exits"
  exit 1
}

function toggleProxy {
	gsettings set org.gnome.system.proxy autoconfig-url "$1"
	mode="$(gsettings get org.gnome.system.proxy mode)"
	modeToggle="none"
	if [[ "$mode" == "'none'" ]]; then
		modeToggle="auto"
	fi
	gsettings set org.gnome.system.proxy mode "$modeToggle"
}

# help: usage + exit
if [[ "$#" = "0" || "$1" = "--help" || "$1" = "-h" ]]; then
	usage
fi

autoProxyConfigFile=""
# Check that the proxy config file exists
if [[ -n "$1" && -f $1 ]]; then
  autoProxyConfigFile=$1
	toggleProxy $autoProxyConfigFile
else
	echo "ERROR: the provided PAC file does not exist or is not specified"
fi
