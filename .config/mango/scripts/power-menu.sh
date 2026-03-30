#!/bin/bash

# Options with Nerd Font icons
options="Lock
Logout
Sleep
Reboot
Poweroff
Hibernate"

# --- Custom color scheme ---
BG="#252530FF"
FG="#cdcdcdFF"

SEL_BG="#606079FF"
SEL_FG="#d7d7d7FF"

PROMPT_BG="#6e94b2FF"
PROMPT_FG="#252530FF"

chosen=$(
    echo -e "$options" | fuzzel --dmenu \
        --lines 5
)

# Strip icon + extra spaces, keep only the word
action=$("$chosen")

case "$action" in
Logout)
    mmsg -q
    ;;
Sleep)
    sync
    systemctl suspend
    swaylock --clock --indicator
    ;;
Lock)
    sync
    swaylock --clock --indicator
    ;;
Reboot)
    sync
    pkexec umount -l /mnt/external-harddrive/ || true
    systemctl reboot
    ;;
Poweroff)
    sync
    pkexec umount -l /mnt/external-harddrive/ || true
    systemctl poweroff
    ;;
Hibernate)
    sync
    systemctl hibernate
    ;;
*)
    exit 0
    ;;
esac
