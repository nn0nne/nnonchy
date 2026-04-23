#!/bin/sh

# --- Bluetooth Logic (Same as before, as it worked) ---
if bluetoothctl show | grep -q "Powered: yes"; then
    if bluetoothctl info | grep -q "Connected: yes"; then
        echo "bt_status|string|󰂱"
    else
        echo "bt_status|string|󰂯"
    fi
else
    echo "bt_status|string|󰂲"
fi

# --- WiFi Logic (Using iwd/iwctl) ---
# Note: Replace 'wlan0' with your interface name if it's different (check 'ip link')
SSID=$(iwctl station wlan0 show | grep "Connected network" | awk '{print $3}')

if [ -z "$SSID" ]; then
    echo "wifi_status|string|󰤮"
else
    echo "wifi_status|string|󰤨"
fi

# --- Power Profile Logic (Using TLP) ---
# TLP doesn't have 'profiles' like PPD, it usually switches between AC and BAT.
# We'll show if it's currently in AC (performance) or BAT (save) mode.
TLP_MODE=$(tlp-stat -s | grep "Mode" | awk '{print $3}')

case $TLP_MODE in
    ac)      echo "power_icon|string|󰓅" ;; # High performance icon
    battery) echo "power_icon|string|󰾆" ;; # Power save icon
    *)       echo "power_icon|string|󰈐" ;;
esac

echo ""
