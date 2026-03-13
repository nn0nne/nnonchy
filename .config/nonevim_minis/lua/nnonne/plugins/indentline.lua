return {
	"lukas-reineke/indent-blankline.nvim",
	-- event = "VeryLazy",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = { "│" },
		},
	},
	config = function()
		require("ibl").setup()
	end,
}
