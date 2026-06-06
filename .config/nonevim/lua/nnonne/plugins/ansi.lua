local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "ansi.nvim" })

	require("ansi").setup()
end

return M
