#!/bin/bash

# Installs the dotfiles and utility binaries by syncing the repo with
# the $HOME directory.
# Credit: https://github.com/mathiasbynens/dotfiles

cd "$(dirname "${BASH_SOURCE}")"

# useful colored output commands
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

function copyFilesToHome {
	echo "Syncing dotfiles to ~/ ..."
	rsync --exclude ".git/" --exclude "dotfiles.sh" --exclude "bin/" \
		--exclude "img/" --exclude "README.md" --exclude "LICENSE" \
		--exclude "bash_completion/" \
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

function setupDotFiles {
	copyFilesToHome          # syncronize the configuration dotfiles
	symlinkBinScripts        # setup the scripts in the ~/bin directory

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
