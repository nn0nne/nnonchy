local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
  pack.add({ "lualine.nvim", "opencode.nvim" })

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
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
        refresh_time = 16, -- ~60fps
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

            local current_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
            if ft_map[current_ft] then
              return ft_map[current_ft]
            end

            local buf_name = vim.api.nvim_buf_get_name(0)
            if buf_name:match("opencode") then
              return "オープンコード" -- Renders "オープンコード" (Opencode in Katakana)
            end

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
            return mode_map[vim.api.nvim_get_mode().mode] or ""
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
        {
          "filename",
          file_status = true,
          newfile_status = false,
          path = 4,
          symbols = {
            modified = "[+]",
            readonly = "[-]",
            unnamed = "",
            newfile = "[New]",
          },
        },
      },
      -- lualine_x = { { require("opencode").statusline } },
      lualine_x = {},
      lualine_y = { { "datetime", style = "%u%d%m%H%M" } },
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
      lualine_c = { "filename" },
      lualine_x = { "filetype" },
      lualine_y = { "datetype" },
      lualine_z = { "searchcount", "selectioncount", "location", "progress" },
    },
    -- extensions = {
    --   "oil",
    --   "man",
    --   "mason",
    --   "quickfix",
    --   "toggleterm",
    --   "trouble",
    --   "nvim-dap-ui",
    -- },
  })
end

return M
