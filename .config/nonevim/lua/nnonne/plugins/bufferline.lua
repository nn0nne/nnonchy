local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "bufferline.nvim" })

	require("bufferline").setup({
		options = {
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,
			separator_style = "thin",
			sort_by = "insert_after_current",
		},
	})
end

return M
