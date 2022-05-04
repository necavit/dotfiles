#!/bin/bash

# ls aliases
alias ls="ls --color=auto --group-directories-first"
alias la="ls -lash"
alias ll="ls -lsh"
alias l="ls -F"

# Upper directory aliase
alias ..="cd .."

# Nautilus alias
alias nau="nautilus . &"

# git aliases
alias dev="git checkout dev"
alias pull="git pull"
alias prune="git remote prune origin"
alias push="git push && git push --tags"
