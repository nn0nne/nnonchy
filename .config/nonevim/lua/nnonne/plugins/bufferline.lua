return {
	"akinsho/bufferline.nvim",
	event = "bufAdd",
	version = "*",
	config = function()
		require("bufferline").setup({
			options = {
				indicator = {
					icon = "| ",
					style = "underline",
				},
				diagnostics = "nvim_lsp",
				-- rest of config ...

				--- count is an integer representing total count of errors
				--- level is a string "error" | "warning"
				--- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
				--- this should return a string
				--- Don't get too fancy as this function will be executed a lot
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
			},
		})
	end,
	opts = function()
		local Offset = require("bufferline.offset")
		if not Offset.edgy then
			local get = Offset.get
			Offset.get = function()
				if package.loaded.edgy then
					local old_offset = get()
					local layout = require("edgy.config").layout
					local ret = { left = "", left_size = 0, right = "", right_size = 0 }
					for _, pos in ipairs({ "left", "right" }) do
						local sb = layout[pos]
						local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
						if sb and #sb.wins > 0 then
							ret[pos] = old_offset[pos .. "_size"] > 0 and old_offset[pos]
								or pos == "left" and ("%#Bold#" .. title .. "%*" .. "%#BufferLineOffsetSeparator#│%*")
								or pos == "right"
									and ("%#BufferLineOffsetSeparator#│%*" .. "%#Bold#" .. title .. "%*")
							ret[pos .. "_size"] = old_offset[pos .. "_size"] > 0 and old_offset[pos .. "_size"]
								or sb.bounds.width
						end
					end
					ret.total_size = ret.left_size + ret.right_size
					if ret.total_size > 0 then
						return ret
					end
				end
				return get()
			end
			Offset.edgy = true
		end
	end,
}
