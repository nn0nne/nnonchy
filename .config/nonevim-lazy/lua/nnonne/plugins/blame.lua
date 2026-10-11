return {
  "roschaefer/blame.nvim",
  cmd = "Blame",
  keys = {
    {
      "<leader>gb",
      function()
        if vim.t.blame_view then
          vim.t.blame_view:close()
          vim.t.blame_view = nil
        else
          vim.cmd("Blame")
        end
      end,
      desc = "Toggle Git Blame",
    },
  },
  opts = {
    on_attach = function(view)
      vim.t.blame_view = view

      view.keymap.set("n", "yc", function()
        local commit = view:commit()
        if commit then
          vim.fn.setreg("+", commit.hash)
          vim.notify("Copied commit " .. commit.hash:sub(1, 8))
        end
      end, { desc = "Yank commit hash" })
    end,
  },
}

-- return {
--   "f-person/git-blame.nvim",
--   event = "VeryLazy",
--   config = function()
--     require("gitblame").setup({
--       -- Off by default: it shells out to `git blame` on every CursorHold across
--       -- every buffer. Toggle on demand with <leader>gb (:GitBlameToggle).
--       enabled = false,
--       message_template = " <summary> • <date> • <author>",
--       date_format = "%d%m%y%H%M",
--       max_commit_summary_length = 50,
--       message_when_not_committed = "  Not Committed Yet",
--       display_virtual_text = 1,
--       ignored_filetypes = { "help", "gitcommit", "gitrebase", "qf", "fugitive", },
--       gitblame_delay = 250,
--       use_blame_commit_file_urls = true,
--       schedule_event = "CursorHold",
--       clear_event = "CursorHoldI",
--       virtual_text_column = 80
--     })
--   end,
--   keys = {
--     { "<leader>gb", "<cmd>GitBlameToggle<cr>",        desc = "Toggle Git Blame" },
--     { "<leader>go", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open Blame Commit", },
--     { "<leader>gy", "<cmd>GitBlameCopySHA<cr>",       desc = "Copy Blame SHA", },
--     { "<leader>gY", "<cmd>GitBlameCopyCommitURL<cr>", desc = "Copy Blame Commit URL", },
--     { "<leader>gf", "<cmd>GitBlameOpenFileURL<cr>",   desc = "Open Blame File", },
--     { "<leader>gF", "<cmd>GitBlameCopyFileURL<cr>",   desc = "Copy Blame File URL", },
--   }
-- }
