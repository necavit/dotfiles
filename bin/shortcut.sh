#!/bin/bash

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`

function usage {
  echo "${bold}Usage: `basename $0` [-h|--help] [COMMAND]${reset}"
  echo ""
  echo "  Add, remove and list ${bold}cd${reset} alias commands, that act as shortcuts."
  echo "  The aliased commands are appended to the $aliasFile config file."
  echo ""
  echo " COMMANDS"
  echo "    ${bold}add${reset} ALIAS TARGET_DIR"
  echo "        Adds an alias (shortcut) to the TARGET_DIR with the name ALIAS."
  echo "    ${bold}remove${reset} ALIAS"
  echo "        Removes the specified ALIAS command. Prompts for confirmation."
  echo "    ${bold}list${reset} [ALIAS]"
  echo "        Lists all the aliased commands. If an ALIAS is provided, lists this"
  echo "        shortcut only."
  echo " OPTIONS"
  echo "    ${bold}-h|--help${reset}"
  echo "        Displays this usage page and exits"
  exit 1
}

function getAliasForName {
  cat $aliasFile | grep "cd /" | grep "$1" \
      | sed "s/\=/,/;s/alias\ //;s/\"cd\ //;s/\"//" | column -t -s','
}

function addAlias {
  if [[ ! -z "$1" && ! -z "$2" ]]; then
    if [[ -d "$2" ]]; then
      echo "alias $1=\"cd $2\"" >> $aliasFile
      echo "${red}Please execute the following command to take effect immediately"
      echo "or wait for a new shell to source it for you.${reset}"
      echo "source $aliasFile"
    else
      echo "ERROR: $2 is not a directory"
      exit 1
    fi
  else
    echo "ERROR: insufficient number of parameters"
  fi
}

function removeAlias {
  aliasToRemove=$(getAliasForName "$1")
  echo "${red}WARNING!!! WARNING!!! WARNING!!!${reset}"
  echo "Are you sure you want to delete the alias:"
  read -p "\"$aliasToRemove\" ? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		# remove the alias from the file
    aliasLine=$(cat $aliasFile | grep "cd /" | grep "$1")
    echo "Removing \"$aliasLine\" from $aliasFile..."
    sed -i.bak "/${aliasLine//\//\\/}/d" $aliasFile
    # undo the alias
    echo "${red}Please execute the following command to take effect immediately"
    echo "or wait for a new shell to do it for you.${reset}"
    echo "unalias $1"
	fi
}

function listAlias {
  if [[ "$1" = "--complete" ]]; then
    # list alias for the autocomplete function
    cat $aliasFile | grep "cd /" | sed "s/alias\ //;s/\"cd\ //;s/\=.*//" | sort
  else
    if [[ ! -z "$1" ]]; then
      # list one particular alias
      getAliasForName "$1"
    else
      # list all aliases:
      #  cat the file, get the lines where a "cd /..." is, take out some of the clutter
      #  and unnecessary quotation marks, transform to a CSV output, sort it and output
      #  print it nicely with 'column'
      cat $aliasFile | grep "cd /" \
          | sed "s/\=/,/;s/alias\ //;s/\"cd\ //;s/\"//" \
          | sort | column -t -s','
    fi
  fi
}

function checkAliasFile {
  if [[ ! -f $aliasFile ]]; then
    echo "The shortcut database file is not in its default location or does not exist."
    echo "Initializing the shortcut database file..."
    echo "#!/bin/bash" > $aliasFile
  fi
}

# check for root
if [[ $(id -u) -ne 0 ]]; then
  # load config
  aliasFile="$HOME/.bash_shortcut"

  # help: usage + exit
  if [[ "$#" = "0" || "$1" = "--help" || "$1" = "-h" ]]; then
    usage
  fi

  # check the existence of the file
  checkAliasFile

  # select the command
  if [[ "$1" = "add" ]]; then
    shift
    addAlias "$@"
  elif [[ "$1" = "remove" ]]; then
    shift
    removeAlias "$@"
  elif [[ "$1" = "list" ]]; then
    shift
    listAlias "$@"
  else
    echo "Error: command not recognised: $1"
  fi
else
  echo "Error: this script should NOT be run as root."
  exit 1
fi
