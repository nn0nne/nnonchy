local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
	pack.add({ "git-blame.nvim" })

	require("gitblame").setup({
		enabled = true,
		-- Minimal template: Message • Time Ago • Author (omits the cluttered SHA)
		message_template = " <summary> • <date> • <author>",

		-- Use relative dates (e.g., "3 weeks ago") instead of full timestamps
		date_format = "%r",

		-- Truncate long commit messages after 50 characters to keep things neat
		max_commit_summary_length = 50,

		-- Message to display on uncommitted/local changes
		message_when_not_committed = "  Not Committed Yet",
	})
end

return M
