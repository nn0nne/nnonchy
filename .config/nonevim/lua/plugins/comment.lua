return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- 1. Setup the context plugin first
    require("ts_context_commentstring").setup({
      enable_autocmd = false,
    })

    -- 2. Setup Comment.nvim and link them via pre_hook
    require("Comment").setup({
      -- This MUST be pre_hook, not post_hook
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

      padding = true,
      sticky = true,
      ignore = nil,
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
    })
  end,
}
