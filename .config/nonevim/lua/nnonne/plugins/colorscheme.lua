local M = {}

local pack = require("nnonne.commands.pack")

-- Core function to apply the theme based on the state file
function M.apply_system_theme()
	local g = vim.g
	local f = io.open(os.getenv("HOME") .. "/.config/theme_state", "r")

	if f then
		local mode = f:read("*l")
		f:close()

		if mode == "light" then
			vim.o.background = "light"
			vim.cmd.colorscheme("gruvbox-material")
		else
			vim.o.background = "dark"
			vim.cmd.colorscheme("vague")
		end
	else
		vim.o.background = "dark"
		vim.cmd.colorscheme("vague")
	end
end

function M.setup()
	pack.add({ "vague.nvim", "gruvbox-material" })

	require("vague").setup({
		transparent = true,
	})

	local g = vim.g
	g.gruvbox_material_background = "hard"
	g.gruvbox_material_foreground = "original"
	g.gruvbox_material_enable_bold = 1
	g.gruvbox_material_enable_italic = 1
	g.gruvbox_material_cursor = "auto"
	g.gruvbox_material_transparent_background = 2
	g.gruvbox_material_dim_inactive_windows = 1
	g.gruvbox_material_visual = "red background"
	g.gruvbox_material_menu_selection_background = "red"
	g.gruvbox_material_spell_foreground = "colored"
	g.gruvbox_material_ui_contrast = "high"
	g.gruvbox_material_float_style = "blend"
	g.gruvbox_material_diagnostic_text_highlight = 1
	g.gruvbox_material_diagnostic_line_highlight = 1
	g.gruvbox_material_diagnostic_virtual_text = "highlighted"
	g.gruvbox_material_current_word = "high contrast background"
	g.gruvbox_material_inlay_hints_background = "dimmed"
	g.gruvbox_material_statusline_style = "original"
	g.bruvbox_material_better_performance = 1

	-- 1. Run once on startup to set initial theme
	M.apply_system_theme()

	local signal = vim.uv.new_signal()
	if signal then
		vim.uv.signal_start(signal, "sigusr1", function()
			vim.schedule(function()
				M.apply_system_theme()
			end)
		end)
	end

	vim.api.nvim_create_user_command("TT", function()
		local mode = vim.o.background == "dark" and "light" or "dark"
		local f = io.open(os.getenv("HOME") .. "/.config/theme_state", "w")
		if f then
			f:write(mode .. "\n")
			f:close()
		end
		M.apply_system_theme()
	end, {})
end

return M
