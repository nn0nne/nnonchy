export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results
# Ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="--height 80% --layout reverse --border --info inline --cycle --scroll-off 3 --prompt '❯ ' --pointer '▶' --marker '✓' --ansi --bind 'ctrl-j:down,ctrl-k:up,ctrl-u:preview-page-up,ctrl-d:preview-page-down,?:toggle-preview' \
--color='bg+:#252530,bg:#141415,spinner:#f5cb96,hl:#d8647e' \
--color='fg:#cdcdcd,header:#d8647e,info:#aeaed1,pointer:#8ba9c1' \
--color='marker:#7fa563,fg+:#d7d7d7,prompt:#bb9dbd,hl+:#e08398'"

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
