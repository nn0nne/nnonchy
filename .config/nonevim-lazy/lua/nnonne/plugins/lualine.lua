return {
  {
    "justinhj/battery.nvim",

    opts = {
      update_rate_seconds = 60,
      show_status_when_no_battery = false,
      show_plugged_icon = false,
      show_unplugged_icon = true,
      show_percent = true,
      vertical_icons = false,
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-mini/mini.nvim' },
    init = function()
      -- Ensure mock_nvim_web_devicons runs before lualine attempts to load icons
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    config = function()
      local function project_root(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        local root
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
          local r = client.config and client.config.root_dir
          if r and r ~= "" and name:sub(1, #r + 1) == r .. "/" and (not root or #r > #root) then
            root = r
          end
        end
        return root or vim.uv.cwd()
      end

      local function project_filename()
        local buf = vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(buf)
        local path

        if name == "" or name:match("^%a+://") then
          path = vim.fn.expand("%:t")
        else
          local root = project_root(buf):gsub("/+$", "")
          path = name:sub(1, #root + 1) == root .. "/" and name:sub(#root + 2)
              or vim.fn.fnamemodify(name, ":~")

          local parts = vim.split(path, "/")
          if #parts > 3 then -- more than 2 directories
            path = parts[1] .. "/.../" .. parts[#parts]
          end
        end

        if vim.bo[buf].modified then path = path .. " [+]" end
        if not vim.bo[buf].modifiable or vim.bo[buf].readonly then path = path .. " [-]" end
        return path
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "alpha", "ministarter" },
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = true,
          refresh = {
            -- statusline = 1000,
            -- tabline = 1000,
            -- winbar = 1000,
            -- refresh_time = 100, -- ~60fps
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
            },
          },
        },
        sections = {
          lualine_a = {
            {
              function()
                local ft_map = {
                  oil             = "オイル",
                  man             = "マニュアル",
                  mason           = "メイソン",
                  quickfix        = "クイックフィックス",
                  toggleterm      = "トグルターム",
                  trouble         = "トラブル",
                  ["nvim-dap-ui"] = "デバッグウイ",
                  opencode        = "オープンコード",
                }

                local mode_str = ""
                local current_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })

                if ft_map[current_ft] then
                  mode_str = ft_map[current_ft]
                else
                  local buf_name = vim.api.nvim_buf_get_name(0)
                  if buf_name:match("opencode") then
                    mode_str = "オープンコード"
                  else
                    local mode_map = {
                      n = "ノーマル",
                      i = "インサート",
                      v = "ビジュアル",
                      V = "ビジュアルライン",
                      ["\22"] = "ビジュアルブロック",
                      c = "コマンド",
                      R = "リプレイス",
                      s = "セレクト",
                      S = "セレクトライン",
                      t = "ターミナル",
                    }
                    mode_str = mode_map[vim.api.nvim_get_mode().mode] or ""
                  end
                end

                -- Safe UID check for root/sudo
                local is_sudo = ((vim.uv or vim.loop).getuid() == 0)
                if is_sudo then
                  -- Adds a red lock icon to the left of the mode text
                  return "%#DiagnosticError#%* " .. mode_str
                end

                return mode_str
              end,
              refresh = {
                statusline = { "ModeChanged", "BufEnter", "FileType" }
              }
            },
          },
          lualine_b = {
            "branch",
            "diff",
            "diagnostics",
          },
          lualine_c = {
            project_filename
            -- {
            --   "filename",
            --   file_status = true,
            --   newfile_status = false,
            --   path = 4,
            --   symbols = {
            --     modified = "[+]",
            --     readonly = "[-]",
            --     unnamed = "",
            --     newfile = "[New]",
            --   },
            -- },
          },
          lualine_x = {},
          lualine_y = {
            { "datetime", style = "0%u%d%m%H%M" },
            function()
              return require("battery").get_status_line()
            end,
          },
          lualine_z = { { "searchcount", maxcount = 999, timeout = 500 }, "selectioncount", "location", "progress" },
        },
        inactive_sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diff",
            "diagnostics",
            "lsp_status",
          },
          lualine_c = { project_filename },
          lualine_x = { "filetype" },
          lualine_y = { "datetype" },
          lualine_z = { "searchcount", "selectioncount", "location", "progress" },
        },
      })
    end
  } }
