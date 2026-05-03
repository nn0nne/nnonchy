local M = {}

function M.apply()
	local color1_bg = "#d8647e"
	local color2_bg = "#7fa563"
	local color3_bg = "#b4d4cf"
	local color4_bg = "#e0a363"
	local color5_bg = "#7e98e8"
	local color6_bg = "#c3c3d5"
	local color_fg = "#141415"

	-- -- Heading colors (when not hovered over), extends through the entire line
	-- vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
	-- vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
	-- vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
	-- vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
	-- vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
	-- vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))
	--
	-- -- Highlight for the heading and sign icons (symbol on the left)
	-- -- I have the sign disabled for now, so this makes no effect
	-- vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
	-- vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
	-- vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
	-- vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
	-- vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
	-- vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))

	local highlights = {
		Headline1Bg = { fg = color_fg, bg = color1_bg },
		Headline2Bg = { fg = color_fg, bg = color2_bg },
		Headline3Bg = { fg = color_fg, bg = color3_bg },
		Headline4Bg = { fg = color_fg, bg = color4_bg },
		Headline5Bg = { fg = color_fg, bg = color5_bg },
		Headline6Bg = { fg = color_fg, bg = color6_bg },
		Headline1Fg = { fg = color1_bg, bold = true },
		Headline2Fg = { fg = color2_bg, bold = true },
		Headline3Fg = { fg = color3_bg, bold = true },
		Headline4Fg = { fg = color4_bg, bold = true },
		Headline5Fg = { fg = color5_bg, bold = true },
		Headline6Fg = { fg = color6_bg, bold = true },
	}

	for name, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, name, opts)
	end
end

return M
