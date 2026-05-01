-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/utils/pack.lua

local M = {}

local pluglist = require("nnonne.plugins.pluglist")

function M.pluglist(names)
  return pluglist.by_names(names)
end

function M.add(names, opts)
  vim.pack.add(M.pluglist(names), opts)
end

function M.names()
  return pluglist.names()
end

return M
