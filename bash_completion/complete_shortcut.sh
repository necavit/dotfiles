function _shortcut {
  local cur prev opts notes
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  opts="add list remove"
  aliases=$(shortcut list --complete)

  case "${prev}" in
    remove|list)
      COMPREPLY=( $(compgen -W "${aliases}" -- ${cur}) )
      return 0
      ;;
    *)
      # add foo FILE
      if [[ "${COMP_WORDS[COMP_CWORD-2]}" == "add" ]]; then
        COMPREPLY=( $(compgen -f ${cur}) )
        return 0
      fi
      ;;
  esac

  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))  # completes the options
  return 0
}
complete -F _shortcut shortcut
