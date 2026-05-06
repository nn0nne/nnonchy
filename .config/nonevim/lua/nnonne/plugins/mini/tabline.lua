local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

	require("mini.tabline").setup({
		show_icons = true,
		format = function(buf_id, label)
			local default = require("mini.tabline").default_format(buf_id, label)

			local errors = #vim.diagnostic.get(buf_id, { severity = vim.diagnostic.severity.ERROR })
			local warnings = #vim.diagnostic.get(buf_id, { severity = vim.diagnostic.severity.WARN })

			local diagnostic_suffix = ""
			if errors > 0 then
				diagnostic_suffix = diagnostic_suffix .. "  " .. errors
			end
			if warnings > 0 then
				diagnostic_suffix = diagnostic_suffix .. "  " .. warnings
			end

			return default .. diagnostic_suffix
		end,
	})

	vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = "#6e94b2", fg = "#141415" })
	vim.api.nvim_set_hl(0, "MiniTablineHidden", { bg = "#141415", fg = "#606079" })
	vim.api.nvim_set_hl(0, "MiniTablineVisible", { bg = "#6e94b2", fg = "#252530" })
	vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { bg = "#cdcdcd", fg = "#252530" })
	vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { bg = "#cdcdcd", fg = "#252530" })
	vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { bg = "#cdcdcd", fg = "#141415" })
end

return M
