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
    "lazydev.nvim",
    "blink.cmp"
  })

  require("mason").setup({})
  require("mason-lspconfig").setup({})

  vim.lsp.config("*", {
    on_attach = function(client, bufnr)
      if client.name == "harper_ls" then
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
  capabilities.textDocument.completion.completionItem.snipvtslspetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities = require("blink.cmp").get_lsp_capabilities()

  vim.lsp.config("*", { capabilities = capabilities })

  vim.lsp.config("lua_ls", {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = {
          globals = { "vim" },
        },
        completion = {
          callSnippet = "Replace",
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = { enable = false }
      },
    },
  })

  vim.lsp.config("harper_ls", {
    filetypes = { "markdown" },
  })

  local ft_scope = {
    astro       = { "astro" },
    pylsp       = { "python" },
    ruff        = { "python" },
    bashls      = { "sh", "bash", "zsh" },
    cssls       = { "css", "scss", "less" },
    eslint      = { "javascript", "typescript", "javascriptreact", "typescriptreact", "astro" },
    gradle_ls   = { "groovy", "gradle" },
    groovyls    = { "groovy" },
    html        = { "html" },
    jsonls      = { "json", "jsonc" },
    tailwindcss = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "astro" },
    ts_ls       = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    yamlls      = { "yaml" },
    clangd      = { "c", "cpp" },
    biome       = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
    marksman    = { "markdown" },
    tombi       = { "toml" },
  }

  for server, fts in pairs(ft_scope) do
    vim.lsp.config(server, { filetypes = fts })
  end

  vim.lsp.enable(lsp_tools.lsp_names())

  require("import").setup({
    picker = "telescope",
  })

  vim.keymap.set("n", "<leader>i", function()
    require("import").pick()
  end, { desc = "Import" })

  require("conform").setup({
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters_by_ft = lsp_tools.formatters_by_ft(),
    formatters = {
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
    }
  })

  -- Trigger nvim-lint automatically on save, read, and leaving insert mode
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    callback = function()
      local lint = require("lint")
      local ft = vim.bo.filetype

      -- 1. Check if the linters for this filetype are wrapped in a function
      if type(lint.linters_by_ft[ft]) == "function" then
        -- 2. Force evaluate the function to get the actual table of linters,
        --    then temporarily pass it to try_lint
        local linters = lint.linters_by_ft[ft]()
        lint.try_lint(linters)
      else
        -- 3. If it's a regular table (like markdown), run normally
        lint.try_lint()
      end
    end,
  })


  mason_utils.setup_install_defaults_command(lsp_tools.tools)

  vim.lsp.inlay_hint.is_enabled()
end

return M
