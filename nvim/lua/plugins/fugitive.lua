return {
  'tpope/vim-fugitive',
  cmd = { 'Git', 'Gvdiff', 'GV' },
  keys = {
    { '<leader>ga', ':Git commit --quiet --amend --no-edit<cr>' },
    { '<leader>gA', ':Git commit --quiet --amend<cr>' },
    { '<leader>gc', ':Git commit --quiet<cr>' },
    { '<leader>d',  ':Gvdiff<cr>' },
    { '<leader>D',  ':Gvdiff master<cr>' },
    { '<leader>ed', ':tab Git diff --staged<cr>' },
    { '<leader>gr', ':Git checkout %<cr>' },
    { '<leader>gs', ':Git<cr>' },
    { '<leader>gS', ':GV<cr>' },
    { '<leader>gp', ':Git push --force-with-lease<cr>' },
    { '<leader>gu', ':Git pull --rebase<cr>' },
    {
      '<leader>gS',
      ":'<,'>GV<cr>",
      mode = 'x'
    },
  },
}
