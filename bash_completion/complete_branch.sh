function _branch {
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  opts="fix feature release"
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))  # completes the options
  return 0
}
complete -F _branch branch
