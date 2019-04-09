#!/bin/bash

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Enable Python argcomplete
py_autocomplete_file="/etc/bash_completion.d/python-argcomplete.sh"
if [ -f "$py_autocomplete_file" ]; then
  . $py_autocomplete_file
fi

#### Source dotfiles ####
# Load the shell dotfiles
for file in ~/.{bash_aliases,bash_shortcut,bash_env,bash_functions,bash_prompt}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
