return {
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'AndrewRadev/switch.vim', },
  { 'tlarrieu/vim-sniper' },
  { 'tommcdo/vim-exchange' },
  { 'tpope/vim-eunuch', cmd = { 'Delete', 'Mkdir', 'Move', 'Remove', 'Rename', 'SudoWrite', } },
  { 'tpope/vim-projectionist' },
  { 'tpope/vim-repeat', },
  {
    'tpope/vim-rails',
    config = function()
      vim.treesitter.language.register('yaml', 'eruby.yaml')
    end,
  },
  { 'vifm/vifm.vim', ft = 'vifm' },
  { 'vim-scripts/edifact.vim' },
}
