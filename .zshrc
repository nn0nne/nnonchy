# Start configuration added by Zim Framework install {{{
#
# User configuration sourced by interactive shells
#


# setup mise
eval "$(/usr/bin/mise activate zsh)"

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
# bindkey -v

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
# alias nonevim="NVIM_APPNAME='nonevim' nvim"

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
# alias "?"="opencode run '$*'"

# cd via yazi
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
eval "$(zoxide init zsh --cmd cd)"

# starship setup
eval "$(starship init zsh)"

# Added by Hugging Face CLI installer
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH":"$HOME/.pub-cache/bin"

export SDL_GAMECONTROLLERCONFIG="0300f98c63250000750500001101000095711397,Ipega PG 9099,platform:Linux,a:b0,b:b1,x:b3,y:b4,back:b10,start:b11,guide:b12,leftshoulder:b6,rightshoulder:b7,leftstick:b13,rightstick:b14,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:a5,righttrigger:a4,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,"
