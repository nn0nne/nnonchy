local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "flutter-tools.nvim", "plenary.nvim", "dressing.nvim" })
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "dart",
		once = true,
		callback = function()
			require("flutter-tools").setup({
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
					-- color = { enabled = true, virtual_text = true, virtual_text_str = "■" },
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
		end,
	})

	-- Flutter Keymaps
	vim.keymap.set("n", "<leader>Frn", "<Cmd>FlutterRun<CR>", { desc = "Run project" })
	vim.keymap.set("n", "<leader>Fd", "<Cmd>FlutterDebug<CR>", { desc = "Debug project" })
	vim.keymap.set("n", "<leader>Flt", "<Cmd>FlutterLogToggle<CR>", { desc = "Toggle Dev Log" })
	vim.keymap.set("n", "<leader>Flc", "<Cmd>FlutterLogClear<CR>", { desc = "Clear Dev Log" })
	vim.keymap.set("n", "<leader>Frl", "<Cmd>FlutterReload<CR>", { desc = "Hot Reload" })
	vim.keymap.set("n", "<leader>Frr", "<Cmd>FlutterRestart<CR>", { desc = "Hot Restart" })
	vim.keymap.set("n", "<leader>Fq", "<Cmd>FlutterQuit<CR>", { desc = "Quit app" })
	vim.keymap.set("n", "<leader>Fo", "<Cmd>FlutterOutlineToggle<CR>", { desc = "Toggle Outline" })
	vim.keymap.set("n", "<leader>Fs", "<Cmd>FlutterDevices<CR>", { desc = "Select Device" })
	vim.keymap.set("n", "<leader>Fe", "<Cmd>FlutterEmulators<CR>", { desc = "Select Emulator" })
	vim.keymap.set("n", "<leader>Fv", "<Cmd>FlutterDevTools<CR>", { desc = "Open DevTools" })

	-- Pubspec Keymaps
	vim.keymap.set("n", "<leader>Fpg", "<Cmd>FlutterPubGet<CR>", { desc = "Flutter Pub Get" })
	vim.keymap.set("n", "<leader>Fpu", "<Cmd>FlutterPubUpgrade<CR>", { desc = "Flutter Pub Upgrade" })
	vim.keymap.set(
		"n",
		"<leader>Fpc",
		"<Cmd>lua require('snacks').terminal.open('flutter clean')<CR>",
		{ desc = "Flutter Clean" }
	)

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(ev)
			vim.lsp.document_color.enable(true, { bufnr = ev.buf })
		end,
	})
end

return M
