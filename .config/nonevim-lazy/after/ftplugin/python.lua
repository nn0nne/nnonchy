-- Global options use 2-space indent (see config/options.lua); Python needs 4,
-- and pasted-in LeetCode/Codewars stubs break when the buffer indents by 2.
local set = vim.opt_local

set.expandtab = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4

-- ruff's default line length (formatter + linter), so the marker matches what
-- conform/ruff will actually produce.
set.colorcolumn = "88"
