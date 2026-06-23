from kitty.boss import Boss
from kitty.window import Window

def on_focus_change(boss: Boss, window: Window, activated: bool) -> None:
    # We only care about the window that just gained focus
    if not activated:
        return

    # Check if 'nvim' is in the foreground process name or arguments
    fp = window.child.foreground_processes
    is_nvim = False
    if fp:
        for proc in fp:
            # Check if nvim is running in this window
            if 'nvim' in proc['cmdline'] or 'nvim' in proc['name']:
                is_nvim = True
                break

    # Apply padding dynamically based on whether it's Neovim or not
    if is_nvim:
        boss.call_remote_control(window, ('set-spacing', 'padding=0'))
    else:
        boss.call_remote_control(window, ('set-spacing', 'padding=default'))
