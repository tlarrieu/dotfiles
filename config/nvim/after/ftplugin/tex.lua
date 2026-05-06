require('utils').autocapitalize({ '*.tex', '*.latex' })

require('runner').setup({
  main = { args = { cmd = { 'just', 'build' }, winbar = '  just build' }, desc = 'Just build' },
  alt = { args = { cmd = { 'just', 'preview' }, winbar = '  just preview' }, desc = 'Just preview' },
})
