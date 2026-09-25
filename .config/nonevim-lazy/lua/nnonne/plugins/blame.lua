return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  config = function()
    require("gitblame").setup({
      enabled = true,
      message_template = " <summary> • <date> • <author>",
      date_format = "%d%m%y%H%M",
      max_commit_summary_length = 50,
      message_when_not_committed = "  Not Committed Yet",
      display_virtual_text = 1,
      ignored_filetypes = { "help", "gitcommit", "gitrebase", "qf", "fugitive", },
      gitblame_delay = 250,
      use_blame_commit_file_urls = true,
      schedule_event = "CursorHold",
      clear_event = "CursorHoldI",
      virtual_text_column = 80
    })
  end,
  keys = {
    { "<leader>gb", "<cmd>GitBlameToggle<cr>",        desc = "Toggle Git Blame" },
    { "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open Blame Commit", },
    { "<leader>gy", "<cmd>GitBlameCopySHA<cr>",       desc = "Copy Blame SHA", },
    { "<leader>gY", "<cmd>GitBlameCopyCommitURL<cr>", desc = "Copy Blame Commit URL", },
    { "<leader>gf", "<cmd>GitBlameOpenFileURL<cr>",   desc = "Open Blame File", },
    { "<leader>gF", "<cmd>GitBlameCopyFileURL<cr>",   desc = "Copy Blame File URL", },
  }
}
