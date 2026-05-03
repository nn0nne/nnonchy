local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

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
end

return M
