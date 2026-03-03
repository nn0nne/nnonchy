#!/bin/bash

# Use kitty hints instead of fzf
kitty @ get-text --ansi | grep -n ".*" | kitten hints --multiple --alphabet "asdfghjkl" --customize-processing '
import re
import sys

for line in sys.stdin:
    line = line.strip()
    m = re.match(r"(\d+):(.+)", line)
    if m:
        print(f"focus window {m.group(1)}: {m.group(2)}")
'
