#!/bin/bash

export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

#### Source dotfiles ####
# Load the shell dotfiles
for file in ~/.{bash_aliases,bash_shortcut,bash_env,bash_functions,bash_prompt}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
