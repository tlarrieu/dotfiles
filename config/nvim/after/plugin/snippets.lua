local filename = function() return vim.fn.expand('%:t:r') end
local dirname = function() return vim.fn.expand('%:h:t') end

local vars = {
  ['$MONTH'] = function() return os.date('%m') end,
  ['$DAY'] = function() return os.date('%d') end,
  ['$TIME'] = function() return os.date('%H:%M') end,
  ['$RB_CLASS_NAME'] = function() return require('helpers').pascalize(filename()) or '' end,
  ['$RB_SPEC_NAME'] = function() return require('helpers').pascalize(filename():gsub('_spec', '')) or '' end,
  ['$RB_MODULE_NAME'] = function() return require('helpers').pascalize(dirname()) or '' end,
  ['$GO_MODULE_NAME'] = dirname,
}

local wordsep = {
  ['\t'] = true,
  [' ']  = true,
  ['.']  = true,
  ['!']  = true,
  ['?']  = true,
  ['(']  = true,
  [')']  = true,
  ['{']  = true,
  ['}']  = true,
  ['[']  = true,
  [']']  = true,
  ["'"]  = true,
  ['"']  = true,
}

local function find_trigger(line, column)
  local start, trigger = column, ''

  while start > 0 do
    local char = string.sub(line, start, start)

    if wordsep[char] then break end

    start, trigger = start - 1, char .. trigger
  end

  return start + 1, trigger
end

local file_for = function(ft)
  return vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'snippets', ft .. '.lua')
end

local import = function(ft)
  local loaded = loadfile(file_for(ft))
  return loaded and loaded() or { snippets = {}, skeletons = {} }
end

local expand = function(string)
  for var, fn in pairs(vars) do string = string:gsub(var, fn()) end

  vim.snippet.expand(string)
end

local find_and_expand = function()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local curline = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  if curline == '' then return end

  local start, trigger = find_trigger(curline, cursor[2])

  local snippet = import(vim.bo.ft).snippets[trigger] or import('common').snippets[trigger]
  if not snippet then return end

  vim.api.nvim_buf_set_text(0, cursor[1] - 1, start - 1, cursor[1] - 1, start + #trigger - 1, { '' })

  if type(snippet) == 'table' then
    curline = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
    snippet = snippet[curline:match('^%s*$') and 'block' or 'inline']
  end

  expand(snippet)
end

local edit = function(ft) return function() vim.cmd.vsplit(file_for(ft == '' and 'common' or ft)) end end
vim.keymap.set('i', '<c-e>', find_and_expand, { desc = 'Expand snippet' })
vim.keymap.set('n', '<leader>eS', edit('common'), { desc = 'Edit common snippets' })
vim.keymap.set('n', '<leader>es', function() edit(vim.bo.ft)() end, { desc = 'Edit ft snippets' })

vim.api.nvim_create_autocmd('BufNewFile', {
  callback = function(ev)
    local path = vim.api.nvim_buf_get_name(ev.buf)
    for _, cfg in ipairs(import(vim.bo[ev.buf].ft).skeletons) do
      if path:match(cfg.pattern) then return expand(cfg.template) end
    end
  end,
})
