return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		local conform = require("conform")
		local ft_formatters =
			{
				python = { "ruff" },
				javascript = { "biome", "prettier_d", "prettier" },
				javascriptreact = { "biome", "prettier_d", "prettier" },
				typescript = { "biome", "prettier_d", "prettier" },
				typescriptreact = { "biome", "prettier_d", "prettier" },
				lua = { "stylua" },
				css = { "prettier_d", "prettier" },
				html = { "prettier_d", "prettier" },
				json = { "biome", "prettier_d", "prettier" },
				jsonc = { "biome", "prettier_d", "prettier" },
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
			}, conform.setup({
				-- formatters = {
				-- 	prettier = {
				-- 		prepend_args = {
				-- 			"--prose-wrap",
				-- 			"always",
				-- 			"--print-width",
				-- 			"100",
				-- 			"--single-quote",
				-- 			"false",
				-- 			"--trailing-comma",
				-- 			"es5",
				-- 		},
				-- 	},
				-- 	shfmt = {
				-- 		prepend_args = { "-i", "2" }, -- 2 spaces indentation
				-- 	},
				-- 	beautysh = {
				-- 		prepend_args = { "--indent-size", "2" },
				-- 	},
				-- 	black = {
				-- 		prepend_args = { "--line-length", "100" },
				-- 	},
				-- 	sqlfluff = {
				-- 		prepend_args = { "fix", "-f" }, -- Auto-fix mode
				-- 	},
				-- },
			})
		-- Filter out unavailable formatters
		local function available_formatters(ft)
			local list = ft_formatters[ft] or {}
			local result = {}
			for _, f in ipairs(list) do
				if type(f) == "string" and vim.fn.executable(f) == 1 then
					table.insert(result, f)
				elseif type(f) == "table" then
					-- For table formatters like { "prisma", lsp_format = "fallback" }
					if f[1] and vim.fn.executable(f[1]) == 1 then
						table.insert(result, f)
					end
				end
			end
			return result
		end

		conform.setup({
			formatters_by_ft = setmetatable({}, {
				__index = function(_, ft)
					return available_formatters(ft)
				end,
			}),
		})

		-- Auto-format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				local ft = vim.bo[args.buf].filetype
				local formatters = available_formatters(ft)
				if #formatters > 0 then
					conform.format({ bufnr = args.buf, formatters = formatters })
				end
			end,
		})
	end,
}
