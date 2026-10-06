-- Size-aware "performance mode" for large buffers.
--
-- Big files make several per-buffer features expensive (treesitter parsing,
-- semantic tokens, document highlight, indent scope, hipatterns). Instead of
-- fighting one file, we degrade only the extras and keep the things you use:
--   * LSP itself  -> completion, hover, goto, rename, diagnostics are KEPT
--   * treesitter  -> kept for "big", skipped only for "huge"
local M = {}

local SOFT_BYTES = 300 * 1024 -- ~300 KiB
local SOFT_LINES = 5000
local HARD_BYTES = 1024 * 1024 -- ~1 MiB
local HARD_LINES = 20000

local augroup = vim.api.nvim_create_augroup("BigFilePerf", { clear = true })

local function byte_size(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return 0
  end
  local stat = (vim.uv or vim.loop).fs_stat(name)
  return stat and stat.size or 0
end

---@param buf integer
---@return integer level 0 = normal, 1 = big, 2 = huge
function M.level(buf)
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  local cached = vim.b[buf].bigfile_level
  if cached ~= nil then
    return cached
  end

  local bytes = byte_size(buf)
  local lines = vim.api.nvim_buf_line_count(buf)

  local level = 0
  if bytes > HARD_BYTES or lines > HARD_LINES then
    level = 2
  elseif bytes > SOFT_BYTES or lines > SOFT_LINES then
    level = 1
  end

  vim.b[buf].bigfile_level = level
  return level
end

function M.is_big(buf)
  return M.level(buf) >= 1
end

function M.is_huge(buf)
  return M.level(buf) >= 2
end

local function apply(buf)
  local level = M.level(buf)
  if level == 0 then
    return
  end

  -- Cheap per-buffer opt-outs
  vim.b[buf].miniindentscope_disable = true
  vim.b[buf].minihipatterns_disable = true

  if level >= 2 then
    pcall(vim.treesitter.stop, buf)
  end

  -- Semantic tokens are enabled automatically on attach; turn them off for
  -- big buffers (treesitter + LSP highlights already cover the useful cases).
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    vim.lsp.semantic_tokens.enable(false, { bufnr = buf, client_id = client.id })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function(ev)
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          apply(ev.buf)
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
      if not M.is_big(ev.buf) then
        return
      end
      vim.lsp.semantic_tokens.enable(false, { bufnr = ev.buf, client_id = ev.data.client_id })
    end,
  })
end

return M
