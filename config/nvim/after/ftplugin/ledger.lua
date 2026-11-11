vim.opt_local.commentstring = '; %s'
vim.opt_local.iskeyword:append({ ':', '/', '.' })

vim.b.to_treesitter_options = true

local runner = require('runner')

local ft = function(cmd)
  return {
    cmd = { 'fish', '-c', ('ft %s'):format(cmd) },
    winbar = ('󰗑 ft %s'):format(cmd),
    show = true,
  }
end

runner.setup({
  main = { args = ft('now'), desc = 'ft now' },
  alt = { args = ft('up'), desc = 'ft up' },
})

-- gD opens the diagnostic under the cursor, as it does in buffers with an LSP
vim.keymap.set('n', 'gD', vim.diagnostic.open_float, { buffer = 0 })

-- After each save, hledger checks the whole journal in the background. Its errors show as
-- diagnostics on the lines hledger names; a valid journal clears them. A save that comes
-- before the check ends cancels that check.
local main_journal = vim.env.LEDGER_FILE or vim.fn.expand('~/.hledger.journal')
local ns = vim.api.nvim_create_namespace('hledger-check')
local shown = {} -- buffers that have check diagnostics
local check
local check_run = 0

local function real(path) return vim.uv.fs_realpath(path) or path end

-- The loaded buffer for a file path, if any.
local function buffer_for(path)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and real(vim.api.nvim_buf_get_name(buf)) == path then return buf end
  end
end

-- The part of hledger's error that explains it: without the header, the file locations and
-- the code excerpt, which the diagnostic's position already shows. The first line is the
-- fallback when nothing else is left.
local function relevant(stderr)
  local kept = {}
  for line in stderr:gmatch('[^\n]+') do
    local l = vim.trim(line)
    local noise = l == ''
        or l:match('^hledger: Error')
        or l:match('in file included from')
        or l:match('[^%s]+:%d+:%d*:?$') -- a location: path:line:col
        or l:match('^%s*%d*%s*|')       -- the code excerpt: "  |", "3245 | text"
        or l:match('^%^+$')
    if not noise then table.insert(kept, l) end
  end
  if #kept > 0 then return table.concat(kept, '\n') end
  return vim.trim(stderr:match('[^\n]+') or '')
end

-- Replaces the check diagnostics with the result: none for a valid journal, otherwise one
-- per location hledger names (file:line:col), in the buffers of those files.
local function show(res, saved_buf)
  for buf in pairs(shown) do vim.diagnostic.reset(ns, buf) end
  shown = {}
  if res.code == 0 then return end

  local raw = res.stderr or ''
  local message = relevant(raw)
  local found = {} -- buffer => diagnostics
  local function add(buf, lnum, col)
    local last = vim.api.nvim_buf_line_count(buf) - 1
    found[buf] = found[buf] or {}
    table.insert(found[buf], {
      lnum = math.min(lnum, last),
      col = col,
      end_col = col + 1,
      severity = vim.diagnostic.severity.ERROR,
      source = 'hledger',
      message = message,
    })
  end
  for path, line, col in raw:gmatch('(/[^%s:]+):(%d+)[%-%d]*:(%d*)') do
    local buf = buffer_for(real(path))
    if buf then add(buf, tonumber(line) - 1, math.max((tonumber(col) or 1) - 1, 0)) end
  end
  if next(found) == nil then add(saved_buf, 0, 0) end -- no location: the first line of this buffer

  for buf, list in pairs(found) do
    vim.diagnostic.set(ns, buf, list)
    shown[buf] = true
  end
end

local function check_journal(ctx)
  if check then check:kill(15) end
  check_run = check_run + 1
  local run = check_run
  check = vim.system({ 'hledger', '-f', main_journal, 'check' }, { text = true }, function(res)
    vim.schedule(function()
      if run ~= check_run then return end -- a later save replaced this check
      check = nil
      show(res, ctx.buf)
    end)
  end)
end

-- The ftplugin can run more than once for a buffer: clear the check before adding it.
local group = vim.api.nvim_create_augroup('LedgerCheck', { clear = false })
vim.api.nvim_clear_autocmds({ group = group, buffer = 0 })
vim.api.nvim_create_autocmd('BufWritePost', { group = group, buffer = 0, callback = check_journal })
