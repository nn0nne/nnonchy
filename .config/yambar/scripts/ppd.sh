#!/bin/sh

# Function to output the current profile in Yambar format
update() {
    PROFILE=$(powerprofilesctl get)
    echo "profile|string|$PROFILE"
    echo ""
}

# Function to cycle profiles: balanced -> performance -> power-saver
cycle() {
    CURRENT=$(powerprofilesctl get)
    case "$CURRENT" in
        balanced)    powerprofilesctl set performance ;;
        performance) powerprofilesctl set power-saver ;;
        *)           powerprofilesctl set balanced ;;
    esac
    update
}

# If an argument is passed, we are cycling; otherwise, we are in a loop
if [ "$1" = "cycle" ]; then
    cycle
else
    while true; do
        update
        sleep 10
    done
fi
