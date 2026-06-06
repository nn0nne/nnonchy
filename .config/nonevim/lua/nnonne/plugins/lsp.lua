-- Shout out https://github.com/kokopi-dev/dotfiles/blob/master/nvim/lua/plugins/lsp.lua
local M = {}

local pack = require("nnonne.commands.pack")
local mason_utils = require("nnonne.commands.mason")
local lsp_tools = require("nnonne.plugins.lsp-manager")

function M.setup()
  pack.add({
    "mason.nvim",
    "conform.nvim",
    "nvim-lint",
    "nvim-lspconfig",
    "mason-lspconfig.nvim",
    "import.nvim",
    "telescope.nvim",
    "workspace-diagnostics.nvim",
  })

  require("mason").setup({})
  require("mason-lspconfig").setup({})

  vim.lsp.config("*", {
    on_attach = function(client, bufnr)
      if client.name == "lua_ls" or client.name == "harper_ls" then
        return
      end

      pcall(function()
        if client:supports_method("textDocument/diagnostic") then
          return
        else
          require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
        end
      end)
    end,
  })


  local capabilities = vim.lsp.protocol.make_client_capabilities()
  pcall(function()
    capabilities = require("blink.cmp").get_lsp_capabilities()
  end)
  vim.lsp.config("*", { capabilities = capabilities })

  -- Shout out https://www.lazyvim.org/extras/lang/typescript/vtsls
  vim.lsp.config("vtsls", {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
  })

  -- Shout out https://www.lazyvim.org/extras/lang/typescript/tsgo
  vim.lsp.config("tsgo", {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    settings = {
      typescript = {
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = false },
          parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
  })

  vim.lsp.config("tailwindcss", {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            "Css = (\\{[^\\{\\}]+\\}|\\[[^\\[\\]]+\\]|'[^']+'|\"[^\"]+\")",
          },
        },
      },
    },
    filetypes = {
      "html",
      "css",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
  })

  vim.lsp.config("eslint", {
    settings = {
      workingDirectories = { mode = "auto" },
    },
  })

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          preloadFileSize = 1000,
          maxPreload = 2000,
          checkThirdParty = false,
          ignoreDir = { ".git", "node_modules" },
        },
        telemetry = { enable = false },
        hint = { enable = true },
      },
      single_file_support = true,
    },
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".git",
      "init.lua",
      "init.sls",
    },
  })

  vim.lsp.config("harper_ls", {
    settings = {
      ["harper-ls"] = {
        userDictPath = "~/dict.txt",
      },
    },
  })

  vim.lsp.enable(lsp_tools.lsp_names())

  require("import").setup({
    picker = "telescope",
  })

  vim.keymap.set("n", "<leader>i", function()
    require("import").pick()
  end, { desc = "Import" })

  require("conform").setup({
    format_on_save = {
      timout_ms = 500,
      lsp_format = "fallback",
    },
    formatters_by_ft = lsp_tools.formatters_by_ft(),
  })

  require("lint").linters_by_ft = lsp_tools.linters_by_ft()

  mason_utils.setup_install_defaults_command(lsp_tools.tools)
end

return M
