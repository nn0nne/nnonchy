local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

	require("mini.pick").setup()

	vim.keymap.set("n", "<leader>ff", function()
		require("mini.pick").builtin.files({ tool = "fd" })
	end, { desc = "Find Files" })

	vim.keymap.set("n", "<leader>fg", function()
		require("mini.pick").builtin.grep_live({ tool = "rg" })
	end, { desc = "Live Grep" })

	vim.keymap.set("n", "<leader>gf", function()
		require("mini.pick").builtin.files({ tool = "git" })
	end, { desc = "Find Files" })

	vim.keymap.set("n", "<leader>gg", function()
		require("mini.pick").builtin.grep_live({ tool = "git" })
	end, { desc = "Live Grep" })

	vim.keymap.set("n", "<leader>ft", function()
		require("mini.pick").builtin.grep({
			pattern = "TODO|HACK|BUG|WARNING|NOTE|FIXME",
		})
	end, { desc = "Live Grep" })
end

return M
