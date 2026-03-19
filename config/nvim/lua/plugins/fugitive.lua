return {
  'tpope/vim-fugitive',
  dependencies = {
    'junegunn/gv.vim',
    'tpope/vim-rhubarb',
  },
  cmd = { 'Git', 'Gvdiff', 'GV', 'Gcd' },
  keys = {
    { '<leader>gW', '<cmd>Git add .<cr>', desc = 'Git add .' },
    { '<leader>gr', '<cmd>Git checkout %<cr>', desc = 'Git checkout %' },
    { '<leader>gp', '<cmd>Git push --force-with-lease --quiet<cr>', desc = 'Git push --force-with-lease' },
    { '<leader>gu', '<cmd>Git pull --rebase --quiet<cr>', desc = 'Git pull --rebase' },
    { '<leader>gs', '<cmd>Git stash --quiet<cr>', desc = 'Git stash' },
    { '<leader>gS', '<cmd>Git stash pop --quiet<cr>', desc = 'Git stash pop' },
    { '<leader>gy', ':GBrowse!<cr>', mode = { 'v', 'n' }, desc = 'Git(Hub) yank file URL' },

    { '<leader>cc', '<cmd>Gcd<cr>', desc = 'Git CWD' },
  },
}
