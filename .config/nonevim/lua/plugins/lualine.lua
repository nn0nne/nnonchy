return {
	"nvim-lualine/lualine.nvim",
    dependencies = { { "DaikyXendo/nvim-material-icon", name = "nvim-web-devicons" } },
	opts = function()
		require("nvim-web-devicons").setup()
		local icons = {
			diagnostics = {
				Error = " ",
				Warn = " ",
				Info = " ",
				Hint = " ",
			},
			git = {
				added = " ",
				modified = " ",
				removed = " ",
			},
		}
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
					refresh_time = 16, -- ~60fps
					events = {
						"WinEnter",
						"BufEnter",
						"BufWritePost",
						"SessionLoadPost",
						"FileChangedShellPost",
						"VimResized",
						"Filetype",
						"CursorMoved",
						"CursorMovedI",
						"ModeChanged",
					},
				},
			},
			sections = {
				lualine_a = {
					{
						function()
							local mode_map = {
								n = "🈚 ノーマル", -- Normal
								i = "✍️ インサート", -- Insert
								v = "👁️ ビジュアル", -- Visual
								V = "📏 ビジュアルライン", -- Visual Line
								[""] = "🔲 ビジュアルブロック", -- Visual Block
								c = "⌨️ コマンド", -- Command
								R = "📝 リプレイス", -- Replace ← changed
								s = "🔤 セレクト", -- Select ← changed
								S = "🧾 セレクトライン", -- Select Line ← changed
								t = "💻 ターミナル", -- Terminal
							}
							local mode = vim.api.nvim_get_mode().mode
							return mode_map[mode] or mode
						end,
						color = { gui = "bold" },
					},
				},
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{
						function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						end,
						icon = " ",
					},
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{
						function()
							return vim.fn.expand("%:~:.")
						end,
					},
				},
				lualine_x = {},
				lualine_y = {
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
