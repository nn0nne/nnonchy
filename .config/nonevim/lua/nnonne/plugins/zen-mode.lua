local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
  pack.add({ "zen-mode.nvim" })

  require("zen-mode").setup({
    {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        width = 80,      -- width of the Zen window
        height = 1,      -- height of the Zen window
        options = {
          -- signcolumn = "no", -- disable signcolumn
          -- number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,                -- disables the ruler text in the cmd line area
          showcmd = false,              -- disables the command in the last line of the screen
          laststatus = 0,               -- turn off the statusline in zen mode
        },
        twilight = { enabled = true },  -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false }, -- disables git signs
        tmux = { enabled = false },     -- disables the tmux statusline
        todo = { enabled = false },     -- if set to "true", todo-comments.nvim highlights will be disabled
        kitty = {
          enabled = false,
          font = "+4", -- font size increment
        },
      },
      on_open = function(win)
      end,
      on_close = function()
      end,
    }
  })
end

return M
