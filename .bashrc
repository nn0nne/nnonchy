#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# blesh setup
[[ $- == *i* ]] &&
  source -- "/usr/share/blesh/ble.sh" --attach=none --rcfile "$HOME/.blerc"

# hide zoxide warning
export _ZO_DOCTOR=0

# Huge history
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a"

# aliases
alias n='NVIM_APPNAME="nonevim" nvim'
alias v='NVIM_APPNAME="nvim" nvim'
alias df="duf"
alias ls="eza -l -F --icons --smart-group"
alias du="dua i"
alias find="fd"
alias grep="rg"
alias cat="bat"
alias y="yazi"
alias mpv="env DRI_PRIME=0 mpv"
alias cp="cpx"

# cd using yazi (yazi go)
function yg() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    zoxide add "$cwd"
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# function to easily use opencde run
ask() {
  opencode run "$*" | rich - --markdown --force-terminal
}

# Use bash-completion, if available, and avoid double-sourcing
[[ $PS1 &&
  ! ${BASH_COMPLETION_VERSINFO:-} &&
  -f /usr/share/bash-completion/bash_completion ]] &&
  . /usr/share/bash-completion/bash_completion

# Foot enable osc7, idk what it is for though XD
osc7_cwd() {
  local strlen=${#PWD}
  local encoded=""
  local pos c o
  for ((pos = 0; pos < strlen; pos++)); do
    c=${PWD:$pos:1}
    case "$c" in
    [-/:_.!\'\(\)~[:alnum:]]) o="${c}" ;;
    *) printf -v o '%%%02X' "'${c}" ;;
    esac
    encoded+="${o}"
  done
  printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}
PROMPT_COMMAND="${PROMPT_COMMAND%}; osc7_cwd"

## editor default to neovim
export EDITOR=nvim

## setting terminal to ~kitty~ foot
export TERMINAL=foot

## ripgrep config for mini.pick
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

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

# starship setup
eval "$(starship init bash)"

# blesh attach
[[ ! ${BLE_VERSION-} ]] || ble-attach

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# fnm (fast node manager) setup
eval "$(fnm env --use-on-cd --shell bash)"

# Added by Hugging Face CLI installer
export PATH="$HOME/.local/bin:$PATH"

# Better completion UX
bind 'TAB:menu-complete'
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'

# zoxide setup
eval "$(zoxide init bash --cmd cd)"
