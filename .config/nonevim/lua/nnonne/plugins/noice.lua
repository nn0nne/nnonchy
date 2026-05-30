local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "noice.nvim", "nui.nvim" })
	require("noice").setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
		notify = {
			enabled = false,
		},
		messages = {
			enabled = true,
			view_search = false,
		},
		cmdline = {
			enabled = false,
		},
		popupmenu = {
			enabled = false,
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "L, " }, -- Catches files line dumps: "17L, 432B"
						{ find = "written" }, -- Catches standard "written" hooks
						{ find = "Formatted" }, -- Catches standard "written" hooks
					},
				},
				opts = { skip = true }, -- Deletes them instantly before rendering
			},
		},
	})
end

return M
