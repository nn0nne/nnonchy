vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlights text when yanking",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- For Vale (advanced writing/grammar tool)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.md",
	callback = function()
		vim.cmd([[compiler vale]])
	end,
})

-- For selene (Lua linter) - alternative setup
vim.api.nvim_create_user_command("Selene", function()
	vim.cmd("!selene %")
end, {})

-- For shellcheck - quickfix integration
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sh", "bash" },
	callback = function()
		vim.bo.makeprg = "shellcheck -f gcc %"
		vim.bo.errorformat = "%f:%l:%c: %m"
	end,
})
