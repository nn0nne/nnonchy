-- TODO:
-- - add and configure more plugins
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
require("nnonne.plugins.lsp").setup()
require("nnonne.plugins.completion").setup()
require("nnonne.plugins.treesitter").setup()
require("nnonne.plugins.mini.minis").setup()
require("nnonne.plugins.mini.pick").setup()
require("nnonne.plugins.mini.files").setup()
require("nnonne.plugins.trouble").setup()
require("nnonne.plugins.lazydev").setup()
require("nnonne.plugins.which-key").setup()
require("nnonne.plugins.gitui").setup()
require("nnonne.plugins.vim-kitty-nav").setup()
require("nnonne.plugins.cord").setup()
require("nnonne.plugins.comments").setup()
require("nnonne.plugins.undotree").setup()
