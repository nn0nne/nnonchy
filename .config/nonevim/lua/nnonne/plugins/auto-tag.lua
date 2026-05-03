-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/autotag.lua
local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "html", "xml", "javascriptreact", "typescriptreact" },
		once = true,
		callback = function()
			pack.add({ "nvim-ts-autotag" })
			require("nvim-ts-autotag").setup({})
		end,
	})
end

return M
