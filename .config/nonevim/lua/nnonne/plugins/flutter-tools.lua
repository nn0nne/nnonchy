local M = {}

local lazy = require("nnonne.utils.lazy")
local pack = require("nnonne.commands.pack")

local function ensure_flutter()
  lazy.load_once("flutter-tools", pack.pluglist({ "flutter-tools.nvim", "plenary.nvim", "dressing.nvim" }), function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dart",
      once = true,
      callback = function()
        require("flutter-tools").setup({
          ui = {
            border = "rounded",
            notification_style = "native",
          },
          decorations = {
            statusline = {
              app_version = false,
              device = false,
              project_config = false,
            },
          },
          debugger = {
            enabled = false, -- enable nvim-dap integration -- idk have nvim-dap so disabled
          },
          root_patterns = { ".git", "pubspec.yaml" },
          widget_guides = { enabled = true },
          closing_tags = {
            highlight = "ErrorMsg",
            prefix = ">",
            enabled = true,
          },
          dev_log = {
            enabled = true,
            open_cmd = "15split",
            focus_on_open = true,
          },
          outline = {
            open_cmd = "30vnew",
            auto_open = false,
          },
          lsp = {
            capabilities = vim.lsp.protocol.make_client_capabilities(),
            settings = {
              showTodos = true,

              completeFunctionCalls = true,
              analysisExcludedFolders = {},
              renameFilesWithClasses = "prompt",
              enableSnippets = true,
              updateImportsOnRename = true,
            },
          },
        })
      end
    })
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        vim.lsp.document_color.enable(true, { bufnr = ev.buf })
      end,
    })
  end)
end

function M.setup()
  vim.keymap.set("n", "<leader>Frn", function()
    ensure_flutter(); vim.cmd("FlutterRun")
  end, { desc = "Run project" })
  vim.keymap.set("n", "<leader>Fd", function()
    ensure_flutter(); vim.cmd("FlutterDebug")
  end, { desc = "Debug project" })
  vim.keymap.set("n", "<leader>Flt", function()
    ensure_flutter(); vim.cmd("FlutterLogToggle")
  end, { desc = "Toggle Dev Log" })
  vim.keymap.set("n", "<leader>Flc", function()
    ensure_flutter(); vim.cmd("FlutterLogClear")
  end, { desc = "Clear Dev Log" })
  vim.keymap.set("n", "<leader>Frl", function()
    ensure_flutter(); vim.cmd("FlutterReload")
  end, { desc = "Hot Reload" })
  vim.keymap.set("n", "<leader>Frr", function()
    ensure_flutter(); vim.cmd("FlutterRestart")
  end, { desc = "Hot Restart" })
  vim.keymap.set("n", "<leader>Fq", function()
    ensure_flutter(); vim.cmd("FlutterQuit")
  end, { desc = "Quit app" })
  vim.keymap.set("n", "<leader>Fo", function()
    ensure_flutter(); vim.cmd("FlutterOutlineToggle")
  end, { desc = "Toggle Outline" })
  vim.keymap.set("n", "<leader>Fs", function()
    ensure_flutter(); vim.cmd("FlutterDevices")
  end, { desc = "Select Device" })
  vim.keymap.set("n", "<leader>Fe", function()
    ensure_flutter(); vim.cmd("FlutterEmulators")
  end, { desc = "Select Emulator" })
  vim.keymap.set("n", "<leader>Fv", function()
    ensure_flutter(); vim.cmd("FlutterDevTools")
  end, { desc = "Open DevTools" })
  vim.keymap.set("n", "<leader>Fpg", function()
    ensure_flutter(); vim.cmd("FlutterPubGet")
  end, { desc = "Pub Get" })
  vim.keymap.set("n", "<leader>Fpu", function()
    ensure_flutter(); vim.cmd("FlutterPubUpgrade")
  end, { desc = "Pub Upgrade" })
  vim.keymap.set("n", "<leader>Fpc", function()
    ensure_flutter()
    require("toggleterm.terminal").Terminal:new({ cmd = "flutter clean", hidden = true }):toggle()
  end, { desc = "Flutter Clean" })
end

return M
