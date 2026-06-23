import os

_theme_real_path = None

def _get_theme_path():
    global _theme_real_path
    if _theme_real_path is None:
        config_path = os.path.expanduser("~/.config/kitty/colorscheme/current-theme.conf")
        _theme_real_path = os.path.realpath(config_path)
    return _theme_real_path

def draw_title(data):
    fmt = data["fmt"]

    session = data.get("session_name") or ""
    title = data.get("title") or ""
    layout = data.get("layout_name") or ""
    bell = data.get("bell_symbol") or ""
    progress = data.get("tab.last_focused_progress_percent") or ""
    num_windows = data.get("num_windows") or 0
    progress_percent = data.get("tab.progress_percent") or ""

    command = title.split(" ")[0]
    if command == "sudo":
        try:
            command = "# " + title.split(" ")[1]
        except IndexError:
            command = "# sudo"

    title = command.split("/")[-1].split(":")[-1]
    layout_short = layout[0].upper() if layout else ""
    layout_display = f"{layout_short}({num_windows})" if layout.lower() == "stack" else layout_short

    parts = []

    real_path = _get_theme_path()
    is_light = "gruvbox" in real_path.lower()

    if is_light:
        bg_style = fmt.bg._f9f5d7
        c_session = fmt.fg.color15
        c_sep = fmt.fg.color7
        c_bell = fmt.fg.color1
        c_prog = fmt.fg.color9
        c_title = fmt.fg.color4
        c_layout = fmt.fg.color13
    else:
        bg_style = fmt.bg._141415
        c_session = fmt.fg.color3
        c_sep = fmt.fg.color3
        c_bell = fmt.fg.color1
        c_prog = fmt.fg.color3
        c_title = fmt.fg.color4
        c_layout = fmt.fg.color4

    if session:
        parts.append(bg_style)
        parts.append(c_session)
        parts.append(session)
        parts.append(c_sep)
        parts.append(" | ")

    if bell:
        parts.append(bg_style)
        parts.append(c_bell)
        parts.append(bell)

    if progress:
        parts.append(bg_style)
        parts.append(c_prog)
        parts.append(progress)

    parts.append(bg_style)
    parts.append(c_title)
    parts.append(title)

    parts.append(c_layout)
    parts.append(f" [{layout_display}]")

    if progress_percent:
        parts.append(bg_style)
        parts.append(c_prog)
        parts.append(progress_percent)

    parts.append(bg_style)
    parts.append(fmt.fg.tab)

    return "".join(parts)
