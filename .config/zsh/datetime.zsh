zmodload zsh/datetime

# 1. Record start time right before command executes
function _transient_preexec() {
  _CMD_START_TIME=$EPOCHREALTIME
}

function _transient_precmd() {
  local duration_str=""
  
  if [[ -n $_CMD_START_TIME ]]; then
    local elapsed=$(( EPOCHREALTIME - _CMD_START_TIME ))
    local duration_ms=$(( int(elapsed * 1000) ))
    unset _CMD_START_TIME

    # Format execution time using Starship
    duration_str=$(starship module cmd_duration --cmd-duration "$duration_ms")
    
    # Add a space before the duration text if it's not empty
    if [[ -n "$duration_str" ]]; then
      duration_str=" ${duration_str}"
    fi
  fi

  # Render character module and cache the snapshot for the transient prompt
  local char_str=$(starship module character)
  
  # Format date components with ANSI truecolor escape sequences
  local c_overlay=$'%{\e[38;2;57;53;82m%}'
  local c_iris=$'%{\e[38;2;196;167;231m%}'
  local c_foam=$'%{\e[38;2;156;207;216m%}'
  local c_rose=$'%{\e[38;2;234;154;151m%}'
  local c_reset=$'%{\e[0m%}'

  local day_str="${c_foam}0$(date +"%u")${c_reset}"
  local date_str="${c_iris}$(date +"%d%m")${c_reset}"
  local time_str="${c_foam}$(date +"%H%M")${c_reset}"
  local cat_str="${c_rose}(•˕ •マ.ᐟ${c_reset}"

  # Cache the complete styled string for the transient prompt
  _CACHED_TRANSIENT_PROMPT=$'\n'"${day_str}${date_str}${time_str} ${cat_str}${duration_str}"$'\n'"${char_str}"
}

# Register Zsh hooks
autoload -Uz add-zsh-hook
add-zsh-hook preexec _transient_preexec
add-zsh-hook precmd _transient_precmd

# 3. Use the cached evaluation for the transient prompt
TRANSIENT_PROMPT_TRANSIENT_PROMPT='${_CACHED_TRANSIENT_PROMPT}'
TRANSIENT_PROMPT_TRANSIENT_RPROMPT=''
