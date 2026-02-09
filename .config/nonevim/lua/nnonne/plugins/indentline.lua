return {
	"lukas-reineke/indent-blankline.nvim",
	event = "VeryLazy",
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
