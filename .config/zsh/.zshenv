# Centralizes config/cache/data locations
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="~/.local/share:/usr/share"

[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"

# Default editor used by git, crontab, etc.
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"

# Pager
if command -v bat >/dev/null 2>&1; then
    # export PAGER="bat -l man -p"
    export PAGER="bat --paging=always"
    # export PAGER="nvim -R -c 'set buftype=nofile bufhidden=hide noswapfile' -"
    # export PAGER='nvim -R +set\ noai\ nocin\ nosmartindent\ scrollback=1000000'
    export MANPAGER="nvim +Man!"
fi

# GPG
export GPG_TTY=$(tty)

# STARSHIP
# The Rosé Pine Moon palette is expressed as 24-bit truecolor hexes, which GUI
# terminals render but the Linux console (TERM=linux, 16 colours) ignores.
# For the console, derive a variant config whose palette references ANSI colour
# names instead, so it renders through the vconsole palette. Generated from the
# main config so everything except the palette stays a single source.
case "${TERM:-}" in
linux*)
    _starship_src="$XDG_CONFIG_HOME/starship.toml"
    _starship_tty="$XDG_CACHE_HOME/starship/starship.tty.toml"
    if [ ! -f "$_starship_tty" ] || [ "$_starship_src" -nt "$_starship_tty" ]; then
        mkdir -p "$(dirname "$_starship_tty")"
        awk '/^\[palettes\.rose-pine-moon\]/{exit} {print}' "$_starship_src" > "$_starship_tty"
        cat >> "$_starship_tty" <<'STARSHIP_TTY_PALETTE'
[palettes.rose-pine-moon]
love = 'red'
gold = 'yellow'
rose = 'cyan'
pine = 'blue'
foam = 'green'
iris = 'purple'
STARSHIP_TTY_PALETTE
    fi
    export STARSHIP_CONFIG="$_starship_tty"
    unset _starship_src _starship_tty
    ;;
*)
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
    ;;
esac

# Personal binaries/scripts
export PATH="$HOME/.local/bin:$PATH"

# Flutterfire
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Personal .env
[ -f $ZDOTDIR/.zsh_env ] && source $ZDOTDIR/.zsh_env

# For rust/cargo compilation
export CARGO_BUILD_JOBS=4
