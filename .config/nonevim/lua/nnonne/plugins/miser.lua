local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
  pack.add({ "miser.nvim" })

  require("miser").setup({
    auto_install = true,                                     -- run `mise install` on startup
    auto_format = true,                                      -- format on save (registry first, LSP fallback)
    auto_lsp = true,                                         -- enable LSPs from mise tools
    registry = {},                                           -- override or extend the built-in registry
    task_runner = nil,                                       -- function(cmd_string) -> ... (default: terminal split)
    task_keymaps = { enabled = true, prefix = "<leader>m" }, -- bind <prefix><alias> for tasks with an `alias`}
  })
end

return M
