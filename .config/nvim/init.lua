-- =========== autocommands ===========

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlights text when yanking",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_tohtml_plugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1

vim.g.deprecation_warnings = false

vim.g.trouble_lualine = true

local opt = vim.opt
opt.autowrite = true -- Enable auto write
-- https://github.com/neovim/neovim/discussions/28010#discussioncomment-9877494
opt.clipboard = "unnamedplus" -- Sync with system clipboard
local function paste()
	return {
		vim.fn.split(vim.fn.getreg(""), "\n"),
		vim.fn.getregtype(""),
	}
end
vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = paste,
		["*"] = paste,
	},
}
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.autoindent = true
-- opt.fillchars = {
-- 	foldopen = "¿",
-- 	foldclose = "¿",
-- 	fold = " ",
-- 	foldsep = " ",
-- 	diff = "¿",
-- 	eob = " ",
-- }
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = false -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smarttab = true
opt.smoothscroll = false
opt.spelllang = { "en", "id" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.softtabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 50 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.showcmd = true
opt.swapfile = false
opt.backup = false
opt.undolevels = 10000
opt.updatetime = 50 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"
opt.background = "dark"
opt.foldenable = true
opt.foldcolumn = "0"
