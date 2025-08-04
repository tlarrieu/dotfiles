return {
  'milkypostman/vim-togglelist',
  keys = {
    { '<leader>q', '<cmd>call ToggleQuickfixList()<cr>', desc = 'Toggle quickfix list' },
    { '<leader>l', '<cmd>call ToggleLocationList()<cr>', desc = 'Toggle location list' },
  },
}
