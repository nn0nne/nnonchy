require("git"):setup({})

require("confirm-quit"):setup()

require("recycle-bin"):setup({
	-- Optional: Override automatic trash directory discovery
	trash_dir = "~/.local/share/Trash/", -- Uncomment to use specific directory
})

require("starship"):setup({
	-- Hide flags (such as filter, find and search). This can be beneficial for starship themes
	-- which are intended to go across the entire width of the terminal.
	hide_flags = true,
	-- Whether to place flags after the starship prompt. False means the flags will be placed before the prompt.
	flags_after_prompt = true,
	-- Custom starship configuration file to use
	config_file = "~/.config/starship.toml", -- Default: nil
	-- Whether to enable support for starship's right prompt (i.e. `starship prompt --right`).
	show_right_prompt = false,
	-- Whether to hide the count widget, in case you want only your right prompt to show up. Only has
	-- an effect when `show_right_prompt = true`
	hide_count = false,
	-- Separator to place between the right prompt and the count widget. Use `count_separator = ""`
	-- to have no space between the widgets.
	count_separator = " ",
})

require("full-border"):setup({
	type = ui.Border.ROUNDED,
})

require("mime-ext.local"):setup({
	-- Expand the existing filename database (lowercase), for example:
	with_files = {
		makefile = "text/makefile",
		-- ...
	},

	-- Expand the existing extension database (lowercase), for example:
	with_exts = {
		mk = "text/makefile",
		-- ...
	},

	-- If the MIME type is not in both filename and extension databases,
	-- then fallback to Yazi's preset `mime.local` plugin, which uses `file(1)`
	fallback_file1 = false,
})

require("spot"):setup({
	metadata_section = {
		enable = true,
		hash_cmd = "xxhsum", -- other hashing commands may be slower
		hash_filesize_limit = 150, -- in MB, set 0 to disable
		relative_time = true, -- 2026-01-01 or n days ago
		time_format = "%Y-%m-%d %H:%M", -- https://www.man7.org/linux/man-pages/man3/strftime.3.html
		show_compression = "size", ---@type false|"size"|"percentage"
	},
	plugins_section = {
		enable = true,
	},
	style = {
		section = "green",
		key = "reset",
		value = "blue",
		selected = "green",
		colorize_metadata = true,
		height = 20,
		width = 60,
		key_length = 15,
	},
})
