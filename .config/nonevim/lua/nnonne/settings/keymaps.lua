-- Clear highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

-- Terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Smart search + centered (fixes duplicate mapping warning)
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Better Up/Down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Window Resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
vim.keymap.set("v", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Join lines & keep cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Buffers
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-M-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-M-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bd", function()
	local current_buf = vim.api.nvim_get_current_buf()
	local valid_buffers = vim.fn.getbufinfo({ buflisted = 1 })

	if #valid_buffers <= 1 then
		local scratch = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_set_current_buf(scratch)
		pcall(vim.api.nvim_buf_delete, current_buf, { force = true })
	else
		vim.cmd("bnext")
		pcall(vim.api.nvim_buf_delete, current_buf, { force = true })
	end
end, { desc = "Close Buffer" })

-- Windows
vim.keymap.set("n", "<leader>wh", "<C-W>s", { remap = true, desc = "Split Window Below" })
vim.keymap.set("n", "<leader>wv", "<C-W>v", { remap = true, desc = "Split Window Right" })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { remap = true, desc = "Delete Window" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize split sizes" })
vim.keymap.set("n", "<leader>wz", "<C-w>_<C-w>|", { desc = "Toggle Window Zoom" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
