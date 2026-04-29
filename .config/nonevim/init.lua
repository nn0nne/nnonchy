require("settings.options")
require("commands.autocommands")
local keymaps = require("settings.keymaps")

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
	"folke/lazydev.nvim",
	"aspeddro/gitui.nvim",
	"vyfor/cord.nvim",
	"folke/which-key.nvim",
	"rafamadriz/friendly-snippets",
	"folke/trouble.nvim",
})

vim.cmd.colorscheme("vague")

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
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				preloadFileSize = 1000,
				maxPreload = 2000,
				checkThirdParty = false,
				ignoreDir = { ".git", "node_modules" },
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = { enable = false },
		},
		single_file_support = true,
	},
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".git",
		"init.lua",
		"init.sls",
	},
})

require("conform").setup({
	format_on_save = {
		timout_ms = 500,
		lsp_format = "fallback",
	},
})

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

require("trouble").setup({})

-- source https://www.reddit.com/r/neovim/comments/1sa95g4/no_more_press_enter_with_ui2_with_example/
vim.opt.cmdheight = 0
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = {
			height = 0.5,
		},
	},
})

if os.getenv("TERM") == "xterm-kitty" or os.getenv("KITTY_WINDOW_ID") then
else
	vim.g.loaded_kitty_navigator = 1
	vim.keymap.set("n", "<C-h>", "<C-w>h")
	vim.keymap.set("n", "<C-j>", "<C-w>j")
	vim.keymap.set("n", "<C-k>", "<C-w>k")
	vim.keymap.set("n", "<C-l>", "<C-w>l")
end

require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.diff").setup({
	view = {
		style = "sign",
	},
})
require("mini.hipatterns").setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		-- TODO Dart/Flutter color
		-- dart_color = {
		-- 	pattern = "0x%x%x(%x%x%x%x%x%x)%f[%X]",
		-- 	group = function(_, _, match)
		-- 		local hex = "#" .. match:sub(-6)
		-- 		return require("mini.hipatterns").compute_hex_color_group(hex, "bg")
		-- 	end,
		-- },
		hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
	},
})
require("mini.icons").setup()
require("mini.indentscope").setup({
	draw = {
		animation = function()
			return 0
		end,
	},
})
require("mini.pick").setup()
require("mini.files").setup({
	mappings = {
		close = "<Esc>",
	},
})
require("mini.ai").setup()
require("mini.notify").setup()
require("mini.snippets").setup({})
require("mini.statusline").setup({
	content = {
		active = function()
			local mode_labels = {
				["n"] = "🈚 ノーマル",
				["v"] = "👁️ ビジュアル",
				["V"] = "📏 ビジュアルライン",
				["\22"] = "🔲 ビジュアルブロック",
				["s"] = "🔤 セレクト",
				["S"] = "🧾 セレクトライン",
				["\19"] = "🟦 セレクトブロック",
				["i"] = "✍️ インサート",
				["R"] = "📝 リプレイス",
				["c"] = "⌨️ コマンド",
				["r"] = "❓ プロンプト",
				["!"] = "🐚 シェル",
				["t"] = "💻 ターミナル",
			}

			local cur_mode = vim.api.nvim_get_mode().mode
			local mode_text = mode_labels[cur_mode] or cur_mode
			local _, mode_hl = require("mini.statusline").section_mode({ trunc_width = 120 })
			local git = require("mini.statusline").section_git({ trunc_width = 40 })
			local diff = require("mini.statusline").section_diff({ trunc_width = 75 })
			local filename = require("mini.statusline").section_filename({ trunc_width = 140 })
			local fileinfo = require("mini.statusline").section_fileinfo({ trunc_width = 120 })
			local location = require("mini.statusline").section_location({ trunc_width = 75 })

			local diagnostics = require("mini.statusline").section_diagnostics({
				trunc_width = 75,
				signs = {
					ERROR = "%#DiagnosticError#󰅚 %#MiniStatuslineDevinfo#",
					WARN = "%#DiagnosticWarn#󰀪 %#MiniStatuslineDevinfo#",
					INFO = "%#DiagnosticInfo#󰋽 %#MiniStatuslineDevinfo#",
					HINT = "%#DiagnosticHint#󰌶 %#MiniStatuslineDevinfo#",
				},
			})

			return require("mini.statusline").combine_groups({
				{ hl = mode_hl, strings = { mode_text } }, -- Use our custom mode_text
				{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { location } },
			})
		end,
	},
})
require("mini.tabline").setup({
	show_icons = true,
	format = function(buf_id, label)
		local errors = #vim.diagnostic.get(buf_id, { severity = vim.diagnostic.severity.ERROR })
		local warnings = #vim.diagnostic.get(buf_id, { severity = vim.diagnostic.severity.WARN })

		local diagnostic_suffix = ""
		if errors > 0 then
			diagnostic_suffix = diagnostic_suffix .. "  " .. errors
		end
		if warnings > 0 then
			diagnostic_suffix = diagnostic_suffix .. "  " .. warnings
		end

		return require("mini.tabline").default_format(buf_id, label) .. diagnostic_suffix
	end,
})
require("mini.extra").setup()
require("mini.jump").setup()
vim.cmd("packadd nvim.undotree")
require("which-key").add(keymaps.spec)
require("which-key").setup({
	preset = "helix",
})
