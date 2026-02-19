return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "ruff", "pylint" }, -- ruff includes both formatting and linting
			javascript = { "eslint" },
			javascriptreact = { "eslint" },
			typescript = { "eslint" },
			typescriptreact = { "eslint" },
			go = { "golangci-lint" },
			-- lua = { "selene" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			dockerfile = { "hadolint" },
			sql = { "sqlfluff", "squawk" },
			markdown = { "markdownlint-cli2" },
			html = { "markuplint" },
			css = { "stylelint" },
			json = { "jsonlint" },
			yaml = { "yamllint" },
			env = { "dotenv-linter" },
			zig = { "zls" }, -- zls includes diagnostics
		}

		-- Custom linter configurations
		local custom_linters = {
			ruff = {
				cmd = "ruff",
				args = { "check", "--quiet", "--format=text", "--no-fix", "--stdin-filename", "$FILENAME" },
				stream = "stdout",
				stdin = true,
				parser = require("lint.parser").from_errorformat("%f:%l:%c: %m"),
			},
			eslint_d = {
				cmd = "eslint_d",
				args = { "--stdin", "--stdin-filename", "$FILENAME", "--format", "compact" },
				stdin = true,
				stream = "stdout",
				ignore_exitcode = true,
				parser = require("lint.parser").from_errorformat("%f: line %l, col %c, %m"),
			},
		}

		for name, config in pairs(custom_linters) do
			lint.linters[name] = config
		end

		-- Create autocommand to lint on save
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})

		-- Optional: Lint on file open
		vim.api.nvim_create_autocmd({ "BufRead", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
