#!/bin/bash

# Define the options
options="Logout\nReboot\nPoweroff\nHibernate"

# Colors (Gruvbox-style based on your input)
BG="#1d2021FF"
FG="#d4be98FF"
SEL_BG="#d4be98FF"
SEL_FG="#1d2021FF"
# Prompt Colors (We'll make the prompt stand out with different colors)
PROMPT_BG="#458588FF" # A nice Blue to make the "Action:" distinct
PROMPT_FG="#1d2021FF"

# Launch wmenu
chosen=$(echo -e "$options" | wmenu -i -p "Action:" \
  -f "JetBrainsMono Nerd Font Mono 10" \
  -l 4 \
  -N "$BG" -n "$FG" \
  -S "$SEL_BG" -s "$SEL_FG" \
  -M "$SEL_BG" -m "$SEL_FG")

case $chosen in
Logout)
  pkill mangowc
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
