local glyphs = require('glyphs')
local adapters = require('usr.testbus.adapters')
local state = require('usr.testbus.state')
local config = require('usr.testbus.config')

---- Drawer --------------------------------------------------------------------
---@enum Outcome
Outcome = {
  PASSED = 'passed',
  FAILED = 'failed',
  MIXED = 'mixed',
}
---@class Report
---@field bufnr integer buffer number to update
---@field outcomes table<string, Outcome> list of outcomes, indexed by line number
---@field diag table<vim.Diagnostic> list of diagnostics with errors
---@param report Report the state to be drawn
local draw = function(report)
  for lnum, outcome in pairs(report.outcomes) do
    local _, col = vim.api.nvim_buf_get_lines(report.bufnr, lnum, lnum + 1, true)[1]:find('^%s*')
    local mark = { id = lnum, virt_text_pos = 'inline', virt_text = { assert(config.markers[outcome]), { ' ', 'Normal' } } }
    vim.api.nvim_buf_set_extmark(report.bufnr, state.namespace(), lnum, col, mark)
  end
  vim.diagnostic.set(state.namespace(), report.bufnr, report.diag, config.diagnostics)
end
--------------------------------------------------------------------------------

local handlers = {
  ruby = adapters.rspec
}

local wrap = function(fun) return function() return state.start() and fun() end end
local run = {
  nearest = wrap(vim.cmd.TestNearest),
  file = wrap(vim.cmd.TestFile),
  last = wrap(vim.cmd.TestLast)
}

---- Public interface ----------------------------------------------------------
return {
  run = run,
  lualine = {
    function()
      return state.has_run() and (
        '󰙨 → ' .. (
          (state.error_count() > 0)
          and glyphs.number(state.error_count())
          or (config.status[state.current()] or {}).icon
        )
      ) or ''
    end,
    color = function() return (config.status[state.current()] or {}).color end,
  },
  redraw = function(data)
    local success, result = handlers.ruby(data)
    if success then draw(result) end
  end,
  interrupt = function() if state.is_running() then state.stop() end end
}
--------------------------------------------------------------------------------
