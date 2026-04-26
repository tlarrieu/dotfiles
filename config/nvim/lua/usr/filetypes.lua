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
  },
  filename = {
    ['~/.neorg/gtd/todo.txt'] = 'todotxt',
    ['.pryrc'] = 'ruby',
    ['.pryrc.local'] = 'ruby',
    ['.irbrc.local'] = 'ruby',
    vifmrc = 'vim',
  }
})

-- mjml <-> eruby
vim.treesitter.language.register('embedded_template', 'mjml')
