return {
	"nvim-flutter/flutter-tools.nvim",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	ft = "dart",
	config = function()
		local ft = require("flutter-tools")

		ft.setup({
			ui = {
				border = "rounded",
				notification_style = "native",
			},
			decorations = {
				statusline = {
					app_version = true,
					device = true,
					project_config = true,
				},
			},
			debugger = {
				enabled = false, -- enable nvim-dap integration -- idk have nvim-dap so disabled
				exception_breakpoints = { "all" },
				evaluate_to_string_in_debug_views = true,
			},
			flutter_path = nil, -- leave nil if flutter is in $PATH
			flutter_lookup_cmd = nil, -- optional: use if flutter_path is custom
			root_patterns = { ".git", "pubspec.yaml" },
			fvm = false, -- enable if using FVM
			widget_guides = { enabled = true },
			closing_tags = {
				highlight = "ErrorMsg",
				prefix = ">",
				enabled = true,
			},
			dev_log = {
				enabled = true,
				open_cmd = "15split",
				focus_on_open = true,
			},
			outline = {
				open_cmd = "30vnew",
				auto_open = false,
			},
			lsp = {
				color = { enabled = true, virtual_text = true, virtual_text_str = "■" },
				on_attach = function(client, bufnr)
					-- Default keymaps
					local buf_map = function(mode, lhs, rhs, opts)
						opts = opts or { noremap = true, silent = true }
						vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
					end

					buf_map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
					buf_map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
					buf_map("n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
					buf_map("x", "<leader>ca", "<Cmd>lua vim.lsp.buf.range_code_action()<CR>")
				end,
				capabilities = vim.lsp.protocol.make_client_capabilities(),
				settings = {
					showTodos = true,
					completeFunctionCalls = true,
					analysisExcludedFolders = {},
					renameFilesWithClasses = "prompt",
					enableSnippets = true,
					updateImportsOnRename = true,
				},
			},
		})

		-- Optional: setup Telescope integration
		pcall(function()
			require("mini.picker").load_extension("flutter")
		end)
	end,
}
