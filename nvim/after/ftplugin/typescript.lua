local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.formatprg = 'prettier'

require('utils').autoformat({ '*.ts', '*.tsx' })
