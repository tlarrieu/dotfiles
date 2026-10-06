local buffer = require('testbus.buffer')
local state = require('testbus.state')

---@class Finding
---@field lnum integer 0-indexed line to anchor the diagnostic to
---@field message string
---@field severity vim.diagnostic.Severity

---@class ReportsBuilder
---@field source string name displayed as the diagnostics source
---@field reports Reports
local _M = {}
_M.__index = _M

---@param source string
---@return ReportsBuilder
_M.new = function(source) return setmetatable({ source = source, reports = {} }, _M) end

---@param bufnr integer
---@return Report
function _M:report(bufnr)
  self.reports[bufnr] = self.reports[bufnr] or { outcomes = {}, diag = {} }
  return self.reports[bufnr]
end

--- Record the outcome of a test, a line holding several outcomes is marked as mixed
---@param path string
---@param lnum integer
---@param status string
function _M:outcome(path, lnum, status)
  local outcomes = self:report(assert(buffer.find(path, true))).outcomes
  local current = outcomes[lnum]
  outcomes[lnum] = (current == nil or current == status) and status or Outcome.MIXED
end

---@param path string
---@param finding Finding
---@param create boolean whether to add a buffer for this path, otherwise the finding is dropped when there is none
function _M:diagnostic(path, finding, create)
  local bufnr = buffer.find(path, create)
  if not bufnr then return end

  vim.fn.bufload(bufnr) -- the buffer content is needed to compute the column
  table.insert(self:report(bufnr).diag, {
    bufnr = bufnr,
    lnum = finding.lnum,
    col = buffer.indent(bufnr, finding.lnum),
    severity = finding.severity,
    message = finding.message,
    source = self.source,
    namespace = state.namespace(),
  })
end

return _M
