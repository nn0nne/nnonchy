return {
	-- Comments
	{
		"echasnovski/mini.comment",
		version = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			-- Disable the autocommand from ts-context-commentstring
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})

			require("mini.comment").setup({
				-- tsx, jsx, html, svelte comment support
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring({
							key = "commentstring",
						}) or vim.bo.commentstring
					end,
				},
			})
		end,
	},

	-- Surround
	{
		"echasnovski/mini.surround",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			custom_surroundings = nil,
			highlight_duration = 300,

			-- saiw → surround without whitespace
			-- saw  → surround with whitespace
			mappings = {
				add = "sa", -- Add surrounding
				delete = "ds", -- Delete surrounding
				find = "sf", -- Find surrounding (right)
				find_left = "sF", -- Find surrounding (left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn",

				suffix_last = "l", -- Search previous
				suffix_next = "n", -- Search next
			},

			n_lines = 20,
			respect_selection_type = false,
			search_method = "cover",
			silent = false,
		},
	},

	-- Trailing whitespace
	{
		"echasnovski/mini.trailspace",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local miniTrailspace = require("mini.trailspace")

			miniTrailspace.setup({
				only_in_normal_buffers = true,
			})

			vim.keymap.set("n", "<leader>cw", function()
				miniTrailspace.trim()
			end, { desc = "Trim trailing whitespace" })

			-- Ensure highlight never reappears
			vim.api.nvim_create_autocmd("CursorMoved", {
				pattern = "*",
				callback = function()
					require("mini.trailspace").unhighlight()
				end,
			})
		end,
	},

	-- Split & join
	{
		"echasnovski/mini.splitjoin",
		config = function()
			local miniSplitJoin = require("mini.splitjoin")

			miniSplitJoin.setup({
				mappings = { toggle = "" }, -- Disable default mapping
			})

			vim.keymap.set({ "n", "x" }, "sj", function()
				miniSplitJoin.join()
			end, { desc = "Join arguments" })

			vim.keymap.set({ "n", "x" }, "sk", function()
				miniSplitJoin.split()
			end, { desc = "Split arguments" })
		end,
	},
}
