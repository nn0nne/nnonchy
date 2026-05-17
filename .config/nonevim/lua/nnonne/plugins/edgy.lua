local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "edgy.nvim" })

	require("edgy").setup({
		-- Reserve the right side of your editor exclusively for OpenCode
		right = {
			{
				ft = "terminal",
				-- This filter ensures edgy ONLY captures the terminal if it's running opencode
				filter = function(buf)
					return vim.b[buf].terminal_job_cmd and vim.b[buf].terminal_job_cmd:find("opencode")
				end,
				title = "OpenCode Assistant",
				size = { width = math.floor(vim.o.columns * 0.5) },
			},
		},
		-- Reserve the bottom split exclusively for Flutter Logs
		-- bottom = {
		-- 	{
		-- 		ft = "flutterLog",
		-- 		title = "Flutter Logs",
		-- 		size = { height = 12 },
		-- 	},
		-- },
		options = {
			left = { size = 30 },
			bottom = { size = 10 },
			right = { size = math.floor(vim.o.columns * 0.5) },
			top = { size = 10 },
		},
	})
end

return M
