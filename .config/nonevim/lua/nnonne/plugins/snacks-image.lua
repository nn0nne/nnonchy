local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "snacks.nvim" })
	require("snacks").setup({
		image = { force = true, doc = { inline = false } },
		terminal = { win = { style = "terminal" } },
	})
end

return M
