return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
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
				lualine_b = { "branch" },
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
				lualine_x = { "location" },
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
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
-- return {
-- 	"nvim-lualine/lualine.nvim",
-- 	event = "VeryLazy",
-- 	init = function()
-- 		vim.g.lualine_laststatus = vim.o.laststatus
-- 		if vim.fn.argc(-1) > 0 then
-- 			-- set an empty statusline till lualine loads
-- 			vim.o.statusline = " "
-- 		else
-- 			-- hide the statusline on the starter page
-- 			vim.o.laststatus = 0
-- 		end
-- 	end,
-- 	opts = function()
-- 		-- PERF: we don't need this lualine require madness 🤷
-- 		local lualine_require = require("lualine_require")
-- 		lualine_require.require = require
--
-- 		local icons = {
-- 			diagnostics = {
-- 				Error = " ",
-- 				Warn = " ",
-- 				Info = " ",
-- 				Hint = " ",
-- 			},
-- 			git = {
-- 				added = " ",
-- 				modified = " ",
-- 				removed = " ",
-- 			},
-- 		}
--
-- 		vim.o.laststatus = vim.g.lualine_laststatus
--
-- 		local opts = {
-- 			options = {
-- 				theme = "auto",
-- 				globalstatus = vim.o.laststatus == 3,
-- 				disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
-- 			},
-- 			sections = {
-- 				lualine_a = {
-- 					{
-- 						function()
-- 							local mode_map = {
-- 								n = "🈚 ノーマル", -- Normal
-- 								i = "✍️ インサート", -- Insert
-- 								v = "👁️ ビジュアル", -- Visual
-- 								V = "📏 ビジュアルライン", -- Visual Line
-- 								[""] = "🔲 ビジュアルブロック", -- Visual Block
-- 								c = "⌨️ コマンド", -- Command
-- 								R = "📝 リプレイス", -- Replace ← changed
-- 								s = "🔤 セレクト", -- Select ← changed
-- 								S = "🧾 セレクトライン", -- Select Line ← changed
-- 								t = "💻 ターミナル", -- Terminal
-- 							}
-- 							local mode = vim.api.nvim_get_mode().mode
-- 							return mode_map[mode] or mode
-- 						end,
-- 						color = { gui = "bold" },
-- 					},
-- 				},
-- 				lualine_b = { "branch" },
--
-- 				lualine_c = {
-- 					{
-- 						{
-- 							function()
-- 								local cwd = vim.fn.getcwd()
-- 								return vim.fn.fnamemodify(cwd, ":t")
-- 							end,
-- 							icon = " ",
-- 						},
-- 						"diagnostics",
-- 						symbols = {
-- 							error = icons.diagnostics.Error,
-- 							warn = icons.diagnostics.Warn,
-- 							info = icons.diagnostics.Info,
-- 							hint = icons.diagnostics.Hint,
-- 						},
-- 					},
-- 					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
-- 					{
-- 						function()
-- 							return vim.fn.expand("%:~:.")
-- 						end,
-- 					},
-- 				},
-- 				lualine_x = {
-- 					Snacks.profiler.status(),
--           -- stylua: ignore
--           {
--             function() return require("noice").api.status.command.get() end,
--             cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
--             color = function() return { fg = Snacks.util.color("Statement") } end,
--           },
--           -- stylua: ignore
--           {
--             function() return require("noice").api.status.mode.get() end,
--             cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
--             color = function() return { fg = Snacks.util.color("Constant") } end,
--           },
--           -- stylua: ignore
--           {
--             function() return "  " .. require("dap").status() end,
--             cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
--             color = function() return { fg = Snacks.util.color("Debug") } end,
--           },
--           -- stylua: ignore
--           {
--             require("lazy.status").updates,
--             cond = require("lazy.status").has_updates,
--             color = function() return { fg = Snacks.util.color("Special") } end,
--           },
-- 					{
-- 						"diff",
-- 						symbols = {
-- 							added = icons.git.added,
-- 							modified = icons.git.modified,
-- 							removed = icons.git.removed,
-- 						},
-- 						source = function()
-- 							local gitsigns = vim.b.gitsigns_status_dict
-- 							if gitsigns then
-- 								return {
-- 									added = gitsigns.added,
-- 									modified = gitsigns.changed,
-- 									removed = gitsigns.removed,
-- 								}
-- 							end
-- 						end,
-- 					},
-- 				},
-- 				lualine_y = {
-- 					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
-- 					{ "location", padding = { left = 0, right = 1 } },
-- 				},
-- 				lualine_z = {
-- 					function()
-- 						return " " .. os.date("%R")
-- 					end,
-- 				},
-- 			},
-- 			extensions = { "neo-tree", "lazy", "fzf" },
-- 		}
--
-- 		-- do not add trouble symbols if aerial is enabled
-- 		-- And allow it to be overriden for some buffer types (see autocmds)
-- 		if vim.g.trouble_lualine and package.has("trouble.nvim") then
-- 			local trouble = require("trouble")
-- 			local symbols = trouble.statusline({
-- 				mode = "symbols",
-- 				groups = {},
-- 				title = false,
-- 				filter = { range = true },
-- 				format = "{kind_icon}{symbol.name:Normal}",
-- 				hl_group = "lualine_c_normal",
-- 			})
-- 			table.insert(opts.sections.lualine_c, {
-- 				symbols and symbols.get,
-- 				cond = function()
-- 					return vim.b.trouble_lualine ~= false and symbols.has()
-- 				end,
-- 			})
-- 		end
--
-- 		return opts
-- 	end,
-- }
