return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost" },
  config = function()
    local lint = require("lint")

    -- ESLint is a per-project devDependency, not a global/mise tool, so resolve
    -- it from the buffer's project root instead of relying on `eslint` being on
    -- PATH. Only lint where an eslint config actually exists.
    local eslint_configs = {
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "eslint.config.ts",
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.json",
      ".eslintrc.yaml",
      ".eslintrc.yml",
    }

    ---@return string|nil root
    local function eslint_root()
      return vim.fs.root(0, eslint_configs)
    end

    ---@return string|nil executable
    local function resolve_eslint()
      local root = eslint_root()
      if not root then
        return nil
      end

      -- Prefer eslint_d (warm daemon) when present: type-checked eslint configs
      -- can take ~20s cold per invocation.
      for _, candidate in ipairs({
        root .. "/node_modules/.bin/eslint_d",
        "eslint_d",
        root .. "/node_modules/.bin/eslint",
        "eslint",
      }) do
        if vim.fn.executable(candidate) == 1 then
          return candidate
        end
      end

      return nil
    end

    -- Point the built-in eslint linter at the project-local binary.
    lint.linters.eslint.cmd = resolve_eslint

    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
    }

    -- Sandboxing state (default: false / bare execution)
    local use_sandbox = false

    ---@param linter lint.Linter
    ---@return lint.Linter
    local function systemd_run(linter)
      local cwd = vim.fn.getcwd()
      local cmd = linter.cmd
      if type(cmd) == "function" then
        cmd = cmd()
      end
      local args = {
        "--user",
        "--collect",
        "--same-dir",
        "--quiet",
        "--pipe",
        "-p", "PrivateUsers=true",
        "-p", "ProtectSystem=true",
        "-p", "PrivateNetwork=true",
        "-p", string.format("BindReadOnlyPaths='%s':'%s'", cwd, cwd),
        "-E", "PATH=" .. (vim.env.PATH or os.getenv("PATH") or ""),
        cmd,
      }
      linter.cmd = "systemd-run"
      vim.list_extend(args, linter.args or {})
      linter.args = args
      return linter
    end

    local function run_linter()
      -- Skip huge buffers; running eslint over a multi-thousand-line file is
      -- wasteful and competes with the LSP.
      if require("nnonne.util.bigfile").is_big(0) then
        return
      end
      -- Nothing to lint (no config / no binary) -> stay quiet.
      if not resolve_eslint() then
        return
      end
      if use_sandbox then
        lint.try_lint(nil, { wrap_linter = systemd_run })
      else
        lint.try_lint()
      end
    end

    -- User command to toggle sandboxing on the fly
    vim.api.nvim_create_user_command("WrapLint", function()
      use_sandbox = not use_sandbox
      vim.notify(
        "Linter Sandboxing (systemd-run): " .. (use_sandbox and "ENABLED" or "DISABLED"),
        vim.log.levels.INFO
      )
      run_linter()
    end, { desc = "Toggle systemd-run sandboxing for nvim-lint" })

    -- Autocommands
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = lint_augroup,
      callback = run_linter,
    })
  end,
}
