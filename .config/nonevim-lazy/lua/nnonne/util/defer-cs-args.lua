-- easy-dotnet's Roslyn LSP can crash with "didOpen ... already open" when a
-- C# file is opened as a startup argument. Delay those buffers until Neovim
-- has finished starting so the LSP attaches to an already-settled project.
local M = {}

local DOTNET_FT = { cs = true, razor = true, cshtml = true, fs = true, vb = true }

function M.setup()
  local files = vim.fn.argv()
  if #files == 0 then return end

  local has_dotnet = false
  for _, file in ipairs(files) do
    local ext = file:match("%.([^.]+)$")
    if ext and DOTNET_FT[ext] then
      has_dotnet = true
      break
    end
  end
  if not has_dotnet then return end

  vim.cmd("args!")
  for _, file in ipairs(files) do
    local buf = vim.fn.bufnr(vim.fn.fnameescape(file), 0)
    if buf > 0 then vim.api.nvim_buf_delete(buf, { force = true }) end
  end

  vim.defer_fn(function()
    for _, file in ipairs(files) do
      vim.cmd("edit " .. vim.fn.fnameescape(file))
    end
  end, 600)
end

return M
