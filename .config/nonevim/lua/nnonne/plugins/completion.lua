-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/cmp.lua
-- Shout out https://github.com/gonstoll/dotfiles/blob/master/.config/nvim/lua/plugins/blink.lua

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
		-- cmdline = {
		--   enabled = true,
		--   completion = {
		--     menu = {auto_show = true},
		--     list = {
		--       selection = {preselect = false}
		--     }
		--   },
		-- },
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			trigger = {
				show_on_accept_on_trigger_character = false,
			},
			list = {
				selection = {
					-- preselect = false,
					auto_insert = false,
				},
			},
			menu = {
				-- border = "none",
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "label", gap = 2 },
						{ "kind_icon", gap = 1, "kind" },
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					-- border = "none",
					max_width = math.floor(vim.o.columns * 0.4),
					max_height = math.floor(vim.o.lines * 0.5),
				},
			},
		},
		snippets = { preset = "mini_snippets" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "lazydev" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				lsp = {
					fallbacks = { "buffer", "path" },
				},
				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					min_keyword_length = 3,
					opts = {
						-- friendly_snippets = true,
						-- search_paths = {vim.fn.stdpath("config") .. "/snippets/nvim"}
					},
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	})
end

return M
