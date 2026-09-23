export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results
# Ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## Vague
# export FZF_DEFAULT_OPTS="--height 80% --layout reverse --border --info inline --cycle --scroll-off 3 --prompt '❯ ' --pointer '▶' --marker '✓' --ansi --bind 'ctrl-j:down,ctrl-k:up,ctrl-u:preview-page-up,ctrl-d:preview-page-down,?:toggle-preview' \
# --color='bg+:#252530,bg:#141415,spinner:#f5cb96,hl:#d8647e' \
# --color='fg:#cdcdcd,header:#d8647e,info:#aeaed1,pointer:#8ba9c1' \
# --color='marker:#7fa563,fg+:#d7d7d7,prompt:#bb9dbd,hl+:#e08398'"

# # Darker-Zenwritten
# export FZF_DEFAULT_OPTS="--height 80% --layout reverse --border --info inline --cycle --scroll-off 3 --prompt '❯ ' --pointer '▶' --marker '✓' --ansi --bind 'ctrl-j:down,ctrl-k:up,ctrl-u:preview-page-up,ctrl-d:preview-page-down,?:toggle-preview' \
# --color='bg+:#232325,bg:#000000,spinner:#84848a,hl:#84848a' \
# --color='fg:#e8e8ee,header:#84848a,info:#84848a,pointer:#e8e8ee' \
# --color='marker:#e8e8ee,fg+:#ffffff,prompt:#84848a,hl+:#ffffff'"

# # Solarized Osaka Dark
# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
#   --highlight-line \
#   --info=inline-right \
#   --ansi \
#   --layout=reverse \
#   --border=none \
#   --color=bg+:#002c38 \
#   --color=bg:#001419 \
#   --color=border:#063540 \
#   --color=fg:#9eabac \
#   --color=gutter:#001419 \
#   --color=header:#c94c16 \
#   --color=hl+:#c94c16 \
#   --color=hl:#c94c16 \
#   --color=info:#637981 \
#   --color=marker:#c94c16 \
#   --color=pointer:#c94c16 \
#   --color=prompt:#c94c16 \
#   --color=query:#9eabac:regular \
#   --color=scrollbar:#063540 \
#   --color=separator:#063540 \
#   --color=spinner:#c94c16 \
# "

# # Rose Pine Dawn
# export FZF_DEFAULT_OPTS="
# 	--color=fg:#797593,bg:#faf4ed,hl:#d7827e
# 	--color=fg+:#575279,bg+:#f2e9e1,hl+:#d7827e
# 	--color=border:#dfdad9,header:#286983,gutter:#faf4ed
# 	--color=spinner:#ea9d34,info:#56949f
# 	--color=pointer:#907aa9,marker:#b4637a,prompt:#797593"

# Rose Pine Moon
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#232136,hl:#ea9a97
	--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
	--color=border:#44415a,header:#3e8fb0,gutter:#232136
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'

export FZF_CTRL_T_OPTS="--preview 'if [[ -d {} ]]; then eza --tree --level=2 {} 2>/dev/null || ls {}; else bat --style=numbers --color=always --line-range :300 {} 2>/dev/null || sed -n \"1,300p\" {}; fi'"

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window 'down:3:wrap' --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)+abort,ctrl-e:toggle-sort'"

export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git || find . -type d"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 {} 2>/dev/null || ls {}'"

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
    local cmd result
    cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
    result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
        && LBUFFER+="$result"  # LBUFFER is the text left of the cursor
    zle reset-prompt
}
zle -N _fzf_file_no_hidden
