return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "saghen/blink.cmp" },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
    },
    inlay_hints = {
      enabled = false,
      exclude = { "vue" },
    },
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
            codeLens = {
              enable = true,
            },
            completion = {
              callSnippet = "Replace",
            },
            doc = {
              privateName = { "^_" },
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      },
      vtsls = {
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        settings = {
          javascript = {
            checkJs = true,
            suggest = {
              autoImports = true,
              completeFunctionCalls = true,
            },
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
            preferences = {
              importModuleSpecifier = "non-relative",
              includePackageJsonAutoImports = "off",
            },
          },
          typescript = {
            -- avoid npm @types fetching and reduce completion work on big repos
            disableAutomaticTypeAcquisition = true,
            tsserver = {
              -- VSCode defaults to 3072; raise it so tsserver doesn't GC-thrash
              -- on large projects (see vtsls README "large repo" section).
              maxTsServerMemory = 4096,
            },
            suggest = {
              autoImports = true,
              completeFunctionCalls = true,
            },
            preferences = {
              importModuleSpecifier = "non-relative",
              includePackageJsonAutoImports = "off",
            },
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMoveToFileCodeAction = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
        },
      },
      prismals = {
        filetypes = { "prisma" },
        -- lspconfig defaults to { '.git', 'package.json' }, and vim.fs.root
        -- resolves markers in list order -- so '.git' wins and the root becomes
        -- the monorepo root. Prefer package.json so the server roots at the
        -- project that owns prisma/schema.prisma.
        root_markers = { "package.json", ".git" },
      },
      tailwindcss = {
        filetypes = { "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      html = {},
      cssls = {
        filetypes = { "css", "scss", "less" },
      },
      jsonls = {
        filetypes = { "json", "jsonc" },
      },
      eslint = {
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      groovyls = {
        filetypes = { "groovy" },
        enabled = vim.fn.executable("groovy-language-server") == 1,
      },
      gradle_ls = {
        filetypes = { "groovy", "gradle" },
        enabled = vim.fn.executable("gradle-language-server") == 1,
      },
    },
  },
  config = function(_, opts)
    local blink = require("blink.cmp")

    -- 1. Setup Diagnostics
    vim.diagnostic.config(opts.diagnostics)

    -- 2. Base Capabilities via blink.cmp
    local capabilities = blink.get_lsp_capabilities({
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    })

    -- 3. Set global defaults using vim.lsp.config('*', ...)
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- 3b. Spawn mise-backed servers with their cwd set to the project root.
    -- mise shims resolve tools from the *cwd* hierarchy, not from the file being
    -- edited, so a shim spawned from $HOME (or the nvim config dir) fails with
    -- "No version is set for shim" and the server silently never starts.
    -- Running the process inside the project root keeps tools per-project while
    -- making resolution independent of where Neovim was launched.
    ---@param tool string
    ---@param args string[]|nil
    ---@param prefer_local boolean|nil
    local function project_cmd(tool, args, prefer_local)
      return function(dispatchers, config)
        local cwd = type(config) == "table" and config.root_dir or nil

        local exe = tool
        if prefer_local and cwd then
          local local_cmd = vim.fs.joinpath(cwd, "node_modules/.bin", tool)
          if vim.fn.executable(local_cmd) == 1 then
            exe = local_cmd
          end
        end

        local cmd = { exe }
        vim.list_extend(cmd, args or {})
        return vim.lsp.rpc.start(cmd, dispatchers, cwd and { cwd = cwd } or nil)
      end
    end

    --- servers whose binaries are provided by mise / node and are affected by
    --- shim resolution. { tool, args, prefer_project_local_binary }
    local mise_servers = {
      vtsls = { "vtsls", { "--stdio" } },
      tailwindcss = { "tailwindcss-language-server", { "--stdio" }, true },
      html = { "vscode-html-language-server", { "--stdio" }, true },
      cssls = { "vscode-css-language-server", { "--stdio" }, true },
      jsonls = { "vscode-json-language-server", { "--stdio" }, true },
      eslint = { "vscode-eslint-language-server", { "--stdio" }, true },
      prismals = { "prisma-language-server", { "--stdio" } },
      lua_ls = { "lua-language-server", {} },
    }

    -- 4. Global LSP Keymaps & Inlay Hints via LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local map_opts = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, map_opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, map_opts)
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, map_opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, map_opts)
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, map_opts)
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, map_opts)

        if client and client.server_capabilities.inlayHintProvider then
          local ft = vim.bo[ev.buf].filetype
          if not vim.tbl_contains(opts.inlay_hints.exclude or {}, ft) then
            vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
          end
        end
      end,
    })

    -- 5. Register server configurations and enable them natively
    for server, server_opts in pairs(opts.servers) do
      if server_opts and server_opts.enabled ~= false then
        local wrap = mise_servers[server]
        if wrap then
          server_opts.cmd = project_cmd(wrap[1], wrap[2], wrap[3])
        end
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end
    end
  end,
}
