local M = {}

M.spec = {
	-- Clear highlights
	{
		"<Esc>",
		"<cmd>nohlsearch<CR>",
		desc = "Clear highlights",
		mode = "n",
	},

	-- Centered scrolling
	{
		"<C-d>",
		"<C-d>zz",
		desc = "Scroll down and center cursor",
		mode = "n",
	},
	{
		"<C-u>",
		"<C-u>zz",
		desc = "Scroll up and center cursor",
		mode = "n",
	},

	-- Terminal
	{
		"<Esc><Esc>",
		"<C-\\><C-n>",
		desc = "Exit terminal mode",
		mode = "t",
	},

	-- Smart search + centered (fixes duplicate mapping warning)
	{
		"n",
		"nzzzv",
		desc = "Next search result centered",
		mode = "n",
	},
	{
		"N",
		"Nzzzv",
		desc = "Previous search result centered",
		mode = "n",
	},

	-- Better Up/Down
	{
		"j",
		"v:count == 0 ? 'gj' : 'j'",
		desc = "Down",
		mode = { "n", "x" },
		expr = true,
		silent = true,
	},
	{
		"<Down>",
		"v:count == 0 ? 'gj' : 'j'",
		desc = "Down",
		mode = { "n", "x" },
		expr = true,
		silent = true,
	},
	{
		"k",
		"v:count == 0 ? 'gk' : 'k'",
		desc = "Up",
		mode = { "n", "x" },
		expr = true,
		silent = true,
	},
	{
		"<Up>",
		"v:count == 0 ? 'gk' : 'k'",
		desc = "Up",
		mode = { "n", "x" },
		expr = true,
		silent = true,
	},

	-- Window Resizing
	{
		"<C-Up>",
		"<cmd>resize +2<cr>",
		desc = "Increase Window Height",
		mode = "n",
	},
	{
		"<C-Down>",
		"<cmd>resize -2<cr>",
		desc = "Decrease Window Height",
		mode = "n",
	},
	{
		"<C-Left>",
		"<cmd>vertical resize -2<cr>",
		desc = "Decrease Window Width",
		mode = "n",
	},
	{
		"<C-Right>",
		"<cmd>vertical resize +2<cr>",
		desc = "Increase Window Width",
		mode = "n",
	},

	-- Move Lines
	{
		"J",
		":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
		desc = "Move Down",
		mode = "v",
	},
	{
		"K",
		":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
		desc = "Move Up",
		mode = "v",
	},

	-- Indenting
	{
		"<",
		"<gv",
		desc = "Indent left",
		mode = "v",
	},
	{
		">",
		">gv",
		desc = "Indent right",
		mode = "v",
	},

	-- Join lines & keep cursor
	{
		"J",
		"mzJ`z",
		desc = "Join lines without moving cursor",
		mode = "n",
	},

	-- Buffers
	{
		"<S-h>",
		"<cmd>bprevious<cr>",
		desc = "Prev Buffer",
		mode = "n",
	},
	{
		"<S-l>",
		"<cmd>bnext<cr>",
		desc = "Next Buffer",
		mode = "n",
	},
	{ "<leader>b", group = "Buffers" },
	{
		"<leader>bd",
		"<cmd>bdelete<cr>",
		desc = "Delete Buffer",
		mode = "n",
	},
	{
		"<S-M-h>",
		"<cmd>BufferLineMovePrev<cr>",
		desc = "Move Buffer Left",
		mode = "n",
	},
	{
		"<S-M-l>",
		"<cmd>BufferLineMoveNext<cr>",
		desc = "Move Buffer Right",
		mode = "n",
	},

	-- Windows
	{
		"<leader>wh",
		"<C-W>s",
		desc = "Split Window Below",
		mode = "n",
		remap = true,
	},
	{
		"<leader>wv",
		"<C-W>v",
		desc = "Split Window Right",
		mode = "n",
		remap = true,
	},
	{ "<leader>w", group = "Windows" },
	{
		"<leader>wd",
		"<C-W>c",
		desc = "Delete Window",
		mode = "n",
		remap = true,
	},
	{
		"<leader>we",
		"<C-w>=",
		desc = "Equalize split sizes",
		mode = "n",
	},

	-- Files / Find
	{ "<leader>f", group = "Find" },
	{
		"<leader>ff",
		function()
			require("mini.pick").builtin.files({ tool = "rg" })
		end,
		desc = "Find Files",
		mode = "n",
	},
	{
		"<leader>fg",
		function()
			require("mini.pick").builtin.grep_live({ tool = "rg" })
		end,
		desc = "Live Grep",
		mode = "n",
	},
	-- Explorer
	{
		"<leader>e",
		function()
			require("mini.files").open(vim.uv.cwd(), true)
		end,
		desc = "Explorer (mini.files)",
		mode = "n",
	},
	{
		"<leader>E",
		function()
			local bufname = vim.api.nvim_buf_get_name(0)
			if bufname == "" then
				require("mini.files").open(vim.uv.cwd(), true)
			else
				require("mini.files").open(bufname, true)
			end
		end,
		desc = "Explorer at current file",
		mode = "n",
	},

	-- TODO: Halo Bang

	-- Trouble
	{ "<leader>x", group = "Trouble" },
	{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics", mode = "n" },
	{
		"<leader>xx",
		function()
			require("trouble").toggle({
				mode = "diagnostics",
				filter = {
					any = {
						{
							severity = vim.diagnostic.severity.ERROR,
							function(item)
								return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
							end,
						},
					},
				},
			})
		end,
		desc = "Buffer Diagnostics",
		mode = "n",
	},
	-- Git
	{ "<leader>g", group = "Git" },
	{
		"<leader>gg",
		function()
			require("gitui").open()
		end,
		desc = "Open GitUI",
		mode = "n",
	},
}

return M
