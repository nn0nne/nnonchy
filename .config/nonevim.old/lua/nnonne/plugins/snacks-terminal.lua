-- https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
return {
	{
		"folke/edgy.nvim",
		---@module 'edgy'
		---@param opts Edgy.Config
		opts = function(_, opts)
			for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
				opts[pos] = opts[pos] or {}
				table.insert(opts[pos], {
					ft = "snacks_terminal",
					size = { height = 0.4 },
					title = "%{b:snacks_terminal.id}: %{b:term_title}",
					filter = function(_buf, win)
						return vim.w[win].snacks_win
							and vim.w[win].snacks_win.position == pos
							and vim.w[win].snacks_win.relative == "editor"
							and not vim.w[win].trouble_preview
					end,
				})
			end
		end,
	},
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			---@class snacks.terminal.Config
			terminal =
				---@field win? snacks.win.Config|{}
				---@field shell? string|string[] The shell to use. Defaults to `vim.o.shell`
				---@field override? fun(cmd?: string|string[], opts?: snacks.terminal.Opts) Use this to use a different terminal implementation
				{
					enabled = true,
					win = { style = "terminal" },
				},
		},
		keys = {},
	},
}
