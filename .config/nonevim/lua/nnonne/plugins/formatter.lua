return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "black" }, -- Use ruff_format instead of isort
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "markdownlint-cli2" },
				go = { "gofumpt", "goimports" },
				sh = { "beautysh", "shfmt" },
				bash = { "beautysh", "shfmt" },
				sql = { "sqlfluff", "pgformatter" },
				prisma = { "prisma", lsp_format = "fallback" },
				groovy = { "npm-groovy-lint" },
				toml = { "taplo" },
				zig = { "zig", lsp_format = "fallback" }, -- zls can format
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
