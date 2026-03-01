#!/bin/bash

# Options with Nerd Font icons
options="  Lock
󰍃  Logout
󰤄  Sleep
󰜉  Reboot
  Poweroff
󰒲  Hibernate"

# --- Custom color scheme ---
BG="#252530FF"
FG="#cdcdcdFF"

SEL_BG="#606079FF"
SEL_FG="#d7d7d7FF"

PROMPT_BG="#6e94b2FF"
PROMPT_FG="#252530FF"

chosen=$(
    echo -e "$options" | rofi -dmenu \
        -i \
        -p "Action:" \
        -lines 5 \
        -font "JetBrainsMono Nerd Font Mono 10" \
        -theme-str "
    * {
      background: $BG;
      foreground: $FG;
      selected-background: $SEL_BG;
      selected-foreground: $SEL_FG;
    }
    window {
      background-color: $BG;
      height: 30%;
    }
    prompt {
      background-color: $PROMPT_BG;
      text-color: $PROMPT_FG;
      padding: 6px;
    }
    listview {
      lines: 5;
      spacing: 4px;
    }
    element {
      padding: 6px;
    }
    element selected {
      background-color: $SEL_BG;
      text-color: $SEL_FG;
    }
  "
)

# Strip icon + extra spaces, keep only the word
action=$(echo "$chosen" | awk '{print $2}')

case "$action" in
Logout)
    pkill mango
    ;;
Sleep)
    sync && systemctl suspend && swaylock --clock --indicator
    ;;
Lock)
    sync && swaylock --clock --indicator
    ;;
Reboot)
    sync && systemctl reboot
    ;;
Poweroff)
    sync && systemctl poweroff
    ;;
Hibernate)
    sync && systemctl hibernate
    ;;
*)
    exit 0
    ;;
esac
