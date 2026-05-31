vim.filetype.add({
  extension = {
    rasi = 'rasi',
    jbuilder = 'ruby',
    rbs = 'ruby',
    mdx = 'markdown',
    zathurarc = 'zathurarc',
    edi = 'edifact',
    mjml = 'eruby',
    tex = 'tex',
    gabc = 'gabc',
    vifm = 'vim',
    tsx = 'typescript',
    tmpl = 'gotmpl',
    txt = function(_, bufnr, _)
      local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
      if content:match('^UNA.... \'') then return 'edifact' end
      return 'text'
    end,
  },
  filename = {
    ['~/.neorg/gtd/todo.txt'] = 'todotxt',
    ['.pryrc'] = 'ruby',
    ['.ruby.local'] = 'ruby',
    vifmrc = 'vim',
  },
  pattern = {
    ['config/kitty/.*'] = { 'kitty', { priority = -math.huge } },
    ['config/neomutt/.*'] = { 'neomuttrc', { priority = -math.huge } },
  },
})

-- mjml <-> eruby
vim.treesitter.language.register('embedded_template', 'mjml')

-- Auto capitalization
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'markdown', 'gitcommit' },
  callback = function(ev)
    vim.api.nvim_create_autocmd('InsertCharPre', {
      buffer = ev.buf,
      callback = function()
        if vim.fn.search("\\v(%^|[.!?]\\_s|\\n\\n)\\_s*%#", 'bcnw') ~= 0 then
          vim.cmd([[let v:char = toupper(v:char)]])
        end
      end,
    })
  end,
})
