vim.filetype.add({
  extension = {
    rasi = 'rasi',
    jbuilder = 'ruby',
    mdx = 'markdown',
    zathurarc = 'zathurarc',
    edi = 'edifact',
    mjml = 'eruby',
  },
  filename = {
    ['~/.neorg/gtd/todo.txt'] = 'todotxt'
  }
})

-- mjml <-> eruby
vim.treesitter.language.register('embedded_template', 'mjml')
