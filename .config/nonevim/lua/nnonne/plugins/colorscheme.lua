local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
  -- pack.add({ "vague.nvim" })
  -- require("vague").setup({
  --   transparent = true,
  -- })
  -- vim.cmd.colorscheme("vague")

  vim.o.background = "dark"

  pack.add({ "zenbones.nvim", "lush.nvim" })
  vim.g.zenwritten_compat = 1
  vim.cmd.colorscheme("darker-zenwritten")
end

return M
