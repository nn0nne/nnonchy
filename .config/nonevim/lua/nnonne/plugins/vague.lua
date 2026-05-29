local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "vague.nvim" })

	require("vague").setup({
		transparent = true,
	})

	vim.cmd.colorscheme("vague")
end

return M
