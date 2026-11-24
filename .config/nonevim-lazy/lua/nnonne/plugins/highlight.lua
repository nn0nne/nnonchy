return {
  'brenoprata10/nvim-highlight-colors',
  config = function()
    require("nvim-highlight-colors").setup({
      render = "background",
      enable_hex = true,
      enable_short_hex = true,
      enable_rgb = true,
      enable_hsl = true,
      enable_ansi = true,
      enable_hsl_without_function = true,
      enable_var_usage = true,
      enable_tailwind = true,
      -- Full clear + rescan on TextChanged/BufEnter is wasted work in markdown
      -- and in big buffers; the plugin supports skipping both.
      exclude_filetypes = { "markdown" },
      exclude_buffer = function(bufnr)
        return require("nnonne.util.bigfile").is_big(bufnr)
      end,
    })
  end
}
