# osc7 for foot
function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}
function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd


update_wallpaper() {
    if [ -z "$1" ]; then
        echo "Usage: update_wallpaper /path/to/image.png"
        return 1
    fi
    cp "$1" ~/.config/mango/wallpaper.png
    pkill swaybg; swaybg -i ~/.config/mango/wallpaper.png -m fit >/dev/null 2>&1 &
    sudo cp "$1" /boot/wallpaper.png
}
