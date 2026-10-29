#!/usr/bin/env bash

ARTIST="$1"
TITLE="$2"

# Only notify if title isn't empty
if [ -n "$TITLE" ]; then
    notify-send "Now Playing" "$TITLE\nby $ARTIST" --app-name="Music"
fi
