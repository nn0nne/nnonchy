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

au({ "CursorHold" }, nil, function()
	local opts = {
		focusable = false,
		scope = "cursor",
		close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
	}
	vim.diagnostic.open_float(nil, opts)
end)

--

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlights text when yanking",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = { "*.md" },
	callback = function()
		vim.opt.colorcolumn = "80"
		vim.opt.textwidth = 80
		vim.opt.linebreak = true
		vim.opt.wrap = true
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*.md" },
	callback = function()
		vim.opt.colorcolumn = "120"
		vim.opt.textwidth = 120
		vim.opt.linebreak = false
		vim.opt.wrap = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Disable mini.indentscope for specific non-code filetypes",
	pattern = {
		"alpha", -- Disables it specifically on your Alpha Dashboard
		"mason",
		"help",
		"trouble",
		"opencode",
	},
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local client_id = tonumber(event.data.client_id)
		local client = client_id and vim.lsp.get_client_by_id(client_id)

		-- Check if the active LSP server supports text document highlighting
		if client and client:supports_method("textDocument/documentHighlight") then
			local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

			-- Highlight word references when holding the cursor still
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = group,
				callback = vim.lsp.buf.document_highlight,
			})

			-- Clear highlights immediately when the cursor moves
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = group,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
-- LspReferenceText controls matches in ordinary prose code
vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true, bg = "#333738" })
-- LspReferenceRead and LspReferenceWrite control variable reading/assignments
vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, bg = "#333738" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bold = true, underline = true, bg = "#333738" })
