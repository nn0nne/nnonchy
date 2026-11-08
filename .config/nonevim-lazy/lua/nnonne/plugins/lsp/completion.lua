return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-s>"] = { "show_signature", "hide_signature" },
        ["<CR>"] = { "select_and_accept", "fallback" },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        completion = {
          menu = { auto_show = true },
          list = {
            selection = { preselect = false }
          },
          ghost_text = { enabled = true }
        },
      },
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = false,
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        trigger = {
          show_on_accept_on_trigger_character = false,
        },
        list = {
          selection = {
            auto_insert = false,
          },
        },
        menu = {
          auto_show = true,
          border = "none",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label",     gap = 2 },
              { "kind_icon", gap = 1, "kind" },
            },
            components = {
              -- customize the drawing of kind icons
              kind_icon = {
                text = function(ctx)
                  -- default kind icon
                  local icon = ctx.kind_icon
                  -- if LSP source, check for color derived from documentation
                  if ctx.item.source_name == "LSP" then
                    local color_item = require("nvim-highlight-colors").format(ctx.item.documentation,
                      { kind = ctx.kind })
                    if color_item and color_item.abbr ~= "" then
                      icon = color_item.abbr
                    end
                  end
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  -- default highlight group
                  local highlight = "BlinkCmpKind" .. ctx.kind
                  -- if LSP source, check for color derived from documentation
                  if ctx.item.source_name == "LSP" then
                    local color_item = require("nvim-highlight-colors").format(ctx.item.documentation,
                      { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      highlight = color_item.abbr_hl_group
                    end
                  end
                  return highlight
                end,
              },
            },
          },
        },
        documentation = {
          -- Manual on <C-space> (blink's `show_documentation`). Auto-show fetches
          -- docs per selected item, which is chatty on large files.
          auto_show = true,
          auto_show_delay_ms = 200,
          -- window = {
          --   -- border = "none",
          --   max_width = math.floor(vim.o.columns * 0.4),
          --   max_height = math.floor(vim.o.lines * 0.5),
          -- },
        },
        ghost_text = {
          enabled = false,
          show_with_menu = false
        }
      },
      snippets = { preset = "default" },
      sources = {
        default = { "lsp", "path", "buffer", "snippets" },
        per_filetype = {
          opencode_ask = { 'lsp', 'buffer' },
        },
        providers = {
          lsp = {
            fallbacks = {},
          },
          -- snippets = {
          --   name = "Snippets",
          --   module = "blink.cmp.sources.snippets",
          --   min_keyword_length = 3,
          --   opts = {
          --   },
          -- },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    })
  end
}
