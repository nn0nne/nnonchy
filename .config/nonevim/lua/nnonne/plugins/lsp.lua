return {
	{
		"neovim/nvim-lspconfig",
		-- tag = "v1.8.0",
		-- pin = true,
		version = "*",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			-- "hrsh7th/nvim-cmp",
		},
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local lspconfig_defaults = require("lspconfig").util.default_config
			local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				lspconfig_defaults.capabilities =
					vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, cmp_lsp.default_capabilities())
			end

			-- lspconfig_defaults.capabilities = vim.tbl_deep_extend(
			-- 	"force",
			-- 	lspconfig_defaults.capabilities,
			-- 	require("cmp_nvim_lsp").default_capabilities()
			-- )
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }
					local map = vim.keymap.set
					map("n", "K", vim.lsp.buf.hover, opts, { desc = "LSP Hover" })
					map("n", "gd", vim.lsp.buf.definition, opts, { desc = "Goto Definition" })
					map("n", "gD", vim.lsp.buf.declaration, opts, { desc = "Goto Declaration" })
					map("n", "gi", vim.lsp.buf.implementation, opts, { desc = "Goto Implementation" })
					map("n", "go", vim.lsp.buf.type_definition, opts, { desc = "Goto Type Definition" })
					map("n", "gr", vim.lsp.buf.references, opts, { desc = "References" })
					map("n", "gs", vim.lsp.buf.signature_help, opts, { desc = "Signature Help" })
					map("n", "crn", vim.lsp.buf.rename, opts, { desc = "Rename Symbol" })
					-- map({ "n", "x" }, "cfm", function()
					-- 	vim.lsp.buf.format({ async = true })
					-- end, opts, {desc = "Format Buffer"})
					map("n", "ca", vim.lsp.buf.code_action, opts, { desc = "Code Action" })
				end,
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "html", "css", "json", "javascript", "typescrtip" },
				callback = function(args)
					vim.lsp.enable("html")
					vim.lsp.enable("cssls")
					vim.lsp.enable("jsonls")
					vim.lsp.enable("tailwindcss")
					vim.lsp.config("tsgo", {
						cmd = { "tsgo", "--lsp", "--stdio" },
						filetypes = {
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
						},
						root_dir = function(fname)
							return vim.fs.root(fname, {
								"tsconfig.json",
								"jsconfig.json",
								"package.json",
								".git",
								"tsconfig.base.json",
							})
						end,
					})

					vim.lsp.enable("tsgo")

					-- TODO: add tsgo, gopls, rust-analyzer, zig, lua_lsp
					vim.lsp.config("eslint", {
						on_attach = function(client, bufnr)
							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = bufnr,
								command = "EslintFixAll",
							})
						end,
					})
					vim.lsp.enable("eslint")
				end,
			})
			-- vim.lsp.enable("html")
			-- vim.lsp.enable("cssls")
			-- vim.lsp.enable("jsonls")
			-- vim.lsp.enable("tailwindcss")
			-- vim.lsp.config("tsgo", {
			-- 	cmd = { "tsgo", "--lsp", "--stdio" },
			-- 	filetypes = {
			-- 		"javascript",
			-- 		"javascriptreact",
			-- 		"typescript",
			-- 		"typescriptreact",
			-- 	},
			-- 	root_dir = function(fname)
			-- 		return vim.fs.root(fname, {
			-- 			"tsconfig.json",
			-- 			"jsconfig.json",
			-- 			"package.json",
			-- 			".git",
			-- 			"tsconfig.base.json",
			-- 		})
			-- 	end,
			-- })
			--
			-- vim.lsp.enable("tsgo")
			--
			-- -- TODO: add tsgo, gopls, rust-analyzer, zig, lua_lsp
			-- vim.lsp.config("eslint", {
			-- 	on_attach = function(client, bufnr)
			-- 		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 			buffer = bufnr,
			-- 			command = "EslintFixAll",
			-- 		})
			-- 	end,
			-- })
			-- vim.lsp.enable("eslint")
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "tailwind-tools", "onsails/lspkind-nvim" },
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					-- Jump to the next snippet placeholder
					["<C-f>"] = cmp.mapping(function(fallback)
						local luasnip = require("luasnip")
						if luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					-- Jump to the previous snippet placeholder
					["<C-b>"] = cmp.mapping(function(fallback)
						local luasnip = require("luasnip")
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
						-- vim.snippet.expand(args.body)
					end,
				},
				preselect = "item",
				completion = {
					completopt = "menu, menuone, noinsert",
				},
				formatting = {
					format = function(entry, item)
						local ok1, lspkind = pcall(require, "lspkind")
						if ok1 then
							item = lspkind.cmp_format()(entry, item)
						end

						local ok2, tw = pcall(require, "tailwind-tools.cmp")
						if ok2 then
							item = tw.lspkind_format(entry, item)
						end

						return item
					end,
				},

				-- formatting = {
				-- 	format = require("lspkind").cmp_format({
				-- 		before = require("tailwind-tools.cmp").lspkind_format,
				-- 	}),
				-- },
			})
		end,
	},
	{
		"mason-org/mason.nvim",
		tag = "v1.11.0",
		pin = true,
		event = "VeryLazy",
		cmd = { "Mason", "MasonInstall" },
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		cmd = { "Mason", "MasonInstall" },
		tag = "v1.32.0",
		pin = true,
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({})
					end,
				},
			})
		end,
	},
}
