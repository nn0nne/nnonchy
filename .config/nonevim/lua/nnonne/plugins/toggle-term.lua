local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "toggleterm.nvim" })

	require("toggleterm").setup({ direction = "float", persist_size = false, float_opts = {
		border = "single",
	} })

	vim.keymap.set({ "n", "t" }, "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle floating terminal" })
end

return M
