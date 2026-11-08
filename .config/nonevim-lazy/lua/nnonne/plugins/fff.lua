return {
  'dmtrKovalenko/fff',
  build = function()
    -- downloads a prebuilt binary or falls back to cargo build
    require("fff.download").download_or_build_binary()
  end,
  lazy = false, -- the plugin lazy-initialises itself
  config = function()
    local root = vim.uv.cwd()

    require("fff").setup({
      prompt = "(づ｡◕‿‿◕｡)づ ",
      layout = {
        prompt_position = "top",
      },
      lazy_sync = true,
      debug = { enabled = false, show_scores = false },
    })

    local function with_root(extra)
      return vim.tbl_extend("force", { cwd = root }, extra or {})
    end

    vim.keymap.set("n", "<leader>ff", function()
      require("fff").find_files(with_root())
    end, { desc = "Find files - FFF" })
    vim.keymap.set("n", "<leader>fg", function()
      require("fff").live_grep(with_root())
    end, { desc = "Grep files - FFF" })
    vim.keymap.set("n", "<leader>fz", function()
      require("fff").live_grep(with_root({ grep = { modes = { "fuzzy", "plain" } } }))
    end, { desc = "Grep files - FFF" })
  end
}
