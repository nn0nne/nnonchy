require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

require("mime-ext"):setup({
	-- Expand the existing filename database (lowercase), for example:
	-- with_files = {
	-- 	makefile = "text/makefile",
	-- 	-- ...
	-- },

	fallback_file1 = true,
})

require("mime-preview"):setup()

require("git"):setup()
