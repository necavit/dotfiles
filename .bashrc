#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable full color support
if [ "$TERM" == "xterm" ]; then
    # No it isn't, it's gnome-terminal
    export TERM=xterm-256color
fi

#### History environment variables ####
# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

#### Shell options ####
# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
#  update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enables minor spell corrections for the 'cd' command
shopt -s cdspell

# Auto cd's to <dir>, without having to type "cd <dir>"
shopt -s autocd

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories
shopt -s globstar

#### lesspipe ####
# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#### ls color support ####
# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

#### Autocompletion ####
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

#### Source dotfiles ####
# Load the shell dotfiles
for file in ~/.{bash_aliases,bash_env,bash_functions,bash_prompt}; do
  echo "Sourcing file: $file"
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file
