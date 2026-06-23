-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/registry.lua

local M = {}

local plugins = {
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/sainnhe/gruvbox-material" },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/folke/ts-comments.nvim" },
  { src = "https://github.com/knubie/vim-kitty-navigator" },
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/vyfor/cord.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/bullets-vim/bullets.vim" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  -- { src = "https://github.com/MagicDuck/grug-far.nvim" },
  { src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
  { src = "https://github.com/stevearc/dressing.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/3rd/image.nvim" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/nickjvandyke/opencode.nvim" },
  { src = "https://github.com/dmtrKovalenko/fff" },
  { src = "https://github.com/f-person/git-blame.nvim" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/JezerM/oil-lsp-diagnostics.nvim" },
  { src = "https://github.com/refractalize/oil-git-status.nvim" },
  { src = "https://github.com/malewicz1337/oil-git.nvim" },
  { src = "https://github.com/hmdfrds/focal.nvim" },
  { src = "https://github.com/piersolenski/import.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/artemave/workspace-diagnostics.nvim" },
  { src = "https://github.com/mistweaverco/kulala.nvim" },
  { src = "https://github.com/folke/zen-mode.nvim" },
}

M.map = {}
for _, plugin in ipairs(plugins) do
  local key = plugin.src:match("([^/]+)$"):gsub("%.git$", ""):gsub("/$", "")

  if key and key ~= "" then
    M.map[key] = vim.tbl_extend("force", {
      name = key,
    }, plugin)
  else
    error("Failed to parse repo name from GitHub URL: " .. tostring(plugin.src))
  end
end

function M.by_names(names)
  local out = {}
  for _, name in ipairs(names) do
    local entry = M.map[name]
    if not entry then
      error("Unknown plugin registry entry: " .. tostring(name))
    end
    table.insert(out, entry)
  end
  return out
end

function M.names()
  local keys = {}
  for name, _ in pairs(M.map) do
    table.insert(keys, name)
  end
  table.sort(keys)
  return keys
end

function M.all()
  return M.by_names(M.names())
end

return M
