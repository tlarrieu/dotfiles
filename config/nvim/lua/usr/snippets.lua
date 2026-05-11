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

local resolve = function(name)
  local ok, ft = pcall(require, 'usr.snippets.' .. vim.bo.ft)
  if ok and ft.snippets[name] then return ft.snippets[name] end

  local common
  ok, common = pcall(require, 'usr.snippets.common')
  if ok then return common.snippets[name] end
end

local inject = function(string)
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

  vim.snippet.expand(inject(snippet))
end

vim.keymap.set('i', '<c-e>', expand, {})

vim.keymap.set('n', '<leader>eS', function()
  vim.cmd.vsplit(vim.fn.expand('~/.config/nvim/lua/usr/snippets/common.lua'))
end, {})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.keymap.set('n', '<leader>es', function()
      if vim.bo.ft == '' then return end

      vim.cmd.vsplit(vim.fn.expand('~/.config/nvim/lua/usr/snippets/' .. vim.bo.ft .. '.lua'))
    end, {})
  end,
})

vim.api.nvim_create_autocmd('BufNewFile', {
  callback = function(ev)
    local ft = vim.bo[ev.buf].ft

    local ok, skeletons = pcall(require, 'usr.snippets.' .. ft)
    if not ok then return end

    skeletons = (skeletons or {}).skeletons or {}

    -- query projectionist
    local skeleton = (vim.fn['projectionist#query']('skeleton')[1] or {})[2]

    if skeleton and not skeletons[skeleton] then
      vim.notify(
        'Skeleton "' .. skeleton .. '" not found for filetype "' .. ft .. '"',
        vim.log.levels.WARN,
        { title = "skeleton.lua" }
      )
      return
    end

    skeleton = skeleton or "base"

    if not skeletons[skeleton] then return false end

    vim.snippet.expand(skeletons[skeleton])
  end,
  group = vim.api.nvim_create_augroup("skeletons_hooks", {})
})
