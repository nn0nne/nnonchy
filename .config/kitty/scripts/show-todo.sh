#!/usr/bin/env bash

TARGET_DIR="$HOME/Documents/notes/todo/"
cd "$TARGET_DIR" || exit 1

NVIM_APPNAME="nonevim" nvim todo.md
