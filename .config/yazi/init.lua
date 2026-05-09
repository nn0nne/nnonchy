require("git"):setup({
	order = 1500,
})

require("confirm-quit"):setup()

require("recycle-bin"):setup({
	trash_dir = "~/.local/share/Trash/",
})

require("gvfs"):setup({
	input_position = { "center", y = 0, w = 60 },
})

require("starship"):setup({
	hide_flags = true,
	flags_after_prompt = true,
	config_file = "~/.config/starship.toml", -- Default: nil
	show_right_prompt = false,
	hide_count = false,
	count_separator = " ",
})

require("full-border"):setup({
	type = ui.Border.PLAIN,
})

require("spot"):setup({
	metadata_section = {
		enable = true,
		hash_cmd = "xxhsum",
		hash_filesize_limit = 150,
		relative_time = true,
		time_format = "%Y-%m-%d %H:%M",
		show_compression = "size",
	},
	plugins_section = {
		enable = true,
	},
	style = {
		section = "green",
		key = "reset",
		value = "blue",
		selected = "blue",
		colorize_metadata = true,
		height = 20,
		width = 60,
		key_length = 15,
	},
})

Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	})
end, 500, Status.RIGHT)
