-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/lsp-manager.lua
local M = {}

M.tools = {
	{ kind = "lsp", lsp = "bashls", mason = "bash-language-server" },
	{ kind = "lsp", lsp = "cssls", mason = "css-lsp" },
	{ kind = "lsp", lsp = "gradle_ls", mason = "gradle-language-server" },
	{ kind = "lsp", lsp = "groovyls", mason = "groovy-language-server" },
	{ kind = "lsp", lsp = "html", mason = "html-lsp" },
	{ kind = "lsp", lsp = "lua_ls", mason = "lua-language-server" },
	{ kind = "lsp", lsp = "tailwindcss", mason = "tailwindcss-language-server" },
	{ kind = "lsp", lsp = "vtsls", mason = "vtsls" },
	{ kind = "formatter", mason = "stylua", ft = { "lua" } },
	{ kind = "formatter", mason = "shfmt", ft = { "sh", "bash" } },
	{ kind = "formatter", mason = "prettierd", ft = { "javascript", "typescript", "html", "css", "json", "jsonc" } },
	{ kind = "formatter", mason = "biome", ft = { "javascript", "typescript", "html", "css", "json", "jsonc" } },
	{ kind = "formatter", mason = "dart_format", ft = { "dart" } },
	{ kind = "linter", mason = "eslint_d", ft = { "javascript", "typescript" } },
	{ kind = "linter", mason = "biome", ft = { "javascript", "typescript" } },
	{ kind = "linter", mason = "stylelint", ft = { "css" } },
	{ kind = "linter", mason = "shellcheck", ft = { "sh", "bash" } },
	{ kind = "linter", mason = "htmllint", ft = { "html" } },
}

function M.lsp_names()
	local names = {}
	for _, tool in ipairs(M.tools) do
		if tool.kind == "lsp" then
			table.insert(names, tool.lsp)
		end
	end
	return names
end

function M.formatters_by_ft()
	local by_ft = {}
	for _, tool in ipairs(M.tools) do
		if tool.kind == "formatter" and tool.ft then
			local formatter = tool.conform or tool.mason
			for _, ft in ipairs(tool.ft) do
				by_ft[ft] = by_ft[ft] or {}
				table.insert(by_ft[ft], formatter)
			end
		end
	end
	return by_ft
end

function M.linters_by_ft()
	local by_ft = {}
	for _, tool in ipairs(M.tools) do
		if tool.kind == "linter" and tool.ft then
			local linter = tool.lint or tool.mason
			for _, ft in ipairs(tool.ft) do
				by_ft[ft] = by_ft[ft] or {}
				table.insert(by_ft[ft], linter)
			end
		end
	end
	return by_ft
end

return M
