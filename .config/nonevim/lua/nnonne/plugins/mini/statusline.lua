local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

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
end

return M
