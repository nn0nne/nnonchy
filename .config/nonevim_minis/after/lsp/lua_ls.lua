-- Source - https://stackoverflow.com/a/79656109
-- Posted by Jo Totland
-- Retrieved 2026-02-25, License - CC BY-SA 4.0

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
