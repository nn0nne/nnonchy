#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$TARGET_DIR"

FILEPATH="$TARGET_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

MODE="${1:-fullscreen}"   # fullscreen, region, window
COPY_CLIP="${2:-false}"   # true, false

WAYFREEZE_PID=""

cleanup() {
    if [[ -n "$WAYFREEZE_PID" ]]; then
        kill "$WAYFREEZE_PID" 2>/dev/null || true
        wait "$WAYFREEZE_PID" 2>/dev/null || true
    fi
}

trap cleanup EXIT INT TERM HUP

case "$MODE" in
    fullscreen)
        grim "$FILEPATH"
        ;;

    window)
        GEOMETRY="$(
            mmsg get focusing-client |
                jq -r '"\(.x),\(.y) \(.width)x\(.height)"'
        )"

        if [[ -z "$GEOMETRY" || "$GEOMETRY" == "null,null nullxnull" ]]; then
            echo "Could not determine focused window geometry." >&2
            exit 1
        fi

        grim -g "$GEOMETRY" "$FILEPATH"
        ;;

    region)
        # Freeze the current frame.
        wayfreeze --hide-cursor &
        WAYFREEZE_PID=$!

        # Give wayfreeze a moment to establish the frozen frame.
        sleep 0.1

        # Select directly on the frozen frame.
        if ! GEOMETRY="$(slurp -d)"; then
            echo "selection cancelled" >&2
            exit 1
        fi

        if [[ -z "$GEOMETRY" ]]; then
            echo "selection cancelled" >&2
            exit 1
        fi

        # Capture the selected region while the frame is still frozen.
        grim -g "$GEOMETRY" "$FILEPATH"
        ;;

    *)
        echo "Usage: $0 [fullscreen|region|window] [true|false]" >&2
        exit 2
        ;;
esac

if [[ "$COPY_CLIP" == "true" && -f "$FILEPATH" ]]; then
    wl-copy <"$FILEPATH"
fi
