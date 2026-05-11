local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "toggleterm.nvim" })

	require("toggleterm").setup({ direction = "float" })

	vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle floating terminal" })
end

return M
