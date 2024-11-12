return {
  'nvimdev/dashboard-nvim',
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
