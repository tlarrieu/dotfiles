local format = ' %s'
local pad = function(str) return string.format('%-18s', str) end

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  opts = {
    theme = 'doom',
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
        [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
        [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
        [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
        [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        "",
        "",
        "",
      },
      center = {
        {
          icon = '󰏗 ',
          desc = pad('Lazy'),
          key = 'l',
          key_format = format,
          action = 'Lazy'
        },
        {
          icon = ' ',
          desc = pad('Mason'),
          key = 'm',
          key_format = format,
          action = 'Mason'
        },
        {
          icon = ' ',
          desc = pad('Files'),
          key = 't',
          key_format = format,
          action = function()
            return require('telescope.builtin').find_files({ hidden = true, path_display = { 'filename_first' } })
          end,
        },
        {
          icon = ' ',
          desc = pad('Live grep'),
          key = 'é',
          key_format = ' ' .. format,
          action = function()
            return require('telescope.builtin').live_grep({ additional_args = { '--hidden' } })
          end,
        },
        {
          icon = ' ',
          desc = pad('Git files'),
          key = 'y',
          key_format = format,
          action = function()
            return require('telescope.builtin').git_status({ hidden = true, path_display = { 'filename_first' } })
          end,
        },
        {
          icon = ' ',
          desc = pad('Git log'),
          key = 's',
          key_format = format,
          action = 'GV',
        },
        {
          icon = '⏻ ',
          desc = pad('Quit'),
          key = 'q',
          key_format = format,
          action = 'quit'
        },
      },
    },
  },
}
