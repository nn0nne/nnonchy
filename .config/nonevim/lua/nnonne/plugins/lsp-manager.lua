-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/lsp-manager.lua
local M = {}

local function find_file(pattern)
	return vim.fs.find(pattern, {
		upward = true,
		stop = vim.uv.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})[1]
end

local function has_dependency(pkg_name)
	local pkg_json_path = find_file("package.json")
	if not pkg_json_path then
		return false
	end

	local file = io.open(pkg_json_path, "r")
	if not file then
		return false
	end

	local content = file:read("*a")
	file:close()

	local ok, json = pcall(vim.json.decode, content)
	if not ok or not json then
		return false
	end

	local deps = json.dependencies or {}
	local dev_deps = json.devDependencies or {}

	return deps[pkg_name] ~= nil or dev_deps[pkg_name] ~= nil
end

local function is_installed(bin)
	return vim.fn.executable(bin) == 1
end

M.tools = {
	{ kind = "lsp", lsp = "bashls", mason = "bash-language-server" },
	{ kind = "lsp", lsp = "cssls", mason = "css-lsp" },
	{ kind = "lsp", lsp = "gradle_ls", mason = "gradle-language-server" },
	{ kind = "lsp", lsp = "groovyls", mason = "groovy-language-server" },
	{ kind = "lsp", lsp = "html", mason = "html-lsp" },
	{ kind = "lsp", lsp = "lua_ls", mason = "lua-language-server" },
	{ kind = "lsp", lsp = "tailwindcss", mason = "tailwindcss-language-server" },
	{ kind = "lsp", lsp = "vtsls", mason = "vtsls" },
	{ kind = "lsp", lsp = "pyright", mason = "pyright" },
	{ kind = "lsp", lsp = "astro", mason = "astro-language-server" },
	{ kind = "lsp", lsp = "jsonls", mason = "json-lsp" },
	{ kind = "lsp", lsp = "taplo", mason = "taplo" },
	{ kind = "lsp", lsp = "eslint", mason = "eslint-lsp" },
	{ kind = "formatter", mason = "stylua", ft = { "lua" } },
	{ kind = "formatter", mason = "shfmt", ft = { "sh", "bash" } },
	{ kind = "formatter", mason = "dart_format", ft = { "dart" } },
	{ kind = "formatter", mason = "ruff", ft = { "python" } },
	{ kind = "formatter", mason = "taplo", ft = { "toml" } },
	{ kind = "linter", mason = "stylelint", ft = { "css" } },
	{ kind = "linter", mason = "shellcheck", ft = { "sh", "bash" } },
	{ kind = "linter", mason = "htmllint", ft = { "html" } },
	{ kind = "linter", mason = "ruff", ft = { "python" } },
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

	local web_fts = { "javascript", "typescript", "html", "css", "json", "jsonc", "astro" }
	for _, ft in ipairs(web_fts) do
		by_ft[ft] = function()
			if find_file("biome.json") and is_installed("biome") then
				return { "biome" }
			end

			if has_dependency("prettier") or has_dependency("prettierd") then
				if has_dependency("prettierd") and is_installed("prettierd") then
					return { "prettierd" }
				elseif is_installed("prettier") then
					return { "prettier" }
				end
			end
			return {}
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

	local web_fts = { "javascript", "typescript", "astro" }
	for _, ft in ipairs(web_fts) do
		by_ft[ft] = function()
			if find_file("biome.json") and is_installed("biome") then
				return { "biome" }
			end

			local has_eslint_config = find_file({
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				"eslint.config.mts",
				"eslint.config.cts",
				".eslintrc",
				".eslintrc.json",
				".eslintrc.js",
				".eslintrc.yml",
				".eslintrc.yaml",
			})

			if has_eslint_config then
				if has_dependency("eslint_d") and is_installed("eslint_d") then
					return { "eslint_d" }
				elseif is_installed("eslint") then
					return { "eslint" }
				end
			end
			return {}
		end
	end

	return by_ft
end

return M
