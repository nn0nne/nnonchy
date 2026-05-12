local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "toggleterm.nvim" })

	require("toggleterm").setup({ direction = "float" })

	vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle floating terminal" })
	vim.keymap.set("n", "<leader>go", function()
		require("toggleterm.terminal").Terminal:new({ cmd = "gitui", hidden = true, direction = "float" }):toggle()
	end, { desc = "Toggle GitUI" })
end

return M
