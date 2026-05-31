local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "vague.nvim", "gruvbox-material" })

	require("vague").setup({
		transparent = true,
	})

	local g = vim.g
	g.gruvbox_material_background = "hard"
	g.gruvbox_material_foreground = "mix"
	g.gruvbox_material_enable_bold = 1
	g.gruvbox_material_enable_italic = 1
	g.gruvbox_material_cursor = "auto"
	g.gruvbox_material_transparent_background = 0 -- 0,1,2
	g.gruvbox_material_dim_inactive_windows = 1
	g.gruvbox_material_visual = "red background"
	g.gruvbox_material_menu_selection_background = "red"
	g.gruvbox_material_spell_foreground = "colored"
	g.gruvbox_material_ui_contrast = "high"
	g.gruvbox_material_float_style = "bright"
	g.gruvbox_material_diagnostic_text_highlight = 1
	g.gruvbox_material_diagnostic_line_highlight = 1
	g.gruvbox_material_diagnostic_virtual_text = "highlighted"
	g.gruvbox_material_current_word = "high contrast background"
	g.gruvbox_material_inlay_hints_background = "dimmed"
	g.gruvbox_material_statusline_style = "mix"
	g.gruvbox_material_better_performance = 1

	vim.opt.background = "dark"
	vim.cmd.colorscheme("vague")

	local function toggle_theme()
		if vim.o.background == "dark" then
			vim.opt.background = "light"
			vim.cmd.colorscheme("gruvbox-material")
		else
			vim.opt.background = "dark"
			vim.cmd.colorscheme("vague")
		end
	end

	vim.api.nvim_create_user_command("TT", toggle_theme, {})
end

return M
