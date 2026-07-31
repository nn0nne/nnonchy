local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
  pack.add({ "miser.nvim" })

  require("miser").setup({
    auto_install = true,
    auto_format = true,
    auto_lsp = true,
    registry = {},
    task_runner = nil,
    task_keymaps = { enabled = true, prefix = "<leader>m" },
  })
end

return M
