return {
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'tommcdo/vim-exchange' },
  { 'tpope/vim-eunuch', cmd = { 'Delete', 'Mkdir', 'Move', 'Remove', 'Rename', 'SudoWrite', } },
  { 'tpope/vim-projectionist' },
  { 'tpope/vim-repeat', },
  { 'vim-scripts/edifact.vim' },
  {
    'tpope/vim-surround',
    init = function()
      vim.g.surround_no_insert_mappings = 1
      vim.keymap.set({ 'n', 'o' }, 'S', 'ys', { remap = true, silent = true })
      vim.keymap.set({ 'x' }, 'S', '<Plug>VSurround', { remap = true, silent = true })
    end
  },
}
