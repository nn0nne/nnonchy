local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "nvim-dap", "nvim-dap-view" })

	require("dap-view").setup({
		windows = {
			position = "left",
		},
	})

	vim.keymap.set("n", "<leader>Dc", require("dap").continue, { desc = "DAP: Start/Continue Session" })

	vim.keymap.set("n", "<leader>Db", require("dap").toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })

	vim.keymap.set("n", "<leader>Di", require("dap").step_into, { desc = "DAP: Step Into" })

	vim.keymap.set("n", "<leader>Do", require("dap").step_over, { desc = "DAP: Step Over" })

	vim.keymap.set("n", "<leader>Dx", require("dap").step_out, { desc = "DAP: Step Out" })

	vim.keymap.set("n", "<leader>Dq", require("dap").terminate, { desc = "DAP: Stop Debugging" })

	vim.keymap.set("n", "<leader>Dt", function()
		require("dap-view").toggle()
	end, { desc = "Toggle Dap View" })
end

return M
