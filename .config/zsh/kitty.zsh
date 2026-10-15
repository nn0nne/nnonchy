# =========================================================
# kitty session auto-save (tmux-continuum style)
# =========================================================
# Periodically saves the kitty session the current window belongs to, capturing
# any running foreground commands (editors, `npm run dev`, ...) so they are
# re-run when the session is restored. Restore with the `kitty_mod+s>g` picker,
# `kitty --session <file>`, or the `kresume` launcher.
#
# Requires kitty shell integration (loaded at the top of .zshrc) for
# `--use-foreground-process` to record commands.

# Seconds between auto-saves.
typeset -g KITTY_AUTOSAVE_INTERVAL=${KITTY_AUTOSAVE_INTERVAL:-300}
# Where session files live (matches the kitty.conf save_as_session --base-dir).
typeset -g KITTY_SESSION_DIR=${KITTY_SESSION_DIR:-$HOME/.local/share/kitty/sessions}

_kitty_autosave() {
    [[ -n ${KITTY_LISTEN_ON:-} ]] || return 0
    command -v kitty >/dev/null 2>&1 || return 0
    command -v jq >/dev/null 2>&1 || return 0
    [[ -d $KITTY_SESSION_DIR ]] || return 0

    # Throttle first (cheap) so every prompt doesn't pay for the kitty @ calls.
    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/kitty-autosave"
    local now=$EPOCHREALTIME
    if [[ -r $cache ]]; then
        local last
        read -r last < "$cache" 2>/dev/null
        [[ -n $last ]] && (( ${now%.*} - ${last%.*} < KITTY_AUTOSAVE_INTERVAL )) && return 0
    fi

    # Which session does this window belong to? (empty when not in a session)
    local name
    name=$(command kitty @ --to "$KITTY_LISTEN_ON" ls --self 2>/dev/null \
        | command jq -r '[.[]|.tabs[]|.windows[]|select(.is_self)][0].session_name // empty' 2>/dev/null)
    [[ -n $name ]] || return 0

    local file="$KITTY_SESSION_DIR/$name.kitty-session"
    [[ -f $file ]] || return 0

    # Reset the throttle timer now that we've decided to (attempt to) save.
    print -r -- "$now" >| "$cache"

    # Save only this session, keeping any running foreground command.
    {
        command kitty @ --to "$KITTY_LISTEN_ON" save_as_session \
            --use-foreground-process \
            --match="session:^${name}$" \
            --save-only \
            "$file" 2>/dev/null
    } &!
}

autoload -Uz add-zsh-hook && add-zsh-hook precmd _kitty_autosave
