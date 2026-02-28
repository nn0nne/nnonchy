#!/usr/bin/env bash

# text=$(playerctl metadata --format '{{artist}} - {{title}}')
# maxlength=35
# # if the text is longer than the max length, truncate it and add "..."
# if [ ${#text} -gt $maxlength ]; then
#   text=${text:0:$maxlength-3}"..."
# fi
#
# playerctl metadata --format '{"text": "'"$text"'", "tooltip": "{{playerName}} : {{artist}} - {{title}}"}'

maxlength=100

if ! playerctl metadata >/dev/null 2>&1; then
  echo '{"text": "", "tooltip": ""}'
  exit 0
fi

text=$(playerctl metadata --format '{{artist}} - {{title}}')

if [ ${#text} -gt $maxlength ]; then
  text="${text:0:$(($maxlength - 3))}..."
fi

tooltip=$(playerctl metadata --format '{{playerName}} : {{artist}} - {{title}}')

printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip"
