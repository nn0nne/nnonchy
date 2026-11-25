-- Docker Compose files need a yaml sub-filetype for the compose LSP to attach.
vim.filetype.add({
	pattern = {
		["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
		["compose.*%.ya?ml"] = "yaml.docker-compose",
	},
})

-- Shout out https://oneofone.dev/post/neovim-diagnostics-float/
-- Floating diagnostic
local group = vim.api.nvim_create_augroup("OoO", { clear = true })

local function au(typ, pattern, cmdOrFn)
	if type(cmdOrFn) == "function" then
		vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
	else
		vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
	end
end

au({ "CursorHold" }, nil, function(ev)
	-- Idle work (diagnostic float) should not fire in non-code/big buffers.
	if
		vim.bo[ev.buf].buftype ~= ""
		or vim.bo[ev.buf].filetype == "markdown"
		or require("nnonne.util.bigfile").is_big(ev.buf)
	then
		return
	end
	local opts = {
		focusable = false,
		scope = "cursor",
		close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
	}
	vim.diagnostic.open_float(nil, opts)
end)

--

local lsp_doc_highlight = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	desc = "Disable mini.indentscope for specific non-code filetypes",
	pattern = {
		"alpha", -- Disables it specifically on your Alpha Dashboard
		"mason",
		"help",
		"trouble",
		"opencode",
		"toggleterm",
		"snacks.terminal",
	},
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local client_id = tonumber(event.data.client_id)
		local client = client_id and vim.lsp.get_client_by_id(client_id)

		-- Check if the active LSP server supports text document highlighting.
		-- Skip big buffers: the extra round-trip on CursorHold(I) is costly there.
		if
			client
			and client:supports_method("textDocument/documentHighlight")
			and vim.bo[event.buf].filetype ~= "markdown"
			and not require("nnonne.util.bigfile").is_big(event.buf)
		then
			-- group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

			-- Highlight word references when holding the cursor still.
			-- Normal mode only: `CursorHoldI` would fire a server round-trip on every
			-- idle moment while typing.
			vim.api.nvim_create_autocmd("CursorHold", {
				buffer = event.buf,
				group = lsp_doc_highlight,
				callback = vim.lsp.buf.document_highlight,
			})

			-- Clear highlights immediately when the cursor moves
			vim.api.nvim_create_autocmd("CursorMoved", {
				buffer = event.buf,
				group = lsp_doc_highlight,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true, bg = "#333738" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, bg = "#333738" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, underline = true, bg = "#333738" })

-- Highlight when yanking (copying) text
vim.api.nvim_set_hl(0, "YankHighlight", {
	fg = "#e0def4", -- rose pine moon text
	bg = "#6e6a86", -- muted rose-gray
	bold = true,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({
			higroup = "YankHighlight",
			-- timeout = 200,
		})
	end,
})

-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     vim.defer_fn(function()
--       vim.cmd("silent !kitty @ set-spacing padding=0")
--     end, 100)
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("VimLeave", {
--   callback = function()
--     vim.cmd("silent !kitty @ set-spacing padding=default")
--   end,
-- })

-- Automatically change working directory to project root based on .git
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Keep the launch dir when no real file was opened.
		local name = vim.api.nvim_buf_get_name(0)
		if name == "" or vim.fn.isdirectory(name) == 1 or vim.bo.buftype ~= "" then
			return
		end

		local root_pattern = { ".git", "package.json", "Cargo.toml" }
		local found_root = vim.fs.root(0, root_pattern)
		if found_root then
			vim.cmd("cd " .. found_root)
		end
	end,
})

-- Highlight the current line on only the active buffer
local cursorline_group = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
	group = cursorline_group,
	pattern = "*",
	command = "setlocal cursorline",
})
vim.api.nvim_create_autocmd("WinLeave", {
	group = cursorline_group,
	pattern = "*",
	command = "setlocal nocursorline",
})

vim.lsp.config("*", {
	on_attach = function(client, bufnr)
		-- some clients support workspace diagnostics natively
		if client:supports_method("workspace/diagnostic", bufnr) then
			vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
		else
			require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
		end
	end,
})
