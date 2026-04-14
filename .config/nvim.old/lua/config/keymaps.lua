-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Join lines & keep cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })

-- Search navigation centered
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Visual indent keep selection
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and keep selection", noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and keep selection", noremap = true, silent = true })

-- Paste over selection without yanking
vim.keymap.set("v", "p", '"_dp', { desc = "Paste over selection without yanking", noremap = true, silent = true })
