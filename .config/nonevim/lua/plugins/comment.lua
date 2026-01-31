return {
	{
		"nvim-mini/mini.comment",
		version = "*",
		config = function()
			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						-- Ask treesitter what the commentstring should be
						return require("ts_context_commentstring.internal").calculate_commentstring()
							or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "VeryLazy",
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
}
