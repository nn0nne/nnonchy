-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/lsp.lua
local M = {}

local pack = require("nnonne.commands.pack")
local mason_utils = require("nnonne.commands.mason")
local lsp_tools = require("nnonne.plugins.lsp-manager")

function M.setup()
	pack.add({ "mason.nvim", "conform.nvim", "nvim-lint", "nvim-lspconfig", "mason-lspconfig.nvim" })

	require("mason").setup({})
	require("mason-lspconfig").setup({})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	pcall(function()
		capabilities = require("blink.cmp").get_lsp_capabilities()
	end)
	vim.lsp.config("*", { capabilities = capabilities })

	vim.lsp.config("tailwindcss", {
		settings = {
			tailwindCSS = {
				experimental = {
					classRegex = {
						"Css = (\\{[^\\{\\}]+\\}|\\[[^\\[\\]]+\\]|'[^']+'|\"[^\"]+\")",
					},
				},
			},
		},
		filetypes = {
			"html",
			"css",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		},
	})

	vim.lsp.config("html", { filetypes = { "html" } })

	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					preloadFileSize = 1000,
					maxPreload = 2000,
					checkThirdParty = false,
					ignoreDir = { ".git", "node_modules" },
					-- library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = { enable = false },
				hint = { enable = true },
			},
			single_file_support = true,
		},
		root_markers = {
			".luarc.json",
			".luarc.jsonc",
			".git",
			"init.lua",
			"init.sls",
		},
	})

	vim.lsp.enable(lsp_tools.lsp_names())

	require("conform").setup({
		format_on_save = {
			timout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = lsp_tools.formatters_by_ft(),
	})

	require("lint").linters_by_ft = lsp_tools.linters_by_ft()

	mason_utils.setup_install_defaults_command(lsp_tools.tools)
end

return M
