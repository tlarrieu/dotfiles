vim.filetype.add({
  extension = {
    rasi = 'rasi',
    jbuilder = 'ruby',
    mdx = 'markdown',
    zathurarc = 'zathurarc',
    edi = 'edifact',
    mjml = 'eruby',
    tex = 'tex',
    gabc = 'gabc',
    vifm = 'vim',
    txt = function(_, bufnr, _)
      local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
      if content:match('^UNA.... \'') then return 'edifact' end
      return 'text'
    end,
  },
  filename = {
    ['~/.neorg/gtd/todo.txt'] = 'todotxt',
    ['.pryrc'] = 'ruby',
    ['.pryrc.local'] = 'ruby',
    ['.irbrc.local'] = 'ruby',
    vifmrc = 'vim',
  },
  pattern = {
    ['config/kitty/.*'] = { 'kitty', { priority = -math.huge } }
  },
})

-- mjml <-> eruby
vim.treesitter.language.register('embedded_template', 'mjml')
