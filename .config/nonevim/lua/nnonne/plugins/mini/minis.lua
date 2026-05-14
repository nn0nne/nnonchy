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
	require("mini.extra").setup()
	require("mini.pick").setup()

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			local opts = { buffer = ev.buf, silent = true }
			local extra = require("mini.extra")

			-- Keymaps

			opts.desc = "Show LSP references"
			-- Replaces Telescope lsp_references
			vim.keymap.set("n", "gR", function()
				extra.pickers.lsp({ scope = "references" })
			end, opts)

			opts.desc = "Go to declaration"
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

			opts.desc = "Show LSP definitions"
			-- Replaces Telescope lsp_definitions
			vim.keymap.set("n", "gd", function()
				extra.pickers.lsp({ scope = "definition" })
			end, opts)

			opts.desc = "Show LSP implementations"
			-- Replaces Telescope lsp_implementations
			vim.keymap.set("n", "gi", function()
				extra.pickers.lsp({ scope = "implementation" })
			end, opts)

			opts.desc = "Show LSP type definitions"
			-- Replaces Telescope lsp_type_definitions
			vim.keymap.set("n", "gt", function()
				extra.pickers.lsp({ scope = "type_definition" })
			end, opts)

			opts.desc = "See available code actions"
			vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts)

			opts.desc = "Smart rename"
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

			opts.desc = "Show buffer diagnostics"
			-- Replaces Telescope diagnostics
			vim.keymap.set("n", "<leader>D", function()
				extra.pickers.diag({ scope = "current" })
			end, opts)

			opts.desc = "Show line diagnostics"
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

			opts.desc = "Show documentation"
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

			opts.desc = "Restart LSP"
			vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

			opts.desc = "Signature Help"
			vim.keymap.set("i", "<C-h>", function()
				-- Using blink.cmp for signature help is much smoother
				require("blink.cmp").show_signature()
			end, opts)
		end,
	})
end

return M
