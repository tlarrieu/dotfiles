return {
  'tpope/vim-fugitive',
  cmd = { 'Git', 'Gvdiff', 'GV' },
  keys = {
    { '<leader>a',  ':Git commit --quiet --amend --no-edit<cr>' },
    { '<leader>A',  ':Git commit --quiet --amend<cr>' },
    { '<leader>c',  ':Git commit --quiet<cr>' },
    { '<leader>d',  ':Gvdiff<cr>' },
    { '<leader>D',  ':Gvdiff master<cr>' },
    { '<leader>ed', ':tab Git diff --staged<cr>' },
    { '<leader>r',  ':Git checkout %<cr>' },
    { '<leader>s',  ':Git<cr>' },
    { '<leader>S',  ':GV<cr>' },
    { '<leader>gp', ':Git push --force-with-lease<cr>' },
    { '<leader>gu', ':Git pull --rebase<cr>' },
    {
      '<leader>S',
      ":'<,'>GV<cr>",
      mode = 'x'
    },
  },
}
