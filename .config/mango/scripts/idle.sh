#!/bin/bash
swayidle -w \
  timeout 300 'swaylock --clock --indicator -f && pkill yambar; yambar' \
  timeout 600 'wlr-randr --output eDP-1 --off && pkill yambar' \
  resume 'yambar & wlr-randr --output eDP-1 --on' \
  timeout 1800 'systemctl suspend' \
  before-sleep 'swaylock --clock --indicator'
