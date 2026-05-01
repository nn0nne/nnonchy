local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "ts-comments.nvim" })
	require("ts-comments").setup()
end

return M
