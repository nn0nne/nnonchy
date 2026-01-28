return {
  "aspeddro/gitui.nvim",
  keys = {
    {
      "<leader>gg", -- or any key combo you prefer
      function()
        require("gitui").open()
      end,
      desc = "Open GitUI",
    },
  },
  opts = {
    command = { enable = true }, -- optional: enables :Gitui command
    binary = "gitui",
    args = {},
    window = {
      options = {
        width = 90,
        height = 80,
        border = "rounded",
      },
    },
  },
}
