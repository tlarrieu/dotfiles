return {
  'tpope/vim-fugitive',
  dependencies = {
    'junegunn/gv.vim',
    'tpope/vim-rhubarb',
  },
  cmd = { 'Git', 'Gvdiff', 'GV', 'Gcd' },
  keys = {
    { '<leader>gr', '<cmd>Git checkout %<cr>', desc = 'Git checkout %' },
    { '<leader>gs', '<cmd>Git stash --quiet<cr>', desc = 'Git stash' },
    { '<leader>gS', '<cmd>Git stash pop --quiet<cr>', desc = 'Git stash pop' },
    { '<leader>gy', ':GBrowse!<cr>', mode = { 'v', 'n' }, desc = 'Git(Hub) yank file URL' },

    { '<leader>cc', '<cmd>Gcd<cr>', desc = 'Git CWD' },
  },
}
