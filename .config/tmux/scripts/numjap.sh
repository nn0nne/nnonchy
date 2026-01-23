#!/bin/bash
# num2japanese.sh - Convert 1-9 to Japanese numerals (Kanji)
# Extend as needed for larger numbers

case "$1" in
1) echo "一" ;;
2) echo "二" ;;
3) echo "三" ;;
4) echo "四" ;;
5) echo "五" ;;
6) echo "六" ;;
7) echo "七" ;;
8) echo "八" ;;
9) echo "九" ;;
10) echo "十" ;;
11) echo "十一" ;;
# Add more as needed...
*) echo "$1" ;; # fallback to original number
esac
