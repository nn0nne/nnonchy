return {
	"nvim-mini/mini.files",
	version = "*",
	config = function()
		local files = require("mini.files")
		files.setup({
			-- Customization of shown content
			content = {
				-- Predicate for which file system entries to show
				filter = function(fs_entry)
					-- Hide .git directory
					if fs_entry.name == ".git" then
						return false
					end

					-- Hide node_modules directory
					if fs_entry.name == "node_modules" then
						return false
					end

					return true
				end,
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
				close = "<Esc>",
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
				width_preview = 25,
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
}
