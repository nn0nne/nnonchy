local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "yazi.nvim" })

	vim.keymap.set("n", "<leader>Y", "<cmd>Yazi<cr>", { desc = "Open yazi at current file" })
end

return M
