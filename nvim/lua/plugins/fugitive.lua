return {
  'tpope/vim-fugitive',
  cmd = { 'Git', 'Gvdiff', 'GV' },
  keys = {
    { '<leader>ga', ':Git commit --quiet --amend --no-edit<cr>', desc = 'Git commit --amend --no-edit' },
    { '<leader>gA', ':Git commit --quiet --amend<cr>',           desc = 'Git commit --amend' },
    { '<leader>gc', ':Git commit --quiet<cr>',                   desc = 'Git commit' },
    { '<leader>gd', ':Gvdiff<cr>',                               desc = 'Git diff' },
    { '<leader>gD', ':Gvdiff master<cr>',                        desc = 'Git diff master..' },
    { '<leader>ed', ':tab Git diff --staged<cr>',                desc = 'Git diff --staged' },
    { '<leader>gr', ':Git checkout %<cr>',                       desc = 'Git checkout %' },
    { '<leader>gs', ':Git<cr>',                                  desc = 'Git' },
    { '<leader>gS', ':GV<cr>',                                   desc = 'GV' },
    { '<leader>gp', ':Git push --force-with-lease<cr>',          desc = 'Git push --force-with-lease' },
    { '<leader>gu', ':Git pull --rebase<cr>',                    desc = 'Git pull --rebase' },
    {
      '<leader>gS',
      ":'<,'>GV<cr>",
      mode = 'x',
      desc = 'GV (visual mode)'
    },
  },
}
