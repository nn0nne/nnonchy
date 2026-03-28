#!/usr/bin/env bash

pkill waybar; waybar --config ~/.config/waybar/config-mango.jsonc >/dev/null 2>&1 &
