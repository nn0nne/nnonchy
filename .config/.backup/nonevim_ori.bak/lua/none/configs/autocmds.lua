-- Always hard wrap at 80 characters in every file
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		vim.opt_local.textwidth = 80
		vim.opt_local.formatoptions:append("t") -- wrap text
		vim.opt_local.smartindent = false
	end,
})

-- Hightlight yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
