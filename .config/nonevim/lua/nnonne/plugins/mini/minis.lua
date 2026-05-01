local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

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
	require("mini.bracketed").setup()
	require("mini.extra").setup()
	require("mini.jump").setup()
end

return M
