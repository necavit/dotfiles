function _backup-extdrive {
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  opts="backup remove-old status"
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))  # completes the options
  return 0
}
complete -F _backup-extdrive backup-extdrive
