#!/bin/bash

if pgrep -x "gammastep" >/dev/null; then
  # It's running → kill it
  pkill -x gammastep
  notify-send -a "GammaStep" "GammaStep disabled" -t 2000
else
  # It's not running → start it
  gammastep -c ~/.config/gammastep/config.ini &
  notify-send -a "GammaStep" "GammaStep enabled" -t 2000
fi
