# =========================================================
# Linux console (TTY) theme overrides
# =========================================================
# Rosé Pine Moon is configured with 24-bit truecolor hex values, which GUI
# terminals render but the Linux console (TERM=linux, 16 colours) ignores.
# These overrides switch the colour-producing tools to the ANSI 0-15 palette,
# which /etc/vconsole.conf maps to Rosé Pine Moon.

[[ $TERM == linux* ]] || return 0

# --- bat / cat: built-in 16-colour "ansi" theme -------------------------
# CLI flags take precedence over the --theme set in ~/.config/bat/config.
alias bat='bat --theme=ansi'
alias cat='bat --theme=ansi'

# --- eza: 16-colour theme (see ~/.config/eza/tty/theme.yml) -------------
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza/tty"
# eza's theme parser only knows the 8 basic ANSI names, so dim the muted/subtle
# greys to bright-black (90) here, which the theme file expresses as "white".
export EZA_COLORS="un=90:gu=90:gn=90:xx=90:in=90:bl=90:xa=90:pi=90:so=90:tm=90:gi=90:gr=90:tr=90:ub=90:uk=90:um=90:ug=90:ut=90"

# --- fzf: 16-colour palette --------------------------------------------
# Named ANSI colours map to the vconsole palette (spinner=gold, info=foam,
# pointer=iris, marker=love, header=pine, hl=rose).
export FZF_DEFAULT_OPTS="
	--color=fg:bright-black,bg:black,hl:cyan
	--color=fg+:white,bg+:bright-black,hl+:cyan
	--color=border:bright-black,header:blue,gutter:black
	--color=spinner:yellow,info:green
	--color=pointer:magenta,marker:red,prompt:bright-black"

# --- fastfetch: 16-colour config ---------------------------------------
alias fastfetch='fastfetch -c ~/.config/fastfetch/tty.jsonc'
