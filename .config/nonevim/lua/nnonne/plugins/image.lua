local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "image.nvim" })

	local backend = "kitty"
	local term = os.getenv("TERM") or ""
	local term_program = os.getenv("TERM_PROGRAM") or ""

	if term_program:lower() == "kitty" or term:lower():match("kitty") then
		backend = "kitty"
	elseif term:lower():match("foot") then
		backend = "sixel"
	end

	require("image").setup({
		backend = backend,
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = true,
				only_render_image_at_cursor_mode = "popup", -- or "inline"
				floating_windows = false, -- if true, images will be rendered in floating markdown windows
				filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
			},
			asciidoc = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				only_render_image_at_cursor_mode = "popup",
				floating_windows = false,
				filetypes = { "asciidoc", "adoc" },
			},
			neorg = {
				enabled = true,
				filetypes = { "norg" },
			},
			rst = {
				enabled = true,
			},
			typst = {
				enabled = true,
				filetypes = { "typst" },
			},
			html = {
				enabled = true,
				only_render_image_at_cursor = true,
				only_render_image_at_cursor_mode = "popup", -- or "inline"
				filetypes = { "html", "xhtml", "htm", "markdown" },
			},
			css = {
				enabled = false,
			},
		},
	})
end

return M
