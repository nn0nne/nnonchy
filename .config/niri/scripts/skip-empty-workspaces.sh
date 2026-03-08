#!/bin/bash

DIRECTION=$1 # "up" or "down"
WORKSPACES=$(niri msg -j workspaces)

# 1. Get the current workspace index (idx)
CURRENT_IDX=$(echo "$WORKSPACES" | jq -r '.[] | select(.is_focused == true) | .idx')

# 2. Get a sorted list of all indices (idx) that have an active window (not null)
# We use 'map' to filter, then 'sort_by' to ensure proper order
POPULATED_INDICES=($(echo "$WORKSPACES" | jq -r 'map(select(.active_window_id != null)) | sort_by(.idx) | .[].idx'))

COUNT=${#POPULATED_INDICES[@]}

# If no other workspaces have windows, just exit
if [ "$COUNT" -le 1 ]; then
    exit 0
fi

# 3. Find the position of our current IDX in the populated list
CURRENT_POS=-1
for i in "${!POPULATED_INDICES[@]}"; do
    if [[ "${POPULATED_INDICES[$i]}" == "$CURRENT_IDX" ]]; then
        CURRENT_POS=$i
        break
    fi
done

# 4. Calculate target index
if [[ "$DIRECTION" == "up" ]]; then
    # Move to the previous populated index
    TARGET_POS=$(((CURRENT_POS - 1 + COUNT) % COUNT))
else
    # Move to the next populated index
    TARGET_POS=$(((CURRENT_POS + 1) % COUNT))
fi

TARGET_IDX=${POPULATED_INDICES[$TARGET_POS]}

# 5. Execute the move
niri msg action focus-workspace "$TARGET_IDX"
