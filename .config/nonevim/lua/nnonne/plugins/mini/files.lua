local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

	require("mini.files").setup({
		mappings = {
			close = "<Esc>",
		},
	})

	vim.keymap.set("n", "<leader>e", function()
		require("mini.files").open(vim.uv.cwd(), true)
	end, { desc = "Explorer (mini.files)" })

	vim.keymap.set("n", "<leader>E", function()
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname == "" then
			require("mini.files").open(vim.uv.cwd(), true)
		else
			require("mini.files").open(bufname, true)
		end
	end, { desc = "Explorer at current file" })
end

return M
