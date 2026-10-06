return {
  "selimacerbas/markdown-preview.nvim",
  -- a live-server.nvim checkout under another dir name needs its spec to
  -- say name = "live-server.nvim", or lazy.nvim clones upstream beside it
  dependencies = { "selimacerbas/live-server.nvim" },
  config = function()
    require("markdown_preview").setup({
      -- all optional; sane defaults shown
      instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
      port = 0,                   -- 0 = auto (8421 for takeover, OS-assigned for multi)
      open_browser = true,
      default_theme = "dark",     -- "dark" or "light"; initial preview theme
      debounce_ms = 300,
    })
  end,
}
