#!/usr/bin/env bash
set -euo pipefail

SESSION_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty/sessions"
EXT=".kitty-session"

mkdir -p "$SESSION_DIR"

case "${1:-open}" in
  open)
    choice=$(
      {
        printf '%s\n' '+ Create new session'
        find "$SESSION_DIR" -maxdepth 1 -type f \
          -name "*${EXT}" -printf '%f\n' |
          sed "s/${EXT}$//" |
          sort
      } | fzf --prompt='Kitty session > ' \
              --height=60% --layout=reverse \
              --border --exit-0
    ) || exit 0

    [[ -n "$choice" ]] || exit 0

    if [[ "$choice" == "+ Create new session" ]]; then
      "$0" create
    else
      kitten @ action goto_session "$SESSION_DIR/$choice$EXT"
    fi
    ;;

  create)
    name=$(fzf --print-query --prompt='New session name > ' \
      </dev/tty 2>/dev/null | head -n 1)

    [[ -n "$name" ]] || exit 0
    name="${name##*/}"
    name="${name%$EXT}"

    [[ "$name" != "." && "$name" != ".." ]] || exit 1

    file="$SESSION_DIR/$name$EXT"

    if [[ -e "$file" ]]; then
      printf 'Session already exists: %s\n' "$file" >&2
      exit 1
    fi

    printf 'layout tall\nlaunch\n' > "$file"
    kitten @ action goto_session "$file"
    ;;

  save)
    name=$(fzf --print-query --prompt='Save session as > ' \
      </dev/tty 2>/dev/null | head -n 1)

    [[ -n "$name" ]] || exit 0
    name="${name##*/}"
    name="${name%$EXT}"

    [[ "$name" != "." && "$name" != ".." ]] || exit 1

    file="$SESSION_DIR/$name$EXT"

    if [[ -e "$file" ]]; then
      printf 'Session already exists: %s\n' "$file" >&2
      exit 1
    fi

    kitten @ action save_as_session --use-foreground-process "$file"
    ;;

  *)
    printf 'Usage: %s {open|create|save}\n' "$0" >&2
    exit 2
    ;;
esac

