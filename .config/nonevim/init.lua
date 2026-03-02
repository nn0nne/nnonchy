require("nnonne")

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

-- https://github.com/kovidgoyal/kitty/issues/1915#issuecomment-2171029759
vim.cmd([[
augroup kitty_mp
    autocmd!
    au VimLeave * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=default margin=0
    au VimEnter * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=0 margin=0
    au BufEnter * if !empty($KITTY_WINDOW_ID) | :silent !kitty @ set-spacing padding=0 margin=0
augroup END
]])
