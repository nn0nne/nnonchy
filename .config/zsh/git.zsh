# git auto fetch
export GIT_AUTO_FETCH_INTERVAL=30
export GIT_AUTO_FETCH_CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/git_fetch_time"
_git_auto_fetch() {
  git rev-parse --is-inside-work-tree &>/dev/null || return 0
  git remote get-url origin &>/dev/null || return 0

  pgrep -f "git fetch --all" >/dev/null && return 0

  local now last_fetch git_dir cache_file

  git_dir=$(git rev-parse --git-dir 2>/dev/null) || return 0
  cache_file="$git_dir/.last_fetch"
  now=$(date +%s)

  if [[ -f "$cache_file" ]]; then
    read -r last_fetch < "$cache_file"
    (( now - last_fetch < GIT_AUTO_FETCH_INTERVAL )) && return 0
  fi

  print -r -- "$now" >| "$cache_file"

  {
    git fetch --all --quiet 2>/dev/null
  } &!
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _git_auto_fetch
