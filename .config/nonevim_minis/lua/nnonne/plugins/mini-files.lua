return {
	"nvim-mini/mini.files",
	version = "*",
	keys = {
		{ "<leader>e", desc = "Explorer (mini.files)" },
		{ "<leader>E", desc = "Explorer at current file" },
	},
	config = function()
		local files = require("mini.files")
		local diagnostic_cache = {}

		local function update_diagnostic_cache(bufnr)
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end
			local path = vim.api.nvim_buf_get_name(bufnr)
			if path == "" then
				return
			end

			local errors, warns = 0, 0
			for _, d in ipairs(vim.diagnostic.get(bufnr)) do
				if d.severity == vim.diagnostic.severity.ERROR then
					errors = errors + 1
				elseif d.severity == vim.diagnostic.severity.WARN then
					warns = warns + 1
				end
			end

			diagnostic_cache[path] = { errors = errors, warns = warns }
		end

		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			callback = function(args)
				update_diagnostic_cache(args.buf)
			end,
		})

		files.setup({
			content = {
				filter = function(fs_entry)
					return fs_entry.name ~= ".git" and fs_entry.name ~= "node_modules"
				end,
				prefix = function(fs_entry)
					local data = diagnostic_cache[fs_entry.path]
					if not data then
						return "  "
					end
					if data.errors > 0 or data.warns > 0 then
						local text = ""
						if data.errors > 0 then
							text = text .. " " .. data.errors
						end
						if data.warns > 0 then
							text = text .. "  " .. data.warns
						end
						return text .. " "
					end
					return "  "
				end,
			},
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
			options = {
				permanent_delete = true,
				use_as_default_explorer = false,
			},
			windows = {
				max_number = math.huge,
				preview = true,
				width_focus = 50,
				width_nofocus = 15,
				width_preview = 25,
			},
		})

		local function open_mini_files()
			files.open(vim.uv.cwd(), true)
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
