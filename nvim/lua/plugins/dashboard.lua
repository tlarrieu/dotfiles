local format = ' %s'
local pad = function(str) return string.format(' %-12s', str) end
local filename_first_and_shorten = {
  'filename_first',
  shorten = { len = 1, exclude = { 1, -3, -2, -1 } }
}

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  opts = {
    theme = 'doom',
    hide = { statusline = false, tabline = false },
    config = {
      disable_move = true,
      header = {
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        [[ ███╗   ██╗██╗   ██╗██╗███╗   ███╗ ]],
        [[ ████╗  ██║██║   ██║██║████╗ ████║ ]],
        [[ ██╔██╗ ██║██║   ██║██║██╔████╔██║ ]],
        [[ ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[ ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        "",
        "",
        "",
      },
      center = {
        {
          icon = ' ',
          desc = pad('Lazy'),
          key = 'l',
          key_format = format,
          action = 'Lazy'
        },
        {
          icon = ' ',
          desc = pad('Mason'),
          key = 'm',
          key_format = format,
          action = 'Mason'
        },
        {
          icon = ' ',
          desc = pad('Quit'),
          key = 'q',
          key_format = format,
          action = 'quit'
        },
      },
    },
  },
}
