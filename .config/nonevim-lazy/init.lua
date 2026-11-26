vim.loader.enable()

require("nnonne.config.options")
require("nnonne.config.keymaps")
require("nnonne.config.autocommands")
require("nnonne.util.bigfile").setup()
require("nnonne.config.core-ui2").setup()
require("nnonne.util.defer-cs-args").setup()

require("nnonne.config.lazy")
