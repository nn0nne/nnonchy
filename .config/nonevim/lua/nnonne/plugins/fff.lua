local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "fff" })

	require("fff").setup({
		prompt = "> ",
		layout = {
			prompt_position = "top",
		},
		lazy_sync = true,
		debug = { enabled = true, show_scores = true },
	})

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			if name == "fff" and (kind == "install" or kind == "update") then
				if not ev.data.active then
					vim.cmd.packadd("fff.nvim")
				end
				require("fff.download").download_or_build_binary()
			end
		end,
	})

	vim.keymap.set("n", "<leader>ff", function()
		require("fff").find_files()
	end, { desc = "Find files - FFF" })
	vim.keymap.set("n", "<leader>fg", function()
		require("fff").live_grep()
	end, { desc = "Grep files - FFF" })
	vim.keymap.set("n", "<leader>fz", function()
		require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
	end, { desc = "Grep files - FFF" })
end

return M
