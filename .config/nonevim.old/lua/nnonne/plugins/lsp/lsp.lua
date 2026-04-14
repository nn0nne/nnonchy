return {
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre" },
		opts = {
			ensure_installed = {
				"basedpyright",
				"bashls",
				"clangd",
				"cssls",
				"css_variables",
				"docker_compose_language_service",
				"dockerls",
				"emmet_language_server",
				"eslint",
				"gopls",
				"gradle_ls",
				"groovyls",
				"html",
				"jsonls",
				"lua_ls",
				"prismals",
				"ruff",
				"rust_analyzer",
				"stylua",
				"tailwindcss",
				"taplo",
				"vtsls",
				"yamlls",
				"zls",
			},
		},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			{
				"neovim/nvim-lspconfig",
				dependencies = { "saghen/blink.cmp" },
				event = { "BufReadPre" },
				config = function()
					local group = vim.api.nvim_create_augroup("OoO", {})

					-- vim.api.nvim_create_autocmd("LspAttach", {
					-- 	desc = "LSP actions",
					-- 	callback = function(event)
					-- 		local opts = { buffer = event.buf }
					--
					-- 		-- Your keymaps
					-- 		-- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					-- 		--                      vim.keymap.set("<>", group = "")
					-- 		-- vim.keymap.set("n", "crn", function()
					-- 		-- 	Snacks.rename.rename_file()
					-- 		-- end, opts)
					-- 		-- vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)
					-- 		-- vim.keymap.set("n", "ce", ":w<CR>:e<CR>", opts)
					-- 	end,
					-- })

					local function au(typ, pattern, cmdOrFn)
						if type(cmdOrFn) == "function" then
							vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
						else
							vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
						end
					end

					au({ "CursorHold" }, nil, function()
						local opts = {
							focusable = false,
							scope = "cursor",
							close_events = { "BufLeave", "CursorMoved" },
						}
						vim.diagnostic.open_float(nil, opts)
					end)
				end,
			},
		},
	},
	{
		"saghen/blink.cmp",
		event = { "BufReadPre" },
		dependencies = {
			{ "rafamadriz/friendly-snippets", event = { "BufReadPost", "BufNewFile" } },
		},
		version = "1.*",
		opts = {
			keymap = {
				preset = "default",
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-s>"] = { "show_signature", "hide_signature" },
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					snippets = {
						opts = {
							friendly_snippets = true,
						},
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
	{ "antosha417/nvim-lsp-file-operations", config = true, event = { "BufReadPre" } },
}
