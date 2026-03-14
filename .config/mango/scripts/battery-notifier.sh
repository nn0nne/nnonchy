#!/usr/bin/env bash

# WARNING: My current implementation use -r to replace the notification sent by notify-send based on the notify-send's id
# (see line 18, 20, and 26)
# The number is pretty large so I don't think it will cause problems though if it is then just make it larger 😊

filename=$(basename "$0")

# shoutout to https://stackoverflow.com/a/15740548
kill $(pgrep -f $filename | /usr/bin/grep -v ^$$\$)

while true; do

    percentage=$(cat /sys/class/power_supply/BAT1/capacity)
    status=$(cat /sys/class/power_supply/BAT1/status)

    if [[ $status == "Discharging" ]]; then
        if [[ $percentage -le 15 ]]; then
            notify-send -r 9999991 -u critical "Critical" "Battery is currently at: $percentage%"
        elif [[ $percentage -le 30 ]]; then
            notify-send -r 9999991 -u critical "Warning" "Battery is currently at: $percentage%"
        fi
    fi

    if [[ $status == "Charging" ]]; then
        if [[ $percentage == 100 ]]; then
            notify-send -r 9999991 "Full" "Battery is currently at: $percentage%"
        fi
    fi

    sleep 60

done
