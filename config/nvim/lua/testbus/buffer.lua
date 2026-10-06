---@class BufferHelper
---@field find fun(path: string, create: boolean): integer?
---@field indent fun(bufnr: integer, lnum: integer): integer
local _M = {}

---@param path string path relative to the working directory
---@param create boolean whether to add (and list) the buffer when none exists for this path
---@return integer?
_M.find = function(path, create)
  local fullpath = vim.fn.fnamemodify(path, ':p')
  if not create and vim.fn.bufexists(fullpath) == 0 then return nil end
  local bufnr = vim.fn.bufadd(fullpath)
  if create then vim.bo[bufnr].buflisted = true end
  return bufnr
end

---@return integer # column of the first non-blank character of the line (0 when unavailable)
_M.indent = function(bufnr, lnum)
  local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum, lnum + 1, true)
  local _, col = ((ok and lines[1]) or ''):find('^%s*')
  return col or 0
end

return _M
