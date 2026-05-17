-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/registry.lua

local M = {}

M.map = {
	["vague.nvim"] = { name = "vague", src = "https://github.com/vague-theme/vague.nvim" },
	["nvim-treesitter"] = {
		name = "nvim-treesitter",
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	["nvim-treesitter-textobjects"] = {
		name = "nvim-treesitter-textobjects",
		src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		version = "main",
	},
	["nvim-lspconfig"] = { name = "nvim-lspconfig", src = "https://github.com/neovim/nvim-lspconfig" },
	["blink.cmp"] = {
		name = "blink-cmp",
		src = "https://github.com/Saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	["conform.nvim"] = { name = "conform", src = "https://github.com/stevearc/conform.nvim" },
	["nvim-lint"] = { name = "nvim-lint", src = "https://github.com/mfussenegger/nvim-lint" },
	["mason.nvim"] = { name = "mason", src = "https://github.com/mason-org/mason.nvim" },
	["mason-lspconfig.nvim"] = { name = "mason-lspconfig", src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	["ts-comments.nvim"] = { name = "ts-comments", src = "https://github.com/folke/ts-comments.nvim" },
	["vim-kitty-navigator"] = { name = "vim-kitty-navigator", src = "https://github.com/knubie/vim-kitty-navigator" },
	["mini.nvim"] = { name = "mini.nvim", src = "https://github.com/nvim-mini/mini.nvim" },
	["lazydev.nvim"] = { name = "lazydev.nvim", src = "https://github.com/folke/lazydev.nvim" },
	-- ["gitui.nvim"] = { name = "gitui.nvim", src = "https://github.com/aspeddro/gitui.nvim" },
	["cord.nvim"] = { name = "cord.nvim", src = "https://github.com/vyfor/cord.nvim" },
	["which-key.nvim"] = { name = "which-key", src = "https://github.com/folke/which-key.nvim" },
	["friendly-snippets"] = { name = "friendly-snippets", src = "https://github.com/rafamadriz/friendly-snippets" },
	["trouble.nvim"] = { name = "trouble.nvim", src = "https://github.com/folke/trouble.nvim" },
	["bullets.vim"] = { name = "bullets.vim", src = "https://github.com/bullets-vim/bullets.vim" },
	["nvim-ts-autotag"] = { name = "nvim-ts-autotag", src = "https://github.com/windwp/nvim-ts-autotag" },
	["grug-far.nvim"] = { name = "grug-far.nvim", src = "https://github.com/MagicDuck/grug-far.nvim" },
	["flutter-tools.nvim"] = { name = "flutter-tools.nvim", src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	["dressing.nvim"] = { name = "dressing.nvim", src = "https://github.com/stevearc/dressing.nvim" },
	["plenary.nvim"] = { name = "plenary.nvim", src = "https://github.com/nvim-lua/plenary.nvim" },
	["render-markdown.nvim"] = {
		name = "render-markdown.nvim",
		src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
	},
	["snacks.nvim"] = { name = "snacks.nvim", src = "https://github.com/folke/snacks.nvim" },
	["image.nvim"] = { name = "image.nvim", src = "https://github.com/3rd/image.nvim" },
	["toggleterm.nvim"] = {
		name = "toggleterm.nvim",
		src = "https://github.com/akinsho/toggleterm.nvim",
	},
	["opencode.nvim"] = { name = "opencode.nvim", src = "https://github.com/nickjvandyke/opencode.nvim" },
	["yazi.nvim"] = { name = "yazi.nvim", src = "https://github.com/mikavilpas/yazi.nvim" },
	["fff"] = { name = "fff", src = "https://github.com/dmtrKovalenko/fff" },
	["git-blame.nvim"] = { name = "git-blame.nvim", src = "https://github.com/f-person/git-blame.nvim" },
}

function M.by_names(names)
	local out = {}
	for _, name in ipairs(names) do
		local entry = M.map[name]
		if not entry then
			error("Unknown plugin registry entry: " .. tostring(name))
		end
		table.insert(out, entry)
	end
	return out
end

function M.names()
	local keys = {}
	for name, _ in pairs(M.map) do
		table.insert(keys, name)
	end
	table.sort(keys)
	return keys
end

function M.all()
	return M.by_names(M.names())
end

return M
