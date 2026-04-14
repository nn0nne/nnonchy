-- =========== autocommands ===========

local group = vim.api.nvim_create_augroup("OoO", { clear = true })

local function au(typ, pattern, cmdOrFn)
	if type(cmdOrFn) == "function" then
		vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
	else
		vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
	end
end

au({ "CursorHold" }, nil, function()
	local opts = {
		focusable = false,
		scope = "cursor",
		close_events = { "BufLeave", "CursorMoved" },
	}
	vim.diagnostic.open_float(nil, opts)
end)

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(event)
		local opts = { buffer = event.buf }

		-- Example keymap
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlights text when yanking",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- autocmds
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = { "*.md" },
	callback = function()
		vim.opt.colorcolumn = "80"
		vim.opt.textwidth = 80
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*.md" },
	callback = function()
		vim.opt.colorcolumn = "120"
		vim.opt.textwidth = 120
	end,
})

-- =========== plugins ===========

local function add_plugins(plugins)
	local expanded_list = {}
	for _, plugin in ipairs(plugins) do
		if type(plugin) == "table" then
			if plugin.src and not plugin.src:find("http") then
				plugin.src = "https://github.com/" .. plugin.src
			end
			table.insert(expanded_list, plugin)
		elseif type(plugin) == "string" then
			local url = plugin:find("http") and plugin or "https://github.com/" .. plugin
			table.insert(expanded_list, { src = url })
		end
	end
	vim.pack.add(expanded_list)
end

add_plugins({
	"vague-theme/vague.nvim",
	{ src = "nvim-treesitter/nvim-treesitter", version = "main" },
	"neovim/nvim-lspconfig",
	{ src = "Saghen/blink.cmp", version = vim.version.range("1.*") },
	"stevearc/conform.nvim",
	"mfussenegger/nvim-lint",
	"mason-org/mason.nvim",
	"mason-org/mason-lspconfig.nvim",
	"folke/ts-comments.nvim",
	"knubie/vim-kitty-navigator",
	"nvim-mini/mini.nvim",
	-- "akinsho/bufferline.nvim",
	-- "nvim-lualine/lualine.nvim",
	"folke/lazydev.nvim",
	"aspeddro/gitui.nvim",
	"vyfor/cord.nvim",
	"folke/which-key.nvim",
	"rafamadriz/friendly-snippets",
	"folke/trouble.nvim",
})

require("nvim-treesitter").setup({
	ensure_installed = {
		"bash",
		-- "c",
		-- "caddy",
		"comment",
		-- "cpp",
		"css",
		"dart",
		"diff",
		-- "dockerfile",
		"ecma",
		"git_config",
		"gitattributes",
		"gitignore",
		-- "go",
		-- "goctl",
		-- "gomod",
		-- "gosum",
		"groovy",
		"html",
		"html_tags",
		"http",
		-- "java",
		-- "javadoc",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"jsx",
		-- "kitty",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		-- "nginx",
		-- "php",
		-- "phpdoc",
		"printf",
		"prisma",
		-- "python",
		"query",
		-- "rasi",
		"regex",
		"requirements",
		-- "ron",
		-- "rust",
		-- "sql",
		-- "ssh_config",
		-- "tmux",
		-- "toml",
		"tsx",
		"typescript",
		"typespec",
		-- "udev",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
		-- "zig",
		-- "zsh",
	},
})
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		-- "basedpyright",
		"bashls",
		-- "clangd",
		"cssls",
		"css_variables",
		-- "docker_compose_language_service",
		-- "dockerls",
		"emmet_language_server",
		"eslint",
		-- "gopls",
		"gradle_ls",
		"groovyls",
		"html",
		"jsonls",
		"lua_ls",
		"prismals",
		-- "ruff",
		-- "rust_analyzer",
		"stylua",
		"tailwindcss",
		-- "taplo",
		"vtsls",
		"yamlls",
		-- "zls",
	},
})
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-s>"] = { "show_signature", "hide_signature" },
		["<CR>"] = { "select_and_accept", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = false } },
	snippets = { preset = "mini_snippets" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			snippets = {
				opts = {
					friendly_snippets = true,
				},
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
require("conform").setup({
	format_on_save = {
		timout_ms = 500,
		lsp_format = "fallback",
	},
})
require("lazydev").setup({
	enable = true,
})
require("vim._core.ui2").enable()
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.diff").setup()
require("mini.hipatterns").setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

		-- Highlight hex color strings (`#rrggbb`) using that color
		hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
	},
})
require("mini.icons").setup()
require("mini.indentscope").setup()
require("mini.pick").setup()
require("mini.files").setup()
require("mini.ai").setup()
require("mini.notify").setup()
require("mini.snippets").setup()
require("mini.statusline").setup()
require("mini.cursorword").setup()
require("mini.tabline").setup()
require("mini.bracketed").setup()
require("mini.clue").setup()
require("mini.extra").setup()
require("mini.jump").setup()
require("mini.misc").setup()
-- require("bufferline").setup({
-- 	options = {
-- 		indicator = {
-- 			icon = "| ",
-- 			style = "underline",
-- 		},
-- 		diagnostics = "nvim_lsp",
-- 		diagnostics_indicator = function(count, level)
-- 			local icon = level:match("error") and " " or " "
-- 			return " " .. icon .. count
-- 		end,
-- 	},
-- })
-- local icons = {
-- 	diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = " " },
-- 	git = { added = " ", modified = " ", removed = " " },
-- }
-- require("lualine").setup({
-- 	options = {
-- 		icons_enabled = true,
-- 		theme = "auto",
-- 		component_separators = { left = "", right = "" },
-- 		section_separators = { left = "", right = "" },
-- 		disabled_filetypes = { statusline = {}, winbar = {} },
-- 		always_divide_middle = true,
-- 		always_show_tabline = true,
-- 		globalstatus = false,
-- 	},
-- 	sections = {
-- 		lualine_a = {
-- 			{
-- 				function()
-- 					local mode_map = {
-- 						n = "🈚 ノーマル",
-- 						i = "✍️ インサート",
-- 						v = "👁️ ビジュアル",
-- 						V = "📏 ビジュアルライン",
-- 						["␖"] = "🔲 ビジュアルブロック",
-- 						c = "⌨️ コマンド",
-- 						R = "📝 リプレイス",
-- 						s = "🔤 セレクト",
-- 						S = "🧾 セレクトライン",
-- 						t = "💻 ターミナル",
-- 					}
-- 					return mode_map[vim.api.nvim_get_mode().mode] or "?"
-- 				end,
-- 				color = { gui = "bold" },
-- 			},
-- 		},
-- 		lualine_b = {}, -- ⚠️ EMPTY: NO GIT OPERATIONS AT STARTUP
-- 		lualine_c = {
-- 			{
-- 				function()
-- 					return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
-- 				end,
-- 				icon = " ",
-- 			},
-- 			-- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
-- 			{
-- 				function()
-- 					return vim.fn.expand("%:~:.")
-- 				end,
-- 			},
-- 		},
-- 		lualine_x = {},
-- 		lualine_y = { { "location", padding = { left = 0, right = 1 } } },
-- 		lualine_z = {},
-- 	},
-- 	inactive_sections = { lualine_c = { "filename" }, lualine_x = { "location" } },
-- 	extensions = {},
-- })
-- vim.defer_fn(function()
-- 	if vim.g.lualine_full_loaded then
-- 		return
-- 	end
-- 	vim.g.lualine_full_loaded = true
--
-- 	require("lualine").setup({
-- 		sections = {
-- 			lualine_b = {
-- 				{ "branch", icon = " " },
-- 			},
-- 			lualine_c = {
-- 				{
-- 					function()
-- 						return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
-- 					end,
-- 					icon = " ",
-- 				},
-- 				{
-- 					"diagnostics",
-- 					symbols = icons.diagnostics,
-- 					colored = true,
-- 					update_in_insert = false,
-- 				},
-- 				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
-- 				{
-- 					function()
-- 						return vim.fn.expand("%:~:.")
-- 					end,
-- 				},
-- 			},
-- 		},
-- 	})
-- end, 100) -- 100ms delay = imperceptible to humans, avoids startup penalty

vim.cmd("packadd nvim.undotree")
vim.cmd.colorscheme("vague")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- =========== keymaps ===========

local M = {}

M.spec = {
	-- Clear highlights
	{
		"<Esc>",
		"<cmd>nohlsearch<CR>",
		desc = "Clear highlights",
		mode = "n",
	},

	-- Centered scrolling
	{
		"<C-d>",
		"<C-d>zz",
		desc = "Scroll down and center cursor",
		mode = "n",
	},
	{
		"<C-u>",
		"<C-u>zz",
		desc = "Scroll up and center cursor",
		mode = "n",
	},

	-- Terminal
	{
		"<Esc><Esc>",
		"<C-\\><C-n>",
		desc = "Exit terminal mode",
		mode = "t",
	},

	-- Smart search + centered (fixes duplicate mapping warning)
	{
		"n",
		"nzzzv",
		desc = "Next search result centered",
		mode = "n",
	},
	{
		"N",
		"Nzzzv",
		desc = "Previous search result centered",
		mode = "n",
	},

	-- Better Up/Down
	{
		"j",
		"v:count == 0 ? 'gj' : 'j'",
		desc = "Down",
		mode = { "n", "x" },
		expr = true,
		silent = true,
	},
	{
		"<Down>",
		"v:count == 0 ? 'gj' : 'j'",
		desc = "Down",
		mode = { "n", "x" },
		expr = true,
		silent = true,
	},
	{
		"k",
		"v:count == 0 ? 'gk' : 'k'",
		desc = "Up",
		mode = { "n", "x" },
		expr = true,
		silent = true,
	},
	{
		"<Up>",
		"v:count == 0 ? 'gk' : 'k'",
		desc = "Up",
		mode = { "n", "x" },
		expr = true,
		silent = true,
	},

	-- Window Resizing
	{
		"<C-Up>",
		"<cmd>resize +2<cr>",
		desc = "Increase Window Height",
		mode = "n",
	},
	{
		"<C-Down>",
		"<cmd>resize -2<cr>",
		desc = "Decrease Window Height",
		mode = "n",
	},
	{
		"<C-Left>",
		"<cmd>vertical resize -2<cr>",
		desc = "Decrease Window Width",
		mode = "n",
	},
	{
		"<C-Right>",
		"<cmd>vertical resize +2<cr>",
		desc = "Increase Window Width",
		mode = "n",
	},

	-- Move Lines
	{
		"J",
		":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
		desc = "Move Down",
		mode = "v",
	},
	{
		"K",
		":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
		desc = "Move Up",
		mode = "v",
	},

	-- Indenting
	{
		"<",
		"<gv",
		desc = "Indent left",
		mode = "v",
	},
	{
		">",
		">gv",
		desc = "Indent right",
		mode = "v",
	},

	-- Join lines & keep cursor
	{
		"J",
		"mzJ`z",
		desc = "Join lines without moving cursor",
		mode = "n",
	},

	-- Buffers
	{
		"<S-h>",
		"<cmd>bprevious<cr>",
		desc = "Prev Buffer",
		mode = "n",
	},
	{
		"<S-l>",
		"<cmd>bnext<cr>",
		desc = "Next Buffer",
		mode = "n",
	},
	{ "<leader>b", group = "Buffers" },
	{
		"<leader>bd",
		"<cmd>bdelete<cr>",
		desc = "Delete Buffer",
		mode = "n",
	},
	{
		"<S-M-h>",
		"<cmd>BufferLineMovePrev<cr>",
		desc = "Move Buffer Left",
		mode = "n",
	},
	{
		"<S-M-l>",
		"<cmd>BufferLineMoveNext<cr>",
		desc = "Move Buffer Right",
		mode = "n",
	},

	-- Windows
	{
		"<leader>wh",
		"<C-W>s",
		desc = "Split Window Below",
		mode = "n",
		remap = true,
	},
	{
		"<leader>wv",
		"<C-W>v",
		desc = "Split Window Right",
		mode = "n",
		remap = true,
	},
	{ "<leader>w", group = "Windows" },
	{
		"<leader>wd",
		"<C-W>c",
		desc = "Delete Window",
		mode = "n",
		remap = true,
	},
	{
		"<leader>we",
		"<C-w>=",
		desc = "Equalize split sizes",
		mode = "n",
	},

	-- Files / Find
	{ "<leader>f", group = "Find" },
	{
		"<leader>ff",
		function()
			require("mini.pick").builtin.files({ tool = "rg" })
		end,
		desc = "Find Files",
		mode = "n",
	},
	{
		"<leader>fg",
		function()
			require("mini.pick").builtin.grep_live({ tool = "rg" })
		end,
		desc = "Live Grep",
		mode = "n",
	},
	-- Explorer
	{
		"<leader>e",
		function()
			require("mini.files").open(vim.uv.cwd(), true)
		end,
		desc = "Explorer (mini.files)",
		mode = "n",
	},
	{
		"<leader>E",
		function()
			local bufname = vim.api.nvim_buf_get_name(0)
			if bufname == "" then
				require("mini.files").open(vim.uv.cwd(), true)
			else
				require("mini.files").open(bufname, true)
			end
		end,
		desc = "Explorer at current file",
		mode = "n",
	},

	-- Trouble
	{ "<leader>x", group = "Trouble" },
	{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace Diagnostics", mode = "n" },
	{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Document Diagnostics", mode = "n" },
	{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Quickfix List", mode = "n" },
	{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location List", mode = "n" },
	{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Todos", mode = "n" },

	-- Git
	{ "<leader>g", group = "Git" },
	{
		"<leader>gg",
		function()
			require("gitui").open()
		end,
		desc = "Open GitUI",
		mode = "n",
	},
}

require("which-key").add(M.spec)
require("which-key").setup({
	preset = "helix",
})

-- =========== options ===========

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
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
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
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes:2" -- Always show the signcolumn, otherwise it would shift the text each time
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
