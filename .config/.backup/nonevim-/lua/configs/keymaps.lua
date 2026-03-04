-- lua/configs/keymaps.lua

local M = {}

-- Local state for the toggle function
local isLspDiagnosticsVisible = true

M.spec = {
	-- Basic Keymaps
	{ "<Esc>", "<cmd>nohlsearch<CR>", desc = "Clear highlights", mode = "n" },

  -- Centered scrolling
  {"<C-d>", "<C-d>zz", desc = "Scroll down and center cursor", mode= "n" },
  {"<C-u>", "<C-u>zz", desc = "Scroll up and center cursor", mode= "n" },

	-- Diagnostics
	{ "<leader>q", vim.diagnostic.setloclist, desc = "Open diagnostic [Q]uickfix list", mode = "n" },

  -- Move to window using the <ctrl> hjkl keys
  {"<C-h>", "<C-w>h", desc = "Go to Left Window", mode = "n", remap = true },
  {"<C-j>", "<C-w>j", desc = "Go to Lower Window", mode = "n", remap = true },
  {"<C-k>", "<C-w>k", desc = "Go to Upper Window", mode = "n", remap = true },
  {"<C-l>", "<C-w>l", desc = "Go to Right Window", mode = "n", remap = true },

	-- Terminal
	{ "<Esc><Esc>", "<C-\\><C-n>", desc = "Exit terminal mode", mode = "t" },

	-- Window Navigation
	{ "<C-h>", "<C-w>h", desc = "Go to Left Window", mode = "n", remap = true },
	{ "<C-j>", "<C-w>j", desc = "Go to Lower Window", mode = "n", remap = true },
	{ "<C-k>", "<C-w>k", desc = "Go to Upper Window", mode = "n", remap = true },
	{ "<C-l>", "<C-w>l", desc = "Go to Right Window", mode = "n", remap = true },

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  {"n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next Search Result", mode = "n"},
  {"n", "'Nn'[v:searchforward]", expr = true, desc = "Next Search Result", mode = "x"},
  {"n", "'Nn'[v:searchforward]", expr = true, desc = "Next Search Result", mode = "o"},
  {"N", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Prev Search Result", mode = "n"},
  {"N", "'Nn'[v:searchforward]", expr = true, desc = "Prev Search Result", mode = "x"},
  {"N", "'Nn'[v:searchforward]", expr = true, desc = "Prev Search Result", mode = "o"},

	-- Better Up/Down
	{ "j", "v:count == 0 ? 'gj' : 'j'", desc = "Down", mode = { "n", "x" }, expr = true, silent = true },
	{ "<Down>", "v:count == 0 ? 'gj' : 'j'", desc = "Down", mode = { "n", "x" }, expr = true, silent = true },
	{ "k", "v:count == 0 ? 'gk' : 'k'", desc = "Up", mode = { "n", "x" }, expr = true, silent = true },
	{ "<Up>", "v:count == 0 ? 'gk' : 'k'", desc = "Up", mode = { "n", "x" }, expr = true, silent = true },

	-- Window Resizing
	{ "<C-Up>", "<cmd>resize +2<cr>", desc = "Increase Window Height", mode = "n" },
	{ "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease Window Height", mode = "n" },
	{ "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Decrease Window Width", mode = "n" },
	{ "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase Window Width", mode = "n" },

	-- Move Lines
	{ "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", desc = "Move Down", mode = "v" },
	{ "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", desc = "Move Up", mode = "v" },

	-- Search Navigation (Centered)
	{ "n", "nzzzv", desc = "Next search result centered", mode = "n" },
	{ "N", "Nzzzv", desc = "Previous search result centered", mode = "n" },

	-- Indenting
	{ "<", "<gv", desc = "Indent left", mode = "v" },
	{ ">", ">gv", desc = "Indent right", mode = "v" },

	-- Leader Mappings
	{ "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy", mode = "n" },

	-- Buffers
	{ "<S-h>", "<cmd>bprevious<cr>", desc = "Prev Buffer", mode = "n" },
	{ "<S-l>", "<cmd>bnext<cr>", desc = "Next Buffer", mode = "n" },
	{ "<leader>b", group = "Buffers" },
	-- { "<leader>bb", "<cmd>e #<cr>", desc = "Switch to Other Buffer", mode = "n" },
  { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer", mode = "n" },
  { "<S-M-h>", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Left", mode = "n" },
{ "<S-M-l>", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Right", mode = "n" },

	-- Splits
	{ "<leader>wh", "<C-W>s", desc = "Split Window Below", mode = "n", remap = true },
	{ "<leader>wv", "<C-W>v", desc = "Split Window Right", mode = "n", remap = true },
	{ "<leader>w", group = "Windows" },
	{ "<leader>wd", "<C-W>c", desc = "Delete Window", mode = "n", remap = true },
	{ "<leader>we", "<C-w>=", desc = "Equalize split sizes", mode = "n" },

	-- Tabs
	{ "<leader><tab>", group = "Tabs" },
	{ "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last Tab" },
	{ "<leader><tab>o", "<cmd>tabonly<cr>", desc = "Close Other Tabs" },
	{ "<leader><tab>f", "<cmd>tabfirst<cr>", desc = "First Tab" },
	{ "<leader><tab><tab>", "<cmd>tabnew<cr>", desc = "New Tab" },
	{ "<leader><tab>]", "<cmd>tabnext<cr>", desc = "Next Tab" },
	{ "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close Tab" },
	{ "<leader><tab>[", "<cmd>tabprevious<cr>", desc = "Previous Tab" },

	-- LSP Logic
	{
		"<leader>lx",
		function()
			isLspDiagnosticsVisible = not isLspDiagnosticsVisible
			vim.diagnostic.config({
				virtual_text = isLspDiagnosticsVisible,
				underline = isLspDiagnosticsVisible,
			})
		end,
		desc = "Toggle LSP diagnostics",
		mode = "n",
	},
	{
		"<leader>ft",
		function()
			local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
			local target_dir = (vim.v.shell_error == 0 and git_root ~= "") and git_root or vim.fn.getcwd()
			vim.cmd("terminal")
			vim.cmd("startinsert")
			vim.fn.chansend(vim.b.terminal_job_id, "cd " .. vim.fn.shellescape(target_dir) .. "\n")
		end,
		desc = "Terminal (project root)",
		mode = "n",
	},
	{
		"<leader>fT",
		":terminal<CR>",
		desc = "Terminal (current buffer)",
	},
}

return M
--
-- -- -- better indenting
-- -- map("x", "<", "<gv")
-- -- map("x", ">", ">gv")
--
-- -- Visual indent keep selection
-- map("v", "<", "<gv", { desc = "Indent left and keep selection", noremap = true, silent = true })
-- map("v", ">", ">gv", { desc = "Indent right and keep selection", noremap = true, silent = true })
--
-- map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
--
-- -- buffers
-- map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
-- map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
-- map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
--
-- -- join lines and keep cursor
-- map("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })
--
-- -- Split management
-- map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
-- map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
-- map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
-- map("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
-- -- map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
--
-- -- tabs
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
--
-- -- Toggle LSP diagnostics
-- local isLspDiagnosticsVisible = true
-- map("n", "<leader>lx", function()
-- 	isLspDiagnosticsVisible = not isLspDiagnosticsVisible
-- 	vim.diagnostic.config({
-- 		virtual_text = isLspDiagnosticsVisible,
-- 		underline = isLspDiagnosticsVisible,
-- 	})
-- end, { desc = "Toggle LSP diagnostics visibility" })
--
-- -- vim: ts=2 sts=2 sw=2 et
