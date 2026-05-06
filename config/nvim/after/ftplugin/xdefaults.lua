require('runner').setup({
  main = { args = { cmd = { 'xrdb', vim.fn.expand('~/.Xresources') }, winbar = ' xrdb ~/.Xresources' }, desc = 'xrdb ~/.Xresources' },
})
