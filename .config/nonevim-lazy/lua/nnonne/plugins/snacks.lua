return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    -- Toggle general floating terminal (<leader>tt)
    {
      "<leader>tt",
      function()
        Snacks.terminal.toggle(nil, {
          win = { position = "float" },
        })
      end,
      desc = "Toggle floating terminal",
      mode = { "n", "t" },
    },
  },
  ---@type snacks.Config
  opts = {
    terminal = {
      enabled = true,
      win = {
        border = "single"
      }
    },
    bigfile = {
      enabled = true,
      notify = true,            -- show notification when big file detected
      size = 1.5 * 1024 * 1024, -- 1.5MB
      line_length = 1000,       -- average line length (useful for minified files)
      -- Enable or disable features when big file detected
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        if vim.fn.exists(":NoMatchParen") ~= 0 then
          vim.cmd([[NoMatchParen]])
        end
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        vim.b.completion = false
        vim.b.minianimate_disable = true
        vim.b.minihipatterns_disable = true
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then
            vim.bo[ctx.buf].syntax = ctx.ft
          end
        end)
      end,
    },
    input = {
      enabled = true
    },
    picker = {
      enabled = true, -- Enhances Select
      win = {
        input = {
          keys = {
            ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
          },
        },
      },
      actions = {
        opencode_send = function(picker) ---@param picker snacks.Picker
          local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
            return item.file
                and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                or item.text
          end, picker:selected({ fallback = true }))

          require("opencode").prompt(table.concat(items, ", ") .. " ")
        end,
      },
    },
  },
  config = function()
    local opencode_cmd = 'opencode'
    ---@type snacks.terminal.Opts
    local snacks_terminal_opts = {
      win = {
        position = 'right',
        enter = false,
      },
    }

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
        end,
      },
    }

    -- Can also leverage toggle functionality.
    -- If you use <leader> here, remove 't' — otherwise Neovim will add input delay to your <leader> when typing in the terminal to watch for the mapping.
    vim.keymap.set({ 'n', 't' }, '<C-.>', function()
      require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
    end, { desc = 'Toggle OpenCode' })

    -- Optionally show the terminal when OpenCode starts executing
    vim.api.nvim_create_autocmd('User', {
      pattern = { 'OpencodeEvent:session.execution.started' },
      callback = function()
        local win = require('snacks.terminal').get(opencode_cmd, { create = false })
        if win then
          win:show()
        end
      end,
    })
  end
}
