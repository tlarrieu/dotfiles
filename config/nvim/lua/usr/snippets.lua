local vars = {
  ['$MONTH'] = function() return os.date('%m') end,
  ['$DAY'] = function() return os.date('%d') end,
  ['$PASCALIZE_FNAME'] = function()
    return require('helpers').pascalize(vim.api.nvim_buf_get_name(0):match('([^/]+)%.%w+$')) or ''
  end
}

local wordsep = {
  [' '] = true,
  ['.'] = true,
  ['!'] = true,
  ['?'] = true,
  ['('] = true,
  [')'] = true,
  ['{'] = true,
  ['}'] = true,
  ['['] = true,
  [']'] = true,
}

local function prevword(line, column)
  local word, i = '', column

  while i > 0 do
    local char = string.sub(line, i, i)

    if wordsep[char] then break end

    word, i = char .. word, i - 1
  end

  return i + 1, word
end

local file_for = function(ft)
  return vim.fs.joinpath(vim.fn.stdpath('config'), '/lua/usr/snippets/', ft .. '.lua')
end

local import = function(ft)
  local loaded = loadfile(file_for(ft))
  return loaded and loaded() or { snippets = {}, skeletons = {} }
end

local resolve = function(name)
  return import(vim.bo.ft).snippets[name] or import('common').snippets[name]
end

local preprocess = function(string)
  for var, fn in pairs(vars) do string = string:gsub(var, fn()) end

  return string
end

local expand = function()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local curline = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  if curline == '' then return end

  local start, trigger = prevword(curline, cursor[2])

  local snippet = resolve(trigger)
  if not snippet then return end

  vim.api.nvim_buf_set_text(0, cursor[1] - 1, start - 1, cursor[1] - 1, start + #trigger - 1, { '' })

  if type(snippet) == 'table' then
    curline = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
    if curline:match('^%s*$') then
      snippet = snippet.block
    else
      snippet = snippet.inline
    end
  end

  vim.snippet.expand(preprocess(snippet))
end

vim.keymap.set('i', '<c-e>', expand, {})

vim.keymap.set('n', '<leader>eS', function()
  vim.cmd.vsplit(file_for('common'))
end, {})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.keymap.set(
      'n',
      '<leader>es',
      function() if vim.bo.ft ~= '' then vim.cmd.vsplit(file_for(vim.bo.ft)) end end
    )
  end,
})

vim.api.nvim_create_autocmd('BufNewFile', {
  callback = function(ev)
    local ft = vim.bo[ev.buf].ft

    local skeletons = import(ft).skeletons

    local skelname = (vim.fn['projectionist#query']('skeleton')[1] or {})[2]

    if skelname and not skeletons[skelname] then
      return vim.notify(
        'Skeleton "' .. skelname .. '" not found for filetype "' .. ft .. '"',
        vim.log.levels.WARN,
        { title = "skeleton.lua" }
      )
    end

    pcall(vim.snippet.expand, skeletons[skelname or "base"])
  end,
  group = vim.api.nvim_create_augroup("skeletons_hooks", {})
})
