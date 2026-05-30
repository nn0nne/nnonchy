-- Shout out https://oneofone.dev/post/neovim-diagnostics-float/
-- Floating diagnostic
local group = vim.api.nvim_create_augroup("OoO", { clear = true })

local function au(typ, pattern, cmdOrFn)
	if type(cmdOrFn) == "function" then
		vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
	else
		vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
	end
end

au({ "CursorHold" }, nil, function()
	local opts = {
		focusable = false,
		scope = "cursor",
		close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
	}
	vim.diagnostic.open_float(nil, opts)
end)

--

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlights text when yanking",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = { "*.md" },
	callback = function()
		vim.opt.colorcolumn = "80"
		vim.opt.textwidth = 80
		vim.opt.linebreak = true
		vim.opt.wrap = true
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*.md" },
	callback = function()
		vim.opt.colorcolumn = "120"
		vim.opt.textwidth = 120
		vim.opt.linebreak = false
		vim.opt.wrap = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Disable mini.indentscope for specific non-code filetypes",
	pattern = {
		"alpha", -- Disables it specifically on your Alpha Dashboard
		"dashboard",
		"snacks_dashboard",
		"lazy",
		"mason",
		"help",
		"NvimTree",
		"neo-tree",
		"trouble",
	},
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})
