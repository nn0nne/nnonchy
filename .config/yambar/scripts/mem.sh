#!/usr/bin/env bash
# --- RAM & Swap Logic ---
# Get RAM percentage
RAM_DATA=$(free | grep Mem)
RAM_TOTAL=$(echo $RAM_DATA | awk '{print $2}')
RAM_USED=$(echo $RAM_DATA | awk '{print $3}')
RAM_PERC=$((RAM_USED * 100 / RAM_TOTAL))
echo "ram_perc|int|$RAM_PERC"

# Get Swap percentage
SWAP_DATA=$(free | grep Swap)
SWAP_TOTAL=$(echo $SWAP_DATA | awk '{print $2}')
if [ "$SWAP_TOTAL" -gt 0 ]; then
    SWAP_USED=$(echo $SWAP_DATA | awk '{print $3}')
    SWAP_PERC=$((SWAP_USED * 100 / SWAP_TOTAL))
else
    SWAP_PERC=0
fi
echo "swap_perc|int|$SWAP_PERC"

echo ""
