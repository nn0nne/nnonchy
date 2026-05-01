local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "vague.nvim" })

	vim.cmd.colorscheme("vague")
end

return M
