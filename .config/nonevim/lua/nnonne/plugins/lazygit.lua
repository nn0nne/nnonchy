local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "lazygit.nvim" })

	vim.keymap.set("n", "<leader>gt", "<cmd>LazyGit<cr>", { desc = "Toggle floating terminal" })
end

return M
