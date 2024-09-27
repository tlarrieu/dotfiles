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
        "",
        "",
        [[  ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣭⣿⣶⣿⣦⣼⣆        ]],
        [[   ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤ ⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦      ]],
        [[     ⠈   ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄    ]],
        [[          ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀ ⠢⣀⡀⠈⠙⠿    ]],
        [[  ⢀      ⢠⣿⣿⣿⠈  ⠡⠌⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀  ]],
        [[  ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿  ]],
        [[ ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾   ]],
        [[⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄ ]],
        [[⠙⠃   ⣼⣿⡟⠌ ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿⠐⣿⣿⡇ ⠛⠻⢷⣄]],
        [[     ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆   ⠁]],
        [[      ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃    ]],
        "",
        "",
        "",
      },
      center = {
        { icon = '󰏗 ', desc = 'Lazy                 ', key = 'l', key_format = ' %s', action = 'Lazy', },
        { icon = ' ', desc = 'Mason', key = 'm', key_format = ' %s', action = 'Mason', },
        {
          icon = ' ',
          desc = 'Files',
          key = 't',
          key_format = ' %s',
          action = function()
            return require('telescope.builtin').find_files({ hidden = true, path_display = { 'filename_first' } })
          end,
        },
        {
          icon = ' ',
          desc = 'Live grep',
          key = 'é',
          key_format = '  %s',
          action = function()
            return require('telescope.builtin').live_grep({ additional_args = { '--hidden' } })
          end,
        },
        {
          icon = ' ',
          desc = 'Git files',
          key = 'x',
          key_format = ' %s',
          action = function()
            return require('telescope.builtin').git_status({ hidden = true, path_display = { 'filename_first' } })
          end,
        },
        {
          icon = ' ',
          desc = 'Git log',
          key = 's',
          key_format = ' %s',
          action = 'GV',
        },
        { icon = '⏻ ', desc = 'Quit', key = 'q', key_format = ' %s', action = 'quit', },
      },
    },
  },
}
