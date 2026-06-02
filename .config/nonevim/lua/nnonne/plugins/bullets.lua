local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "bullets.vim" })

	vim.g.bullets_delete_last_bullet_if_empty = 2
end

return M
