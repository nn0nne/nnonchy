return {
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		dependencies = { "rafamadriz/friendly-snippets" },
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",

		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			-- require("nnonne.snippets.all") -- I don't have one so commented for now
		end,
	},
}
