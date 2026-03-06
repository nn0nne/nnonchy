return {
	"akinsho/toggleterm.nvim",
	version = "*",

	opts = {
		start_in_insert = true,
		open_mapping = "ESC",
	},

	keys = {
		{ "<leader>tt", desc = "Float Terminal" },
		{ "<leader>tv", desc = "Vertical Terminal" },
		{ "<leader>th", desc = "Horizontal Terminal" },
	},

	config = function(_, opts)
		require("toggleterm").setup(opts)

		local Terminal = require("toggleterm.terminal").Terminal

		local runner_term = Terminal:new({
			cmd = "bash",
			hidden = false,
			direction = "float",
		})

		vim.keymap.set("n", "<leader>tt", function()
			runner_term.direction = "float"
			runner_term:toggle()
		end)

		vim.keymap.set("n", "<leader>tv", function()
			runner_term.direction = "vertical"
			runner_term:toggle()
		end)

		vim.keymap.set("n", "<leader>th", function()
			runner_term.direction = "horizontal"
			runner_term:toggle()
		end)
	end,
}
