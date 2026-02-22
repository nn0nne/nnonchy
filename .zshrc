# Start configuration added by Zim Framework install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh
# }}} End configuration added by Zim Framework install

## not needed but keeping it anyway
# source /usr/share/cachyos-zsh-config/cachyos-config.zsh

#################################
### none's config starts here ###
#################################


## alias stuff
alias n='NVIM_APPNAME="nonevim" nvim'
alias v='NVIM_APPNAME="nvim" nvim'
alias m='NVIM_APPNAME="nvim-minimax" nvim'
alias cd="z"
alias df="duf"
alias ls="eza -l -F --icons --smart-group"
alias du="dua i"
alias find="fd"
alias grep="rg"
alias cat="bat"
alias y="yazi"
alias mpv="env DRI_PRIME=0 mpv"
alias celluloid="env DRI_PRIME=0 celluloid"
alias cp="cpx"
alias nvtldr="navi --tldr"
# alias "?"="opencode run '$*'"

# cd via yazi
function yg() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# function to easily use opencde run
'ask'() {
    opencode run "$*" | rich - --markdown --force-terminal
}

# osc7 for foot
function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd


## neovim stuff
export EDITOR=nvim

## setting terminal to kitty
export TERMINAL=foot

## flutter/android development
export ANDROID_HOME=$HOME/android-sdk
export ANDROID_SDK_ROOT=$HOME/android-sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin/:$PATH
export JAVA_HOME=/usr/lib/jvm/java-25-openjdk
export CHROME_EXECUTABLE=/usr/bin/brave

# fzf config
# export FZF_DEFAULT_OPTS="--height 80% --layout reverse --border --info inline --cycle --scroll-off 3 --prompt '❯ ' --pointer '▶' --marker '✓' --ansi --bind 'ctrl-j:down,ctrl-k:up,ctrl-u:preview-page-up,ctrl-d:preview-page-down,?:toggle-preview'"
export FZF_DEFAULT_OPTS="--height 80% --layout reverse --border --info inline --cycle --scroll-off 3 --prompt '❯ ' --pointer '▶' --marker '✓' --ansi --bind 'ctrl-j:down,ctrl-k:up,ctrl-u:preview-page-up,ctrl-d:preview-page-down,?:toggle-preview' \
--color='bg+:#252530,bg:#141415,spinner:#f5cb96,hl:#d8647e' \
--color='fg:#cdcdcd,header:#d8647e,info:#aeaed1,pointer:#8ba9c1' \
--color='marker:#7fa563,fg+:#d7d7d7,prompt:#bb9dbd,hl+:#e08398'"

export FZF_CTRL_T_OPTS="--preview 'if [[ -d {} ]]; then eza --tree --level=2 {} 2>/dev/null || ls {}; else bat --style=numbers --color=always --line-range :300 {} 2>/dev/null || sed -n \"1,300p\" {}; fi'"

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window 'down:3:wrap' --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)+abort,ctrl-e:toggle-sort'"

export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git || find . -type d"

export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 {} 2>/dev/null || ls {}'"


### belows are setups ###

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# zoxide setup
eval "$(zoxide init zsh)"

# starship setup
eval "$(starship init zsh)"

# fnm (fast node manager) setup
eval "$(fnm env --use-on-cd --shell zsh)"

# Added by Hugging Face CLI installer
export PATH="$HOME/.local/bin:$PATH"

# slumber setup
source <(COMPLETE=zsh slumber)
