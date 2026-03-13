return {
	"NickvanDyke/opencode.nvim",
	cmd = { "Opencode" },
	keys = {
		{
			"<leader>aa",
			function()
				require("opencode").toggle()
			end,
			desc = "Toggle Opencode Terminal",
			mode = { "n", "x" },
		},
		{
			"<leader>as",
			function()
				require("opencode").ask("@this: ", { submit = true })
			end,
			desc = "Ask opencode",
			mode = { "n", "x" },
		},
		{
			"<leader>ax",
			function()
				require("opencode").select()
			end,
			desc = "Execute opencode action…",
			mode = { "n", "x" },
		},
		{
			"<leader>ap",
			function()
				require("opencode").prompt("@this")
			end,
			desc = "Add to opencode",
			mode = { "n", "x" },
		},
		{
			"<S-C-u>",
			function()
				require("opencode").command("session.half.page.up")
			end,
			desc = "opencode half page up",
			mode = "n",
		},
		{
			"<S-C-d>",
			function()
				require("opencode").command("session.half.page.down")
			end,
			desc = "opencode half page down",
			mode = "n",
		},
	},

	dependencies = {
		{
			"folke/snacks.nvim",
			opts = { input = {}, picker = {}, terminal = {} },
		},
		{ "akinsho/toggleterm.nvim" },
	},

	config = function()
		vim.g.opencode_opts = {}
		vim.o.autoread = true
	end,
}
