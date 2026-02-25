return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "ruff" }, -- ruff includes both formatting and linting
			javascript = { "biome", "eslint_d", "eslint" },
			javascriptreact = { "biome", "eslint_d", "eslint" },
			typescript = { "biome", "eslint_d", "eslint" },
			typescriptreact = { "biome", "eslint_d", "eslint" },
			-- lua = { "selene" },
			css = { "stylelint" },
			html = { "markuplint" },
			json = { "biome", "jsonlint" },
			yaml = { "yamllint" },
			markdown = { "vale" },
			go = { "golangci-lint" },
			bash = { "shellcheck" },
			groovy = { "npm-groovy-lint" },
			dockerfile = { "hadolint" },
			zig = { "zls" }, -- zls includes diagnostics
			env = { "dotenv-linter" },
			c = { "cpplint" },
			cpp = { "cpplint" },
			dart = { "dcm" },
			http = { "kulala-fmt" },
		}

		-- Custom linter configurations
		-- local custom_linters = {
		-- 	ruff = {
		-- 		cmd = "ruff",
		-- 		args = { "check", "--quiet", "--format=text", "--no-fix", "--stdin-filename", "$FILENAME" },
		-- 		stream = "stdout",
		-- 		stdin = true,
		-- 		parser = require("lint.parser").from_errorformat("%f:%l:%c: %m"),
		-- 	},
		-- 	eslint_d = {
		-- 		cmd = "eslint_d",
		-- 		args = { "--stdin", "--stdin-filename", "$FILENAME", "--format", "compact" },
		-- 		stdin = true,
		-- 		stream = "stdout",
		-- 		ignore_exitcode = true,
		-- 		parser = require("lint.parser").from_errorformat("%f: line %l, col %c, %m"),
		-- 	},
		-- }

		-- for name, config in pairs(custom_linters) do
		-- 	lint.linters[name] = config
		-- end

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
