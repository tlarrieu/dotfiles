return {
  'tpope/vim-fugitive',
  dependencies = {
    'junegunn/gv.vim',
    'tpope/vim-rhubarb',
  },
  cmd = { 'Git', 'Gvdiff', 'GV', 'Gcd' },
  keys = {
    { '<leader>l', '<cmd>below Git<cr>', desc = 'Git' },
    { '<leader>L', '<cmd>GV<cr>', desc = 'GV' },
    { '<leader>L', ":'<,'>GV<cr>", mode = 'x', desc = 'GV (visual mode)' },

    { '<leader>gW', '<cmd>Git add .<cr>', desc = 'Git add .' },
    { '<leader>ga', '<cmd>Git commit --quiet --amend --no-edit<cr>', desc = 'Git commit --amend --no-edit' },
    { '<leader>gA', '<cmd>Git commit --quiet --amend<cr>', desc = 'Git commit --amend' },
    { '<leader>gc', '<cmd>Git commit --quiet<cr>', desc = 'Git commit' },
    { '<leader>gd', '<cmd>leftabove Gvdiff<cr>', desc = 'Git diff' },
    { '<leader>gD', '<cmd>leftabove Gvdiff master<cr>', desc = 'Git diff master..' },
    { '<leader>ed', '<cmd>tab Git diff --staged<cr>', desc = 'Git diff --staged' },
    { '<leader>gr', '<cmd>Git checkout %<cr>', desc = 'Git checkout %' },
    { '<leader>gp', '<cmd>Git push --force-with-lease<cr>', desc = 'Git push --force-with-lease' },
    { '<leader>gu', '<cmd>Git pull --rebase<cr>', desc = 'Git pull --rebase' },
    { '<leader>gs', '<cmd>echo "stash"<bar>silent Git stash<cr>', desc = 'Git stash' },
    { '<leader>gS', '<cmd>echo "unstash"<bar>silent Git stash pop<cr>', desc = 'Git stash pop' },
    { '<leader>gy', ':GBrowse!<cr>', mode = { 'v', 'n' }, desc = 'Git(Hub) yank file URL' },

    { '<leader>cc', '<cmd>Gcd<cr>', desc = 'Git CWD' },
  },
}
