local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "toggleterm.nvim" })

	require("toggleterm").setup({ direction = "float", persist_size = false, float_opts = {
		border = "single",
	} })

	vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle floating terminal" })
	vim.keymap.set("n", "<leader>gt", function()
		require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true }):toggle()
	end, { desc = "Toggle GitUI" })
end

return M
