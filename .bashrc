#
# ~/.bashrc
#
# necavit@arrakis (Arch)
# July 2015

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Shell options
shopt -s cdspell   # Enables minor spell corrections for the 'cd' command

# Prompt customisation
# necavit prompt:
PS1="\[\033[38;5;7m\]\t\[$(tput sgr0)\]\[\033[38;5;15m\] [\[$(tput sgr0)\]\[\033[38;5;14m\]\u\[$(tput sgr0)\]\[\033[38;5;6m\]@\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;12m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]]\\$\[$(tput sgr0)\] "
# original Arch installation prompt:
#PS1='[\u@\h \W]\$ '

# Aliases file
aliases_file=~/.bash_aliases
if [[ -f $aliases_file ]]; then
  . $aliases_file
fi

# Environment variables file
env_file=~/.bash_env
if [[ -f $env_file ]]; then
  . $env_file
fi
