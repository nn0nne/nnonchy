alias n="~/.config/kitty/scripts/kitty_none.sh"
alias none="~/.config/kitty/scripts/kitty_none.sh"
alias v="~/.config/kitty/scripts/kitty_nvim.sh"

alias nzsh="n $ZDOTDIR/.zshrc"
alias szsh="source $ZDOTDIR/.zshrc"

alias df="duf"
alias ls="eza -l -F --icons --smart-group"
alias du="dua i"
alias find="fd"
alias grep="rg --color=auto"
alias cat="bat"
alias y="yazi"
alias mpv="nice -n 19 env MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE=1 mpv"
alias celluloid="env DRI_PRIME=0 celluloid"
alias cp="cpx"
alias ping="prettyping"
alias lg="lazygit"

### zim-utility ###

if (( ${+commands[aria2c]} )); then
  alias get='aria2c --max-connection-per-server=5 --continue'
elif (( ${+commands[axel]} )); then
  alias get='axel --num-connections=5 --alternate'
elif (( ${+commands[wget]} )); then
  alias get='wget --continue --progress=bar --timestamping'
elif (( ${+commands[curl]} )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi

if [[ -z ${NO_COLOR} ]]; then

  # grep colours
  if (( ! ${+GREP_COLOR} )) export GREP_COLOR='37;45'               #BSD
  if (( ! ${+GREP_COLORS} )) export GREP_COLORS="mt=${GREP_COLOR}"  #GNU
  if [[ ${OSTYPE} == (openbsd|solaris)* ]]; then
    if (( ${+commands[ggrep]} )) alias grep='ggrep --color=auto'
  elif (( ${+commands[grep]} )); then
    alias grep='grep --color=auto'
  fi

  # less colours
  if (( ! ${+LESS_TERMCAP_mb} )) export LESS_TERMCAP_mb=$'\E[1;31m'  # Begins blinking.
  if (( ! ${+LESS_TERMCAP_md} )) export LESS_TERMCAP_md=$'\E[1;31m'  # Begins bold.
  if (( ! ${+LESS_TERMCAP_me} )) export LESS_TERMCAP_me=$'\E[0m'     # Ends mode.
  if (( ! ${+LESS_TERMCAP_ue} )) export LESS_TERMCAP_ue=$'\E[0m'     # Ends underline.
  if (( ! ${+LESS_TERMCAP_us} )) export LESS_TERMCAP_us=$'\E[1;32m'  # Begins underline.
fi

if whence dircolors >/dev/null && ls --version &>/dev/null; then
  # GNU

  # ls aliases
  alias lx='ll -X' # long format, sort by extension
  if [[ -z ${NO_COLOR} ]]; then
    # ls colours
    if [[ -s ${HOME}/.dir_colors ]]; then
      eval "$(dircolors --sh ${HOME}/.dir_colors)"
    elif (( ! ${+LS_COLORS} )); then
      export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43'
    fi
    # alias ls='ls --group-directories-first --color=auto'
  else
    # alias ls='ls --group-directories-first'
  fi

  # Always wear a condom
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
else
  # BSD

  if [[ -z ${NO_COLOR} ]]; then
    # ls colours
    export CLICOLOR=1
    if (( ! ${+LSCOLORS} )) export LSCOLORS=ExfxcxdxbxGxDxabagacad
    # Stock OpenBSD ls does not support colors at all, but colorls does.
    if [[ ${OSTYPE} == openbsd* && ${+commands[colorls]} -ne 0 ]]; then
      # alias ls=colorls
    fi
  fi
fi

if (( ${+commands[safe-rm]} && ! ${+commands[safe-rmdir]} )); then
  alias rm=safe-rm
fi
