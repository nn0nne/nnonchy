return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      exclude = { -- add folder names here to exclude
        -- ".git",
        "node_modules",
        -- "ios",
        -- "macos",
        -- "web",
        -- "windows",
        -- "linux",
      },
      hidden = true,
      enabled = true,
      sources = {
        explorer = {
          layout = { preset = "telescope", reverse = false, preview = true }, -- or { preset = "sidebar" }
          auto_close = true,
          cwd = vim.fn.getcwd(),
        },
        files = {},
      },
      win = {
        input = {
          keys = {
            ["<a-h>"] = false, -- unbind <a-h>
          },
        },
        list = {
          keys = {
            ["<a-h>"] = false, -- unbind <a-h> here too
          },
        },
      },
    },
  },

  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer.open()
      end,
      desc = "Open Snacks Picker",
    },
  },
}
