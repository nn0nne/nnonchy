local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "mini.nvim" })

	require("mini.files").setup({
		mappings = {
			close = "<Esc>",
		},
		-- windows = {
		-- 	preview = true,
		-- },
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

	-- 1. Fetch LSP diagnostics from the WHOLE codebase and bubble them up to parent directories
	local function get_workspace_diagnostics()
		local diag_cache = {}

		local severity_map = {
			[vim.diagnostic.severity.ERROR] = { priority = 4, text = " ", hl = "DiagnosticError" },
			[vim.diagnostic.severity.WARN] = { priority = 3, text = " ", hl = "DiagnosticWarn" },
			[vim.diagnostic.severity.INFO] = { priority = 2, text = " ", hl = "DiagnosticInfo" },
			[vim.diagnostic.severity.HINT] = { priority = 1, text = "󰌵 ", hl = "DiagnosticHint" },
		}

		-- Get diagnostics directly from active LSP clients (handles unopened files)
		for _, client in ipairs(vim.lsp.get_clients()) do
			local diags = vim.diagnostic.get(nil, { lsp_client_id = client.id })

			for _, d in ipairs(diags) do
				local path = ""
				if d.bufnr and vim.api.nvim_buf_is_valid(d.bufnr) then
					path = vim.api.nvim_buf_get_name(d.bufnr)
				elseif d.filename then -- Directly handles strings for unopened files from LSPs
					path = d.filename
				end

				if path ~= "" then
					path = path:gsub("\\", "/"):gsub("//", "/")
					local item = severity_map[d.severity]

					if item then
						-- 1a. Apply to the exact file path
						if not diag_cache[path] or item.priority > diag_cache[path].priority then
							diag_cache[path] = item
						end

						-- 1b. BUBBLE UP: Propagate diagnostics up to parent folders for unopened files too
						local dir = vim.fn.fnamemodify(path, ":h")
						while dir and dir ~= "." and dir ~= "/" and #dir > 3 do
							dir = dir:gsub("\\", "/"):gsub("//", "/")
							if not diag_cache[dir] or item.priority > diag_cache[dir].priority then
								diag_cache[dir] = item
							end
							local next_dir = vim.fn.fnamemodify(dir, ":h")
							if next_dir == dir then
								break
							end
							dir = next_dir
						end
					end
				end
			end
		end

		-- Fallback to standard open buffers if no running LSPs are emitting workspace metadata
		if next(diag_cache) == nil then
			for _, d in ipairs(vim.diagnostic.get()) do
				if vim.api.nvim_buf_is_valid(d.bufnr) then
					local path = vim.api.nvim_buf_get_name(d.bufnr):gsub("\\", "/"):gsub("//", "/")
					local item = severity_map[d.severity]
					if path ~= "" and item then
						if not diag_cache[path] or item.priority > diag_cache[path].priority then
							diag_cache[path] = item
						end

						-- Bubble up standard buffers
						local dir = vim.fn.fnamemodify(path, ":h")
						while dir and dir ~= "." and dir ~= "/" and #dir > 3 do
							dir = dir:gsub("\\", "/"):gsub("//", "/")
							if not diag_cache[dir] or item.priority > diag_cache[dir].priority then
								diag_cache[dir] = item
							end
							local next_dir = vim.fn.fnamemodify(dir, ":h")
							if next_dir == dir then
								break
							end
							dir = next_dir
						end
					end
				end
			end
		end

		return diag_cache
	end

	-- 2. Git Status Parser supporting Directory Up-Propagation
	local function get_git_status()
		local git_status = {}

		local git_root_handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
		if not git_root_handle then
			return git_status
		end
		local git_root = git_root_handle:read("*l")
		git_root_handle:close()
		if not git_root or git_root == "" then
			return git_status
		end

		local handle = io.popen("git -C " .. vim.fn.shellescape(git_root) .. " status --porcelain 2>/dev/null")
		if not handle then
			return git_status
		end

		for line in handle:lines() do
			local status = line:sub(1, 2)
			local path = line:sub(3):match("^%s*(.-)%s*$")

			if status:find("R") then
				path = path:match("->%s*(.*)$")
			end

			if path then
				path = path:gsub('^"', ""):gsub('"$', "")
				local abs_path = (git_root .. "/" .. path):gsub("\\", "/"):gsub("//", "/")

				local decoration = { text = " ", hl = "GitSignsChange" }
				if status:find("A") or status:find("%?") then
					decoration = { text = " ", hl = "GitSignsAdd" }
				end

				git_status[abs_path] = decoration

				-- Bubble up git indicators to parent folders
				local dir = vim.fn.fnamemodify(abs_path, ":h")
				while dir and dir ~= git_root and #dir > #git_root do
					dir = dir:gsub("\\", "/"):gsub("//", "/")
					if not git_status[dir] then
						git_status[dir] = { text = " ", hl = "GitSignsChange" }
					end
					local next_dir = vim.fn.fnamemodify(dir, ":h")
					if next_dir == dir then
						break
					end
					dir = next_dir
				end
				if not git_status[git_root] then
					git_status[git_root] = { text = " ", hl = "GitSignsChange" }
				end
			end
		end
		handle:close()
		return git_status
	end

	local ns_id = vim.api.nvim_create_namespace("mini_files_decorations")

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferUpdate",
		callback = function(args)
			local buf_id = args.data.buf_id
			if not vim.api.nvim_buf_is_valid(buf_id) then
				return
			end

			vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)

			local git_cache = get_git_status()
			local diag_cache = get_workspace_diagnostics()
			local n_lines = vim.api.nvim_buf_line_count(buf_id)

			for i = 1, n_lines do
				local entry = MiniFiles.get_fs_entry(buf_id, i)
				if entry then
					local entry_path = entry.path:gsub("\\", "/"):gsub("//", "/")
					local virt_text = {}

					-- 1. Diagnostics (Works globally for files and bubbled parent directories)
					local diag_status = diag_cache[entry_path]
					if diag_status then
						table.insert(virt_text, { diag_status.text, diag_status.hl })
					end

					-- 2. Git Status (Works globally for files and bubbled parent directories)
					local git_status = git_cache[entry_path]
					if git_status then
						table.insert(virt_text, { git_status.text, git_status.hl })
					end

					if #virt_text > 0 then
						vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, {
							virt_text = virt_text,
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
