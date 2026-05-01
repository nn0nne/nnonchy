-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/error-viewer.lua
local M = {}

local lazy = require("nnonne.utils.lazy")
local pack = require("nnonne.commands.pack")

local function with_trouble(fn)
	lazy.load_once("trouble", pack.pluglist({ "trouble.nvim" }), function()
		require("trouble").setup({})
	end)
	fn()
end

function M.setup()
	vim.keymap.set("n", "<leader>xd", function()
		with_trouble(function()
			vim.cmd("Trouble diagnostics toggle filter.buf=0")
		end)
	end, { desc = "Buffer Diagnostics" })
	vim.keymap.set("n", "<leader>xx", function()
		with_trouble(function()
			require("trouble").toggle({
				mode = "diagnostics",
				filter = {
					{
						severity = vim.diagnostic.severity.ERROR,
						function(item)
							return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
						end,
					},
				},
			})
		end)
	end, { desc = "Workspace Diagnostics" })
end

return M
