return {
  'nvimdev/dashboard-nvim',
  commit = '000448d',
  event = 'VimEnter',
  opts = {
    theme = 'hyper',
    hide = { statusline = false, tabline = false },
    config = {
      disable_move = false,
      header = {
        [[ ███╗   ██╗██╗   ██╗██╗███╗   ███╗ ]],
        [[ ████╗  ██║██║   ██║██║████╗ ████║ ]],
        [[ ██╔██╗ ██║██║   ██║██║██╔████╔██║ ]],
        [[ ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[ ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
      },
      shortcut = {},
      project = { enable = false },
      mru = { enable = false },
      footer = {},
    },
  },
}
