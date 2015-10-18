#!/bin/bash

# ls aliases
alias ls="ls --color=auto --group-directories-first"
alias la="ls -lash"
alias ll="ls -lsh"
alias l="ls -F"

# Pacman aliases
alias pac-upgrade="sudo pacman -Syu"          # Synchronize with repositories and then upgrade packages that are out of date on the local system.
alias pac-install="sudo pacman -S"            # Install specific package(s) from the repositories
alias pac-install-file="sudo pacman -U"       # Install specific package not from the repositories but from a file 
alias pac-remove-preserve="sudo pacman -R"    # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pac-remove="sudo pacman -Rns"           # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pac-pkginfo-repo="pacman -Si"           # Display information about a given package in the repositories
alias pac-search="pacman -Ss"                 # Search for package(s) in the repositories
alias pac-pkginfo-local="pacman -Qi"          # Display information about a given package in the local database
alias pac-search-local="pacman -Qs"           # Search for package(s) in the local database

# Packer aliases
alias packer-upgrade="packer -Syu"
alias packer-install="packer -S"
alias packer-pkginfo="packer -Si"
alias packer-search="packer -Ss"
