local M = {}
M.spec = {
	-- Clear highlights
	{ "<Esc>", "<cmd>nohlsearch<CR>", desc = "Clear highlights", mode = "n" },

	-- Centered scrolling
	{ "<C-d>", "<C-d>zz", desc = "Scroll down and center cursor", mode = "n" },
	{ "<C-u>", "<C-u>zz", desc = "Scroll up and center cursor", mode = "n" },

	-- Terminal
	{ "<Esc><Esc>", "<C-\\><C-n>", desc = "Exit terminal mode", mode = "t" },

	-- Smart search + centered (fixes duplicate mapping warning)
	-- { "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next Search Result", mode = "n" },
	-- { "n", "'Nn'[v:searchforward]", expr = true, desc = "Next Search Result", mode = "x" },
	-- { "n", "'Nn'[v:searchforward]", expr = true, desc = "Next Search Result", mode = "o" },
	-- { "N", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Prev Search Result", mode = "n" },
	-- { "N", "'Nn'[v:searchforward]", expr = true, desc = "Prev Search Result", mode = "x" },
	-- { "N", "'Nn'[v:searchforward]", expr = true, desc = "Prev Search Result", mode = "o" },
	{ "n", "nzzzv", desc = "Next search result centered", mode = "n" },
	{ "N", "Nzzzv", desc = "Previous search result centered", mode = "n" },

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

	-- Indenting
	{ "<", "<gv", desc = "Indent left", mode = "v" },
	{ ">", ">gv", desc = "Indent right", mode = "v" },

	-- Join lines & keep cursor
	{ "J", "mzJ`z", desc = "Join lines without moving cursor", mode = "n" },

	-- Lazy
	{ "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy", mode = "n" },

	-- Buffers
	{ "<S-h>", "<cmd>bprevious<cr>", desc = "Prev Buffer", mode = "n" },
	{ "<S-l>", "<cmd>bnext<cr>", desc = "Next Buffer", mode = "n" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer", mode = "n" },
	{ "<S-M-h>", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Left", mode = "n" },
	{ "<S-M-l>", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Right", mode = "n" },

	-- Windows
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
	{ "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New Tab" },
	{ "<leader><tab>]", "<cmd>tabnext<cr>", desc = "Next Tab" },
	{ "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close Tab" },
	{ "<leader><tab>p", "<cmd>tabprevious<cr>", desc = "Previous Tab" },

	-- Files / Find
	{ "<leader>f", group = "Find" },
	{
		"<leader>ff",
		function()
			require("mini.pick").builtin.files({ tool = "rg" })
		end,
		desc = "Find Files",
		mode = "n",
	},
	{
		"<leader>fg",
		function()
			require("mini.pick").builtin.grep_live({ tool = "rg" })
		end,
		desc = "Live Grep",
		mode = "n",
	},
	-- Explorer
	{
		"<leader>e",
		function()
			require("mini.files").open(vim.uv.cwd(), true)
		end,
		desc = "Explorer (mini.files)",
		mode = "n",
	},
	{
		"<leader>E",
		function()
			local bufname = vim.api.nvim_buf_get_name(0)
			if bufname == "" then
				require("mini.files").open(vim.uv.cwd(), true)
			else
				require("mini.files").open(bufname, true)
			end
		end,
		desc = "Explorer at current file",
		mode = "n",
	},

	-- Trouble
	{ "<leader>x", group = "Trouble" },
	{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace Diagnostics", mode = "n" },
	{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Document Diagnostics", mode = "n" },
	{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Quickfix List", mode = "n" },
	{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location List", mode = "n" },
	{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Todos", mode = "n" },

	-- Git
	{ "<leader>g", group = "Git" },
	{
		"<leader>gg",
		function()
			require("gitui").open()
		end,
		desc = "Open GitUI",
		mode = "n",
	},

	-- Yazi
	{ "<leader>y", "<cmd>Yazi<cr>", desc = "Open Yazi", mode = { "n", "v" } },
	{ "<leader>Y", "<cmd>Yazi cwd<cr>", desc = "Open Yazi at cwd", mode = "n" },
	{ "<leader->", "<cmd>Yazi toggle<cr>", desc = "Resume Yazi", mode = "n" },

	-- Flutter
	{ "<leader>F", group = "Flutter" },
	{ "<leader>Frn", "<Cmd>FlutterRun<CR>", desc = "Run project", mode = "n" },
	{ "<leader>Fd", "<Cmd>FlutterDebug<CR>", desc = "Debug project", mode = "n" },
	{ "<leader>Fl", "<Cmd>FlutterLogToggle<CR>", desc = "Toggle Dev Log", mode = "n" },
	{ "<leader>Frl", "<Cmd>FlutterReload<CR>", desc = "Hot Reload", mode = "n" },
	{ "<leader>Frr", "<Cmd>FlutterRestart<CR>", desc = "Hot Restart", mode = "n" },
	{ "<leader>Fq", "<Cmd>FlutterQuit<CR>", desc = "Quit app", mode = "n" },
	{ "<leader>Fo", "<Cmd>FlutterOutlineToggle<CR>", desc = "Toggle Outline", mode = "n" },
	{ "<leader>Fs", "<Cmd>FlutterDevices<CR>", desc = "Select Device", mode = "n" },
	{ "<leader>Fe", "<Cmd>FlutterEmulators<CR>", desc = "Select Emulator", mode = "n" },
	{ "<leader>Fv", "<Cmd>FlutterDevTools<CR>", desc = "Open DevTools", mode = "n" },

	-- OpenCode
	{ "<leader>a", group = "OpenCode" },
	{
		"<leader>aa",
		function()
			require("opencode").toggle()
		end,
		desc = "Toggle Terminal",
		mode = { "n", "x" },
	},
	{
		"<leader>as",
		function()
			require("opencode").ask("@this: ", { submit = true })
		end,
		desc = "Ask opencode",
		mode = { "n", "x" },
	},
	{
		"<leader>ax",
		function()
			require("opencode").select()
		end,
		desc = "Execute Action",
		mode = { "n", "x" },
	},
	{
		"<leader>ap",
		function()
			require("opencode").prompt("@this")
		end,
		desc = "Add to opencode",
		mode = { "n", "x" },
	},
	{
		"<leader>aU",
		function()
			require("opencode").command("session.half.page.up")
		end,
		desc = "Half Page Up",
		mode = "n",
	},
	{
		"<leader>aD",
		function()
			require("opencode").command("session.half.page.down")
		end,
		desc = "Half Page Down",
		mode = "n",
	},

	-- LSP
	{ "<leader>", group = "LSP" },
	{ "g", group = "LSP" },
	{ "K", vim.lsp.buf.hover, desc = "Hover", mode = "n" },
	{ "gd", vim.lsp.buf.definition, desc = "Goto Definition", mode = "n" },
	{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", mode = "n" },
	{ "gi", vim.lsp.buf.implementation, desc = "Goto Implementation", mode = "n" },
	{ "go", vim.lsp.buf.type_definition, desc = "Goto Type Definition", mode = "n" },
	{ "gr", vim.lsp.buf.references, desc = "Goto References", mode = "n" },
	{ "gs", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "n" },
	{ "<leader>crn", vim.lsp.buf.rename, desc = "Rename", mode = "n" },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = "n" },
	{ "<leader>ce", ":w<CR>:e<CR>", desc = "Save & Reload", mode = "n" },

	-- Devdocs
	{ "<leader>D", group = "DevDocs" },
	{
		"<leader>Do",
		mode = "n",
		"<cmd>DevDocs get<cr>",
		desc = "Get Devdocs",
	},
	{
		"<leader>Di",
		mode = "n",
		"<cmd>DevDocs install<cr>",
		desc = "Install Devdocs",
	},
	{
		"<leader>Dv",
		mode = "n",
		function()
			local devdocs = require("devdocs")
			local Snacks = require("snacks")
			local installedDocs = devdocs.GetInstalledDocs()
			vim.ui.select(installedDocs, {}, function(selected)
				if not selected then
					return
				end
				local docDir = devdocs.GetDocDir(selected)
				-- prettify the filename as you wish
				Snacks.picker.files({ cwd = docDir })
			end)
		end,
		desc = "Get Devdocs",
	},
	{
		"<leader>Dd",
		mode = "n",
		"<cmd>DevDocs delete<cr>",
		desc = "Delete Devdoc",
	},

	-- kulala
	{ "<leader>K", group = "Kulala", mode = "n" },
	{ "<leader>Ks", desc = "Send request", mode = "n" },
	{ "<leader>Ka", desc = "Send all requests", mode = "n" },
	{ "<leader>Kb", desc = "Open scratchpad", mode = "n" },

	-- live preview
	{ "<leader>M", group = "Live Preview" },
	{ "<leader>Ms", "<cmd>LivePreview start<cr>", group = "Live Preview" },
}
return M
