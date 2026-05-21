-- TODO:
-- - add and configure keymaps
--
-- Shout out  https://github.com/kokopi-dev/dotfiles/blob/master/nvim/init.lua
vim.loader.enable()

require("nnonne.commands.pack").setup()

require("nnonne.settings.options")
require("nnonne.settings.keymaps")
require("nnonne.commands.autocommands")

require("nnonne.plugins.core-ui2").setup()
require("nnonne.plugins.vague").setup()
require("nnonne.plugins.mini.minis").setup()

require("nnonne.plugins.treesitter").setup()
require("nnonne.plugins.lsp").setup()

require("nnonne.plugins.lazydev").setup()
require("nnonne.plugins.completion").setup()
require("nnonne.plugins.trouble").setup()

require("nnonne.plugins.mini.starter").setup()
-- require("nnonne.plugins.mini.pick").setup()
require("nnonne.plugins.mini.files").setup()
require("nnonne.plugins.mini.statusline").setup()
require("nnonne.plugins.mini.tabline").setup()
require("nnonne.plugins.yazi").setup()
require("nnonne.plugins.fff").setup()

require("nnonne.plugins.comments").setup()
require("nnonne.plugins.auto-tag").setup()
require("nnonne.plugins.search-replace").setup()
require("nnonne.plugins.bullets").setup()
require("nnonne.plugins.undotree").setup()
-- require("nnonne.plugins.gitui").setup()
require("nnonne.plugins.flutter-tools").setup()
require("nnonne.plugins.render-markdown").setup()
-- require("nnonne.plugins.snacks-image").setup()
require("nnonne.plugins.image").setup()
require("nnonne.plugins.toggle-term").setup()
require("nnonne.plugins.opencode").setup()
require("nnonne.plugins.git-blame").setup()
-- require("nnonne.plugins.edgy").setup()
require("nnonne.plugins.nvim-dap").setup()

require("nnonne.plugins.which-key").setup()
require("nnonne.plugins.vim-kitty-nav").setup()
require("nnonne.plugins.cord").setup()
