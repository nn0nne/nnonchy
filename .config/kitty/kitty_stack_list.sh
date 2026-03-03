#!/bin/bash

# Debug file
DEBUG_FILE="/tmp/kitty_debug_$$.txt"
echo "Starting script at $(date)" >"$DEBUG_FILE"
echo "KITTY_LISTEN_ON: $KITTY_LISTEN_ON" >>"$DEBUG_FILE"

# Handle abstract socket (starts with @)
if [ -n "$KITTY_LISTEN_ON" ]; then
    # Extract the socket path (remove 'unix:' prefix)
    SOCKET_PATH=$(echo "$KITTY_LISTEN_ON" | cut -d: -f2)
    echo "Socket path: $SOCKET_PATH" >>"$DEBUG_FILE"

    # For abstract sockets, we need to use the @ symbol as-is
    # kitty understands both unix:/path and unix:@abstract formats
    MAIN_SOCKET="$SOCKET_PATH"

    # Test if this socket works
    WINDOW_DATA=$(kitty @ --to unix:$MAIN_SOCKET ls 2>/dev/null)
    if [ -n "$WINDOW_DATA" ]; then
        WINDOW_COUNT=$(echo "$WINDOW_DATA" | jq '[.[] | .tabs[] | .windows[]] | length' 2>/dev/null)
        echo "Socket $MAIN_SOCKET has $WINDOW_COUNT windows" >>"$DEBUG_FILE"

        if [ "$WINDOW_COUNT" -gt 0 ] 2>/dev/null; then
            echo "Using main socket from KITTY_LISTEN_ON: $MAIN_SOCKET" >>"$DEBUG_FILE"
        else
            MAIN_SOCKET=""
        fi
    else
        echo "Failed to get data from KITTY_LISTEN_ON socket" >>"$DEBUG_FILE"
        MAIN_SOCKET=""
    fi
fi

# If KITTY_LISTEN_ON didn't work, try abstract sockets manually
if [ -z "$MAIN_SOCKET" ]; then
    echo "Trying to find abstract sockets..." >>"$DEBUG_FILE"

    # Abstract sockets don't appear in filesystem, so we need to try common patterns
    # Usually Kitty uses @kitty-<PID> format
    for pid in $(pgrep -f "kitty.*--instance-group" | grep -v $$); do
        potential_socket="@kitty-$pid"
        echo "Trying abstract socket: $potential_socket" >>"$DEBUG_FILE"

        WINDOW_DATA=$(kitty @ --to unix:$potential_socket ls 2>/dev/null)
        if [ -n "$WINDOW_DATA" ]; then
            WINDOW_COUNT=$(echo "$WINDOW_DATA" | jq '[.[] | .tabs[] | .windows[]] | length' 2>/dev/null)
            echo "Socket $potential_socket has $WINDOW_COUNT windows" >>"$DEBUG_FILE"

            if [ "$WINDOW_COUNT" -gt 0 ] 2>/dev/null; then
                MAIN_SOCKET="$potential_socket"
                break
            fi
        fi
    done
fi

echo "Selected main socket: $MAIN_SOCKET" >>"$DEBUG_FILE"

if [ -z "$MAIN_SOCKET" ]; then
    echo "No Kitty main instance found" | tee -a "$DEBUG_FILE"
    echo "Debug info saved to $DEBUG_FILE"
    exit 1
fi

# Get the stack windows from the main instance
kitty @ --to unix:$MAIN_SOCKET ls 2>/dev/null | jq -r '
    .[] | 
    .tabs[] | 
    select(.layout == "stack") | 
    .windows[] | 
    "\(.id) \(.title)"
' 2>/dev/null | grep -v "kitty_stack_list.sh" | grep -v "fzf" | fzf --height=100% --reverse --prompt="Select stack window > " | while read -r selected; do
    if [ -n "$selected" ]; then
        window_id=$(echo "$selected" | cut -d' ' -f1)
        echo "Focusing window $window_id via socket $MAIN_SOCKET" >>"$DEBUG_FILE"
        kitty @ --to unix:$MAIN_SOCKET focus-window -m id:$window_id
    fi
done

echo "Debug info saved to $DEBUG_FILE"
