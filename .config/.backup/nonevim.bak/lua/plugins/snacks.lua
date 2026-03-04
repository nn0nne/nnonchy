return {
  "folke/snacks.nvim",
  opts = {
    animate = {
      duration = 20,
      easing = "linear",
      fps = 60,
    },
    bigfile = {
      enabled = true,
      notify = true, -- Tells you "Big file detected!"
      size = 1.5 * 1024 * 1024, -- Threshold of 1.5MB
      line_length = 1000, -- Detects minified JS/CSS files

      -- This function runs when a big file is opened
      setup = function(ctx)
        -- Disable heavy UI features for this specific buffer
        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd([[NoMatchParen]])
        end

        -- Use Snacks utility to set local window options efficiently
        Snacks.util.wo(0, {
          foldmethod = "manual",
          statuscolumn = "",
          conceallevel = 0,
        })

        vim.b.completion = false -- Disable heavy completion engines

        -- Re-enable basic syntax highlighting without LSP/Treesitter
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },
    dim = {
      scope = {
        min_size = 5,
        max_size = 20,
        siblings = true, -- dims everything except the current scope and its siblings
      },
      animate = {
        enabled = true, -- specifically for the dimming transition
        easing = "outQuad",
        duration = {
          step = 20,
          total = 300,
        },
      },
      -- If you want to use the default filter, you can omit this part.
      -- Only include it if you want to change which buffers get dimmed.
      filter = function(buf)
        return vim.g.snacks_dim ~= false and vim.bo[buf].buftype == ""
      end,
    },
    image = {
      enabled = true,
      -- 1. FILE TYPES
      formats = { "png", "jpg", "jpeg", "gif", "webp", "pdf" },

      -- 2. DOCUMENT SETTINGS (Markdown/LaTeX)
      doc = {
        enabled = true,
        inline = true,
        max_width = 80,
        max_height = 40,
        -- Conceals the LaTeX code and only shows the rendered math image
        conceal = function(lang, type)
          return type == "math"
        end,
      },

      -- 3. MATH RENDERING (LaTeX/Typst)
      math = {
        enabled = true,
        latex = {
          font_size = "Large",
          packages = { "amsmath", "amssymb", "mathtools" },
        },
      },

      -- 4. WINDOW OPTIONS (How the image buffer looks)
      wo = {
        wrap = false,
        number = false,
        relativenumber = false,
        signcolumn = "no",
        statuscolumn = "",
      },
    },
    quickfile = {},
    -- lazy.nvim
    {
      opts = {
        scroll = {
          animate = {
            duration = { step = 10, total = 200 },
            easing = "linear",
          },
          -- faster animation when repeating scroll after delay
          animate_repeat = {
            delay = 100, -- delay in ms before using the repeat animation
            duration = { step = 5, total = 50 },
            easing = "linear",
          },
          -- what buffers to animate
          filter = function(buf)
            return vim.g.snacks_scroll ~= false
              and vim.b[buf].snacks_scroll ~= false
              and vim.bo[buf].buftype ~= "terminal"
          end,
        },
      },
    },
    terminal = {
      win = { style = "" },
    },
    zen = {
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        -- diagnostics = false,
        -- inlay_hints = false,
      },
      center = true, -- center the window
      show = {
        statusline = false, -- can only be shown when using the global statusline
        tabline = false,
      },
      ---@type snacks.win.Config
      win = { style = "zen" },
      --- Callback when the window is opened.
      ---@param win snacks.win
      on_open = function(win) end,
      --- Callback when the window is closed.
      ---@param win snacks.win
      on_close = function(win) end,
      --- Options for the `Snacks.zen.zoom()`
      ---@type snacks.zen.Config
      zoom = {
        toggles = {},
        center = false,
        show = { statusline = true, tabline = true },
        win = {
          backdrop = false,
          width = 0, -- full width
        },
      },
    },
  },
}
