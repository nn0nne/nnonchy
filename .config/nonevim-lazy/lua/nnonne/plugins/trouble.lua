return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xd",
      function()
        require("trouble").toggle({
          mode = "diagnostics",
          filter = {
            {
              severity = {
                vim.diagnostic.severity.ERROR,
                vim.diagnostic.severity.WARN,
              },
              buf = 0,
            },
          },
        })
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>xx",
      function()
        require("trouble").toggle({
          mode = "diagnostics",
          filter = {
            {
              severity = {
                vim.diagnostic.severity.ERROR,
                vim.diagnostic.severity.WARN,
              },
              function(item)
                return item.filename:find((vim.uv or vim.loop).cwd(), 1, true)
              end,
            },
          },
        })
      end,
      desc = "Workspace Diagnostics",
    },
  }
}
