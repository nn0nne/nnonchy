local M = {}

local lazy = require("nnonne.utils.lazy")
local pack = require("nnonne.commands.pack")

function M.setup()
  vim.keymap.set("n", "<leader>gb", function()
    lazy.load_once("git-blame", pack.pluglist({ "git-blame.nvim" }), function()
      require("gitblame").setup({
        enabled = true,
        message_template = " <summary> • <date> • <author>",
        date_format = "%r",
        max_commit_summary_length = 50,
        message_when_not_committed = "  Not Committed Yet",
      })
    end)
    require("gitblame").toggle()
  end, { desc = "Toggle Git Blame" })
end

return M
