return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local uv = vim.loop

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

		-- helper to check if a command exists
		local function command_exists(cmd)
			local handle = uv.spawn(cmd, { args = { "--version" }, stdio = nil }, function(code, _)
				handle:close()
			end)
			return handle ~= nil
		end

		-- safe lint function: only use linters that exist
		local function safe_lint()
			local ft = vim.bo.filetype
			local linters = lint.linters_by_ft[ft] or {}
			local available_linters = {}

			for _, l in ipairs(linters) do
				if lint.linters[l] and vim.fn.executable(l) == 1 then
					table.insert(available_linters, l)
				end
			end

			if #available_linters > 0 then
				lint.try_lint(available_linters)
			end
		end

		-- Create autocommand to lint on save
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = safe_lint,
		})

		-- Optional: Lint on file open
		vim.api.nvim_create_autocmd({ "BufRead", "InsertLeave" }, {
			callback = safe_lint,
		})
	end,
}
