local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "which-key.nvim" })

	require("which-key").setup({
		preset = "helix",
	})
end

return M
