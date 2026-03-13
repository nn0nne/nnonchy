return {
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		event = { "BufReadPost", "BufNewFile" },
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	-- {
	-- 	"numToStr/Comment.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("Comment").setup({
	-- 			-- pre_hook = function()
	-- 			-- 	return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
	-- 			-- end,
	-- 			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	-- 			padding = true,
	-- 			sticky = true,
	-- 			ignore = nil,
	-- 			toggler = {
	-- 				---line-comment toggle keymap
	-- 				line = "gcc",
	-- 				---block-comment toggle keymap
	-- 				block = "gbc",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"JoosepAlviste/nvim-ts-context-commentstring",
	-- 	event = "BufReadPre",
	-- 	config = function()
	-- 		require("ts_context_commentstring").setup({
	-- 			enable_autocmd = false,
	-- 		})
	-- 	end,
	-- },
}
