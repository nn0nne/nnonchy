#!/bin/sh

# Check if the process exists
if pgrep -f "Yambar-Inhibit" > /dev/null; then
    echo "icon|string|󰈈"
else
    echo "icon|string|󰈉"
fi

# The mandatory empty line for Yambar
echo ""
