local o = vim.opt_local

o.updatetime = 60000
o.foldmethod = 'marker'
o.foldclose = 'all'
o.foldopen = 'insert'

-- Tell the GnuPG plugin to armor new files.
vim.g.GPGPreferArmor = 1
-- Tell the GnuPG plugin to sign new files.
vim.g.GPGPreferSign = 1

local group = vim.api.nvim_create_augroup('GPG_AUTOCMD', {})
vim.api.nvim_create_autocmd('CursorHold', {
  pattern = { '*.gpg', '*.asc', '*.pgp' },
  command = 'quit',
  group = group
})
