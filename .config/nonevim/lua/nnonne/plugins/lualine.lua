return {
	"nvim-lualine/lualine.nvim",
	event = "UIEnter",
	opts = function()
		local icons = {
			diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = " " },
			git = { added = " ", modified = " ", removed = " " },
		}

		-- MINIMAL STARTUP CONFIG (avoids git/LSP)
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { statusline = {}, winbar = {} },
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = false,
			},
			sections = {
				lualine_a = {
					{
						function()
							local mode_map = {
								n = "🈚 ノーマル",
								i = "✍️ インサート",
								v = "👁️ ビジュアル",
								V = "📏 ビジュアルライン",
								[""] = "🔲 ビジュアルブロック",
								c = "⌨️ コマンド",
								R = "📝 リプレイス",
								s = "🔤 セレクト",
								S = "🧾 セレクトライン",
								t = "💻 ターミナル",
							}
							return mode_map[vim.api.nvim_get_mode().mode] or "?"
						end,
						color = { gui = "bold" },
					},
				},
				lualine_b = {}, -- ⚠️ EMPTY: NO GIT OPERATIONS AT STARTUP
				lualine_c = {
					{
						function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						end,
						icon = " ",
					},
					-- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{
						function()
							return vim.fn.expand("%:~:.")
						end,
					},
				},
				lualine_x = {},
				lualine_y = { { "location", padding = { left = 0, right = 1 } } },
				lualine_z = {},
			},
			inactive_sections = { lualine_c = { "filename" }, lualine_x = { "location" } },
			extensions = {},
		})

		-- ✨ RESTORE FULL FEATURES AFTER STARTUP (non-blocking)
		vim.defer_fn(function()
			if vim.g.lualine_full_loaded then
				return
			end
			vim.g.lualine_full_loaded = true

			require("lualine").setup({
				sections = {
					lualine_b = {
						{ "branch", icon = " " },
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
						},
					},
					lualine_c = {
						{
							function()
								return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							end,
							icon = " ",
						},
						{
							"diagnostics",
							symbols = icons.diagnostics,
							colored = true,
							update_in_insert = false,
						},
						{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
						{
							function()
								return vim.fn.expand("%:~:.")
							end,
						},
					},
				},
			})
		end, 100) -- 100ms delay = imperceptible to humans, avoids startup penalty
	end,
}
