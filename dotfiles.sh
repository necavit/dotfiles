#!/bin/bash

# Installs the dotfiles and utility binaries by syncing the repo with
# the $HOME directory.
# Credit: https://github.com/mathiasbynens/dotfiles

cd "$(dirname "${BASH_SOURCE}")"

#git pull origin master

function installDotFiles() {
	echo "Syncing dotfiles to ~/ ..."
	rsync --exclude ".git/" --exclude "dotfiles.sh" --exclude "bin/" \
		--exclude "img/" --exclude "README.md" --exclude "LICENSE" \
		-avh --no-perms . ~

	# setup ~/bin directory with symlinks to the executable files in this
	# repository, symlink them and make them executable
	echo "Setting up ~/bin ..."
	mkdir -p ~/bin
	for file in $(pwd)/bin/*.sh; do
		chmod u+x $file
		name=$(basename $file)
		ln -sf $file ~/bin/${name%.*}
	done
	unset file
	unset name

	# autolink this same executable in ~/bin to be able to execute it whenever
	if [ ! -h ~/bin/dotfiles ]; then
		ln -s $(pwd)/dotfiles.sh ~/bin/dotfiles
	fi

	echo "Remember to source ~/.bashrc in order to finnish the dotfiles setup."
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	installDotFiles
else
	read -p "This will overwrite existing files in your home directory. Continue? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		installDotFiles
	fi
fi
unset installDotFiles
