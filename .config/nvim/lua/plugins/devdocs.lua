return {
  "maskudo/devdocs.nvim",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
  },
  cmd = { "DevDocs" },
  keys = {
    {
      "<leader>ho",
      mode = "n",
      "<cmd>DevDocs get<cr>",
      desc = "Get Devdocs",
    },
    {
      "<leader>hi",
      mode = "n",
      "<cmd>DevDocs install<cr>",
      desc = "Install Devdocs",
    },
    {
      "<leader>hv",
      mode = "n",
      function()
        local devdocs = require("devdocs")
        local installedDocs = devdocs.GetInstalledDocs()
        vim.ui.select(installedDocs, {}, function(selected)
          if not selected then
            return
          end
          local docDir = devdocs.GetDocDir(selected)
          -- prettify the filename as you wish
          Snacks.picker.files({ cwd = docDir })
        end)
      end,
      desc = "Get Devdocs",
    },
    {
      "<leader>hd",
      mode = "n",
      "<cmd>DevDocs delete<cr>",
      desc = "Delete Devdoc",
    },
  },
  opts = {
    ensure_installed = {
      "async",
      "axios",
      "babel~7",
      "css",
      "eslint",
      "express",
      "express~4",
      "git",
      "go",
      "html",
      "javascript",
      "matplotlib",
      "mongoose",
      "nextjs",
      "node~24_lts",
      "npm",
      "pandas~2",
      "prettier",
      "python~3.12",
      "react",
      "react~18",
      "react_router",
      "scikit_learn",
      "tailwindcss",
      "tailwindcss~3",
      "threejs",
      "typescript",
      "typescript~5.1",
      "redux",
      "redux~3",
      "lua~5.5",
      "bash",
    },
  },
}
