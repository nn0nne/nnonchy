return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				python = { "ruff" },
				javascript = { "biome", "prettier_d", "prettier" },
				javascriptreact = { "biome", "prettier_d", "prettier" },
				typescript = { "biome", "prettier_d", "prettier" },
				typescriptreact = { "biome", "prettier_d", "prettier" },
				lua = { "stylua" },
				css = { "prettier_d", "prettier" },
				html = { "prettier_d", "prettier" },
				json = { "biome", "prettier_d", "prettier" },
				yaml = { "prettier_d", "prettier" },
				markdown = { "mdformat", "prettier_d", "prettier" },
				go = { "gofumpt", "goimports" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				prisma = { "prisma", lsp_format = "fallback" },
				groovy = { "npm-groovy-lint" },
				toml = { "taplo" },
				zig = { "zig", lsp_format = "fallback" }, -- zls can format
				env = {},
				c = { "clang-format" },
				cpp = { "clang-format" },
				dart = { "dcm" },
				http = { "kulala-fmt" },
			},
			formatters = {
				prettier = {
					prepend_args = {
						"--prose-wrap",
						"always",
						"--print-width",
						"100",
						"--single-quote",
						"false",
						"--trailing-comma",
						"es5",
					},
				},
				shfmt = {
					prepend_args = { "-i", "2" }, -- 2 spaces indentation
				},
				beautysh = {
					prepend_args = { "--indent-size", "2" },
				},
				black = {
					prepend_args = { "--line-length", "100" },
				},
				sqlfluff = {
					prepend_args = { "fix", "-f" }, -- Auto-fix mode
				},
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
