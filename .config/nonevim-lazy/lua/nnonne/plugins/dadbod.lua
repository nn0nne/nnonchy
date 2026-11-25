-- Database UI (PostgreSQL, SQLite, etc.)
return {
  "tpope/vim-dadbod",
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_help = 0
  end,
  config = function()
    vim.keymap.set("n", "<leader>dB", "<cmd>DBUIToggle<CR>", { desc = "Database UI" })
  end,
}
