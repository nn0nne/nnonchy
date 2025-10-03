-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- setup plugins first
require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" }, -- your vendored LazyVim plugins
		{ import = "plugins" }, -- your own plugins
	},
	defaults = {
		lazy = false,
		version = false,
	},
	checker = { enabled = true },
})

-- then run LazyVim config
require("lazyvim.config").init()
require("lazyvim.config").setup({})
