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
	{
		"<leader>bd",
		function()
			Snacks.bufdelete()
		end,
		desc = "Delete Buffer",
		mode = "n",
	},
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

	-- Trouble
	{ "<leader>d", group = "Trouble" },
	{ "<leader>dw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Workspace Diagnostics", mode = "n" },
	{ "<leader>dd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Document Diagnostics", mode = "n" },
	{ "<leader>dq", "<cmd>Trouble quickfix toggle<CR>", desc = "Quickfix List", mode = "n" },
	{ "<leader>dl", "<cmd>Trouble loclist toggle<CR>", desc = "Location List", mode = "n" },
	{ "<leader>dt", "<cmd>Trouble todo toggle<CR>", desc = "Todos", mode = "n" },

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
	{ "<leader>Y", "<cmd>Yazi<cr>", desc = "Open Yazi", mode = { "n", "v" } },
	-- { "<leader>Y", "<cmd>Yazi cwd<cr>", desc = "Open Yazi at cwd", mode = "n" },
	-- { "<leader->", "<cmd>Yazi toggle<cr>", desc = "Resume Yazi", mode = "n" },

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
	{ "<leader>Fp", group = "Pubspec" },
	{
		"<leader>Fpg",
		"<Cmd>FlutterPubGet<CR>",
		desc = "Flutter Pub Get",
		mode = "n",
	},
	{
		"<leader>Fpu",
		"<Cmd>FlutterPubUpgrade<CR>",
		desc = "Flutter Pub Upgrade",
		mode = "n",
	},
	{
		"<leader>Fpc",
		"<Cmd>lua require('snacks').terminal.open('flutter clean')<CR>",
		desc = "Flutter Clean",
		mode = "n",
	},
	{
		"<leader>Fpa",
		"<Cmd>FlutterDepsAdd<CR>",
		desc = "Add Pub Package",
		mode = "n",
	},
	{
		"<leader>Fpid",
		"<Cmd>PubspecAssistAddDevPackage<CR>",
		desc = "Add Pub Dev Package (inline)",
		mode = "n",
	},
	{
		"<leader>Fpia",
		"<Cmd>PubspecAssistAddPackage<CR>",
		desc = "Add Pub Package (inline)",
		mode = "n",
	},
	{
		"<leader>Fpip",
		"<Cmd>PubspecAssistPickVersion<CR>",
		desc = "Pick Pub Package version (inline)",
		mode = "n",
	},

	-- LSP
	{ "K", vim.lsp.buf.hover, desc = "Hover", mode = "n" },
	-- { "g", group = "LSP" },
	-- { "gd", vim.lsp.buf.definition, desc = "Goto Definition", mode = "n" },
	-- { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", mode = "n" },
	-- { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation", mode = "n" },
	-- { "go", vim.lsp.buf.type_definition, desc = "Goto Type Definition", mode = "n" },
	-- { "gr", vim.lsp.buf.references, desc = "Goto References", mode = "n" },
	-- { "gs", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "n" },
	{
		"gd",
		function()
			Snacks.picker.lsp_definitions()
		end,
		desc = "Goto Definition",
	},
	{
		"gD",
		function()
			Snacks.picker.lsp_declarations()
		end,
		desc = "Goto Declaration",
	},
	{
		"gr",
		function()
			Snacks.picker.lsp_references()
		end,
		nowait = true,
		desc = "References",
	},
	{
		"gI",
		function()
			Snacks.picker.lsp_implementations()
		end,
		desc = "Goto Implementation",
	},
	{
		"gy",
		function()
			Snacks.picker.lsp_type_definitions()
		end,
		desc = "Goto T[y]pe Definition",
	},
	{
		"gai",
		function()
			Snacks.picker.lsp_incoming_calls()
		end,
		desc = "C[a]lls Incoming",
	},
	{
		"gao",
		function()
			Snacks.picker.lsp_outgoing_calls()
		end,
		desc = "C[a]lls Outgoing",
	},
	{ "<leader>c", group = "Code Stuff" },
	{
		"<leader>crn",
		function()
			Snacks.rename.rename_file()
		end,
		desc = "Rename",
		mode = "n",
	},
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

	-- Opencode
	{ "<leader>O", group = "Opencode" },
	{
		"<leader>Ot",
		function()
			require("opencode").toggle()
		end,
		desc = "Toggle Opencode Terminal",
		mode = { "n", "x" },
	},
	{
		"<leader>Oa",
		function()
			require("opencode").ask("@this: ", { submit = true })
		end,
		desc = "Ask opencode",
		mode = { "n", "x" },
	},
	{
		"<leader>Ox",
		function()
			require("opencode").select()
		end,
		desc = "Execute opencode action…",
		mode = { "n", "x" },
	},
	{
		"<leader>Op",
		function()
			require("opencode").prompt("@this")
		end,
		desc = "Add to opencode",
		mode = { "n", "x" },
	},

	-- Terminal
	{ "<leader>t", group = "Terminal" },
	{
		"<leader>tt",
		function()
			Snacks.terminal.toggle()
		end,
		desc = "Toggle Terminal",
	},

	-- Picker
	{
		"<leader>e",
		function()
			Snacks.explorer()
		end,
		desc = "File Explorer",
	},
	{ "<leader>f", group = "Finder" },
	{
		"<leader>fgg",
		function()
			Snacks.picker.grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>fgw",
		function()
			Snacks.picker.grep_word()
		end,
		desc = "Visual selection or word",
		mode = { "n", "x" },
	},
	{
		"<leader>fD",
		function()
			Snacks.picker.diagnostics()
		end,
		desc = "Diagnostics",
	},
	{
		"<leader>fd",
		function()
			Snacks.picker.diagnostics_buffer()
		end,
		desc = "Buffer Diagnostics",
	},
	-- find
	{
		"<leader>fb",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>fc",
		function()
			Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		end,
		desc = "Find Config File",
	},
	{
		"<leader>ff",
		function()
			Snacks.picker.files({ cmd = "rg", hidden = true })
		end,
		desc = "Find Files",
	},

	{
		"<leader>0",
		function()
			Snacks.dashboard.open()
		end,
		desc = "Open dashboard",
	},
}
return M
