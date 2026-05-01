-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/cmp.lua

local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "blink.cmp", "friendly-snippets" })

	require("blink.cmp").setup({
		keymap = {
			preset = "default",
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-s>"] = { "show_signature", "hide_signature" },
			["<CR>"] = { "select_and_accept", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = { documentation = { auto_show = false } },
		snippets = { preset = "mini_snippets" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	})
end

return M
