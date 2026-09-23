return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  config = function()
    require("gitblame").setup({
      enabled = true,
      message_template = " <summary> • <date> • <author>",
      date_format = "%d%m%H%M",
      max_commit_summary_length = 50,
      message_when_not_committed = "  Not Committed Yet",
      display_virtual_text = 0
    })
  end,
  -- keys = {
  --   {
  --     "<leader>gb",
  --     function()
  --       require("gitblame").toggle()
  --     end,
  --     desc = "Toggle Git Blame"
  --   },
  -- }
}
