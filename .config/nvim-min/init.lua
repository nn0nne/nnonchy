-- nvim-min: small lazy.nvim profile for big files, mainly markdown.
-- Usage: NVIM_APPNAME=nvim-min nvim <file>   (zsh: nm <file>)
-- Plugins are all lazy: render-markdown, mdkite and conform are loaded only
-- when their feature is actually used.

local opt = vim.opt
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.deprecation_warnings = false

-- ---------------------------------------------------------------------------
-- lean options
-- ---------------------------------------------------------------------------
opt.termguicolors = true
opt.background = "dark"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "no"
opt.ruler = false
opt.showmode = false
opt.laststatus = 0
opt.cmdheight = 0
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.joinspaces = false
opt.updatetime = 1000
opt.timeoutlen = 280
opt.ttimeoutlen = 0
opt.swapfile = false
opt.backup = false
opt.undofile = false
opt.undolevels = 1000
opt.completeopt = "menuone,noselect"
opt.clipboard = "unnamedplus"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.inccommand = "nosplit"
opt.foldmethod = "manual"
opt.foldlevel = 99
opt.foldenable = false
opt.spell = false
opt.list = false
opt.virtualedit = "block"
opt.winminwidth = 5
opt.splitbelow = true
opt.splitright = true

-- ---------------------------------------------------------------------------
-- lazy.nvim, reusing the plugins already installed by the main config
-- ---------------------------------------------------------------------------
local lazypath = vim.env.HOME .. "/.local/share/nvim/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Colorscheme must load at startup; everything else stays lazy.
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme rose-pine-moon")
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		lazy = true,
		opts = {
			debounce = 300,
			code = { language_icon = false },
			-- Never attach to the huge-line FRD; prevents the one-frame flash.
			-- ignore = function(buf)
			-- 	if vim.fn.getfsize(vim.api.nvim_buf_get_name(buf)) > 200 * 1024 then
			-- 		return true
			-- 	end
			-- 	for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
			-- 		if #line > 64 * 1024 then
			-- 			return true
			-- 		end
			-- 	end
			-- 	return false
			-- end,
		},
	},
	{
		"selimacerbas/mdkite.nvim",
		lazy = true,
		dependencies = { "selimacerbas/kitehost.nvim" },
		opts = {
			instance_mode = "takeover",
			port = 0,
			open_browser = true,
			default_theme = "dark",
			debounce_ms = 300,
		},
	},
	{
		"stevearc/conform.nvim",
		ft = "markdown",
		cmd = { "MdFormat" },
		opts = {
			formatters_by_ft = { markdown = { "prettier" } },
			format_after_save = function(buf)
				-- if vim.fn.getfsize(vim.api.nvim_buf_get_name(buf)) > 200 * 1024 then
				--   return nil
				-- end
				return {}
			end,
			notify_no_formatters = false,
		},
		config = function(_, opts)
			require("conform").setup(opts)
			vim.api.nvim_create_user_command("MdFormat", function()
				vim.cmd("write")
			end, {})
		end,
	},
}, {
	root = vim.env.HOME .. "/.local/share/nvim/lazy",
	lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
	install = { missing = false },
	checker = { enabled = false },
	change_detection = { enabled = false },
	local_spec = false,
	pkg = { enabled = false },
	rocks = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = {
				-- "netrwPlugin",
				"gzip",
				"zipPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zip",
				"editorconfig",
			},
		},
	},
})

-- ---------------------------------------------------------------------------
-- big-file guard
-- ---------------------------------------------------------------------------
-- Neovim 0.12 builtin ftplugins call vim.treesitter.start() on FileType.
-- Skip only big buffers; small markdown needs a parser for render-markdown.
local ts_start = vim.treesitter.start
local is_big -- defined below

vim.treesitter.start = function(buf, lang, opts)
	buf = buf or 0
	if is_big and is_big(buf) then
		return false
	end
	return ts_start(buf, lang, opts)
end

local BIG_BYTES = 200 * 1024
-- local HUGE_LINE_BYTES = 64 * 1024

is_big = function(buf)
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return false
	end
	local stat = (vim.uv or vim.loop).fs_stat(name)
	return stat ~= nil and stat.size > BIG_BYTES
end

-- local function has_huge_line(buf)
-- 	for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
-- 		if #line > HUGE_LINE_BYTES then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end

-- local function apply_markdown(buf)
-- 	if vim.bo[buf].filetype ~= "markdown" then
-- 		return
-- 	end
-- 	if is_big(buf) then
-- 		pcall(vim.treesitter.stop, buf)
-- 		if has_huge_line(buf) then
-- 			vim.bo[buf].syntax = ""
-- 		end
-- 		vim.b[buf].completion = false
-- 		local ok, render = pcall(require, "render-markdown")
-- 		if ok then
-- 			vim.api.nvim_buf_call(buf, function()
-- 				pcall(render.buf_disable)
-- 			end)
-- 		end
-- 	else
-- 		vim.cmd("Lazy load render-markdown.nvim")
-- 		local ok, render = pcall(require, "render-markdown")
-- 		if ok then
-- 			local okm, manager = pcall(require, "render-markdown.core.manager")
-- 			if okm then
-- 				pcall(manager.attach, buf)
-- 			end
-- 			vim.api.nvim_buf_call(buf, function()
-- 				pcall(render.buf_enable)
-- 			end)
-- 		end
-- 	end
-- end

-- -- Register after plugin autocmds (VimEnter), so our decision wins.
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	once = true,
-- 	callback = function()
-- 		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
-- 			if vim.api.nvim_buf_is_loaded(buf) then
-- 				apply_markdown(buf)
-- 			end
-- 		end
-- 		vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
-- 			group = vim.api.nvim_create_augroup("nvim-min-markdown", { clear = true }),
-- 			callback = function(ev)
-- 				apply_markdown(ev.buf)
-- 			end,
-- 		})
-- 	end,
-- })

-- ---------------------------------------------------------------------------
-- muscle memory that does not need plugins
-- ---------------------------------------------------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<S-h>", ":bp<CR>")
map("n", "<S-l>", ":bn<CR>")
map("n", "<leader>bd", ":bd<CR>")
map("n", "<leader>wh", "<C-w>s")
map("n", "<leader>wv", "<C-w>v")
map("n", "<leader>wd", "<C-w>c")
map("n", "<leader>we", "<C-w>=")
map("n", "<leader>wz", "<C-w>_<C-w>|")
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")
map("n", "<leader>wl", function()
	vim.wo.wrap = not vim.wo.wrap
end)
map("t", "<Esc><Esc>", "<C-\\><C-n>")
map("n", "<leader>mds", ":MdPreview start<CR>")
map("n", "<leader>mdr", ":MdPreview refresh<CR>")
map("n", "<leader>mdt", ":MdPreview stop<CR>")
map("n", "<leader>fm", ":MdFormat<CR>")

-- :MdPreview [start|refresh|stop] loads mdkite (+kitehost) on demand.
vim.api.nvim_create_user_command("MdPreview", function(opts)
	vim.cmd("Lazy load mdkite.nvim")
	vim.cmd("MdKite " .. (opts.args == "" and "start" or opts.args))
end, { nargs = "?" })
