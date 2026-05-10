local cword = function(cursor)
  if cursor[2] == 0 then return end

  local _cursor = { cursor[1], cursor[2] - 1 }
  vim.api.nvim_win_set_cursor(0, _cursor)
  local word = vim.fn.expand('<cword>')

  vim.api.nvim_win_set_cursor(0, cursor)
  return word
end

local resolve = function(name)
  local ok, ft = pcall(require, 'usr.snippets.' .. vim.bo.ft)
  if ok and ft.snippets[name] then return ft.snippets[name] end

  local common
  ok, common = pcall(require, 'usr.snippets.common')
  if ok then return common.snippets[name] end
end

local inject = function(string)
  return string
      :gsub('$MONTH', os.date('%m'))
      :gsub('$DAY', os.date('%d'))
      :gsub('$PASCALIZE_FNAME', require('helpers').pascalize(vim.api.nvim_buf_get_name(0):match('([^/]+)%.%w+$')) or '')
end

local expand = function()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local curword = cword(cursor)
  local snippet = resolve(curword)
  if not snippet then return end

  local curline = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  if curline == '' then return end

  local start, finish = curline:find(curword, cursor[2] + 1 - #curword, true)
  if not start then return end

  vim.api.nvim_buf_set_text(0, cursor[1] - 1, start - 1, cursor[1] - 1, finish, { '' })
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
