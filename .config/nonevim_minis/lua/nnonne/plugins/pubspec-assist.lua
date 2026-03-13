return {
  "akinsho/pubspec-assist.nvim",
  requires = "plenary.nvim",
  ft = "yaml",
  event = "BufRead pubspec.yaml",
  config = function()
    require("pubspec-assist").setup()
  end,
}
