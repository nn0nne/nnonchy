local M = {}

local pack = require("nnonne.commands.pack")

function M.setup()
  pack.add({ "opencode.nvim" })

  vim.opt.autoread = true

  vim.keymap.set({ "n", "t" }, "<leader>ot", function()
    require("opencode").toggle()
  end, { desc = "Toggle embedded" })
  vim.keymap.set("n", "<leader>oa", function()
    require("opencode").ask("@cursor: ")
  end, { desc = "Ask about this" })
  vim.keymap.set("v", "<leader>oa", function()
    require("opencode").ask("@selection: ")
  end, { desc = "Ask about selection" })
  vim.keymap.set("n", "<leader>o+", function()
    require("opencode").prompt("@buffer", { append = true })
  end, { desc = "Add buffer to prompt" })
  vim.keymap.set("v", "<leader>o+", function()
    require("opencode").prompt("@selection", { append = true })
  end, { desc = "Add selection to prompt" })
  vim.keymap.set("n", "<leader>oe", function()
    require("opencode").prompt("Explain @cursor and its context")
  end, { desc = "Explain this code" })
  vim.keymap.set("n", "<leader>on", function()
    require("opencode").command("session_new")
  end, { desc = "New session" })
  vim.keymap.set({ "n", "v" }, "<leader>os", function()
    require("opencode").select()
  end, { desc = "Select prompt" })
end

return M
