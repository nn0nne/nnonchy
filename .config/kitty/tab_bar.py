def draw_title(data):
    fmt = data["fmt"]

    session = data.get("session_name") or ""
    title = data.get("title") or ""
    layout = data.get("layout_name") or ""
    bell = data.get("bell_symbol") or ""
    activity = data.get("activity_symbol") or ""
    progress = data.get("tab.last_focused_progress_percent") or ""
    num_windows = data.get("num_windows") or 0
    progress_percent = data.get("tab.progress_percent") or ""

    # Clean title
    title = title.split("/")[-1].split(":")[-1]

    # Short layout name (first letter, uppercase)
    layout_short = layout[0].upper() if layout else ""

    # If layout is stack, show number of windows
    if layout.lower() == "stack":
        layout_display = f"{layout_short}({num_windows})"
    else:
        layout_display = layout_short

    parts = []

    if session:
        parts.append(fmt.fg.color3)
        parts.append(session + " | ")

    parts.append(fmt.fg.color1)
    parts.append(bell + activity)

    parts.append(fmt.fg.color3)
    parts.append(progress)

    parts.append(fmt.fg.color4)
    parts.append(title)

    parts.append(fmt.fg.color4)
    parts.append(f" [{layout_display}]")

    parts.append(fmt.fg.color1)
    parts.append(progress_percent)

    parts.append(fmt.fg.tab)  # reset to tab default color

    return "".join(parts)
