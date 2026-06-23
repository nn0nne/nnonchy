local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
  pack.add({ "lazydev.nvim" })

  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library",    words = { "vim%.uv" } },
      { path = "/usr/share/hypr/stubs", words = { "hyprland" } },
    },
  })
end

return M
