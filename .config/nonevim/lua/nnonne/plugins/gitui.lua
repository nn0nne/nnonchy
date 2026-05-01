local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "gitui.nvim" })

	vim.keymap.set("n", "<leader>gg", function()
		require("gitui").open()
	end, { desc = "Open GitUI" })
end

return M
