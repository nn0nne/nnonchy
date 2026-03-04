return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  opts = {
    enabled = true,
    log_level = vim.log.levels.OFF,
    editor = {
      client = "neovim",
      tooltip = "I don't know what I'm doing",
      icon = "https://cdn3.emoji.gg/emojis/9736_clownnerd.png",
    },
    display = {
      theme = "atom",
      flavor = "dark",
      swap_fields = true,
      swap_icons = true,
    },
    timestamp = {
      enabled = true,
      reset_on_idle = false,
      reset_on_change = false,
    },
    idle = {
      enabled = true,
      timeout = 3000,
      show_status = true,
      ignore_focus = true,
      unidle_on_focus = true,
      smart_idle = true,
      details = "眠いよね、みんな？",
      state = "すやすや",
      tooltip = "₍₋ ู₋₎ ᶻzᶻzᶻ",
      icon = "https://cdn3.emoji.gg/emojis/5301_clownsleepy.png",
    },
    text = {
      default = "(-_-)",
      workspace = function(_)
        return "Staring blankly at the terminal..."
      end,
      viewing = function(_)
        return "Using Neovim"
      end,
      editing = function(_)
        return "Using Neovim"
      end,
      file_browser = function(_)
        return "Using Neovim"
      end,
      plugin_manager = function(_)
        return "Using Neovim"
      end,
      lsp = function(_)
        return "Using Neovim"
      end,
      docs = function(_)
        return "Using Neovim"
      end,
      vcs = function(_)
        return "Using Neovim"
      end,
      notes = function(_)
        return "Using Neovim"
      end,
      debug = function(_)
        return "Using Neovim"
      end,
      test = function(_)
        return "Using Neovim"
      end,
      diagnostics = function(_)
        return "Using Neovim"
      end,
      games = function(_)
        return "Using Neovim"
      end,
      terminal = function(_)
        return "Using Neovim"
      end,
      dashboard = "Using Neovim",
      -- default = nil,
      -- workspace = function(opts)
      --   return "In " .. opts.workspace
      -- end,
      -- viewing = function(opts)
      --   return "Viewing " .. opts.filename
      -- end,
      -- editing = function(opts)
      --   return "Editing " .. opts.filename
      -- end,
      -- file_browser = function(opts)
      --   return "Browsing files in " .. opts.name
      -- end,
      -- plugin_manager = function(opts)
      --   return "Managing plugins in " .. opts.name
      -- end,
      -- lsp = function(opts)
      --   return "Configuring LSP in " .. opts.name
      -- end,
      -- docs = function(opts)
      --   return "Reading " .. opts.name
      -- end,
      -- vcs = function(opts)
      --   return "Committing changes in " .. opts.name
      -- end,
      -- notes = function(opts)
      --   return "Taking notes in " .. opts.name
      -- end,
      -- debug = function(opts)
      --   return "Debugging in " .. opts.name
      -- end,
      -- test = function(opts)
      --   return "Testing in " .. opts.name
      -- end,
      -- diagnostics = function(opts)
      --   return "Fixing problems in " .. opts.name
      -- end,
      -- games = function(opts)
      --   return "Playing " .. opts.name
      -- end,
      -- terminal = function(opts)
      --   return "Running commands in " .. opts.name
      -- end,
      -- dashboard = "Home",
    },
    buttons = nil,
    -- buttons = {
    --   {
    --     label = 'View Repository',
    --     url = function(opts) return opts.repo_url end,
    --   },
    -- },
    assets = nil,
    variables = nil,
    hooks = {
      ready = nil,
      shutdown = nil,
      pre_activity = nil,
      post_activity = nil,
      idle_enter = function(opts)
        opts.manager:set_activity({
          details = "眠いよね、みんな？",
          state = "すやすや",
          is_idle = true,
          assets = {
            large_image = "https://cdn3.emoji.gg/emojis/5301_clownsleepy.png",
            large_text = "₍₋ ู₋₎ ᶻzᶻzᶻ",
          },
        })
      end,
      idle_leave = function(opts)
        opts.manager:set_activity({
          details = "Staring blankly at the terminal...",
          state = "Using Neovim",
          is_idle = false,
          assets = {
            large_image = "https://cdn3.emoji.gg/emojis/9736_clownnerd.png",
            large_text = "I don't know what I'm doing",
          },
        })
      end,
      workspace_change = function(opts)
        opts.manager:set_activity({
          type = "watching",
          details = "Staring at other terminal...",
          state = "Using Neovim",
          is_idle = false,
          assets = {
            large_image = "https://cdn3.emoji.gg/emojis/9736_clownnerd.png",
            large_text = "I still don't know what I'm doing",
          },
        })
      end,
    },
    plugins = nil,
    advanced = {
      plugin = {
        autocmds = true,
        cursor_update = "on_hold",
        match_in_mappings = true,
      },
      server = {
        update = "fetch",
        pipe_path = nil,
        executable_path = nil,
        timeout = 300000,
      },
      discord = {
        reconnect = {
          enabled = false,
          interval = 5000,
          initial = true,
        },
      },
    },
  },
}
