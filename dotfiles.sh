#!/bin/bash

# Installs the dotfiles and utility binaries by syncing the repo with
# the $HOME directory.
# Credit: https://github.com/mathiasbynens/dotfiles

cd "$(dirname "${BASH_SOURCE}")"

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

function checkAndInstall {
	echo -n "  Checking package: $1"
	if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		echo -e "\t\t${red}Not installed!${reset}"
		echo "  executing: sudo apt-get install $1"
		sudo apt-get install $1
	else
		echo -e "\t\t${green}Ok${reset}"
	fi
}

function checkPipAndInstall {
	echo -n "  Checking Python package: $1"
	if [ $(pip list | grep -c "$1") -eq 0 ]; then
		echo -e "\t\t${red}Not installed!${reset}"
		echo "  executing: sudo pip install $1"
		sudo pip install $1
	else
		echo -e "\t\t${green}Ok${reset}"
	fi
}

function checkDependencies {
	# general (apt-get) dependencies
	echo "Checking dependencies..."
	dependencies=( git python python-pip )
	for i in "${dependencies[@]}"; do
		checkAndInstall $i
	done

	# python (pip) dependencies
	echo "Checking Python (pip) dependencies..."
	py_dependencies=( argcomplete )
	for i in "${py_dependencies[@]}"; do
		checkPipAndInstall $i
	done
}

function enablePythonAutocomplete {
	# NOTE: remember that Pip and 'argcomplete' must be installed as dependencies
	echo "Enabling Python argcompletion..."
	if [ ! -f /etc/bash_completion.d/python-argcomplete.sh ]; then
		sudo activate-global-python-argcomplete --dest=/etc/bash_completion.d
	fi
}

function copyFilesToHome {
	echo "Syncing dotfiles to ~/ ..."
	rsync --exclude ".git/" --exclude "dotfiles.sh" --exclude "bin/" \
		--exclude "img/" --exclude "README.md" --exclude "LICENSE" \
		-avh --no-perms . ~
}

function symlinkBinScripts {
	# setup ~/bin directory with symlinks to the executable files in this
	# repository, symlink them and make them executable
	echo "Setting up ~/bin ..."
	mkdir -p ~/bin

	# Bash scripts
	for file in $(pwd)/bin/*.sh; do
		chmod u+x $file
		name=$(basename $file)
		ln -sf $file ~/bin/${name%.*}
	done
	unset file
	unset name

	# Python scripts
	for file in $(pwd)/bin/*.py; do
		chmod u+x $file
		name=$(basename $file)
		ln -sf $file ~/bin/${name%.*}
	done
	unset file
	unset name
}

function generateCompletions {
	completionFile=~/.bash_completion
	echo "Generating custom Bash completions into $completionFile ..."
	cat bash_completion/*.sh > $completionFile
}

function setupDotFiles {
	checkDependencies        # apt-get and Python dependencies
	enablePythonAutocomplete # argument autocompletion for Python scripts
	copyFilesToHome          # syncronize the configuration dotfiles
	symlinkBinScripts        # setup the scripts in the ~/bin directory
	generateCompletions

	echo "${red}Remember to ${reset}source ~/.bashrc${red} in order to finnish the dotfiles setup.${reset}"
}

#### MAIN SCRIPT entry point ####

if [ "$1" == "--yes" -o "$1" == "-y" ]; then
	setupDotFiles
else
	read -p "This will overwrite existing files in your home directory. Continue? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		setupDotFiles
	fi
fi

# cleanup all the Bash functions defined here!
unset setupDotFiles
unset symlinkBinScripts
unset enablePythonAutocomplete
unset checkDependencies
unset checkAndInstall
unset checkPipAndInstall
