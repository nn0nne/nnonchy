return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
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
				config = function()
					local group = vim.api.nvim_create_augroup("OoO", {})

					vim.api.nvim_create_autocmd("LspAttach", {
						desc = "LSP actions",
						callback = function(event)
							local opts = { buffer = event.buf }

							-- Your keymaps
							vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
							vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
							vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
							vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
							vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
							vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
							vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
							vim.keymap.set("n", "crn", vim.lsp.buf.rename, opts)
							vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)
							vim.keymap.set("n", "ce", ":w<CR>:e<CR>", opts)
						end,
					})

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
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{
				"nvim-mini/mini.snippets",
				version = "*",
				config = function()
					require("mini.snippets").setup({
						snippets = {
							require("mini.snippets").gen_loader.from_lang(),
						},
					})
				end,
				opts = {
					sources = {
						-- add lazydev to your completion providers
						default = { "lazydev", "lsp", "path", "snippets", "buffer" },
						providers = {
							lazydev = {
								name = "LazyDev",
								module = "lazydev.integrations.blink",
								-- make lazydev completions top priority (see `:h blink.cmp`)
								score_offset = 100,
							},
						},
					},
				},
			},
		},
		version = "1.*",
		opts = {
			snippets = { preset = "mini_snippets" },
			keymap = {
				preset = "default",
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-s>"] = { "show_signature", "hide_signature" },
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			-- appearance = { nerd_font_variant = "mono" },
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
			-- signature = { enabled = true },
			-- fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{ "antosha417/nvim-lsp-file-operations", config = true },
}
