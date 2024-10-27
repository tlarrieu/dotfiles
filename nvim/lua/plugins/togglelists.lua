return {
  'milkypostman/vim-togglelist',
  keys = {
    { '<leader>q', ':call ToggleQuickfixList()<cr>', desc = 'Toggle quickfix list' },
    { '<leader>l', ':call ToggleLocationList()<cr>', desc = 'Toggle location list' },
  },
}
