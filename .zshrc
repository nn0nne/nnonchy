# setup mise
eval "$(/usr/bin/mise activate zsh)"

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

bindkey -e # set to emacs for yazi shell drop to not be vi-mode

# Prompt for spelling correction of commands.
setopt CORRECT
# Customize spelling correction prompt.
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

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

## alias stuff
alias n="~/.config/kitty/scripts/kitty_none.sh"
alias none="~/.config/kitty/scripts/kitty_none.sh"
alias v="~/.config/kitty/scripts/kitty_nvim.sh"

alias nzsh="n ~/.zshrc"
alias szsh="source ~/.zshrc"
alias df="duf"
alias ls="eza -l -F --icons --smart-group"
alias du="dua i"
alias find="fd"
alias grep="rg"
alias cat="bat"
alias y="yazi"
alias mpv="nice -n 19 env MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE=1 mpv"
alias celluloid="env DRI_PRIME=0 celluloid"
alias cp="cpx"
alias ping="prettyping"

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
export CHROME_EXECUTABLE=/usr/bin/brave-origin-beta

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

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# zoxide setup
eval "$(zoxide init zsh --cmd cd)"

# starship setup
eval "$(starship init zsh)"

# Added by Hugging Face CLI installer
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"

[ -f ~/.zsh_env ] && source ~/.zsh_env
