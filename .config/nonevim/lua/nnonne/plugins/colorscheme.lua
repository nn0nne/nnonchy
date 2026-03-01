return {
	-- {
	-- 	"slugbyte/lackluster.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	init = function()
	-- 		local lackluster = require("lackluster")
	--
	-- 		lackluster.setup({
	-- 			tweak_highlight = {
	-- 				-- Selected item in mini.pick list
	-- 				PmenuSel = {
	-- 					overwrite = true,
	-- 					bg = "#3a3a3a", -- pick something clearly different
	-- 					fg = "#ffffff",
	-- 					bold = true,
	-- 				},
	--
	-- 				-- Optional: improve general popup menu visibility
	-- 				Pmenu = {
	-- 					overwrite = false,
	-- 					bg = "#2a2a2a",
	-- 				},
	--
	-- 				-- If mini.pick uses CursorLine
	-- 				CursorLine = {
	-- 					overwrite = false,
	-- 					bg = "#333333",
	-- 				},
	--
	-- 				MiniFilesDirectory = {
	-- 					overwrite = true,
	-- 					fg = "#8a8a8a", -- lighter gray than default
	-- 					bold = true,
	-- 				},
	--
	-- 				Directory = {
	-- 					overwrite = false,
	-- 					fg = "#8a8a8a",
	-- 				},
	--
	-- 				Search = {
	-- 					overwrite = true,
	-- 					bg = "#444444",
	-- 					fg = "#cccccc",
	-- 				},
	--
	-- 				IncSearch = {
	-- 					overwrite = true,
	-- 					bg = "#505050",
	-- 					fg = "#ffffff",
	-- 				},
	--
	-- 				CurSearch = {
	-- 					overwrite = true,
	-- 					bg = "#606060",
	-- 					fg = "#ffffff",
	-- 				},
	-- 			},
	-- 		})
	-- 		-- vim.cmd.colorscheme("lackluster")
	-- 		vim.cmd.colorscheme("lackluster-hack")
	-- 		-- vim.cmd.colorscheme("lackluster-mint")
	-- 	end,
	-- },
	-- {
	-- 	"webhooked/kanso.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		-- Default options:
	-- 		require("kanso").setup({
	-- 			bold = true, -- enable bold fonts
	-- 			italics = true, -- enable italics
	-- 			compile = true, -- enable compiling the colorscheme
	-- 			undercurl = true, -- enable undercurls
	-- 			commentStyle = { italic = true },
	-- 			functionStyle = {},
	-- 			keywordStyle = { italic = true },
	-- 			statementStyle = {},
	-- 			typeStyle = {},
	-- 			transparent = true, -- do not set background color
	-- 			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
	-- 			terminalColors = true, -- define vim.g.terminal_color_{0,17}
	-- 			colors = { -- add/modify theme and palette colors
	-- 				palette = {},
	-- 				theme = { zen = {}, pearl = {}, ink = {}, all = {} },
	-- 			},
	-- 			overrides = function(colors) -- add/modify highlights
	-- 				return {}
	-- 			end,
	-- 			background = { -- map the value of 'background' option to a theme
	-- 				dark = "zen", -- try "zen", "mist" or "pearl" !
	-- 				light = "mist", -- try "zen", "mist" or "ink" !
	-- 			},
	-- 			foreground = "default", -- "default" or "saturated" (can also be a table like background)
	-- 			minimal = true, -- reduced color palette for a more minimal look
	-- 		})
	--
	-- 		-- setup must be called before loading
	-- 		vim.cmd("colorscheme kanso")
	-- 	end,
	-- },
	{
		"vague-theme/vague.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other plugins
		config = function()
			require("vague").setup({
				transparent = true, -- don't set background
				-- disable bold/italic globally in `style`
				bold = true,
				italic = true,
				style = {
					-- "none" is the same thing as default. But "italic" and "bold" are also valid options
					boolean = "bold",
					number = "none",
					float = "none",
					error = "bold",
					comments = "italic",
					conditionals = "none",
					functions = "none",
					headings = "bold",
					operators = "none",
					strings = "italic",
					variables = "none",

					-- keywords
					keywords = "none",
					keyword_return = "italic",
					keywords_loop = "none",
					keywords_label = "none",
					keywords_exception = "none",

					-- builtin
					builtin_constants = "bold",
					builtin_functions = "none",
					builtin_types = "bold",
					builtin_variables = "none",
				},
				-- plugin styles where applicable
				-- make an issue/pr if you'd like to see more styling options!
				plugins = {
					cmp = {
						match = "bold",
						match_fuzzy = "bold",
					},
					dashboard = {
						footer = "italic",
					},
					lsp = {
						diagnostic_error = "bold",
						diagnostic_hint = "none",
						diagnostic_info = "italic",
						diagnostic_ok = "none",
						diagnostic_warn = "bold",
					},
					neotest = {
						focused = "bold",
						adapter_name = "bold",
					},
					telescope = {
						match = "bold",
					},
				},

				-- Override highlights or add new highlights
				-- on_highlights = function(highlights, colors) end,

				-- Override colors
				colors = {
					bg = "#141415",
					inactiveBg = "#1c1c24",
					fg = "#cdcdcd",
					floatBorder = "#878787",
					line = "#252530",
					comment = "#606079",
					builtin = "#b4d4cf",
					func = "#c48282",
					string = "#e8b589",
					number = "#e0a363",
					property = "#c3c3d5",
					constant = "#aeaed1",
					parameter = "#bb9dbd",
					visual = "#333738",
					error = "#d8647e",
					warning = "#f3be7c",
					hint = "#7e98e8",
					operator = "#90a0b5",
					keyword = "#6e94b2",
					type = "#9bb4bc",
					search = "#405065",
					plus = "#7fa563",
					delta = "#f3be7c",
				},
			})

			vim.cmd("colorscheme vague")
		end,
	},
}
