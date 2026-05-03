local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

	require("mini.pairs").setup()
	require("mini.icons").setup()
	require("mini.notify").setup()
	require("mini.extra").setup()
	require("mini.jump").setup()
	require("mini.snippets").setup()
	require("mini.diff").setup({
		view = {
			style = "sign",
		},
	})
	require("mini.hipatterns").setup({
		highlighters = {
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
			-- TODO Dart/Flutter color
			-- dart_color = {
			-- 	pattern = "0x%x%x(%x%x%x%x%x%x)%f[%X]",
			-- 	group = function(_, _, match)
			-- 		local hex = "#" .. match:sub(-6)
			-- 		return require("mini.hipatterns").compute_hex_color_group(hex, "bg")
			-- 	end,
			-- },
			hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
		},
	})
	require("mini.indentscope").setup({
		draw = {
			animation = function()
				return 0
			end,
		},
	})
	require("mini.ai").setup({
		mappings = {
			around = "a",
			inside = "i",

			around_next = "an",
			inside_next = "in",
			around_last = "al",
			inside_last = "il",

			goto_left = "g[",
			goto_right = "g]",
		},
	})
	require("mini.bracketed").setup({
		buffer = { suffix = "b", options = {} },
		comment = { suffix = "c", options = {} },
		conflict = { suffix = "x", options = {} },
		diagnostic = { suffix = "d", options = {} },
		file = { suffix = "f", options = {} },
		indent = { suffix = "i", options = {} },
		jump = { suffix = "j", options = {} },
		location = { suffix = "l", options = {} },
		oldfile = { suffix = "o", options = {} },
		quickfix = { suffix = "q", options = {} },
		treesitter = { suffix = "t", options = {} },
		undo = { suffix = "u", options = {} },
		window = { suffix = "w", options = {} },
		yank = { suffix = "y", options = {} },
	})
	require("mini.surround").setup({
		mappings = {
			add = "<leader>sa",
			delete = "<leader>sd",
			find = "<leader>sf",
			find_left = "<leader>sF",
			highlight = "<leader>sh",
			replace = "<leader>sr",

			suffix_last = "<leader>l",
			suffix_next = "<leader>n",
		},
	})
end

return M
