return {
	"NickvanDyke/opencode.nvim",
	cmd = { "Opencode" },
	dependencies = {
		{
			"folke/snacks.nvim",
			opts = { input = {}, picker = {}, terminal = {} },
		},
	},

	config = function()
		vim.g.opencode_opts = {}
		vim.o.autoread = true
	end,
}
