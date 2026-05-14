local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "yazi.nvim" })
end

return M
