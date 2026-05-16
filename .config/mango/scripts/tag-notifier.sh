#!/bin/bash

# Fetch the status from MangoWM's IPC
status_output=$(mmsg -gt)

# Parse out the active tag and its window count
# Looks for lines starting with your monitor (eDP-1) and 'tag', where the 4th column is 1 (Active)
read -r active_tag window_count <<<$(echo "$status_output" | awk '$1 == "eDP-1" && $2 == "tag" && $4 == 1 {print $3, $5}')

# Send the notification if a tag was found
if [ -n "$active_tag" ]; then
  message="$active_tag"
  if [ "$window_count" -gt 0 ]; then
    message="$message-$window_count"
  else
    message="$message-0"
  fi

  notify-send -a "MangoWM" -i dialog-information "$message"
else
  notify-send -a "MangoWM" -u critical "Error" "Could not parse MangoWM tags."
fi
