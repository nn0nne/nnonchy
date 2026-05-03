#!/bin/bash
swayidle -w \
  timeout 300 'swaylock --clock --indicator -f && pkill yambar; yambar &' \
  timeout 600 'wlr-randr --output eDP-1 --off && pkill yambar' \
  resume 'wlr-randr --output eDP-1 --on; yambar &' \
  timeout 1800 'systemctl suspend' \
  before-sleep 'swaylock --clock --indicator'
