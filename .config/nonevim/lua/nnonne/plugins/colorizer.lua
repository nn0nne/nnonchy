return {
	"norcalli/nvim-colorizer.lua",
	event = { "BufReadPost", "BufNewFile" },
	ft = {
		"html",
		"css",
		"tsx",
		"jsx",
		"rasi",
	},
	config = function()
		require("colorizer").setup()
	end,
}
