# Centralizes config/cache/data locations
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="~/.local/share:/usr/share"

# Default editor used by git, crontab, etc.
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"

# Pager
if command -v bat >/dev/null 2>&1; then
  export PAGER="bat -l man -p"
fi

# GPG
export GPG_TTY=$(tty)

# STARSHIP
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"

# Personal binaries/scripts
export PATH="$HOME/.local/bin:$PATH"

# Flutterfire
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Personal .env
[ -f $ZDOTDIR/.zsh_env ] && source $ZDOTDIR/.zsh_env

# For rust/cargo compilation
export CARGO_BUILD_JOBS=4
