return -- lazy.nvim
{
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		---@class snacks.input.Config
		input =
			---@field enabled? boolean
			---@field win? snacks.win.Config|{}
			---@field icon? string
			---@field icon_pos? snacks.input.Pos
			---@field prompt_pos? snacks.input.Pos
			{
				enabled = true,
				icon = " ",
				icon_hl = "SnacksInputIcon",
				icon_pos = "left",
				prompt_pos = "title",
				win = { style = "input" },
				expand = true,
			},
	},
}
