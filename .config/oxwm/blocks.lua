---@module 'oxwm'

local colors = require("vague")

return {
	oxwm.bar.block.ram({
		format = "Ram: {used}/{total} GB",
		interval = 5,
		color = colors.light_blue,
		underline = true,
	}),
	oxwm.bar.block.static({
		text = "│",
		interval = 999999999,
		color = colors.lavender,
		underline = false,
	}),
	oxwm.bar.block.datetime({
		format = "{}",
		date_format = "%a, %b %d - %-I:%M %P",
		interval = 60,
		color = colors.cyan,
		underline = true,
	}),
	-- Uncomment to add battery status (useful for laptops)
	oxwm.bar.block.battery({
		format = "Bat: {}%",
		charging = "⚡ Bat: {}%",
		discharging = "- Bat: {}%",
		full = "✓ Bat: {}%",
		interval = 30,
		color = colors.green,
		underline = true,
	}),
}
