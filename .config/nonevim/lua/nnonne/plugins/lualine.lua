local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "lualine.nvim", "opencode.nvim" })

	require("lualine").setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = { left = "│", right = "│" },
			section_separators = { left = "█", right = "█" },
			disabled_filetypes = {
				statusline = { "alpha", "ministarter" },
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = true,
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
							n = "🈚 ノーマル",
							i = "✍️ インサート",
							v = "👁️ ビジュアル",
							V = "📏 ビジュアルライン",
							[""] = "🔲 ビジュアルブロック",
							c = "⌨️ コマンド",
							R = "📝 リプレイス",
							s = "🔤 セレクト",
							S = "🧾 セレクトライン",
							t = "💻 ターミナル",
						}
						return mode_map[vim.api.nvim_get_mode().mode] or "?"
					end,
				},
			},
			lualine_b = {
				"branch",
				"diff",
				"diagnostics",
			},
			lualine_c = {
				{
					"filename",
					file_status = true,
					newfile_status = false,
					path = 4,
					symbols = {
						modified = "[+]",
						readonly = "[-]",
						unnamed = "",
						newfile = "[New]",
					},
				},
			},
			lualine_x = { { require("opencode").statusline }, { "filetype", colored = true, icon_only = true } },
			lualine_y = { { "datetime", style = "%d%u%m%H%M" } },
			lualine_z = { { "searchcount", maxcount = 999, timeout = 500 }, "selectioncount", "location" },
		},
		inactive_sections = {
			lualine_a = { "mode" },
			lualine_b = {
				"branch",
				"diff",
				"diagnostics",
				"lsp_status",
			},
			lualine_c = { "filename" },
			lualine_x = { "filetype" },
			lualine_y = { "datetype" },
			lualine_z = { "searchcount", "selectioncount", "location" },
		},
		extensions = {
			"oil",
			"man",
			"mason",
			"quickfix",
			"toggleterm",
			"trouble",
			"nvim-dap-ui",
		},
	})
end

return M
