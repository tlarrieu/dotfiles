return {
  'tpope/vim-fugitive',
  dependencies = {
    'junegunn/gv.vim',
    'tpope/vim-rhubarb',
  },
  cmd = { 'Git', 'GBrowse', 'Gcd' },
  keys = {
    { '<leader>gy', ':GBrowse!<cr>', mode = { 'v', 'n' }, desc = 'Git(Hub) yank URL' },
    { '<leader>cc', '<cmd>Gcd<cr>', desc = 'Git CWD' },
  },
}
