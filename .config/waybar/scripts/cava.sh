#! /bin/bash

# bar="▁▂▃▄▅▆▇█"
# dict="s/;//g;"
#
# # creating "dictionary" to replace char with bar
# i=0
# while [ $i -lt ${#bar} ]; do
#     dict="${dict}s/$i/${bar:$i:1}/g;"
#     i=$((i = i + 1))
# done
#
# # write cava config
# config_file="/tmp/polybar_cava_config"
# echo "
# [general]
# bars = 18
#
# [output]
# method = raw
# raw_target = /dev/stdout
# data_format = ascii
# ascii_max_range = 7
# " >$config_file
#
# # read stdout from cava
# cava -p $config_file | while read -r line; do
#     echo $line | sed $dict
# done

bars="▁▂▃▄▅▆▇█"

config_file="/tmp/polybar_cava_config"
echo "
[general]
bars = 10
framerate = 24
autosens = 1
noise_reduction = 70
sleep_timer = 3
mode = waves

[input]
method = pipewire
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 59
" >$config_file

cava -p "$config_file" | while read -r line; do
  output=""
  for ((i = 0; i < ${#line}; i++)); do
    char="${line:$i:1}"
    case "$char" in
    0) output+="▁" ;;
    1) output+="▂" ;;
    2) output+="▃" ;;
    3) output+="▄" ;;
    4) output+="▅" ;;
    5) output+="▆" ;;
    6) output+="▇" ;;
    7) output+="█" ;;
    \;) output+=" " ;;
    esac
  done
  echo "$output"
done
