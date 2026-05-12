local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "toggleterm.nvim" })

	require("toggleterm").setup({ direction = "float", float_opts = {
		border = "shadow",
	} })

	vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle floating terminal" })
	vim.keymap.set("n", "<leader>gt", function()
		require("toggleterm.terminal").Terminal:new({ cmd = "gitui", hidden = true }):toggle()
	end, { desc = "Toggle GitUI" })
	-- vim.keymap.set("n", "<leader>ot", function()
	-- 	require("toggleterm.terminal").Terminal
	-- 		:new({
	-- 			cmd = "opencode",
	-- 			hidden = true,
	-- 			on_open = function(term)
	-- 				vim.cmd("startinsert!")
	-- 				vim.api.nvim_buf_set_keymap(
	-- 					term.bufnr,
	-- 					"n",
	-- 					"q",
	-- 					"<cmd>close<CR>",
	-- 					{ noremap = true, silent = true }
	-- 				)
	-- 			end,
	-- 		})
	-- 		:toggle()
	-- end, { desc = "Toggle Opencode" })
end

return M
