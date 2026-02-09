return {
	"nvim-mini/mini.nvim",
	version = "*",
	dependencies = {
		{ "nvim-mini/mini.icons", version = "*" },
	},
	event = "InsertEnter",
	config = function()
		require("mini.pairs").setup()
		require("mini.surround").setup({
			-- Add custom surroundings to be used on top of builtin ones. For more
			-- information with examples, see `:h MiniSurround.config`.
			custom_surroundings = nil,

			-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
			highlight_duration = 500,

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "sa", -- Add surrounding in Normal and Visual modes
				delete = "sd", -- Delete surrounding
				find = "sf", -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},

			-- Number of lines within which surrounding is searched
			n_lines = 20,

			-- Whether to respect selection type:
			-- - Place surroundings on separate lines in linewise mode.
			-- - Place surroundings on each line in blockwise mode.
			respect_selection_type = false,

			-- How to search for surrounding (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
			-- see `:h MiniSurround.config`.
			search_method = "cover",

			-- Whether to disable showing non-error feedback
			-- This also affects (purely informational) helper messages shown after
			-- idle time if user input is required.
			silent = false,
		})
		local mini_pick = require("mini.pick")
		mini_pick.setup({
			-- Delays (in ms; should be at least 1)
			delay = {
				-- Delay between forcing asynchronous behavior
				async = 10,

				-- Delay between computation start and visual feedback about it
				busy = 50,
			},

			-- Keys for performing actions. See `:h MiniPick-actions`.
			mappings = {
				caret_left = "<Left>",
				caret_right = "<Right>",

				choose = "<CR>",
				choose_in_split = "<C-s>",
				choose_in_tabpage = "<C-t>",
				choose_in_vsplit = "<C-v>",
				choose_marked = "<M-CR>",

				delete_char = "<BS>",
				delete_char_right = "<Del>",
				delete_left = "<C-u>",
				delete_word = "<C-w>",

				mark = "<C-x>",
				mark_all = "<C-a>",

				move_down = "<C-n>",
				move_start = "<C-g>",
				move_up = "<C-p>",

				paste = "<C-r>",

				refine = "<C-Space>",
				refine_marked = "<M-Space>",

				scroll_down = "<C-f>",
				scroll_left = "<C-h>",
				scroll_right = "<C-l>",
				scroll_up = "<C-b>",

				stop = "<Esc>",

				toggle_info = "<S-Tab>",
				toggle_preview = "<Tab>",
			},

			-- General options
			options = {
				-- Whether to show content from bottom to top
				content_from_bottom = false,

				-- Whether to cache matches (more speed and memory on repeated prompts)
				use_cache = false,
			},

			-- Source definition. See `:h MiniPick-source`.
			source = {
				items = nil,
				name = nil,
				cwd = nil,

				match = nil,
				show = nil,
				preview = nil,

				choose = nil,
				choose_marked = nil,
			},

			-- Window related options
			window = {
				-- Float window config (table or callable returning it)
				config = nil,

				-- String to use as caret in prompt
				prompt_caret = "▏",

				-- String to use as prefix in prompt
				prompt_prefix = "> ",
			},
		})

		local files = require("mini.files")
		files.setup({
			-- Customization of shown content
			content = {
				-- Predicate for which file system entries to show
				filter = nil,
				-- Highlight group to use for a file system entry
				highlight = nil,
				-- Prefix text and highlight to show to the left of file system entry
				prefix = nil,
				-- Order in which to show file system entries
				sort = nil,
			},

			-- Module mappings created only inside explorer.
			-- Use `''` (empty string) to not create one.
			mappings = {
				close = "q",
				go_in = "l",
				go_in_plus = "L",
				go_out = "h",
				go_out_plus = "H",
				mark_goto = "'",
				mark_set = "m",
				reset = "<BS>",
				reveal_cwd = "@",
				show_help = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},

			-- General options
			options = {
				-- Whether to delete permanently or move into module-specific trash
				permanent_delete = true,
				-- Whether to use for editing directories
				use_as_default_explorer = false,
			},

			-- Customization of explorer windows
			windows = {
				-- Maximum number of windows to show side by side
				max_number = math.huge,
				-- Whether to show preview of file/directory under cursor
				preview = true,
				-- Width of focused window
				width_focus = 50,
				-- Width of non-focused window
				width_nofocus = 15,
				-- Width of preview window
				width_preview = 100,
			},
		})
		local function open_mini_files()
			local path = vim.uv.cwd()
			files.open(path, true)
		end

		vim.keymap.set("n", "<leader>e", open_mini_files, { desc = "Explorer (mini.files)" })
		vim.keymap.set("n", "<leader>E", function()
			local bufname = vim.api.nvim_buf_get_name(0)
			if bufname == "" then
				files.open(vim.uv.cwd(), true)
			else
				files.open(bufname, true)
			end
		end, { desc = "Explorer at current file" })
	end,
	keys = {
		{
			"<leader>ff",
			function()
				require("mini.pick").builtin.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fg",
			function()
				require("mini.pick").builtin.grep_live()
			end,
			desc = "Live Grep",
		},
		-- {
		-- 	"<leader>fr",
		-- 	function()
		-- 		require("mini.pick").builtin.resume()
		-- 	end,
		-- 	desc = "Resume Picker",
		-- },
	},
}
