#!/bin/bash

# Define the options
options="Logout\nSleep\nReboot\nPoweroff\nHibernate"

# --- Custom color scheme from your palette ---
BG="#252530FF" # color0 (background)
FG="#cdcdcdFF" # color7 (normal foreground)

SEL_BG="#606079FF" # color8 (selection background)
SEL_FG="#d7d7d7FF" # color15 (selection foreground – bright & readable)

PROMPT_BG="#6e94b2FF" # color4 (prompt background – soft blue)
PROMPT_FG="#252530FF" # color0 (prompt text – dark for contrast)

# Launch wmenu
chosen=$(echo -e "$options" | wmenu -i -p "Action:" \
  -f "JetBrainsMono Nerd Font Mono 10" \
  -l 5 \
  -N "$BG" -n "$FG" \
  -S "$SEL_BG" -s "$SEL_FG" \
  -M "$SEL_BG" -m "$SEL_FG")

case $chosen in
Logout)
  pkill mango
  ;;
Sleep)
  sync && systemctl suspend && swaylock
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
