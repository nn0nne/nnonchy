return {
	"nvim-mini/mini.surround",
	version = "*",
	keys = {
		{ "<Space>sa", desc = "Add surrounding" },
		{ "<Space>sd", desc = "Delete surrounding" },
		{ "<Space>sf", desc = "Find surrounding" },
		{ "<Space>sF", desc = "Find surrounding left" },
		{ "<Space>sh", desc = "Highlight surrounding" },
		{ "<Space>sr", desc = "Replace surrounding" },
		{ "<Space>sl", desc = "Suffix last" },
		{ "<Space>sn", desc = "Suffix next" },
	},
	config = function()
		require("mini.surround").setup({
			custom_surroundings = nil,
			highlight_duration = 500,
			mappings = {
				add = "<Space>sa",
				delete = "<Space>sd",
				find = "<Space>sf",
				find_left = "<Space>sF",
				highlight = "<Space>sh",
				replace = "<Space>sr",
				suffix_last = "<Space>sl",
				suffix_next = "<Space>sn",
			},
			n_lines = 20,
			respect_selection_type = false,
			search_method = "cover",
			silent = false,
		})
	end,
}
