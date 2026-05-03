-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/search-replace.lua
local M = {}

local pack = require("nnonne.commands.pack")
local lazy = require("nnonne.utils.lazy")

local function with_grug(fn)
	lazy.load_once("grug-far", pack.pluglist({ "grug-far.nvim" }), function()
		require("grug-far").setup({})
	end)
	fn(require("grug-far"))
end

function M.setup()
	vim.keymap.set("n", "<leader>Ss", function()
		with_grug(function()
			vim.cmd("GrugFar")
		end)
	end, { desc = "Search/replace project" })

	vim.keymap.set("n", "<leader>Sc", function()
		with_grug(function(grug)
			grug.open({ prefills = { paths = vim.fn.expand("%") } })
		end)
	end, { desc = "Search/replace current file" })

	vim.keymap.set("x", "<leader>Sx", function()
		with_grug(function(grug)
			grug.open({ visualSelectionUsage = "operate-within-range" })
		end)
	end, { desc = "Search/replace in selection" })
end

return M
