local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

	require("mini.files").setup({
		mappings = {
			close = "<Esc>",
		},
	})

	vim.keymap.set("n", "<leader>e", function()
		require("mini.files").open(vim.uv.cwd(), true)
	end, { desc = "Explorer (mini.files)" })

	vim.keymap.set("n", "<leader>E", function()
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname == "" then
			require("mini.files").open(vim.uv.cwd(), true)
		else
			require("mini.files").open(bufname, true)
		end
	end, { desc = "Explorer at current file" })

	local function get_diagnostic_status(path)
		local bufnr = vim.fn.bufnr(path)
		if bufnr == -1 then
			return nil
		end

		local diags = vim.diagnostic.get(bufnr)
		if #diags == 0 then
			return nil
		end

		local max_severity = vim.diagnostic.severity.HINT
		for _, d in ipairs(diags) do
			if d.severity < max_severity then
				max_severity = d.severity
			end
		end

		local signs = {
			[vim.diagnostic.severity.ERROR] = { text = " ", hl = "DiagnosticError" },
			[vim.diagnostic.severity.WARN] = { text = " ", hl = "DiagnosticWarn" },
			[vim.diagnostic.severity.INFO] = { text = " ", hl = "DiagnosticInfo" },
			[vim.diagnostic.severity.HINT] = { text = "󰌵 ", hl = "DiagnosticHint" },
		}

		return signs[max_severity]
	end

	local ns_id = vim.api.nvim_create_namespace("mini_files_diagnostics")
	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferUpdate",
		callback = function(args)
			local buf_id = args.data.buf_id
			vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)

			local n_lines = vim.api.nvim_buf_line_count(buf_id)
			for i = 1, n_lines do
				local entry = MiniFiles.get_fs_entry(buf_id, i)
				if entry then
					local status = get_diagnostic_status(entry.path)
					if status then
						vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, {
							virt_text = { { status.text, status.hl } },
							virt_text_pos = "inline",
							priority = 100,
						})
					end
				end
			end
		end,
	})
end

return M
