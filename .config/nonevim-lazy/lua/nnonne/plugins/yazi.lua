return {
	"mikavilpas/yazi.nvim",
	version = "*", -- use the latest stable version
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
		{
			"durelius/yazi-lsp-info.nvim",
			opts = {
				debug = false,
				memory = { max_lsp_buffer_files = 20, files_per_batch = 5 },
			},
		},
	},
	keys = {
		-- 👇 in this section, choose your own keymappings!
		{
			"<leader>Y",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
	},
	---@type YaziConfig | {}
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
		},
		hooks = {
			yazi_opened = function()
				-- This plugin ships lua/init.lua, so its real module name is "init",
				-- not the repo name used by lazy.nvim.
				local ok, mod = pcall(require, "yazi-lsp-info")
				if not ok then
					mod = require("init")
				end
				mod.refresh()
			end,
		},
	},
	-- 👇 if you use `open_for_directories=true`, this is recommended
	init = function()
		-- mark netrw as loaded so it's not loaded at all.
		--
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		vim.g.loaded_netrwPlugin = 1
	end,
}
