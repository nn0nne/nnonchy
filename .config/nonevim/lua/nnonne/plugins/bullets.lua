local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "bullets.vim" })
end

return M
